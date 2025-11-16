local Weather = {}
Weather.Objets = {}
Weather.Mud = {}
Weather.active = true

function Weather.createObjs()
    for i = 1, 121 do
        local obj = {
            x = math.random(0, 1000),
            y = math.random(0, 750),
            id = i,
            altitude = math.random(10, 100) / 1000,
        }
        table.insert(Weather.Objets, obj)
    end
    
    for i = 1, 97 do
        local obj = {
            x = math.random(0, 1000),
            y = math.random(0, 750),
            id = i,
            proccess = math.random(60, 100) / 100,
        }
        table.insert(Weather.Mud, obj)
    end
end

function Weather.update(dt)
    if not Weather.active then return end
    for i, obj in ipairs(Weather.Objets) do
        obj.x = obj.x - 8 * dt
        obj.y = obj.y + 6.5 * dt
        obj.altitude = obj.altitude - 0.05 * dt

        -- reset
        if obj.altitude <= 0 then
            obj.x = math.random(0, 1000)
            obj.y = math.random(0, 750)
            obj.altitude = .1
        end
    end

    for _, mud in ipairs(Weather.Mud) do
        mud.proccess = mud.proccess - 0.5 * dt

        -- reset
        if mud.proccess <= 0 then
            mud.x = math.random(0, 1000)
            mud.y = math.random(0, 750)
            mud.proccess = love.math.random(20, 10) / 100
        end
    end
end

function Weather.draw01(img)
    if not Weather.active then return end
    for _, obj in ipairs(Weather.Objets) do
        love.graphics.setColor(1, 1, 1, 0.5)
        love.graphics.draw(img, obj.x, obj.y, 0, obj.altitude)
        love.graphics.setColor(1, 1, 1, 1)
    end
end

function Weather.draw02(img)
    if not Weather.active then return end
    for _, mud in ipairs(Weather.Mud) do
        love.graphics.setColor(1, 1, 1, mud.proccess)
        love.graphics.draw(img, mud.x, mud.y, 0, .1 / mud.proccess)
        love.graphics.setColor(1, 1, 1, 1)
    end
end

function Weather.allScreenEffect()
    if not Weather.active then return end
    love.graphics.setColor(.65, .65, .65, 1)
end

return Weather