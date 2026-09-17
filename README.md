# CarForge

Car workshop management application for customers, vehicles, service orders,
estimates, inventory, and settlements. Currently in early development.

The Rails application lives at the repository root. Built with Ruby 4.0.4,
Rails 8.1, PostgreSQL, and Hotwire.

- [Project overview](docs/overview.md) — scope and main concepts.
- [Requirements](docs/details.md) — workflows and business rules.
- [Database schema](docs/database/schema.dbml) — proposed data model in DBML format.
- [Wireframes](wireframes/garageOps-rails-wires/) — separate Rails prototype with sample screens and data.
- [Project board](https://github.com/users/gmalinowski/projects/8) — development tasks and progress.

## Development

Rails runs locally with Ruby 4.0.4 and Bundler. PostgreSQL runs in a container
managed by Docker Compose or Podman Compose and is available on port `5433`.

Run the following commands from the repository root for the initial setup:

```bash
bundle install
podman compose up -d
bin/rails db:create db:migrate
bin/rails db:seed
```

For Docker, replace `podman compose` with `docker compose`.
Run the seed command once; it creates the development user below.

Start the application:

```bash
bin/dev
```

Open [localhost:3000](http://localhost:3000). The development account is:

- Email: `user1@example.com`
- Password: `password`
