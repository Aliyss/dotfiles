local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- https://github.com/prettier-solidity/prettier-plugin-solidity
null_ls.setup({
	debug = false,
	on_attach = function(client, bufnr)
		if client.name == "tsserver" or client.name == "rust_analyzer" then
			client.resolved_capabilities.document_formatting = false
		end
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({ timeout_ms = 5000 })
				end,
			})
		end
	end,
	sources = {
		formatting.eslint_d.with({
			extra_filetypes = { "svelte", "ts" },
			extra_args = { "--fast" },
		}),
		formatting.prettierd.with({
			extra_filetypes = { "svelte", "ts" },
			extra_args = { "--fast" },
		}),
		formatting.black.with({ extra_args = { "--fast" } }),
		formatting.stylua,
		formatting.rustfmt,
		formatting.google_java_format,
		diagnostics.flake8,
	},
})
