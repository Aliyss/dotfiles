local status_ok, config = pcall(require, "vim-markdown")
if not status_ok then
	return
end

config.setup({})
