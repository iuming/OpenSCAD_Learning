// tutorial/intermediate/04_hinges_and_joints.scad
// ==============================================
// 学习目标: 设计打印级活动铰链和可动关节
// 重点: 配合公差、打印方向、支撑优化

$fn = 40;
tolerance = 0.3;  // FDM 打印配合间隙 (mm)

// ---- 活动铰链 (living hinge) ----
module living_hinge(
    width  = 30,
    length = 40,
    thick  = 2,
    hinge_gap = 0.6,
    n_slots   = 4
) {
    difference() {
        // 铰链本体
        cube([width, length, thick]);

        // 横向槽 (柔化)
        slot_space = length / (n_slots + 1);
        for (i = [1 : n_slots]) {
            translate([0, i * slot_space, 0])
                cube([width, hinge_gap, thick]);
        }

        // 纵向长槽
        translate([width / 2 - 0.5, length * 0.1, 0])
            cube([1, length * 0.8, thick]);
    }
}

// ---- 门铰链 ----
module door_hinge(
    leaf_w = 25,   // 页片宽度
    leaf_l = 40,   // 页片长度
    leaf_t = 3,    // 页片厚度
    pin_r  = 3     // 销轴半径
) {
    module hinge_half() {
        difference() {
            union() {
                // 页片
                cube([leaf_w, leaf_l, leaf_t]);

                // 卷筒
                translate([leaf_w, 0, leaf_t / 2])
                    rotate([-90, 0, 0])
                        cylinder(r = pin_r + leaf_t, h = leaf_l);
            }

            // 销孔
            translate([leaf_w, -1, leaf_t / 2])
                rotate([-90, 0, 0])
                    cylinder(r = pin_r + tolerance / 2,
                             h = leaf_l + 2);

            // 螺丝孔
            for (y = [leaf_l * 0.2, leaf_l * 0.5, leaf_l * 0.8]) {
                translate([leaf_w / 2, y, -1])
                    cylinder(r = 1.5, h = leaf_t + 2);
            }
        }
    }

    // 上半部分
    hinge_half();

    // 下半部分(反转放置)
    translate([-leaf_w - pin_r * 2 - leaf_t * 2 - 1, 0, leaf_t + 2])
        mirror([0, 0, 1])
            hinge_half();
}

// ---- 球关节 ----
module ball_joint(
    ball_r   = 8,
    socket_r = 8.5,
    stem_r   = 4,
    stem_l   = 15,
    cutout   = 0.6  // 装配切口
) {
    // 球头
    difference() {
        union() {
            sphere(r = ball_r);
            translate([0, 0, -stem_l])
                cylinder(r = stem_r, h = stem_l);
        }
        // 装配切口(弹性卡入)
        translate([-ball_r, -cutout / 2, -ball_r])
            cube([ball_r * 2, cutout, ball_r * 2]);
    }

    // 球窝
    translate([0, 20, 0]) {
        difference() {
            union() {
                sphere(r = socket_r + 3);
                translate([0, 0, -stem_l / 2])
                    cylinder(r = stem_r + 2, h = stem_l / 2);
            }

            // 球形空腔
            sphere(r = socket_r);

            // 开口(让球杆活动)
            translate([0, -socket_r - 1, -socket_r])
                rotate([0, 45, 0])
                    cube([socket_r * 3, socket_r, socket_r * 3],
                         center = true);
        }
    }
}

// ---- 展示 ----
living_hinge();

translate([40, 0, 0])
    door_hinge();

translate([-40, -20, 0])
    ball_joint();
