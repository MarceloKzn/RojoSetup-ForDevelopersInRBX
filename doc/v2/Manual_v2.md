# 📦 Roblox Studio — Arquitetura Profissional, Segurança e Escalabilidade (v2)

> **Objetivo:** Documento de **revisão offline** para elevar imediatamente o nível técnico no Roblox Studio. Foco em **arquitetura limpa**, **server-authoritative**, **segurança real**, **boas práticas**, **uso correto de `--!strict`** e **sistemas que escalam** independentemente do gênero do jogo.

---

## 🧠 Princípio Fundamental (Não Negociável)

> ❌ **O Client nunca decide estado, lógica ou resultado.**

O Client:

* Input
* UI
* VFX
* Feedback

O Server:

* Validação
* Lógica
* Estado
* Persistência
* Anti‑cheat

Se essa regra for quebrada, **o projeto nasce explorável**.

---

## 🏗️ Arquitetura Base (Server‑Authoritative)

```
Client
  └── UI / Input / FX
        ↓
Remote (Request)
        ↓
Server Validation Layer
        ↓
Domain Services (Lógica)
        ↓
State / Data / World
        ↓
Client Feedback (replicado)
```

Nada pula etapas.

---

## 📁 Estrutura Profissional de Pastas

```
ReplicatedStorage
 ├── Remotes
 │    ├── Combat
 │    ├── Inventory
 │    └── Progression
 ├── Shared
 │    ├── Types
 │    ├── Enums
 │    └── Configs

ServerScriptService
 ├── Bootstrap.server.lua
 ├── Services
 │    ├── CombatService.lua
 │    ├── InventoryService.lua
 │    ├── PlayerDataService.lua
 │    └── TeleportService.lua
 ├── Validators
 │    ├── CombatValidator.lua
 │    └── InventoryValidator.lua
 ├── RateLimit
 │    └── RateLimiter.lua
 └── Data
      └── DataStore.lua

StarterPlayer
 └── StarterPlayerScripts
      └── Controllers
           ├── UIController.client.lua
           └── InputController.client.lua
```

---

## 🧩 O que é um **Service** (Definição Técnica)

**Service = módulo de domínio**, responsável por **regras de negócio**, nunca por UI.

Um Service:

* Roda **somente no Server**
* Não acessa `PlayerGui`
* Não confia no Client
* Expõe funções claras

Exemplo de responsabilidade:

* `CombatService`: cálculo de dano, cooldown, hit validation
* `InventoryService`: add/remove item, stack, validação
* `PlayerDataService`: load/save/cache

---

## 🔗 Quando e Como usar `require()`

### Regra prática

* `require()` **uma vez** por Service
* Centralizado no **Bootstrap**
* Nunca em loops

### Bootstrap (orquestrador)

Responsável por:

* Carregar Services
* Inicializar Data
* Conectar Remotes

Nenhuma lógica de gameplay vive aqui.

---

## 🧠 `--!strict` (Uso Correto e Profissional)

### O que é

`--!strict` ativa **type checking forte** no Luau.

Não é opcional em projetos sérios.

### Onde usar

* **Services**
* **Validators**
* **Shared/Types**

### Onde evitar

* Scripts temporários
* Prototipagem rápida

### Benefícios reais

* Evita payload inválido de Remote
* Documenta contrato de função
* Detecta erro antes de runtime

### Exemplo mental

* Todo Remote tem um **tipo de payload esperado**
* Se não bater, **request é descartada**

---

## 🔐 Comunicação Client ⇄ Server (Segurança Real)

### Camadas obrigatórias

1. **Rate Limit**
2. **Sanity Check**
3. **Validação de Estado**
4. **Execução**

Sem exceções.

---

## ⏱️ Rate Limiting (Anti‑Spam / Anti‑Exploit)

### Objetivo

Evitar:

* Spam de Remote
* Flood de requests
* Exploits de repetição

### Modelo mental

* Player tem um **contador por ação**
* Janela de tempo fixa
* Excedeu → request ignorada

### Onde vive

* Server
* Módulo dedicado (`RateLimiter`)

Nunca no Client.

---

## 🧪 Sanity Check (Validação de Payload)

### O que validar sempre

* Tipo (`typeof`)
* Intervalo numérico
* Enum válido
* Instance pertence ao Player

### Nunca confiar em:

* `Instance` enviada pelo Client
* Dano calculado no Client
* Cooldown controlado no Client

Client **pede**, Server **decide**.

---

## 🛡️ Validação de Estado

Antes de executar qualquer ação:

Perguntas obrigatórias:

* O Player pode fazer isso agora?
* Está vivo?
* Tem recurso suficiente?
* Está no local correto?

Se qualquer resposta for não → aborta.

---

## 💾 DataStore — Prática Profissional

### Regras obrigatórias

* `UpdateAsync` > `SetAsync`
* Cache em memória
* Retry com limite
* Versionamento de schema

### Modelo mental

* DataStore é **lento**
* Falhas acontecem
* Nunca salvar direto em evento de morte

Persistência é backend, não gameplay.

---

## ⚙️ Performance (Mental Model)

### Evitar

* Loops desnecessários em `Heartbeat`
* `wait()` em lógica crítica
* `FindFirstChild` repetido

### Preferir

* Cache de referências
* Eventos
* Processamento sob demanda

Performance ruim escala mal.

---

## 🚫 O que NUNCA fazer

* Lógica sensível no Client
* Dano calculado no Client
* Confiança em cooldown do Client
* Remote sem validação
* Services acessando UI

Esses erros **denunciam iniciante**.

---

## ✅ Checklist Técnico Final

* ✅ `--!strict` nos módulos críticos
* ✅ Services server‑side
* ✅ Remotes validados
* ✅ Rate limit ativo
* ✅ DataStore robusto
* ✅ Client apenas visual

---

## 🧠 Resultado Esperado

Após revisar este documento:

* Você pensa como **engenheiro**, não como scripter
* Seu código escala
* Seu jogo resiste a exploit
* Seu nível técnico é perceptível

📌 **Este README é um manual de arquitetura, não um tutorial.**