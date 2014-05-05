local t = Def.ActorFrame {
	Def.ActorFrame {
		FOV=90;
		LoadActor( "CJ108" )..{
			InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;scale_or_crop_background;diffusealpha,0.125);
		};
		LoadActor( "stream" )..{
			InitCommand=cmd(z,240;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoomto,SCREEN_WIDTH*2,SCREEN_HEIGHT*2;);
			OnCommand=cmd(blend,"BlendMode_Add";diffusealpha,0.03;rotationx,-15;customtexturerect,0,0,SCREEN_WIDTH/256*2,SCREEN_HEIGHT/256*2;texcoordvelocity,0.25,0);
		};
		LoadActor( "../shared/_noise" )..{
			InitCommand=cmd(diffusealpha,0.1;blend,"BlendMode_Add");
		};
	};
	LoadActor( "stripes" )..{
		InitCommand=cmd(diffusetopedge,color("0,0.5,0.5");x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoomx,2;texcoordvelocity,-0.05,0;diffusealpha,0.25;skewx,0.12);
	};
	LoadActor( "stripes" )..{
		InitCommand=cmd(diffusetopedge,color("0.5,0.5,0.5");x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoomx,2;zoomy,-1;texcoordvelocity,0.025,0;diffusealpha,0.1;skewx,-0.2);
	};
}
t[#t+1] = LoadActor( "shade" )..{
	InitCommand=cmd(Center;zoomto,SCREEN_WIDTH+2,SCREEN_HEIGHT;blend,"BlendMode_WeightedMultiply");
}
if GetUserPrefB("ShowBackgroundLights") then
t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y);
	LoadActor("lights") .. {
		InitCommand=cmd(rotationz,90;blend,"BlendMode_Add";zoomtowidth,SCREEN_HEIGHT+75;zoomtoheight,30;diffusealpha,0.35;x,-SCREEN_CENTER_X-8;y,0;diffuseramp;effectclock,'beat');
	};
	LoadActor("lights") .. {
		InitCommand=cmd(rotationz,-90;blend,"BlendMode_Add";zoomtowidth,SCREEN_HEIGHT+75;zoomtoheight,30;diffusealpha,0.35;x,SCREEN_CENTER_X+8;y,0;diffuseramp;effectclock,'beat');
	};
};
end

return t