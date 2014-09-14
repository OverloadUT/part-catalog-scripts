-- Support for airbag parts from any of several mods
-- airbags.rule.lua
-- by Starstrider42
-- Created June 27, 2014
-- Last modified June 27, 2014

for name,part in pairs(PARTS) do
	if part.name:lower():find("airbag") then	
		addToModCategory(part,"Utility/Landing/Airbag")
	end	
end	-- end part loop
