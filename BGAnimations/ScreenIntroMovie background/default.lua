local bg = Def.ActorFrame {
	LoadActor( "space" )..{
		InitCommand=cmd(zoomtoheight,SCREEN_HEIGHT;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;diffuse,color("0,0,0,0.4"));
		OnCommand=cmd(linear,98;diffuse,color("1,1,1,1"))
	};
	LoadActor( "lol_clouds" )..{
		InitCommand=cmd(texcoordvelocity,.03,0.1;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;customtexturerect,0,0,1,1;stretchto,SCREEN_LEFT,SCREEN_TOP,SCREEN_RIGHT,SCREEN_BOTTOM;diffusealpha,0.015;blend,"BlendMode_Add");
	};
};
return bg;