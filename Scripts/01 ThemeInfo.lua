-- theme identification:
themeInfo = {
	ProductCode = "SHRK-012",
	Name = "Optical",
	Version = "v1.01 Release",
	Date = "20091202",
	Internal = "203"
}

function GetThemeVersion()
	str = themeInfo.Version
	str = string.sub(str, 2, 5)
	return tonumber(str)
end