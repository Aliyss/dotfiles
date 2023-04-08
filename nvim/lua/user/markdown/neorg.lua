local status_ok, config = pcall(require, "neorg")
if not status_ok then
	return
end

config.setup({
	load = {
		["core.defaults"] = {},
		["core.norg.dirman"] = {
			config = {
				workspaces = {
					aliyss = "~/Projects/life/aliyss",
				},
			},
		},
		["core.norg.concealer"] = {},
		["core.norg.completion"] = {
			config = {
				engine = "nvim-cmp",
			},
		},
		["core.integrations.treesitter"] = {
			config = {
				configure_parsers = true,
				install_parsers = true,
			},
		},
	},
})

config.run = ":Neorg sync-parsers"
