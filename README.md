# Biblioteca Municipal Ney Pontes — API (Backend)

API REST em Ruby on Rails para gerenciamento do acervo e emprestimos da biblioteca.

## Requisitos

- Ruby 3.2+
- Docker + Docker Compose (para banco e email)
- Rails 8.1+

## Setup rapido

```bash
# 1. Subir banco e servidor de email
docker compose up -d

# 2. Instalar gems
bundle install

# 3. Criar banco, migrar e popular
rails db:create db:migrate db:seed

# 4. Iniciar servidor
rails server
```

Servidor em `http://localhost:3000`.

## Servicos Docker

| Servico | Porta | Descricao |
|---------|-------|-----------|
| PostgreSQL | 5432 | Banco de dados |
| Mailpit | 1025 | SMTP (envio de emails) |
| Mailpit UI | 8025 | Interface web para ver emails |

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
http://localhost:8025
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
