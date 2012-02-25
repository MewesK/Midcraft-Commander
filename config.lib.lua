-----------------------------------------------------------------------------
-- Midcraft Commander
-- Author: MewK
-- Version: 0.5
--
-- This program is released under the MIT License (MIT).
-----------------------------------------------------------------------------

function loadConfig(path, defaultConfig)
	-- Load saved config
	local savedConfig = {}
	if fs.exists(path) then
		local file = fs.open(path, 'r')
		if file then
			local data = file.readAll()
			savedConfig = textutils.unserialize(data)
			file.close()
		else     
			error('Could not open file')
		end
	end
	
	-- Merge configs
	for name, value in pairs(savedConfig) do
		defaultConfig[name] = value
	end
	
	return defaultConfig
end

function saveConfig(path, config)
	local file = fs.open(path, 'w')
	if file then
		file.write(textutils.serialize(config))
		file.close()
	else     
		error('Could not open file')
	end
end