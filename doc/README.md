# README — Documentação Completa da API e Serviços do Roblox Studio

> **Resumo:** Este documento é uma referência extensa e prática (em Português) para criação profissional no Roblox Studio. Cobre serviços, métodos, eventos, padrões de arquitetura, exemplos de código em Luau com `--!strict`, quando usar/não usar, segurança, performance e boas práticas. Não substitui a documentação oficial; serve como um README completo para um repositório GitHub.

---

## Índice

1. Introdução e propósito
2. Convenções deste README
3. Estrutura de projeto recomendada
4. Lista dos principais Services (visão geral)
5. Services — explicação detalhada, métodos, exemplos, quando usar/não usar

   * Players
   * Workspace
   * ReplicatedStorage
   * ServerScriptService
   * StarterPlayer/StarterGui/StarterPack
   * DataStoreService
   * HttpService
   * RunService
   * UserInputService
   * MarketplaceService
   * TeleportService
   * PathfindingService
   * Lighting
   * PhysicsService
   * CollectionService
   * MessagingService
   * LogService
   * AnalyticsService
   * BadgeService
   * InsertService
   * AssetService
   * GroupService
   * GuiService
   * TweenService
   * SoundService
   * ContextActionService
   * LocalizationService
   * MemoryStoreService (e.g., for ordered data and locks)
   * TextService
   * VoiceChatService
   * Network related services (ProfileService patterns)
6. Conceitos básicos da Engine (Instances, Properties, Events, Methods)
7. Classes importantes (Part, Model, Humanoid, Tool, WeldConstraint, Welds, Attachments, Meshes)
8. Remotes: RemoteEvent e RemoteFunction — padrões, exemplos, quando NÃO usar
9. Segurança e validação server-side (autoridade do servidor, anti-exploit)
10. Padrões de arquitetura escaláveis (Server/Client/Shared, Services & Controllers)
11. Otimização de performance (streaming, LODs, humanoids, simulators, physics)
12. Economia de memória e garbage collection (boas práticas)
13. Tasks, coroutines e RunService (Heartbeat/Stepped/RenderStepped)
14. Data persistence: DataStores e ProfileService (padrões, limites, backoff)
15. Deploy e CI/CD para Roblox (Rojo, GitHub Actions, testes unitários)
16. Exemplos práticos (Inventário, Sistema de Quest, Sistema de Trabalhos — JobManager)
17. Checklist de revisão antes do build
18. FAQ técnico
19. Referências (links oficiais)

---

## 1. Introdução e propósito

Documento direto, prático e técnico para desenvolvedores que planejam criar experiências Roblox escaláveis e profissionais. Objetivo: centralizar padrões, exemplos de código, armadilhas comuns e quando usar ou evitar certas APIs.

---

## 2. Convenções deste README

* Linguagem de exemplos: **Luau** com `--!strict` quando aplicável.
* Comentários: `--` e `--!strict` no topo dos exemplos.
* Cliente = código que roda no jogador (LocalScript). Servidor = ServerScript/ModuleScript no ServerScriptService.
* Use `ReplicatedStorage` para dados compartilhados legíveis por cliente e servidor (não para segredos).
* Use `ServerScriptService` para lógica server-side.
* Sempre valide dados no servidor.

---

## 3. Estrutura de projeto recomendada

```
Place/ExperienceRoot
├─ ReplicatedStorage/
│  ├─ SharedModules/
│  ├─ RemoteEvents/
│  └─ RemoteFunctions/
├─ ServerScriptService/
│  ├─ Services/        -- módulos que encapsulam a lógica server-side
│  ├─ Controllers/     -- controladores que orquestram Services
│  └─ Init.server.lua
├─ StarterPlayer/
│  ├─ StarterPlayerScripts/
│  └─ StarterCharacterScripts/
├─ StarterGui/
├─ StarterPack/
└─ Modules/            -- módulos utilitários (padrão)
```

Explicação: separar por responsabilidade (Services = lógica persistente, Controllers = orquestração do jogo, Modules compartilhados = lógica reutilizável). Use naming claro e export types nos ModuleScripts.

---

## 4. Lista dos principais Services (visão geral)

