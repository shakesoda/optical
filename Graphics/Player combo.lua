local c
local player = Var "Player"
local ShowComboAt = THEME:GetMetric("Combo", "ShowComboAt")
local Pulse = THEME:GetMetric("Combo", "PulseCommand")

local NumberMinZoom = THEME:GetMetric("Combo", "NumberMinZoom")
local NumberMaxZoom = THEME:GetMetric("Combo", "NumberMaxZoom")
local NumberMaxZoomAt = THEME:GetMetric("Combo", "NumberMaxZoomAt")

local t = Def.ActorFrame {
	LoadFont("Combo", "numbers")..{
		Name="Number",
		OnCommand = THEME:GetMetric("Combo", "NumberOnCommand")
	},
	InitCommand=function(self)
		c = self:GetChildren()
		c.Number:visible(false)
	end,
	ComboCommand=function(self, param)
		local iCombo = param.Misses or param.Combo
		if not iCombo or iCombo < ShowComboAt then
			c.Number:visible(false)
			return
		end
		param.Zoom = scale(iCombo, 0, NumberMaxZoomAt, NumberMinZoom, NumberMaxZoom)
		param.Zoom = clamp(param.Zoom, NumberMinZoom, NumberMaxZoom)
		c.Number:visible(true)
		c.Number:settext(string.format("%i", iCombo))
		Pulse(c.Number, param)
	end
}
return t