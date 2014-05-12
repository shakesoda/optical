GAMESTATE:Reset()
STATSMAN:Reset()
local pos, ind, numitems, fadetime, movetime = 0, 0, 5, 0.3, 0.12
local maxdistance = ( numitems - 1 ) / 2
local start = false
local lockedinput = true
local randscreens = {
	"ScreenSelectGame",
	"ScreenIntroMovie",
	"ScreenMetaphor"
}
local screen = Var("LoadingScreen")
local msg = {
	ScreenString("Settings"),
	ScreenString("Awesome"),
	ScreenString("Play"),
	ScreenString("Edit"),
	ScreenString("Exit")
}
local screens = {
	"ScreenOptionsService",
	randscreens[math.random(#randscreens)],
	"ScreenProfileLoad",
	"ScreenEditMenu",
	"ScreenExit"
}
-- thanks vdl!
function UpdateInternal(self, Player)
	if GAMESTATE:IsHumanPlayer(Player) then
		if MEMCARDMAN:GetCardState(Player) == 'MemoryCardState_none' then
			local ind = SCREENMAN:GetTopScreen():GetProfileIndex(Player)
			if ind <= 0 then
				if SCREENMAN:GetTopScreen():SetProfileIndex(Player, 1) then
					self:queuecommand('Update')
				end
			end
		else
			SCREENMAN:GetTopScreen():SetProfileIndex(Player, 0)
		end
	end
end

local function Key(key)
	if key == "Left" then
		ret = IsGame("pump") and "DownLeft" or "Left"
	elseif key == "Right" then
		ret = IsGame("pump") and "DownRight" or "Right"
	elseif key == "Start" then
		ret = IsGame("pump") and "Center" or "Start"
	end
	return ret
end

local function UpdateIndex()
	ind = pos + ( numitems - maxdistance )
end

-- update this initially
UpdateIndex()

local function ChangePos(dir)
	pos = pos + dir
	if pos < -maxdistance then
		pos = maxdistance
	elseif pos > maxdistance then
		pos = -maxdistance
	end
	UpdateIndex()
	return pos -- just to return something
end

local function Items(self,params)
	local i, offset = 1,-2
	local xspacing = 164
	local files = {
		"_gears",
		"_nonowa",
		"_play",
		"_edit",
		"_exit",
		0 -- pad to make even
	}
	local numfiles = #files/2
	local ret = Def.ActorFrame {
		MenuStartMessageCommand = cmd(runcommandsonleaves,cmd(smooth,fadetime;diffusealpha,0));
		MovedMessageCommand = cmd(hurrytweening,0.25;smooth,movetime;x,xspacing*-pos);
	}
	for i=-numfiles+1,numfiles-1 do
		ret[#ret+1] = LoadActor( files[i+numfiles] )..{
			InitCommand=cmd(ztest,true;x,xspacing*i)
		}
	end
	return ret
end
local t = Def.ActorFrame {
	FOV=90;
	InitCommand=cmd(sleep,0.2;queuecommand,"UnlockInput");
	UnlockInputCommand=function(self)
		lockedinput = false
	end;
	LoadActor( THEME:GetPathS( "_common", "value" ) )..{ MovedMessageCommand=cmd(play); };
	LoadActor( THEME:GetPathS( "Common", "start" ) )..{ MenuStartMessageCommand=cmd(play); };
	Def.Quad {
		InitCommand=cmd(diffuse,color("0,0,0");zwrite,1;blend,"BlendMode_NoEffect";zoomto,12,128;y,SCREEN_CENTER_Y;x,5);
	};
	Def.Quad {
		InitCommand=cmd(diffuse,color("0,0,0");zwrite,1;blend,"BlendMode_NoEffect";zoomto,12,128;y,SCREEN_CENTER_Y;x,SCREEN_WIDTH-6);
	};
	StandardDecorationFromFile("Body","body");
	StandardDecorationFromFile("Cursor","cursor");
	Def.ActorFrame {
		InitCommand=cmd(Center);
		Items();
		MenuStartMessageCommand=cmd(runcommandsonleaves,cmd(smooth,0.3;diffusealpha,0));
		LoadActor( THEME:GetPathG("","_arrow") )..{
			Name="LeftArrow";
			InitCommand=cmd(x,-82;diffusealpha,0.4;rotationz,-90;bounce;effectmagnitude,-6,0,0;effectperiod,0.75);
			FadeInCommand=cmd(smooth,0.3;x,-82;diffusealpha,0.4); FadeOutCommand=cmd(smooth,0.3;x,-100;diffusealpha,0);
		};
		LoadActor( THEME:GetPathG("","_arrow") )..{
			Name="RightArrow";
			InitCommand=cmd(x,82;diffusealpha,0.4;rotationz,90;bounce;effectmagnitude,6,0,0;effectperiod,0.75);
			FadeInCommand=cmd(smooth,0.3;x,82;diffusealpha,0.4); FadeOutCommand=cmd(smooth,0.3;x,100;diffusealpha,0);
		};
		LoadFont( "_myriad", "" )..{
			Name="Text";
			Text=msg[ind];
			InitCommand=cmd(y,-84;shadowlengthy,1);
			UpdateTextCommand=function(self)
				self:settext( msg[ind] )
			end;
			MovedMessageCommand=function(self)
				self:hurrytweening(0.25) -- try to prevent overflow
				self:smooth(movetime/2)
				self:rotationx(90)
				self:queuecommand("UpdateText")
				self:smooth(movetime/2)
				self:rotationx(0)
			end;
		};
		MovedMessageCommand=function(self) -- lazy, works.
			local left = self:GetChild("LeftArrow")
			local right = self:GetChild("RightArrow")
			left:hurrytweening(0.25)
			right:hurrytweening(0.25)
			if pos == maxdistance then
				right:playcommand("FadeOut")
				left:playcommand("FadeIn")
			elseif pos == -maxdistance then
				left:playcommand("FadeOut")
				right:playcommand("FadeIn")
			else
				right:playcommand("FadeIn")
				left:playcommand("FadeIn")
			end
		end;
	};
	PlayerJoinedMessageCommand=cmd(queuecommand,'Update');
	PlayerUnjoinedMessageCommand=cmd(queuecommand,'Update');
	OnCommand=cmd(queuecommand,'Update');
	UpdateCommand=function(self)
		UpdateInternal(self, PLAYER_1)
		UpdateInternal(self, PLAYER_2)
	end;
	CodeMessageCommand=function(self,params)
		if not lockedinput then
			if params.Name then
				MESSAGEMAN:Broadcast("Some", {Name = params.Name})
			end
			if params.Name == Key("Left") then
				ChangePos(-1)
				MESSAGEMAN:Broadcast("Moved")
			elseif params.Name == Key("Right") then
				ChangePos(1)
				MESSAGEMAN:Broadcast("Moved");
			elseif params.Name == Key("Start") then
				if start == false then -- don't want to run this more than once.
					if not GAMESTATE:IsHumanPlayer(params.PlayerNumber) then
						SCREENMAN:GetTopScreen():SetProfileIndex(params.PlayerNumber, -1)
						MESSAGEMAN:Broadcast("MenuStart")
						start = true
					end
				end
			elseif params.Name == 'Back' then
				SCREENMAN:GetTopScreen():Cancel()
			end
		end
	end;
	MenuStartMessageCommand=cmd(queuecommand,"Fade";sleep,fadetime+0.15;queuecommand,"Off");
	FadeCommand=function(self)
		if screens[ind] == "ScreenExit" or screens[ind] == "ScreenIntroMovie" then
			local fade = self:GetChild("Fade")
			fade:playcommand("FadeOut")
		end
	end;
	OffCommand=function(self)
		if start == true then
			local playerOne = GAMESTATE:IsHumanPlayer(PLAYER_1)
			local playerTwo = GAMESTATE:IsHumanPlayer(PLAYER_2)
			if not playerOne then
				GAMESTATE:ApplyGameCommand("applydefaultoptions;playmode,regular;style,single;difficulty,hard", PLAYER_2)
			else
				GAMESTATE:ApplyGameCommand("applydefaultoptions;playmode,regular;style,single;difficulty,hard", PLAYER_1)
			end
			SCREENMAN:SetNewScreen(screens[ind])
		end
	end;
}
t[#t+1] = StandardDecorationFromFileOptional("VersionInfo","version")
t[#t+1] = Def.Quad {
	Name="Fade";
	InitCommand=cmd(diffuse,color("0,0,0");diffusealpha,0;FullScreen);
	FadeOutCommand=cmd(smooth,fadetime;diffusealpha,1);
}
return t
