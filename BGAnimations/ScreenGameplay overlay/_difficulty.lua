-- thanks again to AJ for code that is sane.

local DifficultyStates = {
	Difficulty_Beginner = 0,
	Difficulty_Easy = 1,
	Difficulty_Medium = 2,
	Difficulty_Hard = 3,
	Difficulty_Challenge = 4,
	Difficulty_Edit = 5
};

local difficulties = Def.ActorFrame {
	-- P1
	LoadActor( "_diffs" )..{
		InitCommand=cmd(animate,false;diffusealpha,0.5;x,SCREEN_LEFT;horizalign,left;y,SCREEN_TOP;vertalign,top;blend,"BlendMode_Add";playcommand,"Load");
		LoadCommand=function(self,params)
			if GAMESTATE:IsSideJoined(PLAYER_1) then
				local steps = GAMESTATE:GetCurrentSteps(PLAYER_1);
				local difficulty = steps:GetDifficulty();
				self:setstate( DifficultyStates[difficulty] );
			else
				self:visible(false);
			end
		end
	};
	-- P2
	LoadActor( "_diffs" )..{
		InitCommand=cmd(animate,false;diffusealpha,0.5;x,SCREEN_RIGHT;zoomx,-1;horizalign,left;y,SCREEN_TOP;vertalign,top;blend,"BlendMode_Add";playcommand,"Load");
		LoadCommand=function(self,params)
			if GAMESTATE:IsSideJoined(PLAYER_2) then
				local steps = GAMESTATE:GetCurrentSteps(PLAYER_2);
				local difficulty = steps:GetDifficulty();
				self:setstate( DifficultyStates[difficulty] );
			else
				self:visible(false);
			end
		end
	};
};
return difficulties;