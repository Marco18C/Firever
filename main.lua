---@diagnostic disable-next-line: lowercase-global
love = love or {}
unpack = unpack or {}
debug = false

player = {
    x = 777,
    y = 620,
    width = 25,
    height = 25,
    speed = 200,
    team = 15,
    sellingA = 0,
    typeOBJ = "player1",
    currentAnimation = "idle",
    animationSpeed = 0.56,
    timeSinceLastShot = 0,
    bulletsInCharger = 0,
    weaponHandX = 0,
    weaponHandY = 0,
    weaponHandR = 0,
    timeshoot = 0,
    FireAngle = 0,
    health = 200,
    toFront = 1,
    Zoom = .45,
    angle = 0,
    death = false,
    melee = false,
    Playing = false,
    isMoving = false,
    isShooting = false,
    vehicleDriver = false,
    deadIm = love.graphics.newImage("Objetos/Objects/deadBoddy.png"),
    inHand = {},
    vehicle = nil
}
FlagPoint = {x = 0, y = 0, radius = 50}
AsWon = false
Returning = false
Effects = {}
SmokesIm = {}
anim = require("anim")
deepCopy = require("Copy")
LoadG_B = require("LoadG&B")
Explodes = require("Explodes")
I_W = LoadG_B("textures/armas")
handAnim = require("player.WeaponMov")
OBB = require("obb")
mud_thread = love.graphics.newImage("textures/Effects/mud.png")
water_thread = love.graphics.newImage("textures/Effects/01.png")
NA_IMG = love.graphics.newImage("textures/armas/NA.png")
playerIDL = love.graphics.newImage("player/idle/01.png")
playerIDF = love.graphics.newImage("player/idle/02.png")
playerIMG01 = love.graphics.newImage("player/walk/moving.png")
playerIMG02 = love.graphics.newImage("player/walk/chesting.png")
playerIMG03 = love.graphics.newImage("player/walk/melee.png")
playerIMG04 = love.graphics.newImage("player/walk/movingR.png")
playerIMG05 = love.graphics.newImage("player/walk/movingL.png")
PlayerIM = {}
PlayerRM = {}
PlayerCH = {}
PlayerML = {}
PlayerIM = anim:newIM(playerIMG01, 400, 400, .025, true)
PlayerRM = anim:newIM(playerIMG04, 400, 400, .025, true)
PlayerLM = anim:newIM(playerIMG05, 400, 400, .025, true)
PlayerCH = anim:newIM(playerIMG02, 400, 400, 1 / 20, true)
PlayerML = anim:newIM(playerIMG03, 400, 400, 1 / 50, true)
playerHE = love.graphics.newImage("player/walk/Head.png")
BackGroundEnding = {
    x = 0,
    y = 0
}
camera = {
    x = 0,
    y = 0,
    scale = 1,
    isActive = true,
    screenShakeAmount = 0,
    shakeDecaySpeed = 8,
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
local lg = love.graphics
local draw = lg.draw
local setColor = lg.setColor
local mouseGetPos = love.mouse.getPosition
local leftLauncherOffsetX = -50
local leftLauncherOffsetY = 20
local rightLauncherOffsetX = 50
local rightLauncherOffsetY = 20
local aiCantities = 0
local cellSize = 32
local WonScale = 1
local aiEnabled = false  -- Variable para habilitar/deshabilitar la IA
local Refoirment = false       -- Tamaño del mosaico
local backgroundTextures = {}  -- Almacena las texturas para el fondo
local backgroundMatrix = {}    -- Matriz 2D para asignar tipos de textura al fondo
local polygons = require("polygon")
local WindowManager = require("windows")
local KillPoints = require("KillPoints")
local transition = require("transition")
local IAatackPoints = {}
local obstacles = {}
local vehicles = {}
local IACopies = {}
local bullets = {}
local Flags = {}
local Warning = {}
gun = {
    {
        name = "M4",
        damage = 21,
        fireRate = 0.06,
        ["Ox"] = 40,
        ["Oy"] = 0,
        ["Os"] = 0.045,
        ["Odx"] = 12.5,
        ["Ody"] = 12.5,
        ["Offx"] = 37,
        ["Offy"] = 2,
        ["BulletDx"] = 0,
        ["BulletDy"] = 0,
        ammo = 30,
        maxAmmo = 30,
        dispersion = 0.012,
        chargers = 3,
        Maxchargers = 3,
        bulletSpeed = 900,
        pos = 1, -- Si es una primaria (1), secundaria (2) u objeto (3 o 4)
        texture = I_W["M4"],  -- Ajustado el nombre de la textura
        HUD = nil,
        bala = I_W["Bala"],
        auto = true,
        timer = 14,
        shake = 0.6,
        rotateSpeed = 16,
        -- Otras propiedades según sea necesario
    },
    {
        name = "Enfield",
        damage = 198,
        fireRate = 1,
        ["Ox"] = 40,
        ["Oy"] = 0,
        ["Os"] = 0.03,
        ["Odx"] = 12.5,
        ["Ody"] = 12.5,
        ["Offx"] = 37,
        ["Offy"] = 2,
        ["BulletDx"] = 0,
        ["BulletDy"] = 0,
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
        timer = 100,
        shake = 6,
        rotateSpeed = 16,
        -- Otras propiedades según sea necesario
    },
    {
        name = "M1014",
        damage = 14,
        fireRate = 0,
        ["Ox"] = 40,
        ["Oy"] = 0,
        ["Os"] = 0.045,
        ["Odx"] = 12.5,
        ["Ody"] = 12.5,
        ["Offx"] = 35,
        ["Offy"] = 0,
        ["BulletDx"] = 0,
        ["BulletDy"] = 0,
        ammo = 10,
        maxAmmo = 20,
        dispersion = 0.07,
        chargers = 24,
        Maxchargers = 24,
        bulletSpeed = 1000,
        pos = 1, -- Si es una primaria (1), secundaria (2) u objeto (3 o 4)
        texture = love.graphics.newImage("textures/armas/M1014.png"),  -- Ajustado el nombre de la textura
        HUD = nil,
        bala = love.graphics.newImage("textures/armas/Bala2.png"),
        auto = true,
        timer = 8,
        shake = 4,
        rotateSpeed = 16,
        -- Otras propiedades según sea necesario
    },
    {
        name = "MP-18",
        damage = 12.625,
        fireRate = 0.08,
        ["Ox"] = 40,
        ["Oy"] = 180,
        ["Os"] = 0.02,
        ["Odx"] = 12.5,
        ["Ody"] = 12.5,
        ["Offx"] = 20,
        ["Offy"] = 4,
        ["BulletDx"] = 0,
        ["BulletDy"] = 0,
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
        timer = 18,
        shake = 0.75,
        rotateSpeed = 20,
        -- Otras propiedades según sea necesario
    },
    {
        name = "G-18",
        damage = 56,
        fireRate = 0.0,  -- Disparos por segundo
        ["Ox"] = -1400,
        ["Oy"] = 0,
        ["Os"] = 0.008,
        ["Odx"] = 12.5,
        ["Ody"] = 12.5,
        ["Offx"] = 25,
        ["Offy"] = 0,
        ["BulletDx"] = 0,
        ["BulletDy"] = 0,
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
        timer = 16,
        shake = 1.2,
        MaseSpeed = .01,
        rotateSpeed = 16,
        -- Otras propiedades según sea necesario
    },
    {
        name = "Colt 1911",
        damage = 60,
        fireRate = 0.5,  -- Disparos por segundo
        ["Ox"] = -1500,
        ["Oy"] = -100,
        ["Os"] = 0.01,
        ["Odx"] = 12.5,
        ["Ody"] = 12.5,
        ["Offx"] = 25,
        ["Offy"] = 0,
        ["BulletDx"] = 0,
        ["BulletDy"] = 0,
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
        timer = 17,
        shake = 2,
        rotateSpeed = 16,
        -- Otras propiedades según sea necesario
    },
    {
        name = "MediKit",
        damage = -20,
        fireRate = 0.5,
        ["Ox"] = -4,
        ["Oy"] = 2,
        ["Os"] = 1,
        ["Odx"] = 12.5,
        ["Ody"] = 12.5,
        ["Offx"] = 25,
        ["Offy"] = 0,
        ["BulletDx"] = 0,
        ["BulletDy"] = 0,
        ammo = 8,
        maxAmmo = 8,
        dispersion = 0,
        chargers = 1,
        Maxchargers = 1,
        pos = 3, -- Si es una primaria (1), secundaria (2) u objeto (3 o 4)
        texture = love.graphics.newImage("textures/armas/MediKit.png"),  -- Ajustado el nombre de la textura
        HUD = nil,
        bala = love.graphics.newImage("textures/armas/MediKit.png"),
        auto = false,
        timer = .25,
        shake = 0,
        -- Otras propiedades según sea necesario
    },
    {
        name = "FGM-172",
        damage = 600,
        fireRate = 0,
        ["Ox"] = 190,
        ["Oy"] = 0,
        ["Os"] = .1,
        ["Odx"] = 12.5,
        ["Ody"] = 12.5,
        ["Offx"] = 25,
        ["Offy"] = 0,
        ["BulletDx"] = 0,
        ["BulletDy"] = 0,
        ammo = 3,
        maxAmmo = 3,
        dispersion = 1 / 7000,
        chargers = 2,
        Maxchargers = 2,
        pos = 4,
        type = "misile",
        MaseSpeed = .175,
        texture = love.graphics.newImage("textures/armas/Predator.png"),  -- Ajustado el nombre de la textura
        HUD = nil,
        bala = love.graphics.newImage("textures/armas/Misile_1.png"),
        auto = false,
        timer = 6,
        shake = 45,
        rotateSpeed = 6.5,
        OnDestroyBullet = function(x, y)
            Explodes.Explode(x, y, 2, 2)
        end
    }
}

local function toggleAI()
    aiEnabled = not aiEnabled
end

local pathIndex = 1

local function toPixel(cellX, cellY)
    return cellX * cellSize, cellY * cellSize
end

function updateAI(dt)
    if not aiEnabled then return end
    -- Hacer que la AI detecte el path
    if vehicle.currentPath then
        if pathIndex > #vehicle.currentPath then
            -- Esto controla en movimiento de la IA Normal, que solo caza al jugador.
            local start = {x = vehicle.x, y = vehicle.y}
            local goal = {x = player.x, y = player.y}
            vehicle.currentPath = AStar(start, goal)
            pathIndex = 1  -- Reinicia el índice del camino
        end
    else
        print("Error : Recalculando ruta")
        local start = {x = vehicle.x, y = vehicle.y}
        local goal = {x = player.x, y = player.y}
        vehicle.currentPath = AStar(start, goal)
        pathIndex = 1  -- Reinicia el índice del camino
    end
            
    if vehicle.currentPath and #vehicle.currentPath > 0 and pathIndex <= #vehicle.currentPath then
        local nextStep = vehicle.currentPath[pathIndex]
        local targetX, targetY = toPixel(nextStep.x, nextStep.y)  -- Convertir a píxeles
            
        local dx = targetX - vehicle.x
        local dy = targetY - vehicle.y
        local dist = math.sqrt(dx * dx + dy * dy)
            
        if dist > vehicle.speed * dt then
            vehicle.x = vehicle.x + (dx / dist) * vehicle.speed * dt
            vehicle.y = vehicle.y + (dy / dist) * vehicle.speed * dt
        else
            vehicle.x = targetX
            vehicle.y = targetY
            pathIndex = pathIndex + 1
        end
    end

    if vehicle.death then
        vehicle.reviveT = vehicle.reviveT - dt
        if vehicle.reviveT <= 0 then
            for _, flag in ipairs(Flags) do
                if math.Xsign(flag.progress, vehicle.team) then
                    local revivePoint = math.random(1, #flag.spawns)
                    vehicle.x = flag.spawns[revivePoint].x
                    vehicle.y = flag.spawns[revivePoint].y
                end
            end
            vehicle.reviveT = 15
            vehicle.health = 200
            vehicle.death = false
            vehicle.reloadT = 0
            vehicle.currentPath = {}
            vehicle.inHand.ammo = vehicle.inHand.maxAmmo
        end
    end
end

function shootAIBullet(offsetX, offsetY, ShooterMan, Objective, team)
    local vehicle = ShooterMan or vehicle
    local player = Objective or player
    local offsetX = offsetX or 0
    local offsetY = offsetY or 0
    local spreadX = 0
    local spreadY = 0
    local angle = vehicle.angle
    local vehicleBulletSpeed = (vehicle.inHand.bulletSpeed or 500) * (math.random(100, 110) / 100)

    -- Calcular offsets basados en ángulo (si existen)
    local dx = 0
    local dy = 0
    if offsetX then
        dx = math.cos(angle) * offsetX
        dy = math.sin(angle) * offsetX
    end
    if offsetY then
        dx = dx - math.sin(angle) * offsetY
        dy = dy + math.cos(angle) * offsetY
    end

    -- Establacer tipo de misil para que los guiados funcionen xd
    local GunType = vehicle.inHand.type or "default"

    -- Calcular la dirección hacia el jugador de manera automática
    if not vehicle.inVehicle then
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
        spreadX = directionX * cosAngle - directionY * sinAngle
        spreadY = directionX * sinAngle + directionY * cosAngle

        angle = math.atan2(spreadY, spreadX)  -- Actualizar el ángulo de la balaelse
    else
        -- disparar en línea recta hacia donde apunta el vehículo
        spreadX = math.cos(angle) + (math.random() - 0.5) * vehicle.inHand.dispersion
        spreadY = math.sin(angle) + (math.random() - 0.5) * vehicle.inHand.dispersion
    end

    -- Crear la bala con la dirección dispersa
    local bullet = {
        x = (vehicle.x + vehicle.width / 2) + dx,
        y = (vehicle.y + vehicle.height / 2) + dy,
        r = vehicle.inHand.radius or 5,
        time = vehicle.inHand.timer or 100,
        TtoDraw = vehicle.inHand.ActivationTimer or 0,
        OnDestroyBullet = vehicle.inHand.OnDestroyBullet or function()end,
        damage = vehicle.inHand.damage or 10,
        image = vehicle.inHand.bala,
        angle = angle or 0,
        type = GunType,
        team = team or 2,
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

--<----------------------------------------------------------- STAR ------------------------------------------------------------->
local threadObj
local input = love.thread.getChannel("input")
local output = love.thread.getChannel("output")
local threadResult = nil
threadRunning = false

function astarkkk(start, goal, obstacles)
    if not threadRunning then
        threadObj = love.thread.newThread("STAR.lua")
        threadObj:start()
        print("Iniciando hilo de A*" .. " con start: " .. start.x .. "," .. start.y .. " goal: " .. goal.x .. "," .. goal.y)
        input:push({start = start, goal = goal, obstacles = obstacles, Warning = Warning})
        threadRunning = true
    end
    if threadResult then
        if threadResult.result and #threadResult.result > 0 then
            --print("Longitud del path: ", #threadResult.result)
            return threadResult.result
        end
    end
    return nil
end

function UpdateSTAR()
    if threadRunning then
        local result = output:pop()
        if result then
            threadResult = result
            threadRunning = false
            --print("Resultado del hilo:", threadResult.result)
        end
    end
    if threadObj then
        if threadObj:getError() then
            print("Error en el hilo: ", threadObj:getError())
        end
    end
end
--<----------------------------------------------------------- STAR ------------------------------------------------------------->

-- Función para inicializar una copia de IA con un camino
function spawnIACopy(x, y, team)
    local UsableSpawn
    local currentNodeIndex
    local pathData = getPathByName("main") or {}
    for _, flag in ipairs(Flags) do
        if team > 0 and flag.progress < 0 then
            local spawn = flag.spawns[math.random(1, #flag.spawns)]
            UsableSpawn = spawn
            break
        else
            local spawn = flag.spawns[math.random(1, #flag.spawns)]
            UsableSpawn = spawn
            break
        end
    end

    for i, node in ipairs(pathData.nodes) do
        local dx = node.x - x
        local dy = node.y - y
        local dist = math.sqrt(dx * dx + dy * dy)

        if dist < 64 then
            currentNodeIndex = i
            print(currentNodeIndex)
        end
    end

    local newIA = {
        x = x or math.random(0, love.graphics.getWidth() - vehicle.width),
        y = y or math.random(0, love.graphics.getHeight() - vehicle.height),
        angle = 0,
        speed = 200,
        reloadT = 0,
        reviveT = 30,
        health = 200,              -- salud de la IA
        shootTimer = 0,
        currentPathIndex = 1,
        TimeSinceLastShot = 0,
        width = vehicle.width,
        height = vehicle.height,
        direction = "Der",
        lastDirection = {x = 1, y = 0},
        isShooting = false,
        inHand = deepCopy(gun[math.random(1, 4)]),
        path = nil,  -- Inicialmente sin camino
        team = team,
        dead = true,
        currentPathName = "main",
        pathToFollow = nil,
        currentNodeIndex = currentNodeIndex,
        PointCamping = UsableSpawn,
    }
    table.insert(IACopies, newIA)
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

function math.Xsign(a, b)
    return (a >= 0 and b >= 0) or (a < 0 and b < 0)
end

function getPathByName(name)
    local pathData = Paths[name]
    if type(pathData) == "table" then
        return pathData
    else
        print("Error: El camino '" .. name .. "' no es válido o no existe.")
        return nil
    end
end

-- Función principal para actualizar IA
function updateIACopies(dt, player)
    if not Refoirment then return end
    for b, ia in ipairs(IACopies) do
        local pathData = getPathByName("main") or {}
        local closestEntity
        local distanceToTarget = 0
        local closestDistance = math.huge
        if not ia.dead then
            -- Actualizar la vida de la IA
            if ia.health <= 0 then
                ia.dead = true
                ia.health = 200
                ia.reviveT = 30
            end

            ----------------------- ya se ha establecido la IA, ahora a disparar --------------------------------

            -- IA del Team 1 busca enemigo más cercano -----------------------------------------------
            if ia.team == player.team then -----------------------------------------------------------
                for _, otherIA in ipairs(IACopies) do ------------------------------------------------
                    if otherIA.team ~= ia.team then  -- Solo enemigos --------------------------------
                        local distanceToOther = (otherIA.x - ia.x)^2 + (otherIA.y - ia.y)^2-----------
                        if distanceToOther < closestDistance then ------------------------------------
                            closestDistance = distanceToOther ----------------------------------------
                            closestEntity = otherIA --------------------------------------------------
                        end --------------------------------------------------------------------------
                    end ------------------------------------------------------------------------------
                end -----------------------------------------><><><><><><><><-------------------------
            else -------------------------------------------------------------------------------------
                -- IA del Team 2 ---------------------------------------------------------------------
                closestEntity = player ---------------------------------------------------------------
                closestDistance = (player.x - ia.x)^2 + (player.y - ia.y)^2 --------------------------
                -----------------------------------><><><><><><><><><---------------------------------
                -- Buscar IA aliada más cercana ------------------------------------------------------
                for _, otherIA in ipairs(IACopies) do ------------------------------------------------
                    if otherIA.team ~= ia.team then  -- Solo aliadas ---------------------------------
                        local distanceToOther = (otherIA.x - ia.x)^2 + (otherIA.y - ia.y)^2-----------
                        if distanceToOther < closestDistance then ------------------------------------
                            closestDistance = distanceToOther ----------------------------------------
                            closestEntity = otherIA --------------------------------------------------
                        end --------------------------------------------------------------------------
                    end ------------------------------------------------------------------------------
                end ----------------------------------------------------------------------------------
            end --------------------------------------------------------------------------------------

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
                distanceToTarget = math.sqrt(dx * dx + dy * dy)
            end

            -- Comportamiento de disparo
            ia.shootTimer = ia.shootTimer + dt
            local weapon = ia.inHand

            if ia.shootTimer >= weapon.fireRate and weapon.ammo > 0 and distanceToTarget < (200 / math.max(ia.inHand.dispersion, .7)) and not closestEntity.dead then
                local isBurst = weapon.fireRate <= 0
                local team = ia.team
                local offsetX = 0
                local offsetY = 0

                local shoot = function()
                    shootAIBullet(offsetX, offsetY, ia, closestEntity, team)
                end

                if isBurst then
                    for _ = 1, weapon.ammo do
                        shoot()
                    end
                    weapon.ammo = 0
                else
                    shoot()
                    weapon.ammo = weapon.ammo - 1
                end

                ia.shootTimer = 0  -- Reiniciar temporizador
            end

            -- reload all AI's
            if ia.inHand.ammo <= 0 then
                ia.reloadT = ia.reloadT + dt
                if ia.reloadT >= 3 then
                    ia.inHand.ammo = ia.inHand.maxAmmo
                    ia.reloadT = 0
                end
            end

            -- Comprobar colisiones con cada IA usando el sistema de chunks
            for i = #vehicleBullets, 1, -1 do
                local bull = vehicleBullets[i]
                if checkCollisionRect(bull.x, bull.y, 5, 5, ia.x, ia.y, 37, 37) and not ia.dead then
                    -- Verificar si los equipos son diferentes
                    if ia.team ~= bull.team then
                        ia.health = ia.health - ia.inHand.damage
                        KillPoints.addOrb(ia.x, ia.y, 2)
                        bull.OnDestroyBullet(bull.x, bull.y, vehicle)
                        table.remove(vehicleBullets, i)
                    end
                end
            end
            for i = #vehicles, 1, -1 do
                local veh = vehicles[i]

                for _, h in ipairs(veh.RHB) do
                    if not vehicle.inVehicle and checkCollisionRect(h[1], h[2], 1, 1,
                        ia.x, ia.y, ia.width, ia.height) and not ia.dead
                        and veh.currentSpeed >= 100 then
                        ia.dead = true
                        KillPoints.addOrb(ia.x, ia.y, math.floor(ia.inHand.damage / 3))
                    end
                end
            end
            for i = #Explodes.explosions, 1, -1 do
                local e = Explodes.explosions[i]

                local DTE = distance(ia.x, ia.y, e.x, e.y)
                if DTE <= e.radius then
                    ia.health = 0
                    KillPoints.addOrb(ia.x, ia.y, math.floor(ia.inHand.damage / 3))
                end
            end

            -------------------------------- Ya disparó, Movimiento IA por nodos -----------------------------------
            for _, flag in ipairs(Flags) do
                if ia.currentPathName and flag and not ia.dead then

                    if pathData and pathData.nodes then
                        ia.currentNodeIndex = ia.currentNodeIndex or 1
                        local node = pathData.nodes[ia.currentNodeIndex]

                        if node and polygons.isSquareInPolygon(ia.x, ia.y, 0, 0, flag.vertex) and not math.Xsign(ia.team, flag.progress) then
                        else
                            local dx = node.x - ia.x
                            local dy = node.y - ia.y
                            local dist = math.sqrt(dx * dx + dy * dy)

                            if dist < 4 then
                                -- Escoge un vecino aleatorio distinto al anterior
                                local nextOptions = {}
                                for _, neighbor in ipairs(node.neighbors or {}) do
                                    if neighbor ~= ia.previousNodeIndex then
                                        table.insert(nextOptions, neighbor)
                                    end
                                end

                                -- Elegir uno aleatoriamente
                                if #nextOptions > 0 then
                                    ia.previousNodeIndex = ia.currentNodeIndex
                                    ia.currentNodeIndex = nextOptions[math.random(1, #nextOptions)]
                                end
                            else
                                if distanceToTarget < (200 / math.max(ia.inHand.dispersion, .7)) and not closestEntity.dead then
                                else
                                    if not polygons.isSquareInPolygon(ia.x, ia.y, 0, 0, flag.vertex) then
                                        -- Moverse hacia el nodo actual
                                        local dirX, dirY = dx / dist, dy / dist
                                        ia.x = ia.x + dirX * ia.speed * dt / 3.65
                                        ia.y = ia.y + dirY * ia.speed * dt / 3.65
                                    else
                                        local dirX, dirY = dx / dist, dy / dist
                                        ia.x = ia.x + dirX * ia.speed * dt / 11.5
                                        ia.y = ia.y + dirY * ia.speed * dt / 11.5
                                    end
                                end
                            end
                        end
                    end
                end
            end
        else
            ia.reviveT = ia.reviveT - dt
            if ia.reviveT <= 0 then
                for _, flag in ipairs(Flags) do
                    if math.Xsign(flag.progress, ia.team) then
                        local revivePoint = math.random(1, #flag.spawns)
                        ia.x = flag.spawns[revivePoint].x
                        ia.y = flag.spawns[revivePoint].y
                    end
                end
                for _, OtherIA in ipairs(IACopies) do
                    if not checkCollisionRect(ia.x, ia.y, 37, 37, OtherIA.x, OtherIA.y, 37, 37) then
                        ia.reviveT = 30
                        ia.health = 200
                        ia.dead = false
                        ia.reloadT = 0
                        ia.shootTimer = 0
                        ia.inHand.ammo = ia.inHand.maxAmmo
                        player.Playing = true
                        local closestNodeIndex = nil
                        local closestDistance = math.huge
                        for i, node in ipairs(pathData.nodes) do
                            local dx = node.x - ia.x
                            local dy = node.y - ia.y
                            local dist = math.sqrt(dx * dx + dy * dy)

                            if dist < 64 and dist < closestDistance then
                                closestDistance = dist
                                closestNodeIndex = i
                            end
                        end
                        if closestNodeIndex then
                            ia.currentNodeIndex = closestNodeIndex
                        end
                        for _, flag in ipairs(Flags) do
                            if not math.Xsign(ia.team, flag.progress) then
                                local spawn = flag.spawns[math.random(1, #flag.spawns)]
                                ia.PointCamping = spawn
                                break
                            end
                        end
                        break
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
        if not ia.dead then
            local angle = math.atan2(ia.lastDirection.y, ia.lastDirection.x)
            if ia.team == 15 then
                setColor(0.3, 0.3, 1)
                else
                setColor(1, 0.3, 0.3)
            end
            draw(SWATImage, ia.x + 11, ia.y + 11, angle, 0.7, 0.7, 18.5, 18.5)
            setColor(1, 1, 1)
        end
    end
end

function AStar(start, goal)
    local openSet = {}
    local cameFrom = {}
    local gScore = {}
    local fScore = {}
    local MaxNodes = 500

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

        -- Explorar vecinos
        local neighbors = {{x=1, y=0}, {x=-1, y=0}, {x=0, y=1}, {x=0, y=-1}}
        for _, neighbor in ipairs(neighbors) do
            local neighborX = current.x + neighbor.x
            local neighborY = current.y + neighbor.y

            -- Comprobar si el vecino no es un obstáculo
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

    return nil  -- Si no hay camino
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
    draw(
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

function drawMissiles()
    for _, missile in ipairs(vehicleBullets) do
        -- Dibuja el misil con rotación basada en su ángulo
        if missile.type == "misile" then
        -- Dibuja el misil con rotación basada en su ángulo
        missile.angle = math.atan2(player.y - missile.y, player.x - missile.x)
        draw(
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
    local minZoom = player.Zoom
    local maxZoom = player.Zoom
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
    }
end
function updateVisibleChunks(posX, posY, chunkSize, scale)
    scale = scale or 1  -- Usar escala 1 por defecto si no se especifica

    -- Calcular los límites visibles en base a la posición y escala
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    
    local startX = math.floor(posX / chunkSize)
    local startY = math.floor(posY / chunkSize)
    local endX = math.floor((posX + screenWidth) / chunkSize + 64 / scale)
    local endY = math.floor((posY + screenHeight) / chunkSize + 64 / scale)

    -- Generar los chunks necesarios para los límites visibles
    for cx = startX, endX do
        for cy = startY, endY do
            backgroundChunks[cx] = backgroundChunks[cx] or {}
            if not backgroundChunks[cx][cy] then
                backgroundChunks[cx][cy] = generateChunk(cx, cy)
            end
        end
    end

    -- Eliminar los chunks que ya no son visibles
    for cx, column in pairs(backgroundChunks) do
        for cy, _ in pairs(column) do
            if cx < startX or cx > endX or cy < startY or cy > endY then
                backgroundChunks[cx][cy] = nil
            end
        end
        if next(backgroundChunks[cx]) == nil then
            backgroundChunks[cx] = nil
        end
    end
end
local floorImageNT = love.graphics.newImage("textures/obstacle/outgrass1.png")
local imageCache = {}  -- Tabla para almacenar imágenes ya cargadas
function drawBackground()
    for _, column in pairs(backgroundChunks) do
        for cy, chunk in pairs(column) do
            draw(floorImageNT, chunk.x, chunk.y, 0, chunkSize / floorImageNT:getWidth(), chunkSize / floorImageNT:getHeight())
        end
    end
end

function getImage(path)
    local numberIm = 1
    if not imageCache[path] then
        if love.filesystem.getInfo(path) then
            imageCache[path] = love.graphics.newImage(path)
            numberIm = numberIm + 1
        else
            imageCache[path] = getDefaultImage()
        end
    end
    return imageCache[path]
end

local function loadMapImages()
    local mapImages = {}
    local files = love.filesystem.getDirectoryItems("Levels/")
    print("cargando MapsIm")

    for _, file in ipairs(files) do
    end

    return mapImages
end
























--____________________________________________________________________________________________________________________________________________--
local vehiclesLoad = {}
local eventsLoaded = {}
local gunImages = {}
local Events = {}
local FlagsLoad = {}
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
    health = 200,  -- Salud
    width = 25,  -- Anchura
    height = 25,  -- Altura
    angle = 90,  -- HitBox
    HBox = 45,  -- HitBox
    timeshoot = 0, -- Tiempo de disparo
    FireAngle = 0,
    team = -15,
    reviveT = 15,
    death = false,  -- Muerte
    Playing = true,
    isMoving = false,
    Shooting = false,
    inVehicle = false,
    vehicleDriver = false,
    image = vehicleImage,
    image2 = vehicleImage2,
    image3 = vehicleImage3,
    image4 = vehicleImage4,
    deadIm = vehicleImage5,
    Direction = "Der",
    typeOBJ = "player2",
    originX = vehicleImage:getWidth() / 2,
    originY = vehicleImage:getHeight() / 2,
    currentPath = {},  -- Ruta actual
    pathIndex = 1,  -- Índice de la ruta
    reloadT = 0,  -- Tiempo de recarga
    inHand = {},
    vehicle = {
                rotate = 0,
            }
}
vehicleTimeSinceLastShot = 0
vehicleLastDirection = {x = 0.5, y = 0.5}  -- Por defecto disparará hacia la derecha
objects = {}

function createObject(x, y, width, height, onTouchFunction, image, lifeTime, caller, useCollider, onDied)
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
        caller = caller or function()end,
        AtDead = onDied or function()end,
    }
    table.insert(objects, obj)
end

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

local function loadLUAFiles(Table, Path)
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
local function loadLevelDataFromFolders(tableToFill, baseFolder, targetFileName)
    local levelDirs = love.filesystem.getDirectoryItems(baseFolder)
    for _, item in ipairs(levelDirs) do
        local fullPath = baseFolder .. "/" .. item
        if love.filesystem.getInfo(fullPath, "directory") then
            local luaFilePath = fullPath .. "/" .. targetFileName .. ".lua"
            if love.filesystem.getInfo(luaFilePath) then
                local chunk, errorMessage = love.filesystem.load(luaFilePath)
                if chunk then
                    local result = chunk()
                    if type(result) == "table" then
                        table.insert(tableToFill, result)
                    else
                        print("⚠️ El archivo no devolvió una tabla: " .. luaFilePath)
                    end
                else
                    print("❌ Error al cargar el archivo: " .. errorMessage)
                end
            end
        end
    end
end
local function loadImagesFromFolders(tableToFill, baseFolder)
    local levelDirs = love.filesystem.getDirectoryItems(baseFolder)

    for _, item in ipairs(levelDirs) do
        local subFolder = baseFolder .. "/" .. item
        if love.filesystem.getInfo(subFolder, "directory") then
            local files = love.filesystem.getDirectoryItems(subFolder)

            for _, file in ipairs(files) do
                local nameWithoutExt = file:match("(.+)%..+$")
                local extension = file:match("^.+(%..+)$")

                if extension and (extension == ".png" or extension == ".jpg" or extension == ".jpeg" or extension == ".bmp") then
                    local imagePath = subFolder .. "/" .. file
                    local success, image = pcall(love.graphics.newImage, imagePath)

                    if success and image then
                        tableToFill[nameWithoutExt] = image
                    else
                        print("❌ Error cargando imagen: " .. imagePath)
                    end
                end
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
    for _, vehicle in ipairs(vehicles) do
        if checkCollisionRect(x, y, w, h, vehicle.x, vehicle.y, vehicle.height, vehicle.height) then
            return true
        end
    end
    return false
end
local tileSize = 1     
H = true

function getDefaultImage()
    if not imageCache["__default__"] then
        local imgData = love.image.newImageData(64, 64)
        imgData:mapPixel(function(x, y)
            return 1, 0, 0, 1  -- Rojo sólido
        end)
        imageCache["__default__"] = love.graphics.newImage(imgData)
    end
    return imageCache["__default__"]
end

function loadObstacles()
    local levels = {}
    local levelIndex = 2
    local firstLevelObstacles = {}
    local firstLines = {}
    local levelDirs = love.filesystem.getDirectoryItems("Levels")
    mapImages = loadMapImages()
    print("##########################################################################################")

    for _, dir in ipairs(levelDirs) do
        local dirPath = "Levels/" .. dir
        if love.filesystem.getInfo(dirPath, "directory") then
            local path = dirPath .. "/obs.txt"
            if love.filesystem.getInfo(path) then
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
                            local imgPath = "Levels/" .. dir .. "/x64.png"
                            table.insert(firstLineValues, getImage(imgPath))
                        elseif count == 9 then
                            -------- caragr mapas ----------------
                            table.insert(firstLineValues, getImage("Levels/" .. dir .. "/mapImg.png"))
                        elseif count == 10 then
                            local chunk, errorMessage = love.filesystem.load("Levels/" .. dir .. "/flag.lua")
                            if chunk then
                                local result = chunk()
                                table.insert(firstLineValues, result)
                            else
                                print("No se pudo cargar flag.lua en carpeta: " .. dir)
                            end
                        elseif count == 11 then
                            table.insert(firstLineValues, dir)
                            print(dir)
                        elseif count == 12 then
                            table.insert(firstLineValues, val == "true")
                        elseif count == 15 then
                            local chunk, errorMessage = love.filesystem.load("Levels/" .. dir .. "/paths.lua")
                            if not chunk then
                                print("Error al cargar el archivo:", errorMessage)
                            else
                                local pathTable = chunk()
                                table.insert(firstLineValues, pathTable)
                            end
                        elseif count == 1 or count == 2 or count == 3 or count == 4 or
                               count == 7 or count == 8 or count == 13 or count == 14 then
                            table.insert(firstLineValues, tonumber(val))
                        end
                    end
                    table.insert(firstLineValues, dir)
                    print(dir)
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
                        layer = values[8],
                    }
                    obstacle.imgW = obstacle.image:getWidth()
                    obstacle.imgH = obstacle.image:getHeight()
                    obstacle.scaleX = obstacle.width / obstacle.imgW
                    obstacle.scaleY = obstacle.height / obstacle.imgH
                    
                    table.insert(obstacles, obstacle)
                end
            end

            levels[levelIndex - 1] = { obstacles = obstacles }
            levelIndex = levelIndex + 1
            end
        end
    end

    if levelIndex == 1 then
        print("Error: No se encontró ningún archivo de nivel.")
        return {}, {}, {}, {}
    else
        return firstLevelObstacles, levels, firstLines
    end
end

currentLevel = 1
LD = true
function drawPoints(x, y, points, scale, spacing, numbers)
    local digitWidth = numbers[0].width

    -- Convertir el número a una cadena para procesar cada dígito
    local pointsStr = tostring(points)

    for i = 1, #pointsStr do
        local digit = tonumber(pointsStr:sub(i, i))
        local img = numbers[digit].image
        local scaleX = numbers[digit].width / img:getWidth()
        local scaleY = numbers[digit].height / img:getHeight()
        draw(img, x + (i - 1) * (digitWidth + spacing), y, 0, scaleX * scale, scaleY * scale)
    end
end

-- Función de carga
function love.load()
    love.window.setTitle("FieldOfView")
    love.window.setMode(1000, 750)
    WindowSize = love.graphics.getHeight() / 750
    -- Cargar niveles y establecer nivel actual
    obstacles, levels, firstLines = loadObstacles()
    print("NUMLEVELs " .. #levels)
    loadLUAFiles(gun ,"Objetos/guns/")
    loadLUAFiles(Effects ,"effects/")
    loadLUAFiles(loadedVehicles, "Objetos/Drivables/")
    loadLevelDataFromFolders(vehiclesLoad, "Levels", "veh")
    loadLevelDataFromFolders(eventsLoaded, "Levels", "events")
    loadLevelDataFromFolders(FlagsLoad, "Levels", "flag")
    loadImagesFromFolders(gunImages, "textures/armas")
    loadImagesFromFolders(SmokesIm, "textures/Smokes")
    collectgarbage("collect")
    updateVisibleChunks(camera.y, camera.y, chunkSize, camera.scale)
    -- Ocultar el cursor del mouse dentro de la ventana del juego
    love.mouse.setVisible(false)
    -- Crear matriz 2D para el fondo con tipos de texturas aleatorios
    for x = 1, math.ceil(5 / tileSize) do
        backgroundMatrix[x] = {}
        for y = 1, math.ceil(5 / tileSize) do
            backgroundMatrix[x][y] = math.random(1, #backgroundTextures)
        end
    end

    for i = 1, #gun do
        local weapon = gun[i]  -- Obtener arma actual
        if type(weapon.texture) == "string" then  -- Si es un string, convertirlo en imagen
            weapon.texture = I_W[weapon.texture] or weapon.texture  -- Si no existe, mantener el string
        end
    end

    NewGame()

    --------------------------------------------------------------------------------------------------------------------------------------
    ----------------------------------------------------//    las ventanas    //----------------------------------------------------------
    --------------------------------------------------------------------------------------------------------------------------------------
    
    WindowManager.createWindow("Spawns", 0, 0, love.graphics.getWidth() / 2, love.graphics.getHeight())

    for _, flag in ipairs(Flags) do
        WindowManager.addButton("Spawns", flag.name, flag.x, flag.y, 40, 40, function()
            local spawn = flag.spawns[math.random(1, #flag.spawns)]
            if player.death and flag.progress > 0 then
                player.x = spawn.x
                player.y = spawn.y
                for _, weapon in ipairs(weapons) do
                    weapon.ammo = weapon.maxAmmo
                    weapon.chargers = weapon.Maxchargers
                end
                player.death = false
                WindowManager.openWindow("Spawns")
            end
        end)
    end
    WindowManager.addImage("Spawns", mapImages["obstacles" .. tostring(MapsLevel + 1)], 15, 15, (love.graphics.getWidth() / 2) - 30, love.graphics.getHeight() - 30)
    
    --------------------------------------------------------------------------------------------------------------------------------------
    --------------------------------------------------------------------------------------------------------------------------------------
    --------------------------------------------------------------------------------------------------------------------------------------

    -- Cargar imágenes de números
    numbers = {}
    Anumbers = {}
    for i = 0, 9 do
        local img = love.graphics.newImage("Objetos/Numbers/" .. i .. ".png")
        local Aimg = love.graphics.newImage("Objetos/Numbers/A" .. i .. ".png")
        -- Escalar la imagen al 4.5% de su tamaño original
        img:setFilter("nearest", "nearest")
        Aimg:setFilter("nearest", "nearest")
        numbers[i] = {
            image = img,
            width = img:getWidth() * 0.045,
            height = img:getHeight() * 0.045
        }
        Anumbers[i] = {
            image = Aimg,
            width = Aimg:getWidth() * 0.45,
            height = Aimg:getHeight() * 0.45
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
    Effects[1].createObjs()

    -- Establecer la animación inicial
    player.currentAnimation = "idle"
end

function updateVehicleBullets(dt)
    for i = #vehicleBullets, 1, -1 do
        local bullet = vehicleBullets[i]
        bullet.x = bullet.x + bullet.dx * dt
        bullet.y = bullet.y + bullet.dy * dt

        -- Colisión con el jugador
        if checkCollisionRect(bullet.x, bullet.y, 5, 5, player.x, player.y, player.width, player.height) and player.vehicle == nil and not menuActive and not AsWon and not player.death then
            table.remove(vehicleBullets, i)
            bullet.OnDestroyBullet(bullet.x, bullet.y, vehicle)
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
                bullet.OnDestroyBullet(bullet.x, bullet.y, vehicle)
                table.remove(vehicleBullets, i)
            end
        end
        
        for v = #vehicles, 1, -1 do
            local vehicle = vehicles[v]

            if checkCollisionRect(bullet.x, bullet.y, 5, 5, vehicle.x, vehicle.y, vehicle.height, vehicle.height) then
                vehicle.health = vehicle.health - bullet.damage
                bullet.OnDestroyBullet(bullet.x, bullet.y, player)
                table.remove(vehicleBullets, i)
            end
        end

        -- Colisión con los bordes de la pantalla
        if not camera.isActive then
            if bullet.x < 0 or bullet.x > love.graphics.getWidth() or bullet.y < 0 or bullet.y > love.graphics.getHeight() then
                bullet.OnDestroyBullet(bullet.x, bullet.y, player)
                table.remove(vehicleBullets, i)
            end
        end

        -- Colisión con objetos del mapa (por ejemplo, paredes)
        for _, obstacle in ipairs(obstacles) do
            if obstacle.lar == 1 and checkCollisionRect(bullet.x, bullet.y, 5, 5, obstacle.x, obstacle.y, obstacle.width, obstacle.height) and not obstacle.traversable then
                local DestroyerB = bullet.OnDestroyBullet(bullet.x, bullet.y, vehicle) or function()end
                DestroyerB()
                table.remove(vehicleBullets, i)
                break
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
    currentLevel = currentLevel or math.random(1, #levels)
    selectedLine = firstLines[currentLevel]
    player.inVehicle = false
    vehicle.inVehicle = false
    player.inHand.ammo = player.inHand.maxAmmo
    player.inHand = weapons[1]
    vehicle.inHand = WforP2[1]
    WonScale = 35
    vehicles = {}
    KillPoints.orbs = {}
    vehicleBullets = {}
    if player.seat then player.seat.occupied = false end -- Liberar el asiento
    player.vehicle = nil
    player.death = false
    vehicle.death = false
    IACopies = {}
    collectgarbage("collect")
    vehicle.health = 200
    vehicle.currentPath = {}
    player.health = 200
    Returning = true
    MapsLevel = currentLevel
    vehicles = {}
    for _, DataV in ipairs(vehiclesLoad) do
        if DataV.name == selectedLine[#selectedLine] then
            for _, PosVeh in ipairs(DataV.All) do
                for _, vehicle in ipairs(loadedVehicles) do
                    if PosVeh.name == vehicle.name then
                        local bestVeh = deepCopy(vehicle)
                        bestVeh.x = PosVeh.x
                        bestVeh.y = PosVeh.y
                        bestVeh.rotate = PosVeh.rotate
                        table.insert(vehicles, bestVeh)
                        break
                    end
                end
            end
            break
        else
            print("NO se encontraron vehiculos")
        end
    end
    for _, DataD in pairs(FlagsLoad) do
        if DataD.name == selectedLine[#selectedLine] then
            Flags = deepCopy(DataD.FlagsVertex)
            Warning = deepCopy(DataD.warning)
            aiCantities = DataD.IAnumbers
            break
        else
            Flags = {}
            Warning = {{-10000, -10000}, {10750, -10000}, {10750, 10750}, {-10000, 10750}}
            aiCantities = 0
        end
    end
    for _, DataE in pairs(eventsLoaded) do
        if DataE.name == selectedLine[#selectedLine] then
            Events = DataE.All
            break
        else
            Events = {}
        end
    end
    if selectedLine then
        player.x = selectedLine[1]
        player.y = selectedLine[2]
        vehicle.x = selectedLine[3]
        vehicle.y = selectedLine[4]
        FlagPoint.x = selectedLine[7] or 0
        FlagPoint.y = selectedLine[8] or 0
        camera.isActive = selectedLine[5]
        Refoirment = selectedLine[5]
        Paths = selectedLine[15] or {}
        if Events.weather and Effects[1] then
            Effects[1].active = Events.weather or false
            objects = deepCopy(Events.objects)
        else
            Effects[1].active = false
            objects = {}
        end
        bossTank.isAsleep = true
        bossTank.health = 1000
        camera.x = 0
        camera.y = 0
        IAatackPoints = {}
        -- todos los IAatackPoints 1, 2 & 3...
        for _, flag in ipairs(Flags) do
            for _, spawn in ipairs(flag.spawns) do
                local baseX, baseY = spawn.x, spawn.y

                -- Insertar el punto original
                table.insert(IAatackPoints, {x = baseX, y = baseY})
            end
        end
    end
    for i = aiCantities, 1, -1 do
            for _, flag in ipairs(Flags) do
                local Spwn = math.random(1, #flag.spawns)
                local selectedSpwn = flag.spawns[Spwn]
                local SpwnX = selectedSpwn.x
                local SpwnY = selectedSpwn.y
                if flag.progress == 100 and i > aiCantities / 2 then
                    spawnIACopy(SpwnX, SpwnY, 15)
                elseif flag.progress == -100 and i <= aiCantities / 2 then
                    spawnIACopy(SpwnX, SpwnY, -15)
                end
            end
    end
    for _, weapon in ipairs(weapons) do                                                --Cambiè esto, pls pruebalo
    weapon.chargers = weapon.Maxchargers
    end
    for _, Guns in ipairs(gun) do
    Guns.chargers = Guns.Maxchargers
    end
    obstacles = levels[currentLevel].obstacles
    level = level + 1
    transition.reset()
    bossTank.x = 306
    WindowManager.removeWindow("Spawns")
    WindowManager.createWindow("Spawns", 0, 0, love.graphics.getWidth() / 2, love.graphics.getHeight())
    for _, flag in ipairs(Flags) do
        WindowManager.addButton("Spawns", flag.name, flag.x, flag.y, 40, 40, function()
            local spawn = flag.spawns[math.random(1, #flag.spawns)]
            if player.death and flag.progress > 0 then
                player.x = spawn.x
                player.y = spawn.y
                weapons[1].chargers = weapons[1].Maxchargers
                weapons[1].ammo = weapons[1].maxAmmo
                weapons[2].chargers = weapons[2].Maxchargers
                weapons[2].ammo = weapons[2].maxAmmo
                player.death = false
                WindowManager.openWindow("Spawns")
            end
        end)
    end
    WindowManager.addImage("Spawns", selectedLine[9], 15, 15, (love.graphics.getWidth() / 2) - 30, love.graphics.getHeight() - 30)

    
    WindowManager.removeWindow("IAs TP")
    WindowManager.createWindow("IAs TP", 0, 0, love.graphics.getWidth() / 8, love.graphics.getHeight() / 1.2)
    for r, ia in ipairs(IACopies) do
        WindowManager.addButton("IAs TP", r, 4, (12 * r) - 12, 40, 12, function()
            player.x = ia.x
            player.y = ia.y
        end)
    end
    local function mountAtInit(player)
        local nearestVehicle = findNearestVehicle(player.x, player.y, 100) -- rango de 100 píxeles
        if nearestVehicle then
            mountVehicle(player, nearestVehicle)
        end
    end
    mountAtInit(player)
    mountAtInit(vehicle)
    collectgarbage("collect")
end

weapons = {
    gun[1], -- M4
    gun[5], -- Pistola
    gun[3],
    {
        name = "MediKit",
        damage = -20,
        fireRate = 5,
        ammo = 8,
        maxAmmo = 8,
        dispersion = 4,
        chargers = 1,
        Maxchargers = 1,
        bulletSpeed = 100,
        pos = 3, -- Si es una primaria (1), secundaria (2) u objeto (3 o 4)
        texture = love.graphics.newImage("textures/armas/MediKit.png"),  -- Ajustado el nombre de la textura
        bala = love.graphics.newImage("textures/armas/MediKit.png"),
        auto = false,
        timer = 100,
        shake = 0.1,
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
        timer = 0,
        shake = 0,
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
        bulletSpeed = 1111,
        pos = 1, -- Si es una primaria (1), secundaria (2) u objeto (3 o 4)
        texture = I_W["M4"],  -- Ajustado el nombre de la textura
        bala = I_W["Bala"],
        auto = true,
        timer = 100,
        shake = 0.6,
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
        bulletSpeed = 800,
        pos = 2, -- Si es una primaria (1), secundaria (2) u objeto (3 o 4)
        texture = I_W["Pistola"],
        bala = I_W["Bala3"],
        auto = false,
        timer = 100,
        shake = 2,
        -- Otras propiedades según sea necesario
    },
    {
        name = "ShGun",
        damage = 20,
        fireRate = 0,
        ammo = 20,
        maxAmmo = 20,
        dispersion = 0.01,
        chargers = 24,
        Maxchargers = 24,
        bulletSpeed = 1111,
        pos = 1, -- Si es una primaria (1), secundaria (2) u objeto (3 o 4)
        texture = I_W["M4"],  -- Ajustado el nombre de la textura
        bala = I_W["Bala3"],
        auto = true,
        type = "misile",
        timer = 100,
        shake = 5,
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
        bulletSpeed = 100,
        pos = 3, -- Si es una primaria (1), secundaria (2) u objeto (3 o 4)
        texture = I_W["MediKit"],  -- Ajustado el nombre de la textura
        bala = I_W["MediKit"],
        auto = false,
        timer = 100,
        shake = 0.1,
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
        timer = 0,
        shake = 0,
    }
}

-- Detectar cuando se suelta el clic del mouse
function love.mousereleased(x, y, button)
    if button == 1 then
        isDragging = false  -- Detenemos el arrastre
    end
end

function love.mousepressed(x, y, button)
    WindowManager.mousepressed(x, y, button)
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

    
    if not menuActive and not AsWon then
        if not player.inHand.melee then
            if button == 1 and not player.inHand.auto and not player.death then
                shoot(player)
                player.isShooting = true
            else
                player.isShooting = false
            end
        end
    end
end

function love.keypressed(key)
    if key == "escape" then
        menuActive = not menuActive  -- Cambia el estado del menú
        if menuActive then
            vehicle.inHand = WforP2[1]
        end
    end
    if key == "t" then
        for _, vehicle in ipairs(vehicles) do
            local truth
            for _, obstacle in ipairs(obstacles) do
                local obs = {}
                obs.x = obstacle.x + (obstacle.width / 2)
                obs.y = obstacle.y + (obstacle.height / 2)
                obs.hw = obs.width / 2
                obs.hh = obs.height / 2
                obs.angle = 0
                local veh = {}
                veh.x = vehicle.x + (vehicle.width / 4)
                veh.y = vehicle.y + (vehicle.height / 2)
                veh.hw = vehicle.width / 2
                veh.hh = vehicle.height / 2
                veh.angle = vehicle.rotate
                if OBB.check(obs, veh) and not obstacle.traversable then
                    truth = true
                    print("Vehículo:", vehicle.name)
                    print("¿Colisión general?:", tostring(truth))
                    break
                else
                    truth = false
                end
            end
        end
    end
    if key == "f3" then
        debug = not debug
    end
    if key == "return" and selectedLine[5] then
        WindowManager.openWindow("Spawns")
    elseif key == "g" and selectedLine[5] then
        WindowManager.openWindow("IAs TP")
    end
    if key == "u" then
        if player.Zoom == .45 then
            player.Zoom = 1
        else
            player.Zoom = .45
        end
    end
    if key == "f" then
        if not player.melee and not player.death then
            player.melee = true -------------------- termina el melee attack --------------------
            PlayerML:SetFrame(1)
            print("Melee activated")
        end
    end
    if key == "y" then  -- Cambia a la tecla que prefieras
        toggleAI()
    end
    if key == "kp5" then  -- Cambia a la tecla que prefieras
        Refoirment = not Refoirment
    end
    if key == "p" then
        love.window.setMode(1366, 768)
        player1Canvas = love.graphics.newCanvas(love.graphics.getWidth() / 2, love.graphics.getHeight())
        player2Canvas = love.graphics.newCanvas(love.graphics.getWidth() / 2, love.graphics.getHeight())
        WindowSize = love.graphics.getHeight() / 750
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

local function updateShake(camera, dt)
    if camera.screenShakeAmount > 0 then
        camera.screenShakeAmount = camera.screenShakeAmount - (camera.screenShakeAmount * camera.shakeDecaySpeed * dt)
        if camera.screenShakeAmount < 0.05 then
            camera.screenShakeAmount = 0
        end
    end
end

local function UpdateFlags(dt)
    for _, flag in ipairs(Flags) do
        local isContested = false

        -- Comprobar si el jugador está dentro
        if polygons.isSquareInPolygon(player.x, player.y, player.width, player.height, flag.vertex) and not player.death then
            flag.progress = flag.progress + player.team * dt
            isContested = true
        end

        -- Comprobar si el P2 está dentro
        if polygons.isSquareInPolygon(vehicle.x, vehicle.y, vehicle.width, vehicle.height, flag.vertex) and not vehicle.death then
            flag.progress = flag.progress + vehicle.team * dt
            isContested = true
        end

        -- Comprobar las unidades IA
        for _, AI in ipairs(IACopies) do
            if polygons.isSquareInPolygon(AI.x, AI.y, AI.width, AI.height, flag.vertex) and not AI.dead then
                flag.progress = flag.progress + AI.team * dt
                isContested = true
            end
        end

        -- Si no hay nadie capturando y el progreso no está en -100 o 100, relajar hacia 0
        if not isContested and flag.progress ~= 100 and flag.progress ~= -100 then
            if flag.progress > 0 then
                flag.progress = math.max(0, flag.progress - 30 * dt) -- Baja hacia 0
            elseif flag.progress < 0 then
                flag.progress = math.min(0, flag.progress + 30 * dt) -- Sube hacia 0
            end
        end

        -- dar puntos al jugador 1 o 2
        if flag.progress > 99 then
            player1Points = player1Points + flag.progress * dt / 9600
        elseif flag.progress < -99 then
            player2Points = player2Points - flag.progress * dt / 9600
        end

        -- Clamp final entre -100 y 100
        flag.progress = math.max(-100, math.min(flag.progress, 100))
    end
end

function triggerScreenShake(camera ,intensity)
    camera.screenShakeAmount = intensity or 4
end

function lerpAngle(a, b, t)
    local diff = (b - a + math.pi) % (2 * math.pi) - math.pi
    return a + diff * t
end

-- Normaliza ángulo a -π..π
function normalizeAngle(a)
    return (a + math.pi) % (2 * math.pi) - math.pi
end

function UpdateTimers(dt)
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
end

function UpdateObjets(dt)
    for i = #objects, 1, -1 do
        local obj = objects[i]

        if obj.collisionable then
            local playerCollides = checkCollisionRect(player.x, player.y, player.width, player.height, obj.x, obj.y, obj.width, obj.height)
            local vehicleCollides = checkCollisionRect(vehicle.x, vehicle.y, vehicle.width, vehicle.height, obj.x, obj.y, obj.width, obj.height)

            -- Si el jugador toca el objeto y aún no ha sido tocado
            if obj.isActive and playerCollides and not obj.isTouched and not player.inVehicle then
                obj.onTouch(obj, player)
                obj.isTouched = true
            elseif vehicleCollides and not vehicle.inVehicle then
                obj.onTouch(obj, vehicle)
                obj.isTouched = true
            else
                obj.isTouched = false
            end
        end

        if obj.isActive and obj.update then
            obj:update(dt, CC)
        end
        obj.caller(obj)

        obj.lifeTime = obj.lifeTime - dt

        if not obj.isActive then
            table.remove(objects, i)
        elseif obj.lifeTime <= 0 and obj.isActive then
            obj.AtDead()
            obj.isActive = false
        end
    end

    ---//------------------------------- Spawn de objetos ramdom ------------------//--
    --//--------------------------------------------------------------------------//--

    CC = math.floor(CC + 60 * dt)

    if (CC == 150 or CC == 300 or CC == 500) and not menuActive and not AsWon then
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
end

function UpdateP1Anims(dt)
    anim.updateIM(PlayerIM, dt)
    anim.updateIM(PlayerCH, dt)
    anim.updateIM(PlayerML, dt)
    
    if player.currentAnimation == "walk" then
        local UniCFrame = PlayerCH:obtainFrame()
        player.weaponHandR = handAnim[UniCFrame].r
    else
        player.weaponHandR = 0
    end
end

function UpdateBoss(dt)
    -- Actualizar el movimiento y disparos del tanque jefe
    if not bossTank.isAsleep and not AsWon and not menuActive then
        updateBossTank(dt)
        -- El cannon del tanque...
        -- Actualizar la rotación del cañón hacia el jugador
    updateCannonRotation(dt, player.x, player.y)

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

    -- Actualizar las balas del cañón
        for _, bullet in ipairs(cannonBullets) do
            bullet.x = bullet.x + bullet.dx * dt
            bullet.y = bullet.y + bullet.dy * dt
            break
        end
    end
end

function changeScene()
    -- Lógica para cambiar de nivel
    if vehicle.health <= 0 and not vehicle.death then
        vehicle.death = true
        vehicle.health = 200
        KillPoints.addOrb(vehicle.x, vehicle.y, 500)
        vehicle.reviveT = 15
        local V = vehicle
        createObject(V.x, V.y, V.width, V.height, function()end, V.deadIm, 100, function()end, false)
        if not selectedLine[5] then
            player.inHand = weapons[1]
            player2Points = player2Points + 1
            V.death = false
        else
            player1Points = math.max(player1Points - 1, 1)
        end
        if not Paths.main then
            NewGame()
        end
    elseif player.health <= 0 and not player.death then
        player.death = true
        player.health = 200
        KillPoints.addOrb(player.x, player.y, 500)
        createObject(player.x, player.y, player.width, player.height, function()end, player.deadIm, 100, function()end, false)
        dismountVehicle(player)
        if not selectedLine[5] then
            vehicle.inHand = weapons[1]
            player1Points = player1Points + 1
            player.death = false
        else
            player2Points = math.max(player2Points - 1, 1)
        end
        if not Paths.main then
            NewGame()
        end
    end
end

function player2Control(dt)
    ---------------//-----------------//----- Disparo del vehículo ----------//-------//--------------
    if (love.keyboard.isDown("kp0") or aiEnabled) then
        if (vehicleTimeSinceLastShot >= vehicle.inHand.fireRate and
            vehicle.inHand.ammo > 0 and not menuActive and not AsWon and
            not vehicle.death) then
            vehicle.Shooting = true 
            if not vehicle.inVehicle or vehicle.vehicleDriver then
                if vehicle.inHand.fireRate ~= 0 then
                    local offsetX = vehicle.inHand.Offx or 0
                    local offsetY = vehicle.inHand.Offy or 0
                    shootAIBullet(offsetX, offsetY)
                    vehicle.inHand.ammo = vehicle.inHand.ammo - 1
                    vehicleTimeSinceLastShot = 0
                else
                    for _ = 1, vehicle.inHand.ammo do
                        shootAIBullet()
                    end
                    vehicle.inHand.ammo = 0
                end
            else
                if vehicle.inHand.fireRate ~= 0 then
                    shoot(vehicle)
                    vehicle.inHand.ammo = vehicle.inHand.ammo - 1
                    vehicleTimeSinceLastShot = 0
                else
                    for _ = 1, vehicle.inHand.ammo do
                        shoot(vehicle)
                    end
                    vehicle.inHand.ammo = 0
                end
            end
        -- Dash del jugador 2
            if vehicleDashTimeLeft >= 0 then
                vehicleIsDashing = false
                vehicleDashTimeLeft = math.max(vehicleDashTimeLeft - dt, 0)
            end
        end
    else
        vehicle.Shooting = false
    end

    -----//-------------------//-------------------------------------//----------------------------//-----
    ----//-------------------//------------- Movimiento ------------//----------------------------//------
    ---//-------------------//-------------------------------------//----------------------------//-------
    
    if not AsWon and not menuActive then
        -- Calcular la posición anterior del vehículo solo si el jugador está en un vehículo
        local oldX, oldY = vehicle.x, vehicle.y
        -- Manejar el movimiento del vehículo basado en las teclas presionadas
        local PressDot = love.keyboard.isDown("kp.")
        if not vehicle.Shooting then
            if love.keyboard.isDown("left") then
                oldX = vehicle.x - vehicle.speed * dt
                vehicle.Direction = "Izq"
                if vehicle.inVehicle then
                    vehicle.angle = vehicle.angle - math.rad(162) * dt
                end
                vehicleLastDirection = {x = -1, y = 0}
            elseif love.keyboard.isDown("right") then
                oldX = vehicle.x + vehicle.speed * dt
                vehicle.Direction = "Der"
                if vehicle.inVehicle then
                    vehicle.angle = vehicle.angle + math.rad(162) * dt
                end
                vehicleLastDirection = {x = 1, y = 0}
            end
            if love.keyboard.isDown("up") then
                oldY = vehicle.y - vehicle.speed * dt
                vehicle.Direction = "Up"
                if PressDot then
                    vehicle.angle = math.rad(270)
                end
                vehicleLastDirection = {x = 0, y = -1}
            elseif love.keyboard.isDown("down") then
                oldY = vehicle.y + vehicle.speed * dt
                vehicle.Direction = "Dwn"
                if PressDot then
                    vehicle.angle = math.rad(90)
                end
                vehicleLastDirection = {x = 0, y = 1}
            end
        end
        
        -- Evitar que el vehículo se salga de la pantalla o colisione con obstáculos
        -- Si hay una colisión, restaurar la posición anterior del vehículo
        if not checkCollision(oldX, oldY, vehicle.width, vehicle.height) then
            vehicle.x, vehicle.y = oldX, oldY
        end
    end

    -------//-------------------//-------------------------------------//----------------------------//-----
    ------//-------------------//--------------- Recarga del P2 ------//----------------------------//------
    -----//-------------------//-------------------------------------//----------------------------//-------
    if vehicle.inHand.ammo <= 0 then
        vehicle.reloadT = vehicle.reloadT + dt
        if vehicle.reloadT >= 1 then
            vehicle.inHand.ammo = vehicle.inHand.maxAmmo
            vehicle.reloadT = 0
        end
    end

    for i = 1, 4 do
        if love.keyboard.isDown("kp" .. tostring(i)) and not vehicle.inVehicle then
            vehicle.inHand = WforP2[i]
            break
        end
    end
    
    if vehicle.health < 200 then
        vehicle.health = vehicle.health + 0.125
    end
    if not vehicle.inVehicle then
        vehicle.angle = math.atan2(player.y - vehicle.y, player.x - vehicle.x)
    end


    vehicleTimeSinceLastShot = vehicleTimeSinceLastShot + dt
end

local function UpdateBulles(dt)
    for e = #bullets, 1, -1 do
    local bullet = bullets[e]
        bullet.x = bullet.x + bullet.speed * dt * math.cos(bullet.angle)
        bullet.y = bullet.y + bullet.speed * dt * math.sin(bullet.angle)
        -- Verificar colisiones con obstáculos
        for _, obstacle in ipairs(obstacles) do
        if not obstacle.traversable and obstacle.lar == 1 and checkBulletObstacleCollision(bullet, obstacle) then
            bullet.isActive = false  -- Desactivar la bala si hay colisión con un obstáculo
            bullet.OnDestroyBullet(bullet.x, bullet.y, player)
            Explodes.Explode(bullet.x + (bullet.radius / 2), bullet.y + (bullet.radius / 2), .2, .3)
            table.remove(bullets, e)
                break  -- No es necesario verificar colisiones con otros obstáculos
            elseif checkBulletObstacleCollision(bullet, vehicle) 
            and not vehicle.inVehicle and not vehicle.death then
                -- comprobar el daño del jugador 2 ( PERDÍ ESTO POR NO HACERLE CASO A FREDDY :( )
                vehicle.health = vehicle.health - math.random(bullet.damage - bullet.damage / 8, bullet.damage + 5)
                bullet.OnDestroyBullet(bullet.x, bullet.y, player)
                table.remove(bullets, e)
                break
            end
        end
        -- Comprobar colisiones con cada IA
        for j = #IACopies, 1, -1 do
            local ia = IACopies[j]
            if checkCollisionRect(bullet.x - (bullet.radius / 2), bullet.y - (bullet.radius / 2), bullet.radius, bullet.radius, ia.x, ia.y, ia.width, ia.height) and not ia.dead then
                ia.health = ia.health - bullet.damage
                KillPoints.addOrb(ia.x, ia.y, 2)
                table.remove(bullets, e)  -- Eliminar la bala
                if ia.health <= 0 then
                    ia.dead = true            -- Eliminar la IA si su salud llega a 0
                    break
                end
            end
        end
        -- Verificar colisión con el tanque jefe
        if checkCollisionWithBossTank(bullet) and not bossTank.isAsleep then
            table.remove(bullets, e)  -- Eliminar la bala después de la colisión
        end

        -- Desactivar la bala si sale de la pantalla
        if not camera.isActive then
            if bullet.x < -5 or bullet.y < -5 or bullet.x > 1000 or bullet.y > 750 then
                bullet.isActive = false
            end
        end
        bullet.timer = bullet.timer - dt
        bullet.timero = bullet.timero + dt
        if bullet.timer <= 0 then
            bullet.OnDestroyBullet(bullet.x, bullet.y, player)
            table.remove(bullets, e)
            break
        end
    end
end

function PlayerControls(dt)
    ----------//------------//------- Lógica para recargar --------------//------------//---------------------//----------
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

    -------//-------------------//-------------------------------------//----------------------------//-----
    ------//-------------------//--------------- Animaciones ---------//----------------------------//------
    -----//-------------------//-------------------------------------//----------------------------//-------

    -- Actualizar ángulo del jugador
    local mouseX, mouseY = love.mouse.getPosition()
    local playerX, playerY

    if not camera.isActive then
        playerX = player.x + player.width / 2
        playerY = player.y + player.height / 2
    else
        playerX = (love.graphics.getWidth() / 4) + (player.width / 2)
        playerY = (love.graphics.getHeight() / 2) + (player.height / 2)
    end

    -- Ángulo objetivo hacia el mouse
    local targetAngle = math.atan2(mouseY - playerY, mouseX - playerX)

    -- Rotación con suavizado si corresponde
    if player.inHand.rotateSpeed then
        player.angle = lerpAngle(player.angle, targetAngle, math.min(player.inHand.rotateSpeed * dt, 1))
    else
        player.angle = targetAngle
    end

    -- Límite de giro si está en vehículo
    if player.vehicle and player.vehicle.gun.Llimit and player.vehicle.gun.Rlimit then
        if player.vehicle.gun.Llimit ~= 0 and player.vehicle.gun.Llimit ~= 0 then
            local v = player.vehicle
            local diff = normalizeAngle(player.angle - v.rotate)

            -- límites (por defecto simétricos si no defines ambos)
            local left  = v.gun.Llimit
            local right = v.gun.Rlimit

            -- recorta el ángulo relativo según lado
            if diff >  right then diff =  right end
            if diff < -left then diff = -left end

            player.angle = normalizeAngle(v.rotate + diff)
        end
    end
    
    -- Restringir la tasa de disparo
    if player.timeshoot > 0 then
        player.timeshoot = player.timeshoot - dt
    end

    if player.melee then
        local frame = PlayerML:obtainFrame()
        if frame == 15 and not player.death then
            createBullet((player.x + 12.5),
                         (player.y + 12.5),
            player.angle, "default", .05,
            0, 15, function()end,
            23, 0, NA_IMG, 0, 666)
        elseif frame == 25 then
            createBullet((player.x + 12.5),
                         (player.y + 12.5),
            player.angle, "default", .05,
            0, 15, function()end,
            23, 0, NA_IMG, 0, 666)
            player.melee = false
        end
    end

    -------//-------------------//-------------------------------------//----------------------------//-----
    ------//-------------------//--------------- Disparo del P1 ------//----------------------------//------
    -----//-------------------//-------------------------------------//----------------------------//-------
    if love.mouse.isDown(1) 
    and player.timeshoot <= 0 
    and not menuActive 
    and not AsWon 
    and player.inHand.auto 
    then
        -- Si el jugador no está muerto
        player.isShooting = true
        if not player.death then
            -- Si el arma tiene una cadencia de disparo (fireRate) mayor a 0
            if player.inHand.fireRate > 0 then
                shoot(player) -- Dispara una bala
                player.timeshoot = player.inHand.fireRate -- Reinicia el tiempo de espera entre disparos
            else
                -- Si el arma no tiene fireRate, dispara todas las balas disponibles
                for i = 1, player.inHand.ammo do
                    shoot(player)
                    player.inHand.ammo = player.inHand.ammo - 1
                end
            end
        end
    else
        player.isShooting = false
    end

    UpdateBulles(dt)

    -----//-------------------//-------------------------------------//----------------------------//-----
    ----//-------------------//------------- Movimiento ------------//----------------------------//------
    ---//-------------------//-------------------------------------//----------------------------//-------

    -- Seleccionar armas (Asalto)
    for i = 1, 4 do
        if love.keyboard.isDown(tostring(i)) and not player.inVehicle then
            player.inHand = weapons[i]
            local frameDuration = player.inHand.MaseSpeed or (1 / 20)
            PlayerCH:SetFramerate(frameDuration)
            break
        end
    end
    if not AsWon and not menuActive then
        local up    = love.keyboard.isDown("w")
        local down  = love.keyboard.isDown("s")
        local left  = love.keyboard.isDown("a")
        local right = love.keyboard.isDown("d")

        local moveX, moveY = 0, 0

        if up then moveY = -1 end
        if down then moveY = 1 end
        if left then moveX = -1 end
        if right then moveX = 1 end

        local attackType = not player.melee
        -- Movimiento
        if (moveX ~= 0 or moveY ~= 0) and attackType and not player.inVehicle then
            -- Normalizar para evitar velocidad diagonal aumentada
            local magnitude = math.sqrt(moveX * moveX + moveY * moveY)
            moveX = moveX / magnitude
            moveY = moveY / magnitude

            -- Movimiento
            newX = player.x + moveX * player.speed * dt
            newY = player.y + moveY * player.speed * dt

            player.currentAnimation = "walk"
            player.isMoving = true

            -- Dirección del jugador (normalizada)
            local dirX = math.cos(player.angle)
            local dirY = math.sin(player.angle)

            local moveAngle = math.atan2(moveY, moveX)
            local delta = player.angle - moveAngle

            delta = (delta % (2 * math.pi) + 2 * math.pi) % (2 * math.pi)

            player.sellingA = delta
        else
            player.currentAnimation = "idle"
            player.isMoving = false
        end
    end
    
    if not checkCollision(newX, newY, player.width, player.height) then
        player.x, player.y = newX, newY
    end

    player.originX = (playerIDL:getWidth() / 2) * .1
    player.originY = (playerIDL:getHeight() / 2) * .1
end

-- Función de actualización
function love.update(dt)
    Effects[1].update(dt)
    if not menuActive and not AsWon then
        updateShake(camera, dt)
        Explodes.Update(dt)
        KillPoints.UpdateOrbs(dt)
        collectgarbage("collect")
        UpdateSTAR()
        UpdateTimers(dt)
        UpdateObjets(dt)
        UpdateP1Anims(dt)
        player2Control(dt)
        PlayerControls(dt)
        startVehicleDash(dt)

        updateIACopies(dt, player)
        updateVehicleBullets(dt)
        updateVehicles(dt)
        updateMissiles(dt)
        UpdateFlags(dt)
        changeScene()
        UpdateBoss(dt)
        updateAI(dt)
        
        VehicleUpDownUpdate(player, "w", "s", "a", "d", "q", "e", dt)
        VehicleUpDownUpdate(vehicle, "up", "down", "left", "right", "kp9", "kp7", dt)
    end

    AsRounding(dt)
    transition.update(dt)
    
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

function shoot(player)
    if player.inHand.ammo > 0 and player.timeshoot <= 0 then
        -- Reduzca la munición
        player.inHand.ammo = player.inHand.ammo - 1
        -- rotar cuerpo
        player.FireAngle = (math.random() * 2 - 1) * player.inHand.dispersion
        if player.inHand.BulletDx and player.inHand.BulletDy then
            createBullet((player.x + player.width / 2) + player.inHand.BulletDx,
                         (player.y + player.height / 2) + player.inHand.BulletDy,
            player.angle + (player.weaponHandR or 0) + player.FireAngle, player.inHand.type, player.inHand.timer,
            player.inHand.ActivationTimer, player.inHand.radius, player.inHand.OnDestroyBullet,
            player.inHand.Offx, player.inHand.Offy)
        else
            createBullet(player.x + player.width / 2, player.y + player.height / 2,
            player.angle + (player.weaponHandR or 0) + player.FireAngle, player.inHand.type, player.inHand.timer,
            player.inHand.ActivationTimer, player.inHand.radius, player.inHand.OnDestroyBullet)
        end
        triggerScreenShake(camera ,player.inHand.shake)
    end
end

function createBullet(x, y, angle, type, time, Atimer, radius, OnDestroyBullet, offsetX, offsetY, img, speed, damage)
    local newBullet = table.copy(Bullet)

    -- Calcular offsets basados en ángulo (si existen)
    local dx = 0
    local dy = 0
    if offsetX then
        dx = math.cos(angle) * offsetX
        dy = math.sin(angle) * offsetX
    end
    if offsetY then
        dx = dx - math.sin(angle) * offsetY
        dy = dy + math.cos(angle) * offsetY
    end

    newBullet.radius = radius or 5
    newBullet.x = x + dx - (newBullet.radius / 2)
    newBullet.y = y + dy - (newBullet.radius / 2)
    newBullet.speed = (speed or player.inHand.bulletSpeed or 500) * (math.random(100, 110) / 100)
    newBullet.angle = angle
    newBullet.isActive = true
    newBullet.texture = img or player.inHand.bala
    newBullet.type = type or nil
    newBullet.timer = time
    newBullet.timero = 0
    newBullet.ActivationTimer = Atimer or 0
    newBullet.damage = damage or player.inHand.damage or 10
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

local function drawGuns(player)
local currentGun = player.inHand
local weaponHandR = player.weaponHandR or 0
    if player.melee then return end
    if currentGun.texture then
        if player.inHand.Ox and player.inHand.Oy then
            draw(currentGun.texture,
            (player.x) + player.inHand.Odx,
            (player.y) + player.inHand.Ody,
            player.angle + weaponHandR + player.FireAngle, player.inHand.Os, player.inHand.Os,
            player.inHand.Ox, player.inHand.Oy)
        else
            draw(currentGun.texture,
            (player.x) + currentGun.texture:getHeight() /2,
            (player.y) + currentGun.texture:getHeight() /2,
            player.angle, 1, 1, player.originX, player.originY)
        end
    end
end

local function drawBullets()
    for _, bullet in ipairs(bullets) do
        if bullet.isActive and bullet.timero > bullet.ActivationTimer then
            local BullW = bullet.texture:getWidth()
            local BullH = bullet.texture:getHeight()
            draw(bullet.texture, bullet.x + 2.5, bullet.y + 2.5, bullet.angle, 1, 1, BullW / 2, BullH / 2)
        end
    end  -- Estas son las balas :)
end

function Menu()
    if menuActive then
        draw(DoGround)

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
        draw(Direcction, 945, 431, 0, -0.045)
        draw(Direcction, 805, 409, 0, 0.045)
        draw(Direcction, 945, 476, 0, -0.045)
        draw(Direcction, 805, 454, 0, 0.045)
        draw(Direcction, 945, 300, 0, -0.045)
        draw(Direcction, 805, 278, 0, 0.045)
        love.graphics.print(weapons[1].fireRate, 860, 278)

        -- Dibujar los slots de las armas actuales
        love.graphics.rectangle("line", 100, 100, 190, 50)
        setColor(0.206, 0.206, 0.134)
        love.graphics.rectangle("fill", 100, 100, 190, 50)
        love.graphics.rectangle("fill", 100, 280, 190, 50)
        love.graphics.rectangle("fill", 100, 340, 190, 50)
        love.graphics.rectangle("fill", 470, 100, 150, 300)
        setColor(1, 1, 1)
        love.graphics.print("Slot 1: " .. tostring(weapons[1].name), 110, 120)
        love.graphics.print("Slot 1: " .. tostring(WforP2[1].name), 110, 300)
        love.graphics.rectangle("line", 100, 160, 190, 50)
        love.graphics.rectangle("line", 100, 280, 190, 50)
        love.graphics.rectangle("line", 100, 340, 190, 50)
        setColor(0.206, 0.206, 0.134)
        love.graphics.rectangle("fill", 100, 160, 190, 50)
        setColor(1, 1, 1)
        love.graphics.print("Slot 2: " .. tostring(weapons[2].name), 110, 180)
        love.graphics.print("Slot 1: " .. tostring(WforP2[2].name), 110, 360)

        love.graphics.print("Selecciona el arma:", 300, 70)
        draw(Direcction, 435, 431, 0, -0.045)
        draw(Direcction, 295, 410, 0, 0.045)
        
        -- Dibujar la lista de armas disponibles en la página actual
        local startIndex = (page - 1) * itemsPerPage + 1
        local endIndex = math.min(startIndex + itemsPerPage - 1, #gun)

        for i = startIndex, endIndex do
            local weapon = gun[i]
            local x = 300
            local y = 100 + (i - startIndex) * 60  -- Espacio vertical entre las armas
            if weapon.HUD ~= nil then
            draw(weapon.HUD, x, y, 0, 0.15, 0.15)  -- Dibujar la textura
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
                local selectedLine = firstLines[i]
                local img = numbers[digit].image
                local scaleX = numbers[digit].width / img:getWidth()
                local scaleY = numbers[digit].height / img:getHeight()
                draw(img, x + (e - 1) * digitWidth, y, 0, scaleX, scaleY)
                love.graphics.rectangle("line", x - 8, y, 146, 60)
                draw(selectedLine[6], x + (e - 1) + 90, y + 7.5, 0, .35)
                love.graphics.rectangle("line", x + (e - 1) + 90, y + 7.5, 45, 45)
            end
        end

        -- Mostrar indicación de páginas
        love.graphics.print("Página " .. page .. " de " .. math.ceil(#gun / itemsPerPage), 325, 412.5)
        draw(NEXTImage)
    end
end

-- Calcula la distancia entre dos puntos
function getDistance(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return math.sqrt(dx * dx + dy * dy)
end

FF = 1

local function DebugDraw()
    if debug then
        setColor(1, 0, 0)
        love.graphics.rectangle("line", player.x, player.y, player.width, player.height)
        setColor(0, 0, 1)
        love.graphics.rectangle("line", vehicle.x, vehicle.y, vehicle.width, vehicle.height)
        setColor(0, 1, 1)
        for _, bullet in ipairs(bullets) do
            if bullet.isActive then
                love.graphics.rectangle("line", bullet.x, bullet.y, bullet.radius, bullet.radius)
            end
        end
        for _, obj in ipairs(objects) do
            love.graphics.rectangle("line", obj.x, obj.y, obj.width, obj.height)
        end
        for _, veh in ipairs(vehicles) do
            love.graphics.rectangle("fill", veh.x, veh.y, veh.width, veh.height)
            love.graphics.setColor(0, 0, 0)
            love.graphics.print(veh.health, veh.x, veh.y)
            love.graphics.print(tostring(veh.Collides), veh.x, veh.y + 14)
            if veh.impactAngle then love.graphics.print(math.deg(veh.impactAngle), veh.x, veh.y + 28) end
                local vehT = {}
                vehT.x = veh.x + (veh.width / 4)
                vehT.y = veh.y + (veh.height / 2)
                vehT.hw = veh.width / 2
                vehT.hh = veh.height / 2
                vehT.angle = veh.rotate
                OBB.draw(vehT, {1, 0, 0})

            local VeH = veh.RHB
            for i = #VeH, 1, -1 do
                local H = VeH[i]
                local hx, hy = H[1], H[2]
                love.graphics.setColor(1, 1, .1)
                love.graphics.circle("fill", hx, hy, 5)
            end
            love.graphics.setColor(1, 1, 1)
        end
        setColor(1, 1, 1)

        if vehicle.currentPath then
            for _, path in ipairs(vehicle.currentPath) do
                love.graphics.circle("fill", path.x, path.y, 2)
            end
        end


        ------------------------------------------------------------------------------
        love.graphics.rectangle("line", player.x, player.y,---------------------------
       -(love.graphics.getWidth() / 3) - (player.width / 2), 8)-----------------------
        --------------------Dibujar distancia de pantalla y centro--------------------
        love.graphics.rectangle("line", player.x + player.width, player.y, -----------
        (love.graphics.getWidth() / 3) - (player.width / 2), 8)-----------------------
        ------------------------------------------------------------------------------
    end
end

local function DegugDrawunder()
    if debug then
        local worldPlayerX = (love.graphics.getWidth() / 4) + (player.width / 2)
        local worldPlayerY = (love.graphics.getHeight() / 2) + (player.height / 2)
        love.graphics.print("FPS :" .. love.timer.getFPS(), 0, 36)
        love.graphics.print(collectgarbage("count"))
        love.graphics.print(#Bsmoke, 0, 12)
        love.graphics.print("Diferencia de ángulos " .. tostring(math.deg(player.sellingA)), 80, 12)
        love.graphics.print(#numbers, 0, 24)
        love.graphics.print("Balas ATP" .. #bullets, 0, 84)
        love.graphics.print("Balas UNP" .. #vehicleBullets, 0, 96)
        love.graphics.print("IAs" .. #IACopies, 0, 108)
        love.graphics.print("Player coord : X " .. player.x .. " Y " .. player.y, 0, 120)
        love.graphics.print("Players Points : 1 " .. player1Points .. " 2 " .. player2Points, 0, 132)
        love.graphics.print("Obstacles cantities : Xnum" .. #obstacles, 0, 144)



        if player.inHand.Oy then
            love.graphics.print(player.inHand.Ox .. " " .. player.inHand.Oy, 0, 48)
        end
        if vehicle.inHand.Oy then
            love.graphics.print(vehicle.inHand.Ox .. " " .. vehicle.inHand.Oy, 0, 60)
        end
        if vehicle.vehicle then
            if vehicle.vehicle.seats then
                if vehicle.vehicle.seats[2].y ~= nil then
                    love.graphics.print(vehicle.vehicle.seats[2].x .. " " .. vehicle.vehicle.seats[2].y, 0, 60)
                end
            end
        end
        if player.vehicle then
            if player.vehicle.seats then
                if player.vehicle.seats[2].y ~= nil then
                    love.graphics.print(player.vehicle.seats[2].x .. " " .. player.vehicle.seats[2].y, 0, 72)
                end
            end
        end

        love.graphics.rectangle("line", worldPlayerX, worldPlayerY, player.width / 2, player.height / 2)
        love.graphics.rectangle("line", worldPlayerX, worldPlayerY, -(player.width / 2), -(player.height / 2))

        ------------------------------------------------------------------------------
        setColor(1, 0, 1)-----------------------------------------------
        love.graphics.rectangle("line",-----------------------------------------------
        (love.graphics.getWidth() / 4),-----------------------------------------------
        (love.graphics.getHeight() / 2) + (player.width / 2),-------------------------
       -(love.graphics.getWidth() / 4) - (player.width), 8)---------------------------
        --------------------Dibujar distancia de pantalla y centro--------------------
        love.graphics.rectangle("line",-----------------------------------------------
        (love.graphics.getWidth() / 4) + player.width,--------------------------------
        (love.graphics.getHeight() / 2) + (player.width / 2),-------------------------
        (love.graphics.getWidth() / 4) - (player.width), 8)---------------------------
        ------------------------------------------------------------------------------
        setColor(1, 1, 1)-----------------------------------------------
        ------------------------------------------------------------------------------
        ---
        ---
        local mouseX, mouseY = love.mouse.getPosition()
        love.graphics.print(mouseX .. " " .. mouseY, mouseX, mouseY - 12)
        ---
        ---
    end
end

local function drawFlags()
    for _, flag in ipairs(Flags) do
        -- Asegurar que progress esté en el rango correcto
        local progress = math.max(-100, math.min(100, flag.progress or 0))
        local t = (progress + 100) / 200

        -- Cálculo de color
        local distanceFromZero = math.abs(progress) / 100
        local baseGray = 0.5

        local r = baseGray + (1 - baseGray) * (1 - t) * distanceFromZero
        local g = baseGray * (1 - distanceFromZero)
        local b = baseGray + (1 - baseGray) * t * distanceFromZero

        -- Dibujar el nombre de la bandera
        setColor(r, g, b)
        love.graphics.print(flag.name, flag.x, flag.y)

        -- Dibujar el polígono si tiene vértices
        if flag.vertex and #flag.vertex > 2 and flag.progress > 0 then
            -- Primero el relleno, con 30% de opacidad
            setColor(0, 0, b, 0.2)
            local vertices = {}
            for _, v in ipairs(flag.vertex) do
                table.insert(vertices, v[1])
                table.insert(vertices, v[2])
            end
            love.graphics.polygon("fill", vertices)

            -- Luego el contorno, con 100% de opacidad
            setColor(0, 0, b, .4)
            love.graphics.polygon("line", vertices)
        elseif flag.vertex and #flag.vertex > 2 and flag.progress < 0 then
            -- Primero el relleno, con 30% de opacidad
            setColor(r, 0, 0, 0.2)
            local vertices = {}
            for _, v in ipairs(flag.vertex) do
                table.insert(vertices, v[1])
                table.insert(vertices, v[2])
            end
            love.graphics.polygon("fill", vertices)

            -- Luego el contorno, con 100% de opacidad
            setColor(r, 0, 0, .4)
            love.graphics.polygon("line", vertices)
        elseif flag.vertex and #flag.vertex > 2 and flag.progress == 0 then
            -- Primero el relleno, con 30% de opacidad
            setColor(.1, .1, .1, 0.2)
            local vertices = {}
            for _, v in ipairs(flag.vertex) do
                table.insert(vertices, v[1])
                table.insert(vertices, v[2])
            end
            love.graphics.polygon("fill", vertices)

            -- Luego el contorno, con 100% de opacidad
            setColor(.1, .1, .1, .4)
            love.graphics.polygon("line", vertices)
        end
    end

    -- Restaurar color
    setColor(1, 1, 1)
end

local function drawScene()
    -- Dibujar el fondo
    -- drawBackground() -- Dibujar el fondo dinámico
    -- Obtener las coordenadas del ratón
    mouseX, mouseY = love.mouse.getPosition()

    -- Dibujar obstáculos below
    for _, obstacle in ipairs(obstacles) do
        local obsX, obsY = obstacle.x, obstacle.y
        local obsW, obsH = obstacle.width, obstacle.height

        if obstacle.layer == "below" then
            draw(
                obstacle.image, obsX, obsY, 0,
                obstacle.scaleX,
                obstacle.scaleY
            )
        end
    end
    
    -----------------------------------------------//---------------------//------------------------------------------------------
    --------------------------------------//------// INICIO DE LA ESCENA //----//-------------------------------------------------
    -------------------------------------//------//---------------------//----//--------------------------------------------------
    ------------------------------------//-----------------------------------//---------------------------------------------------

    -- Dibujar al jugador
    if not player.inVehicle then
        if player.death then setColor(.5, .75, 1, .5) end
        -------------------------------- EL PROPIO JUGADOR --------------------------------
        local cx = player.x + (player.width / 2)
        local cy = player.y + (player.height / 2)
        local ox = playerIDL:getWidth() / 2
        local oy = playerIDL:getHeight() / 2
        local scale = 0.1
        local rot = player.angle + (player.inHand.RinPlayer or 0) + player.FireAngle

        if player.currentAnimation == "walk" then
            -- Cuerpo base 
            local diff = math.deg(player.sellingA)
            love.graphics.print(diff)
            if diff < 45 or diff > 315 then
                PlayerIM:drawIM(cx, cy, player.angle, scale, scale, ox, oy)
            elseif diff >= 45 and diff <= 135 then
                PlayerRM:drawIM(cx, cy, player.angle, scale, scale, ox, oy)
            elseif diff > 225 and diff <= 315 then
                PlayerLM:drawIM(cx, cy, player.angle, scale, scale, ox, oy)
            end

            PlayerCH:drawIM(cx, cy, rot, scale, scale, ox, oy)

        elseif player.currentAnimation == "idle" then
            -- Cuerpo base idle
            draw(playerIDF, cx, cy, rot, scale, scale, ox, oy)

            -- Solo melee en idle
            if player.melee then
                PlayerML:drawIM(cx, cy, rot, scale, scale, ox, oy)
            else
                draw(playerIDL, cx, cy, rot, scale, scale, ox, oy)
            end

        end
        -- Head
        local HeadOffset = player.inHand.HeadOffset or 0
        draw(playerHE, cx, cy, rot, scale, scale, ox, oy)
        --^^--------------------------^^ EL PROPIO JUGADOR ^^--------------------------^^--
        setColor(1, 1, 1, 1)
    end
    drawFlags()
    drawVehicles() -- Dibuja todos los vehículos
    drawBullets()
    KillPoints.draw()
    Effects[1].draw02(mud_thread)
    drawGuns(player)
    -- Dibujar balas del jugador 2
    for _, bullet in ipairs(vehicleBullets) do
        if bullet.TtoDraw then
            if bullet.TtoDraw <= 0 then
                draw(bullet.image, bullet.x, bullet.y, bullet.angle, 1, 1, bullet.image:getWidth() / 2, bullet.image:getHeight() / 2)
            end
        end
        if bullet.type == "tank" then
            draw(bossTank.bulletimage, bullet.x - 16, bullet.y - 16)
        end
    end
    drawMissiles()
    
    if vehicle.inVehicle then
        drawGuns(vehicle)
    else
        drawP2()
    end
    if player.inVehicle and not player.vehicleDriver then
        drawGuns(player)
    end
    drawIACopies()
    
    
    -- -- Dibujar el tanque jefe
    --if not bossTank.isAsleep then
    --    love.graphics.draw(bossTank.image, bossTank.x - 18, bossTank.y - 12, 0, 0.34)
    --    drawTankCannon()
    --end
    
    --Bigsmokes = Bsmoke[FF].image
    
    -- Dibujar objetos
    for _, obj in ipairs(objects) do
        draw(obj.image, obj.x, obj.y, 0, obj.width / obj.image:getWidth(), obj.height / obj.image:getHeight())
        if obj.image == Bigsmokes then
            draw(Bigsmokes, obj.x, obj.y, 0, obj.width / obj.image:getHeight(), obj.height / obj.image:getHeight())
        end
    end
    
    Effects[1].allScreenEffect()
    Explodes.draw()


    -------------------------------------------------//-------------------//------------------------------------------------------
    ----------------------------------------//------//  FIN DE LA ESCENA //----//-------------------------------------------------
    ---------------------------------------//------//-------------------//----//--------------------------------------------------
    --------------------------------------//---------------------------------//---------------------------------------------------
    for _, obstacle in ipairs(obstacles) do
        local obsX, obsY = obstacle.x, obstacle.y
        local obsW, obsH = obstacle.width, obstacle.height
        if obstacle.layer == "above" then
            draw(obstacle.image, obstacle.x, obstacle.y, 0, obstacle.scaleX, obstacle.scaleY)
        end
    end
end

-- Crear o actualizar los Canvas
if not player1Canvas then
    player1Canvas = love.graphics.newCanvas(love.graphics.getWidth() / 2, love.graphics.getHeight())
    player2Canvas = love.graphics.newCanvas(love.graphics.getWidth() / 2, love.graphics.getHeight())
end

-- Función de dibujo
function love.draw()

    if Returning then
        player1Canvas = love.graphics.newCanvas(love.graphics.getWidth() / 2, love.graphics.getHeight())
        player2Canvas = love.graphics.newCanvas(love.graphics.getWidth() / 2, love.graphics.getHeight())
        returning = false
    end

    -------------------------------------------------_______________----------------------------------------------------
    ------------------------------------------------_---------------_---------------------------------------------------
                                                  if selectedLine[5] then
    -------------------------------------------------_-------------_----------------------------------------------------
    --------------------------------------------------_____________-----------------------------------------------------

    --- Dibujar vista del Jugador 1 ---
    love.graphics.setCanvas({player1Canvas, stencil = true})
    love.graphics.clear()
    local shakeX, shakeY = 0, 0
    if camera.screenShakeAmount > 0 then
        shakeX = love.math.random(-1, 1) * camera.screenShakeAmount
        shakeY = love.math.random(-1, 1) * camera.screenShakeAmount
    end
    camera:move((player.x + (love.graphics.getWidth() / 3) + (player.width * 1.5)) - 6.5 + shakeX, player.y - 6.5 + shakeY)
    camera:set()  -- Aplicar la cámara del jugador 1
    drawScene()  -- Dibujar todo el mundo del juego
    if #Warning > 2 then polygons.drawShadeOutsidePolygon(Warning, player) end
    DebugDraw()   -- Referencia al Minecraft, y sí sirve
    updateVisibleChunks(vehicle.x - love.graphics.getWidth() / 2, vehicle.y - love.graphics.getHeight(), chunkSize)
    camera:unset()


    --- Dibujar vista del Jugador 2 ---
    love.graphics.setCanvas({player2Canvas, stencil = true})
    love.graphics.clear()
    local shakeX, shakeY = 0, 0
    if camera.screenShakeAmount > 0 then
        shakeX = love.math.random(-1, 1) * camera.screenShakeAmount
        shakeY = love.math.random(-1, 1) * camera.screenShakeAmount
    end
    camera:move(vehicle.x + love.graphics.getWidth() / 3 + shakeX, vehicle.y + shakeY)
    camera:set()  -- Aplicar la cámara del jugador 2
    drawScene()  -- Dibujar todo el mundo del juego
    if #Warning > 2 then polygons.drawShadeOutsidePolygon(Warning, vehicle) end
    DebugDraw()   -- Esto dibuja el F3 (Minecraft)
    updateVisibleChunks(player.x - love.graphics.getWidth() / 2, player.y - love.graphics.getHeight(), chunkSize)
    camera:unset()

    -- Restaurar el canvas para dibujar en la pantalla
    love.graphics.setCanvas()
    love.graphics.clear()

    -- Dibujar ambas vistas en la pantalla
    draw(player1Canvas, 0, 0)
    draw(player2Canvas, love.graphics.getWidth() / 2, 0)
    -------------------------------------------------_______________----------------------------------------------------
    ------------------------------------------------_---------------_---------------------------------------------------
                                                           else
    -------------------------------------------------_-------------_----------------------------------------------------
    --------------------------------------------------_____________-----------------------------------------------------
                                                       drawScene()
                                                           end

Effects[1].draw01(water_thread)
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
    if not selectedLine[5] then
        updateVisibleChunks(0, 0, chunkSize)
    end
    for _, flag in ipairs(Flags) do
        local name
        if debug then
            name = flag.name
        else
            name = " "
        end
        if polygons.isSquareInPolygon(player.x, player.y, player.width, player.height, flag.vertex) then
            polygons.drawFlagProgress(love.graphics.getWidth() / 4,
                                      love.graphics.getHeight() / 16,
                                      name, flag.progress)
        end
        if polygons.isSquareInPolygon(vehicle.x, vehicle.y, vehicle.width, vehicle.height, flag.vertex) then
            polygons.drawFlagProgress(love.graphics.getWidth() - (love.graphics.getWidth() / 4),
                                      love.graphics.getHeight() / 16,
                                      name, flag.progress)
        end
    end
    if AsWon then
        draw(BackGroundEndingImage, BackGroundEnding.x, BackGroundEnding.y, 0, -1)
        draw(RecoilerinEndingImage)
        draw(Pointer, mouseX, mouseY, 0, .035)
        draw(Wan, 205, 80, 0, WonScale)
    end
    love.graphics.setColor(1, 1, 1)
    if not menuActive and not AsWon then
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
        draw(LifeAmmo, 0, love.graphics.getHeight() - 50, 0, 1) 
    end
    transition.DrawTransition()
    WindowManager.draw()
    Menu()
    DegugDrawunder()
    if not selectedLine[5] then DebugDraw() end
    if not menuActive then
    love.graphics.setColor(1, 1, 1)  -- Asegurarse de que el color sea blanco para las imágenes
    if AsWon then
        drawPoints(140, 350, math.floor(player1Points), 5, 80, numbers)  -- Puntos del Jugador 1 en la esquina superior izquierda
        drawPoints(630, 350, math.floor(player2Points), 5, 80, numbers)  -- Puntos del Jugador 2 debajo del Jugador 1
    elseif not AsWon or not selectedLine[5] then
        drawPoints(10, 10, math.floor(player1Points), 1, 0, numbers)  -- Puntos del Jugador 1 en la esquina superior izquierda
        drawPoints(love.graphics.getWidth() - 90, 10, math.floor(player2Points), 1, 0, numbers)  -- Puntos del Jugador 2 debajo del Jugador 1
    elseif selectedLine[5] and not AsWon then
        drawPoints(635, 360, math.floor(player1Points), 5, 80, numbers)  -- Puntos del Jugador 1 en la esquina superior izquierda
        drawPoints(135, 360, math.floor(player2Points), 5, 80, numbers)  -- Puntos del Jugador 2 debajo del Jugador 1
    end
    draw(Point, mouseX- 4, mouseY- 4, 0, 1)
    if love.mouse.isDown(3) or love.mouse.isDown(2) then draw(HelpPoint, mouseX - 16, mouseY - 16, 0, 1) end
    else
    draw(Pointer, mouseX, mouseY, 0, .035)
    if love.mouse.isDown(1) then draw(Pointered, mouseX, mouseY, 0, .035) end
    end
end

function drawP2()
    -- Dibujar el vehículo en las coordenadas x e y del mapa
    if vehicle.death then love.graphics.setColor(.5, .75, 1, .5) end
    if vehicle.Direction == "Dwn" then
    draw(vehicle.image, vehicle.x, vehicle.y, 0, vehicle.width / vehicle.image:getWidth(), vehicle.height / vehicle.image:getWidth())
    elseif vehicle.Direction == "Der" then
    draw(vehicle.image2, vehicle.x, vehicle.y, 0, vehicle.width / vehicle.image:getWidth(), vehicle.height / vehicle.image:getWidth())
    elseif vehicle.Direction == "Up" then
    draw(vehicle.image3, vehicle.x, vehicle.y, 0, vehicle.width / vehicle.image:getWidth(), vehicle.height / vehicle.image:getWidth())
    elseif vehicle.Direction == "Izq" then
    draw(vehicle.image4, vehicle.x, vehicle.y, 0, vehicle.width / vehicle.image:getWidth(), vehicle.height / vehicle.image:getWidth())
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
    for i = #vehicles, 1, -1 do
        local vehicle = vehicles[i]
        if not vehicle.dead then

            if not vehicle.isMoving then
                if vehicle.currentSpeed > 0 then
                    vehicle.currentSpeed = vehicle.currentSpeed - (vehicle.speed / 240)
                else
                    vehicle.currentSpeed = 0
                end
            end

            -- Limitar la velocidad máxima
            if vehicle.currentSpeed > vehicle.speed then
                vehicle.currentSpeed = vehicle.speed
            elseif vehicle.currentSpeed < -vehicle.speed / 2 then
                vehicle.currentSpeed = -vehicle.speed / 2
            end

            local NEXTPX = vehicle.x + math.cos(vehicle.rotate) * vehicle.currentSpeed * dt
            local NEXTPY = vehicle.y + math.sin(vehicle.rotate) * vehicle.currentSpeed * dt

            ----------------------------------//----------------------------//---------------------------------------/
            ---------------------------------//-- Colisiones --------------//---------------------------------------/
            --------------------------------//---------- con Obstáculos --//---------------------------------------/
            -------------------------------//----------------------------//---------------------------------------/

            vehicle.RHB = polygons.getRotatedHitbox(vehicle)

            for _, obstacle in ipairs(obstacles) do
                local obs = {}
                obs.x = obstacle.x + (obstacle.width / 2)
                obs.y = obstacle.y + (obstacle.height / 2)
                obs.hw = obstacle.width / 2
                obs.hh = obstacle.height / 2
                obs.angle = 0
                local veh = {}
                veh.x = NEXTPX + (vehicle.width / 4)
                veh.y = NEXTPY + (vehicle.height / 2)
                veh.hw = (vehicle.width / 2) - 6
                veh.hh = (vehicle.height / 2) - 6
                veh.angle = vehicle.rotate
                if OBB.check(obs, veh) and not obstacle.traversable then
                    vehicle.Collides = true

                    -- Calcula la dirección del impacto (de obstáculo → vehículo)
                    local dx = veh.x - (obs.x + obs.hw)
                    local dy = veh.y - (obs.y + obs.hh)
                    local impactAngle = math.atan2(dy, dx)

                    -- Ángulo del vehículo
                    local vr = vehicle.rotate

                    -- Diferencia angular entre el choque y la dirección del vehículo
                    local diff = (impactAngle - vr + math.pi) % (2 * math.pi) - math.pi
                    vehicle.impactAngle = impactAngle

                    -- Si va marcha atrás, gira en la dirección contraria del contacto
                    if vehicle.currentSpeed < 0 then
                        -- Giro suave proporcional al ángulo de impacto
                        vehicle.rotate = vehicle.rotate + diff * -0.01
                    else
                        vehicle.currentSpeed = -vehicle.currentSpeed / 15 * dt
                        -- vehicle.rotate = vehicle.rotate + diff * 0.01
                    end

                    break
                else
                    vehicle.Collides = false
                end
            end

            ----------------------------------//----------------------------//---------------------------------------/
            ---------------------------------//------ FIN COMPROBACIÓN ----//---------------------------------------/
            --------------------------------//----------------------------//---------------------------------------/

            if not vehicle.Collides then
                vehicle.x = NEXTPX
                vehicle.y = NEXTPY
            end

            ----------------------------------//----------------------------//---------------------------------------/
            ---------------------------------//---------- OTROS -----------//---------------------------------------/
            --------------------------------//----------------------------//---------------------------------------/

            if not player.inVehicle and DD then
                print(player.inHand.name)
                player.inHand = weapons[1]
                DD = false
            end

            if vehicle.health <= 0 then
                vehicle.dead = true
                vehicle.currentSpeed = 0

                if player.vehicle == vehicle then
                    dismountVehicle(player)
                    player.death = true
                    break
                end

                for _ = 1, 4 do
                    Explodes.Explode(
                    vehicle.x + math.random(vehicle.width, 0),
                    vehicle.y + math.random(vehicle.height, 0), math.random(1, 3))
                end

                if not selectedLine[5] then
                    player.inHand = weapons[1]
                end
            end
        else
            anim.updateIM(vehicle.Dim, dt)
        end
    end
end

function handleVehicleControl(vehicle, KeyUp, KeyDown, KeyLeft, KeyRight, dt)

    -- Rotación con las teclas de izquierda/derecha
    if love.keyboard.isDown(KeyLeft) then
        vehicle.rotate = vehicle.rotate - (vehicle.currentSpeed / 240) * dt -- Gira a la izquierda
        vehicle.turning = "left"
        vehicle.isMoving = true
    elseif love.keyboard.isDown(KeyRight) then
        vehicle.rotate = vehicle.rotate + (vehicle.currentSpeed / 240) * dt -- Gira a la derecha
        vehicle.turning = "right"
        vehicle.isMoving = true
    else
        vehicle.turning = "idle"
        vehicle.isMoving = false
    end

    -- Aceleración con la tecla hacia adelante (W) y hacia atrás (S) para el P1 xd
    if love.keyboard.isDown(KeyUp) then
        vehicle.currentSpeed = vehicle.currentSpeed + vehicle.aceleration * dt -- Acelera hacia adelante
        vehicle.isMoving = true
    elseif love.keyboard.isDown(KeyDown) then
        vehicle.currentSpeed = vehicle.currentSpeed - vehicle.aceleration * dt -- Acelera hacia atrás (marcha atrás)
        vehicle.isMoving = true
    else
        vehicle.isMoving = false
    end
end

function drawVehicles()
    for i = #vehicles, 1, -1 do
        local vehiclet = vehicles[i]
        -- Cálculo de factores de escala
        local scaleX = vehiclet.width / vehiclet.image:getWidth()
        local scaleY = vehiclet.height / vehiclet.image:getHeight()
        
        -- Guardamos el estado gráfico antes de rotar y escalar
        love.graphics.push()

        -- Trasladamos el origen al centro del vehículo y aplicamos la rotación
        love.graphics.translate((vehiclet.x + vehiclet.width / 2) + vehiclet.Odx, (vehiclet.y + vehiclet.height / 2) + vehiclet.Ody)
        love.graphics.rotate(vehiclet.rotate)

        -- Dibujamos la imagen escalada y centrada en su posición
        if not vehiclet.dead then
            draw(vehiclet.image, -vehiclet.width / 2, -vehiclet.height / 2, 0, scaleX, scaleY)
        else
            anim.drawIMe(-vehiclet.width / 2, -vehiclet.height / 2, 0, scaleX, scaleY, 0, 0, vehiclet.Dim)
        end
        
        -- Restauramos el estado gráfico
        love.graphics.pop()
    end
end

function findNearestVehicle(playerX, playerY, range)
    local nearestVehicle = nil
    local minDistance = range

    for _, vehicle in ipairs(vehicles) do
        local dist = distance(playerX, playerY, vehicle.x + vehicle.height / 2, vehicle.y + vehicle.height / 2)
        if dist < minDistance then
            nearestVehicle = vehicle
            minDistance = dist
        end
    end

    return nearestVehicle
end

function mountVehicle(player, vehicle)
    for _, seat in ipairs(vehicle.seats) do
        if not seat.occupied and not player.inVehicle then
            if seat.driver then
                player.inHand = vehicle.gun
            elseif seat.gun then
                player.inHand = seat.gun
            else
                player.inHand = weapons[5]
            end
            player.inVehicle = true
            player.vehicleDriver = seat.driver
            player.vehicle = vehicle
            player.seat = seat
            seat.type = player.typeOBJ
            seat.occupied = true -- Marcar el asiento como ocupado
            break
        end
    end
end

function VehicleP1U2Control(player, KeyUp, KeyDown, KeyLeft, KeyRight, dt)
    -- Mantener al jugador en el asiento mientras el vehículo se mueve
    if player.vehicle.rotate >= 6.3 then
        player.vehicle.rotate = player.vehicle.rotate - 6.3
    end
    for _, seat in ipairs(player.vehicle.seats) do
        if seat.occupied and player.typeOBJ == seat.type then
            local seatX, seatY = seat.x, seat.y
            player.x = seatX + player.vehicle.x   -- Esto es muy redundante xd, pero un tuto dice que es más bonito
            player.y = seatY + player.vehicle.y
        end
    end

    -- Control del vehículo
    if player.vehicleDriver and player.Playing then
        handleVehicleControl(player.vehicle, KeyUp, KeyDown, KeyLeft, KeyRight, dt)
    end
end

function VehicleUpDownUpdate(player, KeyUp, KeyDown, KeyLeft, KeyRight, keysight, key, dt)
        if not player.inVehicle then
            if love.keyboard.isDown(key) then
                local nearestVehicle = findNearestVehicle(player.x, player.y, 100) -- rango de 100 píxeles
                if nearestVehicle and not player.death and not nearestVehicle.dead then
                    mountVehicle(player, nearestVehicle)
                end
            end
        else
        VehicleP1U2Control(player, KeyUp, KeyDown, KeyLeft, KeyRight, dt)

        -- Desmontar el vehículo
        if love.keyboard.isDown(keysight) then
            dismountVehicle(player)
        end
    end
end 

function dismountVehicle(player)
    local vehicle = player.vehicle
    if not player.seat or not vehicle then return end

    local vSize = vehicle.height
    local px, py = player.width, player.height

    local positions = {
        { (vehicle.x - px) - 1, vehicle.y + vSize / 3},             -- izquierda
        { (vehicle.x + vSize + px) + 1, vehicle.y + vSize / 3 },     -- derecha
        { vehicle.x + vSize / 3, (vehicle.y - py) + 1},             -- arriba
        { vehicle.x + vSize / 3, (vehicle.y + vSize + py) - 1}      -- abajo
    }

    for _, pos in ipairs(positions) do
        if not checkCollision(pos[1], pos[2], px, py) then
            player.inVehicle = false
            player.vehicleDriver = false
            player.seat.occupied = false
            player.inHand = weapons[1]
            player.vehicle = nil
            player.x, player.y = pos[1], pos[2]
            break
        end
    end
end