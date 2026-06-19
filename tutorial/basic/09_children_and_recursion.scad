// tutorial/basic/09_children_and_recursion.scad
// ==============================================
// 学习目标: 掌握 children() 子节点传递和递归建模
// children() 让你把子对象作为参数传给 module
// 递归 让你用简洁代码创建复杂分形结构

// ---- children() 基础 ----
module container() {
    difference() {
        // 外壳
        minkowski() {
            cube([30, 30, 8], center = true);
            cylinder(r = 3, h = 1, center = true);
        }

        // 掏空
        cube([24, 24, 10], center = true);

        // 底部开口
        translate([0, 0, -4]) cube([10, 24, 3], center = true);
    }

    // 在容器内放置任意子对象
    translate([0, 0, -2]) children();
}

module badge() {
    cylinder(r = 6, h = 2, center = true);
    translate([0, 0, 1]) cylinder(r = 4, h = 1, center = true);
}

// 容器内放徽章
translate([-40, 0, 0])
    container() {
        badge();
    }

// ---- children 索引 ----
module row(spacing) {
    // children(0) 的子对象按间距排列
    for (i = [0 : $children - 1]) {
        translate([i * spacing, 0, 0])
            children(i);
    }
}

translate([0, -30, 0])
    row(spacing = 20) {
        sphere(r = 6);
        cube([10, 10, 10], center = true);
        cylinder(r = 5, h = 12, center = true);
        // 嵌套 children!
        container() {
            sphere(r = 3);
        }
    }

// ---- 递归: 分形树 ----
module fractal_tree(depth, length, angle) {
    if (depth > 0) {
        // 树干
        rotate([0, 90, 0])
            cylinder(r = length / 10, h = length, center = true);

        // 左分支
        translate([0, 0, length / 2])
            rotate([0, angle, 0]) {
                fractal_tree(depth - 1, length * 0.7, angle);
            }

        // 右分支
        translate([0, 0, length / 2])
            rotate([0, -angle, 0]) {
                fractal_tree(depth - 1, length * 0.7, angle);
            }
    }
}

translate([40, 0, 15])
    fractal_tree(depth = 4, length = 30, angle = 30);

// ---- 递归: 希尔伯特曲线 (2D) ----
module hilbert(level, step) {
    if (level == 0) {
        // 什么都不做
    } else {
        rotate([0, 0, -90])
            hilbert(level - 1, step);
        translate([0, step, 0])
            children();
        rotate([0, 0, 90]) {
            translate([step, 0, 0])
                children();
            translate([0, step, 0]) {
                children();
                hilbert(level - 1, step);
            }
        }
    }
}
