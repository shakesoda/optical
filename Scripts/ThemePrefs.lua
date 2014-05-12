-- StepMania 5 Default Theme Preferences Handler
local function OptionNameString(str)
	return THEME:GetString('OptionNames',str)
end

-- Example usage of new system (not fully implemented yet)
local Prefs =
{
	AutoSetStyle =
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	-- BackgroundMode =
	-- {
	-- 	Default = true,
	-- 	Choices = { OptionNameString('Off'), OptionNameString('On') },
	-- 	Values = { false, true }
	-- },
	-- BGM =
	-- {
	-- 	Default = true,
	-- 	Choices = { OptionNameString('Off'), OptionNameString('On') },
	-- 	Values = { false, true }
	-- },
	ComboUnderField =
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { true, false }
	},
	ShowBackgroundLights =
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	ShowBackgroundLogo =
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { true, false }
	},
	ShowBannerShine =
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	TimeChangingBackground =
	{
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	Use12HourClock =
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	-- UserPrefScoringMode =
	-- {
	-- 	Default = false,
	-- 	Choices = { OptionNameString('Off'), OptionNameString('On') },
	-- 	Values = { false, true }
	-- }
}

ThemePrefs.InitAll(Prefs)
