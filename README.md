# Chasm 3D Sketch

- Demo https://r.tiye.me/Triadica/chasm-3d-sketch/

> experiment for toying with 3D map

### Workflow

https://github.com/Triadica/triadica-workflow

### Development

使用者影响：CLI 与浏览器 `@calcit/procs` 配对正式 0.32.1，使用已发布 Space 0.0.47、Touch Control 0.0.35、Respo 0.17.1、UI 0.9.0、Alerts 0.11.0-alpha.4、JS-FFI 0.2.9（传递 Quaternion 0.2.18、Feather 0.5.0-alpha.6、Reel 0.7.0-alpha.5、Router 0.9.0-alpha.4）。Alerts 图仍含预发布版本，不宣称整图均为正式版。请重新安装整张图并重新生成 JS、完整刷新，不混用旧缓存；上游渲染/UI 升级不承诺逐像素相同。

类型标注通过官方 formatter 迁移。Respo DOM 操作适配新版单 Enum 派发：列表状态、新建、复制、颜色与 focus 操作不再调用双参数派发；原 `respo-operation` 检查和 updater 字段解码保持，Space 三个拖点仍使用原双参数接口。`DispatchOp` 代表值仅为入口绑定真实开放 Enum 类型，不声明名义身份，也不是业务默认值；匿名 Alerts 状态事件仍经过原游标检查。三个弹窗点击回调显式声明派发函数及 Unit 返回，不用强转替代检查。

隐藏列表的 `if` 补上空文本分支，避免把隐式 nil 作为 UI 子节点。shader、数据模型、原 HUD 和部署路径保持；旧版本运行行为不以新版宏的行为倒推。原项目无附带测试，本轮全部 267 定义、完整 strict（passed 且 diagnostics 为空）、Caps/toolchain、immutable 和构建通过，实际交互验收仍待完成，不将静态检查冒充 WebGL/弹窗/拖点/触控验收。`List<Number>` 仍不证明长度为三；上游开放几何合同见 [Space #67](https://github.com/Triadica/triadica-space/issues/67)，本轮不宣称已解决。

使用 Node.js 24、Yarn 4.18.0 和 deps.cirru 声明的 Calcit 0.32.1；npm 解析遵循一小时发布等待，无单包豁免。保留原完整类型门禁，不添加强转、验证脚本、预算豁免或测试框架。已退役的 `--strict-types` 标志改为当前默认严格检查，没有关闭严格诊断。

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
