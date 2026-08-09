# Biblioteca Municipal Ney Pontes — API (Backend)

API REST em Ruby on Rails para gerenciamento do acervo e emprestimos da biblioteca.

> Visão geral do projeto e como executar todo o sistema: [README do projeto](../README.md)

---

## Requisitos do edital (DESAFIO Nº 0001/2026) — todos cumpridos ✅

### a) Autenticação ✅

> O sistema deverá permitir o cadastro de novos bibliotecários (nome, e-mail e senha com criptografia no banco). Página de login com e-mail e senha. Funcionalidade de recuperação de senha. Cada novo bibliotecário terá senha provisória cadastrada pelo admin e, no primeiro acesso, será solicitada uma nova senha.

- [x] **Cadastro de bibliotecários** pelo admin (nome, e-mail e senha provisória).
- [x] **Criptografia de senha** no banco (bcrypt via Devise).
- [x] **Página de login** solicitando e-mail e senha.
- [x] **Recuperação de senha por e-mail** (link de redefinição com expiração).
- [x] **Senha provisória + troca obrigatória no primeiro acesso** (`first_login`).

### b) Categorias de livros ✅

> O sistema deverá conter uma página para o cadastro de categorias de livros, considerando apenas o nome da categoria (obrigatório).

- [x] **CRUD de categorias** com o único atributo obrigatório: nome.

### c) Livros ✅

> O sistema deverá conter uma página para o cadastro de livros considerando: ID (obrigatório, único e incremental); Autor (obrigatório); Título (obrigatório); Categoria (obrigatório); Status (disponível, emprestado); Observações (opcional).

- [x] **CRUD de livros** com todos os campos do edital.
- [x] **Status automático**: *disponível* / *emprestado*, atualizado pelo sistema ao emprestar/devolver.
- [x] Página de detalhes do livro com empréstimos ativos.

### d) Usuários da biblioteca ✅

> Cadastro de usuários com Nome completo, CPF (obrigatório e único), Telefone, E-mail e Senha de empréstimo. A senha de empréstimo deverá ser gerada automaticamente (aleatória) e enviada para o e-mail do usuário.

- [x] **Cadastro** com nome completo, CPF (único), telefone e e-mail, todos obrigatórios.
- [x] **Senha de empréstimo gerada automaticamente** (aleatória) para cada novo usuário.
- [x] **Envio da senha de empréstimo por e-mail**.

### e) Empréstimos de livros ✅

> O empréstimo realiza o fluxo: bibliotecário pesquisa o livro e verifica o status; se Disponível, realiza o empréstimo para o usuário da biblioteca; no ato do empréstimo, deverá ser solicitada a senha de empréstimo do usuário; caso o usuário não exista, deverá ser realizado o seu cadastro antes do empréstimo; o sistema registrará a data do empréstimo e calculará a devolução para até 15 dias úteis.

- [x] **Pesquisa do livro** e verificação de status (`GET /api/v1/livros?q=`).
- [x] **Empréstimo apenas para livros disponíveis** (regra `livro_disponivel` no model).
- [x] **Senha de empréstimo solicitada no ato** e validada pelo backend antes de concluir.
- [x] **Cadastro do usuário antes do empréstimo** caso não exista (cadastro rápido dentro do próprio fluxo, com senha gerada automaticamente).
- [x] **Data do empréstimo registrada** e **devolução calculada em até 15 dias úteis** (`15.business_days.from_now`).

### f) Sugestões de funcionalidades (pontuação extra) — todas implementadas ✅

> Relatório de livros em atraso; Renovação online; Histórico de empréstimos por usuário; Cálculo de multas a serem pagas devido a atrasos na devolução de livros.

- [x] **Relatório de livros em atraso** — página dedicada, com busca e exportação CSV.
- [x] **Renovação online** — pelo bibliotecário e pelo próprio cidadão no portal.
- [x] **Histórico de empréstimos por usuário** — com resumo de ativos, atrasados e multas pendentes.
- [x] **Cálculo de multas por atraso** — multa de R$ 2,00 aplicada automaticamente na devolução atrasada e registro de pagamento.

---

## Tecnologias recomendadas no edital — utilizadas ✅

> "Se o candidato preferir, poderá utilizar outras tecnologias conforme desejar (React para o front, utilizar a API ViaCep...), o que será recompensado com pontuação extra."

