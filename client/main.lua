local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil
local PlayerData              = {}
local training = false
local resting = false
local membership = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(1000)
		PlayerData = ESX.GetPlayerData()
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

function hintToDisplay(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

local blips = {
	{title="Matériel de musculation", colour=7, id=311, x = -1201.2257, y = -1568.8670, z = 4.6101}
}
	
Citizen.CreateThread(function()

	for _, info in pairs(blips) do
		info.blip = AddBlipForCoord(info.x, info.y, info.z)
		SetBlipSprite(info.blip, info.id)
		SetBlipDisplay(info.blip, 4)
		SetBlipScale(info.blip, 1.0)
		SetBlipColour(info.blip, info.colour)
		SetBlipAsShortRange(info.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(info.title)
		EndTextCommandSetBlipName(info.blip)
	end
end)

RegisterNetEvent('esx_gym:trueMembership')
AddEventHandler('esx_gym:trueMembership', function()
	membership = true
end)

RegisterNetEvent('esx_gym:falseMembership')
AddEventHandler('esx_gym:falseMembership', function()
	membership = false
end)

Citizen.CreateThread(function()
	while true do
		local interval = 1
		local pos = GetEntityCoords(PlayerPedId())
		local dest = vector3(-1195.6551, -1577.7689, 4.6115)
        local distance = GetDistanceBetweenCoords(pos, dest, true)
		
		if distance > 40 then 
			interval = 200
		else
			interval = 1
			DrawMarker(22, -1195.6551, -1577.7689, 4.6115, 0, 0, 0, 0, 0, 0, 0.401, 0.401, 0.4001, 0, 14, 56, 80, false, true, 2, nil, nil, false)
			if distance < 1 then
				AddTextEntry("HELP", "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le menu de la musculation ~b~gym~w~")
				DisplayHelpTextThisFrame("HELP", false)
				if IsControlPressed(1, 51) then  
					OpenGymMenu()
                end 
            end
		end
	
		Citizen.Wait(interval)
	end
end)
				
Citizen.CreateThread(function()
	while true do
		local interval = 1
		local pos = GetEntityCoords(PlayerPedId())
		local dest = vector3(-1203.3242, -1570.6184, 4.6115)
        local distance = GetDistanceBetweenCoords(pos, dest, true)
		
		if distance > 40 then 
			interval = 200
		else
			interval = 1
			DrawMarker(22, -1203.3242, -1570.6184, 4.6115, 0, 0, 0, 0, 0, 0, 0.401, 0.401, 0.4001, 0, 14, 56, 80, false, true, 2, nil, nil, false)
			if distance < 1 then
				AddTextEntry("HELP", "Appuyer sur ~INPUT_CONTEXT~ pour faire des exercices sur les ~g~bras")
				DisplayHelpTextThisFrame("HELP", false)
				if IsControlJustPressed(0, Keys['E']) then
					if training == false then
					
						TriggerServerEvent('esx_gym:checkChip')
						ESX.ShowNotification("Preparation à ~g~l'exersice~w~...")
						Citizen.Wait(1000)					
					
						if membership == true then
							local playerPed = GetPlayerPed(-1)
							TaskStartScenarioInPlace(playerPed, "world_human_muscle_free_weights", 0, true)
							Citizen.Wait(30000)
							ClearPedTasksImmediately(playerPed)
							ESX.ShowNotification("Vous devez vous reposer ~r~30 secondes ~w~avant de faire un autre exercice..")
							
							training = true
						elseif membership == false then
							ESX.ShowNotification("Vous devez etre membre pour faire les ~r~exercise")
						end
					elseif training == true then
						ESX.ShowNotification("Vous devez vous reposez...")
						
						resting = true
						
						CheckTraining()
					end
				end	
            end
		end
	
		Citizen.Wait(interval)
	end
end)


Citizen.CreateThread(function()
	while true do
		local interval = 1
		local pos = GetEntityCoords(PlayerPedId())
		local dest = vector3(-1200.1284, -1570.9903, 4.6115)
        local distance = GetDistanceBetweenCoords(pos, dest, true)
		
		if distance > 40 then 
			interval = 200
		else
			interval = 1
			DrawMarker(22, -1200.1284, -1570.9903, 4.6115, 0, 0, 0, 0, 0, 0, 0.401, 0.401, 0.4001, 0, 14, 56, 80, false, true, 2, nil, nil, false)
			if distance < 1 then
				AddTextEntry("HELP", "Appuyer sur ~INPUT_CONTEXT~ pour faire des ~g~tractions")
				DisplayHelpTextThisFrame("HELP", false)
				if IsControlJustPressed(0, Keys['E']) then
					if training == false then
					
						TriggerServerEvent('esx_gym:checkChip')
						ESX.ShowNotification("Preparation à ~g~l'exersice~w~...")
						Citizen.Wait(1000)					
					
						if membership == true then
							local playerPed = GetPlayerPed(-1)
							TaskStartScenarioInPlace(playerPed, "prop_human_muscle_chin_ups", 0, true)
							Citizen.Wait(30000)
							ClearPedTasksImmediately(playerPed)
							ESX.ShowNotification("Vous devez vous reposer ~r~30 secondes ~w~avant de faire un autre exercice.")
							
							training = true
						elseif membership == false then
							ESX.ShowNotification("Vous devez etre membre pour faire les ~r~exercise")
						end
					elseif training == true then
						ESX.ShowNotification("Vous devez vous reposez...")
						
						resting = true
						
						CheckTraining()
					end
				end
            end
		end
	
		Citizen.Wait(interval)
	end
end)

Citizen.CreateThread(function()
	while true do
		local interval = 1
		local pos = GetEntityCoords(PlayerPedId())
		local dest = vector3(-1202.9837, -1565.1718, 4.6115)
        local distance = GetDistanceBetweenCoords(pos, dest, true)
		
		if distance > 40 then 
			interval = 200
		else
			interval = 1
			DrawMarker(22, -1202.9837, -1565.1718, 4.6115, 0, 0, 0, 0, 0, 0, 0.401, 0.401, 0.4001, 0, 14, 56, 80, false, true, 2, nil, nil, false)
			if distance < 1 then
				AddTextEntry("HELP", "Appuyer sur ~INPUT_CONTEXT~ pour faire des ~g~pompes")
				DisplayHelpTextThisFrame("HELP", false)
				if IsControlJustPressed(0, Keys['E']) then
					if training == false then
					
						TriggerServerEvent('esx_gym:checkChip')
						ESX.ShowNotification("Preparation à ~g~l'exercice~w~...")
						Citizen.Wait(1000)					
					
						if membership == true then				
							local playerPed = GetPlayerPed(-1)
							TaskStartScenarioInPlace(playerPed, "world_human_push_ups", 0, true)
							Citizen.Wait(30000)
							ClearPedTasksImmediately(playerPed)
							ESX.ShowNotification("Vous devez vous reposer ~r~30 secondes ~w~avant de faire un autre exercice.")
							
							training = true
						elseif membership == false then
							ESX.ShowNotification("Vous devez etre membre pour faire les ~r~exercices")
						end							
					elseif training == true then
						ESX.ShowNotification("Vous devez vous reposez...")
						
						resting = true
						
						CheckTraining()
					end
				end	
            end
		end
	
		Citizen.Wait(interval)
	end
end)

Citizen.CreateThread(function()
	while true do
		local interval = 1
		local pos = GetEntityCoords(PlayerPedId())
		local dest = vector3(-1204.7958, -1560.1906, 4.6115)
        local distance = GetDistanceBetweenCoords(pos, dest, true)
		
		if distance > 40 then 
			interval = 200
		else
			interval = 1
			DrawMarker(22, -1204.7958, -1560.1906, 4.6115, 0, 0, 0, 0, 0, 0, 0.401, 0.401, 0.4001, 0, 14, 56, 80, false, true, 2, nil, nil, false)
			if distance < 1 then
				AddTextEntry("HELP", "Appuyer sur ~INPUT_CONTEXT~ pour faire du ~g~yoga")
				DisplayHelpTextThisFrame("HELP", false)
				if IsControlJustPressed(0, Keys['E']) then
					if training == false then
					
						TriggerServerEvent('esx_gym:checkChip')
						ESX.ShowNotification("Preparation à ~g~l'exercice~w~...")
						Citizen.Wait(1000)					
					
						if membership == true then	
							local playerPed = GetPlayerPed(-1)
							TaskStartScenarioInPlace(playerPed, "world_human_yoga", 0, true)
							Citizen.Wait(30000)
							ClearPedTasksImmediately(playerPed)
							ESX.ShowNotification("Vous devez vous reposer ~r~30 secondes ~w~avant de faire un autre exercice.")
							
							training = true
						elseif membership == false then
							ESX.ShowNotification("Vous devez etre membre pour faire les ~r~exercices")
						end
					elseif training == true then
						ESX.ShowNotification("Vous devez vous reposez...")
						
						resting = true
						
						CheckTraining()
					end
				end	
            end
		end
	
		Citizen.Wait(interval)
	end
end)

Citizen.CreateThread(function()
	while true do
		local interval = 1
		local pos = GetEntityCoords(PlayerPedId())
		local dest = vector3(-1206.1055, -1565.1589, 4.6115)
        local distance = GetDistanceBetweenCoords(pos, dest, true)
		
		if distance > 40 then 
			interval = 200
		else
			interval = 1
			DrawMarker(22, -1206.1055, -1565.1589, 4.6115, 0, 0, 0, 0, 0, 0, 0.401, 0.401, 0.4001, 0, 14, 56, 80, false, true, 2, nil, nil, false)
			if distance < 1 then
				AddTextEntry("HELP", "Appuyer sur ~INPUT_CONTEXT~ pour faire des ~g~Abdos")
				DisplayHelpTextThisFrame("HELP", false)
				if IsControlJustPressed(0, Keys['E']) then
					if training == false then

						TriggerServerEvent('esx_gym:checkChip')
						ESX.ShowNotification("Preparation à ~g~l'exercice~w~...")
						Citizen.Wait(1000)					
					
						if membership == true then	
							local playerPed = GetPlayerPed(-1)
							TaskStartScenarioInPlace(playerPed, "world_human_sit_ups", 0, true)
							Citizen.Wait(30000)
							ClearPedTasksImmediately(playerPed)
							ESX.ShowNotification("Vous devez vous reposer ~r~30 secondes ~w~avant de faire un autre exercice.")
							
							training = true
						elseif membership == false then
							ESX.ShowNotification("Vous devez etre membre pour faire les ~r~exercices")
						end
					elseif training == true then
						ESX.ShowNotification("Vous devez vous reposez...")
						
						resting = true
						
						CheckTraining()
					end
				end	
            end
		end
	
		Citizen.Wait(interval)
	end
end)

function CheckTraining()
	if resting == true then
		ESX.ShowNotification("Vous vous reposez...")
		
		resting = false
		Citizen.Wait(30000)
		training = false
	end
	
	if resting == false then
		ESX.ShowNotification("Vous pouvez à nouveau faire de l'exercice...")
	end
end

function OpenGymMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'gym_menu',
        {
            title    = 'Gym',
            elements = {
				{label = 'Epicerie', value = 'shop'},
				{label = 'Heure d\'ouverture', value = 'hours'},
				{label = 'Pass membre', value = 'ship'},
            }
        },
        function(data, menu)
            if data.current.value == 'shop' then
				OpenGymShopMenu()
            elseif data.current.value == 'hours' then
				ESX.UI.Menu.CloseAll()
				
				ESX.ShowNotification("Nous sommes ouverts ~g~24~w~ heures/jour. Bienvenue!")
            elseif data.current.value == 'ship' then
				OpenGymShipMenu()
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end

function OpenGymShopMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'gym_shop_menu',
        {
            title    = 'Gym - Shop',
            elements = {
				{label = 'Proteine (6€)', value = 'protein_shake'},
				{label = 'Eau (1€)', value = 'water'},
				{label = 'Repas de sport (2€)', value = 'sportlunch'},
				{label = 'Powerade (4€)', value = 'powerade'},
            }
        },
        function(data, menu)
            if data.current.value == 'protein_shake' then
				TriggerServerEvent('esx_gym:buyProteinshake')
            elseif data.current.value == 'water' then
				TriggerServerEvent('esx_gym:buyWater')
            elseif data.current.value == 'sportlunch' then
				TriggerServerEvent('esx_gym:buySportlunch')
            elseif data.current.value == 'powerade' then
				TriggerServerEvent('esx_gym:buyPowerade')
            elseif data.current.value == 'bandage' then
				TriggerServerEvent('esx_gym:buyBandage')
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end

function OpenGymShipMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'gym_ship_menu',
        {
            title    = 'Musculation - Pass membre',
            elements = {
				{label = 'Acheter le pass membre (800€)', value = 'membership'},
            }
        },
        function(data, menu)
            if data.current.value == 'membership' then
				TriggerServerEvent('esx_gym:buyMembership')
				
				ESX.UI.Menu.CloseAll()
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end
