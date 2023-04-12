local status_ok, config = pcall(require, "orgmode")
if not status_ok then
	return
end

config.setup_ts_grammar()

config.setup({
	org_agenda_files = { "~/Projects/life/aliyss/org/*" },
	org_default_notes_file = "~/Projects/life/aliyss/org/refile.org",
	org_capture_templates = {
		r = {
			description = "Repo",
			template = "* [[%x][%(return string.match('%x', '([^/]+)$'))]]%?",
			target = "~/Projects/life/aliyss/org/repos.org",
		},
	},
})
