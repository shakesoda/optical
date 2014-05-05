local function Clock()
	function UpdateVisible(self)
		local screen = SCREENMAN:GetTopScreen()
		local bShow = true
		if screen then
			local sClass = screen:GetName()
			bShow = THEME:GetMetric(sClass, "ShowClock")
		end
		if bShow then
			self:smooth(0.25)
			self:y(12)
		else
			self:smooth(0.25)
			self:y(-56)
		end
	end
	-- clock
	clock = Def.ActorFrame {
		Name="Clock",
		InitCommand=cmd(x,50;y,12;playcommand,"Update"),
		ScreenChangedMessageCommand=UpdateVisible,
		UpdateCommand=cmd(runcommandsonleaves,cmd(queuecommand,"Update")),
		Def.RoundedBox(90,26)..{ InitCommand=cmd(x,-22;y,-4) },
		Def.ActorFrame {
			Name="ClockText",
			InitCommand=cmd(y,-2),
			LoadFont("Common", "normal")..{
				Text="00:00:",
				InitCommand=cmd(horizalign,right;shadowlength,0;diffusebottomedge,color("0.9,0.9,0.9")),
				UpdateCommand=function(self)
					local hour, min = Hour(), Minute()
					if hour > 12 and GetUserPrefB("Use12HourClock") then
						hour = hour - 12
					elseif hour == 0 and GetUserPrefB("Use12HourClock") then
						hour = 12
					end	
					self:settext(string.format('%02i:%02i:', hour, min))
					self:sleep(1)
					self:queuecommand("Update")
				end
			},
			LoadFont("Common", "normal")..{
				Text="00",
				InitCommand=cmd(horizalign,left;shadowlength,0;diffusebottomedge,color("0.9,0.9,0.9")),
				UpdateCommand=function(self)
					local sec = Second()
					self:settext(string.format('%02i', sec))
					self:sleep(1)
					self:queuecommand("Update")
				end,
			},
			LoadFont("Common", "normal")..{
				Text="",
				InitCommand=cmd(x,28;y,-3;horizalign,left;shadowlength,0;diffusebottomedge,color("0.9,0.9,0.9");visible,false;zoom,0.75),
				UpdateCommand=function(self)
					if not GetUserPrefB("Use12HourClock") then
						self:visible(false)
						return
					end
					local hour = Hour()
					if hour < 12 then
						self:settext("AM")
						self:diffuse(color("1,0.85,0,1"))
						self:diffusebottomedge(color("0.75,0.55,0,1"))
					else
						self:settext("PM")
						self:diffuse(color("0,0.85,1,1"))
						self:diffusebottomedge(color("0,0.55,1,1"))
					end
					self:visible(true)
					self:sleep(1)
					self:queuecommand("Update")
				end
			}
		}
	}
	return clock;
end

local function CreditsText(pn)
	function update(self)
		local str = ScreenSystemLayerHelpers.GetCreditsMessage(pn)
		self:settext(str)
	end

	function UpdateVisible(self)
		local screen = SCREENMAN:GetTopScreen()
		local bShow = true
		if screen then
			local sClass = screen:GetName()
			bShow = THEME:GetMetric(sClass, "ShowCoinsAndCredits")
		end
		if bShow then
			self:smooth(0.25)
			self:y(THEME:GetMetric("ScreenSystemLayer","CreditsSharedY"))
		else
			self:smooth(0.25)
			self:y(THEME:GetMetric("ScreenSystemLayer","CreditsSharedY")+48)
		end
	end
	
	local text = LoadFont("_helvetica 15")..{
		InitCommand=cmd(shadowlengthy,1;shadowlengthx,0),
		RefreshCreditTextMessageCommand=update,
		CoinInsertedMessageCommand=update,
		PlayerJoinedMessageCommand=update,
		ScreenChangedMessageCommand=UpdateVisible
	}
	return text
end


local t = Def.ActorFrame {
	Clock(),
	-- system messages
	Def.Quad {
		InitCommand=cmd(diffuse,color("0,0,0,0");zoomto,SCREEN_WIDTH,40;horizalign,left),
		SystemMessageMessageCommand=function(self,params)
			local f = cmd(finishtweening;x,SCREEN_LEFT;y,28;diffusealpha,0;addy,-100;decelerate,0.3;diffusealpha,.7;diffusetopedge,color("0.2,0.2,0.2,0.7");addy,100)
			f(self) -- "f your self"
			self:playcommand("On")
			if params.NoAnimate then
				self:finishtweening()
			end
			f = cmd(sleep,5;decelerate,0.3;addy,100;diffusealpha,0)
			f(self) -- man these are pretty ugly.
			self:playcommand("Off")
		end,
		HideSystemMessageMessageCommand=cmd(finishtweening)
	},
	LoadFont("Common normal")..{
		InitCommand=cmd(strokecolor,color("0,0,0,0.75");maxwidth,750;horizalign,left;vertalign,top;zoom,0.8;shadowlength,2;y,20;diffusealpha,0),
		SystemMessageMessageCommand=function(self,params)
			self:settext(params.Message)
			local f = cmd(finishtweening;x,SCREEN_LEFT+20;y,20;diffusealpha,0;addy,-100;decelerate,0.3;diffusealpha,1;addy,100); f(self)
			self:playcommand("On")
			if params.NoAnimate then
				self:finishtweening()
			end
			f = cmd(sleep,5;decelerate,0.3;addy,100;diffusealpha,0)
			f(self)
			self:playcommand("Off")
		end,
		HideSystemMessageMessageCommand=cmd(finishtweening)
	},
	CreditsText(PLAYER_1)..{ InitCommand=cmd(x,ScreenMetric("CreditsP1X");y,ScreenMetric("CreditsSharedY");diffuse,color("#CCCCCC");diffusetopedge,color("#FFFFFF")) },
	CreditsText(PLAYER_2)..{ InitCommand=cmd(x,ScreenMetric("CreditsP2X");y,ScreenMetric("CreditsSharedY");diffuse,color("#CCCCCC");diffusetopedge,color("#FFFFFF")) }
}
return t