// tutorial/basic/07_hull_and_minkowski.scad
// ==============================================
// 学习目标: 掌握 hull() 和 minkowski() 变换
// hull()   — 凸包,连接多个对象的最小凸形状
// minkowski() — 闵可夫斯基和,形状"膨胀"

// ---- hull() 示例 ----
module hull_demo() {
    // 用 hull 创建连接两个球体的哑铃
    translate([-15, 0, 0]) {
        hull() {
            sphere(r = 8);
            translate([30, 0, 0]) sphere(r = 8);
        }

        // 两端装饰球
        sphere(r = 8);
        translate([30, 0, 0]) sphere(r = 8);
    }

    // hull 连接多个点,创建不规则形状
    translate([15, -25, 0]) {
        hull() {
            translate([0, 5, 0])  cube([25, 3, 3], center = true);
            translate([10, -5, 0]) cube([3, 3, 15], center = true);
            translate([-10, 0, 0]) cylinder(r = 3, h = 3, center = true);
        }
    }
}

// ---- minkowski() 示例 ----
module minkowski_demo() {
    // 圆角立方体: minkowski(cube, sphere)
    translate([0, 20, 0])
        minkowski() {
            cube([18, 18, 18], center = true);
            sphere(r = 3);
        }

    // 圆角圆柱体
    translate([0, -20, 0])
        minkowski() {
            cylinder(r = 8, h = 15, center = true);
            sphere(r = 2);
        }
}

// ---- 综合应用: 创建连接器 ----
module connector() {
    translate([40, 0, 0]) {
        // 方形到圆形的过渡
        hull() {
            // 方形底座
            translate([0, 0, -15]) cube([20, 20, 3], center = true);
            // 圆形顶部
            translate([0, 0, 15]) cylinder(r = 8, h = 3, center = true);
        }

        // 顶部法兰 (minkowski 圆角)
        translate([0, 0, 18])
            minkowski() {
                cube([20, 20, 2], center = true);
                cylinder(r = 2, h = 1, center = true);
            }
    }
}

hull_demo();
minkowski_demo();
connector();
