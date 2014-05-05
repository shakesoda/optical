function GetGameMode(style)
	local game = PREFSMAN:GetPreference("CurrentGame");
	if game == style then
		return true;
	else
		return false;
	end
end

function GetLoop(loop)
	if GetUserPref("BackgroundMode") == "ddrex" then
		return THEME:GetPathS("","loops/ddrex")
	else
		return THEME:GetPathS("","loops/" .. loop)
	end
end

function SetGameKeys()
	local game = PREFSMAN:GetPreference("CurrentGame");
	if game == "kb7" then
		return "Key1,Key2,Key3,Key4,Key5,Key6,Start,Back"
	elseif game == "beat" then
		return "Key1,Key2,Key3,Key4,Key5,Key6,Key7,ScratchUp,ScratchDown,Start,Back"
	elseif game == "popn" then
		return "Key1,Key2,Key3,Key4,Key5,Key6,Key7,Key8,Key9,Start,Back"
	elseif game == "pump" then
		return "UpLeft,UpRight,DownLeft,DownRight,Start,Back"
	else
		return "Left,Right,Start,Back"
	end
end

function InitPrefs()
	-- make sure the prefs aren't nil
	if GetUserPref("ShowBackgroundLights") == nil then
		SetUserPref("ShowBackgroundLights",true)
	end
	if GetUserPref("ShowBackgroundLogo") == nil then
		SetUserPref("ShowBackgroundLogo",true)
	end
	if GetUserPref("BGM") == nil then
		SetUserPref("BGM","freek")
	end
	if GetUserPref("BackgroundMode") == nil then
		SetUserPref("BackgroundMode","optical")
	end
	if GetUserPref("TimeChangingBackground") == nil then
		SetUserPref("TimeChangingBackground", false)
	end
	if GetUserPref("Use12HourClock") == nil then
		SetUserPref("Use12HourClock",true)
	end
	if GetUserPref("ShowBannerShine") == nil then
		SetUserPref("ShowBannerShine",true)
	end
	if GetUserPref("UserPrefScoringMode") == nil then
		SetUserPref("UserPrefScoringMode", 'DDR Extreme');
	end;
	if GetUserPref("ComboUnderField") == nil then
		SetUserPref("ComboUnderField", true);
	end;
end

InitPrefs()

function GetAspect()
	return math.floor(PREFSMAN:GetPreference("DisplayAspectRatio") * 10) / 10;
end;

function GetAspectName()
	if GetAspect() >= 1.7 then -- 16/9
		return "wide";
	elseif GetAspect() == 1.6 then -- 16/10
		return "semiwide";
	else -- 4/3
		return "standard"
	end;
end;

function Def.RoundedBox(Width, Height, Color)
	-- code adapted from shakesoda's optical
	-- then re-adapted into it, thanks AJ.
	assert(Width)
	assert(Height)
	local corner = THEME:GetPathG("","_corner") -- graphic file
	local DefaultColor = THEME:GetMetric("Common","BoxColor")
	
	-- Color is optional.
	if not Color then Color = DefaultColor end
	
	--[[
	How it's drawn:
	  c----c
	  OOOOOO
	  c----c
	
	---- is 8px tall and Width-8 wide. y = (Height/2), flip the bit.
	OOOO is Height-8px tall and Width wide.
	c's x position is Width - 4, flip the bit if needed.
	--]]
	local EdgeWidth = Width-8
	local EdgePosY = (Height/2)
	local CornerPosX = ((Width/2)-4)

	return Def.ActorFrame {
		BeginCommand=cmd(runcommandsonleaves,cmd(diffuse,Color)),

		-- top
		Def.Quad { InitCommand=cmd(zoomto,EdgeWidth-8,8;y,-EdgePosY) },

		-- middle
		Def.Quad { InitCommand=cmd(zoomto,Width,Height-8) },

		-- bottom
		Def.Quad { InitCommand=cmd(zoomto,EdgeWidth-8,8;y,EdgePosY) },

		 -- top left
		LoadActor(corner)..{ InitCommand=cmd(x,-CornerPosX;y,-EdgePosY) },

		 -- top right
		LoadActor(corner)..{ InitCommand=cmd(x,CornerPosX;y,-EdgePosY;rotationz,90) },

		 -- bottom left
		LoadActor(corner)..{ InitCommand=cmd(x,-CornerPosX;y,EdgePosY;rotationz,-90) },

		 -- bottom right
		LoadActor(corner)..{ InitCommand=cmd(x,CornerPosX;y,EdgePosY;rotationz,180) },
	}
end

-- (c) 2008-2009 Colby Klein
-- MIT License.