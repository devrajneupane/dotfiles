return {
    snippet({ trig = "td", name = "TODO" }, {
        d(1, function()
            local function with_cmt(cmt)
                return string.format(vim.bo.commentstring, cmt)
            end
            return snippet("", {
                c(1, {
                    t(with_cmt("TODO: ")),
                    t(with_cmt("FIX: ")),
                    t(with_cmt("NOTE: ")),
                    t(with_cmt("HACK: ")),
                    t(with_cmt("PERF: ")),
                    t(with_cmt("BUG: ")),
                }),
            })
        end),
        i(0),
    }),
}
