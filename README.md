# 🕺 Emote Catalog — Roblox Studio

Catálogo de emotes moderno para Roblox com busca em tempo real, destaque especial e botões de testar e comprar.

---

## 📋 O que você vai precisar

- Roblox Studio instalado
- Uma conta Roblox
- 5 minutos do seu tempo

---

## ⚙️ Passo 1 — Ativar HTTP Requests

Antes de qualquer coisa, você precisa ativar as requisições HTTP no seu jogo:

1. Abra seu jogo no **Roblox Studio**
2. Clique em **Home** no menu superior
3. Clique em **Game Settings**
4. Vá na aba **Security**
5. Ative a opção **Allow HTTP Requests**
6. Clique em **Save**

> ⚠️ Sem isso, a busca de emotes **não vai funcionar**.

---

## 📁 Passo 2 — Criar o ModuleScript (CatalogModule)

1. No painel **Explorer** (lado direito), encontre **ReplicatedStorage**
2. Clique com o botão direito em **ReplicatedStorage**
3. Selecione **Insert Object > ModuleScript**
4. Renomeie para exatamente: `CatalogModule`
5. Dê duplo clique no script para abrir
6. **Apague todo o conteúdo** que já está lá
7. Abra o arquivo [`scripts/CatalogModule.lua`](scripts/CatalogModule.lua) aqui no GitHub
8. Copie todo o código e cole no script

---

## 📁 Passo 3 — Criar o LocalScript (EmoteCatalogUI)

1. No painel **Explorer**, encontre **StarterGui**
2. Clique com o botão direito em **StarterGui**
3. Selecione **Insert Object > ScreenGui**
4. Renomeie a ScreenGui para: `EmoteCatalogGUI`
5. Clique com o botão direito na **ScreenGui** que você criou
6. Selecione **Insert Object > LocalScript**
7. Dê duplo clique no LocalScript para abrir
8. **Apague todo o conteúdo** que já está lá
9. Abra o arquivo [`scripts/EmoteCatalogUI.lua`](scripts/EmoteCatalogUI.lua) aqui no GitHub
10. Copie todo o código e cole no script

---

## 📁 Passo 4 — Criar o Script do Servidor (ServerManager)

1. No painel **Explorer**, encontre **ServerScriptService**
2. Clique com o botão direito em **ServerScriptService**
3. Selecione **Insert Object > Script**
4. Renomeie para: `ServerManager`
5. Dê duplo clique no script para abrir
6. **Apague todo o conteúdo** que já está lá
7. Abra o arquivo [`scripts/ServerManager.lua`](scripts/ServerManager.lua) aqui no GitHub
8. Copie todo o código e cole no script

---

## ▶️ Passo 5 — Testar

1. Clique no botão **Play** no topo do Roblox Studio
2. Um botão azul escrito **EMOTES** vai aparecer no lado esquerdo da tela
3. Clique nele para abrir o catálogo
4. Use a barra de pesquisa para buscar qualquer emote
5. Clique em **▶ TESTAR** para ver o emote no seu personagem
6. Clique em **🛒 COMPRAR** para comprar o emote

---

## ✨ Funcionalidades

| Funcionalidade | Descrição |
|---|---|
| Busca em tempo real | Pesquise qualquer emote do Roblox |
| Emote especial | BRUNO BEST PRIME aparece sempre no topo com destaque dourado |
| Testar emote | Equipa o emote no personagem na hora |
| Comprar emote | Abre o prompt de compra do Roblox |
| Paginação automática | Carrega mais emotes ao rolar até o fim |

---

## 🗂️ Estrutura dos Arquivos

```
mapsss/
└── scripts/
    ├── CatalogModule.lua   → ModuleScript no ReplicatedStorage
    ├── EmoteCatalogUI.lua  → LocalScript dentro da ScreenGui no StarterGui
    └── ServerManager.lua   → Script no ServerScriptService
```

---

## ❓ Problemas comuns

**O catálogo não carrega emotes:**
Verifique se o **Allow HTTP Requests** está ativado em Game Settings > Security.

**O botão EMOTES não aparece:**
Confirme que o LocalScript está dentro de uma **ScreenGui** no **StarterGui**, não diretamente no StarterGui.

**Erro "WaitForChild CatalogModule":**
Confirme que o ModuleScript está no **ReplicatedStorage** e está nomeado exatamente como `CatalogModule`.
