local masonnullls_status_ok, masonnullls = pcall(require, "mason-null-ls")
if not masonnullls_status_ok then
	return
end

masonnullls.setup({
	ensure_installed = {
		"stylua",
		"rust-analyzer",
		"codelldb",
		"rustfmt",
		"svelte-language-server",
		"prettierd",
		"eslint_d",
		"tailwindcss-language-server",
		"shfmt",
		"bash-language-server",
		"shellcheck",
		"js-debug-adapter",
	},
})
