local status_ok, vimsvelte = pcall(require, "vim-svelte")
if not status_ok then
	return
end

vimsvelte.setup()
