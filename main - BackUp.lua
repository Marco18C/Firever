---@diagnostic disable-next-line: lowercase-global
love = love or {}
debug = false

local player = {
    x = 777,
    y = 620,
    width = 25,
    height = 25,
    speed = 200,
    frames = {},  -- Almacena los frames de la animación
    animations = {},  -- Almacena las animaciones del jugador
    currentAnimation = "idle",  -- Estado actual del jugador
    currentFrame = 1,
    death = false,
    animationSpeed = 0.56,  -- Velocidad de la animación
    angle = 0,  -- Ángulo de rotación del personaje
    health = 200,
    isShooting = false,
    timeSinceLastShot = 0,
    bulletsInCharger = 0,
    deadIm = love.graphics.newImage("Objetos/Objects/deadBoddy.png"),
    timeshoot = 0,
    inHand = {},
    Job = 1,
    vehicle = {
                rotate = 0,
            }
}
FlagPoint = {x = 0, y = 0, radius = 50}
AsWon = false
FlagIm = love.graphics.newImage("textures/Flag.png")
BackGroundEnding = {
    x = 0,
    y = 0
}
camera = {
    x = 0,
    y = 0,
    scale = 1,
    isActive = true
}

bossTank = {
    x = 400,  -- Coordenada X inicial en el centro de la pantalla
    y = 50,   -- Coordenada Y fija
    speed = 100,  -- Velocidad de movimiento horizontal
    width = 310,  -- Ancho del tanque
    height = 89,  -- Altura del tanque
    health = 500, -- Salud del jefe
    direction = 1, -- Dirección inicial (1 = derecha, -1 = izquierda)
    image = love.graphics.newImage("Objetos/Vehicles/Tank_Boddy.png"), -- Imagen del tanque
    bulletimage = love.graphics.newImage("textures/armas/Bala6.png"),
    isShooting = false, -- Indica si el jefe está disparando
    shootTimer = 0  -- Temporizador para controlar los disparos
}
tankCannonImage = love.graphics.newImage("Objetos/Vehicles/Tank_Head.png")
timers = {}
tankCannon = {
    x = 400,  -- Coordenada inicial X
    y = 300,  -- Coordenada inicial Y
    angle = 0,  -- Ángulo inicial del cañón
    rotationSpeed = 1.5,  -- Velocidad de rotación del cañón (ajusta según prefieras)
    bulletSpeed = 300,  -- Velocidad de las balas
    barrelLength = 156,  -- Distancia desde el centro hasta la boquilla del cañón
    missileImage = love.graphics.newImage("textures/armas/Misile_1.png")
}
-- Posiciones relativas de los lanzamisiles en el tanque (no tiene que ver con einstein o como sea que se escriba)
local leftLauncherOffsetX = -50
local leftLauncherOffsetY = 20
local rightLauncherOffsetX = 50
local rightLauncherOffsetY = 20
local deepCopy = require("Copy")
local anim = require("anim")
local LoadG_B = require("LoadG&B")
local I_W = LoadG_B("textures/armas")
local IAatackPoints = {}
local obstacles = {}
local IACopies = {}
local bullets = {}
local WonScale = 1
local gun = {
    {
        name = "M4",
        damage = 12,
        fireRate = 0.054,
        ammo = 30,
        maxAmmo = 30,
        dispersion = 0.012,
        chargers = 3,
        Maxchargers = 3,
        pos = 1, -- Si es una primaria (1), secundaria (2) u objeto (3 o 4)
        texture = I_W["M4"],  -- Ajustado el nombre de la textura
        HUD = nil,
        bala = I_W["Bala"],
        auto = true,
        timer = 100
        -- Otras propiedades según sea necesario
    },
    {
        name = "Enfield",
        damage = 190,
        fireRate = 1,
        ammo = 1,
        maxAmmo = 1,
        dispersion = 0.01,
        chargers = 6,
        Maxchargers = 6,
        pos = 1, -- Si es una primaria (1), secundaria (2) u objeto (3 o 4)
        texture = love.graphics.newImage("textures/armas/Enfield.png"),  -- Ajustado el nombre de la textura
        HUD = nil,
        bala = love.graphics.newImage("textures/armas/Bala4.png"),
        auto = false,
        timer = 100
        -- Otras propiedades según sea necesario
    },
    {
        name = "M1014",
        damage = 20,
        fireRate = 0.0,
        ammo = 10,
        maxAmmo = 20,
        dispersion = 0.15,
        chargers = 24,
        Maxchargers = 24,
        pos = 1, -- Si es una primaria (1), secundaria (2) u objeto (3 o 4)
        texture = love.graphics.newImage("textures/armas/M4.png"),  -- Ajustado el nombre de la textura
        HUD = nil,
        bala = love.graphics.newImage("textures/armas/Bala2.png"),
        auto = true,
        timer = 100
        -- Otras propiedades según sea necesario
    },
    {
        name = "MP-18",
        damage = 12.625,
        fireRate = 0.08,
        ammo = 32,
        maxAmmo = 32,
        dispersion = 0.05,
        chargers = 3,
        Maxchargers = 3,
        pos = 4, -- Si es una primaria (1), secundaria (2) u objeto (3 o 4)
        texture = love.graphics.newImage("textures/armas/MP-18.png"),  -- Ajustado el nombre de la textura
        HUD = nil,
        bala = love.graphics.newImage("textures/armas/Bala3.png"),
        auto = true,
        timer = 100
        -- Otras propiedades según sea necesario
    },
    {
        name = "Pistola",
        damage = 56,
        fireRate = 0.0,  -- Disparos por segundo
        ammo = 16,
        maxAmmo = 16,
        dispersion = .1, -- Número en milímetros de la dispersión
        chargers = 5,
        Maxchargers = 5,
        pos = 2, -- Si es una primaria (1), secundaria (2) u objeto (3 o 4)
        texture = love.graphics.newImage("textures/armas/Pistola.png"),
        HUD = nil,
        bala = love.graphics.newImage("textures/armas/Bala.png"),
        auto = false,
        timer = 100
        -- Otras propiedades según sea necesario
    },
    {
        name = "Colt 1911",
        damage = 60,
        fireRate = 0.5,  -- Disparos por segundo
        ammo = 7,
        maxAmmo = 7,
        dispersion = .06, -- Número en milímetros de la dispersión
        chargers = 4,
        Maxchargers = 4,
        pos = 2, -- Si es una primaria (1), secundaria (2) u objeto (3 o 4)
        texture = love.graphics.newImage("textures/armas/Colt 1911.png"),
        HUD = nil,
        bala = love.graphics.newImage("textures/armas/Bala5.png"),
        auto = false,
        timer = 100
        -- Otras propiedades según sea necesario
    },
    {
        name = "MediKit",
        damage = -20,
        fireRate = 0.5,
        ammo = 8,
        maxAmmo = 8,
        dispersion = 4,
        chargers = 1,
        Maxchargers = 1,
        pos = 3, -- Si es una primaria (1), secundaria (2) u objeto (3 o 4)
        texture = love.graphics.newImage("textures/armas/MediKit.png"),  -- Ajustado el nombre de la textura
        HUD = nil,
        bala = love.graphics.newImage("textures/armas/MediKit.png"),
        auto = false,
        timer = 1
        -- Otras propiedades según sea necesario
    },
    {
        name = "FGM-172",
        damage = 600,
        fireRate = 8,
        ammo = 3,
        maxAmmo = 3,
        dispersion = 1 / 7000,
        chargers = 2,
        Maxchargers = 2,
        pos = 4, -- Si es una primaria (1), secundaria (2) u objeto (3 o 4)
        texture = love.graphics.newImage("textures/armas/Predator.png"),  -- Ajustado el nombre de la textura
        HUD = nil,
        bala = love.graphics.newImage("textures/armas/Misile_1.png"),
        auto = false,
        timer = 100
    }
}

-- AI --

local cellSize = 32  -- Tamaño de cada celda en píxeles
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

local aiShootCooldown = 1.45          -- Tiempo en segundos entre ráfagas
local aiLastShotTime = 0           -- Momento del último disparo de la IA
local aiBulletsPerBurst = 6        -- Número de balas por ráfaga
local aiBulletInterval = 0.0075       -- Tiempo entre cada bala en la ráfaga (segundos)
local aiCurrentBurstCount = 0      -- Contador de balas disparadas en la ráfaga
local aiBurstTime = 0              -- Temporizador para la ráfaga
local aiShootingBurst = false      -- Controla si la IA está disparando una ráfaga

local pathIndex = 1

function updateAI(dt)
    -- Actualizar el temporizador del disparo
    aiLastShotTime = aiLastShotTime + dt

    -- Si no está disparando una ráfaga y ha pasado suficiente tiempo, iniciar una ráfaga
    if not aiShootingBurst and aiLastShotTime >= aiShootCooldown then
        aiShootingBurst = true
        aiCurrentBurstCount = 0
        aiBurstTime = 0
        aiLastShotTime = 0  -- Reiniciar el temporizador de la ráfaga
    end

    -- Si está disparando una ráfaga
    -- if aiShootingBurst then
    --    aiBurstTime = aiBurstTime + dt
        
        -- Disparar cada `aiBulletInterval` segundos durante la ráfaga
        -- if aiBurstTime >= aiBulletInterval then
        --    -- shootAIBullet()  -- Disparar una bala pero está desactivado por ahora...
        --    aiCurrentBurstCount = aiCurrentBurstCount + 1
        --    aiBurstTime = 0  -- Reiniciar el temporizador de la ráfaga

            -- Si ha disparado todas las balas de la ráfaga, detener la ráfaga
        --    if aiCurrentBurstCount >= aiBulletsPerBurst then
        --        aiShootingBurst = false
        --    end
        -- end
    -- end
end

function shootAIBullet()
    -- Calcular la dirección hacia el jugador
    local directionX = player.x - vehicle.x
    local directionY = player.y - vehicle.y
    local magnitude = math.sqrt(directionX^2 + directionY^2)

    -- Normalizar la dirección
    directionX = directionX / magnitude
    directionY = directionY / magnitude

    -- Aplicar dispersión en un ángulo aleatorio
    local dispersionAngle = (math.random() - 0.5) * vehicle.inHand.dispersion -- Ángulo en radianes
    local cosAngle = math.cos(dispersionAngle)
    local sinAngle = math.sin(dispersionAngle)

    -- Rotar la dirección original con el ángulo de dispersión
    local spreadX = directionX * cosAngle - directionY * sinAngle
    local spreadY = directionX * sinAngle + directionY * cosAngle

    -- Crear la bala con la dirección dispersa
    local bullet = {
        x = vehicle.x + vehicle.width / 2,
        y = vehicle.y + vehicle.height / 2,
        r = vehicle.inHand.radius or 5,
        time = vehicle.inHand.timer or 100,
        TtoDraw = vehicle.inHand.ActivationTimer or 0,
        damage = vehicle.inHand.damage or 10,
        image = vehicle.inHand.bala,
        angle = math.atan2(spreadY, spreadX) or 0,
        team = 2,
        dx = spreadX * vehicleBulletSpeed,
        dy = spreadY * vehicleBulletSpeed
    }

    table.insert(vehicleBullets, bullet)
end

function table.contains(table, element)
    for _, value in pairs(table) do
        if value.x == element.x and value.y == element.y then
            return true
        end
    end
    return false
end

function astar(start, goal, obstacles)
    local openSet = {}
    local cameFrom = {}
    local gScore = {}
    local fScore = {}
    local MaxNodes = 200

    -- Verificar si una celda está ocupada por un obstáculo
    local function isObstacle(cellX, cellY)
        for _, obstacle in ipairs(obstacles) do
            if not obstacle.traversable then  -- Solo verificar si el obstáculo no es transpasable
                -- Calcular los límites del obstáculo en términos de celdas
                local obstacleLeft = obstacle.x
                local obstacleRight = obstacle.x + obstacle.width
                local obstacleTop = obstacle.y
                local obstacleBottom = obstacle.y + obstacle.height

                -- Convertir las coordenadas de la celda a píxeles
                local cellPixelX, cellPixelY = toPixel(cellX, cellY)

                -- Verificar si la celda (convertida a píxeles) está dentro del área del obstáculo
                if cellPixelX >= obstacleLeft and cellPixelX < obstacleRight and
                   cellPixelY >= obstacleTop and cellPixelY < obstacleBottom then
                    return true  -- La celda está ocupada por un obstáculo no transpasable
                end
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
                    if not table.contains(openSet, {x = neighborX, y = neighborY}) then
                        table.insert(openSet, {x = neighborX, y = neighborY})
                    end
                end
            end
        end
    end

    return nil  -- Si no hay camino
end

aiEnabled = false  -- Variable para habilitar/deshabilitar la IA
local function toggleAI()
    aiEnabled = not aiEnabled
end

function calculatePathForIA(ia, Point)
    local start = {x = ia.x, y = ia.y}
    local goal = {x = IAatackPoints[Point].x, y = IAatackPoints[Point].y}
    ia.path = astar(start, goal, obstacles)
    ia.currentPathIndex = 1
end

-- Función para inicializar una copia de IA con un camino
function spawnIACopy(x, y, team)
    local newIA = {
        x = x or math.random(0, love.graphics.getWidth() - vehicle.width),
        y = y or math.random(0, love.graphics.getHeight() - vehicle.height),
        speed = 200,
        width = vehicle.width,
        height = vehicle.height,
        direction = "Der",
        lastDirection = {x = 1, y = 0},
        isShooting = false,
        path = nil,  -- Inicialmente sin camino
        currentPathIndex = 1,
        health = 200,  -- Nueva salud de la IA
        team = team,
        PointCamping = math.random(1, 3)
    }
    table.insert(IACopies, newIA)
    calculatePathForIA(newIA, newIA.PointCamping)
end

function shootIABurst(ia, team)
    local numBullets = 5  -- Número de balas en la ráfaga
    local spread = math.pi / 6  -- Ángulo de dispersión en radianes (30 grados)
    local startAngle = math.atan2(ia.lastDirection.y, ia.lastDirection.x) - spread / 2

    for i = 0, numBullets - 1 do
        local angle = startAngle + (i / (numBullets - 1)) * spread
        local dx = math.cos(angle) * vehicleBulletSpeed
        local dy = math.sin(angle) * vehicleBulletSpeed

        local bullet = {
            x = ia.x + ia.width / 2,
            y = ia.y + ia.height / 2,
            dx = dx,
            dy = dy,
            team = team
        }
        table.insert(vehicleBullets, bullet)
    end
end

-- sip, esto no existia...
function math.sign(x)
    if x > 0 then
        return 1
    elseif x < 0 then
        return -1
    else
        return 0
    end
end

-- Tamaño de los chunks
local chunkSize = 64

