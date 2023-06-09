local whichkey_status_ok, whichkey = pcall(require, "which-key")
if not whichkey_status_ok then
	return
end

whichkey.setup({})

whichkey.register({
	["<leader>a"] = {
		desc = "Open Alpha",
	},
	["<leader>c"] = {
		desc = "Open Config",
	},
	["<leader>b"] = {
		name = "+Buffers",
		j = { "<cmd>BufferLinePick<cr>", "Jump" },
		f = { "<cmd>Telescope buffers previewer=false<cr>", "Find" },
		b = { "<cmd>BufferLineCyclePrev<cr>", "Previous" },
		n = { "<cmd>BufferLineCycleNext<cr>", "Next" },
		W = { "<cmd>noautocmd w<cr>", "Save without formatting (noautocmd)" },
		-- w = { "<cmd>BufferWipeout<cr>", "Wipeout" }, -- TODO: implement this for bufferline
		e = {
			"<cmd>BufferLinePickClose<cr>",
			"Pick which buffer to close",
		},
		h = { "<cmd>BufferLineCloseLeft<cr>", "Close all to the left" },
		l = {
			"<cmd>BufferLineCloseRight<cr>",
			"Close all to the right",
		},
		D = {
			"<cmd>BufferLineSortByDirectory<cr>",
			"Sort by directory",
		},
		L = {
			"<cmd>BufferLineSortByExtension<cr>",
			"Sort by language",
		},
	},
	["<leader>g"] = { name = "+Git" },
	["<leader>gh"] = { name = "+Git Hunks" },
	["<leader>f"] = { name = "+Telescope" },
	["<leader>x"] = {
		name = "+Trouble",
		x = { "<cmd>TroubleToggle document_diagnostics<cr>", "Document Diagnostics (Trouble)" },
		X = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Workspace Diagnostics (Trouble)" },
		L = { "<cmd>TroubleToggle loclist<cr>", "Location List (Trouble)" },
		Q = { "<cmd>TroubleToggle quickfix<cr>", "Quickfix List (Trouble)" },
	},
	g = {
		name = "+GoTo",
		D = { desc = "Go To Declaration" },
		d = { desc = "Go To Definition" },
		I = { desc = "Go To Implementation" },
		r = { desc = "Go To References" },
		l = { desc = "Open Diagnostic Window" },
	},
	["<leader>l"] = {
		name = "+LSP",
		i = { desc = "LSP Info" },
		I = { desc = "Mason" },
		a = { desc = "Code Action" },
		j = { desc = "Next Diagnostic" },
		k = { desc = "Previous Diagnostic" },
		r = { desc = "Rename" },
		s = { desc = "Signature Help" },
		q = { desc = "Set Location List Diagnostic" }, -- https://github.com/ten3roberts/qf.nvim
	},
	["<leader>z"] = {
		name = "+Zettelkasten",
		f = { "<cmd>Telekasten find_notes<CR>", "Find Notes" },
		g = { "<cmd>Telekasten search_notes<CR>", "Search Notes" },
		d = { "<cmd>Telekasten goto_today<CR>", "GoTo Today" },
		z = { "<cmd>Telekasten follow_link<CR>", "Follow Link" },
		n = { "<cmd>Telekasten new_note<CR>", "New Note" },
		c = { "<cmd>Telekasten show_calendar<CR>", "Show Calendar" },
		b = { "<cmd>Telekasten show_backlinks<CR>", "Show Backlinks" },
		I = { "<cmd>Telekasten insert_img_link<CR>", "Insert Image Link" },
		i = { "<cmd>Telekasten insert_link<CR>", "Insert Link" },
	},
	["<leader>h"] = {
		name = "+Harpoon",
		w = { "<cmd>:lua require('harpoon.mark').add_file()<CR>", "Add File" },
		u = { "<cmd>:lua require('harpoon.ui').toggle_quick_menu()<CR>", "Toggle Quick Menu" },
	},
})
