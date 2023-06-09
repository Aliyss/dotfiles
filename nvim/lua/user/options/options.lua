vim.opt.autowrite = true -- enable auto write
vim.opt.backup = false -- creates a backup file
vim.opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
vim.opt.cmdheight = 1 -- more space in the neovim command line for displaying messages
vim.opt.completeopt = { "menuone", "noselect" } -- mostly just for cmp
vim.opt.conceallevel = 0 -- so that `` is visible in markdown files
vim.opt.cursorline = true -- highlight the current line
vim.opt.expandtab = true -- convert tabs to spaces
vim.opt.fileencoding = "utf-8" -- the encoding written to a file
vim.opt.fillchars.eob = " "
vim.opt.formatoptions = "jcroqlnt" -- tcqj
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.guifont = "monospace:h17" -- the font used in graphical neovim applications
vim.opt.hlsearch = true -- highlight all matches on previous search pattern
vim.opt.ignorecase = true -- ignore case in search patterns
vim.opt.inccommand = "nosplit" -- preview incremental substitute
vim.opt.iskeyword:append("-")
vim.opt.laststatus = 3
vim.opt.list = true -- show some invisible characters (tabs...
vim.opt.mouse = "a" -- allow the mouse to be used in neovim
vim.opt.number = true -- print line number
vim.opt.numberwidth = 2 -- set number column width to 2 {default 4}
vim.opt.pumblend = 10 -- popup blend
vim.opt.pumheight = 10 -- pop up menu height
vim.opt.relativenumber = true -- relative line numbers
vim.opt.ruler = true
vim.opt.scrolloff = 4 -- is one of my fav
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
vim.opt.shiftround = true -- round indent
vim.opt.shiftwidth = 2 -- size of an indent
vim.opt.shortmess:append({ w = true, i = true, c = true })
vim.opt.showcmd = false
vim.opt.showmode = false -- we don't need to see things like -- INSERT -- anymore
vim.opt.showtabline = 0 -- always show tabs
vim.opt.sidescrolloff = 8 -- columns of context
vim.opt.signcolumn = "yes" -- always show the signcolumn, otherwise it would shift the text each time
vim.opt.smartcase = true -- smart case
vim.opt.smartindent = true -- make indenting smarter again
vim.opt.spelllang = { "en" }
vim.opt.splitbelow = true -- force all horizontal splits to go below current window
vim.opt.splitright = true -- force all vertical splits to go to the right of current window
vim.opt.swapfile = false -- creates a swapfile
vim.opt.tabstop = 2 -- insert 2 spaces for a tab
vim.opt.termguicolors = true -- set term gui colors (most terminals support this)
vim.opt.timeoutlen = 1000 -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.undofile = true -- enable persistent undo
vim.opt.undolevels = 10000
vim.opt.updatetime = 300 -- faster completion (4000ms default)
vim.opt.whichwrap:append("<,>,[,],h,l")
vim.opt.wildmode = "longest:full,full" -- command-line completion mode
vim.opt.winminwidth = 5 -- minimum window width
vim.opt.wrap = false -- display lines as one long line
vim.opt.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
