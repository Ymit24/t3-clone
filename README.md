# T3Clone

T3Clone is a modern, full-stack Ruby on Rails 8 application designed as a template for building robust, scalable, and maintainable web apps. It leverages Hotwire (Turbo & Stimulus), Tailwind CSS, and a modular component architecture. The project is containerized for both development and production, and supports rapid iteration, automated testing, and cloud deployment.

## Features
- **Rails 8**: Latest Rails features and conventions
- **Hotwire**: Turbo & Stimulus for SPA-like interactivity
- **Tailwind CSS**: Utility-first styling
- **Component-driven UI**: ViewComponent & Lookbook previews
- **Job Queues**: Solid Queue, Mission Control Jobs
- **API & Web**: RESTful endpoints, session management, user accounts
- **PWA-ready**: Manifest and service worker support
- **Dockerized**: For both local development and production
- **Automated Testing**: Minitest, Guard, fixtures, and system tests

## Technology Stack
- **Ruby**: 3.3.5
- **Rails**: ~> 8.0.2
- **Database**: SQLite (default, easy to swap for PostgreSQL)
- **Frontend**: Hotwire (Turbo, Stimulus), Tailwind CSS
- **Containerization**: Docker
- **Job/Cache**: Solid Queue, Solid Cache, Mission Control Jobs
- **Component Previews**: Lookbook

## Prerequisites
- [Docker](https://www.docker.com/) (recommended for all environments)
- Or: Ruby 3.3.5, Node.js 20+, SQLite3, Yarn/NPM

## Getting Started

### 1. Clone the Repository
```bash
git clone <your-repo-url>
cd t3-clone
```

### 2. Local Development (Recommended: Docker)
#### Build the development image:
```bash
docker build -t rails-dev -f Dockerfile-dev .
```
#### Run the development container:
```bash
docker run -it \
  -p 3000:3000 \
  -v "$(pwd)":/rails \
  rails-dev bash -c "rm -f tmp/pids/server.pid && bundle exec rails s -b 0.0.0.0 -p 3000"
```
Visit [http://localhost:3000](http://localhost:3000)

### 3. Manual Setup (Without Docker)
```bash
# Install dependencies
bundle install
npm install
# Setup database
bin/rails db:setup
# Start the server
bin/rails server
```

### 4. Database Setup & Seeding
- The default database is SQLite (see `config/database.yml`).
- To seed demo data:
```bash
bin/rails db:seed
```

## Running Tests
NOTE: Tests are not currently up to date.
- **All tests:**
  ```bash
  bin/rails test
  ```
- **With Guard (auto-run on file changes):**
  ```bash
  bundle exec guard
  ```
- **System/Integration tests:**
  Place tests in `test/system/` or `test/integration/`.
- **Component tests:**
  See `test/components/` and preview with Lookbook.

## Component Previews (Lookbook)
- Run the Rails server in development and visit [http://localhost:3000/lookbook](http://localhost:3000/lookbook) to browse UI components and previews.

## Deployment

### Kamal 2 (Recommended for Production)
Kamal 2 is a modern deployment tool for Rails applications, enabling zero-downtime deploys using Docker containers on your own infrastructure.

#### Prerequisites
- Docker installed on your server(s)
- SSH access to your deployment target(s)
- `kamal` gem installed locally (`gem install kamal`)
- Registry credentials (Docker Hub or other)
- `RAILS_MASTER_KEY` and any other secrets set up in `.kamal/secrets` or your environment

#### Basic Setup
1. **Configure Kamal**
   - Edit `config/deploy.yml` to match your server and registry settings.
   - Add secrets to `.kamal/secrets` (see Kamal docs for details).
2. **Build and Push Image**
   ```bash
   kamal build
   kamal push
   ```
3. **Deploy**
   ```bash
   kamal deploy
   ```
4. **Rollback (if needed)**
   ```bash
   kamal rollback
   ```

See [Kamal documentation](https://kamal-deploy.org/docs) for advanced configuration, multi-server setups, and troubleshooting.

### Render.com
- See `render.yaml` for configuration.
- Typical setup uses:
  - `DATABASE_URL` (managed by Render)
  - `RAILS_MASTER_KEY` (add via Render dashboard)
- Build and start commands are in `render.yaml`.

### Production Docker
- Build and run the production image:
  ```bash
  docker build -t t3_clone .
  docker run -d -p 80:80 -e RAILS_MASTER_KEY=your_master_key --name t3_clone t3_clone
  ```
- See `Dockerfile` for details.

## Additional Resources
- [Rails Guides](https://guides.rubyonrails.org/)
- [Hotwire Docs](https://hotwired.dev/)
- [Tailwind CSS Docs](https://tailwindcss.com/docs)
- [Lookbook Docs](https://lookbook.build/)

## Contributing
Pull requests and issues are welcome! Please follow Rails conventions and add/maintain tests for new features.

---

© T3Clone. MIT License.