Neste README iremos detalhar os Services mais usados: `Players`, `Workspace`, `ReplicatedStorage`, `ServerScriptService`, `DataStoreService`, `HttpService`, `RunService`, `UserInputService`, `TweenService`, `SoundService`, `PhysicsService`, `PathfindingService`, `CollectionService`, `TeleportService`, `MarketplaceService`, `MemoryStoreService`, entre outros.

---

## 5. Services — explicação detalhada, métodos, exemplos, quando usar/não usar

> **Formato para cada service:** descrição, uso principal, instância de obtenção (`game:GetService("ServiceName")`), métodos importantes, eventos comuns, exemplos de código, e práticas de quando usar/não usar.

### 5.1 Players

**Descrição:** Gerencia jogadores conectados — objetos `Player` são criados/descartados conforme conexão.

**Obter:** `local Players = game:GetService("Players")`

**Métodos/eventos importantes:**

* `Players.PlayerAdded:Connect(function(player) ... end)`
* `Players.PlayerRemoving:Connect(function(player) ... end)`
* `Players:GetPlayers()`
* `Players:PlayerFromCharacter(character)`
* `Players:CreateHumanoidModelFromUserId(userId)` (útil para preview)

**Quando usar:** controlar conexões, iniciar perfis, carregar dados do jogador, configurar leaderstats e UI inicial.

**Quando não usar:** não execute lógica crítica de segurança diretamente no cliente; não armazene dados sensíveis em `leaderstats` visíveis se não for necessário.

**Exemplo — inicializar perfil:**

```lua
--!strict
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local function onPlayerAdded(player: Player)
    -- criar leaderstats simples
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    local aura = Instance.new("IntValue")
    aura.Name = "Aura"
    aura.Value = 0
    aura.Parent = leaderstats

    -- iniciar load de profile (padrão: usar módulo ProfileService)
end

Players.PlayerAdded:Connect(onPlayerAdded)
```

---

### 5.2 Workspace

**Descrição:** Contém a cena/objetos dentro do jogo: `Parts`, `Models`, `Terrain`, `Lighting` link etc. Tudo que está fisicamente no mundo.

**Obter:** `local Workspace = game:GetService("Workspace")`

**Quando usar:** para manipular o ambiente, spawn de objetos físicos, raycasts, pathfinding targets.

**Quando não usar:** não armazene dados de configuração (use `ReplicatedStorage`); evite alterar a hierarquia do Workspace diretamente a cada frame — prefira pooling.

**Métodos/eventos úteis:**

* `Workspace:FindPartOnRayWithIgnoreList` (deprecated em favor de `Raycast` API)
* `Workspace:Raycast(origin, direction, params)`
* `Workspace.CurrentCamera`
* `Workspace:GetDescendants()`

**Exemplo — Raycast e coleta de item (server-side):**

```lua
--!strict
local Workspace = game:GetService("Workspace")

local function raycastFromOrigin(origin: Vector3, direction: Vector3)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {} -- preencher
    local result = Workspace:Raycast(origin, direction, params)
    return result
end
```

---

### 5.3 ReplicatedStorage

**Descrição:** Armazena objetos e módulos compartilhados entre cliente e servidor. Ideal para ModuleScripts que contém tipos, configurações e dados que ambos precisam ler.

**Obter:** `local ReplicatedStorage = game:GetService("ReplicatedStorage")`

**Quando usar:** para assets que clientes precisam ler ao iniciar — templates de GUI, módulos puros, configurações. NÃO armazenar segredos, tokens, ou lógica que precise de proteção.

**Exemplo:** centralizar `RemoteEvents` e módulos utilitários.

```lua
--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local RemoteEvents = Remotes:WaitForChild("RemoteEvents")
```

---

### 5.4 ServerScriptService

**Descrição:** Local para scripts que rodam só no servidor. Código aqui não é acessível ao cliente.

**Quando usar:** lógica de jogo que exige autoridade e segurança: DataStore, validação, matchmaking, economia, salvamentos.

**Exemplo — estrutura de serviço:**

```lua
-- ServerScriptService/Services/InventoryService.server.lua
--!strict
local InventoryService = {}

function InventoryService:Init()
    -- inicializa conexões, cache
end

function InventoryService:AddItem(player, itemId)
    -- valida e adiciona
end

return InventoryService
```

