local status_ok, vimjavascript = pcall(require, "vim-javascript")
if not status_ok then
	return
end

vimjavascript.setup()
