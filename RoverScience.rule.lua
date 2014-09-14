-- Support for modules defined by RoverScience
-- RoverScience.rule.lua
-- by Starstrider42
-- Created June 17, 2014
-- Last modified June 17, 2014

for name,part in pairs(PARTS) do
	if containsModule(part, "RoverScience") then
		addToModCategory(part, "Science/Experiment")
	end

end	-- end part loop
