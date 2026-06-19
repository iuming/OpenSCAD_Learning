// tutorial/intermediate/02_screw_threads.scad
// ==============================================
// 学习目标: 创建真实螺纹 — ISO 公制螺纹
// 使用线性拉伸 + 扭曲实现螺旋结构
// 应用: 螺丝/螺栓、螺母、螺旋齿轮

$fn = 60;

// ---- ISO 公制螺纹参数 ----
// M10 × 1.5 (直径 10mm, 螺距 1.5mm)

// ---- 单头螺纹模块 ----
module screw_thread(
    diameter    = 10,   // 公称直径
    pitch       = 1.5,  // 螺距
    length      = 20,   // 螺纹长度
    thread_depth = 0.866 * 1.5,  // 标准 ISO: h = 0.866×pitch
    tolerance   = 0.05  // 配合间隙
) {
    // 螺纹截面: 60° 三角形
    thread_h = thread_depth;
    thread_w = pitch * 0.8;  // 齿宽(略小于螺距)

    // 螺旋扫掠
    union() {
        linear_extrude(
            height       = length,
            twist        = 360 * length / pitch,
            slices       = length / pitch * 30,
            convexity    = 5
        ) {
            // 在圆柱外面添加三角形齿
            difference() {
                union() {
                    circle(r = diameter / 2);
                    // 一个齿
                    translate([diameter / 2 - thread_h, -thread_w / 2, 0])
                        square([thread_h, thread_w]);
                }
                // 清理内部
                circle(r = diameter / 2 - thread_h - tolerance);
            }
        }
    }
}

// ---- 螺栓模块 ----
module bolt(
    diameter = 10,
    pitch    = 1.5,
    length   = 25,
    head_d   = 16,
    head_h   = 6
) {
    // 螺杆
    cylinder(r = diameter / 2, h = length);

    // 螺纹
    screw_thread(diameter, pitch, length - 1);

    // 六角头
    translate([0, 0, length - 0.1]) {
        // 六角形头部
        cylinder(r = head_d / 2 * 1.1, h = head_h, $fn = 6);
    }
}

// ---- 螺母模块 ----
module nut(
    diameter = 10,
    pitch    = 1.5,
    height   = 8,
    width    = 16
) {
    difference() {
        // 六角形外轮廓
        cylinder(r = width / 2 * 1.1, h = height, $fn = 6);

        // 内螺纹孔
        cylinder(r = diameter / 2 - 0.866 * pitch + 0.1,
                 h = height + 0.1, center = true);
    }
}

// ---- 展示 ----
translate([-30, 0, 0]) bolt(diameter = 10, pitch = 1.5, length = 25);
translate([0, 0, 0])   nut(diameter = 10, pitch = 1.5);
translate([30, 0, 0])  bolt(diameter = 6, pitch = 1.0, length = 18);

// ---- 双头螺纹 (更大螺距) ----
module double_thread(dia, pitch, len) {
    // 粗牙螺纹
    linear_extrude(
        height    = len,
        twist     = 360 * len / pitch * 2,  // 双头
        slices    = len / pitch * 60,
        convexity = 10
    ) {
        circle(r = dia / 2);
        // 对侧双齿
        translate([dia / 2 - 2, -1, 0]) square([2, 2]);
        rotate([0, 0, 180])
            translate([dia / 2 - 2, -1, 0]) square([2, 2]);
    }
}

translate([0, -30, 0])
    double_thread(dia = 8, pitch = 4, len = 20);
