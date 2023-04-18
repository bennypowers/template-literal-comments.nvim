local M = {}

function M.setup()
  ---@param match *
  ---@param _ *
  ---@param bufnr number
  ---@param pred string[]
  ---@param metadata TSMetadata
  vim.treesitter.query.add_directive("set-template-literal-lang-from-comment!", function(match, _, bufnr, pred, metadata)
    local comment_node = match[pred[2]]
    if comment_node then
      local comment = vim.treesitter.get_node_text(comment_node, bufnr)
      local tag = comment:match'/%*%s*(%w+)%s*%*/'
      if tag then
        local language = tag:lower() == 'svg' and 'html'
                      or vim.filetype.match { filename = 'a.'..tag }
                      or tag:lower()
        metadata.language = language
      end
    end
  end)

end

return M
