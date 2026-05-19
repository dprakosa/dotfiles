vim.opt.termguicolors = true
vim.opt.number = true
-- vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.signcolumn = "yes"
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.winborder = "rounded"
vim.opt.completeopt = { "menuone", "noinsert", "fuzzy", "nosort" }
vim.lsp.inlay_hint.enable(true)

vim.g.mapleader = " "
vim.keymap.set("n", "<leader>e", ":Oil<CR>")
vim.keymap.set("n", "<leader>fi", "<cmd>FzfLua files<CR>")
vim.keymap.set("n", "<leader>fj", "<cmd>FzfLua buffers<CR>")
vim.keymap.set("n", "<leader>fd", "<cmd>FzfLua diagnostics_document<CR>")
vim.keymap.set("n", "<leader>fD", "<cmd>FzfLua diagnostics_workspace<CR>")
vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua live_grep<CR>")
vim.keymap.set("n", "<leader>fh", "<cmd>FzfLua help_tags<CR>")
vim.keymap.set("n", "<leader>fr", "<cmd>FzfLua lsp_references<CR>")
vim.keymap.set("n", "<leader>ca", "<cmd>FzfLua lsp_code_actions<CR>")
vim.keymap.set("n", "<leader>fo", "<cmd>FzfLua oldfiles<CR>")
vim.keymap.set("n", "<leader>fs", "<cmd>FzfLua lsp_document_symbols<CR>")
vim.keymap.set("n", "<leader>fS", "<cmd>FzfLua lsp_workspace_symbols<CR>")
vim.keymap.set("n", "<leader>fm", "<cmd>FzfLua marks<CR>")
vim.keymap.set("n", "<leader>fp", "<cmd>FzfLua resume<CR>")
vim.keymap.set("n", "<leader>gc", "<cmd>FzfLua git_commits<CR>")
vim.keymap.set("n", "<leader>gs", "<cmd>FzfLua git_status<CR>")
vim.keymap.set("n", "<leader>gb", "<cmd>FzfLua git_branches<CR>")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "gd", vim.lsp.buf.definition)

vim.pack.add({
  { src = "https://github.com/rebelot/kanagawa.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
  { src = "https://github.com/nvim-mini/mini.nvim" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/rafamadriz/friendly-snippets" },
  { src = "https://github.com/ibhagwan/fzf-lua" },
  -- { src = "https://github.com/mrcjkb/rustaceanvim" },
  { src = "https://github.com/j-hui/fidget.nvim" },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/OXY2DEV/markview.nvim" },
  { src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },
})

vim.cmd("colorscheme kanagawa-dragon")

-- treesitter

require("nvim-treesitter").setup({
  install_dir = vim.fn.stdpath("data") .. "/site",
})

require("nvim-treesitter").install({
  "lua",
  "vim",
  "vimdoc",
  "markdown",
  "json",
  "yaml",
  "toml",
  "bash",
  "python",
  "dockerfile",
  "c",
  "javascript",
  "typescript",
  "tsx",
  "html",
  "css",
  "scss",
})
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

-- lsp

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls" },
})

-- formatting

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_format" },
    typescriptreact = { "prettierd", "prettier", stop_after_first = true },
  },
  default_format_opts = {
    lsp_format = "fallback",
  },
})

vim.keymap.set("n", "<leader>lf", function()
  require("conform").format({ async = true })
end)

-- diagnostics

vim.diagnostic.config({ virtual_text = false })
require("tiny-inline-diagnostic").setup({
  -- preset = "minimal",
  transparent_bg = true,
  options = {
    show_source = {
      enabled = true,
    },
    multilines = {
      enabled = true,
    },
  },
})

-- setups

require("mini.icons").setup()
MiniIcons.tweak_lsp_kind()
local gen_loader = require("mini.snippets").gen_loader
require("mini.snippets").setup({
  snippets = {
    gen_loader.from_lang(),
  },
})
-- require("mini.pairs").setup()
require("mini.completion").setup({})
require("mini.git").setup()
require("mini.diff").setup({
  view = {
    style = "sign",
  },
})
require("mini.statusline").setup()
require("mini.cmdline").setup({
  autopeek = {
    enable = false,
  },
})

require("oil").setup()
require("fzf-lua").setup({ fzf_colors = true, undotree = { previewer = "undotree_native", locate = false } })
require("fidget").setup()

-- undotree

vim.opt.undofile = true
vim.cmd("packadd nvim.undotree")
vim.keymap.set("n", "<leader>u", function()
  require("undotree").open({
    command = "botright 50vnew",
  })
end)

-- tab completion

local function confirm_tab()
  if vim.fn.pumvisible() == 1 then
    return vim.api.nvim_replace_termcodes("<C-y>", true, false, true)
  else
    return "\t"
  end
end

vim.keymap.set("i", "<Tab>", confirm_tab, { expr = true, silent = true })

-- fix global error

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = { globals = { "vim", "MiniIcons" } },
    },
  },
})
