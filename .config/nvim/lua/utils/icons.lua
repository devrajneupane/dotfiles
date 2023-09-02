local M = {}

M.git_colors = {
    GitAdd = "#A1C281",
    GitChange = "#74ADEA",
    GitDelete = "#FE747A",
}
M.dap = {
    Stopped = { " ", "DiagnosticWarn", "DapStoppedLine" }, -- 󰁕
    Breakpoint = " ",
    BreakpointCondition = " ", -- 󰟃
    BreakpointRejected = { " ", "DiagnosticError" },
    LogPoint = ".>",
    Pause = "",
    Play = "",
    RunLast = "↻",
    StepBack = "",
    StepInto = "󰆹",
    StepOut = "󰆸",
    StepOver = "󰆷",
    Terminate = "󰝤",
}
M.diagnostics = {
    Error = " ",
    Warn = " ",
    Hint = " ", -- 󰌵
    Info = " ",
}
M.git = {
    added = " ",
    modified = " ", -- 
    removed = " ",
    ignored = "",
    renamed = "",
    untracked = "",
    unstaged = "󰄱",
    staged = "",
    conflict = "", -- 
    diff = "",
    repo = "",
    logo = "󰊢",
    branch = "", -- 
}
---@see: https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#symbolKind
M.kinds = {
    Array = "󰅪 ",
    Boolean = " ",
    Color = "󰏘 ", -- 
    Constant = "󰏿 ", -- 
    Constructor = " ", -- 
    Class = " ",
    Copilot = "",
    Enum = " ", -- 
    EnumMember = " ",
    Event = "", -- 
    Field = "󰜢 ", --  󰇽 
    File = "󰈙 ",
    Folder = "󰉋 ", -- 
    Function = "󰊕 ",
    Interface = " ", -- 
    Key = "󰌋 ", --  󰌆
    Keyword = " ",
    Method = " ",
    Module = " ", -- 
    Namespace = " ", -- 󰌗
    Null = " ",
    Number = "󰎠 ",
    Object = "󰅩 ",
    Operator = " ", -- 󰆕
    Package = " ",
    Property = "󰜢 ", -- 
    Reference = "󰈇 ", --  
    Snippet = " ", -- 
    String = " ",
    Struct = "󰌗 ", --  󰙅
    Text = "󰉿 ", --  󰭷 
    TypeParameter = " ", -- 󰊄
    Undefined = "",
    Unit = " ", -- 
    Value = " ",
    Variable = "󰀫 ", -- 
}
M.misc = {
    Debug = ""
}

return M
