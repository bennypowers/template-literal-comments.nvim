local M = {}

---@param match any
---@param _ any
---@param bufnr number
---@param pred string[]
---@param metadata TSMetadata
local function set_template_literal_lang_from_comment(match, _, bufnr, pred, metadata)
    local nodes = match[pred[2]]
    if not nodes then return end
    -- Neovim 0.12+ returns a list of nodes; earlier versions return a single node (userdata)
    if type(nodes) ~= 'table' then
      nodes = { nodes }
    end
    for _, comment_node in ipairs(nodes) do
      if comment_node:type() == 'comment' then
        local success, comment = pcall(vim.treesitter.get_node_text, comment_node, bufnr)
        if success then
          local tag = comment:match'/%*%s*(%w+)%s*%*/'
          if tag then
            local language = tag:lower() == 'svg' and 'html'
                          or vim.filetype.match { filename = 'a.'..tag }
                          or tag:lower()
            metadata['injection.include-children'] = true
            metadata['injection.language'] = language
            return
          end
        end
      end
    end
  end

function M.setup()
  vim.treesitter.query.add_directive(
    'set-template-literal-lang-from-comment!',
    set_template_literal_lang_from_comment,
    { force = true }
  )
end

return M
