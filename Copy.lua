function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for k, v in pairs(orig) do
            copy[k] = deepcopy(v) -- Copia recursiva
        end
    else
        copy = orig
    end
    return copy
end

return deepcopy