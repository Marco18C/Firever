local forms = {"black H",
               "black V",
               "blue and black H",
               "blue H",
               "blue V",
               "yellow H",
               "yellow V",
               "enginee"}
local LForms = {}
local Time = 0
local SpeedT = .5
local transition = {}
transition.Epoints = {BkH = 0,
                 BkV = 0,
                 BlaBk = 0,
                 BlH = 0,
                 BlV = 0,
                 YwH = 0,
                 YwV = 0,
                 EnR = 0}
for _, form in ipairs(forms) do
    LForms[form] = love.graphics.newImage("HUD/NoGame/Transition forms/" .. form .. ".png")
end

function transition.update(dt)
    local dtS = dt * SpeedT
    transition.Epoints.BlH = transition.Epoints.BlH + 80 * dtS
    transition.Epoints.BkH = transition.Epoints.BkH + 130 * dtS
    transition.Epoints.YwH = transition.Epoints.YwH + 20 * dtS
    transition.Epoints.YwV = transition.Epoints.YwV + 30 * dtS
    transition.Epoints.BkV = transition.Epoints.BkV + 30 * dtS
    transition.Epoints.BlV = transition.Epoints.BlV + 20 * dtS
    transition.Epoints.BlaBk = transition.Epoints.BlaBk + 10 * dtS
    transition.Epoints.EnR = transition.Epoints.EnR + math.rad(250) * dt

    Time = Time + dt
    if Time >= .75 then
        SpeedT = 38
    end
end

function transition.reset()
    Time = 0
    SpeedT = .5
    transition.Epoints.BlH = 0
    transition.Epoints.BkH = 0
    transition.Epoints.YwV = 0
    transition.Epoints.YwH = 0
    transition.Epoints.BkV = 0
    transition.Epoints.BlV = 0
    transition.Epoints.EnR = 0
    transition.Epoints.BlaBk = 0
end

function transition.DrawTransition()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()

    local function draw(name, x, y, s)
        local WSS = s or 1
        love.graphics.draw(LForms[name], x, y, 0, WindowSize * WSS)
    end

    draw("black H", 0 - transition.Epoints.BkH, 0, 2)
    draw("blue H", 0 - transition.Epoints.BlH, LForms["black H"]:getHeight() * WindowSize * 2, 2)

    draw("blue and black H", 0, h + transition.Epoints.BlaBk - LForms["blue and black H"]:getHeight() * WindowSize)
    draw("yellow V", 0, h - LForms["yellow V"]:getHeight() + transition.Epoints.YwV * WindowSize)

    draw("black V", w - LForms["black V"]:getWidth() * 2 * WindowSize, 0 - transition.Epoints.BkV, 2)
    draw("blue V", w - LForms["blue V"]:getWidth() - (LForms["black V"]:getWidth() * 2) * WindowSize, 0 - transition.Epoints.BlV)

    draw("yellow H", 
         w + transition.Epoints.YwH - LForms["yellow H"]:getWidth() * .5 * WindowSize,
         h + transition.Epoints.BlaBk - LForms["blue and black H"]:getHeight() * WindowSize - LForms["yellow H"]:getHeight() * .5 * WindowSize,
         .5)

    love.graphics.setColor(0, 0, 0, .45)
    drawPoints(635 + transition.Epoints.BkH, 360 + transition.Epoints.BkH, math.floor(player1Points), 5, 80, Anumbers)
    drawPoints(135 - transition.Epoints.BkH, 360 - transition.Epoints.BkH, math.floor(player2Points), 5, 80, Anumbers)
    
    love.graphics.setColor(1, .85, 0, 1)
    drawPoints(635 + 12 + transition.Epoints.BkH, 360 + 20 + transition.Epoints.BkH, math.floor(player1Points), 5, 80, Anumbers)
    drawPoints(135 + 12 - transition.Epoints.BkH, 360 + 18 - transition.Epoints.BkH, math.floor(player2Points), 5, 80, Anumbers)

    local R = transition.Epoints.EnR
    love.graphics.setColor(.1, .1, .1, 1 - R / 8)
    love.graphics.draw(LForms.enginee, w, 0, R, 1, 1, 170, 190)
    
    love.graphics.setColor(.8, .7, .1, 2 - R / 8)
    love.graphics.draw(LForms.enginee, w, 0, R, 1, 1, 230, 190)
    
    love.graphics.setColor(1, 1, 1, 1)
end

return transition