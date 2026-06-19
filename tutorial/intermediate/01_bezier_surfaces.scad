// tutorial/intermediate/01_bezier_surfaces.scad
// ==============================================
// 学习目标: 使用贝塞尔曲线和曲面创建光滑有机形状
// 利用 control points 定义任意 3D 曲面

$fn = 30;
epsilon = 0.01;

// ---- 3 阶贝塞尔曲线 (4 个控制点) ----
function bezier3(t, p0, p1, p2, p3) =
    p0 * pow(1 - t, 3) +
    p1 * 3 * t * pow(1 - t, 2) +
    p2 * 3 * pow(t, 2) * (1 - t) +
    p3 * pow(t, 3);

// ---- 通过贝塞尔曲线生成扫掠管 ----
module bezier_tube(p0, p1, p2, p3, radius, steps) {
    for (i = [0 : steps - 1]) {
        t0 = i / steps;
        t1 = (i + 1) / steps;
        pt0 = bezier3(t0, p0, p1, p2, p3);
        pt1 = bezier3(t1, p0, p1, p2, p3);

        hull() {
            translate(pt0) sphere(r = radius);
            translate(pt1) sphere(r = radius);
        }
    }
}

// 花瓶曲线
p0 = [0, 0, 0];
p1 = [10, 0, 15];
p2 = [-8, 0, 25];
p3 = [0, 0, 40];

bezier_tube(p0, p1, p2, p3, radius = 1.5, steps = 50);

// ---- 贝塞尔旋转面 (花瓶) ----
function bezier2d(t, points, index) =
    let(n = len(points) - 1)
    index < n ?
        points[index] * pow(1 - t, n) * pow(t, index) +
        bezier2d(t, points, index + 1) :
        points[index] * pow(t, index);

// 旋转体轮廓控制点
profile_points = [
    [5, 0],     // 底部
    [8, 5],     // 弧度
    [15, 15],   // 最大直径
    [8, 25],    // 颈部
    [10, 35],   // 口部外翻
    [9, 40],    // 口部
];

module vase() {
    translate([30, 0, 0]) {
        rotate_extrude(angle = 360) {
            polygon(points = profile_points);
        }
    }
}

module organic_vase() {
    translate([-30, 0, 0]) {
        rotate_extrude(angle = 360) {
            // 光滑轮廓: 使用 hull 近似
            hull() {
                for (pt = profile_points) {
                    translate(pt) circle(r = 0.1);
                }
            }
        }
    }
}

vase();
organic_vase();

// ---- 贝塞尔曲面的扫掠管装饰 ----
module decorative_swirl() {
    for (a = [0 : 30 : 330]) {
        rotate([0, 0, a]) {
            p_start = [25, 0, 0];
            p_c1    = [25, 0, 15];
            p_c2    = [5, 0, 30];
            p_end   = [5, 0, 45];

            bezier_tube(p_start, p_c1, p_c2, p_end, 0.5, 30);
        }
    }
}

translate([0, 50, 0])
    decorative_swirl();
