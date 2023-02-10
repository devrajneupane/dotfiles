local borders = { "none", "single", "double", "rounded", "solid", "shadow" }
math.randomseed(os.time())
require('duckytype').setup {
    number_of_words = 10,
    window_config = {
        -- load a random border each time
        border = borders[math.ceil(math.random() * #borders)]
    },
    highlight = {
        good = "Comment",
        bad = "Error",
        remaining = "Todo",
    },
}
