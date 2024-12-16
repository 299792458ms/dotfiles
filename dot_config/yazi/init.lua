require("full-border"):setup {
	type = ui.Border.ROUNDED, -- PLAIN/ROUNDED
}

-- smart enter
-- require("smart-enter"):setup {
-- 	open_multi = true,
-- }


function Linemode:mtimev2()
	local time = math.floor(self._file.cha.modified or 0)

		time = time and os.date("%g-%m-%d %H:%M", time) or ""

	return ui.Line(string.format(time))
end

function Linemode:btimev2()
	local time = math.floor(self._file.cha.created or 0)

		time = time and os.date("%g-%m-%d %H:%M", time) or ""

	return ui.Line(string.format(time))
end
