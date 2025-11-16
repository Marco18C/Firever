local polygonUtils = {}

-- Función para saber si un punto está dentro de un polígono
function polygonUtils.pointInPolygon(x, y, vertices)
    local inside = false
    local j = #vertices

    for i = 1, #vertices do
        local xi, yi = vertices[i][1], vertices[i][2]
        local xj, yj = vertices[j][1], vertices[j][2]

        local intersect = ((yi > y) ~= (yj > y)) and
                          (x < (xj - xi) * (y - yi) / ((yj - yi) + 0.00001) + xi)
        if intersect then
            inside = not inside
        end
        j = i
    end

    return inside
end

function polygonUtils.drawShadeOutsidePolygon(polygonVertices, player)
    local flatVertices = {}
    for _, vertex in ipairs(polygonVertices) do
        table.insert(flatVertices, vertex[1])
        table.insert(flatVertices, vertex[2])
    end

    -- Definir el área del polígono como stencil
    love.graphics.stencil(function()
        love.graphics.polygon("fill", flatVertices)
    end, "replace", 1)

    -- Activar stencil para todo lo que NO sea el polígono
    love.graphics.setStencilTest("less", 1)

    -- Dibujar sombreado sobre todo el mundo visible
    local width, height = love.graphics.getDimensions()
    love.graphics.setColor(0.3, 0, 0, 0.4) -- rojo oscuro semitransparente
    love.graphics.rectangle("fill", player.x - width, player.y - height, width * 3, height * 3)

    -- Limpiar estado gráfico
    love.graphics.setStencilTest()
    love.graphics.setColor(1, 1, 1)
end

-- Función para verificar si un cuadrado está completamente dentro del polígono
function polygonUtils.isSquareInPolygon(squareX, squareY, squareWidth, squareHeight, vertices)
    local corners = {
        {squareX, squareY},
        {squareX + squareWidth, squareY},
        {squareX, squareY + squareHeight},
        {squareX + squareWidth, squareY + squareHeight}
    }

    for _, corner in ipairs(corners) do
        if polygonUtils.pointInPolygon(corner[1], corner[2], vertices) then
            return true
        end
    end

    return false
end

function polygonUtils.drawFlagProgress(x, y, text, progress)
    -- Primero, dibujar el texto
    love.graphics.setColor(.2, .1, .2)
    love.graphics.print(text, x - 10, y - 25)

    -- Configuración
    local radius = 20
    local centerX = x
    local centerY = y
    local totalTriangles = 8
    local fillRatio = math.abs(progress) / 100  -- Normalizado 0-1

    -- Dibujar cada triángulo
    for i = 1, totalTriangles do
        local angle1 = ((i - 1) / totalTriangles) * (2 * math.pi)
        local angle2 = (i / totalTriangles) * (2 * math.pi)

        local x1 = centerX + math.cos(angle1) * radius
        local y1 = centerY + math.sin(angle1) * radius
        local x2 = centerX + math.cos(angle2) * radius
        local y2 = centerY + math.sin(angle2) * radius

        -- Cuánto corresponde a este triángulo
        local triangleMin = (i - 1) / totalTriangles
        local triangleMax = i / totalTriangles

        -- Determinar opacidad
        local alpha = 0
        if fillRatio > triangleMin then
            local localFill = math.min(1, (fillRatio - triangleMin) * totalTriangles)
            alpha = localFill * 0.7 -- máximo 70% de opacidad
        end

        -- Seleccionar color
        if progress > 0 then
            love.graphics.setColor(0, 0, 1, alpha) -- Azul
        elseif progress < 0 then
            love.graphics.setColor(1, 0, 0, alpha) -- Rojo
        else
            love.graphics.setColor(0.5, 0.5, 0.5, 0.3) -- Gris base
        end

        -- Dibujar el triángulo
        love.graphics.polygon("fill", centerX, centerY, x1, y1, x2, y2)
    end

    -- Dibujar el contorno del octágono
    love.graphics.setColor(1, 1, 1, 1)
    local points = {}
    for i = 1, totalTriangles do
        local angle = ((i - 1) / totalTriangles) * (2 * math.pi)
        table.insert(points, centerX + math.cos(angle) * radius)
        table.insert(points, centerY + math.sin(angle) * radius)
    end
    love.graphics.polygon("line", points)

    -- Restaurar color
    love.graphics.setColor(1, 1, 1)
end

function polygonUtils.rotatePoint(px, py, cx, cy, angle)
    local s, c = math.sin(angle), math.cos(angle)
    local dx, dy = px - cx, py - cy
    local rx = dx * c - dy * s
    local ry = dx * s + dy * c
    return cx + rx, cy + ry
end

function polygonUtils.getRotatedHitbox(vehicle)
    local hw, hh = vehicle.width / 4, vehicle.height / 2
    local cx, cy = vehicle.x + hw, vehicle.y + hh
    local poly = {}
    vehicle.hitBox = vehicle.hitBox or {}

    -- calcular seno y coseno UNA sola vez
    local s, c = math.sin(vehicle.rotate), math.cos(vehicle.rotate)

    for _, v in ipairs(vehicle.hitBox) do
        local vx, vy = cx + v[1], cy + v[2]
        local dx, dy = vx - cx, vy - cy
        local rx = dx * c - dy * s
        local ry = dx * s + dy * c
        poly[#poly+1] = {cx + rx, cy + ry}
    end

    return poly
end

return polygonUtils