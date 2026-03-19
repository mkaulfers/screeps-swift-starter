# Local Screeps Server

This starter includes a Docker-based private server setup built around [`Jomik/screeps-server`](https://github.com/Jomik/screeps-server).

## Requirements

- Docker Desktop or Docker Engine with Compose
- A Steam key for the Screeps private server

## Files

- `docker-compose.yml`: runs MongoDB, Redis, `Jomik/screeps-server`, and an optional `steamless-client`
- `.env.example`: starter environment file for `STEAM_KEY` and optional proxy overrides
- `screeps/config.example.yml`: starter server config
- `screeps/config.yml`: your local config copy with mods and launcher options

## First Run

Create your local server config and env file:

```bash
cp Server/screeps/config.example.yml Server/screeps/config.yml
cp Server/.env.example Server/.env
```

Edit `Server/.env` and set:

- `STEAM_KEY`

Then edit `Server/screeps/config.yml` and adjust:

- enabled mods
- any bots you want installed automatically
- launcher options such as `autoUpdate` and `logConsole`

Start the server from the repository root:

```bash
docker compose --env-file Server/.env -f Server/docker-compose.yml up -d
```

The Screeps web UI will be available at `http://127.0.0.1:21025`.

## Optional Browser Client

If you want the newer browser-based Steam client proxy, this stack also includes an optional `steamless-client` service based on [`screepers/steamless-client`](https://github.com/screepers/steamless-client).

Before starting it, make the real Screeps `package.nw` file available inside `Server/steamless-client/package.nw`, or point `SCREEPS_NW_DIR` at the directory that already contains `package.nw`. The checked-in example file is only a placeholder so the expected filename is obvious; it is not usable by the client. You can export `SCREEPS_NW_DIR` in your shell, or add it to `Server/.env`.

Example on macOS:

```bash
export SCREEPS_NW_DIR="$HOME/Library/Application Support/Steam/steamapps/common/Screeps"
```

Then start the browser client profile:

```bash
docker compose --env-file Server/.env -f Server/docker-compose.yml --profile browser up -d
```

If `package.nw` is missing, the container now exits immediately with a clear error instead of failing later inside `steamless-client`.

The browser client will be available at `http://127.0.0.1:8080` and proxy your local Screeps server through `steamless-client`.

If you need to access it from another machine, set:

- `SCREEPS_PROXY_HOST=0.0.0.0`
- `SCREEPS_PROXY_PUBLIC_HOSTNAME=<your host or IP>`
- optionally `SCREEPS_PROXY_PORT=<custom port>`

## Server Management

This setup no longer uses the old `screeps-launcher` CLI. Manage mods through `Server/screeps/config.yml`, then restart the service to apply config changes:

```bash
docker compose --env-file Server/.env -f Server/docker-compose.yml restart screeps
```

Useful operational commands:

```bash
docker compose --env-file Server/.env -f Server/docker-compose.yml logs -f screeps
docker compose --env-file Server/.env -f Server/docker-compose.yml ps
```

Stop the stack:

```bash
docker compose --env-file Server/.env -f Server/docker-compose.yml down
```

Remove all persisted private-server data and start over:

```bash
docker compose --env-file Server/.env -f Server/docker-compose.yml down -v
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
