local t = Def.ActorFrame {}

t[#t+1] = LoadActor(GetUserPref("BackgroundMode"))

if GetUserPrefB("ShowBackgroundLogo") then
t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(Center);
	LoadActor(THEME:GetPathG("","_logo"))..{
		InitCommand=function(self)
			self:zoom(1.035)
			if GetUserPref("BackgroundMode") == "optical" then
				self:diffuse(color("0,0,0,0.075"))
			else
				self:diffuse(color("0,0,0,0.05"))
			end
		end;
	};
	LoadActor(THEME:GetPathG("","_logo"))..{
		InitCommand=cmd(diffuseramp;effectclock,"beat";effectcolor1,color("1,1,1,0.1");effectcolor2,color("1,1,1,0.2"));
	};
}
end

return t;