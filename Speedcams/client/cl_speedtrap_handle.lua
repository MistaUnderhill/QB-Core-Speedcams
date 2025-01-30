speedtraps = {
    {name = "68th Devil", x = 880.364, y = 2698.003, z = 40.255, minSpeed = 35.0},
    {name = "Don't tell Joshua", x = 1212.397, y = 3536.227, z = 34.568, minSpeed = 45.35},
    {name = "Tongva Valley Spy", x = -1511.871, y = 1445.777, z = 120.061, minSpeed = 45.35},
    {name = "Paleto Problems", x = -110.463, y = 6266.835, z = 30.543, minSpeed = 45.35},
    {name = "Great Ocean Breeze", x = -2472.09, y = 3703.39, z = 14.16, minSpeed = 65.0},
    {name = "Palomino Pressure", x = 2436.19, y = -168.27, z = 87.74, minSpeed = 65.0},
    {name = "Pillbox Welcome", x = 365.77, y = -646.87, z = 28.65, minSpeed = 45.0},
    {name = "Elysian Scream", x = 237.17, y = -2663.02, z = 17.68, minSpeed = 65.0},
    {name = "Senora to 68", x = 2457.23, y = 2847.68, z = 48.15, minSpeed = 45.0},
    {name = "Five Points", x = -632.92, y = -372.67, z = 34.16, minSpeed = 45.0},

}
Citizen.CreateThread(function()
    TriggerEvent("lslSpeedtrap:BuildTraps", speedtraps)
    local trapID = nil
    while true do
        local validSpot = false
        for i,k in pairs(speedtraps) do
            if #(vector3(k.x, k.y, k.z) - GetEntityCoords(PlayerPedId())) <= 7.01 then
                validSpot = true
                trapID = i
            end -- Use Z
        end

        if validSpot == true then
            local ped = PlayerPedId()
            local car = GetVehiclePedIsIn(ped, false)
            if GetEntitySpeed(car) >= speedtraps[trapID].minSpeed and GetPedInVehicleSeat(car, -1) == ped and GetEntitySpeed(car) > 0.0 then
                TriggerServerEvent('lslSpeedtrap.Got_A_Runner', trapID, GetEntitySpeed(car))
                TriggerEvent('lslSpeedtrap.ShowSpeed', GetEntitySpeed(car), speedtraps[trapID].name)
                validSpot = false
                trapID = nil
                Citizen.Wait(4000)
            else
                --print('too slow')
                --TriggerEvent('lslSpeedtrap.ShowSpeed', "TOO SLOW")
                validSpot = false
                trapID = nil
                Citizen.Wait(2000)
            end
        else
            --Citizen.Wait(10)
        end
        Citizen.Wait(1)
    end
end)

