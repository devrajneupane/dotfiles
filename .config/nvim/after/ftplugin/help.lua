-- TODO: find the label nearest to current cursor and use fragment identifier(#) to navigate to that section

local filename = vim.fn.expand("%:t")
local title = vim.split(filename, ".", { plain = true })[1]
vim.keymap.set(
    "n",
    "o",
    function() vim.ui.open("https://neovim.io/doc/user/" .. title .. ".html") end,
    { buffer = 0, desc = "open current help in neovim docs" }
)
