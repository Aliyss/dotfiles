local whichkey_status_ok, whichkey = pcall(require, "which-key")
if not whichkey_status_ok then
	return
end

whichkey.setup({})

whichkey.register({
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
})
