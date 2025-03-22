; extends

; Highlight `inline_code` in comments
; Does not work with space or special characters
("text" @markup.raw.markdown_inline
  (#lua-match? @markup.raw.markdown_inline "`.+`")
  (#set! "priority" 1000))

; MAKE UPPERCASE COMMENTS BOLD
; Requires setting the hlgroup `@comment.bold` with attribute `bold=true`
("text" @comment.bold
  (#lua-match? @comment.bold "^[%u]+$"))
