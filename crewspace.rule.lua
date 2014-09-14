-- Support for unconventional crew spaces
-- crewspace.rule.lua
-- by Starstrider42
-- Created June 17, 2014
-- Last modified September 13, 2014

for name,part in pairs(PARTS) do
	-- Allow pods to be both manned and unmanned, if they can hold crew but can operate without one
	if part.crewCapacity ~= 0 and part.crewCapacity ~= "0" then
		for module in modulesByName(part,"ModuleCommand") do		
			if module.values.minimumCrew == "0" then			
				addToModCategory(part, "Pod/Manned")
				addToModCategory(part, "Pod/Unmanned")
				addToModCategory(part, "Pod/Hybrid", nil, "Categories/Pods/Misc")
				break
			end		
		end
	end
end	-- end part loop
