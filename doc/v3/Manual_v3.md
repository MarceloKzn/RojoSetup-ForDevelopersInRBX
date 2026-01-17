# 📦 Roblox Studio — Arquitetura Profissional v3

> **Manual definitivo de backend Roblox**. Server‑authoritative, escalável, legível, seguro e manutenível. Isto não é tutorial. É **arquitetura de engenharia**.

---

## 🧠 PRINCÍPIO FUNDAMENTAL (IMUTÁVEL)

> ❌ **O Client nunca decide estado, lógica ou resultado.**

**Client faz:** input, UI, VFX, feedback

**Server faz:** validação, lógica, estado, persistência, segurança

Quebrou isso → exploit garantido.

---

## 🏗️ VISÃO GLOBAL DO SISTEMA

```
Client Controllers
   ↓
Remote Request
   ↓
Rate Limit
   ↓
Payload Validation
   ↓
State Validation
   ↓
Domain Service
   ↓
World / Data Update
   ↓
Replicação / Feedback
```

Nada pula etapas.

---

## 📁 ESTRUTURA DE PROJETO (MÉDIO / GRANDE)

```
ReplicatedStorage
 ├── Remotes
 ├── Shared
 │    ├── Types
 │    ├── Enums
 │    └── Configs

ServerScriptService
 ├── Bootstrap.server.lua
 ├── Services
 ├── Validators
 ├── RateLimit
 ├── Data
 └── Security

StarterPlayer
 └── StarterPlayerScripts
      ├── Bootstrap.client.lua
      └── Controllers
```

---

## 🔁 CICLO DE VIDA DE UM SISTEMA

### Interface padrão

```lua
export type Service = {
    Init: () -> (),
    Start: () -> (),
    Stop: () -> (),
}
```

### Regras

* `Init()` → setup, cache, binds
* `Start()` → começa a operar
* `Stop()` → desconecta eventos, limpa memória

Nada roda sem necessidade.

---

## 🧠 BOOTSTRAP DO SERVIDOR

Responsável por **orquestrar tudo**.

```lua
--!strict
local Services = {}

local ServiceList = {
    "PlayerDataService",
    "CombatService",
    "InventoryService",
}

for _, name in ServiceList do
    local service = require(script.Services[name])
    service.Init()
    Services[name] = service
end

for _, service in Services do
    service.Start()
end
```

Nenhuma lógica vive aqui.

---

## 🧠 BOOTSTRAP DO CLIENTE

Client também tem ciclo de vida.

```lua
local Controllers = {}

for _, controller in script.Controllers:GetChildren() do
    local c = require(controller)
    c.Init()
    table.insert(Controllers, c)
end

for _, c in Controllers do
    c.Start()
end
```

---

## 🧩 SERVICES (DOMÍNIO)

### O que é

Service = regra de negócio pura.

* Server only
* Não acessa UI
* Não confia no Client

### Exemplo: CombatService

```lua
--!strict
local CombatService = {}

function CombatService.Init()
    -- cache configs
end

function CombatService.Start()
    -- conecta remotes
end

function CombatService.DealDamage(player, target, amount)
    -- lógica
end

return CombatService
```

---

## 🔐 VALIDATORS (ANTI‑EXPLOIT REAL)

### Objetivo

Garantir que **o pedido faz sentido**.

### Exemplo

```lua
--!strict
local Validator = {}

function Validator.ValidateAttack(player, payload)
    if typeof(payload) ~= "table" then return false end
    if typeof(payload.targetId) ~= "number" then return false end
    return true
end

return Validator
```

Sem validação → request descartada.

---

## ⏱️ RATE LIMIT

### Modelo

* Contador por ação
* Janela de tempo
* Excedeu → ignora ou pune

```lua
local RateLimiter = {}
local limits = {}

function RateLimiter.Allow(player, key, max, window)
    -- implementação
end

return RateLimiter
```

Nunca no Client.

---

## 🛡️ SEGURANÇA AVANÇADA

### Regras obrigatórias

* Nunca confiar em Instance do Client
* Re-resolver tudo no Server
* Cooldown = timestamp server-side

### Auto‑Kick

```lua
if suspicious then
    player:Kick("Exploit detectado")
end
```

Sem medo. Segurança primeiro.

---

## 💾 DATA (DataStore + Cache)

### Modelo

* Cache em memória
* Save periódico
* UpdateAsync

```lua
DataStore:UpdateAsync(key, function(old)
    return newData
end)
```

---

## 🌍 SHARD / MMO

### Conceito

* Place ≠ mundo inteiro
* Cada servidor = shard

### Serviços usados

* TeleportService
* MessagingService
* MemoryStoreService

### Exemplo

* Fila global → MemoryStore
* Broadcast → MessagingService

---

## ⚙️ PERFORMANCE

### Nunca

* Heartbeat sem motivo
* Loops infinitos

### Sempre

* Eventos
* Cache
* Sob demanda

---

## ❌ ERROS QUE DENUNCIAM INICIANTE

* Lógica no Client
* Remote sem validação
* Cooldown client-side
* Services mexendo em UI

---

## ✅ CHECKLIST FINAL

* Server‑authoritative
* Services isolados
* Validators ativos
* Rate limit ligado
* Bootstrap limpo

---

## 🧠 CONCLUSÃO

Se você seguir este manual:

* Seu código escala
* Seu jogo resiste a exploit
* Sua arquitetura é legível
* Você pensa como engenheiro

Isso é **backend de verdade no Roblox**.
