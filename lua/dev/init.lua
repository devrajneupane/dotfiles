-- Main setup.

-- These have to be run first and in this order.
require("dev.packer")
require("dev.theme")

-- More setup.
require("dev.neovim")
require("dev.ui")
require("dev.lang")

-- Misc
require("dev.misc")

-- Run this last to ensure they do not get overridden.
require("dev.key-bindings")

local conf_file = vim.fn.stdpath('cache') .. "/dashboard/conf"
local file = assert(io.open(conf_file, "r+"))
local content = file:read("*all")
local data = vim.json.decode(content)
data.config.footer[1] = "Fortune favors Brave"
file:write(vim.json.encode(data))
file:close()
