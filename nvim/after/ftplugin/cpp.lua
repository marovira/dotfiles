package.path = package.path .. ";../../lua;"
local common = require("common")

if common.is_windows() then
    vim.opt_local.makeprg =
        "clang++ -std=c++20 -Wall -Wextra -Werror --pedantic -g -O0 -DDEBUG -o %:r %"
end
