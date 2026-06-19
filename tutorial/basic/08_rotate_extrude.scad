// tutorial/basic/08_rotate_extrude.scad
// ==============================================
// 学习目标: 掌握 rotate_extrude() 旋转拉伸和 linear_extrude() 线性拉伸
// 从 2D 轮廓 → 3D 模型

$fn = 60;

// ---- rotate_extrude() 通过绕 Z 轴旋转 2D 轮廓创建旋转体 ----
module rotate_extrude_demo() {
    // 高脚杯
    translate([-40, 0, 0]) {
        rotate_extrude(angle = 360) {
            // 2D 轮廓: 杯身 + 杯柄 + 底座
            translate([0, 0, 0])
                polygon(points = [
                    [10, 0],    // 底座外侧
                    [8, 3],
                    [6, 3],     // 杯柄底部
                    [4, 20],    // 杯柄顶部
                    [12, 22],   // 杯口外侧
                    [11, 22],   // 杯口内侧(壁厚)
                    [3, 20],
                    [5, 3],
                    [7, 3],
                    [9, 0],
                ]);
        }
    }

    // 花瓶
    translate([0, 0, 0]) {
        rotate_extrude(angle = 360) {
            translate([15, 0, 0])
                polygon(points = [
                    [0, 0],
                    [5, 0],
                    [4, 10],
                    [8, 18],
                    [3, 25],
                    [2, 15],
                    [1, 0],
                ]);
        }
    }
}

// ---- linear_extrude() 线性拉伸 ----
module linear_extrude_demo() {
    // 普通线性拉伸
    translate([30, -30, 0]) {
        linear_extrude(height = 10) {
            text("OpenSCAD", size = 6, font = "Liberation Sans");
        }
    }

    // 带扭曲的线性拉伸
    translate([30, -15, 0]) {
        linear_extrude(height = 15, twist = 180, slices = 100) {
            square([8, 8], center = true);
        }
    }

    // 锥形拉伸 (scale 参数)
    translate([30, 5, 0]) {
        linear_extrude(height = 15, scale = 0.3) {
            square([15, 15], center = true);
        }
    }

    // 沿螺旋路径拉伸 (手动实现)
    translate([30, 25, 0]) {
        linear_extrude(height = 12, twist = -360, slices = 80) {
            translate([10, 0, 0]) circle(r = 3);
        }
    }
}

rotate_extrude_demo();
linear_extrude_demo();
