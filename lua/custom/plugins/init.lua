-- You can add your own  ins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  -- gruvbox theme
  {'morhetz/gruvbox', name='gruvbox'},
  -- Noctis Theme
  -- config = function() vim.cmd.colorscheme('gruvbox') end
  { 'talha-akram/noctis.nvim', name = 'noctis', config = function() vim.cmd.colorscheme('noctis_lux') end },
  -- Catppuccin theme
  { 'catppuccin/nvim', name = 'catppuccin' },

  -- nvim-tree
  'nvim-tree/nvim-tree.lua',
  'nvim-tree/nvim-web-devicons',
  'dart-lang/dart-vim-plugin',  'thosakwe/vim-flutter',  'natebosch/vim-lsc',  'natebosch/vim-lsc-dart',
  {'akinsho/flutter-tools.nvim', dependencies = {'nvim-lua/plenary.nvim', 'stevearc/dressing.nvim',}, config = true},
  { 'Exafunction/codeium.vim', event = 'BufEnter'},
  'github/copilot.vim'
}