-- Función para obtener la coordenada del chunk
function getChunk(x, y)
    local chunkX = math.floor(x / chunkSize)
    local chunkY = math.floor(y / chunkSize)
    return chunkX, chunkY
end

local worldChunks = {}

function getEntitiesInChunk(chunkX, chunkY)
    if worldChunks[chunkX] and worldChunks[chunkX][chunkY] then
        return worldChunks[chunkX][chunkY].entities
    end
    return {}
end

-- Obtener entidades (IA) cercanas en los chunks adyacentes
function getNearbyIACopies(ia)
    local chunkX, chunkY = getChunk(ia.x, ia.y)
    local nearbyIACopies = {}

    -- Recorre el chunk y sus vecinos
    for i = -1, 1 do
        for j = -1, 1 do
            local entitiesInChunk = getEntitiesInChunk(chunkX + i, chunkY + j)
            for _, entity in ipairs(entitiesInChunk) do
                table.insert(nearbyIACopies, entity)
            end
        end
    end

    return nearbyIACopies
end


-- Función principal para actualizar IA
function updateIACopies(dt, player)
    for b, ia in ipairs(IACopies) do
        
        -- Verificar si la IA tiene un camino y el índice es válido
        if ia.path and ia.currentPathIndex <= #ia.path then
            -- Movimiento de la IA basado en la ruta
            local targetNode = ia.path[ia.currentPathIndex]
            local targetX, targetY = toPixel(targetNode.x, targetNode.y)
            local dx, dy = targetX - ia.x, targetY - ia.y
            local distance = math.sqrt(dx * dx + dy * dy)

            if distance < ia.speed * dt then
                ia.x = targetX
                ia.y = targetY
                ia.currentPathIndex = ia.currentPathIndex + 1
            else
                ia.x = ia.x + (dx / distance) * ia.speed * dt
                ia.y = ia.y + (dy / distance) * ia.speed * dt
            end

            -- Si ha llegado al final del camino, recalcular
            if ia.currentPathIndex > #ia.path then
                calculatePathForIA(ia, ia.PointCamping)
                ia.currentPathIndex = 1
            end
        elseif not ia.path then
            calculatePathForIA(ia, ia.PointCamping)
            print("Recalculando ruta para ia N." .. b)
            ia.PointCamping = math.random(1, 3)
            ia.currentPathIndex = 1
        end

        -- Calcular el ángulo hacia la entidad más cercana
        local closestEntity
        local closestDistance = math.huge

        -- IA del Team 1 busca enemigo más cercano
        if ia.team == 1 then
            for _, otherIA in ipairs(IACopies) do
                if otherIA.team ~= ia.team then  -- Solo enemigos
                    local distanceToOther = math.sqrt((otherIA.x - ia.x)^2 + (otherIA.y - ia.y)^2)
                    if distanceToOther < closestDistance then
                        closestDistance = distanceToOther
                        closestEntity = otherIA
                    end
                end
            end
        else
            -- IA del Team 2
            closestEntity = player
            closestDistance = math.sqrt((FlagPoint.x - ia.x)^2 + (FlagPoint.y - ia.y)^2)

            -- Buscar IA aliada más cercana
            for _, otherIA in ipairs(IACopies) do
                if otherIA.team == 1 then  -- Solo aliadas
                    local distanceToOther = math.sqrt((otherIA.x - ia.x)^2 + (otherIA.y - ia.y)^2)
                    if distanceToOther < closestDistance then
                        closestDistance = distanceToOther
                        closestEntity = otherIA
                    end
                end
            end
        end

        -- Calcular el ángulo hacia la entidad más cercana
        if closestEntity then
        local dx, dy = closestEntity.x - ia.x, closestEntity.y - ia.y
        local angleToTarget = math.atan2(dy, dx)

        -- Limitar el rango de rotación a 90 grados
        local directionAngle = math.atan2(ia.lastDirection.y, ia.lastDirection.x)
        local angleDifference = (angleToTarget - directionAngle + math.pi) % (2 * math.pi) - math.pi
        local maxRotation = math.pi / 4  -- 45 grados en radianes

        if math.abs(angleDifference) > maxRotation then
            angleToTarget = directionAngle + math.sign(angleDifference) * maxRotation
        end

        -- Actualizar la dirección de la IA
        ia.lastDirection.x = math.cos(angleToTarget)
        ia.lastDirection.y = math.sin(angleToTarget)

        -- Activar el disparo basado en la distancia a la entidad más cercana
        local distanceToTarget = math.sqrt(dx * dx + dy * dy)
        ia.isShooting = distanceToTarget < 700  -- Dispara si está a menos de 700 píxeles de la entidad más cercana
        end

        -- Comportamiento de disparo
        ia.shootTimer = (ia.shootTimer or 0) - dt
        if ia.isShooting and ia.shootTimer <= 0 then
            if ia.team == 1 then
                shootIABurst(ia, 1)  -- Disparar como aliada
            elseif ia.team == 2 then
                shootIABurst(ia, 2)  -- Disparar como enemiga
            end
            ia.shootTimer = 2  -- Ajustar el tiempo entre ráfagas
        end
    end

    -- Comprobar colisiones con cada IA usando el sistema de chunks
    for j = #IACopies, 1, -1 do
        local ia = IACopies[j]

        for i, bull in ipairs(vehicleBullets) do
            if checkCollisionRect(bull.x, bull.y, 5, 5, ia.x, ia.y, 37, 37) then
                -- Verificar si los equipos son diferentes
                if ia.team ~= bull.team then
                    ia.health = ia.health - 50
                    table.remove(vehicleBullets, i)
                    if vehicle.inHand.OnDestroyBullet then
                        vehicle.inHand.OnDestroyBullet(bull.x, bull.y, vehicle)
                    end
                    if ia.health <= 0 then
                        table.remove(IACopies, j)
                    end
                end
            end
        end
    end
end

local SWATImage = love.graphics.newImage("Objetos/zombies/car2.png")
SWATImage:setFilter("nearest", "nearest")
function drawIACopies()
    for _, ia in ipairs(IACopies) do
        local angle = math.atan2(ia.lastDirection.y, ia.lastDirection.x)
        if ia.team == 1 then
            love.graphics.setColor(1, 0.3, 0.3)
            else
            love.graphics.setColor(0.3, 0.3, 1)
        end
        love.graphics.draw(SWATImage, ia.x + 11, ia.y + 11, angle, 0.7, 0.7, 18.5, 18.5)
        love.graphics.setColor(1, 1, 1)
    end
end
























--____________________________________________________________________________________________________________________________________________--
function updateBossTank(dt)
    -- Mover el tanque de izquierda a derecha
    bossTank.x = bossTank.x + bossTank.speed * bossTank.direction * dt

    -- Cambiar la dirección cuando llega a los bordes
    for _, obstacle in ipairs(obstacles) do
        if bossTank.x < obstacle.x then
            bossTank.direction = 1  -- Mover a la derecha
        else
            bossTank.direction = 0  -- Mover a la izquierda
        end
    end

    -- Comportamiento de disparo del jefe
    bossTank.shootTimer = bossTank.shootTimer - dt
    if bossTank.shootTimer <= 0 then
        bossTank.isShooting = true
        shootBossTankBullets()
        bossTank.shootTimer = 2  -- Dispara cada 2 segundos
    end

    -- Verificar si la salud del tanque llega a cero para "mandarlo a dormir"
    if bossTank.health <= 0 then
        bossTank.isAsleep = true  -- Marca al tanque como dormido
    end
end

bossTankBullets = {}

function shootBossTankBullets()
    for i = -2, 2 do  -- Disparar 5 balas en un patrón de abanico
        local bullet = {
            x = bossTank.x + bossTank.width / 2,
            y = bossTank.y + bossTank.height,
            dx = i * 50,  -- Dispersar las balas horizontalmente
            dy = 200,  -- Velocidad hacia abajo
            width = 8,
            height = 8
        }
        table.insert(bossTankBullets, bullet)
    end
end

function checkCollisionWithBossTank(bullet)
    if bullet.x + 5 > bossTank.x and bullet.x < bossTank.x + bossTank.width and
       bullet.y + 5 > bossTank.y and bullet.y < bossTank.y + bossTank.height then
        bossTank.health = bossTank.health - player.inHand.damage / 25  -- Ajustar el daño según las balas
        return true
    end
    return false
end

function updateCannonRotation(dt, playerX, playerY)
    -- Calcular el ángulo objetivo directamente
    local targetAngle = math.atan2(playerY - (bossTank.y + 48.5), playerX - (bossTank.x + 150))

    -- Calcular la diferencia mínima de rotación
    local difference = (targetAngle - tankCannon.angle + math.pi) % (2 * math.pi) - math.pi

    -- Ajustar la rotación del cañón hacia el ángulo objetivo
    tankCannon.angle = tankCannon.angle + difference * math.min(1, tankCannon.rotationSpeed * dt)
end

function drawTankCannon()
    love.graphics.draw(
        tankCannonImage,
        bossTank.x + 180, bossTank.y + 48.5,
        tankCannon.angle,  -- Ángulo de rotación
        0.3, 0.3,  -- Escalado (ajustado al 30%)
        tankCannonImage:getWidth() / 3.3, tankCannonImage:getHeight() / 2  -- Centrar el punto de origen en la imagen
    )
end

cannonBullets = {}

function shootCannonBullet(numBullets, spreadAngle)
    local baseAngle = tankCannon.angle

    for i = 1, numBullets do
        -- Calcular el ángulo de cada bala en la ráfaga
        local offset = spreadAngle * (i - (numBullets / 2))
        local bulletAngle = baseAngle + offset

        -- Calcular la posición de la boquilla del cañón
        local bulletStartX = (bossTank.x + 180) + math.cos(bulletAngle) * tankCannon.barrelLength
        local bulletStartY = (bossTank.y + 48.5) + math.sin(bulletAngle) * tankCannon.barrelLength

        -- Crear la bala
        local bullet = {
            x = bulletStartX,
            y = bulletStartY,
            dx = math.cos(bulletAngle) * tankCannon.bulletSpeed,
            dy = math.sin(bulletAngle) * tankCannon.bulletSpeed,
            type = "tank"
        }

    table.insert(vehicleBullets, bullet)
    end
end

function shootMissileFromLauncher(launcher)
    local missileStartX, missileStartY

    -- Determinar la posición del lanzamisiles
    if launcher == "left" then
        missileStartX = (bossTank.x + 180) + leftLauncherOffsetX
        missileStartY = (bossTank.y + 48.5) + leftLauncherOffsetY
    elseif launcher == "right" then
        missileStartX = (bossTank.x + 180) + rightLauncherOffsetX
        missileStartY = (bossTank.y + 48.5) + rightLauncherOffsetY
    end

    -- Calcular la dirección del misil (por ejemplo, hacia el jugador)
    local angleToPlayer = math.atan2(player.y - missileStartY, player.x - missileStartX)
    local missileSpeed = 8000  -- Velocidad del misil

    -- Crear el misil
    local missile = {
        x = missileStartX,
        y = missileStartY,
        dx = math.cos(angleToPlayer) * missileSpeed,
        dy = math.sin(angleToPlayer) * missileSpeed,
        angle = angleToPlayer,  -- Podríamos usar esto para rotar el misil visualmente si es necesario
        type = "misile"
    }

    -- Insertar el misil en la tabla de misiles
    table.insert(vehicleBullets, missile)
end

function shootMissiles()
    shootMissileFromLauncher("left")   -- Disparar desde el lanzamisiles izquierdo
    shootMissileFromLauncher("right")  -- Disparar desde el lanzamisiles derecho
end

function updateMissiles(dt)
    for i, missile in ipairs(vehicleBullets) do
        if missile.type == "misile" then
        -- Recalcular la dirección hacia el jugador (puedes ajustar esto para que no cambie muy rápido)
        local angleToPlayer = math.atan2(player.y - missile.y, player.x - missile.x)
        missile.dx = math.cos(angleToPlayer) * 120
        missile.dy = math.sin(angleToPlayer) * 180

        -- Actualizar la posición del misil
        missile.x = missile.x + missile.dx * dt
        missile.y = missile.y + missile.dy * dt
        end
    end
end

function updateplayerMissiles(dt)
    for _, missile in ipairs(bullets) do
        for _, enemies in ipairs(IACopies) do
            if missile.type == "misile" then
            -- Recalcular la dirección hacia el jugador (puedes ajustar esto para que no cambie muy rápido)
            local angleToPlayer = math.atan2(enemies.y - missile.y, enemies.x - missile.x)
            missile.dx = math.cos(angleToPlayer) * 120
            missile.dy = math.sin(angleToPlayer) * 180

            -- Actualizar la posición del misil
            missile.x = missile.x + missile.dx * dt
            missile.y = missile.y + missile.dy * dt
            end
        end
    end
end

function drawMissiles()
    for _, missile in ipairs(vehicleBullets) do
        missile.angle = math.atan2(player.y - missile.y, player.x - missile.x)
        -- Dibuja el misil con rotación basada en su ángulo
        if missile.type == "misile" then
        -- Dibuja el misil con rotación basada en su ángulo
        love.graphics.draw(
            tankCannon.missileImage,  -- Imagen del misil
            missile.x, missile.y,  -- Posición del misil
            missile.angle,  -- Ángulo en radianes (rotación)
            1, 1,  -- Escala en X y Y
            tankCannon.missileImage:getWidth() / 2,  -- Offset X para rotar desde el centro
            tankCannon.missileImage:getHeight() / 2  -- Offset Y para rotar desde el centro
        )
        end
    end
end































--____________________________________________________________________________________________________________________________________________--
-- Función para mover la cámara
function camera:move(dx, dy)
    -- Centramos la cámara en la posición del jugador
    self.x = dx - (love.graphics.getWidth() / 2) / self.scale
    self.y = dy - (love.graphics.getHeight() / 2) / self.scale
end
-- Función para configurar la cámara antes de dibujar
function camera:set()
    local distance = math.sqrt((vehicle.x - player.x)^2 + (vehicle.y - player.y)^2)
    local minDistance = 100
    local maxDistance = 600
    local minZoom = .45
    local maxZoom = .45
    if camera.isActive then
        self.scale = math.max(minZoom, math.min(maxZoom, maxZoom - ((distance - minDistance) / (maxDistance - minDistance)) * (maxZoom - minZoom))) * 3 / 2
    else
        self.scale = 1
    end


    love.graphics.push()
    love.graphics.scale(self.scale, self.scale) -- Escalar si es necesario
    love.graphics.translate(-self.x, -self.y) -- Trasladar la vista
end
-- Función para restaurar la vista
function camera:unset()
    love.graphics.pop() -- Restaurar la transformación
end
-- Tamaño de cada chunk de fondo
local chunkSize = 256
local backgroundChunks = {}
function generateChunk(cx, cy)
    return {
        x = cx * chunkSize,
        y = cy * chunkSize,
        color = {math.random(), math.random(), math.random()} -- Color aleatorio para simular diferentes chunks
    }
