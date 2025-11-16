local Explodes = {}
Explodes.explosions = {}
Explodes.humoPoligonos = {}

local function generatePolygon(x, y, radius, points, irregularity)
    local vertices = {}
    local angleStep = (2 * math.pi) / points
    for i = 1, points do
        local angle = (i - 1) * angleStep + love.math.random() * angleStep * irregularity
        local r = radius * (1 + love.math.random() * irregularity)
        local px = x + math.cos(angle) * r
        local py = y + math.sin(angle) * r
        table.insert(vertices, {x = px, y = py})
    end
    return vertices
end

local function isPointInPolygon(px, py, polygon)
    local inside = false
    local j = #polygon
    for i = 1, #polygon do
        local xi, yi = polygon[i].x, polygon[i].y
        local xj, yj = polygon[j].x, polygon[j].y
        if ((yi > py) ~= (yj > py)) and (px < (xj - xi) * (py - yi) / (yj - yi + 0.00001) + xi) then
            inside = not inside
        end
        j = i
    end
    return inside
end

function Explodes.createExplosion(x, y, power, Zpress)
    power = power or 1.0
    Zpress = Zpress or 1

    local e = {
        x = x,
        y = y,
        radius = 0,
        maxRadius = 100 * power,
        particles = {},
        time = 0,
        fused = false,
        sparks = {},
        power = power
    }

    -- Partículas
    local particleCount = math.floor(100 * power)
    for i = 1, particleCount do
        local angle = math.random() * math.pi * 2
        local speed = math.random(0, 250) * power
        table.insert(e.particles, {
            x = x,
            y = y,
            vx = math.cos(angle) * speed,
            vy = math.sin(angle) * speed - math.random() * 50 * power, -- se eleva
            life = 1,
            size = math.random(2, 6) * math.sqrt(power) * Zpress,
            type = "fire",
            heat = math.random() * 0.4 + 0.6
        })
        table.insert(e.particles, {
            x = x,
            y = y,
            vx = math.cos(angle) * speed,
            vy = math.sin(angle) * speed - math.random() * 50 * power, -- se eleva
            life = .8,
            size = math.random(2, 6) * math.sqrt(power) * Zpress,
            type = "smoke",
            heat = math.random() * 0.4 + 0.6
        })
        table.insert(e.particles, {
            x = x,
            y = y,
            vx = math.cos(angle) * speed,
            vy = math.sin(angle) * speed - math.random() * 50 * power, -- se eleva
            life = .8,
            size = math.random(2, 6) * math.sqrt(power) * Zpress,
            type = "soot",
            heat = math.random() * 0.4 + 0.6
        })
    end

    -- Chispas
    for i = 1, math.floor(15 * power) do
        local angle = math.random() * math.pi * 2
        table.insert(e.sparks, {
            angle = angle,
            length = math.random(20, 50) * power,
            alpha = 1
        })
    end

    return e
end

function Explodes.Explode(x, y, power, Zpress)
    table.insert(Explodes.explosions, Explodes.createExplosion(x, y, power, Zpress))
end

function Explodes.fuseExplosions()
    for i = #Explodes.explosions, 1, -1 do
        for j = i - 1, 1, -1 do
            local e1 = Explodes.explosions[i]
            local e2 = Explodes.explosions[j]
            if not e1.fused and not e2.fused then
                local dx = e1.x - e2.x
                local dy = e1.y - e2.y
                local dist = math.sqrt(dx * dx + dy * dy)
                if dist < (e1.maxRadius + e2.maxRadius) * 0.5 then
                    local mx = (e1.x + e2.x) / 2
                    local my = (e1.y + e2.y) / 2
                    local newExp = Explodes.createExplosion(mx, my, e1.power)
                    newExp.maxRadius = math.max(e1.maxRadius, e2.maxRadius) + 50
                    newExp.fused = true
                    e1.fused = true
                    e2.fused = true
                    table.insert(Explodes.explosions, newExp)
                end
            end
        end
    end
end

