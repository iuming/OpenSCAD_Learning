// tutorial/advanced/06_print_in_place_mechanisms.scad
// ==============================================
// 学习目标: 设计一体打印(print-in-place)机构
// 重点: 间隙、桥接、倒角、打印方向和防粘连设计
// 提醒: 不同打印机公差差异很大，先打印小样件再做大机构

$fn = $preview ? 32 : 96;

clearance = 0.45;        // 活动间隙，FDM 常用 0.35-0.60 mm
pin_d = 6;
link_w = 12;
link_t = 5;
link_len = 42;
show_cutaway = false;    // true 时切开一半，观察内部间隙

// ---- 圆角连杆 ----
module link(length = link_len, width = link_w, thick = link_t, hole_d = pin_d + 2*clearance) {
    difference() {
        hull() {
            translate([-length/2, 0, 0]) cylinder(d = width, h = thick, center = true);
            translate([ length/2, 0, 0]) cylinder(d = width, h = thick, center = true);
        }
        for (x = [-length/2, length/2])
            translate([x, 0, 0])
                cylinder(d = hole_d, h = thick + 1, center = true);
    }
}

// ---- 一体打印转轴: 内轴和外环之间保留 clearance ----
module print_in_place_hinge() {
    difference() {
        union() {
            // 中间活动轴
            cylinder(d = pin_d, h = 34, center = true);

            // 两侧叉耳
            for (z = [-12, 12])
                translate([0, 0, z])
                    difference() {
                        cylinder(d = pin_d + 2*clearance + 6, h = 8, center = true);
                        cylinder(d = pin_d + 2*clearance, h = 9, center = true);
                    }

            // 中间连接耳，和内轴相连
            translate([0, 0, 0])
                cylinder(d = pin_d + 4, h = 8, center = true);
        }

        // 轴向释放槽，减少首层粘连面积
        for (a = [0, 180])
            rotate([0, 0, a])
                translate([0, pin_d/2 + clearance/2, 0])
                    cube([pin_d + 8, clearance, 36], center = true);

        if (show_cutaway)
            translate([-20, -20, -25]) cube([40, 20, 50]);
    }
}

// ---- 剪式连杆机构演示 ----
module scissor_demo(angle = 28) {
    color("lightgray")
        rotate([0, 0, angle]) link();
    color("silver")
        rotate([0, 0, -angle]) link();

    // 三个一体打印铰点
    color("orange") {
        cylinder(d = pin_d, h = link_t + 2, center = true);
        for (x = [-link_len/2*cos(angle), link_len/2*cos(angle)])
            translate([x, 0, 0])
                cylinder(d = pin_d, h = link_t + 2, center = true);
    }
}

// ---- 间隙测试梳，帮助选择 clearance ----
module clearance_comb() {
    translate([0, -38, 0]) {
        for (i = [0:4]) {
            gap = 0.25 + i * 0.1;
            translate([i*18 - 36, 0, 0]) {
                difference() {
                    cube([14, 14, 5], center = true);
                    cylinder(d = pin_d + 2*gap, h = 6, center = true);
                }
                translate([0, -10, 0])
                    linear_extrude(height = 0.6)
                        text(str(gap, "mm"), size = 3, halign = "center");
            }
        }
    }
}

translate([-38, 20, link_t/2]) scissor_demo(angle = 25 + 20*$t);
translate([45, 20, 17]) rotate([90,0,0]) print_in_place_hinge();
clearance_comb();
