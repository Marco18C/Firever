local Events = {}
local directions = {
                    math.rad(220),
                    math.rad(280),
                    math.rad(256),
                    math.rad(248),
                    math.rad(180),
                    math.rad(225),
                    math.rad(270),
                    math.rad(235),
                }
local imagefromFire = love.graphics.newImage("textures/armas/Bala6.png")
local imagefromM249 = love.graphics.newImage("Objetos/Objects/GunsObj/M249.png")

Events.name = "DryingFreeLand 07"

Events.All = {
    weather = true,
    objects = {
        {
            x = 380,
            y = 633,
            width = 58,
            height = 44,
            onTouch = 
                function(obj, Toucher)
                    createObject(
                    obj.x,
                    obj.y,
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
                    for _, angle in ipairs(directions) do
                        triggerScreenShake(camera ,player.inHand.shake)
                        createBullet(obj.x, obj.y, angle, nil, .4, 0, 5,function(x, y, player)
                            for _, angle in ipairs(directions) do
                                triggerScreenShake(camera ,player.inHand.shake)
                                createBullet(obj.x, obj.y, angle, nil, .4, 0, 5,
                                function()end, 0, 0, imagefromFire, 50)
                            end
                        end, 0, 0, imagefromFire, 50)
                        -- Crear la bala con la dirección dispersa
                        local bullet = {
                            x = obj.x,
                            y = obj.y,
                            r = 5,
                            time = .1,
                            TtoDraw = 0,
                            damage = 70,
                            image = imagefromFire,
                            angle = angle or 0,
                            type = "default",
                            team = 2,
                            dx = angle * math.random(-1, 1),
                            dy = angle * math.random(-1, 1),
                        }

                        table.insert(vehicleBullets, bullet)
                    end
                    obj.isActive = false
                end,
            isTouched = false,
            isActive = true,
            image = love.graphics.newImage("textures/obstacle/Oman_gas.png"),
            collisionable = true,
            lifeTime = 100000^128,  -- Tiempo en segundos antes de desaparecer (por defecto 10 segundos)
            timer = 0,  -- Temporizador para el tiempo de vida
            caller = function()end
        },
        {
            x = 0,
            y = 162,
            width = 15,
            height = 50,
            onTouch = 
                function(obj, Toucher)
                Toucher.inHand = deepCopy(gun[11])
                obj.isActive = false
                end,
            isTouched = false,
            isActive = true,
            image = imagefromM249,
            collisionable = true,
            lifeTime = 100000^128,  -- Tiempo en segundos antes de desaparecer (por defecto 10 segundos)
            timer = 0,  -- Temporizador para el tiempo de vida
            caller = function()end
        }
    }
}

return Events