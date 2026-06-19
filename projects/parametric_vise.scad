// projects/parametric_vise.scad
// ==============================================
// 项目: 可参数化台钳
// 3D 打印工作台迷你台钳
// 全部参数化,可调整尺寸、行程、夹持力

$fn = 40;

// ---- 参数 ----
vise_body_w    = 40;   // 钳体宽度
vise_body_l    = 100;  // 钳体长度
vise_body_h    = 15;   // 钳体高度
jaw_width      = 30;   // 钳口宽度
jaw_height     = 20;   // 钳口高度
jaw_opening    = 30;   // 最大开口

// 丝杆参数
screw_diameter = 6;
screw_pitch    = 1.5;
screw_length   = 60;

// 底座
base_width     = 50;
base_length    = 120;
base_thick     = 4;

// ---- 钳体 ----
module vise_body() {
    difference() {
        union() {
            // 主体
            cube([vise_body_w, vise_body_l, vise_body_h]);

            // 固定钳口
            translate([0, 0, vise_body_h])
                cube([vise_body_w, jaw_width, jaw_height]);

            // 燕尾导轨
            translate([0, 0, vise_body_h - 5])
                rotate([0, 90, 0])
                    linear_extrude(height = vise_body_w) {
                        polygon(points = [
                            [0, 0],
                            [vise_body_l - jaw_width * 2, 0],
                            [vise_body_l - jaw_width * 2 - 3, 3],
                            [3, 3],
                        ]);
                    }
        }

        // 丝杆孔
        translate([vise_body_w / 2, jaw_width / 2, vise_body_h / 2])
            rotate([0, 90, 0])
                cylinder(r = screw_diameter / 2 + 0.3,
                         h = vise_body_l + 20, center = true);

        // 丝杆螺母槽
        translate([vise_body_w / 2, vise_body_l - jaw_width * 1.5,
                   vise_body_h - 2])
            cube([screw_diameter + 3, screw_diameter + 3, 6],
                 center = true);

        // 减重槽
        for (y = [jaw_width + 5 : 15 : vise_body_l - jaw_width - 10]) {
            translate([vise_body_w / 2, y, vise_body_h / 2])
                cube([vise_body_w * 0.4, 8, vise_body_h * 0.5],
                     center = true);
        }

        // 安装孔
        for (pos = [[vise_body_w * 0.25, base_length * 0.15],
                     [vise_body_w * 0.75, base_length * 0.15],
                     [vise_body_w * 0.25, base_length * 0.85],
                     [vise_body_w * 0.75, base_length * 0.85]]) {
            translate([pos[0], pos[1], -1])
                cylinder(r = 2.5, h = base_thick + 3);
        }
    }
}

// ---- 活动钳口 ----
module movable_jaw() {
    translate([0, vise_body_l - jaw_width * 2 - 2, vise_body_h]) {
        union() {
            // 钳口体
            cube([vise_body_w, jaw_width, jaw_height]);

            // 燕尾滑块
            translate([0, jaw_width - 3, -5])
                rotate([0, 90, 0])
                    linear_extrude(height = vise_body_w) {
                        polygon(points = [
                            [0, 0],
                            [jaw_width - 3, 0],
                            [jaw_width, 3],
                            [3, 3],
                        ]);
                    }

            // 丝杆螺母座
            translate([vise_body_w / 2, jaw_width / 2, -5])
                difference() {
                    cube([12, 12, 10], center = true);
                    rotate([0, 90, 0])
                        cylinder(r = screw_diameter / 2 + 0.2,
                                 h = 14, center = true);
                }
        }
    }
}

// ---- 丝杆 ----
module lead_screw() {
    translate([vise_body_w / 2, jaw_width / 2, vise_body_h / 2]) {
        rotate([0, 90, 0]) {
            // 丝杆
            cylinder(r = screw_diameter / 2,
                     h = screw_length, center = true);

            // 螺纹(简化)
            for (z = [-screw_length / 2 : screw_pitch * 2 : screw_length / 2]) {
                translate([0, 0, z])
                    linear_extrude(height = screw_pitch, twist = 60) {
                        circle(r = screw_diameter / 2 + 1, $fn = 6);
                    }
            }

            // 手轮端
            translate([screw_length / 2 - 2, 0, 0])
                cylinder(r = screw_diameter * 2.5, h = 4);

            // 手柄
            for (a = [0, 90, 180, 270]) {
                translate([screw_length / 2, 0, 0])
                    rotate([0, a, 0])
                        translate([screw_diameter * 2.5, 0, 0])
                            cylinder(r = 2, h = 20, center = true);
            }
        }
    }
}

// ---- 底座 ----
module vise_base() {
    translate([0, 0, -base_thick])
        difference() {
            minkowski() {
                cube([base_width - 4, base_length - 4, base_thick - 1]);
                cylinder(r = 2, h = 1);
            }

            // 安装孔
            for (pos = [[base_width * 0.25, base_length * 0.15],
                         [base_width * 0.75, base_length * 0.15],
                         [base_width * 0.25, base_length * 0.85],
                         [base_width * 0.75, base_length * 0.85]]) {
                translate([pos[0], pos[1], -1])
                    cylinder(r = 2.5, h = base_thick + 3);
            }
        }
}

// ---- 组装展示 ----
module vise_assembly() {
    vise_base();
    vise_body();
    movable_jaw();
    lead_screw();
}

// 爆炸视图
explode = 0; // [0:Assembly, 1:Exploded]

if (explode == 0) {
    vise_assembly();
} else {
    vise_base();
    translate([0, 0, 20]) vise_body();
    translate([0, -20, 30]) movable_jaw();
    translate([0, 0, 60]) lead_screw();
}
