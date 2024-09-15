require("full-border"):setup {
	-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
	type = ui.Border.ROUNDED,
}

function Linemode:mtimev2()
	local time = math.floor(self._file.cha.modified or 0)

		time = time and os.date("%g-%m-%d %H:%M", time) or ""

	return ui.Line(string.format(time))
end

function Linemode:ctimev2()
	local time = math.floor(self._file.cha.created or 0)

		time = time and os.date("%g-%m-%d %H:%M", time) or ""

	return ui.Line(string.format(time))
end
