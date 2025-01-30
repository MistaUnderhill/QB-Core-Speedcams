print(' Speedcams by MistaUnderhill ')

RegisterNetEvent('lslSpeedtrap.Got_A_Runner')
RegisterNetEvent('lslSpeedtrap.RequestLeaderboard')

AddEventHandler("lslSpeedtrap.Got_A_Runner", function(_trapid, _speed)
    local source = source
    local charCount = 0


    -- Using exports.oxmysql:query instead of MySQL.query
    exports.oxmysql:query("SELECT COUNT(name) AS `count` FROM `speedtrapLB` WHERE `name` = @name AND `trapid` = @race", {
        ["@name"] = GetPlayerName(source),
        ["@race"] = _trapid
    }, function(result)
        charCount = result[1].count
        if charCount == 0 then
            -- Insert query using oxmysql
            exports.oxmysql:query("INSERT INTO `speedtrapLB` (name, trapid, speed) VALUES (@name, @trapid, @speed)", {
                ["@name"] = GetPlayerName(source),
                ["@trapid"] = _trapid,
                ["@speed"] = _speed
            })
        elseif charCount == 1 then
            -- Fetch query to check existing record
            exports.oxmysql:query("SELECT * FROM `speedtrapLB` WHERE `name` = @name AND `trapid` = @trapid", {
                ["@name"] = GetPlayerName(source),
                ["@trapid"] = _trapid
            }, function(result)
                if _speed >= result[1].speed then
                    -- Update query with new speed
                    exports.oxmysql:query("UPDATE `speedtrapLB` SET `speed` = @speed WHERE `name` = @name AND `trapid` = @trapid", {
                        ["@name"] = GetPlayerName(source),
                        ["@trapid"] = _trapid,
                        ["@speed"] = _speed
                    })
                end
            end)
        end
    end)

    -- Trigger the client event to spawn police NPCs and vehicles
    TriggerClientEvent("lslSpeedtrap:SpawnPolice", source)
    
    -- Notify the player using qbcore
    TriggerClientEvent('qbcore:notify', source, 'You have received a higher AI wanted level! Police are after you!', 'error')
end)



AddEventHandler('lslSpeedtrap.RequestLeaderboard', function(_trapid, _overrideSource)
    local top = {}
    local src = source
    if _overrideSource ~= nil and _overrideSource > 0 then
        src = _overrideSource
    end

    -- Fetch leaderboard from `oxmysql`
    exports.oxmysql:query("SELECT * FROM `speedtrapLB` WHERE `trapid` = @trapid ORDER BY `speed` DESC", {
        ["@trapid"] = _trapid
    }, function(result)
        for i, k in pairs(result) do
            if result[i] ~= nil then
                if i < 11 then
                    top[i] = result[i]
                elseif k.name == GetPlayerName(src) then
                    top[i] = result[i]
                end
            else
                break
            end
        end
        -- Send updated leaderboard to client
        TriggerClientEvent('lslSpeedtrap.UpdateLeaderboard', src, _trapid, top)
    end)
end)

AddEventHandler('lslSpeedtrap.RequestLeaderboardFlush', function(_trapid, _reason, _passcode)
    if source == 0 or _passcode == "Flu$hM3" then
        -- Flush leaderboard for speedtrap with `oxmysql`
        exports.oxmysql:query("DELETE FROM `speedtrapLB` WHERE `trapid` = @trapid", {
            ["@trapid"] = _trapid
        }, function(result)
            print('Speedtrap ID ' .. _trapid .. ' leaderboard was flushed. Reason: ' .. _reason .. '.')
        end)
    else
        print('ID ' .. source .. " tried to run this server-only event, but he was not allowed.")
    end
end)

RegisterCommand('flush', function(source, args)
    if args[2] ~= nil then
        if args[1] == "Flu$hM3" then
            if tonumber(args[2]) ~= nil then
                TriggerEvent('lslSpeedtrap.RequestLeaderboardFlush', tonumber(args[2]), "Flushed by test.", args[1])
            end
        end
    end
end)
