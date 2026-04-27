-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
---@module 'lazy'
---@type LazySpec
return {
  'github/copilot.vim',

  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      'github/copilot.vim',
      { 'nvim-lua/plenary.nvim', branch = 'master' },
    },
    build = 'make tiktoken',
    branch = 'main',
    cmd = 'CopilotChat',
    opts = function()
      local user = vim.env.USERNAME or vim.env.USER or 'User'
      user = user:sub(1, 1):upper() .. user:sub(2)
      return {
        auto_insert_mode = true,
        question_header = '  ' .. user .. ' ',
        answer_header = '  Copilot ',
        window = {
          width = 0.4,
        },
      }
    end,
    keys = {
      { '<c-s>', '<CR>', ft = 'copilot-chat', desc = 'Submit Prompt', remap = true },
      { '<leader>a', '', desc = '+ai', mode = { 'n', 'v' } },
      {
        '<leader>aa',
        function()
          return require('CopilotChat').toggle()
        end,
        desc = 'Toggle (CopilotChat)',
        mode = { 'n', 'v' },
      },
      {
        '<leader>ax',
        function()
          return require('CopilotChat').reset()
        end,
        desc = 'Clear (CopilotChat)',
        mode = { 'n', 'v' },
      },
      {
        '<leader>aq',
        function()
          vim.ui.input({
            prompt = 'Quick Chat: ',
          }, function(input)
            if input and input ~= '' then
              require('CopilotChat').ask(input)
            end
          end)
        end,
        desc = 'Quick Chat (CopilotChat)',
        mode = { 'n', 'v' },
      },
      {
        '<leader>ap',
        function()
          require('CopilotChat').select_prompt()
        end,
        desc = 'Prompt Actions (CopilotChat)',
        mode = { 'n', 'v' },
      },
    },
    config = function(_, opts)
      local chat = require 'CopilotChat'

      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = 'copilot-chat',
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
        end,
      })

      chat.setup(opts)
    end,
  },

  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      strategies = {
        chat = {
          adapter = 'copilot',
        },
        inline = {
          adapter = 'copilot',
        },
      },
    },
  },

  {
    'ahmedkhalf/project.nvim',
    enabled = false,
    -- project.nvim monkey-patches deprecated LSP APIs on Neovim 0.12 and can
    -- fight rust-analyzer's workspace root detection, so leave it disabled.
  },

  {
    'mfussenegger/nvim-lint',
    config = function()
      local lint = require 'lint'

      vim.env.ESLINT_D_PPID = vim.fn.getpid()

      lint.linters_by_ft = {
        javascript = { 'eslint_d' },
        javascriptreact = { 'eslint_d' },
        typescript = { 'eslint_d' },
        typescriptreact = { 'eslint_d' },
      }

      local lint_augroup = vim.api.nvim_create_augroup('kickstart-lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          if vim.bo.modifiable then lint.try_lint() end
        end,
      })
    end,
  },

  {
    'windwp/nvim-ts-autotag',
    opts = {
      opts = {
        -- Defaults
        enable_close = true, -- Auto close tags
        enable_rename = true, -- Auto rename pairs of tags
        enable_close_on_slash = false, -- Auto close on trailing </
      },
    },
  },

  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {},
  },

  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown', 'copilot-chat', 'codecompanion' },
  },

  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-neotest/neotest-jest',
    },
    config = function(_, opts)
      require('neotest').setup(opts)
    end,
    opts = function()
      return {
        log_level = vim.log.levels.WARN,
        adapters = {
          require 'neotest-jest' {
            jestCommand = 'npm test --',
            jestConfigFile = vim.fn.getcwd() .. '/jest.config.js',
            env = { TEST = true },
            cwd = function()
              return vim.fn.getcwd()
            end,
          },
        },
      }
    end,
  },
}
