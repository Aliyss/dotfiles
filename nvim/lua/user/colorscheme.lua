local colorscheme = "tokyonight"

require('tokyonight').setup({
	transparent = true
})

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  return
end

vim.cmd[[hi NvimTreeNormal guibg=NONE ctermbg=NONE]]
vim.cmd[[hi NvimTreeNormalNC guibg=NONE ctermbg=NONE]]

vim.cmd[[hi WhichKey guibg=NONE ctermbg=NONE]]
vim.cmd[[hi WhichKeyFloat guibg=NONE ctermbg=NONE]]
