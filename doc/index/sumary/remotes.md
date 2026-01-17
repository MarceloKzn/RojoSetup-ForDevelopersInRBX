# RemoteEvents e RemoteFunctions — Uso Correto

Este arquivo existe para evitar exploits.

---

## Regra absoluta

Cliente nunca manda estado final. Apenas intenção.

---

## RemoteEvent

### Quando usar

* Ações
* Notificações

### Exemplo seguro

```lua
Remote.OnServerEvent:Connect(function(player, data)
	-- validar tudo
end)
```

---

## RemoteFunction

### Use raramente

* Bloqueia thread
* Latência

Nunca use para spam.

---

## Rate limit

Obrigatório.

```lua
if not limiter:allow(player) then return end
```

---

## Anti-patterns

* Cliente mandando dinheiro
* Cliente mandando posição final
* Cliente decidindo loot

---

Se você confia no client, seu jogo já está quebrado.
