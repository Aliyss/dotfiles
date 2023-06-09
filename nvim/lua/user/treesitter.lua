local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

configs.setup({
	ensure_installed = { "bash", "lua", "rust", "svelte", "typescript", "javascript", "json", "markdown", "org" }, -- one of "all" or a list of languages
	ignore_install = { "" }, -- List of parsers to ignore installing
	highlight = {
		enable = true, -- false will disable the whole extension
		disable = {}, -- list of language that will be disabled
		additional_vim_regex_highlighting = { "org" },
	},
	autopairs = {
		enable = true,
	},
	indent = { enable = true, disable = { "python" } },
	autotag = {
		enable = true,
		filetypes = {
			"javascript",
			"typescript",
			"html",
			"svelte",
		},
	},
})
