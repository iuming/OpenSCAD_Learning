# OpenSCAD 速查表（中文注释版）

这份速查表面向从新手到高级用户：先看语法骨架，再查常用建模、调试和 3D 打印参数。所有示例都可直接复制到 `.scad` 文件中运行。

## 1. 文件结构建议

```scad
// 1) 全局精度：预览低、渲染高
$fn = $preview ? 32 : 96;

// 2) 可调参数（Customizer 会读取注释）
外径 = 30;      // [10:1:80]
高度 = 12;      // [2:1:50]
壁厚 = 2;       // [1:0.2:5]

// 3) 工具函数 / 模块
module 示例零件() { /* ... */ }

// 4) 最终装配
示例零件();
```

## 2. 基本体

| 语句 | 说明 | 常用写法 |
|---|---|---|
| `cube([x,y,z], center=true)` | 长方体 | 适合做实体块、切削块 |
| `sphere(r=10)` | 球体 | `$fn` 越高越圆 |
| `cylinder(r=5, h=20)` | 圆柱 | 可用 `d=` 直径参数 |
| `polyhedron(points, faces)` | 多面体 | 高级自定义网格 |
| `text("字", size=8)` | 2D 文字 | 需配合 `linear_extrude()` |

## 3. 变换顺序

OpenSCAD 从内向外执行：

```scad
translate([20,0,0])       // 最后平移
    rotate([0,0,45])      // 再旋转
        cube([10,4,2], center=true); // 先生成 cube
```

常用变换：

```scad
translate([x,y,z]) children();
rotate([rx,ry,rz]) children();
scale([sx,sy,sz]) children();
mirror([1,0,0]) children();
resize([20,10,5]) children();
offset(r=1) children();       // 2D 外扩/内缩
```

## 4. 布尔运算

```scad
union() { a(); b(); }         // 合并
difference() { body(); cut(); } // 从 body 中减去 cut
intersection() { a(); b(); }  // 只保留重叠部分
```

> 小技巧：切削体通常比目标体多伸出 `0.1~1 mm`，避免共面闪烁或非流形边。

## 5. 循环、条件、函数

```scad
for (i = [0:5]) translate([i*8,0,0]) cylinder(r=2,h=5);

if (show_lid) lid(); else box();

function clamp(x, lo, hi) = min(max(x, lo), hi);
```

## 6. 模块与 children()

```scad
module 四角阵列(dx, dy) {
    for (x=[-1,1], y=[-1,1])
        translate([x*dx/2, y*dy/2, 0]) children();
}

四角阵列(40, 20) cylinder(r=2, h=6);
```

## 7. 2D 到 3D

```scad
linear_extrude(height=5, twist=0, scale=1)
    circle(r=10);

rotate_extrude(angle=270)
    translate([20,0,0]) circle(r=3);

projection(cut=true)
    translate([0,0,-2]) cube([20,10,4], center=true);
```

## 8. 常用 3D 打印公差

| 用途 | 建议值（FDM） | 说明 |
|---|---:|---|
| 普通间隙配合 | 0.20–0.35 mm | 盒盖、滑槽、插拔件 |
| 活动关节间隙 | 0.35–0.60 mm | 一体打印铰链/转轴 |
| 压入配合 | -0.05–0.15 mm | 需按材料和机型测试 |
| 螺丝通孔 | 螺丝直径 + 0.3 mm | M3 通孔常用 3.2–3.4 mm |
| 热熔螺母孔 | 参考厂家尺寸 - 0.1 mm | 预留倒角更易安装 |

## 9. 调试符号

```scad
#cube([10,10,10]);   // 高亮显示，不参与布尔结果
%cube([10,10,10]);   // 半透明参考
*cube([10,10,10]);   // 临时禁用
!cube([10,10,10]);   // 只显示此对象
```

## 10. 命令行验证

```bash
openscad -o /tmp/model.stl your_file.scad
openscad --check-parameters true your_file.scad
```

如果模型复杂，先用 `F5` 预览确认形状，再用 `F6` CGAL 渲染导出 STL。