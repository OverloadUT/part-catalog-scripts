-- Support for modules defined by Kerbal Attachment System
-- KAS.rule.lua
-- by Starstrider42
-- Created June 17, 2014
-- Last modified July 2, 2014

for name,part in pairs(PARTS) do
	if containsModule(part, "KASModuleStrut") then
		local fuelLine = false
		for connectable in modulesByName(part, "KASModuleStrut") do
			if connectable.values.allowPumpFuel == "true" then
				fuelLine = true
			end
		end
		if fuelLine then
			addToModCategory(part, "Storage/Transfer")
		else
			addToModCategory(part, "Structural/StrutConnector")
		end
	end

	if containsModule(part, {"KASModuleContainer", "KASModulePartBay"}) then
		addToModCategory(part, "Structural/Compartment")
	end
	if part.name == "KAS.Pylon1" then
		addToModCategory(part, "Structural/GroundSupport")
	end
end	-- end part loop
