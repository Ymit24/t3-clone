# T3Clone
This project is an entry into the t3.chat cloneathon competition. Below are some details about the project. 

DISCLAIMER: As this is a cloneathon submission there are a lot of failing tests, loose code, debug prints, and other wonderful little timebombs throughout the codebase. This is not a bug free product but it works shockingly well in my tests and im super proud of how it turned out!

SHOUTOUT: To my wonderful wife Grace who supported me while I spent tens of hours working on this project over the last week!

## Features
- **User authentication**: Email+password user authentication and basic authorization. No mailer is setup so features like email verification and forgot password aren't fully implemented.
- **Openrouter and OpenAI Providers**: The backend can call both openrouter and openai for generations. There are some limitations such as reasoning sumarries not implemented for OpenAI.
- **Streaming Responses**: All llm responses are streamed to your browser-- and any other browser tab, or device viewing the chat.
- **Resumable Generations**: You can switch chats, leave your tab, close your browser, throw your phone into the ocean and go get a brand new one, and your generations will keep going until they finish or YOU cancel them!
- **Multiple Concurrent Generations**: Have multiple chats generating at the same time on the same account, either through one tab, multiple tabs, or multiple devices, you can chat at the speed you can submit messages!
- **Cancelable Streams**: for both simple, search, and reasoning responses, you can cancel the request and avoid being billed for some 2 minute generation if you forgot a crucial detail in your prompt!
- **Basic Editing**: You can edit messages you already submitted as needed. You can't change the generation settings however, I ran out of time to build that feature :-).
- **Retry**: You can regenerate your last message-- or any earlier one-- and the same generation settings will be used. If you retry an earlier message, your later messages will be deleted.
- **Markdown Rendering**: All messages are rendered via markdown rendering to give the best experience. Code blocks also have syntax highlighting. Some models aren't as great at sticking to the markdown format in their responses so you may need to ask them to reformat their last response.
- **Copy code to clipboard**: All code blocks have a copy to clipboard button. This is a huge quality of life feature.
- **Somewhat functional mobile support**: There are some imperfections but most features are mobile-compatible (not quite mobile friendly per-say)

## Technology Stack
- **Ruby**: 3.3.5
- **Rails**: ~> 8.0.2
- **Database**: SQLite (shockingly good)
- **Frontend**: Hotwire (Turbo, Stimulus), Tailwind CSS
- **Containerization**: Docker
- **Job/Cache**: Solid Queue, Solid Cache, Solid Cable, Mission Control Jobs

## Prerequisites
- [Docker](https://www.docker.com/) (recommended for all environments)
- Or: Ruby 3.3.5, Node.js 20+, SQLite3, Yarn/NPM

## Getting Started

### 0. Try it out live!
Currently, this project is deployed at [christiansmith.live](https://christiansmith.live). Feel free to try it out without having to install anything locally!
NOTE: Please assume anything you put into the deployed instance is public information-- including your keys!! I have some basic security in place but that was a very low priority for this cloneathon so assume all your chats and keys are being read by someone. Provision an API key just for this tool and SET A BUDGET, to avoid someone spending on your key!

### 1. Clone the Repository
```bash
git clone github.com/Ymit24/t3-clone
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

MIT License.
