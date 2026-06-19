// examples/enclosure_with_fasteners.scad
// ==============================================
// 电子外壳示例: 热熔螺母柱、沉头孔、泪滴孔、散热孔、卡扣定位
// 目标: 展示更接近真实 3D 打印产品的结构细节

$fn = $preview ? 32 : 96;

case_w = 90;
case_d = 58;
case_h = 24;
wall = 2.2;
clearance = 0.3;
corner_r = 5;

// ---- 2D 圆角矩形 ----
module rounded_rect_2d(w, d, r) {
    hull() {
        for (x = [-1,1], y = [-1,1])
            translate([x*(w/2-r), y*(d/2-r)]) circle(r=r);
    }
}

// ---- 泪滴孔: 适合水平打印，顶部不用支撑 ----
module teardrop_hole(d = 8, length = 20) {
    r = d/2;
    rotate([90,0,0])
        linear_extrude(height = length, center = true)
            union() {
                circle(r = r);
                polygon([[0,0], [r*cos(45), r*sin(45)], [-r*cos(45), r*sin(45)]]);
            }
}

// ---- 热熔螺母柱 ----
module heatset_boss(h = 8, outer_d = 8, insert_d = 4.2, insert_depth = 5) {
    difference() {
        cylinder(d = outer_d, h = h);
        translate([0,0,h-insert_depth]) cylinder(d = insert_d, h = insert_depth + 0.2);
        translate([0,0,-0.1]) cylinder(d = 2.6, h = h + 0.2);
    }
    // 四片小加强筋
    for (a = [0:90:270])
        rotate([0,0,a])
            translate([outer_d/2, -0.6, 0])
                cube([10, 1.2, h*0.75]);
}

// ---- 外壳下壳 ----
module bottom_case() {
    difference() {
        linear_extrude(height = case_h)
            rounded_rect_2d(case_w, case_d, corner_r);

        translate([0,0,wall])
            linear_extrude(height = case_h)
                rounded_rect_2d(case_w - 2*wall, case_d - 2*wall, max(1, corner_r-wall));

        // 侧面线缆泪滴孔
        translate([0, -case_d/2 - 0.1, 11]) teardrop_hole(d = 9, length = wall + 1);

        // 散热槽
        for (x = [-24:8:24])
            translate([x, case_d/2 - wall/2, 16])
                cube([4, wall + 1, 12], center = true);
    }

    // PCB 支撑柱 / 热熔螺母柱
    for (x = [-1,1], y = [-1,1])
        translate([x*(case_w/2-15), y*(case_d/2-13), wall])
            heatset_boss();

    // 盖子定位台阶
    translate([0,0,case_h-3])
        difference() {
            linear_extrude(height = 2)
                rounded_rect_2d(case_w - wall, case_d - wall, corner_r - 1);
            translate([0,0,-0.1])
                linear_extrude(height = 2.2)
                    rounded_rect_2d(case_w - 3*wall, case_d - 3*wall, corner_r - wall);
        }
}

// ---- 盖子 ----
module lid() {
    translate([0, 76, 0]) {
        difference() {
            linear_extrude(height = 4)
                rounded_rect_2d(case_w, case_d, corner_r);
            for (x = [-1,1], y = [-1,1])
                translate([x*(case_w/2-15), y*(case_d/2-13), -0.1])
                    cylinder(d = 3.4, h = 4.2);
        }

        // 与下壳配合的内唇，尺寸加入 clearance
        translate([0,0,-3])
            linear_extrude(height = 3)
                difference() {
                    rounded_rect_2d(case_w - 2*wall - clearance, case_d - 2*wall - clearance, corner_r - wall);
                    rounded_rect_2d(case_w - 4*wall, case_d - 4*wall, max(1, corner_r - 2*wall));
                }
    }
}

bottom_case();
lid();
