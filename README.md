# OpenSCAD Learning 🧊

从零开始学习 [OpenSCAD](https://openscad.org/) —— 用代码构建 3D 模型。

## 目录结构

```
OpenSCAD_Learning/
├── tutorial/              # 入门教程（按难度递进）
│   ├── basic/             # 基础篇：基本体、变换、布尔运算、模块化
│   ├── intermediate/      # 进阶篇（待添加）
│   └── advanced/          # 高级篇（待添加）
├── examples/              # 独立示例集合
├── projects/              # 综合项目练习
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

### 🟡 进阶篇 `tutorial/intermediate/`

> 即将添加：线性/旋转挤出、多边形、hull、minkowski、投影、传参模块

### 🔴 高级篇 `tutorial/advanced/`

> 即将添加：递归结构、参数化设计、导入 SVG/DXF、动画、性能优化

## 资源

- [OpenSCAD 官方文档](https://openscad.org/documentation.html)
- [OpenSCAD Cheat Sheet](https://openscad.org/cheatsheet/)
- [OpenSCAD 用户手册 (中文)](https://github.com/openscad/openscad/wiki)

## License

MIT
