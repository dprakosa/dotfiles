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
-- vim.opt.fuzzy = true
-- vim.opt.nosort = true
vim.opt.winborder = "rounded"
vim.opt.completeopt = { "menuone", "noinsert" }
vim.g.mapleader = " "

vim.lsp.inlay_hint.enable(true)
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
vim.keymap.set("n", "<leader>fi", "<cmd>FzfLua files<CR>")
vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua live_grep<CR>")
vim.keymap.set("n", "<leader>fh", "<cmd>FzfLua help_tags<CR>")
vim.keymap.set("n", "<leader>fd", "<cmd>FzfLua diagnostics_workspace<CR>")
vim.keymap.set("n", "<leader>e", ":Oil<CR>")
vim.diagnostic.config({ virtual_text = true })

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

require("nvim-treesitter.configs").setup({ auto_install = true, highlight = { enable = true } })
require("mason").setup()
require("mason-lspconfig").setup()
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
require("mini.completion").setup()
require("oil").setup()
require("fzf-lua").setup({ fzf_colors = true })
require("fidget").setup()
require("mini.diff").setup()

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		rust = { "rustfmt" },
	},
	format_on_save = {
		lsp_format = "fallback",
	},
})

vim.g.rustaceanvim = {
	tools = {},
	server = {
		default_settings = {
			["rust-analyzer"] = {},
		},
	},
	dap = {},
}

vim.api.nvim_create_autocmd("FileType", {
	pattern = "rust",
	callback = function()
		vim.keymap.set("n", "K", function()
			vim.cmd.RustLsp({ "hover", "actions" })
		end, { buffer = true, silent = true })
	end,
})

local function confirm_tab()
	if vim.fn.pumvisible() == 1 then
		-- confirm current item
		return vim.api.nvim_replace_termcodes("<C-y>", true, false, true)
	else
		-- no menu: insert a normal tab (will be turned into spaces because of 'expandtab')
		return "\t"
	end
end

vim.keymap.set("i", "<Tab>", confirm_tab, { expr = true, silent = true })
