local bFirstUpdate = true
local t = Def.ActorFrame {
	LoadActor("gradient_b")..{
		InitCommand=cmd(zoomtowidth,SCREEN_WIDTH+1;Center);
	};
	LoadActor("gradient_a")..{
		InitCommand=cmd(zoomtowidth,SCREEN_WIDTH+1;Center;playcommand,"Update");
		UpdateCommand=function(self)
			if GetUserPrefB("TimeChangingBackground") then
				local time = scale(Hour(),0,24,0,180)
				-- sinr instead of sind apparently. what a pain.
				time = math.sin(degtorad(time))
				if not bFirstUpdate then
					self:linear(300)
				else
					bFirstUpdate = false
				end
				self:diffusealpha(clamp(time,0.5,1))
				self:queuecommand("Update")
			end
		end;
	};
}
for i=1,3 do
t[#t+1] = LoadActor("clouds_a")..{
	InitCommand=function(self)
		self:FullScreen()
		self:blend("BlendMode_Add")
		self:diffuse({0.5,0.5,0.5})
		self:diffusealpha(0.04)
		self:customtexturerect(0,0,SCREEN_WIDTH/self:GetWidth(),SCREEN_HEIGHT/self:GetHeight())
		if i == 1 then
			self:texcoordvelocity(0.05,0.2)
		elseif i == 2 then
			self:texcoordvelocity(-0.05,0.15)
		else
			self:diffusealpha(0.03)
			self:texcoordvelocity(0,-0.125)
		end
	end;
}
end

t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(Center);
	LoadActor("cloud 2") .. {
		InitCommand=cmd(blend,"BlendMode_Add";diffusealpha,0.025;);
	};
	LoadActor("cloud 1") .. {
		InitCommand=cmd(blend,"BlendMode_Add";diffusealpha,0.04;);
	};
}

t[#t+1] = Def.ActorFrame {
	LoadActor( "spinna" )..{
		InitCommand=cmd(Center;spin;effectmagnitude,0,0,-10;zoom,.80;diffusealpha,0.05;blend,"BlendMode_Add");
	};
}

for i=1,2 do
t[#t+1] = LoadActor( "arrow" )..{
	InitCommand=cmd(diffusealpha,1;playcommand,"MakeNew");
	MakeNewCommand=function(self)
		self:blend("BlendMode_Add")
		self:diffusealpha(1 - math.random(0.2,0.5))
		self:diffusebottomedge(color("0.75,0.75,0.75"))
		self:x(math.random(0,SCREEN_WIDTH))
		self:y(SCREEN_HEIGHT+32)
		self:zoom(math.random(0.9,1.2))
		self:decelerate(0.30)
		self:addy(-SCREEN_HEIGHT+math.random(60,210))
		self:decelerate(0.4)
		self:addy(-20)
		self:decelerate(0.1)
		self:addy(-150)
		self:diffusealpha(0)
		self:sleep(math.random(0.3,0.9))
		self:queuecommand("MakeNew")
	end;
}
end

t[#t+1] = Def.ActorFrame {
	LoadActor( "spinna" )..{
		InitCommand=cmd(Center;spin;effectmagnitude,0,0,20;zoom,.88;diffuse,color("#00000088"));
	};
}

return t