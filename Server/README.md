# Local Screeps Server

This starter includes a Docker-based private server setup built around the `screepers/screeps-launcher` image.

## Requirements

- Docker Desktop or Docker Engine with Compose
- A Steam key for the Screeps private server

## Files

- `docker-compose.yml`: runs MongoDB, Redis, and `screeps-launcher`
- `screeps/config.example.yml`: starter launcher config
- `screeps/config.yml`: your local config copy with secrets and local tweaks

## First Run

Create your local launcher config:

```bash
cp Server/screeps/config.example.yml Server/screeps/config.yml
```

Edit `Server/screeps/config.yml` and set at least:

- `steamKey`
- any mods you want enabled
- any local bot packages you want mounted or installed

Start the server from the repository root:

```bash
docker compose -f Server/docker-compose.yml up -d
```

The Screeps web UI will be available at `http://127.0.0.1:21025`.

## Server Management

Open the launcher CLI:

```bash
docker compose -f Server/docker-compose.yml exec screeps screeps-launcher cli
```

Useful commands inside the CLI:

```text
system.resetAllData()
system.pauseSimulation()
system.resumeSimulation()
```

Useful launcher commands:

```bash
docker compose -f Server/docker-compose.yml exec screeps screeps-launcher apply
docker compose -f Server/docker-compose.yml exec screeps screeps-launcher backup
docker compose -f Server/docker-compose.yml exec screeps screeps-launcher upgrade
```

Stop the stack:

```bash
docker compose -f Server/docker-compose.yml down
```

## Deploy Your Bot To The Local Server

The root `screeps.sample.json` already includes a `pserver` target pointed at `127.0.0.1:21025`.

From the repository root:

```bash
cp screeps.sample.json screeps.json
```

Then update the `pserver` credentials in `screeps.json` to match your local server user and deploy with:

```bash
npm run push-pserver
```

For automatic rebuild and deploy while editing Swift code:

```bash
npm run watch-pserver
```
