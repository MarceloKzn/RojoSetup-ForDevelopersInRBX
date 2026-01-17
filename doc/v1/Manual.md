# 📦 Roblox Studio — Serviços, Arquitetura e Boas Práticas

> **Objetivo:** Este arquivo serve como material de **consulta offline** para revisar rapidamente **quais serviços do Roblox existem**, **para que servem**, **como são usados na prática** e **como organizar um projeto profissional com backend seguro e escalável**.

---

## 🧠 Visão Geral Rápida (Resumo Mental)

**Regra de Ouro do Roblox:**

> 🛑 *O Client nunca decide nada importante.*

Fluxo correto:

```
Client (UI / Input)
   ↓
RemoteEvent / RemoteFunction
   ↓
Server (Validação + Lógica)
   ↓
Atualiza dados / mundo
   ↓
Client (feedback visual)
```

---

# 🔹 Serviços Fundamentais

## Players

### 📌 Explicação simples

Gerencia tudo relacionado a jogadores.

### 📘 Explicação detalhada

Usado para detectar entrada/saída de jogadores, acessar Character, Backpack, PlayerGui e criar leaderstats.

### 🔧 Uso comum

* Inicialização de dados
* Conectar sistemas ao jogador

### 🧪 Exemplo

```lua
local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player)
    print(player.Name .. " entrou no jogo")
end)
```

---

## Workspace

### 📌 Simples

É o mundo físico do jogo.

### 📘 Detalhado

Contém mapas, partes, NPCs, mobs, hitboxes e tudo que existe fisicamente.

### 🔧 Uso comum

* Raycasts
* Spawns
* Movimentação de mobs

---

## ReplicatedStorage

### 📌 Simples

Local de arquivos compartilhados entre Client e Server.

### 📘 Detalhado

Usado para armazenar **RemoteEvents**, **RemoteFunctions** e **ModuleScripts de configuração**.

⚠️ **Nunca coloque lógica sensível aqui.**

### 🔧 Uso comum

* Comunicação
* Enums
* Configs

---

## ServerScriptService

### 📌 Simples

Backend do jogo (seguro).

### 📘 Detalhado

Scripts aqui rodam apenas no servidor e não podem ser acessados pelo client.

### 🔧 Uso comum

* Progressão
* Combate
* Economia
* Anti-cheat

---

## StarterGui / PlayerGui

### 📌 Simples

Interface do jogador.

### 📘 Detalhado

StarterGui é o template, PlayerGui é a cópia individual de cada jogador.

---

# 🔁 Comunicação Client ⇄ Server

## RemoteEvent

### 📌 Simples

Envia mensagens do Client para o Server (ou vice-versa).

### 📘 Detalhado

Assíncrono, ideal para ações frequentes.

### 🧪 Exemplo

```lua
-- Client
RemoteEvent:FireServer("Click")

-- Server
RemoteEvent.OnServerEvent:Connect(function(player, action)
    -- validação
end)
```

---

## RemoteFunction

### 📌 Simples

Pede algo e espera resposta.

### 📘 Detalhado

Síncrono. Evitar spam.

---

# 💾 Dados e Progressão

## DataStoreService

### 📌 Simples

Salva dados do jogador.

### 📘 Detalhado

Usado para persistir progresso. Deve ter retry, validação e fallback.

### 🔧 Uso comum

* Stats
* Inventory
* Rebirth

---

## ServerStorage

### 📌 Simples

Armazém invisível ao client.

### 📘 Detalhado

Guarda templates de mobs, itens e prefabs.

---

# ⚙️ Gameplay e Performance

## RunService

### 📌 Simples

Controla loops e contexto.

### 📘 Detalhado

Usado para Heartbeat, RenderStepped e detectar Client/Server.

---

## TweenService

### 📌 Simples

Animações suaves.

### 📘 Detalhado

Usado para UI e feedback visual.

---

## PhysicsService

### 📌 Simples

Controle de colisão.

### 📘 Detalhado

Cria grupos de colisão customizados.

---

# 🔐 Segurança e Utilitários

## CollectionService

### 📌 Simples

Sistema de tags.

### 📘 Detalhado

Permite identificar objetos sem depender de hierarquia.

### 🧪 Exemplo

```lua
CollectionService:AddTag(mob, "Enemy")
```

---

## HttpService

### 📌 Simples

JSON e APIs externas.

### 📘 Detalhado

Somente no server. Usado para integração externa.

---

# 🎮 Conteúdo e Experiência

## MarketplaceService

* Gamepasses
* Developer Products

---

## TeleportService

* Dungeons
* Mapas separados

---

# 🏗️ Arquitetura Profissional Recomendada

## Estrutura de Pastas

```
ReplicatedStorage
 ├── Remotes
 ├── Shared (Configs / Enums)

ServerScriptService
 ├── Systems
 │   ├── Combat
 │   ├── Progression
 │   └── Economy
 ├── Services (Lógica)
 └── Data

StarterPlayer
 └── StarterPlayerScripts
     └── UI Controllers
```

---

## Camadas Lógicas

1. **Input (Client)**
2. **Request (Remote)**
3. **Validation (Server)**
4. **Processing (Server)**
5. **State Update (Server)**
6. **Visual Feedback (Client)**

---

# 🧩 Processo de Criação de Jogos Profissionais

## 1️⃣ Planejamento

* Core loop
* Progressão
* Economia

## 2️⃣ Prototipagem

* Sistema mínimo funcional

## 3️⃣ Arquitetura

* Separação de responsabilidades
* Backend primeiro

## 4️⃣ Implementação

* Sistemas isolados
* Comunicação clara

## 5️⃣ Balanceamento

* Escalas
* Testes

## 6️⃣ Otimização

* Performance
* Segurança

---

# ✅ Checklist Mental

* ❌ Client não decide nada
* ✅ Server valida tudo
* ❌ Lógica sensível fora do ReplicatedStorage
* ✅ Sistemas desacoplados
* ✅ Pensar em escala desde o início

---

📌 **Este arquivo é seu guia offline para criar jogos Roblox mais sérios, seguros e escaláveis.**