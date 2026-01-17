# Services do Roblox Studio — Documentação Completa

Este arquivo documenta **TODOS os Services relevantes** do Roblox Studio, com foco em uso profissional, escalabilidade e segurança.

---

## Convenções

```lua
--!strict
local Service = game:GetService("ServiceName")
```

---

## Players

### Responsabilidade

Gerencia conexões de jogadores, criação/destruição de objetos Player.

### Quando usar

* Inicializar dados
* Criar leaderstats (quando realmente necessário)
* Bind de eventos de entrada/saída

### Quando NÃO usar

* Lógica crítica de segurança no cliente
* Armazenar dados sensíveis visíveis

### Principais eventos

* PlayerAdded
* PlayerRemoving

### Exemplo

```lua
Players.PlayerAdded:Connect(function(player)
	-- init profile
end)
```

---

## Workspace

### Responsabilidade

Contém todo o mundo físico: Parts, Models, Terrain.

### Boas práticas

* Use Raycast moderno
* Evite GetDescendants em runtime frequente

### Exemplo

```lua
Workspace:Raycast(origin, direction, params)
```

---

## ReplicatedStorage

### Uso correto

* Módulos compartilhados
* Tipos, configs, constantes

### Nunca use para

* Chaves
* Lógica sensível

---

## ServerScriptService

### Regra

Tudo que importa vive aqui.

### Estrutura recomendada

* Services/
* Controllers/

---

## RunService

### Eventos

* Heartbeat (server/client)
* RenderStepped (client only)

### Erro comum

Lógica pesada por frame.

---

## TweenService

```lua
TweenService:Create(instance, info, goal):Play()
```

---

## PathfindingService

### Não abuse

Pathfinding é caro. Cache caminhos.

---

## PhysicsService

Use CollisionGroups para evitar colisões desnecessárias.

---

## CollectionService

Tags > hierarquia rígida.

---

## DataStoreService

Detalhado em `datastore.md`

---

## MemoryStoreService

Para locks, filas, dados temporários.

---

## MessagingService

Comunicação entre servidores.

---

## TeleportService

Base de MMO com múltiplas Places.

---

## MarketplaceService

Nunca confie no client para compras.

---

## SoundService / GuiService / ContextActionService

Client-side apenas.

---

Arquivo focado apenas em Services. Engine e arquitetura ficam em arquivos separados.