---

### 5.5 StarterPlayer / StarterGui / StarterPack

Use StarterPlayerScripts para LocalScripts que serão clonados para cada jogador; StarterGui para GUIs que cada jogador recebe; StarterPack para ferramentas atribuídas ao jogador.

**Quando não usar:** não coloque lógica sensível na StarterGui que o cliente possa manipular sem validação posterior no servidor.

---

### 5.6 DataStoreService

**Descrição:** Persistência de dados através de `DataStoreService` e `OrderedDataStore`.

**Obter:** `local DataStoreService = game:GetService("DataStoreService")`

**Padrões importantes:**

* Use backoff exponencial em falhas (`pcall` retornando erro);
* Trate `DataStore` com cuidado para rate limits (limitado por Roblox);
* Use `MemoryStoreService` para dados voláteis de alto desempenho e locks quando disponível (devuž).

**Quando usar:** persistência de inventário, progresso do jogador, economia.

**Quando não usar:** usar DataStore para salvar em alta frequência (a cada segundo) — agrupe mudanças e salve periodicamente (auto-save com delta).

**Exemplo — salvar profile com pcall e retry:**

```lua
--!strict
local DataStoreService = game:GetService("DataStoreService")
local playerData = DataStoreService:GetDataStore("PlayerData")

local function SavePlayerData(userId: number, data: table)
    local success, err
    for i = 1, 5 do
        success, err = pcall(function()
            playerData:SetAsync(tostring(userId), data)
        end)
        if success then return true end
        task.wait(2 ^ i)
    end
    warn("Falha ao salvar: ", err)
    return false
end
```

---

### 5.7 HttpService

**Descrição:** Realiza chamadas HTTP externas (necessita habilitar nas configurações do jogo).

**Quando usar:** integrar APIs externas (leaderboards, verificação de pagamentos, microservices). Sempre sanitize e valide respostas.

**Riscos:** dados externos podem ser lentos ou maliciosos — nunca confie automaticamente; execute validações e timeouts.

**Exemplo:** `HttpService:RequestAsync{Url = url, Method = "GET"}`

---

### 5.8 RunService

**Descrição:** Hooks de ciclo de jogo — `Heartbeat`, `Stepped`, `RenderStepped` (este último só para LocalScripts). Use com parcimônia.

**Quando usar:** lógica que precisa do tick do jogo. Para manipular física/estado por frame, animações procedurais ou sincronização.

**Quando NÃO usar:** não faça heavy work por frame em `RenderStepped` se não for UI/visual. Evite criar muitos listeners.

**Exemplo — Listener de Heartbeat:**

```lua
local RunService = game:GetService("RunService")
RunService.Heartbeat:Connect(function(dt)
    -- lógica que roda com o delta time
end)
```

---

### 5.9 UserInputService

**Descrição:** Input do usuário (teclado, mouse, touchscreen). Use LocalScripts.

**Quando usar:** binding custom de controles, detectar entradas locais.

**Quando não usar:** NÃO confie em entradas do cliente para autorizar ações do jogo sem validação server-side.

---

### 5.10 TweenService, SoundService, GuiService, ContextActionService

**Uso:** animações, transições, mapas de controle, manipulação de GUI.

**Exemplo de Tween:**

```lua
local TweenService = game:GetService("TweenService")
local info = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tween = TweenService:Create(part, info, {Transparency = 0})
tween:Play()
```

---

### 5.11 PathfindingService

**Descrição:** Gerar caminhos navegáveis para NPCs.

**Quando usar:** mover NPCs em ambientes complexos.

**Quando não usar:** para alta quantidade (centenas) de pathfinds por segundo — prefira soluções simplificadas ou pré-calculadas.

---

### 5.12 PhysicsService

**Descrição:** camada de colisão e interação (Collision Groups).

**Uso:** definir grupos de colisão para ignorar/aceitar colisões entre objetos.

---

### 5.13 CollectionService

**Descrição:** marcação dinâmica de objetos via tags: `CollectionService:AddTag(instance, tag)`

**Uso:** organizar comportamentos, encontrar rapidamente objetos com tags.

---

### 5.14 TeleportService, MarketplaceService, BadgeService

