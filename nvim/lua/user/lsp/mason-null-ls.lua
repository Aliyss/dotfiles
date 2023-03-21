local masonnullls_status_ok, masonnullls = pcall(require, "mason-null-ls")
if not masonnullls_status_ok then
	return
end

masonnullls.setup({
	ensure_installed = { "stylua" },
})
