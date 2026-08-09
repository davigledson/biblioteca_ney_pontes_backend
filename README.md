# Biblioteca Municipal Ney Pontes — API (Backend)

API REST em Ruby on Rails para gerenciamento do acervo e emprestimos da biblioteca.

## Extras implementados

### Sugestões do edital (pontuação extra)

- Relatório de livros em atraso, com busca e exportação CSV
- Renovação online (pelo bibliotecário e pelo cidadão no portal)
- Histórico de empréstimos por usuário
- Multas por atraso (R$ 2,00), aplicadas automaticamente na devolução atrasada, com registro de pagamento

### Tecnologias opcionais do edital

- Frontend em React + TypeScript
- API ViaCep no preenchimento automático de endereços

### Outros extras visíveis ao usuário

- Renovação online pelo cidadão, sem precisar ir à biblioteca
- Upload de capa de livros (JPG/PNG/WebP, até 5 MB), com pré-visualização e remoção
- Carteirinha digital com número gerado automaticamente
- Portal do cidadão (dashboard, meus empréstimos, carteirinha, perfil)
- Cadastro público de cidadão e acervo público com busca por título/autor
- ViaCep no cadastro: endereço preenchido automaticamente ao informar o CEP
- Dashboard administrativo com indicadores
- Relatórios com exportação CSV e filtros por período/status
- Mensagens de erro amigáveis e sessão estável (erros de negócio não derrubam o login)

### Extras técnicos

- Multiníveis de acesso (admin / bibliotecário / cidadão) com Pundit
- Documentação Swagger da API (`/api-docs`)
- Suíte de testes automatizados (RSpec)

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