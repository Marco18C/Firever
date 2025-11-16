function cargarImagenesArmas(directorio)
    local imagenes = {}

    -- Obtener la lista de archivos en el directorio
    local archivos = love.filesystem.getDirectoryItems(directorio)

    for _, archivo in ipairs(archivos) do
        -- Verificar que el archivo termine en .png, .jpg o .jpeg (evita cargar archivos no válidos)
        if archivo:match("%.png$") or archivo:match("%.jpg$") or archivo:match("%.jpeg$") then
            -- Obtener el nombre sin la extensión
            local nombre = archivo:match("(.+)%..+$")

            -- Cargar la imagen y guardarla en la tabla con su nombre
            imagenes[nombre] = love.graphics.newImage(directorio .. "/" .. archivo)
        end
    end

    return imagenes
end

return cargarImagenesArmas