local WindowManager = {}

WindowManager.windows = {}
WindowManager.current = nil

-- Crear una nueva ventana
function WindowManager.createWindow(name, x, y, width, height)
    WindowManager.windows[name] = {
        x = x,
        y = y,
        width = width,
        height = height,
        buttons = {},
        images = {},
        visible = false
    }
end

-- Agregar un botón a una ventana
function WindowManager.addButton(windowName, text, x, y, width, height, onClick)
    local window = WindowManager.windows[windowName]
    if window then
        table.insert(window.buttons, {
            text = text,
            x = x,
            y = y,
            width = width,
            height = height,
            onClick = onClick
        })
    end
end

-- Agregar una imagen con medidas fijas a una ventana
function WindowManager.addImage(windowName, image, x, y, width, height)
    local window = WindowManager.windows[windowName]
    if window then
        table.insert(window.images, {
            image = image,
            x = x,
            y = y,
            width = width,
            height = height
        })
    end
end

-- Mostrar una ventana
function WindowManager.openWindow(name)
    for otherName, window in pairs(WindowManager.windows) do
        if otherName ~= name then
            window.visible = false
        end
    end

    local window = WindowManager.windows[name]
    if window then
        if window.visible then
            window.visible = false
            WindowManager.current = nil
        else
            window.visible = true
            WindowManager.current = name
        end
    end
end

-- Ocultar todas las ventanas
function WindowManager.closeAll()
    for _, window in pairs(WindowManager.windows) do
        window.visible = false
    end
    WindowManager.current = nil
end

-- Borrar una ventana específica
function WindowManager.removeWindow(name)
    if WindowManager.windows[name] then
        WindowManager.windows[name] = nil
        if WindowManager.current == name then
            WindowManager.current = nil
        end
    end
end

-- Modificar propiedades de una ventana existente
-- params = { x = ..., y = ..., width = ..., height = ... }
-- puse lo de arriba para que samder no se queje
function WindowManager.updateWindow(name, params)
    local window = WindowManager.windows[name]
    if window then
        for key, value in pairs(params) do
            if key == "x" or key == "y" or key == "width" or key == "height" then
                window[key] = value
            end
        end
    end
end

-- Dibujar ventana activa
function WindowManager.draw()
    for _, window in pairs(WindowManager.windows) do
        if window.visible then
            -- Fondo de ventana
            love.graphics.setColor(0.1, 0.1, 0.1, 0.9)
            love.graphics.rectangle("fill", window.x, window.y, window.width, window.height, 8, 8)
            love.graphics.setColor(1, 1, 1)

            -- Imágenes
            for _, img in ipairs(window.images) do
                love.graphics.draw(img.image, window.x + img.x, window.y + img.y, 0,
                    img.width / img.image:getWidth(),
                    img.height / img.image:getHeight())
            end

            -- Botones
            for _, btn in ipairs(window.buttons) do
                love.graphics.setColor(.95, .95, .95)
                love.graphics.circle("fill", window.x + btn.x + (btn.width / 2), window.y + btn.y + (btn.height / 2), btn.width / 2)
                love.graphics.setColor(.8, .8, .8)
                love.graphics.circle("line", window.x + btn.x + (btn.width / 2), window.y + btn.y + (btn.height / 2), btn.width / 2)
                love.graphics.setColor(.75, .75, .9)
                love.graphics.circle("fill", window.x + btn.x + (btn.width - (btn.width / 4)), window.y + btn.y + (btn.height / 4), btn.width / 4)
                love.graphics.setColor(0, 0, 0)
                love.graphics.printf(btn.text, window.x + btn.x, window.y + btn.y + btn.height, btn.width, "center")
                love.graphics.setColor(1, 1, 1)
                love.graphics.printf(btn.text, window.x + btn.x + 1, window.y + btn.y + btn.height + 1, btn.width, "center")
            end
        end
    end
end

-- Detectar clicks
function WindowManager.mousepressed(x, y, button)
    if button == 1 and WindowManager.current then
        local window = WindowManager.windows[WindowManager.current]
        if window and window.visible then
            for _, btn in ipairs(window.buttons) do
                local bx = window.x + btn.x
                local by = window.y + btn.y
                if x >= bx and x <= bx + btn.width and y >= by and y <= by + btn.height then
                    if btn.onClick then
                        btn.onClick()
                    end
                end
            end
        end
    end
end

return WindowManager