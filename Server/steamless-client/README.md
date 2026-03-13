Place the real Screeps `package.nw` in this directory to use the optional `steamless-client` Docker profile.

The compose file mounts this folder at `/steamless` inside the container and expects:

- `Server/steamless-client/package.nw`

`package.nw.example` is just a placeholder and documentation aid. Rename or copy your actual Steam `package.nw` to `package.nw`.

If you prefer to keep the game files somewhere else, set `SCREEPS_NW_DIR` to the directory that already contains `package.nw`.
