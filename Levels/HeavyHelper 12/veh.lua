local vehicles = {}

vehicles.name = 12

vehicles.All = {
    {
        x = -720,
        y = -200,
        speed = 145,
        width = 280,
        height = 120,
        health = 1650,
        rotate = 0,
        image = love.graphics.newImage("Objetos/Vehicles/Tank_Boddy_Inverted.png"),
        aceleration = 75,
        currentSpeed = 0, -- Velocidad actual del vehículo
        isMoving = false,
        Odx = -66,
        Ody = 4,
        gun = {
            name = "tank cannon",
            damage = 180,
            fireRate = .45,
            Ox = 250,
            Oy = 220,
            Os = .325,
            Odx = -48,
            Ody = -46,
            bulletSpeed = 1000,
            BulletDx = 12,
            BulletDy = 12,
            ["Offx"] = 145,
            ["Offy"] = 0,
            ammo = 60,
            maxAmmo = 60,
            dispersion = .015,
            chargers = 2,
            Maxchargers = 2,
            pos = 2,
            ActivationTimer = 0,
            texture = love.graphics.newImage("Objetos/Vehicles/Tank_Head.png"),
            HUD = love.graphics.newImage("HUD/InGame/Guns/default.png"),
            bala = love.graphics.newImage("textures/armas/Bala6.png"),
            auto = true,
            timer = 100,
            OnDestroyBullet = function(x, y, player)
                createBullet(x, y, math.cos(315), nil, .1, 0, 5, function()end, -8, -8)
                createBullet(x, y, math.cos(270), nil, .1, 0, 5, function()end, -8, -8)
                createBullet(x, y, math.cos(225), nil, .1, 0, 5, function()end, -8, 8)
                createBullet(x, y, math.cos(180), nil, .1, 0, 5, function()end, -8, 8)
                createBullet(x, y, math.cos(135), nil, .1, 0, 5, function()end, 8, -8)
                createBullet(x, y, math.cos(90), nil, .1, 0, 5, function()end, 8, -8)
                createBullet(x, y, math.cos(45), nil, .1, 0, 5, function()end, 8, 8)
                createBullet(x, y, math.cos(0), nil, .1, 0, 5, function()end, 8, 8)
            end
        },
        seats = {
            {x = 50, y = 50, occupied = false},
            {x = 0, y = 0, occupied = false}
        },
    }
}

return vehicles