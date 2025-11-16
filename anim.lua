Animation = {}
Animation.__index = Animation

function Animation:newIM(image, frameWidth, frameHeight, frameDuration, repetitive)
    local anim = {
        image = image,
        frameWidth = frameWidth,
        frameHeight = frameHeight,
        frameDuration = frameDuration,
        repetitive = repetitive,
        currentTime = 0,
        currentFrame = 1,
        frames = {}
    }

    local imageWidth = image:getWidth()
    local imageHeight = image:getHeight()

    for y = 0, imageHeight - frameHeight, frameHeight do
        for x = 0, imageWidth - frameWidth, frameWidth do
            table.insert(anim.frames, love.graphics.newQuad(x, y, frameWidth, frameHeight, imageWidth, imageHeight))
        end
    end

    setmetatable(anim, Animation)
    return anim
end

function Animation.updateIM(a, dt)
    a.currentTime = a.currentTime + dt
    while a.currentTime >= a.frameDuration do
        a.currentTime = a.currentTime - a.frameDuration
        if a.repetitive then
            a.currentFrame = a.currentFrame % #a.frames + 1
        else
            a.currentFrame = math.min(a.currentFrame + 1, #a.frames)
        end
    end
end

function Animation:drawIM(x, y, r, sx, sy, ox, oy)
    love.graphics.draw(self.image, self.frames[self.currentFrame], x, y, r, sx, sy, ox, oy)
end

function Animation.drawIMe(x, y, r, sx, sy, ox, oy, d)
    love.graphics.draw(d.image, d.frames[d.currentFrame], x, y, r, sx, sy, ox, oy)
end

function Animation:obtainFrame()
    return self.currentFrame
end

function Animation:SetFramerate(frameDuration)
    self.frameDuration = frameDuration
end

function Animation:SetFrame(frame)
    self.currentFrame = frame
end

return Animation