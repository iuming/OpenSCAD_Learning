// tutorial/advanced/05_print_ready_enclosure.scad
// ==============================================
// 学习目标: 设计可用于 3D 打印的完整电子产品外壳
// 焦点: FDM 打印约束、PCB 安装、散热、走线

$fn = 50;

// ---- 打印约束参数 ----
wall_thickness   = 2.0;   // 壁厚 (≥ 喷嘴直径 × 2)
floor_thickness  = 2.0;   // 底板厚度
tolerance        = 0.3;   // 装配公差
corner_radius    = 4.0;   // 圆角半径(避免应力集中)

// ---- 电路板参数 ----
pcb_width     = 50;
pcb_depth     = 35;
pcb_thickness = 1.6;
pcb_clearance = 3.0;   // 底部走线空间


// ---- 全局展示尺寸（与 enclosure_base()/enclosure_lid() 内部计算保持一致） ----
inner_w = pcb_width  + 2 * tolerance;
inner_d = pcb_depth  + 2 * tolerance;
outer_w = inner_w + 2 * wall_thickness;
outer_d = inner_d + 2 * wall_thickness;

// ---- 圆角盒子 (minkowski 方法) ----
module rounded_box(w, d, h, r) {
    minkowski() {
        cube([w - 2 * r, d - 2 * r, h - r], center = true);
        sphere(r = r);
    }
}

// ---- 外壳 ----
module enclosure_base(ventilation = true) {
    inner_w = pcb_width  + 2 * tolerance;
    inner_d = pcb_depth  + 2 * tolerance;
    inner_h = floor_thickness + pcb_clearance + pcb_thickness + 15;

    outer_w = inner_w + 2 * wall_thickness;
    outer_d = inner_d + 2 * wall_thickness;
    outer_h = inner_h + floor_thickness;

    difference() {
        // 外壳毛坯
        linear_extrude(height = outer_h) {
            difference() {
                offset(r = corner_radius)
                    square([outer_w - 2 * corner_radius,
                            outer_d - 2 * corner_radius], center = true);

                // 倒角外形 (可选)
                offset(r = corner_radius - 1)
                    square([outer_w - 2 * corner_radius + 2,
                            outer_d - 2 * corner_radius + 2], center = true);
            }
        }

        // 掏空内部
        translate([0, 0, floor_thickness]) {
            rounded_box(inner_w, inner_d, inner_h + 1, 1.5);

            // PCB 槽
            translate([0, 0, pcb_clearance])
                cube([pcb_width, pcb_depth, inner_h], center = true);
        }

        // PCB 安装柱
        pcb_mount_points();

        // 散热孔
        if (ventilation) {
            vent_pattern(outer_w, outer_d);
        }

        // 接线开口
        connector_cutouts(outer_w, outer_d);
    }

    // PCB 安装柱
    module pcb_mount_points() {
        mount_h = pcb_clearance;
        mount_r = 3;
        hole_r  = 1.5;

        positions = [
            [-pcb_width / 2 + 3, -pcb_depth / 2 + 3],
            [ pcb_width / 2 - 3, -pcb_depth / 2 + 3],
            [-pcb_width / 2 + 3,  pcb_depth / 2 - 3],
            [ pcb_width / 2 - 3,  pcb_depth / 2 - 3],
        ];

        for (pos = positions) {
            translate([pos[0], pos[1], floor_thickness])
                difference() {
                    cylinder(r = mount_r, h = mount_h);
                    cylinder(r = hole_r, h = mount_h + 1,
                             center = true);
                }
        }
    }

    // 散热通风
    module vent_pattern(w, d) {
        vent_w = 2;
        vent_spacing = 5;
        n_vents = floor((w - 10) / vent_spacing);

        for (x = [0 : n_vents - 1]) {
            x_pos = -w / 2 + 10 + x * vent_spacing;
            for (side = [-1, 1]) {
                translate([x_pos, side * (d / 2 - 5),
                            floor_thickness + 10])
                    rotate([0, 90, 0])
                        cylinder(r = vent_w / 2,
                                 h = wall_thickness * 2,
                                 center = true);
            }
        }
    }

    // 接口开口
    module connector_cutouts(w, d) {
        // USB 开口 (前侧)
        translate([0, -d / 2, floor_thickness + 8])
            cube([12, wall_thickness * 3, 6], center = true);

        // 电源开口 (后侧)
        translate([0, d / 2, floor_thickness + 8])
            cylinder(r = 3, h = wall_thickness * 3, center = true);

        // LED 窗口 (左侧)
        translate([-w / 2, 0, floor_thickness + 12])
            rotate([0, 90, 0])
                cylinder(r = 2, h = wall_thickness * 3, center = true);
    }
}

// ---- 盖子 ----
module enclosure_lid() {
    inner_w = pcb_width  + 2 * tolerance;
    inner_d = pcb_depth  + 2 * tolerance;

    outer_w = inner_w + 2 * wall_thickness;
    outer_d = inner_d + 2 * wall_thickness;
    lid_h = 3;

    difference() {
        // 盖板
        linear_extrude(height = lid_h) {
            offset(r = corner_radius)
                square([outer_w - 2 * corner_radius,
                        outer_d - 2 * corner_radius], center = true);
        }

        // 配合凸台 (嵌入底座)
        translate([0, 0, -1])
            linear_extrude(height = 2) {
                offset(r = 1)
                    square([inner_w - 2, inner_d - 2], center = true);
            }

        // 螺丝孔
        screw_positions = [
            [-outer_w / 2 + 5, -outer_d / 2 + 5],
            [ outer_w / 2 - 5, -outer_d / 2 + 5],
            [-outer_w / 2 + 5,  outer_d / 2 - 5],
            [ outer_w / 2 - 5,  outer_d / 2 - 5],
        ];
        for (pos = screw_positions) {
            translate([pos[0], pos[1], 0])
                cylinder(r = 1.8, h = lid_h + 1, center = true);
        }
    }
}

// ---- 展示 ----
enclosure_base();

translate([outer_w + 10, 0, 0])
    enclosure_lid();

// 装配预览
// translate([0, outer_d + 10, 0]) {
//     enclosure_base();
//     translate([0, 0, floor_thickness + pcb_clearance + pcb_thickness + 15])
//         enclosure_lid();
// }
