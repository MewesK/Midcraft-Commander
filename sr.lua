rednet.open('back')

while true do
	sleep(0.1)
	local event, cpu, message = os.pullEvent()
	if event == 'rednet_message' then
		print('CPU: '..cpu..' Msg: '..message)
		-- rednet.send(cpu,"bot/done")
	end
end