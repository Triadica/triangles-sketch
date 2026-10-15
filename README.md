# Chasm 3D Sketch

- Demo https://r.tiye.me/Triadica/chasm-3d-sketch/

> experiment for toying with 3D map

### Workflow

https://github.com/Triadica/triadica-workflow

### Development

Use Node.js 24 and the Calcit version declared in `deps.cirru`. The browser compiler and `@calcit/procs` are paired at 0.29.3; the system's 0.30.0 compiler is an additional source compatibility check, not a mixed-version browser runtime.

```sh
corepack enable
caps --strict --ci
yarn install --immutable
caps verify --toolchain
calcit calcit.cirru --check-only --all-defs
calcit calcit.cirru js
yarn vite
```

`calcit.cirru` is the only source snapshot; `compact.cirru` is retired. Touch-control CSS comes from the same Caps module as its code. Generated `js-out/` and `dist/` stay untracked.

CI uploads only frontend assets to COS, using the upload action's built-in verification. Pull requests use isolated asset prefixes and never publish the production page. Main retains the existing `/web-assets/repo/Triadica/triangles-sketch` deployment path.

### License

MIT
