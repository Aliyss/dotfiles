local status_ok, configs = pcall(require, "notify.nvim")
if not status_ok then
	return
end

configs.setup()

vim.notify = configs
