-- Support for modules defined by Smart Parts
-- SmartParts.rule.lua
-- by Starstrider42
-- Created June 17, 2014
-- Last modified June 17, 2014

for name,part in pairs(PARTS) do
	if containsModule(part, "KM_FuelController") then
		addToModCategory(part, "Storage/Transfer")
	end
	if containsModule(part, "KM_Flameout_Checker") or containsModule(part, "KM_Stager") then
		addToModCategory(part, "Science/Sensor")
	end
	if containsModule(part, "KM_Altimeter") then
		addToModCategory(part, "Science/Sensor")
	end
end	-- end part loop
