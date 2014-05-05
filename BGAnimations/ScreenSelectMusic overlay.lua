local corner = THEME:GetPathG("","_corner")
cBlack = color("0,0,0,1")

local function StepsDisplay(t, pn)
	local function set(self, player)
		self:SetFromGameState(player)
	end
	local t = Def.StepsDisplay {}
	t.InitCommand=cmd(Load,"StepsDisplay",GAMESTATE:GetPlayerState(pn))
	if pn == PLAYER_1 then
		t.CurrentStepsP1ChangedMessageCommand=function(self) set(self, pn) end
		t.CurrentTrailP1ChangedMessageCommand=function(self) set(self, pn) end
	else
		t.CurrentStepsP2ChangedMessageCommand=function(self) set(self, pn) end
		t.CurrentTrailP2ChangedMessageCommand=function(self) set(self, pn) end
	end
	return t
end

local function InfoBox(Width, Height)
	return Def.RoundedBox(Width, Height)..{
		OnCommand=cmd(runcommandsonleaves,cmd(diffusealpha,0;linear,0.5;diffusealpha,0.8)),
		OffCommand=cmd(runcommandsonleaves,cmd(linear,0.5;diffusealpha,0))
	}
end

function HasStats()
	return STATSMAN:GetPlayedStageStats(1) ~= nil
end

function GetStats(pn)
	local stats = STATSMAN:GetPlayedStageStats(1)
	if not stats then
		return
	end
	stats = stats:GetPlayerStageStats(pn)
	return stats
end

function HasFullCombo(pn)
	if HasStats() then
		return GetStats(pn):FullCombo()
	end
end

function GradeString(pn)
	if HasStats() then
		return string.sub(GetStats(pn):GetGrade(),7)
	end
	return "Failed"
end

local t = Def.ActorFrame {}