**Uso:** ferramentas de monetização e transição entre lugares (places) de um experience.

**Cuidados:** validar transições, tratamento de falhas e callbacks.

---

### 5.15 MemoryStoreService e MessagingService

**MemoryStore:** útil para filas, locks e dados compartilhados entre servidores (ex: matchmaking). `MessagingService` é pub/sub para mensagens entre servidores.

**Observação:** esses serviços têm limitações de quota; use com cuidado.

---

## 6. Conceitos básicos da Engine

* `Instance`: todo objeto na cena herda de `Instance`.
* `Properties`: valores que definem comportamentos (Anchored, CanCollide, Size, CFrame).
* `Events`: `Touched`, `ChildAdded`, `Changed`.
* `Methods`: `Destroy()`, `Clone()`, `FindFirstChild()`, `WaitForChild()`.

**Boas práticas:** usar `WaitForChild` para recursos que podem não ter sido replicados ainda; evitar `:FindFirstChild()` sem checagem se espera necessário.

---

## 7. Classes importantes (resumo rápido)

**Part**: objeto físico básico. Use `Anchored` e `CanCollide` com consciência.

**Model**: agrupa Parts. Use `PrimaryPart` para manipulações globais.

**Humanoid**: componentes de personagem — `Health`, `WalkSpeed`, `JumpPower`, `TakeDamage`.

**Tool**: item equipável pelo jogador; use `Activated`, `Equipped` events.

---

## 8. Remotes: RemoteEvent e RemoteFunction

**RemoteEvent:** assíncrono. Cliente -> servidor: `FireServer`; servidor -> cliente: `FireClient`/`FireAllClients`.

**RemoteFunction:** síncrono com retorno imediato. Evite usar RemoteFunction para chamadas frequentes por latência e segurança (cliente espera resposta bloqueante).

**Padrões:**

* Sempre validar no servidor qualquer input do cliente.
* Use RemoteEvents para notificações; RemoteFunctions apenas quando precisar de resposta imediata e for seguro.
* Combine RemoteEvents com Request/Response pattern: cliente `FireServer` -> servidor processa -> `FireClient` resposta.

**Exemplo seguro de RemoteEvent para comprar item:**

```lua
-- Server
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local BuyItemEvent = Remotes:WaitForChild("BuyItem")

BuyItemEvent.OnServerEvent:Connect(function(player, itemId)
    -- validar itemId, checar saldo, aplicar alteração no servidor
end)
```

**Quando NÃO usar:** NÃO confie no cliente para executar compras, modificar inventário, ou alterar XP.

---

## 9. Segurança e validação server-side

Principais pontos:

* **Servidor é autoridade.** tudo que importa (dinheiro, inventário, saúde) deve ser verificado no server.
* **Rate-limit remotes.** implemente contadores e filas no servidor para evitar flood/exploit.
* **Nunca armazene segredos no ReplicatedStorage.**
* **Use expiração/locks ao salvar** (optimistic locking/compare-and-swap patterns) para evitar overwrites.
* **Sanitize IDs e inputs.** checar tipos, limites (número máximo, string length).

**Exemplo — debounce/rate-limit simples:**

```lua
--!strict
local RateLimiter = {}

function RateLimiter.new(limitPerSec)
    local self = {cache = {}, limit = limitPerSec}
    setmetatable(self, {__index = RateLimiter})
    return self
end

function RateLimiter:allow(player: Player)
    local id = player.UserId
    local now = tick()
    local info = self.cache[id]
    if not info then
        self.cache[id] = {time = now, count = 1}
        return true
    end
    if now - info.time >= 1 then
        info.time = now
        info.count = 1
        return true
    end
    if info.count < self.limit then
        info.count = info.count + 1
        return true
    end
    return false
end
```

---

## 10. Padrões de arquitetura escaláveis

Siga a separação: **Shared Modules** (tipos e constantes), **Services** (lógica persistente no servidor), **Controllers** (orquestram e interagem com o client), **Client Systems** (UI, input, prediction leve).

**Exemplo de Service + Controller:**

* `EconomyService` (server): modifica saldo, guarda no DataStore.
* `EconomyController` (server): lida com eventos, mensageria entre players e serviços, políticas.

**Remote Flow recomendado:**

