# Exemplos Completos — Sistemas Reais

Este arquivo mostra **como tudo se conecta**.

---

## Inventário escalável

### Estrutura

* InventoryService (server)
* InventoryController (server)
* InventoryUI (client)

### Service

```lua
--!strict
local InventoryService = {}

function InventoryService:AddItem(player, itemId)
	-- validar
end

return InventoryService
```

---

## JobManager (RPG)

### Conceito

* Jobs como estados
* XP por ação

```lua
function JobManager:GainXP(player, job, amount)
	-- valida e aplica
end
```

---

## Economia

* Server decide tudo
* Client só exibe

```lua
function EconomyService:AddGold(player, amount)
	-- server only
end
```

---

## MMO por Places

### Arquitetura

* Cada zona = Place
* TeleportService
* MemoryStore

### Benefícios

* Escala
* Menos lag

---

## Fluxo correto

Client → Intent → Server → Replica

---

Exemplos simples, arquitetura sólida.
