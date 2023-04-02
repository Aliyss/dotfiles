local status_ok, configs = pcall(require, "trouble.nvim")
if not status_ok then
	return
end

configs.setup({
	use_diagnostic_signs = true,
	auto_open = true,
})
