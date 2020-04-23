ESX = nil
showHud = false
msg = 'empty'

statuses = {
	{message = "~y~10 System Initialized", id = '0'}
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(60000)
		PlayerData = ESX.GetPlayerData()
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if showHud then 
			rectY = 0.975 - (0.0125 * (#statuses - 1))
			rectH = 0.04 + (0.025 * (#statuses - 1))
			DrawRect(0.900, rectY, 0.205, rectH, 0, 0, 0, 150)
			for i, status in ipairs(statuses) do
				y = 0.975 - (0.025 * (i-1))
				DrawAdvancedText(0.990, y, 0.005, 0.0028, 0.4, tostring(status.message), 0, 191, 255, 255, 6, 0)
			end
			
		end
	end
end)

RegisterCommand('10system', function(source, args, rawCommand)
	if PlayerData.job.name == 'police' or  PlayerData.job.name == 'offpolice' or  PlayerData.job.name == 'offambulance' or PlayerData.job.name == 'ambulance' then
		showHud = not showHud
	end
end, false)

RegisterCommand('10', function(source, args, rawCommand)
	if PlayerData.job.name == 'police' or  PlayerData.job.name == 'offpolice' then
		code = rawCommand:sub(4)
		local xPlayer = ESX.GetPlayerData()
		if code == "7" then
			TriggerServerEvent('esx_10system:setPolice', false)
		elseif code == "8" then
			TriggerServerEvent('esx_10system:setPolice', true)
		end
		TriggerServerEvent('esx_10system:SendStatus', code)
	end
	if PlayerData.job.name == 'offambulance' or PlayerData.job.name == 'ambulance' then
		code = rawCommand:sub(4)
		local xPlayer = ESX.GetPlayerData()
		if code == "7" then
			TriggerServerEvent('esx_10system:setAmbulance', false)
		elseif code == "8" then
			TriggerServerEvent('esx_10system:setAmbulance', true)
		end
		TriggerServerEvent('esx_10system:SendStatus', code)
	end
end, false)

RegisterCommand('10clear', function(source, args, rawCommand)
	if PlayerData.job.name == 'police' then
		statuses = {
			{message = "~y~10 System Cleared", id = '0'}
		}
	end
end, false)

function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(sc, sc)
	N_0x4e096588b13ffeca(jus)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - 0.1+w, y - 0.02+h)
end

RegisterNetEvent('esx_10system:UpdateMessages')
AddEventHandler('esx_10system:UpdateMessages', function(parsedMessage, id)
	local added = false
	if statuses[1].id == '0' then
		statuses[1] = ({message = parsedMessage, id = id})
		added = true
	else
		for i, status in ipairs(statuses) do
			if status.id == id then
				statuses[i] = ({message = parsedMessage, id = id})
				added = true
			end
		end
		if not added then
			statuses[#statuses+1] = ({message = parsedMessage, id = id})
		
		end
	end
end)

RegisterNetEvent('esx_10system:clearSystem')
AddEventHandler('esx_10system:clearSystem', function(id)
	statuses = {
		{message = "~y~10 System Refreshing", id = '0'}
	}
end)