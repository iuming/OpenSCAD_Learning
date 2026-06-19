# OpenSCAD 学习路线图

这份路线图把仓库中的教程、示例和项目串成一条可执行路径。建议每学完一个阶段，都修改参数并导出一次 STL。

## 阶段 1：看懂代码造型

目标：理解 OpenSCAD 是“用代码描述几何”，不是拖拽建模。

1. `tutorial/basic/01_hello_cube.scad`：第一个立方体。
2. `tutorial/basic/02_basic_shapes.scad`：三种基本体。
3. `tutorial/basic/03_transformations.scad`：变换顺序。
4. `tutorial/basic/04_boolean_ops.scad`：用差集挖孔。
5. `cheatsheets/openscad_quick_reference.md`：查语法。

练习：做一个带圆孔的钥匙牌，修改长宽厚和孔径。

## 阶段 2：写可复用零件

目标：开始用变量、模块和循环写可复用结构。

1. `tutorial/basic/05_variables_modules.scad`：模块化。
2. `tutorial/basic/10_parametric_design.scad`：参数化思想。
3. `tutorial/basic/11_customizer_and_units.scad`：Customizer、单位、断言。
4. `examples/utilities.scad`：复用工具模块。

练习：写一个 `rounded_plate(width, depth, thickness, r)` 模块，生成不同尺寸圆角底板。

## 阶段 3：掌握 2D → 3D 工作流

目标：用 2D 轮廓拉伸、旋转、投影，快速做标牌、旋钮、面板。

1. `tutorial/basic/08_rotate_extrude.scad`：旋转体与线性拉伸。
2. `tutorial/intermediate/06_text_svg_projection.scad`：文字、投影、伪 SVG 工作流。
3. `examples/desktop_organizer.scad`：综合实物案例。

练习：做一块带凸字和沉头孔的铭牌。

## 阶段 4：为 3D 打印设计

目标：理解公差、壁厚、孔径、悬垂和打印方向。

1. `cheatsheets/3d_printing_design_rules.md`：设计规则速查。
2. `examples/calibration_test_suite.scad`：打印校准测试片。
3. `tutorial/advanced/05_print_ready_enclosure.scad`：完整外壳。
4. `examples/enclosure_with_fasteners.scad`：热熔螺母、螺丝柱、泪滴孔。

练习：打印校准测试，记录最合适的 clearance，再回填到自己的模型参数中。

## 阶段 5：机构与高级曲面

目标：学习螺纹、齿轮、铰链、轻量化和一体打印机构。

1. `tutorial/intermediate/02_screw_threads.scad`：螺纹。
2. `tutorial/intermediate/03_gears_and_mechanisms.scad`：齿轮机构。
3. `tutorial/intermediate/04_hinges_and_joints.scad`：铰链和球关节。
4. `tutorial/intermediate/07_lattice_and_lightweighting.scad`：蜂窝、格栅、减重。
5. `tutorial/advanced/06_print_in_place_mechanisms.scad`：一体打印机构。

练习：设计一个无需组装的可转动小夹子。

## 阶段 6：项目化建模

目标：把参数、模块、装配、动画和打印规则合并到真实项目。

1. `projects/parametric_vise.scad`：参数化台钳。
2. `projects/robotic_arm.scad`：机器人手臂。
3. `tutorial/advanced/01_animate_assembly.scad`：动画和爆炸视图。
4. `tutorial/advanced/04_csg_optimization.scad`：性能优化。

练习：把一个项目拆成 `参数区 / 工具模块 / 零件模块 / 装配模块` 四段，并加入 `explode` 参数显示爆炸图。

## 推荐学习节奏

- 每次只学一个 `.scad` 文件。
- 先运行原文件，再改 3 个参数。
- 看到 `difference()` 就找“被切的主体”和“切削工具”。
- 复杂模型先关掉细节，用 `$preview` 控制精度。
- 每个新结构先做 20–40 mm 的小样件，确认可打印再放大。