-- TODO: huggingface/hfcc.nvim
-- TODO: add keybind to toggle copilot
return {
    -- copilot
    {
        -- TODO: add keybinds
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        build = ":Copilot auth",
        opts = {
            suggestion = { enabled = false },
            panel = { enabled = false, auto_refresh = true },
        },
    },

    -- generate text using LLMs with customizable prompts Resources
    {

        "David-Kunz/gen.nvim",
        enabled = false, -- not using it for now
        cmd = "Gen",
        opts = {
            model = "mistral", -- The default model to use.
            display_mode = "float", -- The display mode. Can be "float" or "split".
            show_prompt = true, -- Shows the Prompt submitted to Ollama.
            show_model = true, -- Displays which model you are using at the beginning of your chat session.
            no_auto_close = false, -- Never closes the window automatically.
            init = function(options) pcall(io.popen, "ollama serve > /dev/null 2>&1 &") end,
            -- Function to initialize Ollama
            -- The command for the Ollama service. You can use placeholders $prompt, $model and $body (shellescaped).
            -- This can also be a lua function returning a command string, with options as the input parameter.
            -- The executed command must return a JSON object with { response, context }
            -- (context property is optional).
            -- list_models = '<omitted lua function>', -- Retrieves a list of model names
            debug = false, -- Prints errors and the command which is run.
        },
    },
}
