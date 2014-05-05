local t = Def.ActorFrame {
	Name="Main";
	InitCommand=cmd(x,SCREEN_CENTER_X);
	Def.ActorFrame {
		Name="LifebarFrame";
		Def.Quad {
			Name="Lifebar";
			InitCommand=cmd(diffuse,color("0,0,0.5");horizalign,left;diffusealpha,0.7;cropright,0.5;zoomto,420,20;x,-210;y,25);
			LifeChangedMessageCommand=function(self,params)
				if params.Player == PLAYER_1 then
					local life = params.LifeMeter:GetLife();
					self:finishtweening();
					self:decelerate(0.12);
					if life < 1 then
						self:cropright( 1 - life );
					else
						self:cropright( 2 - life );
					end;
					if life >= 0.95 and life <= 1.95 then -- doing good
						self:diffuse(color("0.5,0,0"));
						self:diffusetopedge(color("1,0,0"));
					elseif life > 1.95 then -- doing awesome
						self:diffuse(color("0.5,0.25,0"));
						self:diffusetopedge(color("1,0.75,0"));						
					elseif life <= 0.25 then -- very danger!!
						self:diffuse(color("0,0.5,0"));
						self:diffusetopedge(color("0,1,0"));
					else
						self:diffuse(color("0,0,0.5"));
						self:diffusetopedge(color("0,0,1"));
					end
				end
			end
		};
		Def.SongMeterDisplay {
			StreamWidth=SCREEN_WIDTH;
			Stream=Def.Quad {};
			Tip=Def.Quad{ InitCommand=cmd(zoomto,2,8); };
			InitCommand=cmd(y,10);
		};
	};
};
return t;