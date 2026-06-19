// examples/calibration_test_suite.scad
// ==============================================
// 3D 打印校准测试套件
// 覆盖: 间隙、孔径、桥接、悬垂、文字、薄壁
// 用法: 打印后记录实际效果，把结果用于自己的 OpenSCAD 参数

$fn = 48;

// ---- 间隙测试 ----
module clearance_test() {
    for (i = [0:5]) {
        gap = 0.15 + i * 0.1;
        translate([i*18, 0, 0]) {
            difference() {
                cube([14, 14, 5], center = true);
                cylinder(d = 8 + 2*gap, h = 6, center = true);
            }
            translate([0, -10, 2.6])
                linear_extrude(height = 0.5)
                    text(str(gap), size = 3, halign = "center");
        }
    }
}

// ---- 孔径测试 ----
module hole_size_test() {
    translate([0, 25, 0]) {
        difference() {
            cube([110, 20, 5], center = true);
            for (i = [0:7])
                translate([i*13 - 45.5, 0, 0])
                    cylinder(d = 2 + i*0.5, h = 6, center = true);
        }
        for (i = [0:7])
            translate([i*13 - 45.5, -8, 2.6])
                linear_extrude(height = 0.4)
                    text(str(2 + i*0.5), size = 2.5, halign = "center");
    }
}

// ---- 桥接测试 ----
module bridge_test() {
    translate([0, 55, 0]) {
        for (i = [0:4]) {
            span = 10 + i*8;
            translate([i*24 - 48, 0, 0]) {
                cube([3, 10, 12]);
                translate([span, 0, 0]) cube([3, 10, 12]);
                translate([0, 0, 12]) cube([span+3, 10, 2]);
                translate([span/2, -4, 14.2])
                    linear_extrude(height = 0.4)
                        text(str(span, "mm"), size = 3, halign = "center");
            }
        }
    }
}

// ---- 悬垂角测试 ----
module overhang_test() {
    translate([-55, 90, 0]) {
        for (i = [0:4]) {
            angle = 30 + i*10;
            translate([i*18, 0, 0]) {
                rotate([0, angle, 0]) cube([18, 8, 3]);
                cube([3, 8, 12]);
                translate([0, -6, 0])
                    linear_extrude(height = 0.4)
                        text(str(angle), size = 3, halign = "center");
            }
        }
    }
}

// ---- 薄壁测试 ----
module thin_wall_test() {
    translate([45, 92, 0]) {
        for (i = [0:4]) {
            wall = 0.4 + i*0.2;
            translate([i*8, 0, 0]) {
                cube([wall, 18, 12]);
                translate([0, -6, 12])
                    linear_extrude(height = 0.4)
                        text(str(wall), size = 2.5, halign = "center");
            }
        }
    }
}

clearance_test();
hole_size_test();
bridge_test();
overhang_test();
thin_wall_test();
