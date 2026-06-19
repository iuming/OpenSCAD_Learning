// examples/snap_fit_box.scad
// ==============================================
// 卡扣式盒子 — 无需螺丝的组装设计
// 适合 FDM 打印: 利用塑料弹性实现 snap-fit

$fn = 40;

// ---- 参数 ----
box_width  = 60;
box_depth  = 40;
box_height = 25;
wall       = 2;

// 卡扣参数
snap_width     = 8;
snap_length    = 6;
snap_thickness = 1.5;
snap_overhang  = 1;
snap_taper     = 5;  // 导入斜面角度

tolerance = 0.2;

// ---- 盒体 ----
module snap_box_base() {
    difference() {
        // 外壳
        cube([box_width, box_depth, box_height]);

        // 掏空
        translate([wall, wall, wall])
            cube([box_width - 2 * wall,
                  box_depth - 2 * wall,
                  box_height]);

        // 卡扣槽 (四周各一个)
        snap_positions = [
            [box_width / 2, wall / 2, box_height - snap_length - 1],
            [box_width / 2, box_depth - wall / 2, box_height - snap_length - 1],
            [wall / 2, box_depth / 2, box_height - snap_length - 1],
            [box_width - wall / 2, box_depth / 2, box_height - snap_length - 1],
        ];

        for (pos = snap_positions) {
            translate(pos)
                rotate([
                    (pos[0] < wall ? 0 : 0),
                    (pos[1] < wall ? 90 : (pos[1] > box_depth - wall ? -90 : 0)),
                    0
                ])
                    cube([snap_width + tolerance, wall + 1,
                          snap_length + tolerance], center = true);
        }
    }

    // 底部加强筋
    for (x = [wall : 15 : box_width - wall]) {
        translate([x, wall, wall])
            cube([1.5, box_depth - 2 * wall, 1]);
    }
}

// ---- 盖子 ----
module snap_box_lid() {
    lip_height = 3;

    difference() {
        union() {
            // 盖板
            cube([box_width + 2 * wall, box_depth + 2 * wall, wall]);

            // 配合唇边
            translate([wall + tolerance, wall + tolerance, wall])
                cube([box_width - 2 * tolerance,
                      box_depth - 2 * tolerance,
                      lip_height]);

            // 卡扣
            snap_positions = [
                [box_width / 2, 0, wall],
                [box_width / 2, box_depth, wall],
                [0, box_depth / 2, wall],
                [box_width, box_depth / 2, wall],
            ];

            for (pos = snap_positions) {
                translate([pos[0], pos[1], pos[2]])
                    snap_hook(pos[0], pos[1]);
            }
        }

        // 装饰槽
        translate([box_width / 2, box_depth / 2, -1])
            linear_extrude(height = wall + lip_height + 2)
                offset(r = 3)
                    square([box_width * 0.5, box_depth * 0.5],
                           center = true);
    }

    // 卡扣钩子
    module snap_hook(x, y) {
        // 判断方向
        if (y < wall) {
            // 前侧卡扣
            rotate([90, 0, 0]) {
                translate([0, 0, -snap_length / 2])
                    cube([snap_width, snap_length, snap_thickness],
                         center = true);
                // 钩头
                translate([0, snap_length / 2 - snap_overhang ,
                            snap_thickness / 2])
                    cube([snap_width - tolerance * 4,
                          snap_overhang * 2, snap_thickness],
                         center = true);
            }
        } else if (y > box_depth) {
            // 后侧卡扣
            rotate([-90, 0, 0]) {
                translate([0, 0, -snap_length / 2])
                    cube([snap_width, snap_length, snap_thickness],
                         center = true);
                translate([0, snap_length / 2 - snap_overhang,
                            snap_thickness / 2])
                    cube([snap_width - tolerance * 4,
                          snap_overhang * 2, snap_thickness],
                         center = true);
            }
        }
    }
}

// ---- 展示 ----
translate([-box_width / 2 - 10, -box_depth / 2, box_height + 10])
    snap_box_lid();

snap_box_base();
