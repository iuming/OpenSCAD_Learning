# OpenSCAD Learning 🧊

从零开始学习 [OpenSCAD](https://openscad.org/) —— 用代码构建 3D 模型。

## 目录结构

```
OpenSCAD_Learning/
├── tutorial/              # 20 个教程（按难度递进）
│   ├── basic/             # 10 基础篇：基本体 → 参数化设计
│   ├── intermediate/      #  5 进阶篇：贝塞尔曲面、螺纹、齿轮、铰链、纹理
│   └── advanced/          #  5 高级篇：动画装配、数学艺术、路径放样、性能优化、3D打印外壳
├── examples/              #  3 实用案例
├── projects/              #  2 综合项目
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

3. 打开任意 `.scad` 文件，按 `F5` 预览，按 `F6` 渲染导出。

## 内容总览

| 难度 | 数量 | 涵盖主题 |
|------|------|----------|
| 🟢 基础 | 10 | 基本体、变换、布尔运算、模块化、hull/minkowski、拉伸、递归、参数化 |
| 🟡 进阶 | 5 | 贝塞尔曲面、ISO螺纹、渐开线齿轮、活动铰链、表面纹理 |
| 🔴 高级 | 5 | 动画装配、数学艺术、路径放样、性能优化、3D打印完整外壳 |
| 🛠 示例 | 3 | 工具库、桌面收纳、卡扣盒子、一体轴承 |
| 🚀 项目 | 2 | 参数化台钳、四自由度机器人手臂 |
| **合计** | **25** | |

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

### 🟡 进阶篇 `tutorial/intermediate/`

| 编号 | 文件 | 内容 |
|------|------|------|
| 01 | `bezier_surfaces` | 贝塞尔曲线扫掠管与旋转面 |
| 02 | `screw_threads` | ISO 公制螺纹（螺栓 + 螺母 + 双头螺纹） |
| 03 | `gears_and_mechanisms` | 渐开线直齿轮、齿条、行星齿轮组 |
| 04 | `hinges_and_joints` | 活动铰链、门合页、球关节（含打印公差） |
| 05 | `surface_texture` | 菱形纹理、蜂窝面板、正弦涟漪表面 |

### 🔴 高级篇 `tutorial/advanced/`

| 编号 | 文件 | 内容 |
|------|------|------|
| 01 | `animate_assembly` | `$t` 变量动画：爆炸视图、活塞运动、齿轮啮合 |
| 02 | `math_art` | 螺旋面、环面结、Sierpinski 金字塔、Fibonacci 球 |
| 03 | `bezier_loft` | 3D 路径扫掠 + 截面放样（花瓶、螺管） |
| 04 | `csg_optimization` | CSG 性能优化：`$preview`、`render()`、模块化装配 |
| 05 | `print_ready_enclosure` | 完整 3D 打印电子外壳（PCB座、散热、卡扣） |

### 🛠 实用示例 `examples/`

| 文件 | 内容 |
|------|------|
| `utilities.scad` | 通用工具库：测量标记、圆角盒、阵列、配合测试 |
| `desktop_organizer.scad` | 桌面收纳：笔筒 + 名片夹 + 手机架 |
| `snap_fit_box.scad` | 卡扣式盒子：无需螺丝的 snap-fit 设计 |
| `gear_bearing.scad` | 一体打印轴承：深沟球轴承 + 推力轴承 |

### 🚀 综合项目 `projects/`

| 项目 | 内容 |
|------|------|
| `parametric_vise.scad` | 可参数化台钳：丝杆传动、燕尾导轨、爆炸视图 |
| `robotic_arm.scad` | 四自由度机器人手臂：舵机驱动、平行夹爪 |

## 🔗 学习路径建议

```
基础 01-06  →  掌握 OpenSCAD 核心语法
基础 07-10  →  进阶变换与参数化设计
进阶 01-05  →  工程级建模（螺纹、齿轮、铰链、纹理）
高级 01-05  →  前沿技术（动画、放样、优化、打印设计）
示例 + 项目 →  实战应用
```

## 资源

- [OpenSCAD 官方文档](https://openscad.org/documentation.html)
- [OpenSCAD Cheat Sheet](https://openscad.org/cheatsheet/)
- [OpenSCAD 用户手册](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual)

## License

MIT