t[#t+1] = StandardDecorationFromFileOptional("DDRHeader","header")

local songForStats = STATSMAN:GetAccumPlayedStageStats():GetPlayedSongs()

t[#t+1] = Def.ActorFrame {
	FOV=60,
	InitCommand=cmd(x,SCREEN_LEFT+150;y,SCREEN_CENTER_Y;rotationy,-45;addx,-415),
	SelectMenuOpenedMessageCommand=cmd(stoptweening;sleep,0.1;smooth,0.25;x,SCREEN_LEFT-150;rotationy,0),
	SelectMenuClosedMessageCommand=cmd(stoptweening;smooth,0.25;x,SCREEN_LEFT+150),
	OnCommand=cmd(sleep,0.1;decelerate,0.4;addx,415;rotationy,0),
	OffCommand=cmd(linear,0.15;addx,15;accelerate,0.3;addx,-430;rotationy,-45),
	Def.ActorProxy {
		BeginCommand=function(self)
			local banner = SCREENMAN:GetTopScreen():GetChild('Banner')
			self:SetTarget(banner)
		end
	},
	StandardDecorationFromFileOptional("BannerOver","banner over"),
	StandardDecorationFromFile("BannerFrame","banner frame")
}

local info = Def.ActorFrame {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_BOTTOM-60);
	SelectMenuOpenedMessageCommand=cmd(stoptweening;sleep,0.1;smooth,0.25;y,SCREEN_BOTTOM+30);
	SelectMenuClosedMessageCommand=cmd(stoptweening;smooth,0.25;y,SCREEN_BOTTOM-60);
	CurrentSongChangedMessageCommand=function(self)
		local song = GAMESTATE:GetCurrentSong()
		if song then
			self:visible(true)
		else
			self:visible(false)
		end
	end,
	InfoBox(542, 52),
	Def.ActorFrame {
		LoadFont("_myriad")..{
			Text="-",
			InitCommand=cmd(playcommand,"Set";y,-20;zoom,0.7;shadowlength,0;maxwidth,290),
			OnCommand=cmd(diffusealpha,0;linear,0.5;diffusealpha,1),
			OffCommand=cmd(linear,0.5;diffusealpha,0),
			CurrentSongChangedMessageCommand=cmd(finishtweening;playcommand,"Set"),
			SetCommand=function(self)
				local song = GAMESTATE:GetCurrentSong()
				if not song
					then self:visible(false)
					return
				end
				self:visible(true)
				self:zoomx(1)
				self:zoomy(0.7)
				self:linear(0.07)
				self:zoomx(0.8)
				self:zoomy(0.8)
				if song:GetGenre() ~= "" then
					self:settext(song:GetGenre())
					self:diffuse(color("#AAAAAA"))
					self:diffusetopedge(color("#FFFFFF"))
				else
					self:diffuse(color("#999999"))
					self:diffusetopedge(color("#BBBBBB"))
					self:settext(GenreGen.Generate())
				end

			end
		},
		LoadFont("_myriad")..{
			Text="-",
			InitCommand=cmd(playcommand,"Set";y,-2;zoom,1;diffuse,color("#CCCCCC");diffusetopedge,color("#FFFFFF");shadowlength,0;maxwidth,400;strokecolor,color("#000000dd")),
			OnCommand=cmd(diffusealpha,0;linear,0.5;diffusealpha,1),
			OffCommand=cmd(linear,0.5;diffusealpha,0),
			CurrentSongChangedMessageCommand=cmd(finishtweening;playcommand,"Set"),
			ChangedLanguageDisplayMessageCommand=cmd(finishtweening;playcommand,"Set"),
			DisplayLanguageChangedMessageCommand=cmd(playcommand,"Set"),
			SetCommand=function(self)
				local song = GAMESTATE:GetCurrentSong()
				if not song
					-- get out of here.
					then self:visible(false)
					return
				end
					-- otherwise, set it to the song artist
				self:visible(true)
				self:zoomx(1.2)
				self:zoomy(0.9)
				self:linear(0.07)
				self:zoomx(1)
				self:zoomy(1)
				self:settext(song:GetDisplayArtist())
			end
		},
		LoadFont("_myriad")..{
			InitCommand=cmd(y,60-44;shadowlength,0;diffuse,color("#999999");diffusetopedge,color("#BBBBBB");zoom,0.9),
			OnCommand=cmd(diffusealpha,0;linear,0.5;diffusealpha,1),
			OffCommand=cmd(linear,0.5;diffusealpha,0),
			CurrentSongChangedMessageCommand=cmd(finishtweening;playcommand,"Set"),
			SetCommand=function(self)
				local song = GAMESTATE:GetCurrentSong()
				if not song then
					self:visible(false)
					return
				end
				self:visible(true)
				self:zoomx(1.1)
				self:zoomy(0.8)
				self:linear(0.07)
				self:zoomx(0.9)
				self:zoomy(0.9)
				local time = song:MusicLengthSeconds()
				if time then
					self:settext(SecondsToMSSMsMs(time))
				else
					self:settext("")
				end
			end
		}
	},
	Def.ActorFrame {
		Name="BPMDisplayFrame",
		InitCommand=cmd(y,-22;x,150),
		Def.BPMDisplay {
			File=THEME:GetPathF("Common", "normal"),
			Name="BPMDisplay",
			InitCommand=cmd(horizalign,right;shadowlength,0),
			OnCommand=cmd(diffusealpha,0;linear,0.5;diffusealpha,1),
			OffCommand=cmd(linear,0.5;diffusealpha,0),
			CurrentSongChangedMessageCommand=function(self)
				local song = GAMESTATE:GetCurrentSong()
				if song then
					self:SetFromGameState()
					self:visible(true)
				else
					self:visible(false)
					return
				end
			end
		},
		LoadFont("Common", "normal")..{
			Text="BPM",
			InitCommand=cmd(horizalign,left;x,1;y,-1;zoom,0.65;shadowlength,0),
			OnCommand=cmd(diffusealpha,0;linear,0.5;diffusealpha,1),
			OffCommand=cmd(linear,0.5;diffusealpha,0),
			CurrentSongChangedMessageCommand=function(self)
				local song = GAMESTATE:GetCurrentSong()
				if song then
					self:visible(true)
				else
					self:visible(false)
					return
				end
			end
		}
	}
}

for pn in ivalues(PlayerNumber) do
	local MetricsName = "StepsDisplay" .. PlayerNumberToString(pn)
	info[#info+1] = StepsDisplay(t,pn)..{
		Name=MetricsName,
		InitCommand=function(self)
			self:player(pn)
			ActorUtil.LoadAllCommandsAndSetXY(self,Var "LoadingScreen")
		end,
		PlayerJoinedMessageCommand=function(self, params)
			if params.Player == pn then
				self:visible(true)
				f = cmd(zoom,0;bounceend,0.3;zoom,1)
				f(self)
			end
		end,
		PlayerUnjoinedMessageCommand=function(self, params)
			if params.Player == pn then
				self:visible(true)
				f = cmd(bouncebegin,0.3;zoom,0)
				f(self)
			end
		end
	}