RegisterNetEvent("lslSpeedtrap:SpawnPolice")
AddEventHandler("lslSpeedtrap:SpawnPolice", function()
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)  -- Get player position (Vector3)
    
    -- Wait 100 milliseconds for movement
    Citizen.Wait(100)
    
    local newPlayerPos = GetEntityCoords(playerPed)  -- Get new player position after 100ms
    
    -- Calculate direction vector (movement direction)
    local directionX = newPlayerPos.x - playerPos.x
    local directionY = newPlayerPos.y - playerPos.y
    local directionZ = newPlayerPos.z - playerPos.z

    -- Normalize the direction vector
    local magnitude = math.sqrt(directionX^2 + directionY^2 + directionZ^2)
    directionX = directionX / magnitude
    directionY = directionY / magnitude
    directionZ = directionZ / magnitude

    -- Calculate a position 100 feet ahead of the player
    local aheadX = playerPos.x + (directionX * 100)  -- 100 feet ahead in X
    local aheadY = playerPos.y + (directionY * 100)  -- 100 feet ahead in Y
    local aheadZ = playerPos.z  -- Keep the Z (height) the same

    -- Perpendicular vector (right direction)
    local rightX = -directionY
    local rightY = directionX

    -- Distance to spawn the police vehicles (adjusted to 10 feet)
    local distance = 10.0  -- 10 feet offset from the ahead position

    -- Calculate left and right positions based on the perpendicular direction
    local xLeft = aheadX + (rightX * distance)
    local yLeft = aheadY + (rightY * distance)
    local zPosLeft = aheadZ  -- Use the same Z position for spawn height

    local xRight = aheadX - (rightX * distance)
    local yRight = aheadY - (rightY * distance)
    local zPosRight = aheadZ  -- Use the same Z position for spawn height

    -- Request the police model and vehicle model
    RequestModel("s_m_y_cop_01") -- Police ped model
    RequestModel("police") -- Police car model
    
    -- Wait until both models are loaded
    while not HasModelLoaded("s_m_y_cop_01") or not HasModelLoaded("police") do
        Wait(500)
    end

    -- Spawn the first police vehicle to the left of the player
    local copCarLeft = CreateVehicle(GetHashKey("police"), xLeft, yLeft, zPosLeft, GetEntityHeading(playerPed), true, true)
    SetVehicleSiren(copCarLeft, true) -- Activate siren

    -- Spawn the police ped inside the first car
    local copPedLeft = CreatePedInsideVehicle(copCarLeft, 4, GetHashKey("s_m_y_cop_01"), -1, true, true)

    -- Spawn the second police vehicle to the right of the player
    local copCarRight = CreateVehicle(GetHashKey("police"), xRight, yRight, zPosRight, GetEntityHeading(playerPed), true, true)
    SetVehicleSiren(copCarRight, true) -- Activate siren

    -- Spawn the police ped inside the second car
    local copPedRight = CreatePedInsideVehicle(copCarRight, 4, GetHashKey("s_m_y_cop_01"), -1, true, true)

    -- Increase the chase speed by setting a higher speed (e.g., 60 or more for faster)
    local chaseSpeed = 150.0  -- Increase speed to make the chase faster (higher value = faster)

    -- Use an aggressive driving style (e.g., 288 or 16777216 for police-style)
    local drivingStyle = 16777216 -- Aggressive driving style for police (higher aggression)

    -- Make both police vehicles start a pursuit towards the player with higher speed and aggressive style
    TaskVehicleDriveToCoord(copPedLeft, copCarLeft, playerPos.x + 10, playerPos.y + 10, playerPos.z, chaseSpeed, 0, GetEntityModel(copCarLeft), drivingStyle, 10.0, true)
    TaskVehicleDriveToCoord(copPedRight, copCarRight, playerPos.x + 10, playerPos.y + 10, playerPos.z, chaseSpeed, 0, GetEntityModel(copCarRight), drivingStyle, 10.0, true)

    -- Optionally, make the police ped engage in combat with the player if close enough
    TaskCombatPed(copPedLeft, playerPed, 0, 16)
    TaskCombatPed(copPedRight, playerPed, 0, 16)

    -- After a short delay, begin the chase towards the player
    SetEntityAsMissionEntity(copCarLeft, true, true) -- Set the car as a mission entity so it isn't deleted
    SetEntityAsMissionEntity(copPedLeft, true, true) -- Set the police ped as a mission entity
    SetEntityAsMissionEntity(copCarRight, true, true) -- Set the car as a mission entity so it isn't deleted
    SetEntityAsMissionEntity(copPedRight, true, true) -- Set the police ped as a mission entity

    -- Start a loop to track distance between player and police vehicles
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(500)  -- Check every half second

            -- Calculate the current position of the player and police vehicles
            local copCarLeftPos = GetEntityCoords(copCarLeft)
            local copCarRightPos = GetEntityCoords(copCarRight)
            local playerPos = GetEntityCoords(playerPed)  -- Get player position

            -- Calculate the distance between the player and each police car
            local distanceLeft = Vdist(playerPos.x, playerPos.y, playerPos.z, copCarLeftPos.x, copCarLeftPos.y, copCarLeftPos.z)
            local distanceRight = Vdist(playerPos.x, playerPos.y, playerPos.z, copCarRightPos.x, copCarRightPos.y, copCarRightPos.z)

            -- If either police car moves more than 500 feet from the player, despawn them
            if distanceLeft > 500.0 or distanceRight > 500.0 then
                DeleteEntity(copCarLeft)
                DeleteEntity(copPedLeft)
                DeleteEntity(copCarRight)
                DeleteEntity(copPedRight)
                break  -- Exit the loop when police are despawned
            end
        end
    end)
end)
