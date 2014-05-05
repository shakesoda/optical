return Def.Actor {
	StartTransitioningCommand=function(self)
		MESSAGEMAN:Broadcast("Cancel")
		self:sleep(0.5)
	end;
}