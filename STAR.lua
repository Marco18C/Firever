-- STAR.lua
local thread = love.thread.getChannel("STAR")
local result = {}
local input = love.thread.getChannel("input")
local output = love.thread.getChannel("output")
local polygons = require("Polygon")

-- Recibir datos
local args = input:demand()  -- Espera a que lleguen
local start = args.start
local goal = args.goal
local obstacles = args.obstacles
local Warning = args.Warning

local cellSize = 48  -- Tamaño de cada celda en píxeles
-- Función para convertir coordenadas de píxel a coordenadas de celda
local function toCell(x, y)
    return math.floor(x / cellSize), math.floor(y / cellSize)
end
-- Función para convertir coordenadas de celda a coordenadas de píxel (para mover el vehículo)
local function toPixel(cellX, cellY)
    return cellX * cellSize, cellY * cellSize
end
local function heuristic(a, b)
    local dx = math.abs(a.x - b.x)
    local dy = math.abs(a.y - b.y)
    return (dx + dy) * 2.0
end

local function startAStarThread(start, goal, obstacles)
    local openSet = {}
    local cameFrom = {}
    local gScore = {}
    local fScore = {}
    local MaxNodes = 500
    print("STAR" .. " started with start: " .. start.x .. "," .. start.y .. " goal: " .. goal.x .. "," .. goal.y)

    -- Verificar si una celda está ocupada por un obstáculo
    local function isObstacle(cellX, cellY)
        -- Convertir las coordenadas de la celda a píxeles
        local cellPixelX, cellPixelY = toPixel(cellX, cellY)

        for _, obstacle in ipairs(obstacles) do
            if not obstacle.traversable then  -- Solo verificar si el obstáculo no es transpasable
                -- Calcular los límites del obstáculo en términos de celdas
                local obstacleLeft = obstacle.x
                local obstacleRight = obstacle.x + obstacle.width
                local obstacleTop = obstacle.y
                local obstacleBottom = obstacle.y + obstacle.height


                -- Verificar si la celda (convertida a píxeles) está dentro del área del obstáculo
                if cellPixelX >= obstacleLeft and cellPixelX < obstacleRight and
                   cellPixelY >= obstacleTop and cellPixelY < obstacleBottom then
                    return true  -- La celda está ocupada por un obstáculo no transpasable
                end
            end

            if #Warning > 2 and not polygons.pointInPolygon(cellPixelX, cellPixelY, Warning) then
                 return true  -- La celda está ocupada por un obstáculo no transpasable
            end
        end
        return false
    end

    -- Convertir coordenadas de píxeles a celdas
    local startX, startY = toCell(start.x, start.y)
    local goalX, goalY = toCell(goal.x, goal.y)

    -- Inicialización de A* con celdas activas
    table.insert(openSet, {x = startX, y = startY})
    gScore[startX .. "," .. startY] = 0
    fScore[startX .. "," .. startY] = heuristic({x = startX, y = startY}, {x = goalX, y = goalY})
    
    while #openSet > 0 do
        -- Verificar si se ha creado demasiados nodos para que no explote xd
        if (#cameFrom > MaxNodes or #openSet > MaxNodes) or isObstacle(goalX, goalY) then
            return nil
        end

        -- Obtener el nodo con menor fScore
        table.sort(openSet, function(a, b) return fScore[a.x .. "," .. a.y] < fScore[b.x .. "," .. b.y] end)
        local current = table.remove(openSet, 1)

        -- Si el objetivo es alcanzado
        if current.x == goalX and current.y == goalY then
            -- Construir el camino
            local path = {}
            while cameFrom[current.x .. "," .. current.y] do
                table.insert(path, 1, current)
                current = cameFrom[current.x .. "," .. current.y]
            end
            return path
        end

        -- Explorar vecinos solo dentro de las celdas activas y que no sean obstáculos
        local neighbors = {{x=1, y=0}, {x=-1, y=0}, {x=0, y=1}, {x=0, y=-1}}
        for _, neighbor in ipairs(neighbors) do
            local neighborX = current.x + neighbor.x
            local neighborY = current.y + neighbor.y

            -- Comprobar si el vecino está en la grilla activa y no es un obstáculo
            if not isObstacle(neighborX, neighborY) then
                -- Calcular gScore y fScore
                local tentativeGScore = gScore[current.x .. "," .. current.y] + 1
                local neighborKey = neighborX .. "," .. neighborY
                if tentativeGScore < (gScore[neighborKey] or math.huge) then
                    cameFrom[neighborKey] = current
                    gScore[neighborKey] = tentativeGScore
                    fScore[neighborKey] = tentativeGScore + heuristic({x = neighborX, y = neighborY}, {x = goalX, y = goalY})
                    ---- Contains ----
                    local key = neighborX .. "," .. neighborY
                    if not openSet[key] then
                        table.insert(openSet, {x = neighborX, y = neighborY})
                        openSet[key] = true
                    end
                end
            end
        end
    end

    return {}  -- Si no hay camino
end

local result = startAStarThread(start, goal, obstacles)
output:push({result = result})