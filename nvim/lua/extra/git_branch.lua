local branch_cache = ""

---@class GitBranch
local GitBranch = {}

function GitBranch.update_branch()
    if vim.fn.executable("git") ~= 1 then
        branch_cache = ""
        return
    end

    vim.system(
        { "git", "branch", "--show-current" },
        { text = true, stderr = false },
        function(obj)
            if obj.code == 0 and obj.stdout then
                branch_cache = obj.stdout:gsub("%s+", "")
            else
                branch_cache = ""
            end
        end
    )
end

function GitBranch.get_branch()
    if branch_cache == "" then return "" end
    return " " .. branch_cache
end

return GitBranch
