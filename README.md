# Chasm 3D Sketch

- Demo https://r.tiye.me/Triadica/chasm-3d-sketch/

> experiment for toying with 3D map

### Workflow

https://github.com/Triadica/triadica-workflow

### Development

使用者影响：CLI 与浏览器 `@calcit/procs` 配对正式 0.30.1，并同步已发布的 Space 0.0.44、Touch Control 0.0.32、Respo 0.16.124、UI 0.8.0、Alerts 0.10.57、JS-FFI 0.2.5（Quaternion 0.2.16 为传递依赖）。请重新安装整张图并重新生成 JS、完整刷新，不混用旧缓存。上游渲染/UI 升级不承诺逐像素相同。

本轮完整核对 43 个定义后保留原 Snapshot：既有 Option、Struct、数据解码和三处合法 `merge` 不做机械改写。场景、shader、状态与操作 adapter、HUD 和部署路径保持不变。原项目没有附带测试；全定义、完整 strict 与构建通过不能代替真实 WebGL、弹窗、拖点或触控验收，`List<Number>` 也不等于长度恰好为三的证明。上游开放几何输入合同仍见 [Space #67](https://github.com/Triadica/triadica-space/issues/67)，本轮不宣称已解决。

Use Node.js 24, Yarn 4.18.0 and the formal Calcit 0.30.1 declared in `deps.cirru`; do not compile a browser bundle with an unrelated system compiler.

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
