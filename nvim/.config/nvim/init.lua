vim.opt.termguicolors = true
vim.opt.number = true
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
-- vim.opt.completeopt = { "menuone", "noinsert", "fuzzy", "nosort" }
vim.lsp.inlay_hint.enable(true)
vim.opt.autoread = true

vim.g.mapleader = " "
vim.keymap.set("n", "<leader>e", "<cmd>Oil<cr>")
vim.keymap.set("n", "<leader>fi", "<cmd>FzfLua files<cr>")
vim.keymap.set("n", "<leader>fj", "<cmd>FzfLua buffers<cr>")
vim.keymap.set("n", "<leader>fd", "<cmd>FzfLua diagnostics_document<cr>")
vim.keymap.set("n", "<leader>fD", "<cmd>FzfLua diagnostics_workspace<cr>")
vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua live_grep<cr>")
vim.keymap.set("n", "<leader>fh", "<cmd>FzfLua help_tags<cr>")
vim.keymap.set("n", "<leader>fr", "<cmd>FzfLua lsp_references<cr>")
vim.keymap.set("n", "<leader>ca", "<cmd>FzfLua lsp_code_actions<cr>")
vim.keymap.set("n", "<leader>fo", "<cmd>FzfLua oldfiles<cr>")
vim.keymap.set("n", "<leader>fs", "<cmd>FzfLua lsp_document_symbols<cr>")
vim.keymap.set("n", "<leader>fS", "<cmd>FzfLua lsp_workspace_symbols<cr>")
vim.keymap.set("n", "<leader>fm", "<cmd>FzfLua marks<cr>")
vim.keymap.set("n", "<leader>fp", "<cmd>FzfLua resume<cr>")
vim.keymap.set("n", "<leader>gc", "<cmd>FzfLua git_commits<cr>")
vim.keymap.set("n", "<leader>gs", "<cmd>FzfLua git_status<cr>")
vim.keymap.set("n", "<leader>gb", "<cmd>FzfLua git_branches<cr>")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
vim.keymap.set("n", "grn", vim.lsp.buf.rename)
vim.keymap.set("n", "K", vim.lsp.buf.hover)

vim.pack.add({
	{ src = "https://github.com/rebelot/kanagawa.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "https://github.com/nvim-mini/mini.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
	{ src = "https://github.com/ibhagwan/fzf-lua" },
	-- { src = "https://github.com/elanmed/fzf-lua-frecency.nvim" },
	-- { src = "https://github.com/mrcjkb/rustaceanvim" },
	{ src = "https://github.com/j-hui/fidget.nvim" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/OXY2DEV/markview.nvim" },
	{ src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },
	{ src = "https://github.com/esmuellert/codediff.nvim" },
	{
		src = "https://github.com/Saghen/blink.cmp",
		version = vim.version.range("1.*"),
	},
	{ src = "https://codeberg.org/mfussenegger/nvim-dap" },
	{
		src = "https://github.com/igorlfs/nvim-dap-view",
		version = vim.version.range("1.*"),
	},
	{ src = "https://github.com/windwp/nvim-ts-autotag" },
	{ src = "https://github.com/mistweaverco/kulala.nvim" },
	-- { src = "https://github.com/MunifTanjim/nui.nvim" },
	-- { src = "https://github.com/kndndrj/nvim-dbee" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
})

vim.cmd("colorscheme kanagawa-dragon")

-- treesitter

require("nvim-treesitter").setup({
	install_dir = vim.fn.stdpath("data") .. "/site",
})

require("nvim-treesitter").install({
	"lua",
	"regex",
	"markdown",
	"gitignore",
	"json",
	"yaml",
	"toml",
	"bash",
	"python",
	"dockerfile",
	"c",
	"cpp",

	-- web
	"javascript",
	"typescript",
	"tsx",
	"html",
	"css",
	"scss",
	"embedded_template",

	"solidity",
})
vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

-- lsp

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
		},
	},
})

vim.lsp.config("eslint", {
	settings = {
		format = false,
	},
})

require("mason").setup()

require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"bashls",
		"basedpyright",
		"clangd",

		-- web
		"vtsls",
		"eslint",
		"html",
		"cssls",
		"jsonls",
		"tailwindcss",

		-- config
		"yamlls",
		"dockerls",
		"marksman",
	},
})

