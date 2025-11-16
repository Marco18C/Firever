-- obb.lua
-- Colisión entre rectángulos rotados (OBB) en 2D
-- Usa el Separating Axis Theorem (SAT)
-- Compatible con LÖVE2D o cualquier proyecto Lua

local OBB = {}

-------------------------------------------------------------
-- 🔹 Producto punto
-------------------------------------------------------------
local function dot(ax, ay, bx, by)
    return ax * bx + ay * by
end

-------------------------------------------------------------
-- 🔹 Proyección de una caja sobre un eje
-------------------------------------------------------------
local function project(box, axisX, axisY)
    local c = math.cos(box.angle)
    local s = math.sin(box.angle)

    -- Ejes locales del rectángulo
    local ux, uy = c, s
    local vx, vy = -s, c

    -- Proyección del centro
    local cx, cy = box.x, box.y
    local centerProj = dot(cx, cy, axisX, axisY)

    -- Mitad de la proyección total
    local extent =
        math.abs(dot(ux * box.hw, uy * box.hw, axisX, axisY)) +
        math.abs(dot(vx * box.hh, vy * box.hh, axisX, axisY))

    return centerProj - extent, centerProj + extent
end

-------------------------------------------------------------
-- 🔹 Verifica si dos intervalos se solapan
-------------------------------------------------------------
local function overlap(minA, maxA, minB, maxB)
    return not (maxA < minB or maxB < minA)
end

-------------------------------------------------------------
-- 🔹 Verifica colisión entre dos OBB
-------------------------------------------------------------
function OBB.check(a, b)
    local axes = {
        { math.cos(a.angle),  math.sin(a.angle) },
        { -math.sin(a.angle), math.cos(a.angle) },
        { math.cos(b.angle),  math.sin(b.angle) },
        { -math.sin(b.angle), math.cos(b.angle) },
    }

    for i = 1, #axes do
        local ax, ay = axes[i][1], axes[i][2]
        local minA, maxA = project(a, ax, ay)
        local minB, maxB = project(b, ax, ay)
        if not overlap(minA, maxA, minB, maxB) then
            return false -- Separating axis encontrado → no colisión
        end
    end

    return true -- Todos los ejes se solapan → colisión
end

-------------------------------------------------------------
-- 🔹 Dibuja una OBB (solo para visualización con LÖVE2D)
-------------------------------------------------------------
function OBB.draw(box, r, g, b, a)
    if not love or not love.graphics then return end

    local c = math.cos(box.angle)
    local s = math.sin(box.angle)

    -- Ejes locales unitarios
    local ux, uy = c, s   -- eje X local (dirección "ancho")
    local vx, vy = -s, c  -- eje Y local (dirección "alto")

    local hw, hh = box.hw, box.hh

    -- Vértices = centro +/- ux*hw +/- vx*hh
    local verts = {
        box.x - ux*hw - vx*hh, box.y - uy*hw - vy*hh, -- esquina 1
        box.x + ux*hw - vx*hh, box.y + uy*hw - vy*hh, -- esquina 2
        box.x + ux*hw + vx*hh, box.y + uy*hw + vy*hh, -- esquina 3
        box.x - ux*hw + vx*hh, box.y - uy*hw + vy*hh, -- esquina 4
    }

    love.graphics.setColor(r or 1, g or 1, b or 1, a or 1)
    love.graphics.polygon("line", unpack(verts))
end

-- Dibuja las proyecciones de dos cajas sobre un eje (para debug)
function OBB.debugDrawProjections(a, b, axisX, axisY, ox, oy)
    -- axisX, axisY deben ser unitarios
    -- ox, oy = offset en pantalla donde dibujar la línea de referencia (opcional)
    ox = ox or 400
    oy = oy or 50

    -- helper para obtener intervalo
    local function projectInterval(box)
        local ux, uy = math.cos(box.angle), math.sin(box.angle)
        local vx, vy = -math.sin(box.angle), math.cos(box.angle)
        local centerProj = dot(box.x, box.y, axisX, axisY)
        local extent = math.abs(dot(ux * box.hw, uy * box.hw, axisX, axisY))
                     + math.abs(dot(vx * box.hh, vy * box.hh, axisX, axisY))
        return centerProj - extent, centerProj + extent
    end

    local minA, maxA = projectInterval(a)
    local minB, maxB = projectInterval(b)

    -- escalar proyecciones para mostrarlas en pantalla (sólo visual)
    local scale = 40
    love.graphics.setColor(1,1,1,0.15)
    love.graphics.rectangle("fill", ox, oy, scale * 30, 20) -- fondo

    -- dibujar línea eje
    love.graphics.setColor(1,1,1,0.6)
    love.graphics.line(ox, oy + 10, ox + scale * 30, oy + 10)

    -- dibujar intervalo A (azul)
    love.graphics.setColor(0,0.6,1,1)
    love.graphics.rectangle("fill",
        ox + (minA - minA) * scale, oy + 2,
        (maxA - minA) * scale, 16)

    -- dibujar intervalo B (verde)
    love.graphics.setColor(0,1,0,0.8)
    love.graphics.rectangle("fill",
        ox + (minB - minA) * scale, oy + 2,
        (maxB - minB) * scale, 16)

    -- texto de valores (opcional)
    love.graphics.setColor(1,1,1,1)
    love.graphics.print(string.format("A:[%.2f,%.2f]", minA, maxA), ox, oy + 22)
    love.graphics.print(string.format("B:[%.2f,%.2f]", minB, maxB), ox + 200, oy + 22)
end

return OBB