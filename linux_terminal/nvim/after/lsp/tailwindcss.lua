local lspconfig = require('lspconfig')

return {
  filetypes = { 'html', 'vue', 'templ', 'htmldjango', 'typescriptreact', 'javascriptreact' },
  settings = {
    tailwindCSS = {
      emmetCompletions = true,
    },
  },
  root_dir = lspconfig.util.root_pattern(
    'tailwind.config.js',
    'tailwind.config.ts',
    'package.json'
  ),
}
