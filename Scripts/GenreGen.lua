-- GenreGen, Version 1.1
-- Written by Vyhd (http://boxorroxors.net/)

-- Licensed under Creative Commons Attribution-Share Alike 3.0 Unported
-- ( http://creativecommons.org/licenses/by-sa/3.0/ )
-- All I ask is that you keep this notice intact. :)

-- Callable functions:
-- GenreGen.Generate() - generates a genre from GAMESTATE's current song
-- GenreGen.GenerateFromSong( song ) - generates a genre from a specified song

-- LUA 5.0 compatibility call
local function GetRandom( tbl )
	local max = table.getn(tbl)
	return tbl[math.random(max)]	
end

-- I love having an excuse to name functions like this.
local function IsKyleWard( artist )
	-- that last one is Smiley, if you didn't know.
	local KeeL_aliases = { "Banzai", "Inspector K", "KaW", "KBit", "KeeL", "☺" };

	for i=1,table.getn(KeeL_aliases) do
		if artist == KeeL_aliases[i] then return true end
	end

	return false
end

local function GetGenreString( song, num )
	-- first, a few Easter eggs...

	-- if this is a patched OGG, then set this genre instead.
	if song:MusicLengthSeconds() == 105 then return "Crunchy H4X" end

	local artist = song:GetTranslitArtist()

	-- lol hi dax :>
	if artist == "Dax" then return "Alternative Crapcore" end

	-- now that we've had our fun, create the genre string
	local sRet = ""

	-- this seems backward, because the random() calls are made in
	-- the same order as older scripts to generate the same genres.
	if num >= 3 then sRet = sRet .. GetRandom(GenreGen.Defs.Desc2) .. " " end
	if num >= 2 then sRet = sRet .. GetRandom(GenreGen.Defs.Desc1) .. " " end

	-- lol hi kyle :>
	if IsKyleWard( artist ) then
		sRet = sRet .. "K-" .. GetRandom(GenreGen.Defs.Main)
	else
		sRet = sRet .. GetRandom(GenreGen.Defs.Main)
	end

	return sRet
end

-- alias function for current song
function GenreGen.Generate()
	return GenreGen.GenerateFromSong( GAMESTATE:GetCurrentSong() )
end

function GenreGen.GenerateFromSong( song )
	if not song then return "" end

	-- randomseed truncates float values, but we need more randomness.
	-- move the number over several digits to compensate.
	local factor = 10000
	math.randomseed( factor*song:MusicLengthSeconds() )

	-- Vary the amount of words returned, based on the seed.
	local rand = math.random()

	-- chances for word amount:
	-- 2/10 for one, 7/10 for two, 1/10 for three
	if rand < 0.2 then num = 1
	elseif rand > 0.9 then num = 3
	else num = 2 end

	return GetGenreString( song, num )
end