; extends
(list_item [
  (list_marker_plus)
  (list_marker_minus)
  (list_marker_star)
  (list_marker_dot)
  (list_marker_parenthesis)
] @conceal [
    (task_list_marker_checked)
    (task_list_marker_unchecked)
](#set! conceal ""))

; Checkbox list items
; ((task_list_marker_checked) @conceal (#set! conceal ""))
; ((task_list_marker_unchecked) @conceal (#set! conceal ""))

; Use box drawing characters for tables
; (pipe_table_header ("|") @punctuation.special @conceal (#set! conceal "┃"))
; (pipe_table_delimiter_row ("|") @punctuation.special @conceal (#set! conceal "┃"))
; (pipe_table_delimiter_cell ("-") @punctuation.special @conceal (#set! conceal "━"))
; (pipe_table_row ("|") @punctuation.special @conceal (#set! conceal "┃"))

; Block quotes
; ((block_quote_marker) @punctuation.special (#offset! @punctuation.special 0 0 0 -1) (#set! conceal "▐"))
; ((block_continuation) @punctuation.special (#eq? @punctuation.special "> ") (#offset! @punctuation.special 0 0 0 -1) (#set! conceal "▐"))
; ((block_continuation) @punctuation.special (#eq? @punctuation.special ">") (#set! conceal "▐"))
; (block_quote
;   (paragraph) @text.literal)