end
function updateVisibleChunks()
    -- Calcular los límites visibles en base a la cámara
    local startX = math.floor(camera.x / chunkSize)
    local startY = math.floor(camera.y / chunkSize)
    local endX = math.floor((camera.x + love.graphics.getWidth()) / chunkSize) + 64 * camera.scale
    local endY = math.floor((camera.y + love.graphics.getHeight()) / chunkSize) + 64 * camera.scale

    -- Generar los chunks necesarios para los límites visibles
    for cx = startX, endX do
        for cy = startY, endY do
            if not backgroundChunks[cx] then
                backgroundChunks[cx] = {}
            end
            if not backgroundChunks[cx][cy] then
                backgroundChunks[cx][cy] = generateChunk(cx, cy)
            end
        end
    end

    -- Eliminar los chunks que ya no son visibles
    for cx, column in pairs(backgroundChunks) do
        for cy, chunk in pairs(column) do
            if cx < startX or cx > endX or cy < startY or cy > endY then
                backgroundChunks[cx][cy] = nil -- Eliminar chunk
            end
        end
        -- Eliminar la columna si está vacía
        if next(backgroundChunks[cx]) == nil then
            backgroundChunks[cx] = nil
        end
    end
end
local floorImageNT = love.graphics.newImage("textures/obstacle/outgrass1.png")
function drawBackground()
    for cx, column in pairs(backgroundChunks) do
        for cy, chunk in pairs(column) do
            love.graphics.draw(floorImageNT, chunk.x, chunk.y, 0, chunkSize / floorImageNT:getWidth(), chunkSize / floorImageNT:getHeight())
        end
    end
end
























--____________________________________________________________________________________________________________________________________________--
local vehicles = {}  -- Creamos una tabla para almacenar la información de los vehículos
local vehiclesLoad = {}
local loadedVehicles = {}
local vehicleImage = love.graphics.newImage("textures/vehicles/car1.png")
local vehicleImage2 = love.graphics.newImage("textures/vehicles/car2.png")
local vehicleImage3 = love.graphics.newImage("textures/vehicles/car3.png")
local vehicleImage4 = love.graphics.newImage("textures/vehicles/car4.png")
local vehicleImage5 = love.graphics.newImage("Objetos/Objects/deadVoddy.png")
local BackGroundEndingImage = love.graphics.newImage("HUD/NoGame/EndRoundBackGround.png")
local RecoilerinEndingImage = love.graphics.newImage("HUD/NoGame/EndRound.png")
local NEXTImage = love.graphics.newImage("HUD/InGame/NEXT.png")
vehicleImage:setFilter("nearest", "nearest")
vehicleImage2:setFilter("nearest", "nearest")
vehicleImage3:setFilter("nearest", "nearest")
vehicleImage4:setFilter("nearest", "nearest")
local LifeAmmo = love.graphics.newImage("HUD/InGame/Life&ammo.png")
LifeAmmo:setFilter("nearest", "nearest")
local Point = love.graphics.newImage("HUD/InGame/Point.png")
Point:setFilter("nearest", "nearest")
local Pointer = love.graphics.newImage("HUD/InGame/Pointer.png")
Pointer:setFilter("nearest", "nearest")
local Pointered = love.graphics.newImage("HUD/InGame/Pointered.png")
Pointered:setFilter("nearest", "nearest")
local HelpPoint = love.graphics.newImage("HUD/InGame/HelpPoint.png")
HelpPoint:setFilter("nearest", "nearest")
local Direcction = love.graphics.newImage("HUD/InGame/Direcction.png")
Direcction:setFilter("nearest", "nearest")
local DoGround = love.graphics.newImage("HUD/BackGround.png")
DoGround:setFilter("nearest", "nearest")
math.randomseed(os.time())
-- Cinematica
    PositionWon = -100
    BBlu = -500
    Bpurp = -100
    InGame = true
-- Función para cargar los vehículos desde un archivo
-- Añadir estas variables globales
local selectedSlot = nil  -- Controla el arma que se desea reemplazar
local selectedWeapon = nil  -- Controla el arma seleccionada para reemplazar
vehicleDashSpeed = 800
vehicleDashDuration = 0.01
vehicleIsDashing = false
vehicleDashTimeLeft = 0
vehicleBullets = {}
vehicleBulletSpeed = 500
vehicleBulletCooldown = 0.5
local menuActive = false  -- Controla si el menú está activo
local page = 1
local itemsPerPage = 5  -- Cantidad de armas por página
-- Jugador 2
vehicle = {
    x = 192,  -- Coordenada X
    y = 160,  -- Coordenada Y
    speed = 200,  -- Velocidad
    width = 25,  -- Anchura
    height = 25,  -- Altura
    rotate = 90,  -- HitBox
    HBox = 45,  -- HitBox
    death = false,  -- Muerte
    image = vehicleImage,
    image2 = vehicleImage2,
    image3 = vehicleImage3,
    image4 = vehicleImage4,
    deadIm = vehicleImage5,
    Direction = "Der",
    health = 200,  -- Salud
    currentPath = {},  -- Ruta actual
    pathIndex = 1,  -- Índice de la ruta
    reloadT = 0,  -- Tiempo de recarga
    inHand = {}
}
vehicleTimeSinceLastShot = 0
vehicleLastDirection = {x = 0.5, y = 0.5}  -- Por defecto disparará hacia la derecha
objects = {}

function createObject(x, y, width, height, onTouchFunction, image, lifeTime, caller, useCollider)
    local obj = {
        x = x,
        y = y,
        width = width,
        height = height,
        onTouch = onTouchFunction,
        isTouched = false,
        isActive = true,
        image = image,
        collisionable = useCollider or true,
        lifeTime = lifeTime or 10,  -- Tiempo en segundos antes de desaparecer (por defecto 10 segundos)
        timer = 0,  -- Temporizador para el tiempo de vida
        caller = caller or function()end
    }
    table.insert(objects, obj)
end

local randomVariable = 0
local minTimeBetweenReloads = 0.5
local timeSinceLastReload = 0
-- Definición de la entidad Bullet
local Bullet = {
    x = 0,
    y = 0,
    speed = 500,
    angle = 0,
    isActive = false,
}

function loadLUAFiles(Table, Path)
    local weaponFiles = love.filesystem.getDirectoryItems(Path)

    for _, file in ipairs(weaponFiles) do
        if file:match("%.lua$") then
            local weaponPath = Path .. file

            local chunk, errorMessage = love.filesystem.load(weaponPath)
            if chunk then
                local weapone = chunk()
                if weapone and type(weapone) == "table" then
                    table.insert(Table, weapone)
                else
                    print("El archivo no devolvió una tabla: " .. file)
                end
            else
                print("Error al cargar el archivo: " .. errorMessage)
            end
        end
    end
end
for i, weapon in ipairs(gun) do
    local imagePath = "HUD/InGame/Guns/" .. weapon.name .. ".png"
    if love.filesystem.getInfo(imagePath) then
        weapon.HUD = love.graphics.newImage(imagePath)
    else
        print("Error: No se encontró la imagen para " .. weapon.name)
        weapon.HUD = nil  -- O una textura por defecto
    end
end
local level = 1
local levelsFolder = "Levels/"
if true then
    obstaclesFile = "obstacles" .. level .. ".txt"
