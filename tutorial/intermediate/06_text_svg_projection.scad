// tutorial/intermediate/06_text_svg_projection.scad
// ==============================================
// 学习目标: 掌握文字、2D 轮廓拉伸、投影 projection() 和伪 SVG 工作流
// 说明: 本例不依赖外部 SVG 文件，所有轮廓都在文件内自包含定义

$fn = $preview ? 36 : 96;

badge_width = 90;
badge_height = 34;
badge_thick = 3;
corner_r = 5;
text_raise = 1.0;
hole_d = 5;

// ---- 2D 圆角矩形 ----
module rounded_rect_2d(w, h, r) {
    hull() {
        for (x = [-1, 1], y = [-1, 1])
            translate([x * (w/2 - r), y * (h/2 - r)])
                circle(r = r);
    }
}

// ---- 伪 SVG 图标: 用 polygon 定义一个简化火箭 ----
module rocket_icon_2d(scale_factor = 1) {
    scale(scale_factor) union() {
        polygon([[0,12], [5,2], [4,-8], [0,-12], [-4,-8], [-5,2]]);
        translate([0,2]) circle(r = 2.0);
        translate([-4,-5]) polygon([[-1,0], [-7,-4], [-4,3]]);
        translate([4,-5]) polygon([[1,0], [7,-4], [4,3]]);
        translate([0,-12]) polygon([[-2,0], [0,-6], [2,0]]);
    }
}

// ---- 名牌主体 ----
module badge_body() {
    difference() {
        linear_extrude(height = badge_thick)
            rounded_rect_2d(badge_width, badge_height, corner_r);

        // 左右挂孔
        for (x = [-1, 1])
            translate([x * (badge_width/2 - 9), 0, -0.1])
                cylinder(d = hole_d, h = badge_thick + 0.2);
    }
}

// ---- 浮雕文字和图标 ----
module raised_art() {
    translate([-20, -4, badge_thick])
        linear_extrude(height = text_raise)
            text("学习 OpenSCAD", size = 7, font = "Liberation Sans:style=Bold",
                 halign = "center", valign = "center");

    translate([28, 0, badge_thick])
        linear_extrude(height = text_raise)
            rocket_icon_2d(scale_factor = 0.75);
}

// ---- projection() 演示: 从 3D 零件得到 2D 外形 ----
module projected_outline_demo() {
    translate([0, -52, 0]) {
        color("lightblue")
            linear_extrude(height = 0.6)
                projection(cut = false)
                    badge_body();

        translate([0, -22, 0])
            linear_extrude(height = 0.8)
                text("projection() 可生成 2D 轮廓", size = 5,
                     halign = "center", valign = "center");
    }
}

// ---- 组合展示 ----
badge_body();
color("orange") raised_art();
projected_outline_demo();
