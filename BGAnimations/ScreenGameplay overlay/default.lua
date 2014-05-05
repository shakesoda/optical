local bFirstUpdate = { true, true };
local t = Def.ActorFrame {
	Def.Quad { InitCommand=cmd(x,SCREEN_CENTER_X;y,15;stretchto,0,0,SCREEN_WIDTH,18;diffuse,color("#000000")); };
	LoadActor( "_fill" )..{
		InitCommand=cmd(hide_if,not GAMESTATE:IsSideJoined(PLAYER_1);x,SCREEN_CENTER_X;y,15;stretchto,0,0,SCREEN_WIDTH/2,15);
		LifeChangedMessageCommand=function(self,params)
			if params.Player == PLAYER_1 then
				local life = params.LifeMeter:GetLife()
				self:stoptweening()
				self:linear(0.25)
				if life > 1 then
					self:diffuse(color("1,0.25,0,1"))
				else
					self:diffuse(color("1,1,1,1"))
				end
			end
		end;
	};
	Def.Quad{
		InitCommand=cmd(x,SCREEN_CENTER_X;y,15;stretchto,0,0,SCREEN_WIDTH/2,15;diffuse,color("#00000055");diffusetopedge,color("#000000FF");diffuserightedge,color("#000000FF"));
		OnCommand=cmd(playcommand,"LifeChangedMessage");
		LifeChangedMessageCommand=function(self,params)
			if params.Player == PLAYER_1 then
				local life = params.LifeMeter:GetLife()
				self:finishtweening()
				if bFirstUpdate[1] then
					self:sleep(0.125)
					self:smooth(0.5)
					bFirstUpdate[1] = false
				else
					self:linear(0.05)
				end
				self:cropleft(clamp(life,0,1))
			end
		end;
		Condition=GAMESTATE:IsSideJoined(PLAYER_1);
	};
	LoadActor( "_life" )..{ InitCommand=cmd(x,SCREEN_CENTER_X;y,15;stretchto,0,0,SCREEN_WIDTH/2,30); };
	LoadActor( "_fill" )..{
		InitCommand=cmd(hide_if,not GAMESTATE:IsSideJoined(PLAYER_2);x,SCREEN_CENTER_X;y,15;stretchto,SCREEN_CENTER_X,0,SCREEN_RIGHT,15;rotationz,180);
		LifeChangedMessageCommand=function(self,params)
			if params.Player == PLAYER_2 then
				local life = params.LifeMeter:GetLife()
				self:stoptweening()
				self:linear(0.25)
				if life > 1 then
					self:diffuse(color("1,0.25,0,1"))
				else
					self:diffuse(color("1,1,1,1"))
				end
			end
		end;
	};
	Def.Quad{
		InitCommand=cmd(x,SCREEN_CENTER_X;y,15;stretchto,SCREEN_CENTER_X,0,SCREEN_RIGHT,15;diffuse,color("#00000055");diffusetopedge,color("#000000FF");diffuseleftedge,color("#000000FF"));
		OnCommand=cmd(playcommand,"Update");
		LifeChangedMessageCommand=function(self, params)
			if params.Player == PLAYER_2 then
				local life = params.LifeMeter:GetLife()
				self:finishtweening()
				if bFirstUpdate[2] then
					self:sleep(0.125)
					self:smooth(0.5)
					bFirstUpdate[2] = false
				else
					self:linear(0.05)
				end
				self:cropright(clamp(life,0,1))
			end
		end;
		Condition=GAMESTATE:IsSideJoined(PLAYER_2);
	};
	LoadActor( "_life" )..{ InitCommand=cmd(x,SCREEN_CENTER_X;y,15;stretchto,SCREEN_CENTER_X,0,SCREEN_RIGHT,30); };
	Def.Quad{ InitCommand=cmd(stretchto,0,0,2,20;x,SCREEN_CENTER_X;diffuse,color("#aaaaaa");diffusetopedge,color("#ffffff")); };
	Def.SongMeterDisplay {
		StreamWidth=SCREEN_WIDTH-2;
		Stream=Def.Quad { InitCommand=cmd(diffusealpha,0.2); };
		Tip=Def.Quad{ InitCommand=cmd(zoomto,2,6); };
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_TOP+10.5);
	};
	LoadActor( "_difficulty" );
	-- LoadActor("_fuck"); -- FUCK!!
};
return t;