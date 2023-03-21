local status_ok, html5 = pcall(require, "html5")
if not status_ok then
	return
end

html5.setup()
