-- Support for alternative science modules defined by Station Science
-- StationScience.rule.lua
-- by Starstrider42
-- Created September 13, 2014
-- Last modified September 13, 2014

for name,part in pairs(PARTS) do
	if containsModule(part, "StationExperiment") or containsModule(part, "SampleAnalyzer") then
		addToModCategory(part, "Science/Experiment")
	end	

	if containsModule(part, "ResearchFacility") then
		addToModCategory(part, "Science/Misc")
	end	
end	-- end part loop
