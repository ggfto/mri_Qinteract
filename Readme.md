# World Interactions
Crie interações no mundo com opções selecionáveis

# Créditos
[ChatDisabled](https://github.com/Chatdisabled)

[Devyn](https://github.com/darktrovx)

[Zoo](https://github.com/FjamZoo)

[Snipe](https://github.com/pushkart2)

# Guias e Demos (inglês)

[Video Demo 1](https://youtu.be/dQ7Pdq1pdHQ)
[Video Demo 2](https://youtu.be/9ZLK0kl2k94)

Necessário [ox_lib](https://github.com/overextended/ox_lib)

Opções de Interação
```
Functions
Client Events
Server Events
```

# Compatibilidade com ox\_target

Este recurso fornece uma camada de compatibilidade para substituir completamente o `ox_target` usando o sistema `interact`, **sem precisar modificar scripts existentes**. Ele intercepta chamadas de export do `ox_target` e redireciona para o sistema `exports.interact`, garantindo compatibilidade com todas as funcionalidades essenciais.

## Métodos implementados

| Método                | Implementado? | Observações  |
| --------------------- | ------------- | ------------ |
| `addGlobalPlayer`     | ✅             | Implementado |
| `removeGlobalPlayer`  | ✅             | Implementado |
| `addGlobalVehicle`    | ✅             | Implementado |
| `removeGlobalVehicle` | ✅             | Implementado |
| `addModel`            | ✅             | Implementado |
| `removeModel`         | ✅             | Implementado |
| `addEntity`           | ✅             | Implementado |
| `removeEntity`        | ✅             | Implementado |
| `addSphereZone`       | ✅             | Implementado |
| `addBoxZone`          | ✅             | Implementado |
| `removeZone`          | ✅             | Implementado |

## Métodos ainda não implementados

| Método               | Requer implementação? | Como adaptar                                   |
| -------------------- | --------------------- | ---------------------------------------------- |
| `addGlobalOption`    | ✅ Sim                 | Adicionar interação global com base no jogador |
| `removeGlobalOption` | ✅ Sim                 | Remover por `id` genérico                      |
| `addGlobalObject`    | ✅ Sim                 | Mapear como `addModel` ou `addEntity`          |
| `removeGlobalObject` | ✅ Sim                 | Igual a `removeModel`/`removeEntity`           |
| `addGlobalPed`       | ✅ Sim                 | Usar `addEntity` com checagem de tipo          |
| `removeGlobalPed`    | ✅ Sim                 | Igual a `removeEntity`                         |
| `addPolyZone`        | ⚠️ Talvez             | Adaptar para centro e raio aproximado          |

---

# Formato das opções

```lua
 {
    label = 'Hello World!',
    canInteract = function(entity, coords, args)
        return true
    end,
    action = function(entity, coords, args)
        print(entity, coords, json.encode(args))
    end,
    serverEvent = "server:Event",
    event = "client:Event",
    args = {
        value1 = 'foo',
        [2] = 'bar',
        ['three'] = 0,
    }
 }

```

# Exports
```lua
-- Add an interaction point at a set of coords
exports.interact:AddInteraction({
    coords = vec3(0.0, 0.0, 0.0),
    distance = 8.0, -- optional
    interactDst = 1.0, -- optional
    id = 'myCoolUniqueId', -- needed for removing interactions
    name = 'interactionName', -- optional
    groups = {
        ['police'] = 2, -- Jobname | Job grade
    },
    options = {
         {
            label = 'Hello World!',
            action = function(entity, coords, args)
                print(entity, coords, json.encode(args))
            end,
        },
    }
})

exports.interact:AddLocalEntityInteraction({
    entity = entityIdHere,
    name = 'interactionName', -- optional
    id = 'myCoolUniqueId', -- needed for removing interactions
    distance = 8.0, -- optional
    interactDst = 1.0, -- optional
    ignoreLos = false, -- optional ignores line of sight
    offset = vec3(0.0, 0.0, 0.0), -- optional
    bone = 'engine', -- optional
    groups = {
        ['police'] = 2, -- Jobname | Job grade
    },
    options = {
        {
            label = 'Hello World!',
            action = function(entity, coords, args)
                print(entity, coords, json.encode(args))
            end,
        },
    }
})

-- Add an interaction point on a networked entity
exports.interact:AddEntityInteraction({
    netId = entityNetIdHere,
    name = 'interactionName', -- optional
    id = 'myCoolUniqueId', -- needed for removing interactions
    distance = 8.0, -- optional
    interactDst = 1.0, -- optional
    ignoreLos = false, -- optional ignores line of sight
    offset = vec3(0.0, 0.0, 0.0), -- optional
    bone = 'engine', -- optional
    groups = {
        ['police'] = 2, -- Jobname | Job grade
    },
    options = {
        {
            label = 'Hello World!',
            action = function(entity, coords, args)
                print(entity, coords, json.encode(args))
            end,
        },
    }
})

exports.interact:AddGlobalVehicleInteraction({
    name = 'interactionName', -- optional
    id = 'myCoolUniqueId', -- needed for removing interactions
    distance = 8.0, -- optional
    interactDst = 1.0, -- optional
    offset = vec3(0.0, 0.0, 0.0), -- optional
    bone = 'engine', -- optional
    groups = {
        ['police'] = 2, -- Jobname | Job grade
    },
    options = {
        {
            label = 'Hello World!',
            action = function(entity, coords, args)
                print(entity, coords, json.encode(args))
            end,
        },
    }
})


-- Add interaction(s) to a list of models
exports.interact:AddModelInteraction({
    model = 'modelName',
    offset = vec3(0.0, 0.0, 0.0), -- optional
    bone = 'engine', -- optional
    name = 'interactionName', -- optional
    id = 'myCoolUniqueId', -- needed for removing interactions
    distance = 8.0, -- optional
    interactDst = 1.0, -- optional
    groups = {
        ['police'] = 2, -- Jobname | Job grade
    },
    options = {
        {
            label = 'Hello World!',
            action = function(entity, coords, args)
                print(entity, coords, json.encode(args))
            end,
        },
    }
})


-- Add Interaction(s) to players

exports.interact:addGlobalPlayerInteraction({
    distance = 5.0,
    interactDst = 1.5,
    offset = vec3(0.0, 0.0, 0.0),
    id = 'interact:actionPlayer',
    options = {
        name = 'interact:actionPlayer',
        label = 'Do Action On Player',
        action = function(entity, _, _, serverId)
            print(entity, serverId)
        end,
    }
})

---@param id number : The id of the interaction to remove
-- Remove an interaction point by id.
exports.interact:RemoveInteraction(interactionID)

---@param entity number : The entity to remove the interaction from
---@param id number : The id of the interaction to remove
-- Remove an interaction point from a local entity by id.
exports.interact:RemoveLocalEntityInteraction(entity, interactionID)

---@param netId number : The network id of the entity to remove the interaction from
---@param id number : The id of the interaction to remove
-- Remove an interaction point from a networked entity by id.
exports.interact:RemoveModelInteraction(model, interactionID)

---@param model number : The model to remove the interaction from
---@param id number : The id of the interaction to remove
-- Remove an interaction point from a model by id.
exports.interact:RemoveEntityInteraction(netId, interactionID)

---@param id number : The id of the interaction to remove
-- Remove an interaction point by id.
exports.interact:RemoveGlobalVehicleInteraction(interactionID)

---@param id number : The id of the interaction to remove
-- Remove an player interaction by id.
exports.interact:RemoveGlobalPlayerInteraction(interactionID)
```
