// projects/robotic_arm.scad
// ==============================================
// 项目: 小型机器人手臂
// 4 自由度,可参数化连杆长度
// 适合 Arduino 舵机驱动

$fn = 40;

// ---- 参数 ----
// 各关节连杆长度 (mm)
link1_len = 50;   // 底座→肩
link2_len = 60;   // 上臂
link3_len = 50;   // 前臂
link4_len = 30;   // 手腕→末端

// 舵机安装座参数
servo_width  = 23;
servo_depth  = 12.5;
servo_height = 22;
servo_flange = 5;

// 关节直径
joint_od = 30;
joint_id = 8;  // 轴承/轴孔

// 安装螺丝
screw_d = 2.5;

// ---- 舵机座 ----
module servo_mount() {
    difference() {
        union() {
            // 底座
            cube([servo_width + 4, servo_depth + 6, 3]);

            // 侧面安装耳
            for (x = [-1, 1]) {
                translate([x * (servo_width / 2 + 2), 0, 0])
                    cube([4, servo_depth + 6, servo_height - 12]);
            }
        }

        // 舵机腔
        translate([0, 0, 3])
            cube([servo_width + 1, servo_depth + 1, servo_height]);

        // 螺丝孔
        for (x = [-1, 1]) {
            translate([x * (servo_width / 2), 0, -1])
                cylinder(r = screw_d / 2, h = 6,
                         $fn = 20, center = true);
        }
    }
}

// ---- 旋转关节 ----
module revolute_joint(od, id, height) {
    difference() {
        cylinder(r = od / 2, h = height, center = true);

        // 轴承孔
        cylinder(r = id / 2, h = height + 1, center = true);

        // 减重
        for (i = [0 : 5]) {
            rotate([0, 0, i * 60])
                translate([od * 0.3, 0, 0])
                    cylinder(r = od * 0.1, h = height + 1,
                             $fn = 12, center = true);
        }
    }
}

// ---- 连杆 ----
module link(length, width, thickness) {
    difference() {
        union() {
            // 杆体
            hull() {
                cylinder(r = width / 2, h = thickness);
                translate([length - width, 0, 0])
                    cylinder(r = width / 2, h = thickness);
            }

            // 关节端
            cylinder(r = joint_od / 2, h = thickness);
            translate([length, 0, 0])
                cylinder(r = joint_od / 2, h = thickness);
        }

        // 关节孔
        cylinder(r = joint_id / 2, h = thickness + 1,
                 center = true);
        translate([length, 0, 0])
            cylinder(r = joint_id / 2, h = thickness + 1,
                     center = true);

        // 减重槽
        translate([length / 2, 0, thickness / 2])
            cube([length - joint_od, width * 0.4, thickness * 0.4],
                 center = true);
    }
}

// ---- 末端执行器 (平行夹爪) ----
module gripper(width, opening, height) {
    module jaw() {
        difference() {
            // 夹爪
            hull() {
                cube([width * 0.4, 8, height]);
                translate([0, 15, 0])
                    cube([width * 0.2, 5, height]);
            }

            // 手指槽
            translate([0, 5, height * 0.6])
                rotate([0, 30, 0])
                    cube([width * 0.5, 5, height], center = true);
        }
    }

    // 固定端
    translate([0, 0, 0]) {
        // 基座
        cube([width, 15, height * 0.3]);

        // 滑轨
        translate([0, 15, height * 0.15])
            cube([width, opening * 1.5, 3]);
    }

    // 夹爪 (对称开口)
    translate([0, 15 + opening / 2, height * 0.15]) jaw();
    mirror([0, 1, 0])
        translate([0, 15 + opening / 2, height * 0.15]) jaw();
}

// ---- 底座转台 ----
module base_turntable() {
    difference() {
        union() {
            cylinder(r = 40, h = 8);

            // 安装法兰
            for (i = [0 : 2]) {
                rotate([0, 0, i * 120])
                    translate([32, 0, 0])
                        cylinder(r = 6, h = 8);
            }

            // 舵机座 (旋转)
            translate([0, 0, 8])
                cylinder(r = joint_od / 2 + 3, h = 15);
        }

        // 舵机腔
        translate([0, 0, 1])
            cube([servo_width + 2, servo_depth + 2, 10],
                 center = true);

        // 安装孔
        for (i = [0 : 2]) {
            rotate([0, 0, i * 120])
                translate([32, 0, -1])
                    cylinder(r = 1.5, h = 10, $fn = 20);
        }
    }
}

// ---- 组装 ----
module robotic_arm() {
    // 底座
    color("darkgray")
        base_turntable();

    // 底座旋转关节
    translate([0, 0, 8])
        color("silver")
            revolute_joint(joint_od, joint_id, 10);

    // 上臂
    translate([0, 0, 8])
        rotate([0, -60, 0])
            color("steelblue")
                link(link2_len, 15, 8);

    // 肘关节
    translate([0, 0, 8])
        rotate([0, -60, 0])
            translate([link2_len, 0, 0])
                color("silver")
                    revolute_joint(25, 6, 8);

    // TODO: 由于 OpenSCAD 的层级限制,这里展示概念
    // 实际项目需分层级的 transform 传递
}

robotic_arm();

// 末端执行器展示
translate([80, 0, 0])
    rotate([90, 0, 0])
        gripper(width = 30, opening = 20, height = 25);
