if not vim.filetype then
    return
end

vim.filetype.add({
    extension = {
        lock = "yaml",
        rasi = "rasi",
        json = "jsonc", -- test: always use jsonc for JSON
    },
    filename = {
        [".profile"] = "sh",
        [".psqlrc"] = "conf",
        ["launch.json"] = "jsonc",
        ["bash_aliases"] = "bash",
    },
    pattern = {
        [".*%.theme"] = "conf",
        ["^.env%..*"] = "bash",
        ["*%.docker%-compose*"] = "yaml.docker-compose", -- not working btw
        [".git/hooks/.*"] = "bash", -- test
        ["/tmp/bash%-fc%..*"] = "bash", -- for opening current line in editor, via bash.
    },
})