* Cliente envia intenção (ex: "requestBuy") via RemoteEvent.
* Servidor valida e executa.
* Servidor responde com RemoteEvent separado com resultado.

**State replication:** minimize dados trafegados e envie diffs (delta) quando possível.

---

## 11. Otimização de performance

**Rendering & Client-side:**

* Use `StreamingEnabled` e `CollectionService` para carregamento por região.
* Use LODs (niveau de detalhe) para modelos.
* Pooling para instâncias (reusar objetos em vez de destruir/criar frequentemente).

**Server-side:**

* Sharding/partitioning de world: múltiplos places para dividir carga; TeleportService para mover players entre places.
* MemoryStore + MessagingService para sincronizar estado entre servidores.
* Evite loops de alto custo por jogador; prefira agendamento por grupos.

**Physics:**

* Prefira `AssemblyLinearVelocity` sobre aplicar forças em loops.
* Evite muitas constraints dinâmicas; use simpler colliders.

**Humanoids/Characters:**

* Para >200 players por place: use *networked visualization* (ver outros jogadores como proxies), reduzir bone count e animações, usar LOD para não animar off-screen.

---

## 12. Economia de memória & GC

* Desconecte eventos (`:Disconnect()`) quando objetos são destruídos.
* Evite closures com referências longas para grandes tabelas.
* Use `:Destroy()` para objetos grandes e setar referências a nil.

---

## 13. Tasks, coroutines e RunService

* Prefira `task.spawn` e `task.defer` em vez de coroutines manuais.
* Use `RunService.Heartbeat` para sincronização com a física.
* `RenderStepped` é somente para LocalScripts e UI. Evite work pesado aqui.

---

## 14. Data persistence: DataStores e ProfileService

**Padrões:**

* Use ProfileService ou padrão similar para locks de profile.
* Implementar `OnClose` e auto-save periódico.
* Tratar merges e default values com cuidado.

**Exemplo simplificado de ProfileService pattern:**

```lua
-- usar ProfileService de community modules
```

---

## 15. Deploy e CI/CD (Rojo + GitHub)

* Estruture com Rojo para sincronizar arquivos locais com o Place.
* Use GitHub Actions para testes estáticos (lint, type-check com Luau analyzers) e deploy script que usa `rbxmk`/`rojo` commands.

---

## 16. Exemplos práticos

### 16.1 Sistema de Inventário (padrão)

* Use `ReplicatedStorage.SharedModules.ItemDefinitions` para tipos e metadados.
* `InventoryService` no servidor para salvar/validar; `InventoryController` para comunicar com clients.

**Exemplo (simplificado):**

```lua
-- InventoryService.server.lua
--!strict
local InventoryService = {}
local playerInventories = {}

function InventoryService:AddItem(player: Player, itemId: string)
    -- valida e insere
end

return InventoryService
```

### 16.2 Sistema de Jobs (JobManager)

* Use `ScriptableObjects`? (No Roblox, substitua por ModuleScripts que retornam tabelas configuráveis).
* `JobManager` server-side com métodos `GainXP(player, jobId, amount)` e eventos para quando upar.

---

## 17. Checklist de revisão antes do build

* Validação server-side: todas as mudanças críticas são validadas.
* DataStore backoff implementado.
* Remotes rate-limited.
* Pooling, não spawn/destruir excessivamente.
* Scripts desconectam eventos e liberam referências.
* Testes com roblox-client-server local (Play Solo) e QA em builds.

---

## 18. FAQ técnico

**P: Posso usar RemoteFunction para sincronizar posição?**
R: Não. Para posições frequentes, use NetworkOwner, CFrame replication via physics ou custom compression com RemoteEvents e state interpolation.

**P: Como reduzir latência para ações críticas?**
R: Use prediction client-side com rollback / reconciliação server authoritative.

---

## 19. Referências

Este README foi criado com base na documentação oficial do Roblox e nas boas práticas da comunidade:

* Documentação de criação e guias do Roblox. (fonte oficial)
* Listagem e referência da API do engine. (fonte oficial)

---

### Observações finais

Este arquivo é extenso, mas não substitui 100% a documentação oficial — use-o como reference central no seu repositório. Se quiser, posso:

---

*Fim do README — versão inicial (detalhada)*
