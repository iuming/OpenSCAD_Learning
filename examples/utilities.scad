// examples/utilities.scad
// ==============================================
// 通用工具库 — 可复用的辅助模块集合
// 在模型中使用: use <utilities.scad>

// ---- 测量辅助 ----
module center_mark(size = 5) {
    color("red") {
        cube([size, 0.4, 0.4], center = true);
        cube([0.4, size, 0.4], center = true);
        cube([0.4, 0.4, size], center = true);
    }
}

// ---- 圆角盒子 ----
module rounded_cube(size, r = 2, center = false) {
    translate(center ? [0, 0, 0] : size / 2)
        minkowski() {
            cube(size - [2 * r, 2 * r, r]);
            sphere(r = r);
        }
}

// ---- 圆角圆柱 ----
module rounded_cylinder(r, h, corner_r = 1) {
    minkowski() {
        cylinder(r = r - corner_r, h = h - corner_r);
        sphere(r = corner_r);
    }
}

// ---- 十字槽螺丝孔 ----
module phillips_screw_head(diameter, head_h, depth = 0.5) {
    difference() {
        cylinder(r = diameter / 2, h = head_h);

        // 十字槽
        translate([0, 0, head_h - depth])
            linear_extrude(height = depth + 0.1) {
                square([diameter * 0.7, diameter * 0.12], center = true);
                square([diameter * 0.12, diameter * 0.7], center = true);
            }
    }
}

// ---- 配合公差孔 ----
module clearance_hole(diameter, length, tolerance = 0.2) {
    cylinder(r = diameter / 2 + tolerance, h = length, center = true);
}

module press_fit_hole(diameter, length, interference = 0.1) {
    cylinder(r = diameter / 2 - interference, h = length, center = true);
}

// ---- 阵列工具 ----
module circular_array(n, radius, rotate = true) {
    for (i = [0 : n - 1]) {
        angle = i * 360 / n;
        rotate([0, 0, angle])
            translate([radius, 0, 0])
                if (rotate)
                    rotate([0, 0, -angle]) children();
                else
                    children();
    }
}

module rectangular_grid(nx, ny, spacing_x, spacing_y) {
    for (x = [0 : nx - 1]) {
        for (y = [0 : ny - 1]) {
            translate([
                (x - (nx - 1) / 2) * spacing_x,
                (y - (ny - 1) / 2) * spacing_y,
                0
            ]) children();
        }
    }
}

// ---- 配合间隙测试件 ----
module tolerance_test() {
    module test_pair(label, diameter, gap) {
        base_y = 0;
        translate([0, base_y, 0]) {
            text(label, size = 3, halign = "center");

            // 孔
            translate([-10, -15, 0]) {
                difference() {
                    cube([12, 12, 5]);
                    translate([6, 6, -1])
                        cylinder(r = diameter / 2 + gap / 2,
                                 h = 7, $fn = 30);
                }
            }

            // 轴
            translate([10, -15, 0])
                cylinder(r = diameter / 2, h = 5, $fn = 30);

            translate([0, base_y - 20, 0])
                children();
        }
    }

    test_pair("0.1", 8, 0.1) children();
    test_pair("0.2", 8, 0.2) children();
    test_pair("0.3", 8, 0.3) children();
}

// ---- 文本标签 ----
module label_plate(text_str, width, height, thickness) {
    difference() {
        minkowski() {
            cube([width - 4, height - 4, thickness - 1]);
            cylinder(r = 2, h = 1, $fn = 20);
        }

        translate([width / 2, height / 2, thickness - 0.6])
            linear_extrude(height = 0.8)
                text(text_str, size = height * 0.4,
                     halign = "center", valign = "center");
    }
}
