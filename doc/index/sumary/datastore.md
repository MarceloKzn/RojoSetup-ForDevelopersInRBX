# Data Persistence no Roblox — DataStore & MemoryStore

Este arquivo cobre **persistência profissional de dados** no Roblox. Se você errar aqui, seu jogo quebra em escala.

---

## Visão geral

Roblox oferece **dois sistemas distintos**:

* **DataStoreService** → persistência longa (dados salvos)
* **MemoryStoreService** → dados temporários entre servidores (rápido, volátil)

Eles **não competem**, eles **se complementam**.

---

## DataStoreService

### Quando usar

* Inventário
* Economia
* Progresso
* Configurações do jogador

### Quando NÃO usar

* Dados que mudam a cada frame
* Sincronização em tempo real
* Locks distribuídos

---

## Regras críticas

* Sempre usar `pcall`
* Sempre implementar retry com backoff
* Nunca salvar em loop apertado
* Nunca confiar em dados do client

---

## Padrão de salvamento seguro

```lua
--!strict
local DataStoreService = game:GetService("DataStoreService")
local Store = DataStoreService:GetDataStore("PlayerDataV1")

local function save(userId: number, data: table)
	for attempt = 1, 5 do
		local ok, err = pcall(function()
			Store:SetAsync(tostring(userId), data)
		end)
		if ok then return true end
		task.wait(2 ^ attempt)
	end
	return false
end
```

---

## Load seguro com defaults

```lua
local DEFAULT = {Gold = 0, Level = 1}

local function load(userId)
	local ok, result = pcall(function()
		return Store:GetAsync(tostring(userId))
	end)
	if ok and result then
		return result
	end
	return table.clone(DEFAULT)
end
```

---

## Autosave

* Intervalo recomendado: 60–120s
* Salvar no `PlayerRemoving`
* Salvar no `BindToClose`

Nunca dependa só de um deles.

---

## MemoryStoreService

### Para que serve

* Locks distribuídos
* Matchmaking
* Filas
* Leaderboards temporários

### NÃO é persistente

Tudo some em minutos.

---

## Lock distribuído (exemplo)

```lua
local MemoryStore = game:GetService("MemoryStoreService")
local map = MemoryStore:GetSortedMap("ProfileLocks")

local function acquireLock(userId)
	local success = pcall(function()
		map:SetAsync(tostring(userId), true, 30)
	end)
	return success
end
```

---

## Profile Pattern (resumo)

* Um jogador = um profile
* Lock antes de carregar
* Unlock ao sair
* Merge seguro

Use ProfileService se possível.

---

Persistência mal feita destrói jogos. Sem exceção.
