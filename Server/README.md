# Local Screeps Server

This starter includes a Docker-based private server setup built around the `screepers/screeps-launcher` image.

## Requirements

- Docker Desktop or Docker Engine with Compose
- A Steam key for the Screeps private server

## Apple Silicon

The `screepers/screeps-launcher` image is currently published as `linux/amd64`, so Docker Desktop on Apple Silicon needs to run it under emulation.
`Server/docker-compose.yml` already sets `platform: linux/amd64` for you.

## Files

- `docker-compose.yml`: runs MongoDB, Redis, `screeps-launcher`, and an optional `steamless-client`
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

## Optional Browser Client

If you want the newer browser-based Steam client proxy, this stack also includes an optional `steamless-client` service based on [`screepers/steamless-client`](https://github.com/screepers/steamless-client).

Before starting it, make the real Screeps `package.nw` file available inside `Server/steamless-client/package.nw`, or point `SCREEPS_NW_DIR` at the directory that already contains `package.nw`. The checked-in example file is only a placeholder so the expected filename is obvious; it is not usable by the client. You can export `SCREEPS_NW_DIR` in your shell, or put it in a local `.env` file next to `Server/docker-compose.yml`.

Example on macOS:

```bash
export SCREEPS_NW_DIR="$HOME/Library/Application Support/Steam/steamapps/common/Screeps"
```

Then start the browser client profile:

```bash
docker compose -f Server/docker-compose.yml --profile browser up -d
```

If `package.nw` is missing, the container now exits immediately with a clear error instead of failing later inside `steamless-client`.

The browser client will be available at `http://127.0.0.1:8080` and proxy your local Screeps server through `steamless-client`.

If you need to access it from another machine, set:

- `SCREEPS_PROXY_HOST=0.0.0.0`
- `SCREEPS_PROXY_PUBLIC_HOSTNAME=<your host or IP>`
- optionally `SCREEPS_PROXY_PORT=<custom port>`

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
