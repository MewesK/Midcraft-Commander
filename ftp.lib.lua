-----------------------------------------------------------------------------
-- Midcraft Commander
-- Author: MewK
--
-- This program is released under the MIT License (MIT).
-----------------------------------------------------------------------------

function ftpListModems()
	local modems = {}
	for index, side in ipairs(redstone.getSides()) do
		if peripheral.isPresent(side) and peripheral.getType(side) == 'modem' then
			table.insert(modems, {
				['side'] = side,
			})
			for _index, method in ipairs(peripheral.getMethods(side)) do
				print(_index)
				print(method)
			end
		end
	end
end

function ftpAuth(password)
end

function ftpAuth(password)
end

function ftpListEntries(folder)
end

function ftpListVirtualEntries(folder)
end

function ftpCommandParam(command, entry, ...)
end

function ftpSendEntry(entry)
end

function ftpRequestEntry(entry)
end

function ftpCheckRights(entry)
end

ftpListModems()