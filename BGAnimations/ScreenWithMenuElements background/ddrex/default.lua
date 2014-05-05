local t = Def.ActorFrame {
	LoadActor("bg_" .. GetAspectName()) .. {
		InitCommand=cmd(Center;SetTextureFiltering,false);
		OnCommand=function(self)
			if GetAspect() > 1.7 then -- FATTA THAN YO MAMA
				self:rainbow();
			end;
		end;
	};
	-- LoadActor("time") .. {
	-- 	InitCommand=cmd(x,SCREEN_RIGHT-(640-582);y,26;SetTextureFiltering,false);
	-- };
};
return t;