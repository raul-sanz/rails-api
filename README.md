
# Nexu API

API construida con Ruby on Rails 8.

## 🧰 Requisitos

- Ruby 3.3.6 (gestionado con RVM o rbenv)
- Rails 8.0.2
- PostgreSQL (mínimo v12)

## 🚀 Instalación

Cloná el repositorio:

```bash
git clone https://github.com/raul-sanz/rails-api.git
cd nexu-api
```

Instalá las dependencias Ruby:

```bash
bundle install
```

Creá la base de datos en Postgres(local) y ejecutá las migraciones:

```bash
rails db:migrate
```

Cargá datos de ejemplo seeds:

```bash
rails db:seed
```

## 🧪 Pruebas

Antes de correr los tests, asegurate de no tener conexiones abiertas a la base de datos `nexu_api_test`. Si las hay, cerralas con:

```bash
psql -U postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'nexu_api_test';"
```

Luego, ejecutá:

```bash
rails db:test:prepare
rails test
```

O, si preferís recrear todo desde cero:

```bash
RAILS_ENV=test rails db:drop db:create db:migrate
rails test
```

> ⚠️ No tener herramientas como PgAdmin, DataGrip o extensiones de VSCode conectadas a la DB de test durante estos comandos.

## 📦 Inicia tu servidos local

- `rails s` — Inicia el servidor en `http://localhost:3000`
- `rails routes` — Lista todas las rutas de la API

## 🔐 Variables de entorno

Asegurate de definir estas variables en tu entorno o en un archivo `.env`:

```env
DATABASE_URL_DEV=postgres://usuario:clave@localhost:5432/nexu_api_dev
DATABASE_URL_TEST=postgres://usuario:clave@localhost:5432/nexu_api_test
```

# ✅ Checklist de Backend para Nexu

## 🧾 Descripción general
Este proyecto es una API backend en Rails para ser consumida por un frontend ya existente. Se deben cumplir los siguientes requerimientos y rutas.

---

## ✅ Rutas requeridas

- [x] `GET /brands` – Lista todas las marcas con su precio promedio.
- [x] `GET /brands/:id/models` – Lista todos los modelos de una marca.
- [x] `POST /brands` – Crea una nueva marca. El nombre debe ser único.
- [x] `POST /brands/:id/models` – Crea un nuevo modelo para una marca existente. Nombre único dentro de la marca.
- [x] `PUT /models/:id` – Permite editar el average_price de un modelo.
- [x] `GET /models` – Lista todos los modelos, con filtros por `greater` y/o `lower`.

---

## ✅ Lógica de negocio

- [x] El precio promedio de cada marca es el promedio de los precios de sus modelos.
- [x] El nombre de la marca debe ser único. Si ya existe, retornar error adecuado.
- [x] El nombre del modelo debe ser único dentro de su marca. Si ya existe, retornar error.
- [x] Si el `average_price` se especifica al crear o actualizar, debe ser mayor a 100,000.
- [x] Si se intenta crear un modelo con una marca inexistente, retornar error.

---

## ✅ Base de datos

- [x] Crear base de datos para almacenar marcas y modelos.
- [x] Población inicial de la base de datos con el JSON proporcionado.

---

## ✅ Ejemplo de respuesta

### GET /brands
```json
[
  {"id": 1, "nombre": "Acura", "average_price": 702109},
  {"id": 2, "nombre": "Audi", "average_price": 630759}
]