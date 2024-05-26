local M = {}

---@param match any
---@param _ any
---@param bufnr number
---@param pred string[]
---@param metadata TSMetadata
local function set_template_literal_lang_from_comment(match, _, bufnr, pred, metadata)
    local comment_node = match[pred[2]]
    if comment_node then
      local success, comment = pcall(vim.treesitter.get_node_text, comment_node, bufnr)
      if success then
        local tag = comment:match'/%*%s*(%w+)%s*%*/'
        if tag then
          local language = tag:lower() == 'svg' and 'html'
                        or vim.filetype.match { filename = 'a.'..tag }
                        or tag:lower()
          metadata['injection.include-children'] = true
          metadata['injection.language'] = language
        end
      end
    end
  end

function M.setup()
  vim.treesitter.query.add_directive(
    'set-template-literal-lang-from-comment!',
    set_template_literal_lang_from_comment,
    {}
  )
end

return M