function Explodes.Update(dt)
    Explodes.fuseExplosions()

    for i = #Explodes.explosions, 1, -1 do
        local e = Explodes.explosions[i]
        e.time = e.time + dt
        e.radius = math.min(e.time * 200, e.maxRadius)

        for j = #e.particles, 1, -1 do
            local p = e.particles[j]
            p.life = p.life - dt
            p.x = p.x + p.vx * dt
            p.y = p.y + p.vy * dt
            p.vx = p.vx * 0.96
            p.vy = p.vy * 0.96
            if p.life <= 0 then
                table.remove(e.particles, j)
            elseif p.life < 0.8 and p.type == "fire" then
                p.type = "smoke"
            end
        end

        for s = #e.sparks, 1, -1 do
            local spark = e.sparks[s]
            spark.alpha = spark.alpha - dt * 2
            if spark.alpha <= 0 then
                table.remove(e.sparks, s)
            end
        end

        if e.radius >= e.maxRadius / 2 and not e.denied then
            -- Generar nube de humo al final de la explosión
            e.denied = true
            local poly = {
                vertices = generatePolygon(e.x, e.y, 60 * e.power / 3, 8, 0.4),
                particles = {},
                lifetime = 4.0
            }
            -- Agregar partículas de humo dentro del polígono
            for _ = 1, 100 * e.power / 3.5 do
                local attempts = 0
                repeat
                    local v1 = poly.vertices[love.math.random(1, #poly.vertices)]
                    local v2 = poly.vertices[love.math.random(1, #poly.vertices)]
                    
                    -- Interpolar entre esos puntos
                    local t = love.math.random()
                    local x = v1.x + (v2.x - v1.x) * t
                    local y = v1.y + (v2.y - v1.y) * t

                    attempts = attempts + 1
                    if isPointInPolygon(x, y, poly.vertices) or attempts > 30 then
                        table.insert(poly.particles, {
                            x = x,
                            y = y,
                            vx = love.math.random(-10, 10),
                            vy = love.math.random(-10, 10),
                            power = e.power,
                            life = 1.0
                        })
                        break
                    end
                until false
            end
            table.insert(Explodes.humoPoligonos, poly)
        elseif #e.particles == 0 then
            table.remove(Explodes.explosions, i)
        end
    end
    
    for i = #Explodes.humoPoligonos, 1, -1 do
        local poly = Explodes.humoPoligonos[i]
        poly.lifetime = poly.lifetime - dt
        for j = #poly.particles, 1, -1 do
            local p = poly.particles[j]
            p.life = p.life - (dt / 2)
            p.x = p.x + p.vx * dt
            p.y = p.y + p.vy * dt
            if p.life <= 0 then
                table.remove(poly.particles, j)
            end
        end
        if poly.lifetime <= 0 then
            table.remove(Explodes.humoPoligonos, i)
        end
    end
end

function Explodes.draw()
    for _, poly in ipairs(Explodes.humoPoligonos) do
        love.graphics.setColor(0.2, 0.2, 0.2, 0.2 * (poly.lifetime / 4))
        local verts = {}
        for _, v in ipairs(poly.vertices) do
            table.insert(verts, v.x)
            table.insert(verts, v.y)
        end
        love.graphics.polygon("fill", verts)

        for _, p in ipairs(poly.particles) do
            love.graphics.setColor(0.3, 0.3, 0.3, p.life)
            love.graphics.circle("fill", p.x, p.y, 5 * p.power)
        end
    end

    for _, e in ipairs(Explodes.explosions) do

        -- Dibujar chispas
        for _, s in ipairs(e.sparks) do
            local x2 = e.x + math.cos(s.angle) * s.length
            local y2 = e.y + math.sin(s.angle) * s.length
            love.graphics.setColor(1, 1, 0.2, s.alpha)
            love.graphics.line(e.x, e.y, x2, y2)
        end

        for _, p in ipairs(e.particles) do
            local t = p.life
            if p.type == "fire" then
                love.graphics.setColor(1, 0.4 + 0.4 * t, 0, t)
            elseif p.type == "soot" then
                love.graphics.setColor(.1, .1, .1, t)
            else
                love.graphics.setColor(0.5, 0.5, 0.5, t * 0.5)
            end
            love.graphics.circle("fill", p.x, p.y, p.size)
        end
    end
    love.graphics.setColor(1, 1, 1, 1)
end

return Explodes