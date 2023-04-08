local status_ok, config = pcall(require, "vimwiki")
if not status_ok then
	return
end

config.setup({})
