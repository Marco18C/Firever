local KillPoints = {}
KillPoints.orbs = {}

function KillPoints.addOrb(x, y, value)
    for i = 1, value do
        local colour = math.random(1, 6) / 10
        table.insert(KillPoints.orbs, {
            x = x,
            y = y,
            SpeedX = love.math.random(-60, 60),
            SpeedY = love.math.random(-60, 60),
            time = 6,
            color = {1, colour, colour, 1},
            value = 1 / 500
        })
    end
end

function KillPoints.attractToTarget(orb, target, speed, radius, dt)
    local dx = target.x + target.width / 2 - orb.x
    local dy = target.y + target.height / 2 - orb.y
    local distance = math.sqrt(dx * dx + dy * dy)
    local attractionRadius = radius
    local pullStrength = speed

    if distance < attractionRadius then
        local normX = dx / distance
        local normY = dy / distance
        orb.SpeedX = orb.SpeedX + normX * pullStrength * dt
        orb.SpeedY = orb.SpeedY + normY * pullStrength * dt
    end
end

function KillPoints.UpdateOrbs(dt)
    for i = #KillPoints.orbs, 1, -1 do
        local orb = KillPoints.orbs[i]

        if not player.death then KillPoints.attractToTarget(orb, player, 300, 256, dt) end
        if not vehicle.death then KillPoints.attractToTarget(orb, vehicle, 300, 256, dt) end

        orb.x = orb.x + orb.SpeedX * dt
        orb.y = orb.y + orb.SpeedY * dt
        orb.time = orb.time - dt
        local friction = 0.2
        orb.SpeedX = orb.SpeedX * (1 - (1 - friction) * dt)
        orb.SpeedY = orb.SpeedY * (1 - (1 - friction) * dt)

        if checkCollisionRect(player.x, player.y, player.width, player.height, orb.x - 12, orb.y - 12, 24, 24) and not player.death then
            player2Points = player2Points + orb.value
            table.remove(KillPoints.orbs, i)
        elseif checkCollisionRect(vehicle.x, vehicle.y, vehicle.width, vehicle.height, orb.x - 12, orb.y - 12, 24, 24) and not vehicle.death then
            player1Points = player1Points + orb.value
            table.remove(KillPoints.orbs, i)
        end

        if orb.time <= 0 then
            table.remove(KillPoints.orbs, i)
        end
    end
end

function KillPoints.draw()
    for i = 1, #KillPoints.orbs do
        local orb = KillPoints.orbs[i]
        love.graphics.setColor(orb.color)
        love.graphics.circle("fill", orb.x, orb.y, 2)
        love.graphics.setColor(1, 1, 1, 1)
    end
end

return KillPoints