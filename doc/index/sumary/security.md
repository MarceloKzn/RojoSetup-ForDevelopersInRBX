# Segurança no Roblox Studio — Anti-Exploit Real

Este arquivo existe porque **95% dos jogos Roblox são exploráveis**.

---

## Princípio absoluto

> **Servidor é autoridade.**

Se o client decide algo importante, você já perdeu.

---

## O que o client PODE fazer

* Enviar intenção
* Renderizar UI
* Predição visual

## O que o client NUNCA decide

* Dinheiro
* XP
* Loot
* Dano final
* Posição válida

---

## Validação server-side

Sempre valide:

* Tipo
* Range
* Estado atual
* Cooldown

```lua
if typeof(amount) ~= "number" then return end
if amount < 0 or amount > MAX then return end
```

---

## Rate limit obrigatório

```lua
if not limiter:allow(player) then
	warn("Spam detectado", player)
	return
end
```

Sem rate limit, Remote = exploit.

---

## Anti-patterns fatais

* Cliente manda novo saldo
* Cliente manda posição final
* Cliente chama Remote em loop

---

## Dano e combate

* Cliente pode *sugerir* hit
* Servidor recalcula
* Servidor aplica

Nunca confie em hitbox client-only.

---

## Logs e auditoria

* LogService
* Kick progressivo
* Ban apenas com evidência

---

## Obscuridade ≠ segurança

Esconder nomes de Remotes não protege nada.

---

Se não existe validação, existe exploit.
