# Arquitetura Profissional no Roblox Studio

Este arquivo define **como estruturar projetos que escalam**.

---

## Camadas

### Server

* Autoridade total
* Economia, inventário, dados

### Client

* UI
* Input
* Predição

### Shared

* Tipos
* Constantes
* Configurações

---

## Padrão Services & Controllers

### Service

* Sem UI
* Sem input
* Apenas lógica

### Controller

* Orquestra Services
* Comunicação via Remotes

---

## Fluxo correto

Client → Intent → Server valida → Server executa → Server replica estado

---

## Exemplo

```lua
-- InventoryService
function AddItem(player, itemId)
	-- valida
end
```

---

## State Machines

Recomendado para:

* Combate
* Jobs
* NPCs

---

## MMO Pattern

* Uma Place ≠ um mundo
* Mundo = várias Places
* Teleport + MemoryStore

---

Arquitetura ruim não escala. Simples assim.
