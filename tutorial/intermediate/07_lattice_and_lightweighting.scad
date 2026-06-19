// tutorial/intermediate/07_lattice_and_lightweighting.scad
// ==============================================
// 学习目标: 设计减重孔、蜂窝格栅、加强筋和可打印轻量化结构
// 重点: 减重不等于削弱，保留边框和受力路径很重要

$fn = $preview ? 24 : 64;

plate_w = 100;
plate_d = 55;
plate_t = 4;
wall = 4;
cell_r = 4;
cell_gap = 10;

// ---- 2D 六边形 ----
module hex_2d(r = 5) {
    polygon([for (i = [0:5]) [r*cos(60*i + 30), r*sin(60*i + 30)]]);
}

// ---- 蜂窝孔阵列 ----
module honeycomb_cuts(w, d, r, gap) {
    nx = floor(w / gap);
    ny = floor(d / (gap * 0.86));

    for (ix = [-nx:nx], iy = [-ny:ny]) {
        x = ix * gap + (iy % 2) * gap/2;
        y = iy * gap * 0.86;
        if (abs(x) < w/2 - wall - r && abs(y) < d/2 - wall - r)
            translate([x, y, -0.2])
                linear_extrude(height = plate_t + 0.4)
                    hex_2d(r = r);
    }
}

// ---- 加强筋 ----
module rib(length = 70, height = 12, thick = 1.4) {
    rotate([90, 0, 0])
        linear_extrude(height = thick, center = true)
            polygon([[0,0], [length,0], [0,height]]);
}

// ---- 轻量化安装板 ----
module lightweight_plate() {
    difference() {
        // 主体板
        cube([plate_w, plate_d, plate_t], center = true);

        // 蜂窝减重孔
        honeycomb_cuts(plate_w, plate_d, cell_r, cell_gap);

        // 四个安装孔
        for (x = [-1,1], y = [-1,1])
            translate([x*(plate_w/2-10), y*(plate_d/2-10), 0])
                cylinder(d = 4.2, h = plate_t + 1, center = true);
    }

    // 顶部边缘加强梁
    translate([0, plate_d/2 - 2, plate_t/2]) cube([plate_w, 3, 3], center = true);
    translate([0, -plate_d/2 + 2, plate_t/2]) cube([plate_w, 3, 3], center = true);

    // 三角加强筋示例
    for (x = [-1, 1])
        translate([x*20, 0, plate_t/2])
            rib(length = 28, height = 12, thick = 1.2);
}

// ---- 旁边展示单个蜂窝单元，便于理解 ----
module cell_demo() {
    translate([0, 45, 0]) {
        color("gold") linear_extrude(height = 2) hex_2d(r = cell_r);
        translate([0, -12, 0])
            linear_extrude(height = 0.8)
                text("六边形孔抗弯效率高", size = 4, halign = "center");
    }
}

lightweight_plate();
cell_demo();
