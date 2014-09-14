-- Support for KASModuleGrab
-- KAS.fallback.lua
-- by Starstrider42
-- Created September 13, 2014
-- Last modified September 13, 2014

for name,part in pairs(PARTS) do
	-- Placed here to ensure that Grabbability does not interfere with categories 
	--	defined in default.fallback.lua
	if containsModule(part, "KASModuleGrab") then
		addToModCategory(part, "Utility/Grabbable")
	end
end	-- end part loop
