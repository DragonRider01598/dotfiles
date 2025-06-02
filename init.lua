-- ── Lazy.nvim bootstrap ─────────────────────────────────────────────────────────
local global_lazy_path = "/usr/local/share/nvim/lazy/lazy.nvim"
local local_lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local lazypath = nil

if vim.loop.fs_stat(global_lazy_path) then
  lazypath = global_lazy_path
elseif vim.loop.fs_stat(local_lazy_path) then
  lazypath = local_lazy_path
else
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", local_lazy_path
  })
  lazypath = local_lazy_path
end

vim.opt.rtp:prepend(lazypath)

-- ── Options ──────────────────────────────────────────────────────────────────────
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.ruler = true
vim.opt.cursorline = true
vim.cmd([[highlight CursorLine cterm=bold ctermbg=black]])
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.textwidth = 79
vim.opt.showmatch = true

vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.clipboard = "unnamedplus"

-- ── Keymaps ──────────────────────────────────────────────────────────────────────
vim.keymap.set("n", "<C-n>", ":NERDTreeToggle<CR>", { noremap = true, silent = true })

for _, key in ipairs({ "<Up>", "<Down>", "<Left>", "<Right>" }) do
  vim.keymap.set({ "n", "i", "v" }, key, "<Nop>", { noremap = true, silent = true })
end

-- ── Plugins ──────────────────────────────────────────────────────────────────────
require("lazy").setup({
  { "tomasiser/vim-code-dark", lazy = false, priority = 1000 },

  { "preservim/nerdtree" },
  { "ryanoasis/vim-devicons" },
  { "tpope/vim-fugitive" },
  { "jiangmiao/auto-pairs" },
  { "tpope/vim-commentary" },
  { 'neovim/nvim-lspconfig', lazy = true},

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "codedark",
          section_separators = "",
          component_separators = "",
        },
        sections = {
          lualine_c = { { 'filename', path = 1 }, 'branch' }
        }
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash", "c", "cpp", "python", "lua", "json", "yaml", "toml", "vim",
          "html", "css", "javascript", "typescript", "markdown", "markdown_inline",
          "cmake", "make", "dockerfile"
        },
        highlight = { enable = true },
        indent = { enable = true },
        auto_install = true,
      })
    end,
  },

  { "williamboman/mason.nvim", build = ":MasonUpdate", config = true },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "pyright", "clangd", "cmake", "bashls", "html", "cssls", "ts_ls",
          "jsonls", "yamlls", "dockerls", "lua_ls", "marksman", "tailwindcss"
        },
        automatic_installation = true,
      })

      local lspconfig = require("lspconfig")
      local servers = {
        "pyright", "clangd", "cmake", "bashls", "html", "cssls", "ts_ls",
        "jsonls", "yamlls", "dockerls", "lua_ls", "marksman", "tailwindcss"
      }

      for _, server in ipairs(servers) do
        if server == "lua_ls" then
          lspconfig.lua_ls.setup({
            settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim" },
                },
              },
            },
          })
        else
          lspconfig[server].setup({})
        end
      end
    end,
  },

  {
    "nvimtools/none-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.black,
          null_ls.builtins.diagnostics.flake8,
          null_ls.builtins.formatting.prettier,
        },
      })
    end,
  },

  {
    "jay-babu/mason-null-ls.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "jose-elias-alvarez/null-ls.nvim"
    },
    config = function()
      require("mason-null-ls").setup({
        ensure_installed = { "black", "flake8", "prettier" },
        automatic_installation = true,
      })
    end,
  },
})

vim.cmd.colorscheme("codedark")
