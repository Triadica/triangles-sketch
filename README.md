# Chasm 3D Sketch

- Demo https://r.tiye.me/Triadica/chasm-3d-sketch/

> experiment for toying with 3D map

### Workflow

https://github.com/Triadica/triadica-workflow

### Calcit 0.40.0 使用说明

请同时使用正式 Calcit 与 `@calcit/procs` 0.40.0，配套 Space 0.0.49、
Touch Control 0.0.39、Respo 0.19.5、UI 0.15.2、Alerts 0.14.2 和 JS FFI 0.2.13。
重装依赖并重新生成 JS。原画布、形状控件、颜色与删除弹窗的操作方式沿用原版。

新增业务操作时使用具名 `Op`。Space 的双参数回调仍接收拖点和游标事件，
Alerts 发出的旧状态事件在 Respo 入口解码后使用同一状态更新逻辑。

### 历史：Calcit 0.32.1

使用者影响：CLI 与浏览器 `@calcit/procs` 配对正式 0.32.1，使用已发布 Space 0.0.47、Touch Control 0.0.35、Respo 0.17.1、UI 0.9.0、Alerts 0.11.0-alpha.5、JS-FFI 0.2.9（传递 Quaternion 0.2.18、Reel 0.7.0-alpha.5、Router 0.9.0-alpha.4）。Alerts 图仍含预发布版本，不宣称整图均为正式版。请重新安装整张图并重新生成 JS、完整刷新，不混用旧缓存；上游渲染/UI 升级不承诺逐像素相同。

类型标注通过官方 formatter 迁移。Respo DOM 操作适配新版单 Enum 派发：列表状态、新建、复制、颜色与 focus 操作不再调用双参数派发；原 `respo-operation` 检查和 updater 字段解码保持，Space 三个拖点仍使用原双参数接口。`DispatchOp` 代表值仅为入口绑定真实开放 Enum 类型，不声明名义身份，也不是业务默认值；匿名 Alerts 状态事件仍经过原游标检查。三个弹窗点击回调显式声明派发函数及 Unit 返回，不用强转替代检查。

隐藏列表的 `if` 补上空文本分支，避免把隐式 nil 作为 UI 子节点。shader、数据模型、原 HUD 和部署路径保持；旧版本运行行为不以新版宏的行为倒推。原项目无附带测试，本轮全部 267 定义、完整 strict（passed 且 diagnostics 为空）、Caps/toolchain、immutable 和构建通过，本轮实际交互验收范围见下文，不将静态检查冒充所有 WebGL/拖点/触控验收。`List<Number>` 仍不证明长度为三；上游开放几何合同见 [Space #67](https://github.com/Triadica/triadica-space/issues/67)，本轮不宣称已解决。

使用 Node.js 24、Yarn 4.18.0 和 deps.cirru 当前声明的 Calcit 0.40.0；npm 解析遵循一小时发布等待，无单包豁免。保留原完整类型门禁，不添加强转、验证脚本、预算豁免或测试框架。移除冗余的 `--strict-types` 参数，0.32.1 默认即执行严格检查，没有关闭严格诊断。

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

最新精确 Alerts alpha.5 已移除 alert `.show` 的旧 Optional 参数并加强部分 schema；本站只调用 Modal 的 `.show`，通过原全定义/完整 strict 验证，不用类型断言兼容旧接口。其正式依赖图尚未发布对应 Alerts 正式版，保留准确 alpha 声明，不用本地候选冒充发布 tag。

### 本轮实际验收

使用精确官方 0.32.1、最新已发布 Alerts alpha.5 的真实九模块 Caps 图；全 267 定义、42 个公开定义、完整 strict（diagnostics=[]）、工具链配对、immutable、canonical 与 JS/Vite 构建通过。原项目无附属测试，未新增重复框架或门禁例外。相对前一迁移候选，42 个完整官方定义视图相同，本轮只更新发布依赖及说明。

隔离 IAB 实际验证 WebGL 画面、List 显隐、Add、Duplicate、focus 切换；点击 `ColorType:` 打开颜色弹窗，分别应用颜色 4/2 到两个图形，`color!` 按原语义只更新选中图形。`more...` 弹窗打开/关闭、一个 Space 控制点拖动和刷新回初始 ColorType 0 均正常，warning/error 为空。未点击删除操作，未验收全部触控、所有拖点、设备性能或持久化，不把这些检查扩大为完整几何向量合同证明。独立只读评审确认单 Enum 桥接保留游标/状态，原 Space 双参入口不变。

旧匿名 Enum 槽证明问题已有上游 [Calcit #2447](https://github.com/calcit-lang/calcit/issues/2447) 跟踪修复，不新增重复 issue 或项目专用编译器规则。当前 `DispatchOp` 是诚实的开放 Enum 合同，不伪装封闭业务操作或放宽为 Dynamic。原 CI 的精确提交验收结果在迁移 PR 更新。

### License

MIT
