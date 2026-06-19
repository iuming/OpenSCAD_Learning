// tutorial/intermediate/05_surface_texture.scad
// ==============================================
// 学习目标: 在模型表面添加纹理和图案
// 方法: 位移贴图、布尔运算阵列、投影切割

$fn = 60;

// ---- 菱形纹理圆柱 ----
module diamond_texture_cylinder(r, h, diamond_size, depth) {
    n_circum = floor(2 * PI * r / diamond_size);
    n_height = floor(h / diamond_size);

    difference() {
        cylinder(r = r, h = h);

        // 菱形凹凸
        for (i = [0 : n_circum - 1]) {
            angle = i * 360 / n_circum;
            for (j = [0 : n_height - 1]) {
                z = j * diamond_size + diamond_size / 2;
                offset = (j % 2) * (180 / n_circum);  // 错位

                rotate([0, 0, angle + offset])
                    translate([r - depth / 2, 0, z]) {
                        // 菱形: 旋转的正方形
                        rotate([0, 45, 0])
                            cube([diamond_size * 0.7, depth * 2,
                                  diamond_size * 0.7], center = true);
                    }
            }
        }
    }
}

// ---- 蜂窝纹理 ----
module honeycomb_surface(width, depth, height, cell_size, wall) {
    difference() {
        cube([width, depth, height]);

        // 蜂窝网格
        cols = floor(width  / (cell_size * 1.5)) + 1;
        rows = floor(depth  / (cell_size * sqrt(3))) + 1;

        for (col = [0 : cols - 1]) {
            offset_x = col * cell_size * 1.5;
            for (row = [0 : rows - 1]) {
                offset_y = row * cell_size * sqrt(3) +
                          ((col % 2) * cell_size * sqrt(3) / 2);

                translate([offset_x, offset_y, height / 2])
                    rotate([0, 0, 90])
                        cylinder(r = cell_size / 2 - wall, h = height + 2,
                                 $fn = 6, center = true);
            }
        }
    }
}

// ---- 涟漪效果 (正弦位移) ----
module ripple_surface(size, amplitude, frequency) {
    step = 1;
    n = floor(size / step);

    // 逐点构建表面
    for (x = [0 : step : size - step]) {
        for (y = [0 : step : size - step]) {
            // 到中心距离
            dx = x - size / 2;
            dy = y - size / 2;
            dist = sqrt(dx * dx + dy * dy);

            // 正弦涟漪高度
            z = amplitude * sin(frequency * dist) *
                exp(-dist / (size * 0.3));

            translate([x, y, max(0, z)])
                cube([step, step, abs(z) + 0.5]);
        }
    }
}

// ---- 展示 ----
// 菱形纹理圆柱
translate([-35, 0, 0])
    diamond_texture_cylinder(r = 15, h = 30, diamond_size = 4, depth = 1.5);

// 蜂窝面板
translate([0, -25, 0])
    honeycomb_surface(width = 30, depth = 30, height = 3,
                      cell_size = 5, wall = 0.6);

// 涟漪盘
translate([40, -15, 0])
    ripple_surface(size = 30, amplitude = 4, frequency = 0.5);
