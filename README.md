# OpenSCAD Learning 🧊

从零开始学习 [OpenSCAD](https://openscad.org/) —— 用代码构建 3D 模型。

## 目录结构

```
OpenSCAD_Learning/
├── tutorial/              # 24 个教程（按难度递进）
│   ├── basic/             # 11 基础篇：基本体 → Customizer 参数化
│   ├── intermediate/      #  7 进阶篇：曲面、螺纹、齿轮、铰链、纹理、文字投影、轻量化
│   └── advanced/          #  6 高级篇：动画、数学艺术、放样、优化、外壳、一体打印机构
├── examples/              #  6 实用案例
├── projects/              #  2 综合项目
├── docs/                  # 学习路线与专题文档
├── cheatsheets/           # 速查表与 3D 打印规则
├── RUNNING.md              # 运行与导出说明
└── README.md
```

## 快速开始

1. 安装 OpenSCAD：
   - **Linux**：`dnf install openscad` / `apt install openscad`
   - **macOS**：`brew install openscad`
   - **Windows**：从 [openscad.org](https://openscad.org/downloads.html) 下载

2. 克隆仓库：
   ```bash
   git clone git@github.com:iuming/OpenSCAD_Learning.git
   ```

3. 打开任意 `.scad` 文件，按 `F5` 预览，按 `F6` 渲染导出。更多命令行导出方式见 `RUNNING.md`。


## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=iuming/OpenSCAD_Learning&type=Date)](https://www.star-history.com/#iuming/OpenSCAD_Learning&Date)

## 内容总览

| 难度 | 数量 | 涵盖主题 |
|------|------|----------|
| 🟢 基础 | 11 | 基本体、变换、布尔运算、模块化、hull/minkowski、拉伸、递归、参数化、Customizer |
| 🟡 进阶 | 7 | 贝塞尔曲面、ISO螺纹、渐开线齿轮、活动铰链、表面纹理、文字投影、轻量化 |
| 🔴 高级 | 6 | 动画装配、数学艺术、路径放样、性能优化、3D打印完整外壳、一体打印机构 |
| 🛠 示例 | 6 | 工具库、桌面收纳、卡扣盒子、一体轴承、校准测试、带紧固件外壳 |
| 🚀 项目 | 2 | 参数化台钳、四自由度机器人手臂 |
| 📚 文档/速查 | 3 | 学习路线、OpenSCAD 速查、3D 打印设计规则 |
| **合计** | **33** | |

## 学习路线

### 🟢 基础篇 `tutorial/basic/`

| 编号 | 文件 | 内容 |
|------|------|------|
| 01 | `hello_cube` | 第一个 3D 对象 |
| 02 | `basic_shapes` | 立方体、球体、圆柱体 |
| 03 | `transformations` | 平移、旋转、缩放 |
| 04 | `boolean_ops` | 并集、差集、交集 |
| 05 | `variables_modules` | 变量、循环、自定义模块 |
| 06 | `nameplate` | 综合练习：桌面名牌 |
| 07 | `hull_and_minkowski` | hull() 凸包与 minkowski() 膨胀 |
| 08 | `rotate_extrude` | rotate_extrude 与 linear_extrude 拉伸 |
| 09 | `children_and_recursion` | children 传递与递归建模（分形树） |
| 10 | `parametric_design` | 参数化设计（齿轮、盒子、条件装配） |
| 11 | `customizer_and_units` | Customizer 参数、单位换算、assert 参数检查 |

### 🟡 进阶篇 `tutorial/intermediate/`

| 编号 | 文件 | 内容 |
|------|------|------|
| 01 | `bezier_surfaces` | 贝塞尔曲线扫掠管与旋转面 |
| 02 | `screw_threads` | ISO 公制螺纹（螺栓 + 螺母 + 双头螺纹） |
| 03 | `gears_and_mechanisms` | 渐开线直齿轮、齿条、行星齿轮组 |
| 04 | `hinges_and_joints` | 活动铰链、门合页、球关节（含打印公差） |
| 05 | `surface_texture` | 菱形纹理、蜂窝面板、正弦涟漪表面 |
| 06 | `text_svg_projection` | 文字浮雕、内置 2D 图标、projection 轮廓投影 |
| 07 | `lattice_and_lightweighting` | 蜂窝减重、加强筋、轻量化安装板 |

### 🔴 高级篇 `tutorial/advanced/`

| 编号 | 文件 | 内容 |
|------|------|------|
| 01 | `animate_assembly` | `$t` 变量动画：爆炸视图、活塞运动、齿轮啮合 |
| 02 | `math_art` | 螺旋面、环面结、Sierpinski 金字塔、Fibonacci 球 |
| 03 | `bezier_loft` | 3D 路径扫掠 + 截面放样（花瓶、螺管） |
| 04 | `csg_optimization` | CSG 性能优化：`$preview`、`render()`、模块化装配 |
| 05 | `print_ready_enclosure` | 完整 3D 打印电子外壳（PCB座、散热、卡扣） |
| 06 | `print_in_place_mechanisms` | 一体打印机构、活动间隙、剪式连杆、铰链 |

### 🛠 实用示例 `examples/`

| 文件 | 内容 |
|------|------|
| `utilities.scad` | 通用工具库：测量标记、圆角盒、阵列、配合测试 |
| `desktop_organizer.scad` | 桌面收纳：笔筒 + 名片夹 + 手机架 |
| `snap_fit_box.scad` | 卡扣式盒子：无需螺丝的 snap-fit 设计 |
| `gear_bearing.scad` | 一体打印轴承：深沟球轴承 + 推力轴承 |
| `calibration_test_suite.scad` | 3D 打印校准：间隙、孔径、桥接、悬垂、薄壁 |
| `enclosure_with_fasteners.scad` | 带热熔螺母柱、泪滴孔、散热槽的电子外壳 |

### 🚀 综合项目 `projects/`

| 项目 | 内容 |
|------|------|
| `parametric_vise.scad` | 可参数化台钳：丝杆传动、燕尾导轨、爆炸视图 |
| `robotic_arm.scad` | 四自由度机器人手臂：舵机驱动、平行夹爪 |

### 📚 文档与速查

| 文件 | 内容 |
|------|------|
| `docs/learning_roadmap.md` | 分阶段学习路线和练习建议 |
| `cheatsheets/openscad_quick_reference.md` | OpenSCAD 语法、建模、调试速查 |
| `cheatsheets/3d_printing_design_rules.md` | FDM 壁厚、公差、孔径、悬垂、导出检查清单 |

## 🔗 学习路径建议

```
基础 01-06  →  掌握 OpenSCAD 核心语法
基础 07-11  →  进阶变换、参数化与 Customizer
进阶 01-07  →  工程级建模（螺纹、齿轮、铰链、纹理、文字、轻量化）
高级 01-06  →  前沿技术（动画、放样、优化、打印设计、一体打印机构）
示例 + 项目 →  实战应用
```

## 资源

- [OpenSCAD 官方文档](https://openscad.org/documentation.html)
- [OpenSCAD Cheat Sheet](https://openscad.org/cheatsheet/)
- [OpenSCAD 用户手册](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual)

## License

MIT
