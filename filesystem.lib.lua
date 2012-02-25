-----------------------------------------------------------------------------
-- Midcraft Commander
-- Author: MewK
-- Version: 0.2
--
-- This program is released under the MIT License (MIT).
-----------------------------------------------------------------------------

local w, h = term.getSize()
local hw = math.floor(w / 2)

function buildPath(entry, name)
	if entry and entry.fullpath then
		return '/' .. fs.combine(entry.fullpath, name or '')
	end
	return '/' .. fs.combine(entry or '', name or '')
end

function createEntry(_path, _name, _type, _action, _meta)
	return {
		['path'] = _path,
		['name'] = _name,
		['fullpath'] = buildPath(_path, _name),
		['type'] = _type,
		['action'] = _action,
		['meta'] = _meta
	}
end

function createEntryFromPath(_path, _type)
	_path = buildPath(_path)
	if _path == '/' then
		return createEntry('/', '/', 0)
	else
		local _name = buildPath(fs.getName(_path))
		return createEntry(string.gsub(_path, _name, ''), _name, 0)
	end
end

function compareEntries(entry1, entry2) 
	return entry1.fullpath < entry2.fullpath
end

function moveEntry(entry, destination, copyMode, forceOverwrite)
	-- Input validation
	if not entry or not entry.fullpath or not fs.exists(entry.fullpath) or not destination then
		return 0
	end

	-- File equals
	if entry.fullpath == destination then
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
				fs.copy(entry.fullpath, destination)
			else
				fs.move(entry.fullpath, destination)
			end
			return 2
		else
			return -2
		end
	else
		if copyMode then
			fs.copy(entry.fullpath, destination)
		else
			fs.move(entry.fullpath, destination)
		end
		return 1
	end
end

function listEntries(folder, virtualEntries)
	-- Sort into dirs/files
	local dirs = {}
	local files = {}
	
	-- Get files and folders
	if folder.fullpath ~= '/' then
		table.insert(dirs, createEntry(folder.fullpath, '..', 0))	-- 0 = open
	end
	
	if fs.exists(folder.fullpath) then
		for index, entry in ipairs(fs.list(folder.fullpath)) do
			if fs.isDir(buildPath(folder, entry)) then
				table.insert(dirs, createEntry(folder.fullpath, entry, 0))	-- 0 = open
			else
				table.insert(files, createEntry(folder.fullpath, entry, 1))	-- 1 = run
			end
		end
	end	
	
	-- Handle virtual entries
	for index, entry in ipairs(virtualEntries) do
		-- virtual entry
		if entry.path == folder.fullpath then
			table.insert(dirs, entry)	-- 0 = folder/open
		
		-- virtual folder
		elseif entry.fullpath == folder.fullpath and entry.action then
			for index, _entry in ipairs(entry.action(entry)) do
				if _entry.type == 0 then
					table.insert(dirs, _entry)	-- 0 = open
				else
					table.insert(files, _entry)	-- 1 = run
				end
			end
		end
	end
	
	-- Sort tables
	table.sort(dirs, compareEntries)
	table.sort(files, compareEntries)
	
	for index, file in ipairs(files) do
		table.insert(dirs, file)
	end
	
	return dirs
end

function runProgram(path, ...)
	path = shell.resolveProgram(path)
	if path ~= nil then
		term.clear()
		term.setCursorPos(1, 1)
		
		if false then
			shell.run('shell', path, ...)
		else
			shell.run(path, ...)
			-- Wait for user action if text is on screen
			local cx,cy = term.getCursorPos()
			if cx ~= 1 or cy ~= 1 then
				local text = 'Press any key to continue'
				
				term.setCursorPos(hw - math.floor(string.len(text) / 2), h)
				term.clearLine()
				term.write(text)
				
				os.pullEvent('key')
			end
		end

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