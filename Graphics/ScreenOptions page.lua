--[[ for some old eval thing I need to fix
local graphy = SCREEN_CENTER_Y+185;
	LoadActor("ScreenEvaluationStage overlay/life graph", PLAYER_1) .. {
		InitCommand = cmd(x,SCREEN_LEFT+100;y,graphy);
	};
	LoadActor("ScreenEvaluationStage overlay/life graph", PLAYER_2) .. {
		InitCommand = cmd(x,SCREEN_RIGHT-100;y,graphy);
	};
]]

local t = Def.ActorFrame {
-- mid
	Def.Quad {
		InitCommand=cmd(zoomto,SCREEN_WIDTH,SCREEN_HEIGHT-260;y,SCREEN_CENTER_Y;x,SCREEN_CENTER_X;diffuse,color("#222222dd");diffusetopedge,color("#000000dd"));
	};
-- top
	Def.Quad {
		InitCommand=cmd(zoomto,SCREEN_WIDTH,100;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-160;diffuse,color("#000000dd");diffusetopedge,color("#000000aa"));
	};
	Def.Quad {
		InitCommand=cmd(zoomto,SCREEN_WIDTH,50;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-160;vertalign,bottom;diffuse,color("#ffffff08");diffusetopedge,color("#ffffff33"));
	};
-- bottom
	Def.Quad {
		InitCommand=cmd(zoomto,SCREEN_WIDTH,100;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+160;diffuse,color("#000000dd");diffusetopedge,color("#222222dd"));
	};
	Def.Quad {
		InitCommand=cmd(zoomto,SCREEN_WIDTH,50;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+160;vertalign,top;diffuse,color("#00000066");diffusetopedge,color("#00000022"));
	};
};
return t;