local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

require("packer").startup(function(use)
	-- Nvim-related plugins
	use("wbthomason/packer.nvim")
	use("nvim-lua/plenary.nvim")
	use("folke/lazy.nvim")
	use("lewis6991/impatient.nvim")

	-- Window-related plugins
	use("akinsho/toggleterm.nvim")
	use("kyazdani42/nvim-tree.lua")
	use("moll/vim-bbye")
	use("ahmedkhalf/project.nvim")
	use("goolord/alpha-nvim")
	use("nvim-telescope/telescope.nvim")
	use("folke/which-key.nvim")
	use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } })

	-- Theme-related plugins
	use("folke/tokyonight.nvim")
	use("nvim-lualine/lualine.nvim")
	use("kyazdani42/nvim-web-devicons")
	use("echasnovski/mini.indentscope")

	-- Formatting-related plugins
	use("windwp/nvim-autopairs")
	use("numToStr/Comment.nvim")
	use({ "JoosepAlviste/nvim-ts-context-commentstring", commit = "88343753dbe81c227a1c1fd2c8d764afb8d36269" })
	use("akinsho/bufferline.nvim")
	use("lukas-reineke/indent-blankline.nvim")
	--[[ use("prettier/vim-prettier") ]]
	--[[ use("w0rp/ale") -- This is what is showing duplicate Errors. ]]
	use("Shougo/context_filetype.vim")

	-- CMP-related plugins
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("saadparwaiz1/cmp_luasnip")
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-nvim-lua")

	-- Snippets-related plugins
	use("L3MON4D3/LuaSnip")
	use("rafamadriz/friendly-snippets")

	-- Highlighting-related plugins
	use("nvim-treesitter/nvim-treesitter")

	-- LSP-related plugins
	use("williamboman/mason.nvim")
	use("williamboman/mason-lspconfig.nvim")
	use("jose-elias-alvarez/null-ls.nvim")
	use("neovim/nvim-lspconfig")
	use("RRethy/vim-illuminate")
	use("jay-babu/mason-null-ls.nvim")
	use("folke/trouble.nvim")

	-- Intellisense-related plugins
	use("lvimuser/lsp-inlayhints.nvim")
	--[[ use("neoclide/coc.nvim") ]]
	--[[ use("codechips/coc-svelte") ]]

	-- Debugger-related plugins
	use("mfussenegger/nvim-dap")

	-- Git-related plugins
	use("kdheepak/lazygit.nvim")
	use("lewis6991/gitsigns.nvim")

	-- Rust-related plugins
	use("rust-lang/rust.vim")
	use("simrat39/rust-tools.nvim")

	-- Svelte-related plugins
	use("burner/vim-svelte")

	-- HTML-related plugins
	--[[ use("othree/html5.vim") ]]

	-- Javascript-related plugins
	use("pangloss/vim-javascript")

	-- Typescript-related plugins
	--[[ use("HerringtonDarkholme/yats.vim") ]]

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
