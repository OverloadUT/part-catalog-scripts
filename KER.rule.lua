-- Support for modules defined by Kerbal Engineer Redux
-- KER.rule.lua
-- by Starstrider42
-- Created June 17, 2014
-- Last modified September 13, 2014

for name,part in pairs(PARTS) do
	-- Filter out configs that add KER to command pods
	if part.name:find("Engineer") then
		if containsModule(part, "FlightEngineerModule") then
			addToModCategory(part, "Science/Sensor")
		end
	end

end	-- end part loop
