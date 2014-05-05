local t = Def.ActorFrame {
	LoadSongBackground()..{
		InitCommand=cmd(FullScreen;diffusealpha,0);
		OnCommand=cmd(accelerate,0.5;diffusealpha,1;sleep,0.25);
		CancelMessageCommand=cmd(stoptweening;decelerate,0.5;diffusealpha,0);
	}
};
return t;