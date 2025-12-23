vim.opt.termguicolors = true
vim.opt.relativenumber = true
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
vim.diagnostic.config({ virtual_text = true })

vim.g.mapleader = " "
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>fi", "<cmd>FzfLua files<CR>")
vim.keymap.set("n", "<leader>fj", "<cmd>FzfLua buffers<CR>")
vim.keymap.set("n", "<leader>fd", "<cmd>FzfLua diagnostics_document<CR>")
vim.keymap.set("n", "<leader>fD", "<cmd>FzfLua diagnostics_workspace<CR>")
vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua live_grep<CR>")
vim.keymap.set("n", "<leader>fh", "<cmd>FzfLua help_tags<CR>")
vim.keymap.set("n", "<leader>fr", "<cmd>FzfLua lsp_references<CR>")
vim.keymap.set("n", "<leader>ca", "<cmd>FzfLua lsp_code_actions<CR>")
vim.keymap.set("n", "<leader>e", ":Oil<CR>")

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
	{ src = "https://github.com/mrcjkb/rustaceanvim" },
	{ src = "https://github.com/j-hui/fidget.nvim" },
	{ src = "https://github.com/stevearc/conform.nvim" },
})

vim.cmd("colorscheme kanagawa-dragon")

-- treesitter

require("nvim-treesitter").setup({
	install_dir = vim.fn.stdpath("data") .. "/site",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "lua", "vim", "vimdoc", "zsh" },
	callback = function()
		vim.treesitter.start()
	end,
})

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls" },
})
require("mini.icons").setup()
MiniIcons.tweak_lsp_kind()
local gen_loader = require("mini.snippets").gen_loader
require("mini.snippets").setup({
	snippets = {
		gen_loader.from_lang(),
	},
})
require("mini.pairs").setup()
require("mini.statusline").setup()
require("mini.completion").setup({})
require("mini.diff").setup()
require("mini.cmdline").setup()
require("oil").setup()
require("fzf-lua").setup({ fzf_colors = true, undotree = { previewer = "undotree_native", locate = false } })
require("fidget").setup()

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
	},
	format_on_save = {
		lsp_format = "fallback",
	},
})

local function confirm_tab()
	if vim.fn.pumvisible() == 1 then
		return vim.api.nvim_replace_termcodes("<C-y>", true, false, true)
	else
		return "\t"
	end
end

vim.keymap.set("i", "<Tab>", confirm_tab, { expr = true, silent = true })

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = { globals = { "vim", "MiniIcons" } },
		},
	},
})

-- vim.g.rustaceanvim = {
-- 	tools = {},
-- 	server = {
-- 		default_settings = {
-- 			["rust-analyzer"] = {},
-- 		},
-- 	},
-- 	dap = {},
-- }
--
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "rust",
-- 	callback = function()
-- 		vim.keymap.set("n", "K", function()
-- 			vim.cmd.RustLsp({ "hover", "actions" })
-- 		end, { buffer = true, silent = true })
-- 	end,
-- })
--
