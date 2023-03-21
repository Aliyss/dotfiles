local status_ok, ale = pcall(require, "ale")
if not status_ok then
	return
end

ale.setup({
	ft = { "typescript", "html", "svelte" },
	cmd = {
		"ALEEnable",
		"ALELint",
		"ALEFix",
	},
	config = function()
		vim.g.ale_linters = {
			typescript = { "eslint" },
			svelte = { "eslint" },
		}
		vim.g.ale_fixers = {
			typescript = { "eslint" },
			svelte = { "eslint" },
		}
	end,
})
