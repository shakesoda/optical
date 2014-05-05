local cursoralpha = 0.1

local sleeptime = 0
local fadetime = 0.5

local corner = THEME:GetPathG("","_corner")

local cursor = Def.ActorFrame {
	Name="Cursor";
	-- top left, center, right, middle, bottom left, center, right
	MenuStartMessageCommand=cmd(runcommandsonleaves,cmd(smooth,0.3;diffusealpha,0));
	LoadActor( corner )..{
		InitCommand=cmd(x,-64;y,-64;diffusealpha,0);
		OnCommand=cmd(sleep,sleeptime;smooth,fadetime;diffusealpha,cursoralpha);
	};
	Def.Quad {
		InitCommand=cmd(y,-64;diffusealpha,0;zoomto,120,8);
		OnCommand=cmd(sleep,sleeptime;smooth,fadetime;diffusealpha,cursoralpha);
	};
	LoadActor( corner )..{
		InitCommand=cmd(x,64;y,-64;rotationz,90;diffusealpha,0);
		OnCommand=cmd(sleep,sleeptime;smooth,fadetime;diffusealpha,cursoralpha);
	};
	Def.Quad {
		InitCommand=cmd(diffusealpha,0;zoomto,136,120);
		OnCommand=cmd(sleep,sleeptime;smooth,fadetime;diffusealpha,cursoralpha);
	};
	LoadActor( corner )..{
		InitCommand=cmd(x,-64;y,64;rotationz,-90;diffusealpha,0);
		OnCommand=cmd(sleep,sleeptime;smooth,fadetime;diffusealpha,cursoralpha);
	};
	Def.Quad {
		InitCommand=cmd(y,64;diffusealpha,0;zoomto,120,8);
		OnCommand=cmd(sleep,sleeptime;smooth,fadetime;diffusealpha,cursoralpha);
	};
	LoadActor( corner )..{
		InitCommand=cmd(x,64;y,64;rotationz,180;diffusealpha,0);
		OnCommand=cmd(sleep,sleeptime;smooth,fadetime;diffusealpha,cursoralpha);
	};
};
return cursor;