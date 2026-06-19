// tutorial/advanced/01_animate_assembly.scad
// ==============================================
// 学习目标: 使用 $t 变量创建动画装配演示
// OpenSCAD 动画: View → Animate (或 `open animation`)
// $t 从 0 到 1 循环变化

$fn = 40;

// ---- 爆炸视图装配 ----
module explode_view(
    explode_distance = 0,  // 0=装配, 1=完全展开
    rotation         = 0   // 旋转角度
) {
    // 底板
    color("gray")
        translate([0, 0, -5])
            cube([60, 40, 5], center = true);

    // 4 个螺丝 — 爆炸方向
    screw_positions = [
        [-25, -15], [25, -15], [-25, 15], [25, 15]
    ];
    for (pos = screw_positions) {
        translate([pos[0], pos[1], explode_distance * 15])
            color("silver")
                translate([0, 0, -2.5]) {
                    cylinder(r = 2, h = 20);
                    cylinder(r = 4, h = 3, $fn = 6);
                }
    }

    // 中间板
    color("steelblue", alpha = 0.7)
        translate([0, 0, explode_distance * 5])
            cube([50, 30, 5], center = true);

    // 齿轮轴
    translate([0, 0, explode_distance * 25]) {
        color("gold") {
            cylinder(r = 3, h = 25);
            // 齿轮
            translate([0, 0, 15])
                color("silver")
                    cylinder(r = 10, h = 4, $fn = 20);
        }
    }

    // 顶盖
    color("darkred", alpha = 0.5)
        translate([0, 0, explode_distance * 40])
            cube([45, 25, 3], center = true);
}

// ---- 活塞动画 ----
module piston_animation(
    crank_angle = 0  // 0-360 度
) {
    crank_r   = 12;
    rod_len   = 35;
    piston_r  = 10;
    piston_h  = 8;
    cylinder_h = 30;

    // 曲轴中心位置
    crank_x = crank_r * cos(crank_angle);
    crank_y = crank_r * sin(crank_angle);

    // 活塞位置 (几何约束)
    piston_y = crank_y + sqrt(rod_len * rod_len - crank_x * crank_x);

    // 气缸
    color("gray", alpha = 0.3)
        translate([0, 0, cylinder_h / 2])
            cube([piston_r * 2.2, piston_r * 2.2, cylinder_h],
                 center = true);

    // 活塞
    translate([0, piston_y, 0])
        color("orange")
            cylinder(r = piston_r, h = piston_h, center = true);

    // 连杆
    color("silver")
        hull() {
            translate([crank_x, crank_y, 0]) sphere(r = 2);
            translate([0, piston_y, 0])      sphere(r = 2);
        }

    // 曲轴
    color("gold")
        translate([0, 0, 0])
            cylinder(r = 3, h = piston_r * 0.8, center = true);

    // 飞轮
    color("darkgray")
        rotate_extrude(angle = 360) {
            translate([crank_r, 0, 0])
                square([3, 2], center = true);
        }
}

// ---- 齿轮啮合动画 ----
module gear_pair_animation() {
    teeth1 = 20;
    teeth2 = 12;
    module_g = 2;
    ratio = teeth2 / teeth1;

    // 齿轮 1 (主动)
    color("steelblue")
        rotate([0, 0, $t * 360]) {
            cylinder(r = teeth1 * module_g / 2, h = 6, $fn = teeth1 * 3);
            // 齿标记
            for (i = [0 : teeth1 - 1]) {
                rotate([0, 0, i * 360 / teeth1])
                    translate([teeth1 * module_g / 2, 0, 3])
                        cube([module_g, 1, 3], center = true);
            }
        }

    // 齿轮 2 (从动, 反向旋转)
    distance = (teeth1 + teeth2) * module_g / 2;
    translate([distance, 0, 0])
        color("darkred")
            rotate([0, 0, -$t * 360 / ratio + 180 / teeth1]) {
                cylinder(r = teeth2 * module_g / 2, h = 6,
                         $fn = teeth2 * 3);
                for (i = [0 : teeth2 - 1]) {
                    rotate([0, 0, i * 360 / teeth2])
                        translate([teeth2 * module_g / 2, 0, 3])
                            cube([module_g, 1, 3], center = true);
                }
            }
}

// ---- 场景选择 (使用 $t 切换) ----
// 使用 Customizer 可以选择不同演示
scene = 1; // [1:Explode View, 2:Piston, 3:Gear Pair]

if (scene == 1) {
    explode_view(explode_distance = $t, rotation = $t * 360);
} else if (scene == 2) {
    translate([0, -10, 0])
        piston_animation(crank_angle = $t * 360);
} else {
    translate([-20, 0, 0])
        gear_pair_animation();
}
