return Def.ActorFrame {
	Def.RoundedBox(120,SCREEN_HEIGHT-16)..{
		InitCommand=cmd(x,64;y,SCREEN_CENTER_Y);
	};
	Def.RoundedBox(120,SCREEN_HEIGHT-16)..{
		InitCommand=cmd(x,SCREEN_WIDTH-64;y,SCREEN_CENTER_Y);
	};
	Def.Quad {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;diffuse,color("0,0,0,0.85");zoomto,300,SCREEN_HEIGHT);
	};
}