end
-- Función para verificar colisiones entre dos rectángulos
function checkCollisionRect(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and
           x2 < x1 + w1 and
           y1 < y2 + h2 and
           y2 < y1 + h1
end
-- Función para verificar colisiones entre el jugador y los obstáculos
function checkCollision(x, y, w, h)
    for _, obstacle in ipairs(obstacles) do
        if not obstacle.traversable and checkCollisionRect(x, y, w, h, obstacle.x, obstacle.y, obstacle.width, obstacle.height) then
            return true
        end
    end
    return false
end
local backgroundTextures = {}  -- Almacena las texturas para el fondo
local backgroundMatrix = {}    -- Matriz 2D para asignar tipos de textura al fondo
local Refoirment = false       -- Tamaño del mosaico
local tileSize = 1     
H = true
G = true
D = true
K = true
local imageCache = {}  -- Tabla para almacenar imágenes ya cargadas
numberIm = 1

function getImage(path)
    if not imageCache[path] then
        imageCache[path] = love.graphics.newImage(path)
        print("Cargando imagen: " .. path .. " (Número " .. numberIm .. ")")
        numberIm = numberIm + 1
    end
    return imageCache[path]  -- Devuelve la imagen ya cargada
end

function loadObstacles()
    local levels = {}
    local levelIndex = 1
    local firstLevelObstacles = {}
    local firstLines = {}

    while true do
        local obstaclesFile = "obstacles" .. levelIndex .. ".txt"
        local path = levelsFolder .. obstaclesFile

        if not love.filesystem.getInfo(path) then
            break
        end

        local content, _ = love.filesystem.read(path)
        local obstacles = {}
        local isFirstLine = true

        for line in content:gmatch("[^\r\n]+") do
            if isFirstLine then
                local firstLineValues = {}
                local count = 0
                for val in line:gmatch("[^,]+") do
                    count = count + 1
                    if count == 5 then
                        table.insert(firstLineValues, val == "true")
                    elseif count == 6 then
                        local imgPath = "Levels/ImageLevels x64/" .. val .. ".png"
                        table.insert(firstLineValues, getImage(imgPath))
                    else
                        table.insert(firstLineValues, tonumber(val))
                    end
                end
                table.insert(firstLines, firstLineValues)
                isFirstLine = false
            else
                local values = {}
                for val in line:gmatch("[^,]+") do
                    table.insert(values, val)
                end

                local imgPath = "textures/obstacle/" .. values[6]
                local obstacle = {
                    x = tonumber(values[1]),
                    y = tonumber(values[2]),
                    width = tonumber(values[3]),
                    height = tonumber(values[4]),
                    lar = tonumber(values[5]),
                    image = getImage(imgPath),  -- Usar la función de caché
                    traversable = values[7] == "true",
                    layer = values[8]
                }
                
                table.insert(obstacles, obstacle)
            end
        end

        if levelIndex == 1 then
            firstLevelObstacles = obstacles
        else
            levels[levelIndex - 1] = { obstacles = obstacles }
        end

        levelIndex = levelIndex + 1
    end

    if levelIndex == 1 then
        print("Error: No se encontró ningún archivo de nivel.")
        return {}, {}, {}, {}
    else
        return firstLevelObstacles, levels, firstLines
    end
end

-- Cargar niveles y establecer nivel actual
obstacles, levels, firstLines = loadObstacles()
currentLevel = 1
LD = true
function drawPoints(x, y, points, scale, spacing)
    local digitWidth = numbers[0].width

    -- Convertir el número a una cadena para procesar cada dígito
    local pointsStr = tostring(points)

    for i = 1, #pointsStr do
        local digit = tonumber(pointsStr:sub(i, i))
        local img = numbers[digit].image
        local scaleX = numbers[digit].width / img:getWidth()
        local scaleY = numbers[digit].height / img:getHeight()
        love.graphics.draw(img, x + (i - 1) * (digitWidth + spacing), y, 0, scaleX * scale, scaleY * scale)
    end
end

-- Función de carga
function love.load()
    love.window.setTitle("FieldOfView")
    love.window.setMode(1000, 750)
    NewGame()
    collectgarbage("collect")
    updateVisibleChunks()
    -- Ocultar el cursor del mouse dentro de la ventana del juego
    love.mouse.setVisible(false)
    -- Crear matriz 2D para el fondo con tipos de texturas aleatorios
    for x = 1, math.ceil(5 / tileSize) do
        backgroundMatrix[x] = {}
        for y = 1, math.ceil(5 / tileSize) do
            backgroundMatrix[x][y] = math.random(1, #backgroundTextures)
        end
    end


    -- Cargar imágenes de números
    numbers = {}
    for i = 0, 9 do
        local img = love.graphics.newImage("Objetos/Numbers/" .. i .. ".png")
        -- Escalar la imagen al 4.5% de su tamaño original
        img:setFilter("nearest", "nearest")
        numbers[i] = {
            image = img,
            width = img:getWidth() * 0.045,
            height = img:getHeight() * 0.045
        }
    end

    -- anim humo --
    -- Cargar imágenes de Humos
    Bsmoke = {}
    for i = 1, 8 do
        local img = love.graphics.newImage("Objetos/Objects/humos Big Smoke/" .. i .. ".png")
        img:setFilter("nearest", "nearest")
        Bsmoke[i] = {
            image = img
        }
    end

    Bigsmokes = Bsmoke[1].image


    -- Inicializar puntos
    player1Points = 0
    player2Points = 0

    -- Cargar armas adicionales desde archivos
    loadLUAFiles(gun ,"Objetos/guns/")
    loadLUAFiles(loadedVehicles, "Objetos/LevelVehicles/")
    loadLUAFiles(vehiclesLoad, "Levels/VehiclesLevels/")


    player.inHand = gun[1]
    vehicle.inHand = deepCopy(gun[1])
    player.inHand.ammo = player.inHand.maxAmmo

    for i = 1, #gun do
        local weapon = gun[i]  -- Obtener arma actual
        if type(weapon.texture) == "string" then  -- Si es un string, convertirlo en imagen
            weapon.texture = I_W[weapon.texture] or weapon.texture  -- Si no existe, mantener el string
        end
    end

    -- Cargar las texturas para el fondo
    for i = 1, 5 do  -- Puedes ajustar el número según sea necesario
        local texture = love.graphics.newImage("textures/obstacle/outgrass" .. i .. ".png")
        texture:setFilter("nearest", "nearest")
        table.insert(backgroundTextures, texture)
    end

    BAblue = love.graphics.newImage("HUD/NoGame/BackGroundBlue.png")
    BAGree = love.graphics.newImage("HUD/NoGame/BackGroundGreen.png")
    BApurp = love.graphics.newImage("HUD/NoGame/BackGroundPurple.png")
    Won = love.graphics.newImage("HUD/NoGame/WON.png")
    Wan = love.graphics.newImage("HUD/NoGame/WAN.png")
    HealthIM = love.graphics.newImage("Objetos/Objects/Health.png")
    GunsIM = love.graphics.newImage("Objetos/Objects/Weapons.png")

    -- Cargar las imágenes de los obstáculos
    for _, obstacle in ipairs(obstacles) do
        obstacle.image:setFilter("nearest", "nearest")  -- Configurar el filtro de la imagen para pixel art
    end

    -- Crear frames de animación para el jugador
for i = 1, 4 do
    local framePath = "player/idle/frame" .. i .. ".png"
    if love.filesystem.getInfo(framePath) then
        table.insert(player.frames, love.graphics.newImage(framePath))
    else
        break  -- Salir del bucle si no existe el frame
    end
end

for i = 1, 6 do
    local framePath = "player/walk/frame" .. i .. ".png"
    if love.filesystem.getInfo(framePath) then
        table.insert(player.frames, love.graphics.newImage(framePath))
    else
        break  -- Salir del bucle si no existe el frame
    end
end
     -- Configurar el punto de origen del personaje para rotar alrededor del centro
     player.originX = player.frames[1]:getWidth() / 2
     player.originY = player.frames[1]:getHeight() / 2

    -- Configurar las animaciones del jugador
    player.animations["idle"] = {1, 2, 3, 4}
    player.animations["walk"] = {1, 2, 3, 4}

    -- Establecer la animación inicial
    player.currentAnimation = "idle"
end

function shootVehicleBullet()
    local bullet = {
        x = vehicle.x + vehicle.width / 2,
        y = vehicle.y + vehicle.height / 2,
        dx = vehicleLastDirection.x * vehicleBulletSpeed,
        dy = vehicleLastDirection.y * vehicleBulletSpeed
    }
    table.insert(vehicleBullets, bullet)
end

function updateVehicleBullets(dt)
    for i = #vehicleBullets, 1, -1 do
        local bullet = vehicleBullets[i]
        if bullet then
        bullet.x = bullet.x + bullet.dx * dt
        bullet.y = bullet.y + bullet.dy * dt

            -- Colisión con el jugador
            if checkCollisionRect(bullet.x, bullet.y, 5, 5, player.x, player.y, player.width, player.height) and not menuActive and not AsWon and not player.death then
                table.remove(vehicleBullets, i)
                if vehicle.inHand.OnDestroyBullet then
                    vehicle.inHand.OnDestroyBullet(bullet.x, bullet.y, vehicle)
                end
                if bullet.damage then
                    player.health = player.health - bullet.damage
                else
                    player.health = player.health - 35
                end
                -- Aquí lo que sucede cuando una bala impacta al jugador --
            elseif bullet.time and bullet.TtoDraw then
                bullet.time = bullet.time - dt
                bullet.TtoDraw = bullet.TtoDraw - dt
                if bullet.time <= 0 then
                    table.remove(vehicleBullets, i)
                    if vehicle.inHand.OnDestroyBullet then
                        vehicle.inHand.OnDestroyBullet(bullet.x, bullet.y, vehicle)
                    end
                end
            end
            
        for i, vehicle in ipairs(vehicles) do
            if bullet then
                if checkCollisionRect(bullet.x, bullet.y, 5, 5, vehicle.x, vehicle.y, vehicle.height, vehicle.height) then
                    table.remove(vehicleBullets, i)
                    vehicle.health = vehicle.health - 0.5
                    for _, bullet in ipairs(bullets) do
                        if checkCollisionRect(bossTank.x, bossTank.y, bossTank.width, bossTank.height, vehicle.x, vehicle.y, vehicle.height, vehicle.height) and checkCollisionRect(bullet.x, bullet.y, 5, 5, vehicle.x, vehicle.y, vehicle.width, vehicle.height) then
                            bossTank.health = bossTank.health - 200
                            table.remove(vehicles, i)
                        end
                    end
                elseif vehicle.health <= 0 then
                    print("Vehicle destroyed!")
                    player.inVehicle = false
                    player.inHand = weapons[1]
                    table.remove(vehicles, i)
                end
            end
        end

            -- Colisión con los bordes de la pantalla
            if not camera.isActive then
                if bullet.x < 0 or bullet.x > love.graphics.getWidth() or bullet.y < 0 or bullet.y > love.graphics.getHeight() then
                    table.remove(vehicleBullets, i)
                end
            end

            -- Colisión con objetos del mapa (por ejemplo, paredes)
            for _, obstacle in ipairs(obstacles) do
                if obstacle.lar == 1 and checkCollisionRect(bullet.x, bullet.y, 5, 5, obstacle.x, obstacle.y, obstacle.width, obstacle.height) and not obstacle.traversable then
                    table.remove(vehicleBullets, i)
                    break
                end
            end
        end
    end
end

function startVehicleDash(dt)

    local function isCollidingWithObstacle(x, y)
        for _, obstacle in ipairs(obstacles) do
            if x < obstacle.x + obstacle.width and
               x + vehicle.width > obstacle.x and
               y < obstacle.y + obstacle.height and
               y + vehicle.height > obstacle.y and
               not obstacle.traversable then
                return true
            end
        end
        return false
    end

    if vehicleDashTimeLeft < 0.15 and vehicleIsDashing then
        vehicleIsDashing = true
        vehicleDashTimeLeft = math.min(vehicleDashTimeLeft + dt, 0.15)

        local nextX, nextY = vehicle.x, vehicle.y

        -- Calcular la próxima posición según la dirección
        if vehicle.Direction == "Up" then
            nextY = vehicle.y - (vehicleDashSpeed * vehicleDashDuration) * dt / 0.01
        elseif vehicle.Direction == "Dwn" then
            nextY = vehicle.y + (vehicleDashSpeed * vehicleDashDuration) * dt / 0.01
        elseif vehicle.Direction == "Izq" then
            nextX = vehicle.x - (vehicleDashSpeed * vehicleDashDuration) * dt / 0.01
        elseif vehicle.Direction == "Der" then
            nextX = vehicle.x + (vehicleDashSpeed * vehicleDashDuration) * dt / 0.01
        end

        -- Verificar si la próxima posición está libre de obstáculos
        if not isCollidingWithObstacle(nextX, nextY) then
            vehicle.x = nextX
            vehicle.y = nextY
        else
            -- Si hay colisión, detener el dash
            vehicleIsDashing = false
            vehicleDashTimeLeft = 0
        end
    end
end

CarDefault = love.graphics.newImage("Objetos/Vehicles/Car_1.png")
function NewGame(currentLevel)
    collectgarbage("collect")
    bullets = {}
    player.inVehicle = false
    player.inHand.ammo = player.inHand.maxAmmo
    WonScale = 35
    vehicles = {}
    vehicleBullets = {}
    if player.seat then player.seat.occupied = false end -- Liberar el asiento
    player.vehicle = nil
    objects = {}
    IACopies = {}
    collectgarbage("collect")
    vehicle.health = 200
    vehicle.currentPath = {}
    player.health = 200
    currentLevel = currentLevel or math.random(2, #levels)
    for _, DataV in ipairs(vehiclesLoad) do
        if DataV.name == currentLevel + 1 then
            vehicles = deepCopy(DataV.All)
        end
    end
    selectedLine = firstLines[currentLevel + 1]
    if selectedLine then
        player.x = selectedLine[1]
        player.y = selectedLine[2]
        vehicle.x = selectedLine[3]
        vehicle.y = selectedLine[4]
        FlagPoint.x = selectedLine[7] or 0
        FlagPoint.y = selectedLine[8] or 0
        camera.isActive = selectedLine[5]
        Refoirment = selectedLine[5]
        bossTank.isAsleep = not selectedLine[5]
        bossTank.health = 1000
        camera.x = 0
        camera.y = 0
        IAatackPoints = {}
        -- todos los IAatackPoints 1, 2 & 3...
        local D = {x = selectedLine[10] or FlagPoint.x, -- 1
                   y = selectedLine[11] or FlagPoint.y}
        local B = {x = selectedLine[12] or FlagPoint.x, -- 2
                   y = selectedLine[13] or FlagPoint.y}
        local A = {x = selectedLine[14] or FlagPoint.x, -- 3
                   y = selectedLine[15] or FlagPoint.y}
            table.insert(IAatackPoints, D)
            table.insert(IAatackPoints, B)
            table.insert(IAatackPoints, A)
    end
    for _, weapon in ipairs(weapons) do                                                --Cambiè esto, pls pruebalo
    weapon.chargers = weapon.Maxchargers
    end
    for _, Guns in ipairs(gun) do
    Guns.chargers = Guns.Maxchargers
    end
    obstacles = levels[currentLevel].obstacles
    PositionWon = -500
    level = level + 1
    BBlu = -500
    Bpurp = -666
    bossTank.x = 306
    collectgarbage("collect")
end

weapons = {
    {
        name = "M4",
        damage = 22,
        fireRate = 0.054,
        ammo = 30,
        maxAmmo = 30,
        dispersion = 0.012,
        chargers = 3,
        Maxchargers = 3,
        pos = 1, -- Si es una primaria (1), secundaria (2) u objeto (3 o 4)
        texture = I_W["M4"],  -- Ajustado el nombre de la textura
        bala = I_W["Bala"],
        auto = true,
        timer = 100
        -- Otras propiedades según sea necesario
    },
    {
        name = "Pistola",
        damage = 56,
        fireRate = 0.5,  -- Disparos por segundo
        ammo = 16,
        maxAmmo = 16,
        dispersion = .1, -- Número en milímetros de la dispersión
        chargers = 5,
        Maxchargers = 5,
        pos = 2, -- Si es una primaria (1), secundaria (2) u objeto (3 o 4)
        texture = I_W["Pistola"],
        bala = I_W["Bala3"],
        auto = false,
        timer = 100
        -- Otras propiedades según sea necesario
    },
    {
        name = "ShGun",
        damage = 20,
        fireRate = 0.005,
        ammo = 20,
        maxAmmo = 20,
        dispersion = 0.5,
        chargers = 24,
        Maxchargers = 24,
        pos = 1, -- Si es una primaria (1), secundaria (2) u objeto (3 o 4)
        texture = I_W["M4"],  -- Ajustado el nombre de la textura
        bala = I_W["Bala3"],
        auto = true,
        type = "misile",
        timer = 100
        -- Otras propiedades según sea necesario
    },
    {
        name = "MediKit",
        damage = -20,
        fireRate = 5,
        ammo = 8,
        maxAmmo = 8,
        dispersion = 4,
        chargers = 1,
        Maxchargers = 1,
        pos = 3, -- Si es una primaria (1), secundaria (2) u objeto (3 o 4)
        texture = love.graphics.newImage("textures/armas/MediKit.png"),  -- Ajustado el nombre de la textura
        bala = love.graphics.newImage("textures/armas/MediKit.png"),
        auto = false,
        timer = 100
        -- Otras propiedades según sea necesario
    },
    {
        name = "nil",
        damage = 0,
        fireRate = 0,
        ammo = 0,
        maxAmmo = 0,
        dispersion = 0,
        chargers = 0,
        Maxchargers = 0,
        pos = 0,
        texture = love.graphics.newImage("textures/obstacle/node.png"),
        HUD = love.graphics.newImage("textures/obstacle/node.png"),
        bala = love.graphics.newImage("textures/obstacle/node.png"),
        auto = false,
        timer = 0
    }
}

WforP2 = {
    {
        name = "M4",
        damage = 22,
        fireRate = 0.054,
        ammo = 30,
        maxAmmo = 30,
        dispersion = 0.012,
        chargers = 3,
        Maxchargers = 3,
        pos = 1, -- Si es una primaria (1), secundaria (2) u objeto (3 o 4)
        texture = I_W["M4"],  -- Ajustado el nombre de la textura
        bala = I_W["Bala"],
        auto = true,
        timer = 100
        -- Otras propiedades según sea necesario
    },
    {
        name = "Pistola",
        damage = 56,
        fireRate = 0.5,  -- Disparos por segundo
        ammo = 16,
        maxAmmo = 16,
        dispersion = .1, -- Número en milímetros de la dispersión
        chargers = 5,
        Maxchargers = 5,
        pos = 2, -- Si es una primaria (1), secundaria (2) u objeto (3 o 4)
        texture = I_W["Pistola"],
        bala = I_W["Bala3"],
        auto = false,
        timer = 100
        -- Otras propiedades según sea necesario
    },
    {
        name = "ShGun",
        damage = 20,
        fireRate = 0.005,
        ammo = 20,
        maxAmmo = 20,
        dispersion = 0.5,
        chargers = 24,
        Maxchargers = 24,
        pos = 1, -- Si es una primaria (1), secundaria (2) u objeto (3 o 4)
        texture = I_W["M4"],  -- Ajustado el nombre de la textura
        bala = I_W["Bala3"],
        auto = true,
        type = "misile",
        timer = 100
        -- Otras propiedades según sea necesario
    },
    {
        name = "MediKit",
        damage = -20,
        fireRate = 5,
        ammo = 8,
        maxAmmo = 8,
        dispersion = 4,
        chargers = 1,
        Maxchargers = 1,
        pos = 3, -- Si es una primaria (1), secundaria (2) u objeto (3 o 4)
        texture = love.graphics.newImage("textures/armas/MediKit.png"),  -- Ajustado el nombre de la textura
        bala = love.graphics.newImage("textures/armas/MediKit.png"),
        auto = false,
        timer = 100
        -- Otras propiedades según sea necesario
    },
    {
        name = "nil",
        damage = 0,
        fireRate = 0,
        ammo = 0,
        maxAmmo = 0,
        dispersion = 0,
        chargers = 0,
        Maxchargers = 0,
        pos = 0,
        texture = love.graphics.newImage("textures/obstacle/node.png"),
        HUD = love.graphics.newImage("textures/obstacle/node.png"),
        bala = love.graphics.newImage("textures/obstacle/node.png"),
        auto = false,
        timer = 0
    }
}

-- Detectar cuando se suelta el clic del mouse
function love.mousereleased(x, y, button)
    if button == 1 then
        isDragging = false  -- Detenemos el arrastre
    end
end

function love.mousepressed(x, y, button)
    if button == 1 and menuActive then  -- Verifica si el botón izquierdo del mouse fue presionado

         -- Detectar si se ha hecho clic en el slot 1 o 2
         if x > 100 and x < 290 and y > 100 and y < 150 then
            selectedSlot = 1
            print("1")
        elseif x > 100 and x < 290 and y > 160 and y < 210 then
            selectedSlot = 2
            print("2")
        elseif x > 100 and y > 280 and x < 100 + 190 and y < 280 + 50 then
            selectedSlot = 3
            print("3")
        elseif x > 100 and y > 340 and x < 290 and y < 340 + 50 then
            selectedSlot = 4
            print("4")
        elseif x > 410 and x < 440  and y > 412.5 and y < 435 then
            if page < math.ceil(#gun / itemsPerPage) then
                page = page + 1
            end
        elseif x > 295 and x < 325  and y > 410 and y < 435 and page > 1 then
                page = page - 1
        elseif x >= 900 and x <= 945 and y >= 409 and y <= 454 then
            aiShootCooldown = aiShootCooldown +.1
        elseif x >= 805 and x <= 850 and y >= 409 and y <= 454 then
            aiShootCooldown = aiShootCooldown -.1
        elseif x >= 900 and x <= 945 and y >= 454 and y <= 499 then
            aiBulletsPerBurst = aiBulletsPerBurst +1
        elseif x >= 805 and x <= 850 and y >= 454 and y <= 499 then
            aiBulletsPerBurst = aiBulletsPerBurst -1
        elseif x >= 900 and x <= 945 and y >= 255 and y <= 300 then
            weapons[1].fireRate = weapons[1].fireRate +.045
        elseif x >= 805 and x <= 850 and y >= 278 and y <= 323 then
            weapons[1].fireRate = weapons[1].fireRate -.045
        end

        local startIndex = (page - 1) * itemsPerPage + 1
        local endIndex = math.min(startIndex + itemsPerPage - 1, #gun)
        for i = startIndex, endIndex do
            local weapon = gun[i]
            local posY = 100 + (i - startIndex) * 60  -- Y posición de cada arma visible

            -- Detecta si el clic está dentro del área de un arma
            if x >= 300 - 8 and x <= 300 - 8 + 146 and y >= posY and y <= posY + 60 and selectedSlot ~= nil then
                -- Por ejemplo, reemplazar un slot de arma
                if selectedSlot < 3 then
                weapons[selectedSlot] = weapon  -- Reemplaza el arma en el slot seleccionado
                else
                WforP2[selectedSlot - 2] = deepCopy(weapon)
                print("otra arma : " .. selectedSlot)
                end
            end
        end

-------------------------------------------------------------------------------------------------------------------------------------<3
        
        local startIndex = (page - 1) * itemsPerPage + 1
        local endIndex = math.min(startIndex + itemsPerPage - 1, #levels)
        for i = startIndex, endIndex do
            local posY = 100 + (i - startIndex) * 60  -- Y posición de cada arma visible

            if x >= 480 - 8 and x <= 480 - 8 + 146 and y >= posY and y <= posY + 60 then
                NewGame(i)
                updateVisibleChunks()
                menuActive = not menuActive
            end
        end
    end

    if x >= 751 and y >= 637 and x <= 975 and y <= 720 and AsWon and button == 1 then
        player1Points = 0
        player2Points = 0
        AsWon = false
        menuActive = true
    elseif x >= 751 and y >= 637 and x <= 975 and y <= 720 and button == 1 and menuActive then
        menuActive = false
        vehicle.inHand = WforP2[1]
    end

    -- Si ambos están seleccionados, realiza el reemplazo
    if selectedSlot and selectedWeapon then
        if selectedSlot < 3 then
        weapons[selectedSlot] = selectedWeapon
        player.inHand = weapons[selectedSlot]
        selectedWeapon = nil
        else
        WforP2[selectedSlot - 2] = selectedWeapon
        vehicle.inHand = WforP2[selectedSlot]
        selectedWeapon = nil
        print("otra arma : " .. selectedSlot)
        end
    end

    
    if button == 1 and not menuActive and not AsWon and not player.inHand.auto and not player.death then
        shoot()
    end
end

function love.keypressed(key)
    if key == "escape" then
        menuActive = not menuActive  -- Cambia el estado del menú
        if menuActive then
            vehicle.inHand = WforP2[1]
        end
    end
    if key == "kp7" then
        local nearestVehicle = findNearestVehicle(vehicle.x, vehicle.y, 100) -- rango de 100 píxeles
        if nearestVehicle then
            mountVehicle(vehicle, nearestVehicle)
        end
    end
    if key == "t" then
        timers = {}
    end
    if key == "f3" then
        debug = not debug
    end
    if key == "u" then
        camera.isActive = not camera.isActive
        if not camera.isActive then
            camera.x = 0
            camera.y = 0
        end
    end
    if key == "f" then
        player1Points = 9
    end
    if key == "i" then  -- Cambia a la tecla que prefieras
        toggleAI()
    end
    if key == "kp5" then  -- Cambia a la tecla que prefieras
        Refoirment = not Refoirment
    end
            if key == "p" then
              love.window.setMode(1366, 768)
              player1Canvas = love.graphics.newCanvas(love.graphics.getWidth() / 2, love.graphics.getHeight())
              player2Canvas = love.graphics.newCanvas(love.graphics.getWidth() / 2, love.graphics.getHeight())
            end
    if menuActive then
        if key == "right" then
            if page < math.ceil(#gun / itemsPerPage) then
                page = page + 1
            end
        elseif key == "left" then
            if page > 1 then
                page = page - 1
            end
        end
    end
end

local CC = 0
local shooterCannon = 60
local DirecctionBG = -100
function wait(seconds, callback)
    table.insert(timers, {time = seconds, callback = callback})
end

local iaSpawnTimer = 0
function spawnIACopiesAutomatically(dt)
    iaSpawnTimer = iaSpawnTimer - dt
    if iaSpawnTimer <= 0 then
        spawnIACopy(selectedLine[1], selectedLine[2], 1)
        spawnIACopy(selectedLine[3], selectedLine[4], 2)
        iaSpawnTimer = 3  -- Ajusta el intervalo de spawn (3 segundos en este caso... si quieres cambialo)
    end
end

-- Función de actualización
function love.update(dt)
    collectgarbage("collect")
    -- Iterar sobre la lista de temporizadores
    for i = #timers, 1, -1 do  -- Si, esto es como lo del roblox
        local timer = timers[i]  -- Me pregunto si alguien leerà esto
        -- Reducir el tiempo del temporizador
        timer.time = timer.time - dt  -- Al menos por què alguien deberìa leer esto
        -- Si el temporizador ha llegado a 0 o menos, ejecuta la función
        if timer.time <= 0 then  -- estas hackeando?
            timer.callback()
            -- Eliminar el temporizador de la lista
            table.remove(timers, i)
        end
    end
    local i = 1
    while i <= #objects do
        local obj = objects[i]

        if obj.collisionable then
            local playerCollides = checkCollisionRect(player.x, player.y, player.width, player.height, obj.x, obj.y, obj.width, obj.height)
            local vehicleCollides = checkCollisionRect(vehicle.x, vehicle.y, vehicle.width, vehicle.height, obj.x, obj.y, obj.width, obj.height)

            -- Si el jugador toca el objeto y aún no ha sido tocado
            if obj.isActive and playerCollides and not obj.isTouched then
                obj.onTouch(obj, player)
                obj.isTouched = true
            elseif vehicleCollides then
                obj.onTouch(obj, vehicle)
                obj.isTouched = true
            else
                obj.isTouched = false
            end
        end

        if not obj.isActive then
            table.remove(objects, i)
            break
        else
            i = i + 1
        end
    end

    updateVehicles(dt)
    AsRounding(dt)
    
    -- Si el jugador no está en un vehículo
    if not player.inVehicle then
        -- Buscar el vehículo más cercano al presionar "E"
        if love.keyboard.isDown("e") then
            local nearestVehicle = findNearestVehicle(player.x, player.y, 100) -- rango de 100 píxeles
            if nearestVehicle then
                mountVehicle(player, nearestVehicle)
            end
        end
    else
        -- Mantener al jugador en el asiento mientras el vehículo se mueve
        local seatX, seatY = rotateAroundCenter(player.vehicle.x + player.vehicle.width / 2, player.vehicle.y + player.vehicle.height / 2, 13.75, 0, player.vehicle.rotate)
        if player.vehicle.rotate >= 6.3 then
            player.vehicle.rotate = player.vehicle.rotate - 6.3
        end
        player.x = seatX
        player.y = seatY

        -- Control del vehículo
        handleVehicleControl(player.vehicle, dt)

        -- Desmontar el vehículo
        if love.keyboard.isDown("q") then
            dismountVehicle(player)
        end
    end

    -- Actualiza la nube de gas
    for _, obj in ipairs(objects) do
        if obj.isActive and obj.update then
            obj:update(dt, CC)
        end
        obj.caller(obj)
    end

    if vehicle.health < 200 then
    vehicle.health = vehicle.health + 0.125
    end

    -- Actualizar el movimiento y disparos del tanque jefe
    if not bossTank.isAsleep and not AsWon and not menuActive then
        updateBossTank(dt)
        -- El cannon del tanque...
        -- Actualizar la rotación del cañón hacia el jugador
    updateCannonRotation(dt, player.x, player.y)
    updateMissiles(dt)
    updateplayerMissiles(dt)

    -- Verifica si el cañón debe disparar (por ejemplo, cada cierto tiempo o bajo ciertas condiciones)
    if shooterCannon <= 0 then
        shootCannonBullet(2, 0.008)
        wait(0.1, function() shootCannonBullet(3, 0.006) end)
        wait(0.2, function() shootCannonBullet(2, 0.005) end)
        shooterCannon = 120
    end
    if CC == 250 or CC == 300 or CC == 500 then
        shootMissiles()
    end
    if shooterCannon > 0 then
        shooterCannon = shooterCannon - 1
    end
    if checkCollisionRect(player.x, player.y, player.height, player.width, bossTank.x, bossTank.y, bossTank.width, bossTank.height) and not menuActive and not AsWon and not player.death then
        player.health = player.health - 200
    end
    for _, bullet in ipairs(vehicleBullets) do
        for i, vehicle in ipairs(vehicles) do
            if checkCollisionRect(bullet.x, bullet.y, 5, 5, vehicle.x, vehicle.y, vehicle.height, vehicle.height) then
                table.remove(vehicleBullets, i)
                vehicle.health = vehicle.health - 2
                break
            elseif vehicle.health <= 0 then
                player.inVehicle = false
                player.inHand = weapons[1]
                table.remove(vehicles, i)
                break
            end
        end
    end

    -- Actualizar las balas del cañón
        for _, bullet in ipairs(cannonBullets) do
            bullet.x = bullet.x + bullet.dx * dt
            bullet.y = bullet.y + bullet.dy * dt
            break
        end
    end
    
    
    
    CC = math.floor(CC + 60 * dt)
    for i = #objects, 1, -1 do
        local obj = objects[i]
        obj.lifeTime = obj.lifeTime - dt

        if obj.lifeTime <= 0 then
            obj.isActive = false
        end
    end

        if (CC == 150 or CC == 300 or CC == 500) and not menuActive and not AsWon then
            createObject(
            math.random(1, 940), 
            math.random(1, 690), 
            100, 
            100, 
            function(obj, Toucher)
                if not Toucher.death then
                    Toucher.health = Toucher.health - 6
                    wait(4.6, function() obj.isActive = false end)
                end
            end, 
            Bigsmokes, 
            10,
            function(_)end)
            
            createObject(
            math.random(1, 940), 
            math.random(1, 690), 
            15, 
            15, 
            function(obj, Toucher)
                Toucher.health = 200
                obj.isActive = false
            end, 
            HealthIM, 
            10,
            function(_)end)

            createObject(
            math.random(1, 940), 
            math.random(1, 690), 
            15, 
            15, 
            function(obj, Toucher)
                Toucher.inHand = deepCopy(gun[math.random(1, 10)])
                obj.isActive = false
            end, 
            GunsIM, 
            10,
            function(_)end)
        end

        if CC == 600 then CC = 0 end


    -- Lógica para cambiar de nivel
    if vehicle.health <= 0 and not vehicle.death then
        vehicle.death = true
        vehicle.health = 200
        local V = vehicle
        createObject(V.x, V.y, V.width, V.height, function()end, V.deadIm, 100, function()end, false)
        player.inHand = weapons[1]
        player2Points = player2Points + 1
        if not selectedLine[5] then
            NewGame()
            V.death = false
        end
    elseif player.health <= 0 and not player.death then
        player.death = true
        player.health = 200
        createObject(player.x, player.y, player.width, player.height, function()end, player.deadIm, 100, function()end, false)
        player.inHand = weapons[1]
        player1Points = player1Points + 1
        if not selectedLine[5] then
            NewGame()
            player.death = false
        end
    end

        -- Actualizar IA original y copias
        if Refoirment and not menuActive and not AsWon then
        updateIACopies(dt, player)
        spawnIACopiesAutomatically(dt)
        end
    if aiEnabled and not menuActive and not AsWon then
            -- Actualizar el temporizador
        aiLastShotTime = aiLastShotTime + dt
        updateAI(dt)

        -- Si ha pasado suficiente tiempo, disparar
        if aiLastShotTime >= aiShootCooldown then
            shootAIBullet()  -- Disparar
            aiLastShotTime = 0  -- Reiniciar el temporizador
        end

        if vehicle.currentPath then
            if pathIndex > #vehicle.currentPath then
                -- Esto controla en movimiento de la IA Normal, que solo caza al jugador.
                local start = {x = vehicle.x, y = vehicle.y}
                local goal = {x = player.x, y = player.y}
                vehicle.currentPath = astar(start, goal, obstacles)
                print("Nueva ruta")
                pathIndex = 1  -- Reinicia el índice del camino
            end
        else
            print("Error : Recalculando ruta")
            local start = {x = vehicle.x, y = vehicle.y}
            local goal = {x = player.x, y = player.y}
            vehicle.currentPath = astar(start, goal, obstacles)
        end
        

        if vehicle.currentPath and #vehicle.currentPath > 0 and pathIndex <= #vehicle.currentPath then
            local nextStep = vehicle.currentPath[pathIndex]
            local targetX, targetY = toPixel(nextStep.x, nextStep.y)  -- Convertir a píxeles
        
            local dx = targetX - vehicle.x
            local dy = targetY - vehicle.y
            local dist = math.sqrt(dx * dx + dy * dy)
        
            if dist > vehicle.speed / 80 then
                vehicle.x = vehicle.x + (dx / dist) * vehicle.speed * dt
                vehicle.y = vehicle.y + (dy / dist) * vehicle.speed * dt
            else
                vehicle.x = targetX
                vehicle.y = targetY
                pathIndex = pathIndex + 1
            end
        end
    end

    vehicleTimeSinceLastShot = vehicleTimeSinceLastShot + dt
    startVehicleDash(dt)
    -- Disparo del vehículo
    if (love.keyboard.isDown("kp0") or aiEnabled) and vehicleTimeSinceLastShot >= vehicle.inHand.fireRate and vehicle.inHand.ammo > 0 and not menuActive and not AsWon and not vehicle.death then
        if vehicle.inHand.fireRate ~= 0 then
            shootAIBullet()
            vehicle.inHand.ammo = vehicle.inHand.ammo - 1
            vehicleTimeSinceLastShot = 0
        else
            for _ = 1, vehicle.inHand.ammo do
                shootAIBullet()
            end
            vehicle.inHand.ammo = 0
        end
    -- Dash del jugador 2
        if vehicleDashTimeLeft >= 0 then
            vehicleIsDashing = false
            vehicleDashTimeLeft = math.max(vehicleDashTimeLeft - dt, 0)
        end
    elseif love.keyboard.isDown("kp.") then
        vehicleIsDashing = true
    end
    -- Recarga del vehículo
    if vehicle.inHand.ammo <= 0 then
        vehicle.reloadT = vehicle.reloadT + dt
        if vehicle.reloadT >= 1 then
            vehicle.inHand.ammo = vehicle.inHand.maxAmmo
            vehicle.reloadT = 0
        end
    end

    updateVehicleBullets(dt)

    -- Lógica para recargar
    if love.keyboard.isDown("r") then
        if player.inHand and player.inHand.chargers and player.inHand.chargers > 0 and player.inHand.ammo < player.inHand.maxAmmo then
            if love.timer.getTime() - timeSinceLastReload > minTimeBetweenReloads then
                -- Resta un cargador y recarga la cantidad de balas
                player.inHand.chargers = player.inHand.chargers - 1
                player.inHand.ammo = player.inHand.maxAmmo
                timeSinceLastReload = love.timer.getTime()
                player.timeshoot = player.inHand.fireRate
            end
        end
    end
        -- Movimiento del jugador
        local newX, newY = player.x, player.y
        -- Otra movida xd
    if H == true then
        for x = 1, math.ceil(love.graphics.getWidth() / tileSize) do
            backgroundMatrix[x] = {}
            for y = 1, math.ceil(love.graphics.getHeight() / tileSize) do
                backgroundMatrix[x][y] = love.math.random(#backgroundTextures)
            end
            player.inHand.ammo = player.inHand.maxAmmo
            player.inHand = gun[1]
            H = false
        end
    end

    if not AsWon and not menuActive then
        -- Calcular la posición anterior del vehículo solo si el jugador está en un vehículo
        local oldX, oldY = vehicle.x, vehicle.y
        -- Manejar el movimiento del vehículo basado en las teclas presionadas
        if love.keyboard.isDown("left") then
            oldX = vehicle.x - vehicle.speed * dt
            vehicle.Direction = "Izq"
            vehicleLastDirection = {x = -1, y = 0}
        elseif love.keyboard.isDown("right") then
            oldX = vehicle.x + vehicle.speed * dt
            vehicle.Direction = "Der"
            vehicleLastDirection = {x = 1, y = 0}
        end
        if love.keyboard.isDown("up") then
            oldY = vehicle.y - vehicle.speed * dt
            vehicle.Direction = "Up"
            vehicleLastDirection = {x = 0, y = -1}
        elseif love.keyboard.isDown("down") then
            oldY = vehicle.y + vehicle.speed * dt
            vehicle.Direction = "Dwn"
            vehicleLastDirection = {x = 0, y = 1}
        end
        
        -- Evitar que el vehículo se salga de la pantalla o colisione con obstáculos
        -- Si hay una colisión, restaurar la posición anterior del vehículo
        if not checkCollision(oldX, oldY, vehicle.width, vehicle.height) then
            vehicle.x, vehicle.y = oldX, oldY
        end
    end

    -- Seleccionar armas (Asalto)
        if love.keyboard.isDown("1") and player.Job == 1 then
        player.inHand = weapons[1]
        elseif love.keyboard.isDown("2") and player.Job == 1 then
        player.inHand = weapons[2]
        elseif love.keyboard.isDown("3") and player.Job == 1 then
        player.inHand = weapons[3]
        elseif love.keyboard.isDown("4") and player.Job == 1 then
        player.inHand = weapons[4]
        end
        if love.keyboard.isDown("kp1") then
        vehicle.inHand = WforP2[1]
        elseif love.keyboard.isDown("kp2") then
        vehicle.inHand = WforP2[2]
        elseif love.keyboard.isDown("kp3") then
        vehicle.inHand = WforP2[3]
        elseif love.keyboard.isDown("kp4") then
        vehicle.inHand = WforP2[4]
        end
        if not player.inVehicle then
            if not camera.isActive and not AsWon and not menuActive then
                if love.keyboard.isDown("w") and player.y >= 0 then
                    newY = player.y - player.speed * dt
                    player.currentAnimation = "walk"
                    updateVisibleChunks()
                elseif love.keyboard.isDown("s") and player.y <= 725 then
                    newY = player.y + player.speed * dt
                    player.currentAnimation = "walk"
                    updateVisibleChunks()
                else
                    player.currentAnimation = "idle"
                end
            elseif camera.isActive and not AsWon and not menuActive then
                if love.keyboard.isDown("w") then
                    newY = player.y - player.speed * dt
                    player.currentAnimation = "walk"
                    updateVisibleChunks()
                elseif love.keyboard.isDown("s") then
                    newY = player.y + player.speed * dt
                    player.currentAnimation = "walk"
                    updateVisibleChunks()
                else
                    player.currentAnimation = "idle"
                end
            end
    
            if not camera.isActive and not AsWon and not menuActive then
                if love.keyboard.isDown("a") and player.x >= 0 then
                    newX = player.x - player.speed * dt
                    player.currentAnimation = "walk"
                    updateVisibleChunks()
                elseif love.keyboard.isDown("d") and player.x <= 975 then
                    newX = player.x + player.speed * dt
                    player.currentAnimation = "walk"
                    updateVisibleChunks()
                else
                    player.currentAnimation = "idle"
                end
            elseif camera.isActive and not AsWon and not menuActive then
                if love.keyboard.isDown("a") then
                    newX = player.x - player.speed * dt
                    player.currentAnimation = "walk"
                    updateVisibleChunks()
                elseif love.keyboard.isDown("d") then
                    newX = player.x + player.speed * dt
                    player.currentAnimation = "walk"
                    updateVisibleChunks()
                else
                    player.currentAnimation = "idle"
                end
            end
        end

    


        -- Actualizar la posición del jugador solo si no hay colisión
    if not checkCollision(newX, newY, player.width, player.height) then
        player.x, player.y = newX, newY
    end
    -- Actualizar la animación del jugador
    local animationFrames = player.animations[player.currentAnimation]
    if #animationFrames > 1 then
        player.currentFrame = player.currentFrame + player.animationSpeed * dt
        if player.currentFrame > #animationFrames + 1 then
            player.currentFrame = 1
        end
    end
    -- Obtener el tamaño del frame actual y ajustar el hitbox
    local currentFrame = animationFrames[math.floor(player.currentFrame)]
    local frameWidth = player.frames[currentFrame]:getWidth()
    local frameHeight = player.frames[currentFrame]:getHeight()

    player.width = frameWidth
    player.height = frameHeight
    
    -- Calcular el nuevo origen basado en el centro del frame actual
    player.originX = (frameWidth / 2)
    player.originY = (frameHeight / 2) - 1

    if not camera.isActive then
   -- Actualizar el ángulo para que el personaje mire al ratón
   local mouseX, mouseY = love.mouse.getPosition()
   player.angle = math.atan2(mouseY - (player.y + (player.height / 2)), mouseX - (player.x + (player.width / 2)))
    else
    -- Obtener la posición del ratón en relación al mundo
    local mouseX, mouseY = love.mouse.getPosition()
    local worldMouseX = mouseX
    local worldMouseY = mouseY
    local worldPlayerX = (love.graphics.getWidth() / 4) + (player.width / 2)
    local worldPlayerY = (love.graphics.getHeight() / 2) + (player.height / 2)
    player.angle = math.atan2(worldMouseY - worldPlayerY, worldMouseX - worldPlayerX)
    end

   if player.isShooting then
       player.timeSinceLastShot = player.timeSinceLastShot + dt

       -- Lógica para disparar, por ejemplo, comprobar si ha pasado el tiempo suficiente
       if player.timeSinceLastShot >= 1 / player.inHand.fireRate and not player.death then
           shoot()  -- Implementa la función shoot Henry -> quien es Henry? -> xd no se
           player.timeSinceLastShot = 0
       end
   end
        for _, vehiclet in ipairs(vehicles) do
            if checkCollisionRect(vehiclet.x, vehiclet.y, vehiclet.height, vehiclet.height, vehicle.x, vehicle.y, vehicle.width, vehicle.height) and vehiclet.currentSpeed >= 100 then
                NewGame()
                player.inHand = weapons[1]
                player2Points = player2Points + 1
            end
            break
        end  -- No es necesario verificar colisiones con otros obstáculos
   
   for e = #bullets, 1, -1 do
    local bullet = bullets[e]
       if bullet.isActive then
           bullet.x = bullet.x + bullet.speed * dt * math.cos(bullet.angle)
           bullet.y = bullet.y + bullet.speed * dt * math.sin(bullet.angle)

           -- Verificar colisiones con obstáculos
           for _, obstacle in ipairs(obstacles) do
               if not obstacle.traversable and obstacle.lar == 1 and checkBulletObstacleCollision(bullet, obstacle) then
                   bullet.isActive = false  -- Desactivar la bala si hay colisión con un obstáculo
                   bullet.OnDestroyBullet(bullet.x, bullet.y, player)
                   table.remove(bullets, e)
                    break  -- No es necesario verificar colisiones con otros obstáculos
                elseif checkBulletVehicleCollision(bullet, vehicle) and not menuActive and not AsWon and not vehicle.death then
                      vehicle.health = vehicle.health - math.random(player.inHand.damage- player.inHand.damage/ 8, player.inHand.damage+ 5)
                      bullet.OnDestroyBullet(bullet.x, bullet.y, player)
                      table.remove(bullets, e)
                    break
                end
           end
           -- Comprobar colisiones con cada IA
        for j = #IACopies, 1, -1 do
            local ia = IACopies[j]
            if checkCollisionRect(bullet.x - (bullet.radius / 2), bullet.y - (bullet.radius / 2), bullet.radius, bullet.radius, ia.x, ia.y, 37, 37) then
                ia.health = ia.health - player.inHand.damage
                table.remove(bullets, i)  -- Eliminar la bala
                if ia.health <= 0 then
                    table.remove(IACopies, j)  -- Eliminar la IA si su salud llega a 0
                end
                break
            end
        end

        -- Verificar colisión con el tanque jefe
        if checkCollisionWithBossTank(bullet) and not bossTank.isAsleep then
            table.remove(bullets, i)  -- Eliminar la bala después de la colisión
        end
   
            -- Desactivar la bala si sale de la pantalla
            if not camera.isActive then
                if bullet.x < -5 or bullet.y < -5 or bullet.x > 1000 or bullet.y > 750 then
                    bullet.isActive = false
                end
            end
       end
       bullet.timer = bullet.timer - dt
       bullet.timero = bullet.timero + dt
       if bullet.timer <= 0 then
        table.remove(bullets, e)
            bullet.OnDestroyBullet(bullet.x, bullet.y, player)
       end
   end
    for _, vehiclet in ipairs(vehicles) do
     if checkCollisionRect(vehiclet.x, vehiclet.y, vehiclet.height, vehiclet.height, vehicle.x, vehicle.y, vehicle.width, vehicle.height) and vehiclet.currentSpeed >= 100 then
         vehicle.health = 0
         NewGame(currentLevel)
         player.inHand = weapons[1]
     end
    end
   -- Restringir la tasa de disparo
   if player.timeshoot > 0 then
       player.timeshoot = player.timeshoot - dt
   end
   -- Lógica para el disparo ---------------------------------------------------------------------------\\\\
   -----------------------------------------------------------------------------------------------------\\\\
    if love.mouse.isDown(1) 
    and player.timeshoot <= 0 
    and not menuActive 
    and not AsWon 
    and player.inHand.auto 
    then
        -- Si el jugador no está muerto
        if not player.death then
            -- Si el arma tiene una cadencia de disparo (fireRate) mayor a 0
            if player.inHand.fireRate > 0 then
                shoot() -- Dispara una bala
                player.timeshoot = player.inHand.fireRate -- Reinicia el tiempo de espera entre disparos
            else
                -- Si el arma no tiene fireRate, dispara todas las balas disponibles
                for i = 1, player.inHand.ammo do
                    shoot()
                    player.inHand.ammo = player.inHand.ammo - 1
                end
            end
        end
    end
   -----------------------------------------------------------------------------------------------------\\\\
   -----------------------------------------------------------------------------------------------------\\\\

   if player.inHand.dispersion then randomVariable = (math.random() * 2 - 1) * player.inHand.dispersion end
    PositionWon = PositionWon + 12
    BBlu = BBlu + 14.5
    Bpurp = Bpurp + 16
    collectgarbage("collect")
end
function AsRounding(dt)
    if player1Points >= 10 or player2Points >= 10 then
            AsWon = true
            aiEnabled = false
        else
            AsWon = false
    end
    if BackGroundEnding.x <= love.graphics.getWidth() then
        BackGroundEnding.x = love.graphics.getWidth()
        BackGroundEnding.y = love.graphics.getWidth()
        DirecctionBG = 100
    elseif BackGroundEnding.x >= 2856 then
        BackGroundEnding.x = 2856
        BackGroundEnding.y = 2856
        DirecctionBG = -100
    end
    if WonScale > 1 then
        WonScale = WonScale - 25 * dt
    else
        WonScale = 1
    end
    BackGroundEnding.x = BackGroundEnding.x + DirecctionBG * dt
    BackGroundEnding.y = BackGroundEnding.y + DirecctionBG * dt
end

function checkBulletObstacleCollision(bullet, obstacle)
    local bulletRadius = 1  -- Ajusta el radio según sea necesario
    local bulletX, bulletY = bullet.x, bullet.y
    local obstacleX, obstacleY = obstacle.x, obstacle.y
    local obstacleWidth, obstacleHeight = obstacle.width, obstacle.height

    -- Calcular la distancia entre el centro de la bala y el centro del obstáculo
    local centerDistanceX = math.abs((bulletX + bulletRadius) - (obstacleX + obstacleWidth / 2))
    local centerDistanceY = math.abs((bulletY + bulletRadius) - (obstacleY + obstacleHeight / 2))

    -- Calcular el radio de colisión combinado
    local combinedRadiusX = bulletRadius + obstacleWidth / 2
    local combinedRadiusY = bulletRadius + obstacleHeight / 2

    -- Verificar si hay colisión en ambas dimensiones
    local collisionX = centerDistanceX < combinedRadiusX
    local collisionY = centerDistanceY < combinedRadiusY

    return collisionX and collisionY
end

function checkBulletVehicleCollision(bullet, vehicle)
    local bulletRadius = bullet.radius  -- Ajusta el radio según sea necesario
    local bulletX, bulletY = bullet.x, bullet.y
    local vehicleX, vehicleY = vehicle.x, vehicle.y
    local vehicleWidth, vehicleHeight = vehicle.width, vehicle.height

    -- Calcular la distancia entre el centro de la bala y el centro del obstáculo
    local centerDistanceX = math.abs((bulletX + bulletRadius) - (vehicleX + vehicleWidth / 2))
    local centerDistanceY = math.abs((bulletY + bulletRadius) - (vehicleY + vehicleHeight / 2))

    -- Calcular el radio de colisión combinado
    local combinedRadiusX = bulletRadius + vehicleWidth / 2
    local combinedRadiusY = bulletRadius + vehicleHeight / 2

    -- Verificar si hay colisión en ambas dimensiones
    local collisionX = centerDistanceX < combinedRadiusX
    local collisionY = centerDistanceY < combinedRadiusY

    return collisionX and collisionY
end

function shoot()
    if player.inHand.ammo > 0 and player.timeshoot <= 0 then
        -- Reduzca la munición
        player.inHand.ammo = player.inHand.ammo - 1
        -- Puedes crear una instancia de bala y manejar su movimiento
        if player.inHand.BulletDx and player.inHand.BulletDy then
            createBullet((player.x + 12.5) + player.inHand.BulletDx,
                         (player.y + 12.5) + player.inHand.BulletDy,
            player.angle, player.inHand.type, player.inHand.timer,
            player.inHand.ActivationTimer, player.inHand.radius, player.inHand.OnDestroyBullet)
        else
            createBullet(player.x + 12.5, player.y + 12.5,
            player.angle, player.inHand.type, player.inHand.timer,
            player.inHand.ActivationTimer, player.inHand.radius, player.inHand.OnDestroyBullet)
        end
    end
end

function createBullet(x, y, angle, type, time, Atimer, radius, OnDestroyBullet)
    local randomVariable = (math.random() * 2 - 1) * player.inHand.dispersion
    local newBullet = table.copy(Bullet)  -- Asegúrate de tener una función table.copy para duplicar la entidad
    newBullet.x = x
    newBullet.y = y
    newBullet.speed = player.inHand.bulletSpeed or 500
    newBullet.angle = angle + randomVariable
    newBullet.isActive = true
    newBullet.texture = player.inHand.bala  -- Asignar la textura de la bala desde la arma actual
    newBullet.type = type or nil
    newBullet.timer = time
    newBullet.timero = 0
    newBullet.ActivationTimer = Atimer or 0
    newBullet.radius = radius or 5
    newBullet.OnDestroyBullet = OnDestroyBullet or function()end

    table.insert(bullets, newBullet)
end
function table.copy(orig)
    local copy = {}
    for key, value in pairs(orig) do
        if type(value) == "table" then
            copy[key] = table.copy(value)  -- Recursivamente copiar tablas internas
        else
            copy[key] = value
        end
    end
    return copy
end

local function drawGunsP1()
local currentGun = player.inHand
    if currentGun.texture then
        if player.inHand.Ox and player.inHand.Oy then
            love.graphics.draw(currentGun.texture,
            (player.x) + ((currentGun.texture:getHeight() /2) * player.inHand.Os) + player.inHand.Odx,
            (player.y) + ((currentGun.texture:getHeight() /2) * player.inHand.Os) + player.inHand.Ody,
            player.angle, player.inHand.Os, player.inHand.Os, player.originX + player.inHand.Ox, player.originY + player.inHand.Oy)
        else
            love.graphics.draw(currentGun.texture,
            (player.x) + currentGun.texture:getHeight() /2,
            (player.y) + currentGun.texture:getHeight() /2,
            player.angle, 1, 1, player.originX, player.originY)
        end
    end
end

function Menu()
    if menuActive then
        love.graphics.draw(DoGround)

        love.graphics.setColor(0.206, 0.206, 0.134)
        love.graphics.rectangle("fill", 290, 100, 150, 300)
        love.graphics.rectangle("fill", 290, 405, 150, 30)
        love.graphics.rectangle("fill", 800, 405, 150, 30)
        love.graphics.rectangle("fill", 800, 450, 150, 30)
        love.graphics.setColor(0.412, 0.412, 0.268)     
        love.graphics.rectangle("line", 290, 100, 150, 300) 
        love.graphics.rectangle("line", 290, 405, 150, 30)
        love.graphics.rectangle("line", 800, 405, 150, 30)
        love.graphics.rectangle("line", 800, 450, 150, 30)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Selecciona el slot a reemplazar:", 100, 70)
        love.graphics.draw(Direcction, 945, 431, 0, -0.045)
        love.graphics.draw(Direcction, 805, 409, 0, 0.045)
        love.graphics.draw(Direcction, 945, 476, 0, -0.045)
        love.graphics.draw(Direcction, 805, 454, 0, 0.045)
        love.graphics.draw(Direcction, 945, 300, 0, -0.045)
        love.graphics.draw(Direcction, 805, 278, 0, 0.045)
        love.graphics.print(aiShootCooldown, 860, 415)
        love.graphics.print(aiBulletsPerBurst, 860, 460)
        love.graphics.print(weapons[1].fireRate, 860, 278)

        -- Dibujar los slots de las armas actuales
        love.graphics.rectangle("line", 100, 100, 190, 50)
        love.graphics.setColor(0.206, 0.206, 0.134)
        love.graphics.rectangle("fill", 100, 100, 190, 50)
        love.graphics.rectangle("fill", 100, 280, 190, 50)
        love.graphics.rectangle("fill", 100, 340, 190, 50)
        love.graphics.rectangle("fill", 470, 100, 150, 300)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Slot 1: " .. tostring(weapons[1].name), 110, 120)
        love.graphics.print("Slot 1: " .. tostring(WforP2[1].name), 110, 300)
        love.graphics.rectangle("line", 100, 160, 190, 50)
        love.graphics.rectangle("line", 100, 280, 190, 50)
        love.graphics.rectangle("line", 100, 340, 190, 50)
        love.graphics.setColor(0.206, 0.206, 0.134)
        love.graphics.rectangle("fill", 100, 160, 190, 50)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Slot 2: " .. tostring(weapons[2].name), 110, 180)
        love.graphics.print("Slot 1: " .. tostring(WforP2[2].name), 110, 360)

        love.graphics.print("Selecciona el arma:", 300, 70)
        love.graphics.draw(Direcction, 435, 431, 0, -0.045)
        love.graphics.draw(Direcction, 295, 410, 0, 0.045)
        
        -- Dibujar la lista de armas disponibles en la página actual
        local startIndex = (page - 1) * itemsPerPage + 1
        local endIndex = math.min(startIndex + itemsPerPage - 1, #gun)

        for i = startIndex, endIndex do
            local weapon = gun[i]
            local x = 300
            local y = 100 + (i - startIndex) * 60  -- Espacio vertical entre las armas
            if weapon.HUD ~= nil then
            love.graphics.draw(weapon.HUD, x, y, 0, 0.15, 0.15)  -- Dibujar la textura
            love.graphics.rectangle("line", x - 8, y, 146, 60)
            end
        end

            local endIndex = math.min(startIndex + itemsPerPage - 1, #levels)

        for i = startIndex, endIndex do
            local x = 480
            local y = 100 + (i - startIndex) * 60  -- Espacio vertical entre las armas
                local digitWidth = numbers[0].width
            
                -- Convertir el número a una cadena para procesar cada dígito
                local pointsStr = tostring(i)
            
                for e = 1, #pointsStr do
                    local digit = tonumber(pointsStr:sub(e, e))
                    local selectedLine = firstLines[i + 1]
                    local img = numbers[digit].image
                    local scaleX = numbers[digit].width / img:getWidth()
                    local scaleY = numbers[digit].height / img:getHeight()
                    love.graphics.draw(img, x + (e - 1) * digitWidth, y, 0, scaleX, scaleY)
                    love.graphics.rectangle("line", x - 8, y, 146, 60)
                    love.graphics.draw(selectedLine[6], x + (e - 1) + 90, y + 7.5, 0, .35)
                    love.graphics.rectangle("line", x + (e - 1) + 90, y + 7.5, 45, 45)
                end
        end

        -- Mostrar indicación de páginas
        love.graphics.print("Página " .. page .. " de " .. math.ceil(#gun / itemsPerPage), 325, 412.5)
        love.graphics.draw(NEXTImage)
    end
end

FF = 1

local function drawScene()
    -- Dibujar el fondo
    love.graphics.setColor(255, 255, 255)  -- Restablecer el color blanco para el fondo
    drawBackground() -- Dibujar el fondo dinámico
    -- Obtener las coordenadas del ratón
    mouseX, mouseY = love.mouse.getPosition()
    
    -- Dibujar obstáculos
    for _, obstacle in ipairs(obstacles) do
    local obsX = obstacle.x
    local obsY = obstacle.y
        if obstacle.layer == "below" then
            love.graphics.draw(obstacle.image, obsX, obsY, 0, obstacle.width / obstacle.image:getWidth(), obstacle.height / obstacle.image:getHeight())
        end
    end
    love.graphics.setColor(255, 255, 255)  -- Color blanco para el jugador
    drawVehicles() -- Dibuja todos los vehículos
    drawGunsP1()
    for _, bullet in ipairs(bullets) do
        if bullet.isActive and bullet.timero > bullet.ActivationTimer then
            love.graphics.draw(bullet.texture, bullet.x, bullet.y, bullet.angle, 1, 1, bullet.texture:getWidth() / 2, bullet.texture:getHeight() / 2)
        end
    end  -- Estas son las balas :)
    -- Dibujar al jugador
    love.graphics.setColor(255, 255, 255)  -- Color blanco para el jugador
    local animationFrames = player.animations[player.currentAnimation]
    if not player.inVehicle then
        if player.death then love.graphics.setColor(.5, .75, 1, .5) end
        love.graphics.draw(player.frames[animationFrames[math.floor(player.currentFrame)]], (player.x) + (player.width / 2), (player.y) + (player.height / 2), player.angle, 1, 1, player.originX, player.originY)
        if player.death then love.graphics.setColor(1, 1, 1, 1) end
    end
    -- Dibujar balas del jugador 2
     for _, bullet in ipairs(vehicleBullets) do
        if bullet.TtoDraw then
            if bullet.TtoDraw <= 0 then
                love.graphics.draw(bullet.image, bullet.x, bullet.y, bullet.angle, 1, 1, bullet.image:getWidth() / 2, bullet.image:getHeight() / 2)
            end
        end
    end
    love.graphics.draw(FlagIm, FlagPoint.x, FlagPoint.y, 0, .076)
    
    
    drawVehicle()
    drawIACopies()
    
    
     -- Dibujar el tanque jefe
     if not bossTank.isAsleep then
        love.graphics.draw(bossTank.image, bossTank.x - 18, bossTank.y - 12, 0, 0.34)
        drawTankCannon()
    
        -- Dibujar las balas del cañón
        for _, bullet in ipairs(vehicleBullets) do
            if bullet.type == "tank" then
            love.graphics.draw(bossTank.bulletimage, bullet.x - 16, bullet.y - 16)
            end
        end
        drawMissiles()
    end
    
    Bigsmokes = Bsmoke[FF].image
    
        FF = FF +1
    if FF == 6 then
        FF = 1
    end
    
    -- Dibujar objetos
    for _, obj in ipairs(objects) do
        love.graphics.draw(obj.image, obj.x, obj.y, 0, obj.width / obj.image:getHeight(), obj.height / obj.image:getHeight())
        if obj.image == Bigsmokes then
            love.graphics.draw(Bigsmokes, obj.x, obj.y, 0, obj.width / obj.image:getHeight(), obj.height / obj.image:getHeight())
        end
    end
    
    -- Dibujar obstáculos por encima del jugador
    for _, obstacle in ipairs(obstacles) do
        if obstacle.layer == "above" then
            love.graphics.draw(obstacle.image, obstacle.x, obstacle.y, 0, obstacle.width / obstacle.image:getWidth(), obstacle.height / obstacle.image:getHeight())
        end
    end
    
    for _, circ in ipairs(IAatackPoints) do
        love.graphics.circle("fill", circ.x, circ.y, 12)
    end
    
end

-- Función de dibujo
function love.draw()
    -------------------------------------------------_______________----------------------------------------------------
    ------------------------------------------------_---------------_---------------------------------------------------
                                                 if selectedLine[5] then
    -------------------------------------------------_-------------_----------------------------------------------------
    --------------------------------------------------_____________-----------------------------------------------------
    -- Crear o actualizar los Canvas
    if not player1Canvas then
        player1Canvas = love.graphics.newCanvas(love.graphics.getWidth() / 2, love.graphics.getHeight())
        player2Canvas = love.graphics.newCanvas(love.graphics.getWidth() / 2, love.graphics.getHeight())
    end

    --- Dibujar vista del Jugador 1 ---
    love.graphics.setCanvas(player1Canvas)
    love.graphics.clear()
    camera:move((player.x + love.graphics.getWidth() / 3) + player.width, player.y)
    camera:set()  -- Aplicar la cámara del jugador 1
    drawScene()  -- Dibujar todo el mundo del juego
    camera:unset()

    --- Dibujar vista del Jugador 2 ---
    love.graphics.setCanvas(player2Canvas)
    love.graphics.clear()
    camera:move(vehicle.x + love.graphics.getWidth() / 3, vehicle.y)
    camera:set()  -- Aplicar la cámara del jugador 2
    drawScene()  -- Dibujar todo el mundo del juego
    camera:unset()

    -- Restaurar el canvas para dibujar en la pantalla
    love.graphics.setCanvas()
    love.graphics.clear()

    -- Dibujar ambas vistas en la pantalla
    love.graphics.draw(player1Canvas, 0, 0)
    love.graphics.draw(player2Canvas, love.graphics.getWidth() / 2, 0)
    -------------------------------------------------_______________----------------------------------------------------
    ------------------------------------------------_---------------_---------------------------------------------------
                                                           else
    -------------------------------------------------_-------------_----------------------------------------------------
    --------------------------------------------------_____________-----------------------------------------------------
    drawScene()
    end
if AsWon then
love.graphics.draw(BackGroundEndingImage, BackGroundEnding.x, BackGroundEnding.y, 0, -1)
love.graphics.draw(RecoilerinEndingImage)
love.graphics.draw(Pointer, mouseX, mouseY, 0, .035)
love.graphics.draw(Wan, 205, 80, 0, WonScale)
end

--love.graphics.line((player.x) + 12.75, (player.y) + 12.75, mouseX, mouseY)
--love.graphics.setLineWidth(0.000025)  -- Ancho de línea
--love.graphics.print(player.x ,80, 80, 100)
--love.graphics.print(player.y ,100, 100, 100)
--love.graphics.print(vehicle.health,180, 180, 100)
--love.graphics.print(player.health,80, 180, 100)
-- Debug options
--love.graphics.setColor(0, 0, 128)  -- Azul ultramarino en RGB
--love.graphics.rectangle("fill", mouseX, mouseY, 1, 1)
--love.graphics.setColor(78, 0, 128)  -- Azul ultramarino en RGB
--love.graphics.rectangle("fill", mouseX, mouseY, 6666, 1)
--love.graphics.rectangle("fill", mouseX, mouseY, 1, 6666)
-- Dibujar los FPS en la esquina superior izquierda
--love.graphics.setColor(255, 255, 255)  -- Establecer el color a blanco
--love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 120, 120, 100)
--love.graphics.print("MOX: " .. mouseX .. " MOY: " .. mouseY, 140, 140, 100)

    -- El HUD
    love.graphics.draw(BAGree, BBlu, 0, 0, 1)
    love.graphics.draw(BAblue, BBlu, 0, 0, .5)
    love.graphics.draw(BApurp, Bpurp, 0, 0, .5)
    love.graphics.draw(Won, PositionWon, 0, .5, .5)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", 30, love.graphics.getHeight() - 38, (player.health / 7)*5, 4)
    love.graphics.rectangle("fill", 30, love.graphics.getHeight() - 16, (player.inHand.ammo / player.inHand.maxAmmo)* 141 , 7)
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", 30, love.graphics.getHeight() - 34, (vehicle.health / 200)* 141 , 4.5)
    love.graphics.setColor(.8, 1, .7)
    love.graphics.rectangle("fill", 30, love.graphics.getHeight() - 16, (player.inHand.chargers / player.inHand.Maxchargers)* 148 , -10)
    love.graphics.setColor(player.health / 200, 0, 0)
    love.graphics.rectangle("fill", 10, love.graphics.getHeight() - 40, 11, 11)
    love.graphics.setColor(player.inHand.ammo / 30, player.inHand.ammo/30, player.inHand.ammo / 30)
    love.graphics.rectangle("fill", 5, love.graphics.getHeight() - 20, 16, 11)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(LifeAmmo, 0, love.graphics.getHeight() - 50, 0, 1)
    Menu()
    if not menuActive then
    love.graphics.setColor(1, 1, 1)  -- Asegurarse de que el color sea blanco para las imágenes
    if not AsWon then
        drawPoints(10, 10, player1Points, 1, 0)  -- Puntos del Jugador 1 en la esquina superior izquierda
        drawPoints(love.graphics.getWidth() - 90, 10, player2Points, 1, 0)  -- Puntos del Jugador 2 debajo del Jugador 1
    else
        drawPoints(135, 360, player1Points, 5, 80)  -- Puntos del Jugador 1 en la esquina superior izquierda
        drawPoints(635, 360, player2Points, 5, 80)  -- Puntos del Jugador 2 debajo del Jugador 1
    end
    love.graphics.draw(Point, mouseX- 4, mouseY- 4, 0, 1)
    if love.mouse.isDown(3) or love.mouse.isDown(2) then love.graphics.draw(HelpPoint, mouseX - 16, mouseY - 16, 0, 1) end
    else
    love.graphics.draw(Pointer, mouseX, mouseY, 0, .035)
    if love.mouse.isDown(1) then love.graphics.draw(Pointered, mouseX, mouseY, 0, .035) end
    end
    love.graphics.print(collectgarbage("count"))
    love.graphics.print(#Bsmoke, 0, 12)
    love.graphics.print(#numbers, 0, 24)
end

function drawVehicle()
    -- Dibujar el vehículo en las coordenadas x e y del mapa
    if vehicle.death then love.graphics.setColor(.5, .75, 1, .5) end
    if vehicle.Direction == "Dwn" then
    love.graphics.draw(vehicle.image, vehicle.x, vehicle.y, 0, vehicle.width / vehicle.image:getWidth(), vehicle.height / vehicle.image:getWidth())  -- Ejemplo: dibuja un rectángulo como vehículo
    elseif vehicle.Direction == "Der" then
    love.graphics.draw(vehicle.image2, vehicle.x, vehicle.y, 0, vehicle.width / vehicle.image:getWidth(), vehicle.height / vehicle.image:getWidth())
    elseif vehicle.Direction == "Up" then
    love.graphics.draw(vehicle.image3, vehicle.x, vehicle.y, 0, vehicle.width / vehicle.image:getWidth(), vehicle.height / vehicle.image:getWidth())
    elseif vehicle.Direction == "Izq" then
    love.graphics.draw(vehicle.image4, vehicle.x, vehicle.y, 0, vehicle.width / vehicle.image:getWidth(), vehicle.height / vehicle.image:getWidth())
    end
    if vehicle.death then love.graphics.setColor(1, 1, 1, 1) end
    --love.graphics.print(vehicle.x .. vehicle.y, 160, 160, 100)
end
  --
    --
      --
        --
          --
      --    --____________________________________________________________________________________________________--             --__--
    --
  --
--
  








--  
-- Efectos & Objetos varios --
-- Crear la nube de gas
function createGasCloud(x, y, width, height, image)
    local gasCloud = {
        x = x,
        y = y,
        width = width,
        height = height,
        image = image,  -- La imagen de la nube de gas
        isActive = true,
        effectDuration = 0,  -- Tiempo en segundos durante el cual el efecto está activo
        effectInterval = 10,  -- Intervalo en segundos para aplicar el efecto
        effectRadius = 50,  -- Radio del área de efecto
        effectDamage = 5,  -- Daño que causa la nube de gas
        effectTimer = 0  -- Temporizador para el efecto
    }

    -- Función para aplicar el efecto de la nube de gas
    function gasCloud:applyEffect()
        -- Verifica si el jugador está dentro del área de efecto
        local function isPlayerInRange(player)
            local distX = player.x - self.x
            local distY = player.y - self.y
            return (distX * distX + distY * distY) <= (self.effectRadius * self.effectRadius)
        end

        -- Aplicar efecto si el jugador está dentro del rango
        if isPlayerInRange(player) then
            player.health = math.max(player.health - self.effectDamage, 0)  -- Reducir la salud del jugador
            print("¡Jugador afectado por la nube de gas!")
        end
    end

    -- Función para actualizar la nube de gas
    function gasCloud:update(dt, CC)
        if not self.isActive then return end
        
        -- Actualiza el temporizador del efecto
        self.effectTimer = self.effectTimer + dt

        -- Aplicar el efecto en intervalos regulares
        if self.effectTimer >= self.effectInterval then
            self:applyEffect()
            self.effectTimer = 0  -- Reiniciar el temporizador
        end
        
        -- Desactivar la nube después de una cierta duración (opcional)
        self.effectDuration = self.effectDuration + dt
        if self.effectDuration >= 30 then  -- Duración en segundos
            self.isActive = false
        end
    end

    return gasCloud
end






















--____________________________________________________________________________________________________________________________________________--

function spawnvehicle(x, y, speed, width, height, health, rotate, image, aceleration, gun)
    local vehicle = {
        x = x or math.random(0, love.graphics.getWidth() - width),
        y = y or math.random(0, love.graphics.getHeight() - height),
        speed = speed or 100,
        width = width or 50,
        height = height or 50,
        health = health or 100,
        rotate = rotate or 0,
        image = image,
        aceleration = aceleration or 0.5,
        currentSpeed = 0, -- Velocidad actual del vehículo
        gun = gun or gun[1],
        seats = {
            {x = 3.5, y = 3, occupied = false}, -- Coordenadas relativas al vehículo
            {x = 15, y = 25, occupied = false}
        },
    }
    table.insert(vehicles, vehicle)
end

function distance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

-- Función para rotar un punto alrededor del centro del vehículo
function rotateAroundCenter(centerX, centerY, radius, initialAngle, angleOffset)
    -- Convertimos los ángulos a radianes
    local radians = initialAngle + angleOffset

    -- Calculamos las nuevas coordenadas
    local x = centerX + radius * math.cos(radians)
    local y = centerY + radius * math.sin(radians)

    return x, y
end
local DD = true
function updateVehicles(dt)
    for _, vehicle in ipairs(vehicles) do
        local originalX = vehicle.x
        local originalY = vehicle.y

        -- Limitar la velocidad máxima
        if vehicle.currentSpeed > vehicle.speed then
            vehicle.currentSpeed = vehicle.speed
        elseif vehicle.currentSpeed < -vehicle.speed / 2 then
            vehicle.currentSpeed = -vehicle.speed / 2
        end

        local function detectCollisionType(vehicle, obstacle)
            local dx = obstacle.x + obstacle.width / 2 - (vehicle.x + vehicle.height / 2)
            local dy = obstacle.y + obstacle.height / 2 - (vehicle.y + vehicle.height / 2)
        
            local angleToObstacle = math.atan2(dy, dx)
            local angleDiff = math.abs((vehicle.rotate - angleToObstacle) % (2 * math.pi))
        
            if angleDiff > math.pi then
                angleDiff = 2 * math.pi - angleDiff
            end
        
            if angleDiff < 0.52 then
                return "frontal"
            elseif angleDiff > 2.62 then  -- ~150 grados o más (colisión trasera)
                return "trasera"
            else
                return "lateral"
            end
        end

        -- Movimiento basado en la rotación
        vehicle.x = vehicle.x + math.cos(vehicle.rotate) * vehicle.currentSpeed * dt
        vehicle.y = vehicle.y + math.sin(vehicle.rotate) * vehicle.currentSpeed * dt

        -- Verificar colisiones por separado
        local collidedX, collidedY = false, false

        for _, obstacle in ipairs(obstacles) do
            if checkCollisionRect(vehicle.x, originalY, vehicle.height + 2, vehicle.height + 2, obstacle.x, obstacle.y, obstacle.width, obstacle.height) and not obstacle.traversable then
                collidedX = true
            end
            if checkCollisionRect(originalX, vehicle.y, vehicle.height + 2, vehicle.height + 2, obstacle.x, obstacle.y, obstacle.width, obstacle.height) and not obstacle.traversable then
                collidedY = true
            end
            if checkCollisionRect(vehicle.x, vehicle.y, vehicle.height + 2, vehicle.height + 2, obstacle.x, obstacle.y, obstacle.width, obstacle.height) and not obstacle.traversable then
                if checkCollisionRect(vehicle.x, vehicle.y, vehicle.height + 2, vehicle.height + 2, obstacle.x, obstacle.y, obstacle.width, obstacle.height) and not obstacle.traversable then
                    local collisionType = detectCollisionType(vehicle, obstacle)
            
                    if collisionType == "frontal" or collisionType == "trasera" then
                        -- Colisión frontal o trasera: detener por completo
                        vehicle.x = originalX
                        vehicle.y = originalY
                        vehicle.currentSpeed = 0
                        break
                    elseif collisionType == "lateral" then
                        -- Colisión lateral: detener solo el eje correspondiente
                        if checkCollisionRect(vehicle.x, originalY, vehicle.height + 2, vehicle.height + 2, obstacle.x, obstacle.y, obstacle.width, obstacle.height) then
                            vehicle.x = originalX
                        end
                        if checkCollisionRect(originalX, vehicle.y, vehicle.height + 2, vehicle.height + 2, obstacle.x, obstacle.y, obstacle.width, obstacle.height) then
                            vehicle.y = originalY
                        end
                    end
                end
            end
        end

        -- Revertir posición solo en el eje que colisionó
        if collidedX then vehicle.x = originalX end
        if collidedY then vehicle.y = originalY end

        -- Control del arma del jugador en el vehículo
        if player.inVehicle then
            player.inHand = vehicle.gun
            DD = true
        elseif not player.inVehicle and DD == true then
            print(player.inHand.name)
            player.inHand = weapons[1]
            DD = false
        end
    end
end

function handleVehicleControl(vehicle, dt)
    -- Rotación con las teclas de izquierda/derecha
    if love.keyboard.isDown("a") then
        vehicle.rotate = vehicle.rotate - (vehicle.currentSpeed / 120) * dt -- Gira a la izquierda
    end
    if love.keyboard.isDown("d") then
        vehicle.rotate = vehicle.rotate + (vehicle.currentSpeed / 120) * dt -- Gira a la derecha
    end

    -- Aceleración con la tecla hacia adelante (W) y hacia atrás (S)
    if love.keyboard.isDown("w") then
        vehicle.currentSpeed = vehicle.currentSpeed + vehicle.aceleration * dt -- Acelera hacia adelante
    elseif love.keyboard.isDown("s") then
        vehicle.currentSpeed = vehicle.currentSpeed - vehicle.aceleration * dt -- Acelera hacia atrás (marcha atrás)
    end
end

function drawVehicles()
    for _, vehicle in ipairs(vehicles) do
        -- Cálculo de factores de escala
        local scaleX = vehicle.width / vehicle.image:getWidth()
        local scaleY = vehicle.height / vehicle.image:getHeight()
        
        -- Guardamos el estado gráfico antes de rotar y escalar
        love.graphics.push()

        -- Trasladamos el origen al centro del vehículo y aplicamos la rotación
        love.graphics.translate((vehicle.x + vehicle.width / 2) + vehicle.Odx, (vehicle.y + vehicle.height / 2) + vehicle.Ody)
        love.graphics.rotate(vehicle.rotate)

        -- Dibujamos la imagen escalada y centrada en su posición
        love.graphics.draw(vehicle.image, -vehicle.width / 2, -vehicle.height / 2, 0, scaleX, scaleY)
        
        -- Restauramos el estado gráfico
        love.graphics.pop()
        if debug then
            love.graphics.rectangle("fill", vehicle.x, vehicle.y, vehicle.height, vehicle.height)
        end
        for _, vehicle in ipairs(vehicles) do
            if vehicle.seats[1].occupied then
            love.graphics.print(player.vehicle.rotate)
            end
        end
    end
end

function shootFromVehicle(vehicle)
    for _, seat in ipairs(vehicle.seats) do
        if seat.gun then
            createBullet(vehicle.x + seat.x, vehicle.y + seat.y, player.angle, 60)
        end
    end
end

function findNearestVehicle(playerX, playerY, range)
    local nearestVehicle = nil
    local minDistance = range

    for _, vehicle in ipairs(vehicles) do
        local dist = distance(playerX, playerY, vehicle.x, vehicle.y)
        if dist < minDistance then
            nearestVehicle = vehicle
            minDistance = dist
        end
    end

    return nearestVehicle
end

function mountVehicle(player, vehicle)
    for _, seat in ipairs(vehicle.seats) do
        if not seat.occupied then
            player.inVehicle = true
            player.vehicle = vehicle
            player.seat = seat
            -- Si el jugador está en el vehículo, actualizar su posición
        for _, seat in ipairs(vehicle.seats) do
            if seat.occupied then
                -- Calcular el centro del vehículo
                local centerX = vehicle.x + vehicle.width / 2
                local centerY = vehicle.y + vehicle.height / 2

                -- Rotar la posición relativa del asiento del jugador respecto al centro del vehículo
                local seatX, seatY = rotateAroundCenter(vehicle.x + seat.x, vehicle.y + seat.y, centerX, centerY, vehicle.rotate)

                -- Actualizar la posición del jugador con la posición rotada
                player.x = vehicle.x * (math.tan(vehicle.rotate)) * 800
                player.y = vehicle.y * (math.tan(vehicle.rotate)) * 800
            end
        end
            seat.occupied = true -- Marcar el asiento como ocupado
            break
        end
    end
end

function dismountVehicle(player)
    player.inVehicle = false
    player.seat.occupied = false -- Liberar el asiento
    player.vehicle = nil
end