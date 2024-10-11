---@fun
---@alias display_function fun(tbl: telescope.Entry): string

---@class telescope.Entry
---@field value table | string
---@field display string | display_function
---@field ordinal string
---@field path? string
---@field lnum? integer

---@class ez_lsp.telescope.ServerInfoEntry: telescope.Entry
---@field value ez_lsp.lsp.ServerInfo

---@class ez_lsp.telescope._Annotation
---@field hl_group string
---@field line_no integer
---@field start_col integer
---@field end_col integer

---@class ez_lsp.telescope._BufferContent
---@field _lines string[]
---@field _annotations ez_lsp.telescope._Annotation[]
---@field _line_counter integer
---@field _row_width integer
---@field _col1_width integer
---@field _col2_width integer
---@field add_line fun(self: ez_lsp.telescope._BufferContent, line: string|ez_lsp.telescope._AnnotatedText)
---@field add_lines fun(self: ez_lsp.telescope._BufferContent, lines: (string|ez_lsp.telescope._AnnotatedText)[])
---@field set_lines_to_buffer fun(self: ez_lsp.telescope._BufferContent, bufnr: integer)
---@field add_row fun(self: ez_lsp.telescope._BufferContent, row: ez_lsp.telescope._2ColRow)

---@class ez_lsp.telescope._PartialAnnotation
---@field hl_group string
---@field start_col integer
---@field end_col integer

---@class ez_lsp.telescope._AnnotatedText
---@field text string
---@field annotations ez_lsp.telescope._PartialAnnotation[]

---@class ez_lsp.telescope._2ColRow
---@field col1 string | ez_lsp.telescope._AnnotatedText
---@field col2 string | ez_lsp.telescope._AnnotatedText
