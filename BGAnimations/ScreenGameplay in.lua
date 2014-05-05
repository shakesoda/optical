local t = Def.ActorFrame {
	LoadSongBackground()..{
		InitCommand=cmd(FullScreen;diffusealpha,1);
		OnCommand=cmd(decelerate,0.5;diffusealpha,0);		
	}
};
return t;