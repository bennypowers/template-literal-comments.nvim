local helpers = dofile('tests/helpers.lua')
local child = helpers.new_child()
local expect, eq = MiniTest.expect, MiniTest.expect.equality

local function get_injected_langs()
  child.lua([[
    local parser = vim.treesitter.get_parser(0)
    parser:parse(true)
    _G._test_langs = {}
    for lang, _ in pairs(parser:children()) do
      table.insert(_G._test_langs, lang)
    end
  ]])
  return child.lua_get('_G._test_langs')
end

local T = MiniTest.new_set({
  hooks = {
    pre_case = function()
      child.restart({ '-u', 'scripts/minimal_init.lua' })
    end,
    post_once = child.stop,
  },
})

T['setup'] = MiniTest.new_set()

T['setup']['registers directive'] = function()
  child.lua([[
    _G._test_directives = vim.treesitter.query.list_directives()
  ]])
  local has = child.lua_get('_G._test_directives')
  expect.no_equality(
    vim.tbl_contains(has, 'set-template-literal-lang-from-comment!'),
    false
  )
end

T['injections'] = MiniTest.new_set({
  hooks = {
    pre_case = function()
      child.cmd('edit test/fixture.js')
      child.lua([[
        vim.treesitter.start(0, 'javascript')
        vim.treesitter.get_parser(0):parse(true)
      ]])
    end,
  },
})

T['injections']['detects html injection'] = function()
  local langs = get_injected_langs()
  expect.no_equality(vim.tbl_contains(langs, 'html'), false)
end

T['injections']['detects css injection'] = function()
  local langs = get_injected_langs()
  expect.no_equality(vim.tbl_contains(langs, 'css'), false)
end

T['injections']['maps svg to html'] = function()
  child.lua([[
    vim.api.nvim_buf_set_lines(0, 0, -1, false, {
      'const s = /* svg */`<svg></svg>`;',
    })
    vim.treesitter.get_parser(0):parse(true)
  ]])
  local langs = get_injected_langs()
  expect.no_equality(vim.tbl_contains(langs, 'html'), false)
end

T['injections']['no injection without comment'] = function()
  child.lua([[
    vim.api.nvim_buf_set_lines(0, 0, -1, false, {
      'const s = `<div>no comment</div>`;',
    })
    vim.treesitter.get_parser(0):parse(true)
  ]])
  local langs = get_injected_langs()
  eq(vim.tbl_contains(langs, 'html'), false)
end

return T
