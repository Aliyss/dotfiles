local status_ok, config = pcall(require, "telekasten")
if not status_ok then
	return
end

config.setup({
	home = vim.fn.expand("~/Projects/life"),
})
