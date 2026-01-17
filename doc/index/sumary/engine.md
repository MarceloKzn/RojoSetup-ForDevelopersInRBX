# Engine do Roblox — API Essencial

Este arquivo documenta **como a engine realmente funciona**.

---

## Instance

Tudo herda de `Instance`.

### Métodos universais

* Destroy()
* Clone()
* FindFirstChild()
* WaitForChild()

```lua
local part = Instance.new("Part")
part.Parent = workspace
```

---

## Properties

Definem comportamento.

* Anchored
* CanCollide
* Transparency
* CFrame

Alterar propriedades custa CPU. Evite spam.

---

## Events

* Touched
* Changed
* ChildAdded

Sempre desconecte eventos.

---

## Part

Objeto físico base.

Boas práticas:

* Use Anchored quando possível
* CollisionGroups

---

## Model

Agrupamento lógico.

Sempre defina `PrimaryPart`.

---

## Humanoid

O maior custo da engine.

Evite usar centenas.

* Health
* WalkSpeed
* TakeDamage()

---

## Tool

Item equipável.

* Activated
* Equipped

Valide no server.

---

## CFrame vs Vector3

* Vector3 → posição
* CFrame → posição + rotação

Sempre prefira CFrame.

---

## Attributes

Comunicação leve.

```lua
instance:SetAttribute("Level", 5)
```

Nunca use como fonte segura.

---

Engine mal entendida gera código ruim.
