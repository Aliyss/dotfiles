local status_ok, vimprettier = pcall(require, "vim-prettier")
if not status_ok then
	return
end

vimprettier.setup({
	run = "npm install",
	cmd = {
		"vim.cmd[[let g:prettier#quickfix_enabled = 0]]",
		"vim.cmd[[let g:prettier#autoformat_require_pragma = 0]]",
		"vim.cmd[[au BufWritePre *.css,*.svelte,*.pcss,*.html,*.ts,*.js,*.json PrettierAsync]]",
	},
})
