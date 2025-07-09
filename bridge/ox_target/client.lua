if not Config.ReplaceOxTarget then return end

if GetResourceState('ox_target') == 'started' then
    print('^1 oxtarget is running, stopping ox_target...^0')
    lib.callback.await('mri_Qinteract:Server:StopTarget', false)
    print('^2 ox_target stopped successfully!^0')
end

local function exportHandler(exportName, func)
    print(exportName, func)
    AddEventHandler(('__cfx_export_ox_target_%s'):format(exportName), function(setCB)
        setCB(func)
    end)
end

local function parseGroups(groups)
    if not groups then return nil end
    local out = {}
    for k, v in pairs(groups) do
        out[k] = tonumber(v) or 0
    end
    return out
end

local function convertOptions(options)
    local out = {}

    for _, opt in ipairs(options) do
        local o = {
            label = opt.label or opt.name or 'Interact',
            icon = opt.icon,
            items = opt.items,
            canInteract = opt.canInteract,
            groups = opt.groups,
            job = opt.job,
            jobGrade = opt.jobGrade,
            name = opt.name,
            id = opt.id,
            distance = opt.distance,
            interactDst = opt.interactDst,
        }

        o.action = function(entity, coords, _args)
            if opt.canInteract and not opt.canInteract(entity, coords, _args) then
                return
            end

            if opt.onSelect then
                opt.onSelect({
                    entity = entity,
                    coords = coords,
                    icon = opt.icon,
                    name = opt.name,
                    zone = opt.zone,
                    serverId = NetworkGetPlayerIndexFromPed(entity),
                    items = opt.items,
                    groups = opt.groups,
                    job = opt.job,
                    jobGrade = opt.jobGrade,
                })
            end
        end

        table.insert(out, o)
    end

    return out
end

local Interact = exports.interact

local function addBoxZone(name, center, length, width, options, targetOptions)
    Interact:AddInteraction({
        coords = vector3(center.x, center.y, center.z),
        distance = targetOptions.distance or 2.0,
        interactDst = targetOptions.interactDst or 1.5,
        id = name,
        name = name,
        groups = parseGroups(targetOptions.groups),
        options = convertOptions(targetOptions.options or { targetOptions }),
    })
end

exports('addBoxZone', addBoxZone)
exportHandler('addBoxZone', addBoxZone)

local function addSphereZone(name, center, radius, options, targetOptions)
    Interact:AddInteraction({
        coords = vector3(center.x, center.y, center.z),
        distance = radius or targetOptions.distance or 2.0,
        interactDst = targetOptions.interactDst or 1.5,
        id = name,
        name = name,
        groups = parseGroups(targetOptions.groups),
        options = convertOptions(targetOptions.options or { targetOptions }),
    })
end

exports('addSphereZone', addSphereZone)
exportHandler('addSphereZone', addSphereZone)

local function addEntity(entities, targetOptions)
    for _, entity in ipairs(type(entities) == 'table' and entities or { entities }) do
        if NetworkGetEntityIsNetworked(entity) then
            Interact:AddEntityInteraction({
                netId = NetworkGetNetworkIdFromEntity(entity),
                id = targetOptions.id or ('ox:' .. entity),
                name = targetOptions.name or ('ox:' .. entity),
                distance = targetOptions.distance or 2.0,
                interactDst = targetOptions.interactDst or 1.5,
                bone = targetOptions.bone,
                offset = targetOptions.offset or vec3(0.0, 0.0, 0.0),
                groups = parseGroups(targetOptions.groups),
                options = convertOptions(targetOptions.options or { targetOptions }),
            })
        else
            Interact:AddLocalEntityInteraction({
                entity = entity,
                id = targetOptions.id or ('ox:' .. entity),
                name = targetOptions.name or ('ox:' .. entity),
                distance = targetOptions.distance or 2.0,
                interactDst = targetOptions.interactDst or 1.5,
                bone = targetOptions.bone,
                offset = targetOptions.offset or vec3(0.0, 0.0, 0.0),
                groups = parseGroups(targetOptions.groups),
                options = convertOptions(targetOptions.options or { targetOptions }),
            })
        end
    end
end

exports('addEntity', addEntity)
exportHandler('addEntity', addEntity)

local function addModel(models, targetOptions)
    for _, model in ipairs(type(models) == 'table' and models or { models }) do
        Interact:AddModelInteraction({
            model = model,
            id = targetOptions.id or ('ox:' .. model),
            name = targetOptions.name or ('ox:' .. model),
            bone = targetOptions.bone,
            offset = targetOptions.offset or vec3(0.0, 0.0, 0.0),
            distance = targetOptions.distance or 2.0,
            interactDst = targetOptions.interactDst or 1.5,
            groups = parseGroups(targetOptions.groups),
            options = convertOptions(targetOptions.options or { targetOptions }),
        })
    end
end

exports('addModel', addModel)
exportHandler('addModel', addModel)

local function addGlobalVehicle(targetOptions)
    Interact:AddGlobalVehicleInteraction({
        id = targetOptions.id or 'ox:globalVehicle',
        name = targetOptions.name,
        bone = targetOptions.bone,
        offset = targetOptions.offset or vec3(0.0, 0.0, 0.0),
        distance = targetOptions.distance or 4.0,
        interactDst = targetOptions.interactDst or 2.0,
        groups = parseGroups(targetOptions.groups),
        options = convertOptions(targetOptions.options or { targetOptions }),
    })
end

exports('addGlobalVehicle', addGlobalVehicle)
exportHandler('addGlobalVehicle', addGlobalVehicle)

local function addGlobalPlayer(targetOptions)
    Interact:AddGlobalPlayerInteraction({
        id = targetOptions.id or 'ox:globalPlayer',
        offset = targetOptions.offset or vec3(0.0, 0.0, 0.0),
        distance = targetOptions.distance or 3.0,
        interactDst = targetOptions.interactDst or 1.5,
        groups = parseGroups(targetOptions.groups),
        options = convertOptions(targetOptions.options or { targetOptions }),
    })
end

exports('addGlobalPlayer', addGlobalPlayer)
exportHandler('addGlobalPlayer', addGlobalPlayer)

local function removeZone(id)
    Interact:RemoveInteraction(id)
end

exports('removeZone', removeZone)
exportHandler('removeZone', removeZone)

local function removeEntity(entity, id)
    if NetworkGetEntityIsNetworked(entity) then
        Interact:RemoveEntityInteraction(NetworkGetNetworkIdFromEntity(entity), id)
    else
        Interact:RemoveLocalEntityInteraction(entity, id)
    end
end

exports('removeEntity', removeEntity)
exportHandler('removeEntity', removeEntity)

local function removeModel(model, id)
    Interact:RemoveModelInteraction(model, id)
end

exports('removeModel', removeModel)
exportHandler('removeModel', removeModel)

local function removeGlobalVehicle(id)
    Interact:RemoveGlobalVehicleInteraction(id)
end

exports('removeGlobalVehicle', removeGlobalVehicle)
exportHandler('removeGlobalVehicle', removeGlobalVehicle)

local function removeGlobalPlayer(id)
    Interact:RemoveGlobalPlayerInteraction(id)
end

exports('removeGlobalPlayer', removeGlobalPlayer)
exportHandler('removeGlobalPlayer', removeGlobalPlayer)
