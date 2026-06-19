// tutorial/basic/10_parametric_design.scad
// ==============================================
// 学习目标: 掌握参数化建模技巧
// 使用全局变量、条件表达式、自定义参数实现灵活设计

// ---- 参数定义 (Customizer 友好) ----
// 齿轮参数
teeth        = 20;    // 齿数
pitch_radius = 30;    // 节圆半径
pressure_angle = 20;   // 压力角
height       = 8;     // 齿轮厚度
bore_radius  = 5;     // 轴孔半径
keyway_width = 2;     // 键槽宽

// ---- 渐开线齿轮模块 ----
module spur_gear(teeth, pr, pa, h, bore) {
    module involute_tooth() {
        // 简化渐开线齿形
        tooth_width = 2 * pr * sin(180 / teeth) / teeth * 0.8;
        intersection() {
            square([pr + 5, tooth_width * 2], center = true);
            circle(r = pr + 2);
        }
    }

    difference() {
        // 齿轮本体
        linear_extrude(height = h) {
            difference() {
                circle(r = pr + 3);

                // 切出齿槽
                for (i = [0 : teeth - 1]) {
                    rotate([0, 0, i * 360 / teeth])
                        scale([1, 0.6, 1])
                            circle(r = pr * 1.6 / teeth * 2);
                }
            }
        }

        // 轴孔
        cylinder(r = bore, h = h + 2, center = true);

        // 键槽
        translate([0, 0, 0])
            cube([bore * 2, keyway_width, h + 2], center = true);
    }
}

// ---- 参数化盒子 ----
module parametric_box(width, depth, height, wall, lid) {
    // lid = true 时输出盖子, false 时输出盒体
    if (lid) {
        // 盖子
        difference() {
            cube([width, depth, 3]);
            // 配合凸台
            translate([wall, wall, 0])
                cube([width - 2 * wall, depth - 2 * wall, 1]);
        }
    } else {
        // 盒体
        difference() {
            cube([width, depth, height]);
            translate([wall, wall, wall])
                cube([width - 2 * wall, depth - 2 * wall, height]);
        }
    }
}

// ---- 使用三元运算符的条件设计 ----
module conditional_stand(
    diameter,
    height,
    type = "simple"
// "simple", "feet", "slotted"
) {
    type_index = (type == "simple")  ? 0 :
                 (type == "feet")    ? 1 :
                 (type == "slotted") ? 2 : 0;

    // 主柱
    cylinder(r = diameter, h = height);

    if (type_index == 1) {
        // 三脚底座
        for (i = [0 : 2]) {
            rotate([0, 0, i * 120])
                translate([diameter * 0.5, 0, 0])
                    cylinder(r = diameter * 0.3, h = 2);
        }
    }

    if (type_index == 2) {
        // 开槽
        for (i = [0 : 3]) {
            rotate([0, 0, i * 90])
                translate([0, 0, height / 2])
                    cube([diameter * 2, 2, height / 3], center = true);
        }
    }
}

// ---- 阵列 ----
translate([-60, 40, 0])
    spur_gear(teeth, pitch_radius, pressure_angle, height, bore_radius);

translate([0, 40, 0])
    parametric_box(width = 30, depth = 20, height = 15, wall = 2, lid = false);

translate([40, 40, 0])
    parametric_box(width = 30, depth = 20, height = 15, wall = 2, lid = true);

translate([-60, -10, 0])
    conditional_stand(diameter = 8, height = 20, type = "simple");

translate([0, -10, 0])
    conditional_stand(diameter = 8, height = 20, type = "feet");

translate([40, -10, 0])
    conditional_stand(diameter = 8, height = 20, type = "slotted");
