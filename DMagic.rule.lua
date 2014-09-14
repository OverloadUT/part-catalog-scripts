-- Support for alternative science modules defined by DMagic Orbital Science
-- DMagic.rule.lua
-- by Starstrider42
-- Created June 17, 2014
-- Last modified June 17, 2014

for name,part in pairs(PARTS) do
	if containsModule(part, "DMEnviroSensor") or containsModule(part, "DMMagBoomModule") then	
		addToModCategory(part, "Science/Sensor")
	end	
	if containsModule(part, "DMModuleScienceAnimate") or containsModule(part, "DMAnomalyScanner") 
		or containsModule(part, "DMBioDrill") then
		addToModCategory(part, "Science/Experiment")
	end	
end	-- end part loop
