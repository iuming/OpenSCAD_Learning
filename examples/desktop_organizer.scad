// examples/desktop_organizer.scad
// ==============================================
// 桌面收纳 — 笔筒 + 名片夹 + 手机支架一体
// 适合 3D 打印的实用桌面配件

$fn = 50;

// ---- 笔筒部分 ----
module pen_holder(
    diameter = 50,
    height   = 80,
    wall     = 2,
    bottom   = 2
) {
    difference() {
        cylinder(r = diameter / 2 + wall, h = height);

        // 内部
        translate([0, 0, bottom])
            cylinder(r = diameter / 2, h = height);

        // 底部排水/透气孔
        for (x = [-1, 1]) {
            for (y = [-1, 1]) {
                translate([x * diameter * 0.2,
                           y * diameter * 0.2, 0])
                    cylinder(r = 2, h = bottom + 1, center = true);
            }
        }
    }
}

// ---- 名片夹 ----
module business_card_holder(
    width  = 55,
    depth  = 10,
    height = 35,
    wall   = 2,
    angle  = 15  // 倾斜角度
) {
    rotate([0, angle, 0]) {
        difference() {
            // 外壳
            cube([width + 2 * wall, depth + 2 * wall, height + wall]);

            // 卡片槽
            translate([wall, wall, wall])
                cube([width, depth, height]);

            // 前侧开口(方便取卡)
            translate([-1, depth / 4, height * 0.3])
                cube([width + 2 * wall + 2, depth / 2, height * 0.7]);
        }
    }
}

// ---- 手机支架 ----
module phone_stand(
    base_w    = 60,
    base_d    = 50,
    height    = 50,
    angle     = 20,
    phone_thk = 12
) {
    union() {
        // 底座
        difference() {
            translate([0, 0, 0])
                cube([base_w, base_d, 3]);

            // 防滑槽
            for (x = [-base_w * 0.3, 0, base_w * 0.3]) {
                translate([x + base_w / 2, base_d * 0.3, 0])
                    cube([1, base_d * 0.5, 4], center = true);
            }
        }

        // 支撑板
        translate([0, base_d - 5, 3])
            rotate([angle, 0, 0]) {
                cube([base_w, 5, height]);

                // 手机搁板
                translate([0, 0, height - 5])
                    cube([base_w, 2, 5]);

                // 底部档条
                translate([0, -8, 0])
                    cube([base_w, 10, 3]);
            }

        // 侧面加强筋
        for (x = [2, base_w - 2]) {
            hull() {
                translate([x, base_d - 8, 3])
                    cube([3, 5, 3]);
                translate([x, base_d * 0.3, 3])
                    rotate([angle, 0, 0])
                        cube([3, 3, height * 0.4]);
            }
        }
    }
}

// ---- 组装 ----
// 底板
color("darkgray")
    translate([0, 0, 0])
        cube([140, 80, 3]);

// 笔筒
color("steelblue")
    translate([20, 40, 3])
        pen_holder(diameter = 40, height = 70);

// 名片夹
color("darkgreen")
    translate([85, 10, 3])
        rotate([0, -15, 0])
            business_card_holder();

// 手机支架
color("darkorange")
    translate([90, 50, 3])
        phone_stand(base_w = 40, base_d = 30, height = 40);

// 小件托盘
color("silver")
    translate([15, 15, 3])
        difference() {
            cube([40, 20, 5]);
            translate([2, 2, 2])
                cube([36, 16, 4]);
        }
