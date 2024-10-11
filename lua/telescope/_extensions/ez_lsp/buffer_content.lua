local BufferContent = {
    _lines = {},
    _annotations = {},
    _line_counter = 0,
    _row_width = 0,
    _col1_width = 10,
    _col2_width = 0,
}

BufferContent.__index = BufferContent

---@param row_width integer
---@param column_1_width? integer
---@return ez_lsp.telescope._BufferContent
function BufferContent:new(row_width, column_1_width)
    ---@type ez_lsp.telescope._BufferContent
    local instance = setmetatable({}, BufferContent)
    instance._lines = {}
    instance._annotations = {}
    instance._line_counter = 0
    instance._row_width = row_width
    instance._col1_width = column_1_width or 10
    instance._col2_width = instance._row_width - instance._col1_width
    return instance
end

---@param self ez_lsp.telescope._BufferContent
---@param line string|ez_lsp.telescope._AnnotatedText
function BufferContent:add_line(line)
    self._line_counter = self._line_counter + 1
    if type(line) == "string" then
        table.insert(self._lines, line)
    else
        table.insert(self._lines, line.text)
        for _, partial_annotation in ipairs(line.annotations) do
            ---@type ez_lsp.telescope._Annotation
            local annotation = {
                hl_group = partial_annotation.hl_group,
                line_no = self._line_counter - 1,
                start_col = partial_annotation.start_col,
                end_col = partial_annotation.end_col,
            }

            table.insert(self._annotations, annotation)
        end
    end
end

---@param self ez_lsp.telescope._BufferContent
---@param row ez_lsp.telescope._2ColRow
function BufferContent:add_row(row)
    local col1 = row.col1
    local col2 = row.col2

    ---@type string
    local col1_text_orig

    ---@type string
    local col1_text

    ---@type ez_lsp.telescope._PartialAnnotation[]
    local annotations = {}

    if type(col1) == "table" then
        for _, annotation in ipairs(col1.annotations) do
            if annotation.start_col < self._col1_width then
                if annotation.end_col < self._col1_width then
                    table.insert(annotations, annotation)
                else
                    local updated_annotation = annotation
                    updated_annotation.end_col = self._col1_width - 1
                    table.insert(annotations, updated_annotation)
                end
            end
        end
    end

    if type(col1) == "string" then
        col1_text_orig = col1
    else
        col1_text_orig = col1.text
    end

    if #col1_text_orig >= self._col1_width then
        col1_text = string.sub(col1_text_orig, 1, self._col1_width - 2) .. "… "
    else
        col1_text = col1_text_orig .. string.rep(" ", self._col1_width - #col1_text_orig)
    end

    ---@type string
    local col2_text_orig

    if type(col2) == "string" then
        col2_text_orig = col2
    else
        col2_text_orig = col2.text
    end

    local col2_text = string.sub(col2_text_orig, 1, self._col2_width)

    self:add_line({ text = col1_text .. col2_text, annotations = annotations })

    if #col2_text_orig > self._col2_width then
        self:add_row({
            col1 = "",
            col2 = string.sub(col2_text_orig, self._col2_width + 1),
        })
    end
end

---@param self ez_lsp.telescope._BufferContent
---@param lines (string|ez_lsp.telescope._AnnotatedText)[]
function BufferContent:add_lines(lines)
    for _, line in ipairs(lines) do
        self:add_line(line)
    end
end

---@param self ez_lsp.telescope._BufferContent
---@param bufnr integer
function BufferContent:set_lines_to_buffer(bufnr)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, self._lines)
    for _, annotation in ipairs(self._annotations) do
        vim.api.nvim_buf_add_highlight(
            bufnr,
            -1,
            annotation.hl_group,
            annotation.line_no,
            annotation.start_col,
            annotation.end_col
        )
    end
end
return BufferContent
