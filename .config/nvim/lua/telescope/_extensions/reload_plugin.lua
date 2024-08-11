local has_telescope, telescope = pcall(require, "telescope")

if not has_telescope then return end

local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local conf = require("telescope.config").values

local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local plugins = vim.tbl_keys(require("lazy.core.config").plugins)

local reload_plugin = function(opts)
    -- opts = vim.tbl_extend("keep", opts or {}, require("telescope.themes").get_dropdown({}))
    opts = opts or require("telescope.themes").get_dropdown({})
    pickers
        .new(opts, {
            prompt_title = "Reload Plugin",
            finder = finders.new_table({
                results = plugins,
            }),
            previewer = false,
            sorter = conf.generic_sorter(opts),
            attach_mappings = function(prompt_bufnr)
                actions.select_default:replace(function()
                    actions.close(prompt_bufnr)
                    local plugin = action_state.get_selected_entry()[1]
                    require("lazy.util").warn("Reloading **" .. plugin .. "**")
                    require("lazy.core.loader").reload(plugin)
                end)
                return true
            end,
        })
        :find()
end

return telescope.register_extension({
    exports = {
        reload_plugin = reload_plugin,
    },
})
