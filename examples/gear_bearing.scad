// examples/gear_bearing.scad
// ==============================================
// 一体打印轴承 — 无需装配的可旋转轴承
// 利用打印间隙实现旋转功能

$fn = 60;

// ---- 参数 ----
bearing_od  = 40;  // 外径
bearing_id  = 20;  // 内径
bearing_h   = 8;   // 厚度
ball_count  = 8;   // 滚珠数
ball_d      = 5;   // 滚珠直径
race_depth  = 1;   // 滚道深度
clearance   = 0.3; // 间隙(关键!)

// ---- 深沟球轴承 ----
module deep_groove_bearing(
    od, id, h, n_balls, ball_dia, clearance
) {
    r_ave = (od + id) / 4;  // 滚道平均半径

    difference() {
        union() {
            // 外圈
            difference() {
                cylinder(r = od / 2, h = h);

                // 外侧倒角
                translate([0, 0, -1])
                    cylinder(r = od / 2 - 1, h = h + 2,
                             $fn = 6);

                // 内侧滚道
                translate([0, 0, h / 2])
                    rotate_extrude(angle = 360) {
                        translate([r_ave, 0, 0])
                            circle(r = ball_dia / 2 + clearance);
                    }
            }

            // 内圈
            difference() {
                cylinder(r = id / 2 + 3, h = h);

                // 轴孔
                translate([0, 0, -1])
                    cylinder(r = id / 2, h = h + 2);
            }
        }

        // 滚珠放置位置(切除多余材料模拟滚珠通道)
        for (i = [0 : n_balls - 1]) {
            angle = i * 360 / n_balls;
            rotate([0, 0, angle])
                translate([r_ave, 0, h / 2])
                    sphere(r = ball_dia / 2 + clearance);
        }
    }

    // 滚珠(单独打印或作为展示)
    % for (i = [0 : n_balls - 1]) {
        angle = i * 360 / n_balls;
        rotate([0, 0, angle])
            translate([r_ave, 0, h / 2])
                sphere(r = ball_dia / 2);
    }
}

// ---- 推力轴承 ----
module thrust_bearing(
    od, id, h, n_balls, ball_dia
) {
    r_ave = (od + id) / 4;

    // 下垫圈
    difference() {
        cylinder(r = od / 2, h = h / 3);
        cylinder(r = id / 2, h = h / 2, center = true);

        // 滚道
        for (i = [0 : n_balls - 1]) {
            rotate([0, 0, i * 360 / n_balls])
                translate([r_ave, 0, 0])
                    sphere(r = ball_dia / 3, $fn = 12);
        }
    }

    // 滚珠笼
    translate([0, 0, h / 3]) {
        difference() {
            cylinder(r = r_ave + ball_dia / 2 + 2, h = ball_dia * 0.8,
                     center = true);
            cylinder(r = r_ave - ball_dia / 2 - 2, h = ball_dia * 2,
                     center = true);
        }

        for (i = [0 : n_balls - 1]) {
            rotate([0, 0, i * 360 / n_balls])
                translate([r_ave, 0, 0])
                    sphere(r = ball_dia / 2);
        }
    }

    // 上垫圈
    translate([0, 0, h * 2 / 3]) {
        difference() {
            cylinder(r = od / 2, h = h / 3);
            cylinder(r = id / 2, h = h / 2, center = true);

            for (i = [0 : n_balls - 1]) {
                rotate([0, 0, (i + 0.5) * 360 / n_balls])
                    translate([r_ave, 0, 0])
                        sphere(r = ball_dia / 3, $fn = 12);
            }
        }
    }
}

// ---- 展示 ----
translate([0, 0, 0])
    deep_groove_bearing(bearing_od, bearing_id, bearing_h,
                        ball_count, ball_d, clearance);

translate([50, 0, 0])
    thrust_bearing(bearing_od, bearing_id, bearing_h,
                   ball_count, ball_d);
