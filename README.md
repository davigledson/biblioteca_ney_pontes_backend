# Biblioteca Municipal Ney Pontes — API (Backend)

API REST em Ruby on Rails para gerenciamento do acervo e emprestimos da biblioteca.

## Requisitos

- Ruby 3.2+
- PostgreSQL 16+
- Rails 8.1+

## Setup

```bash
bundle install
rails db:create db:migrate db:seed
rails server
```

Servidor em `http://localhost:3000`.

## Credenciais

### Admin (bibliotecario)

| Campo | Valor |
|-------|-------|
| E-mail | `admin@biblioteca.com` |
| Senha | `admin123` |

No primeiro login, sera solicitada a troca da senha.

### Cidadao

| Campo | Valor |
|-------|-------|
| E-mail | `cidadao@email.com` |
| Senha de acesso | `senha123` |
| Senha de emprestimo | `abc123` |

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

### Admin (autenticado como bibliotecario)

| Metodo | Rota | Descricao |
|--------|------|-----------|
| GET | `/api/v1/users` | Listar bibliotecarios |
| POST | `/api/v1/users` | Cadastrar bibliotecario |
| GET/PUT/DELETE | `/api/v1/users/:id` | CRUD bibliotecario |
| GET/POST/PUT/DELETE | `/api/v1/categorias` | CRUD categorias |
| GET/POST/PUT/DELETE | `/api/v1/livros` | CRUD livros |
| GET/POST/PUT/DELETE | `/api/v1/cidadaos` | CRUD cidadaos |
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
