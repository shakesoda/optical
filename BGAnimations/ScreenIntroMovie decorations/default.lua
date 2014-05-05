local things = {
	-- toss in :awesome: a ton of times to that it shows up the most.
	Awesome = {"_face","_aghost","_ball","_cirno","_face","_face","_face","_face","_megacolbert"},
};

local rise = 0;
local index = math.random(1,9);

index = math.random(1,#things['Awesome']);
rise = "things/"..things['Awesome'][index];

local awesome = Def.ActorFrame {
	
	LoadActor(rise)..{
		InitCommand=cmd(zoom,0.8;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+205);
		OnCommand=cmd(linear,96;y,SCREEN_CENTER_Y;zoom,0.9);
	};
	LoadActor( "moon" )..{
		InitCommand=cmd(zoom,0.59;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+325);
		OnCommand=cmd(linear,101;y,SCREEN_BOTTOM+320;zoom,.55;rotationz,8);
	};
	-- header-type-crap lol
	LoadFont( "Common normal" )..{
		Text="2001 : A SPACE OPTICAL";
		InitCommand=cmd(x,SCREEN_CENTER_X;y,10;zoom,0.7;diffuse,color("#BBBBBB");diffusetopedge,color("#FFFFFF");shadowlength,0);
	};
};
return awesome;