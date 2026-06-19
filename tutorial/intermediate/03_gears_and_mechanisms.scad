// tutorial/intermediate/03_gears_and_mechanisms.scad
// ==============================================
// 学习目标: 创建标准渐开线齿轮并组装运动机构
// 包括直齿轮、齿条、行星齿轮组

$fn = 60;

// ---- 完整的渐开线直齿轮 ----
module involute_gear(
    teeth         = 20,
    module        = 2,     // 模数 = 节圆直径/齿数
    height        = 8,
    pressure_angle = 20,
    backlash      = 0.05,
    bore          = 5,
    helix         = 0      // 斜齿轮螺旋角
) {
    // 基本尺寸
    pr = module * teeth / 2;       // 节圆半径
    ar = pr + module;              // 齿顶圆半径
    dr = pr - 1.25 * module;       // 齿根圆半径
    br = pr * cos(pressure_angle);  // 基圆半径

    // 齿厚 (考虑 backlash)
    tooth_thickness = module * PI / 2 - backlash;

    module tooth_profile() {
        // 渐开线齿廓
        intersection() {
            // 齿的外轮廓
            difference() {
                circle(r = ar + 0.5);
                circle(r = dr - 0.1);
            }

            // 齿形: 简化为梯形近似
            hull() {
                translate([pr, tooth_thickness / 2, 0])
                    circle(r = module * 0.3, $fn = 8);
                translate([ar, tooth_thickness * 0.3, 0])
                    circle(r = module * 0.1, $fn = 8);
                translate([pr, -tooth_thickness / 2, 0])
                    circle(r = module * 0.3, $fn = 8);
                translate([ar, -tooth_thickness * 0.3, 0])
                    circle(r = module * 0.1, $fn = 8);
            }
        }
    }

    difference() {
        union() {
            // 齿轮本体
            cylinder(r = dr, h = height);

            // 齿
            for (i = [0 : teeth - 1]) {
                rotate([0, 0, i * 360 / teeth])
                    linear_extrude(height = height)
                        tooth_profile();
            }
        }

        // 轴孔
        cylinder(r = bore, h = height + 1, center = true);

        // 减重孔
        for (i = [0 : 2]) {
            rotate([0, 0, i * 120])
                translate([pr * 0.6, 0, -1])
                    cylinder(r = pr * 0.2, h = height + 2,
                             $fn = 20);
        }

        // 键槽
        translate([0, 0, height / 2])
            cube([bore * 2, bore * 0.4, height + 1], center = true);
    }
}

// ---- 齿条 ----
module rack(
    teeth    = 15,
    module   = 2,
    height   = 6,
    width    = 10
) {
    pitch = PI * module;

    difference() {
        cube([pitch * teeth, width, height]);

        // 切齿
        for (i = [0 : teeth - 1]) {
            translate([i * pitch + pitch / 2, 0, height])
                rotate([-90, 0, 0])
                    cylinder(r = pitch * 0.3, h = width + 1,
                             center = true, $fn = 6);
        }
    }
}

// ---- 行星齿轮组 ----
module planetary_gear_set() {
    sun_teeth    = 20;
    planet_teeth = 12;
    ring_teeth   = sun_teeth + 2 * planet_teeth;
    mod          = 1.5;

    // 太阳轮 (输入)
    color("gold")
        involute_gear(teeth = sun_teeth, module = mod,
                      height = 5, bore = 3);

    // 行星轮 × 3
    for (i = [0 : 2]) {
        rotate([0, 0, i * 120])
            translate([(sun_teeth + planet_teeth) * mod / 2, 0, 0]) {
                color("silver")
                    involute_gear(teeth = planet_teeth, module = mod,
                                  height = 5, bore = 2);
            }
    }

    // 齿圈 (固定)
    color("gray", alpha = 0.3)
        difference() {
            cylinder(r = ring_teeth * mod / 2 + 3, h = 5);
            cylinder(r = ring_teeth * mod / 2 - 2, h = 6,
                     center = true);
        }
}

// ---- 展示 ----
// 齿轮啮合演示
translate([-60, 0, 0]) {
    involute_gear(teeth = 15, module = 2, height = 6, bore = 4);
    translate([(15 + 10) * 2 / 2, 0, 0])
        rotate([0, 0, 180 / 10])
            involute_gear(teeth = 10, module = 2, height = 6, bore = 3);
}

// 齿轮-齿条
translate([-10, -30, 0]) {
    involute_gear(teeth = 12, module = 2, height = 8, bore = 3);
    translate([-12 * 2 / 2, -12 * 2 / 2 - 0.5, 0])
        rotate([90, 0, 0])
            rack(teeth = 5, module = 2, height = 4, width = 6);
}

// 行星齿轮组
translate([30, -10, 0])
    planetary_gear_set();
