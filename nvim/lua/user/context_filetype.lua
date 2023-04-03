local status_ok, context_filetype = pcall(require, "context_filetype")
if not status_ok then
	return
end

context_filetype.setup({})