end

t[#t+1] = info

col = {
	W1 = "0,0.25,1,0.25",
	W2 = "1,0.85,0.3,0.25",
	W3 = "0,1,0.25,0.25",
	W4 = "0,0,0.75,0.25",
	W5 = "1,0.5,0.15,0.25",
	WM = "0.75,0,0,0.25"
}

t[#t+1] = Def.ActorFrame {
	Def.ActorFrame {
		InitCommand=cmd(y,SCREEN_CENTER_Y;x,SCREEN_CENTER_X*3),
		SelectMenuOpenedMessageCommand=cmd(stoptweening;sleep,0.1;smooth,0.25;x,SCREEN_CENTER_X),
		SelectMenuClosedMessageCommand=cmd(stoptweening;smooth,0.25;x,SCREEN_CENTER_X*3),
		Def.RoundedBox(536, 260),
		LoadFont("Common normal")..{
			Text="Evaluation",
			InitCommand=cmd(x,-262;y,-122;horizalign,left;diffuse,color("0.7,0.7,0.7");diffusebottomedge,color("0.5,0.5,0.5");shadowlengthy,1;shadowcolor,color("0,0,0,0.5"))
		},
		Def.Quad {
			InitCommand=cmd(zoomto,526,1;y,-108;diffuse,color("0.4,0.4,0.4"))
		},
		Def.ActorFrame {
			Condition=HasStats(),
			InitCommand=cmd(zoomx,256),
			Def.Quad { InitCommand=cmd(zoomto,1,20;y,-87;diffuse,color(col.W1);diffusetopedge,BoostColor(color(col.W1),0.1)) }, -- flawless
			Def.Quad { InitCommand=cmd(zoomto,1,20;y,-67;diffuse,color(col.W2);diffusetopedge,BoostColor(color(col.W2),0.1)) }, -- perfect
			Def.Quad { InitCommand=cmd(zoomto,1,20;y,-47;diffuse,color(col.W3);diffusetopedge,BoostColor(color(col.W3),0.1)) }, -- great
			Def.Quad { InitCommand=cmd(zoomto,1,20;y,-27;diffuse,color(col.W4);diffusetopedge,BoostColor(color(col.W4),0.1)) }, -- good
			Def.Quad { InitCommand=cmd(zoomto,1,20;y,-7;diffuse,color(col.W5);diffusetopedge,BoostColor(color(col.W5),0.1)) }, -- bad
			Def.Quad { InitCommand=cmd(zoomto,1,20;y,13;diffuse,color(col.WM);diffusetopedge,BoostColor(color(col.WM),0.1)) } -- miss
		},
		Def.Quad {
			Condition=HasStats(),
			InitCommand=cmd(x,-128;y,-36;zoomto,1,20*6;diffuse,cBlack)
		},
		Def.Quad {
			Condition=HasStats(),
			InitCommand=cmd(x,128;y,-36;zoomto,1,20*6;diffuse,cBlack)
		},
		LoadFont("Common normal")..{
			Text=string.lower(PREFSMAN:GetPreference("CurrentGame") .. " mode"),
			InitCommand=cmd(x,262;y,-122;horizalign,right;diffuse,color("0.7,0.7,0.7");diffusebottomedge,color("0.5,0.5,0.5");shadowlengthy,1;shadowcolor,color("0,0,0,0.5"))
		},
		Def.ActorFrame {
			InitCommand=function(self)
				if HasStats() then
					self:y(-38)
				end
				self:shadowlengthy(1)
			end,
			LoadFont("Common normal")..{
				Text=ScreenString("NoSongsPlayed"),
				InitCommand=cmd(playcommand,"Set";shadowlengthy,1),
				SetCommand=function(self)
					local stats = STATSMAN:GetPlayedStageStats(1)
					if stats then
						stats = stats:GetPlayerStageStats(PLAYER_1)
					else
						return
					end
					str = string.format("%s\n%s\n%s\n%s\n%s\n%s",
						ScreenString("Flawless"),
						ScreenString("Perfect"),
						ScreenString("Great"),
						ScreenString("Good"),
						ScreenString("Bad"),
						ScreenString("Miss")
					)
					self:settext(str)
				end
			},
			-- player 1 stats
			LoadFont("Common normal")..{
				Text="",
				InitCommand=cmd(playcommand,"Set";shadowlengthy,1),
				Condition=GAMESTATE:IsSideJoined(PLAYER_1),
				SetCommand=function(self)
					local stats = STATSMAN:GetPlayedStageStats(1)
					if stats then
						stats = stats:GetPlayerStageStats(PLAYER_1)
					else
						return
					end
					self:horizalign(right)
					self:x(-64)
					str = string.format("%05d\n%05d\n%05d\n%05d\n%05d\n%05d",
						stats:GetTapNoteScores('TapNoteScore_W1'),
						stats:GetTapNoteScores('TapNoteScore_W2'),
						stats:GetTapNoteScores('TapNoteScore_W3'),
						stats:GetTapNoteScores('TapNoteScore_W4'),
						stats:GetTapNoteScores('TapNoteScore_W5'),
						stats:GetTapNoteScores('TapNoteScore_Miss')
					)
					self:settext(str)
				end
			},
			-- player 2 stats
			LoadFont("Common normal")..{
				Text="",
				InitCommand=cmd(playcommand,"Set";shadowlengthy,1),
				Condition=GAMESTATE:IsSideJoined(PLAYER_2),
				SetCommand=function(self)
					local stats = STATSMAN:GetPlayedStageStats(1)
					if stats then
						stats = stats:GetPlayerStageStats(PLAYER_2)
					else
						return
					end
					self:horizalign(left)
					self:x(64)
					str = string.format("%05d\n%05d\n%05d\n%05d\n%05d\n%05d",
						stats:GetTapNoteScores('TapNoteScore_W1'),
						stats:GetTapNoteScores('TapNoteScore_W2'),
						stats:GetTapNoteScores('TapNoteScore_W3'),
						stats:GetTapNoteScores('TapNoteScore_W4'),
						stats:GetTapNoteScores('TapNoteScore_W5'),
						stats:GetTapNoteScores('TapNoteScore_Miss')
						-- stats:MaxCombo()
					)
					self:settext(str)
				end
			}
		},
		-- eval banner
		Def.ActorFrame {
			Condition=HasStats(),
			InitCommand=cmd(y,76),
			Def.Sprite {
				BeginCommand=cmd(LoadFromSongBanner,songForStats[#STATSMAN:GetAccumPlayedStageStats():GetPlayedSongs()]),
				InitCommand=cmd(scaletoclipped,256,80)
			},
			StandardDecorationFromFileOptional("BannerOver","banner over"),
			StandardDecorationFromFile("BannerFrame","banner frame")
		},
		-- eval song artist / title
		LoadFont("Common normal")..{
			Text="",
			InitCommand=cmd(y,124;playcommand,"Set";shadowlengthy,1),
			SetCommand=function(self)
				local song = STATSMAN:GetAccumPlayedStageStats():GetPlayedSongs()
				song = song[#song] -- dumb
				if song then -- and dumber
					self:settext(song:GetDisplayArtist() .. " / " .. song:GetDisplayFullTitle())
					self:maxwidth(512)
				end
			end
		},
		-- player 1
		LoadFont("Common normal")..{
			Condition=HasStats() and GAMESTATE:IsSideJoined(PLAYER_1),
			Text=HasFullCombo(PLAYER_1) and "Full Combo!" or "",
			InitCommand=cmd(xy,-200,-88;diffuseshift;effectcolor1,color("0.7,0.7,0.7,1");shadowlengthy,1)
		},
		LoadActor(THEME:GetPathG("","_grades/"..GradeString(PLAYER_1)))..{
			Condition=HasStats() and GAMESTATE:IsSideJoined(PLAYER_1),
			InitCommand=cmd(xy,-200,76),
		},
		-- player 2
		LoadFont("Common normal")..{
			Condition=HasStats() and GAMESTATE:IsSideJoined(PLAYER_2),
			Text=HasFullCombo(PLAYER_2) and "Full Combo!" or "",
			InitCommand=cmd(xy,200,-88;diffuseshift;effectcolor1,color("0.7,0.7,0.7,1");shadowlengthy,1)
		},
		LoadActor(THEME:GetPathG("","_grades/"..GradeString(PLAYER_2)))..{
			Condition=HasStats() and GAMESTATE:IsSideJoined(PLAYER_2),
			InitCommand=cmd(xy,200,76),
		},
	}
}
t[#t+1] = StandardDecorationFromFile("OptionsListFrame", "optionslist frame")
t[#t+1] = StandardDecorationFromFile("Arrows", "arrows")

return t