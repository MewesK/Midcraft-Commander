-----------------------------------------------------------------------------
-- Midcraft Commander
-- Author: MewK
-- Version: 0.2
--
-- This program is released under the MIT License (MIT).
-----------------------------------------------------------------------------

local w, h = term.getSize()
local hw = math.floor(w / 2)

function trimText(text, width)
	if width > 6 and # text > 0 and # text > width then
		text = string.sub(text, 0, width - 3)..'...'
	end
	return text
end

function drawLineH(x, y, length)
    term.setCursorPos(x, y)
	for i = 1, length do
		term.write('-')
	end
end

function drawLabeledLineH(x, y, length, text)
	text = trimText(text, length - 5)
	drawLineH(x, y, length)
    term.setCursorPos(x + 1, y)
	term.write(' '..text..' ')
end

function drawLineV(x, y, length)
	for i = 0, length - 1 do
		term.setCursorPos(x, y + i)
		if i == 0 or i == length - 1 then
			term.write('+')
		else
			term.write('|')
		end
	end
end

function drawEntries(view, clipboard, clipboardAction, buildPath)
	local y = 0
	local _start = view.scrollOffset + 1
	local _end = view.scrollOffset + view.height
	
	if _end > # view.entryList then
		_end = # view.entryList
	end
	
	for index = _start, _end do
		local entry = view.entryList[index]
		local _entry = trimText(entry, view.width - 4)
		local __entry = buildPath(view.currentDirectory, entry)
		
		local selected = false
		for index, value in ipairs(clipboard) do
			if value == __entry then
				selected = true
				break
			end
		end
		
		-- Position indicator
		if view.active and view.selectionIndex == index then
			_entry = '» '.._entry
		else
			_entry = '  '.._entry
		end
		
		-- Selection indicator
		if selected then
			-- Default indicator
			if clipboardAction == 0 then
				_entry = _entry..' ?'
				
			-- Copy indicator
			elseif clipboardAction == 1 then
				_entry = _entry..' +'

			-- Cut indicator
			elseif clipboardAction == 2 then
				_entry = _entry..' -'
				
			end
		end
		
		term.setCursorPos(view.x, view.y + y)
		term.write(_entry)
		
		y = y + 1
	end
end

function drawMenu(x, y, menuFunctions, menuItemSelection)
	term.setCursorPos(x, y)
	term.clearLine()
	for index, menuFunction in ipairs(menuFunctions) do
		if menuItemSelection and index == menuItemSelection then
			term.write('['..menuFunction.name..']')
		else
			term.write(' '..menuFunction.name..' ')
		end
	end
end

function test() error('mmm') end