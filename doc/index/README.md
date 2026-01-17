# Roblox Studio — Documentação Técnica (Index)

Este repositório contém uma documentação **modular** e **profissional** da Engine do Roblox Studio, focada em leitura offline e uso prático em projetos que escalam.

> Não substitui a documentação oficial. Serve como guia técnico central para times e projetos reais.

---

## Estrutura da Documentação

* **services.md** — Todos os Services do Roblox Studio (quando usar, quando não usar, exemplos)
* **architecture.md** — Arquitetura profissional (Server / Client / Shared, Services & Controllers)
* **remotes.md** — RemoteEvents e RemoteFunctions (segurança, padrões, anti-exploit)
* **datastore.md** — Persistência (DataStoreService, MemoryStoreService, Profile patterns)
* **performance.md** — Otimização real (client, server, física, streaming, humanoids)
* **security.md** — Validação server-side, rate limit, autoridade do servidor
* **engine.md** — Conceitos da engine (Instance, Properties, Events, Classes)
* **examples.md** — Sistemas completos (Inventário, Jobs, Economy, MMO patterns)

---

## Público-alvo

* Desenvolvedores Roblox intermediários e avançados
* Projetos que precisam escalar (RPGs, MMOs, simuladores)
* Times que usam Rojo, GitHub e CI

---

## Regras de ouro

* Servidor é autoridade
* Cliente nunca decide estado crítico
* ReplicatedStorage não guarda segredos
* Tudo que escala precisa de arquitetura

---

## Referências Oficiais

* [https://create.roblox.com/docs](https://create.roblox.com/docs)
* [https://create.roblox.com/docs/reference/engine](https://create.roblox.com/docs/reference/engine)

---

Leia os arquivos na ordem acima para máximo entendimento.