- [x] **React + TypeScript** no frontend (SPA).
- [x] **API ViaCep** para preenchimento automático de endereços.

---

## Outros extras implementados

- [x] **Carteirinha digital** com número gerado automaticamente (`BNP-ANO-hex`) e status.
- [x] **Portal do cidadão**: dashboard, meus empréstimos, renovação online, carteirinha e edição de perfil.
- [x] **Cadastro público de cidadão** e **acervo público** com busca por título/autor.
- [x] **Dashboard administrativo** com indicadores (acervo, empréstimos ativos/atrasados, cidadãos).
- [x] **Relatórios com exportação CSV** e filtros por período/status.
- [x] **Multiníveis de acesso** (admin / bibliotecário / cidadão) com Pundit.
- [x] **Documentação Swagger** da API (`/api-docs`).
- [x] **Suíte de testes automatizados** (RSpec).
- [x] **Tratamento de erros amigável** no frontend (mensagens do backend exibidas ao usuário) e **sessão estável** (erros de negócio não derrubam o login).

---

## Critérios de avaliação atendidos

| Critério | Situação |
|----------|----------|
| Autenticação dos usuários (1 pt) | ✅ Implementado |
| Recuperação de senha por e-mail (1 pt) | ✅ Implementado |
| Categorias de livros (0,5 pt) | ✅ Implementado |
| Livros (1 pt) | ✅ Implementado |
| Usuários da biblioteca (1,5 pt) | ✅ Implementado |
| Empréstimo de livros (3 pts) | ✅ Implementado |
| Funcionalidades extras (até 1 pt) | ✅ Todas as 4 sugestões + extras |

---

## Requisitos

- Ruby 3.2+
- Docker + Docker Compose (para banco e email)
- Rails 8.1+

## Setup rapido

```bash
# 1. Subir servidor de email (Mailpit) e o banco (veja a seção Docker)
docker compose up -d

# 2. Instalar gems
bundle install

# 3. Criar banco, migrar e popular
rails db:create db:migrate db:seed

# 4. Iniciar servidor
rails server
```

Servidor em `http://localhost:3000`.

## Docker

O projeto usa **Docker Compose apenas para o Mailpit** (servidor de email). O PostgreSQL roda em um container próprio (`postgres:17-alpine`).

### 1. Iniciar o Mailpit

```bash
docker compose up -d
```

- SMTP: `localhost:1026` (o Rails envia os emails por aqui)
- UI para ver os emails: `http://localhost:8026`

Para parar/ver logs: `docker compose down` e `docker compose logs -f mailpit`.

### 2. Iniciar o PostgreSQL

Verifique se já existe um container rodando na porta 5432:

```bash
docker ps
```

Se não houver, crie um (exemplo com usuário `postgres`):

```bash
docker run -d \
  --name d3tec-postgres \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -p 5432:5432 \
  postgres:17-alpine
```

> **Importante:** as credenciais do banco usadas pelo Rails (`DB_USERNAME` e `DB_PASSWORD` no `.env`) devem ser as mesmas definidas na criação do container.

## Servicos Docker

| Servico | Porta host | Descricao |
|---------|-----------|-----------|
| PostgreSQL (`postgres:17-alpine`) | 5432 | Banco de dados (container separado) |
| Mailpit SMTP | 1026 | SMTP (envio de emails) |
| Mailpit UI | 8026 | Interface web para ver emails |

## Credenciais

### Admin do sistema

| Campo | Valor |
|-------|-------|
| E-mail | `admin@biblioteca.com` |
| Senha | `admin123` |
| Papel | `admin` |

No primeiro login, sera solicitada a troca da senha. O admin tem acesso total,
inclusive ao cadastro de bibliotecarios (que recebem a senha temporaria por email).

### Bibliotecarios (demo)

| E-mail | Senha |
|--------|-------|
| `maria.bibliotecaria@biblioteca.com` | `senha123` (trocar no 1º acesso) |
| `joaopedro.bibliotecario@biblioteca.com` | `senha123` |
| `fernanda.bibliotecaria@biblioteca.com` | `senha123` |

### Cidadao

| Campo | Valor |
|-------|-------|
| E-mail | `cidadao@email.com` |
| Senha de acesso | `senha123` |
| Senha de emprestimo | `abc123` |

