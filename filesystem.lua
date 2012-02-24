-----------------------------------------------------------------------------
-- Midcraft Commander
-- Author: MewK
-- Version: 0.2
--
-- This program is released under the MIT License (MIT).
-----------------------------------------------------------------------------

local w, h = term.getSize()
local hw = math.floor(w / 2)
	
function buildPath(path, name)
	return '/' .. fs.combine(path or '', name or '')
end

function moveEntry(source, destination, copyMode, forceOverwrite)
	-- Input validation
	if not source or not destination or not fs.exists(source) then
		return 0
	end

	-- File equals
	if source == destination then
		return -1
	end

	-- File exists		
	if fs.exists(destination) then
		local overwrite
		
		if forceOverwrite then
			overwrite = 'y'
		else
			term.setCursorPos(1, h)
			term.clearLine()
			overwrite = read('File exists. Overwrite? (y/n): ', nil)
		end
			
		if overwrite == 'y' then
			fs.delete(destination)
			if copyMode then
				fs.copy(source, destination)
			else
				fs.move(source, destination)
			end
			return 2
		else
			return -2
		end
	else
		if copyMode then
			fs.copy(source, destination)
		else
			fs.move(source, destination)
		end
		return 1
	end
end

function listEntries(path)
	-- Sort into dirs/files
	local files = {}
	local dirs = {}

	if path ~= '/' then
		table.insert(dirs, '/..')
	end
	
	for index, entry in pairs(fs.list(path)) do
		local sPath = buildPath(path, entry)
		if fs.isDir(sPath) then
			table.insert(dirs, '/'..entry)
		else
			table.insert(files, entry)
		end
	end
				
	table.sort(dirs)
	table.sort(files)
	
	for index, file in ipairs(files) do
		table.insert(dirs, file)
	end
	
	return dirs
end

function runProgram(path, ...)
	term.clear()
	term.setCursorPos(1, 1)
	shell.run(path, ...)
	
	-- Wait for user action if text is on screen
	local cx,cy = term.getCursorPos()
	if cx ~= 1 or cy ~= 1 then
		local text = '< Press any key to continue >'
		term.setCursorPos(hw - math.floor(string.len(text) / 2), h)
		term.clearLine()
		term.write(text)
		
		repeat
			local event, param = os.pullEvent()
		until event == 'key'
	end
end

function parseCommand(command)
	local words = {}
	for match in string.gmatch(command, "[^ \t]+") do
		table.insert(words, match)
	end

	if words[1] then
		runProgram(words[1], unpack(words, 2))
	end
end