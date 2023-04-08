local status_ok, config = pcall(require, "notify")
if not status_ok then
	return
end

config.setup({
	background_colour = "#000000",
})

vim.notify = config