## Emails

O sistema envia emails automaticamente via Mailpit. Para visualizar:

```
http://localhost:8026
```

Emails disparados:

- **Cadastro de cidadao** (publico ou admin) → senha de emprestimo + carteirinha
- **Cadastro de bibliotecario** (pelo admin) → senha temporaria de acesso
- **Recuperacao de senha** → link de reset

## Swagger

```
http://localhost:3000/api-docs
```

## Endpoints principais

### Autenticacao

| Metodo | Rota | Descricao |
|--------|------|-----------|
| POST | `/api/v1/login` | Login |
| DELETE | `/api/v1/logout` | Logout |
| POST | `/api/v1/registro` | Cadastro de cidadao |
| POST | `/api/v1/users/password` | Recuperar senha |
| PUT | `/api/v1/users/password` | Redefinir senha |

### Admin (somente admin do sistema)

| Metodo | Rota | Descricao |
|--------|------|-----------|
| GET | `/api/v1/users` | Listar bibliotecarios |
| POST | `/api/v1/users` | Cadastrar bibliotecario (envia senha temporaria por email) |
| GET/PUT/DELETE | `/api/v1/users/:id` | CRUD bibliotecario |

### Bibliotecario / Admin (autenticados)

| Metodo | Rota | Descricao |
|--------|------|-----------|
| GET/POST/PUT/DELETE | `/api/v1/categorias` | CRUD categorias |
| GET/POST/PUT/DELETE | `/api/v1/livros` | CRUD livros |
| GET/POST/PUT/DELETE | `/api/v1/cidadaos` | CRUD cidadaos |
| GET | `/api/v1/cidadaos/:id/carteirinha` | Carteirinha do cidadao |
| GET/POST | `/api/v1/emprestimos` | Emprestimos |
| PUT | `/api/v1/emprestimos/:id/devolver` | Devolucao |
| PUT | `/api/v1/emprestimos/:id/renovar` | Renovacao |
| GET | `/api/v1/emprestimos/atrasados` | Relatorio de atrasados |
| GET | `/api/v1/emprestimos/historico` | Historico por cidadao |

### Cidadao

| Metodo | Rota | Descricao |
|--------|------|-----------|
| GET | `/api/v1/perfil` | Ver perfil |
| PUT | `/api/v1/perfil` | Editar perfil |

## Testes

```bash
rails db:test:prepare
rails rswag          # gera documentacao Swagger
bundle exec rspec    # roda specs (49 exemplos)
```

## Variaveis de ambiente

Copie `.env.example` para `.env` e ajuste:

```bash
cp .env.example .env
```

| Variavel | Obrigatoria | Descricao |
|----------|-------------|-----------|
| `DB_USERNAME` | Sim (desenvolvimento) | Usuario do PostgreSQL |
| `DB_PASSWORD` | Sim (desenvolvimento) | Senha do PostgreSQL |
| `DB_HOST` | Nao | Host do banco (default `localhost`) |
| `DB_PORT` | Nao | Porta do banco (default `5432`) |
| `PORT` | Nao | Porta do servidor Rails (default `3000`) |
| `DEVISE_JWT_SECRET_KEY` | Nao (desenvolvimento) | Segredo para assinar os JWTs; obrigatoria fora de dev (em dev cai para `secret_key_base` ou fallback) |
| `FRONTEND_URL` | Nao | URL do frontend usada nos links de recuperacao de senha (default `http://localhost:3010`) |
| `RAILS_LOG_LEVEL` | Nao | Nivel de log (default `info`) |
| `RAILS_MAX_THREADS` | Nao | Pool de conexoes do banco (default `5`) |

### Conteudo do `.env.example`

```env
# Banco de dados (PostgreSQL via docker compose)
DB_USERNAME=biblioteca
DB_PASSWORD=biblioteca123
DB_HOST=localhost
DB_PORT=5432

# Servidor
PORT=3000

# Seguranca (JWT) - gere com: ruby -rsecurerandom -e "puts SecureRandom.hex(64)"
DEVISE_JWT_SECRET_KEY=troque_este_valor_por_um_segredo_aleatorio

# Frontend (links de email)
FRONTEND_URL=http://localhost:3010

# Logs
RAILS_LOG_LEVEL=info
```
