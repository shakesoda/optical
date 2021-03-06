return Def.ActorFrame {
	Name="Arrows";
	LoadActor(THEME:GetPathG("","_arrow"))..{
		InitCommand=cmd(diffusealpha,0;y,-32);
		PreviousSongMessageCommand=function(self)
			self:stoptweening()
			self:diffusealpha(1)
			self:decelerate(0.4)
			self:diffusealpha(0)
		end;
	};
	LoadActor(THEME:GetPathG("","_arrow"))..{
		InitCommand=cmd(diffusealpha,0;rotationz,180;y,32);
		NextSongMessageCommand=function(self)
			self:stoptweening()
			self:diffusealpha(1)
			self:decelerate(0.4)
			self:diffusealpha(0)
		end;
	};
};