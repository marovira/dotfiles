---@class P4Command
---@field message string
---@field cmd string[]

---@class P4
---@field commands P4Command[]
local p4 = {}

function p4.new()
    ---@type {[string]: P4Command}
    local cmds = {
        edit = {
            message = "File opened for edit",
            cmd = { "p4", "edit" },
        },
        revert = {
            message = "File reverted",
            cmd = { "p4", "revert", "-a" },
        },
    }

    return setmetatable({ commands = cmds }, { __index = p4 })
end

---@param obj vim.SystemCompleted
---@param name string
function p4:on_exit(obj, name)
    if obj.code == 0 then
        print(self.commands[name].message)
    else
        print(
            "error: p4 command exited with code "
                .. obj.code
                .. "and message: "
                .. obj.stderr
        )
    end
end

---@param cmd string[]
---@return string[]
function p4:extend_command(cmd)
    local ret = {}
    for i, val in ipairs(cmd) do
        ret[i] = val
    end
    table.insert(ret, vim.fn.expand("%"))
    return ret
end

---@param name string
function p4:callback(name)
    local args = self:extend_command(self.commands[name].cmd)
    vim.system(args, { text = true }, function(obj) self:on_exit(obj, name) end)
end

function p4:edit() self:callback("edit") end

function p4:revert() self:callback("revert") end

return p4
