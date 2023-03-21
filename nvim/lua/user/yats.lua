local status_ok, yats = pcall(require, "yats")
if not status_ok then
	return
end

yats.setup()
