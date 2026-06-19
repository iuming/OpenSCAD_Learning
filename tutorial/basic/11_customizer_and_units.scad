// tutorial/basic/11_customizer_and_units.scad
// ==============================================
// 学习目标: 使用 Customizer 友好的参数、单位换算和断言
// 重点: 让模型参数清晰、可调、可验证，适合分享给他人使用

// OpenSCAD 默认单位是毫米。这里用中文变量名帮助理解，实际项目可用英文。
$fn = $preview ? 32 : 96;

// ---- Customizer 参数区 ----
// 面板宽度
panel_width = 80;        // [40:1:160]
// 面板深度
panel_depth = 45;        // [25:1:100]
// 面板厚度
panel_thickness = 3;     // [2:0.5:8]
// 圆角半径
corner_radius = 5;       // [1:0.5:12]
// 安装孔直径
mount_hole_d = 4;        // [2:0.2:8]
// 是否显示尺寸标尺
show_ruler = true;       // [true,false]
// 铭牌文字
label_text = "OPENSCAD";
// 文字高度
text_height = 0.8;       // [0.3:0.1:2]

// ---- 参数检查 ----
assert(panel_width > 2 * corner_radius, "宽度必须大于两倍圆角半径");
assert(panel_depth > 2 * corner_radius, "深度必须大于两倍圆角半径");
assert(mount_hole_d + 4 < min(panel_width, panel_depth), "安装孔太大");

// ---- 单位换算函数 ----
function inch(v) = v * 25.4;      // 英寸转毫米
function mil(v) = v * 0.0254;     // PCB 常用 mil 转毫米
function clamp(v, lo, hi) = min(max(v, lo), hi);

// ---- 2D 圆角矩形 ----
module rounded_rect_2d(w, d, r) {
    // hull() 连接四个圆，得到稳定的圆角矩形
    hull() {
        for (x = [-1, 1], y = [-1, 1])
            translate([x * (w/2 - r), y * (d/2 - r)])
                circle(r = r);
    }
}

// ---- 面板主体 ----
module labeled_panel() {
    difference() {
        linear_extrude(height = panel_thickness)
            rounded_rect_2d(panel_width, panel_depth, corner_radius);

        // 四角安装孔，切削体上下多伸出 0.2 mm，避免共面问题
        for (x = [-1, 1], y = [-1, 1])
            translate([x * (panel_width/2 - 10), y * (panel_depth/2 - 10), -0.1])
                cylinder(d = mount_hole_d, h = panel_thickness + 0.2);
    }

    // 凸起文字：先生成 2D text，再线性拉伸
    translate([0, 0, panel_thickness])
        linear_extrude(height = text_height)
            text(label_text, size = clamp(panel_depth * 0.22, 6, 14),
                 halign = "center", valign = "center");
}

// ---- 简单尺寸标尺 ----
module ruler(length = 50, step = 10) {
    color("gray") {
        cube([length, 0.4, 0.4]);
        for (i = [0 : step : length])
            translate([i, 0, 0])
                cube([0.4, 4, 0.4], center = true);
    }
}

labeled_panel();

if (show_ruler) {
    translate([-panel_width/2, -panel_depth/2 - 10, 0])
        ruler(length = panel_width, step = 10);

    // 示例: 1 英寸参考线，帮助理解 OpenSCAD 的毫米单位
    translate([-panel_width/2, -panel_depth/2 - 16, 0])
        color("blue") cube([inch(1), 0.8, 0.8]);
}
