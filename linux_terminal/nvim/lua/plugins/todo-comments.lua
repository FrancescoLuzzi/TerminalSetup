vim.pack.add({
  {
    src = 'https://github.com/folke/todo-comments.nvim',
    version = 'main',
  },
  {
    src = 'https://github.com/nvim-lua/plenary.nvim',
    version = 'master',
  },
})

local utils = require('utils')
local register_normal = utils.create_keymap_setter('n')
local todo_comments = require('todo-comments')
todo_comments.setup({ signs = false })

register_normal('[t', 'previous todo comment', todo_comments.jump_prev)
register_normal(']t', 'next todo comment', todo_comments.jump_next)
-- todo_comments function is injected by 'todo-comments'
register_normal('<leader>st', 'search todos', snacks.picker.todo_comments())
