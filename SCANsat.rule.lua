-- Support for antennas defined by SCANsat
-- SCANsat.rule.lua
-- by Starstrider42
-- Created June 17, 2014
-- Last modified July 2, 2014

-- From http://lua-users.org/wiki/BitUtils
-- Note that this function can only test one flag at a time :(
function testflag(set, flag)
  return set % (2*flag) >= flag
end

for name,part in pairs(PARTS) do
	for scanner in modulesByName(part, "SCANsat") do
		if tonumber(scanner.values.sensorType) ~= 0 then
			addToModCategory(part, "Science/Survey", nil, nil, true)
		end

		if testflag(scanner.values.sensorType, 1) or testflag(scanner.values.sensorType, 2) then
			addToModCategory(part, "Science/Survey/Altimetry", nil, nil, true)
		end
		if testflag(scanner.values.sensorType, 8) then
			addToModCategory(part, "Science/Survey/Biome", nil, nil, true)
		end
		if testflag(scanner.values.sensorType, 16) or testflag(scanner.values.sensorType, 32) then
			addToModCategory(part, "Science/Survey/Anomaly", nil, nil, true)
		end
	end
end	-- end part loop
