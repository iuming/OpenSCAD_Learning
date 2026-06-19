// tutorial/advanced/02_math_art.scad
// ==============================================
// 学习目标: 数学艺术 — 使用数学函数创建美感三维形态
// 主题: 参数曲面、螺旋结构、分形、极小曲面

$fn = 40;

// ---- 螺旋面 (Helicoid) ----
module helicoid(size, turns, height) {
    slices = 80;
    for (i = [0 : slices - 1]) {
        t0 = i / slices;
        t1 = (i + 1) / slices;

        hull() {
            for (r = [0.2, 1]) {
                theta0 = t0 * turns * 360;
                theta1 = t1 * turns * 360;
                z0 = t0 * height;
                z1 = t1 * height;

                x0 = r * size * cos(theta0);
                y0 = r * size * sin(theta0);
                x1 = r * size * cos(theta1);
                y1 = r * size * sin(theta1);

                translate([x0, y0, z0])
                    sphere(r = 0.8, $fn = 8);
                translate([x1, y1, z1])
                    sphere(r = 0.8, $fn = 8);
            }
        }
    }
}

// ---- 环面结 (Torus Knot) ----
module torus_knot(p, q, R, r, steps) {
    for (i = [0 : steps - 1]) {
        t = i / steps * 360;

        // 环面结参数方程
        theta = p * t;
        phi   = q * t;

        x = (R + r * cos(theta)) * cos(phi);
        y = (R + r * cos(theta)) * sin(phi);
        z = r * sin(theta);

        translate([x, y, z])
            sphere(r = r * 0.5, $fn = 12);
    }
}

// ---- 谢尔宾斯基金字塔 (Sierpinski) ----
module sierpinski_pyramid(level, size) {
    if (level == 0) {
        // 四面体
        polyhedron(
            points = [
                [0, 0, size],
                [-size / 2, -size / 2, 0],
                [size / 2, -size / 2, 0],
                [0, size / 2, 0]
            ],
            faces = [
                [0, 1, 2], [0, 2, 3],
                [0, 3, 1], [1, 2, 3]
            ]
        );
    } else {
        s = size / 2;
        // 四个子金字塔
        translate([0, 0, s])
            sierpinski_pyramid(level - 1, s);
        translate([-s / 2, -s / 2, 0])
            sierpinski_pyramid(level - 1, s);
        translate([s / 2, -s / 2, 0])
            sierpinski_pyramid(level - 1, s);
        translate([0, s / 2, 0])
            sierpinski_pyramid(level - 1, s);
    }
}

// ---- 斐波那契球面分布 ----
module fibonacci_sphere(n, radius) {
    phi = (1 + sqrt(5)) / 2;  // 黄金比例

    for (i = [0 : n - 1]) {
        // 均匀球面分布
        y = 1 - 2 * i / (n - 1);
        theta = 2 * PI * i / phi;

        r_at_y = sqrt(1 - y * y);

        x = r_at_y * cos(theta);
        z = r_at_y * sin(theta);

        translate([x, y, z] * radius)
            sphere(r = radius * 0.15, $fn = 8);
    }
}

// ---- 展示 ----
helicoid(size = 15, turns = 3, height = 30);

translate([35, 0, 15])
    color("steelblue")
        torus_knot(p = 2, q = 3, R = 12, r = 3, steps = 200);

translate([-35, 0, 0])
    color("darkred", alpha = 0.8)
        sierpinski_pyramid(level = 3, size = 20);

translate([0, -30, 0])
    color("gold")
        fibonacci_sphere(n = 120, radius = 15);
