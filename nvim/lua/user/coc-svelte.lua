local status_ok, cocsvelte = pcall(require, "coc-svelte")
if not status_ok then
	return
end

cocsvelte.setup({
	run = "npm install",
})
