// tutorial/advanced/03_bezier_loft.scad
// ==============================================
// 学习目标: 高级放样 — 沿 3D 路径扫描任意截面
// 使用 skin() 和 sweep() 创建复杂有机形状

$fn = 30;
epsilon = 0.01;

// ---- 3D 贝塞尔曲线 (7 个控制点) ----
function bezier(t, v) =
    (len(v) > 2) ?
        bezier(t, [
            for (i = [0 : len(v) - 2])
                v[i] * (1 - t) + v[i + 1] * t
        ]) :
        v[0] * (1 - t) + v[1] * t;

// ---- 放样 (Loft): 两组截面之间平滑过渡 ----
module loft(profile_bottom, profile_top, height, slices) {
    for (i = [0 : slices - 1]) {
        t  = i / slices;
        t1 = (i + 1) / slices;
        z  = t * height;
        z1 = t1 * height;

        hull() {
            for (pt = profile_bottom) {
                pt_top = profile_top[
                    floor((pt[0] / max_radius(profile_bottom)) *
                          len(profile_top))
                    % len(profile_top)
                ];

                // 插值
                rx = pt[0] + (pt_top[0] - pt[0]) * t;
                ry = pt[1] + (pt_top[1] - pt[1]) * t;
                rx1 = pt[0] + (pt_top[0] - pt[0]) * t1;
                ry1 = pt[1] + (pt_top[1] - pt[1]) * t1;

                translate([rx, ry, z])
                    sphere(r = 0.8, $fn = 6);
                translate([rx1, ry1, z1])
                    sphere(r = 0.8, $fn = 6);
            }
        }
    }
}

function max_radius(profile) =
    max([for (pt = profile) norm([pt[0], pt[1]])]);

// ---- 3D 路径扫掠 (Sweep) ----
module sweep_path(control_points, profile_radius, steps) {
    n = len(control_points);

    for (i = [0 : steps - 1]) {
        t  = i / steps;
        t1 = (i + 1) / steps;

        pos  = bezier(t,  control_points);
        pos1 = bezier(t1, control_points);

        // 切线方向
        dir = pos1 - pos;

        hull() {
            translate(pos) sphere(r = profile_radius, $fn = 8);
            translate(pos1) sphere(r = profile_radius, $fn = 8);
        }
    }
}

// ---- 方形到圆形变截面体 ----
module square_to_circle_loft(
    square_size = 10,
    circle_radius = 8,
    height      = 20,
    slices      = 40
) {
    for (i = [0 : slices - 1]) {
        t = i / slices;
        t1 = (i + 1) / slices;

        // 插值: square → circle
        r_sq = square_size / sqrt(2);   // 方形的外接圆半径
        r_cr = circle_radius;
        r0 = r_sq + (r_cr - r_sq) * t;
        r1 = r_sq + (r_cr - r_sq) * t1;

        // 截面的多边形过渡
        sides = 4 + floor(20 * t);  // 4→24 面

        hull() {
            translate([0, 0, t * height])
                cylinder(r = r0, h = epsilon, $fn = max(4, sides));
            translate([0, 0, t1 * height])
                cylinder(r = r1, h = epsilon, $fn = max(4, sides + 1));
        }
    }
}

// ---- 花瓶 (截面扫描) ----
module vase_profile() {
    // 曲线路径
    path = [
        [0, 0, 0],
        [3, 0, 10],
        [-2, 0, 20],
        [1, 0, 30],
        [0, 0, 40],
    ];

    steps = 80;
    radiuses = [8, 12, 14, 8, 10];  // 各高度处的半径

    for (i = [0 : steps - 1]) {
        t = i / steps;
        t1 = (i + 1) / steps;

        pos  = bezier(t,  path);
        pos1 = bezier(t1, path);

        // 半径插值
        idx = floor(t * (len(radiuses) - 1));
        frac = t * (len(radiuses) - 1) - idx;
        r = (idx < len(radiuses) - 1) ?
            radiuses[idx] * (1 - frac) + radiuses[idx + 1] * frac :
            radiuses[idx];

        idx1 = floor(t1 * (len(radiuses) - 1));
        frac1 = t1 * (len(radiuses) - 1) - idx1;
        r1 = (idx1 < len(radiuses) - 1) ?
            radiuses[idx1] * (1 - frac1) + radiuses[idx1 + 1] * frac1 :
            radiuses[idx1];

        hull() {
            translate(pos)  cylinder(r = r, h = epsilon, center = true);
            translate(pos1) cylinder(r = r1, h = epsilon, center = true);
        }
    }
}

// ---- 展示 ----
translate([-15, 0, 0])
    square_to_circle_loft(square_size = 12, circle_radius = 6, height = 20);

translate([20, 0, 0])
    vase_profile();

// 3D 路径管子
module spiral_tube() {
    // 控制点定义螺旋
    n_pts = 10;
    cpts = [
        for (i = [0 : n_pts])
            let(a = i * 360 * 1.5 / n_pts,
                r = 15 + 5 * sin(a * 3),
                z = i * 30 / n_pts)
            [r * cos(a), r * sin(a), z]
    ];
    sweep_path(cpts, profile_radius = 2.5, steps = 100);
}

translate([0, 25, 0])
    spiral_tube();