-- formatting

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		sh = { "shfmt" },
		python = { "ruff_format" },
		typescript = { "prettier" },
		typescriptreact = { "prettier" },
		javascript = { "prettier" },
		javascriptreact = { "prettier" },
		html = { "prettier" },
		css = { "prettier" },
		scss = { "prettier" },
		json = { "prettier" },
		yaml = { "prettier" },
		markdown = { "prettier" },
	},
	default_format_opts = {
		lsp_format = "fallback",
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})

require("mason-tool-installer").setup({
	ensure_installed = {
		"stylua",
		"ruff",
		"shfmt",
		"prettier",
	},
})

vim.keymap.set("n", "<leader>lf", function()
	require("conform").format({ async = true })
end)

-- diagnostics

vim.diagnostic.config({
	virtual_text = false,
	underline = true,
	severity_sort = true,
	update_in_insert = false,
})

require("tiny-inline-diagnostic").setup({
	-- preset = "minimal",
	transparent_bg = true,
	options = {
		show_source = {
			-- enabled = true,
			enabled = false,
		},
		multilines = {
			enabled = true,
		},
		overflow = {
			mode = "wrap",
			padding = 0,
		},
	},
})

-- dap

require("dap-view").setup({
	auto_toggle = true,
	virtual_text = {
		enabled = true,
	},
})

local dap = require("dap")
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint)
vim.keymap.set("n", "<leader>dc", dap.continue)
vim.keymap.set("n", "<leader>dn", dap.step_over)
vim.keymap.set("n", "<leader>di", dap.step_into)
vim.keymap.set("n", "<leader>do", dap.step_out)
vim.keymap.set("n", "<leader>dx", dap.terminate)
vim.keymap.set("n", "<leader>dt", "<cmd>DapViewToggle<cr>")

-- completions

require("blink.cmp").setup({
	keymap = {
		preset = "super-tab",
	},
	appearance = {
		nerd_font_variant = "mono",
	},
	completion = {
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200,
		},
	},
	signature = {
		enabled = true,
	},
	sources = {
		default = { "lsp", "path", "snippets" },
	},
	cmdline = {
		keymap = {
			preset = "inherit",
		},
		completion = {
			menu = {
				auto_show = true,
			},
		},
	},
})

-- plugins

require("mini.icons").setup()
require("mini.pairs").setup()
require("mini.statusline").setup()
-- require("mini.git").setup()
-- require("mini.diff").setup({
-- 	view = {
-- 		style = "sign",
-- 	},
-- })

require("oil").setup()

require("fzf-lua").setup({
	fzf_colors = true,
	undotree = { previewer = "undotree_native", locate = false },
	ui_select = {},
})

require("fidget").setup({
	notification = {
		override_vim_notify = true,
	},
})

-- git

local gitsigns = require("gitsigns")

gitsigns.setup()

vim.keymap.set("n", "]h", function()
	gitsigns.nav_hunk("next")
end)

vim.keymap.set("n", "[h", function()
	gitsigns.nav_hunk("prev")
end)

vim.keymap.set("n", "<leader>gp", gitsigns.preview_hunk)

-- webdev

require("kulala").setup({
	global_keymaps = false,
})
vim.keymap.set("n", "<leader>rs", function()
	require("kulala").run()
end)
vim.keymap.set("n", "<leader>ra", function()
	require("kulala").run_all()
end)

require("nvim-ts-autotag").setup()

-- undotree

vim.opt.undofile = true
vim.cmd("packadd nvim.undotree")
vim.keymap.set("n", "<leader>u", function()
	require("undotree").open({
		command = "botright 50vnew",
	})
end)

-- terminal

local term = {
	buf = nil,
	win = nil,
}

local function open_float_term()
	local width = math.floor(vim.o.columns * 0.7)
	local height = math.floor(vim.o.lines * 0.7)

	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	if not term.buf or not vim.api.nvim_buf_is_valid(term.buf) then
		term.buf = vim.api.nvim_create_buf(false, true)
	end

	term.win = vim.api.nvim_open_win(term.buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		border = "rounded",
		style = "minimal",
	})

	if vim.bo[term.buf].buftype ~= "terminal" then
		vim.cmd("terminal")
	end

	vim.cmd("startinsert")
end

local function toggle_float_term()
	if term.win and vim.api.nvim_win_is_valid(term.win) then
		vim.cmd("stopinsert")
		vim.api.nvim_win_hide(term.win)
		return
	end

	open_float_term()
end

vim.keymap.set({ "n", "t" }, "<A-t>", toggle_float_term)

-- vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], {
--     desc = "Exit terminal mode",
-- })
