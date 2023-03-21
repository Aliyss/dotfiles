local colorscheme = "tokyonight"

require("tokyonight").setup({
	transparent = true,
})

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
	return
end

vim.cmd([[hi NvimTreeNormal guibg=NONE ctermbg=NONE]])
vim.cmd([[hi NvimTreeNormalNC guibg=NONE ctermbg=NONE]])

-- vim.cmd([[hi ]])
vim.cmd([[hi WhichKey guibg=NONE ctermbg=NONE]])
vim.cmd([[hi WhichKeyFloat guibg=NONE ctermbg=NONE]])
vim.cmd([[hi LspFloatWinNormal guibg=NONE ctermbg=NONE]])

-- Key:         Ctrl-e
-- Action:      Show treesitter capture group for textobject under cursor.
vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		local bufnr = vim.fn.bufnr("%")
		vim.keymap.set("n", "<CR>", function()
			vim.api.nvim_command([[execute "normal! \<cr>"]])
			vim.api.nvim_command(bufnr .. "bd")
		end, { buffer = bufnr })
	end,
	pattern = "qf",
})

-- TSPlayground provided command. (Need to install the plugin.)
-- bindkey("n",    "<C-e>",  ":TSHighlightCapturesUnderCursor<CR>",   opts)
-- This was misbehaving a lot.
-- Might be more stable now in recent treesitter versions.
