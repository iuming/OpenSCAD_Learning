// tutorial/advanced/04_csg_optimization.scad
// ==============================================
// 学习目标: CSG 运算优化与大型场景管理
// 技巧: $preview 性能优化、render() 缓存、
//       多级组合、模块化设计

// ---- 性能技巧 1: 使用 $preview 变量 ----
module detailed_part() {
    if ($preview) {
        // 预览模式: 简化几何
        cylinder(r = 10, h = 5, $fn = 20);
    } else {
        // 渲染模式: 完整细节
        difference() {
            cylinder(r = 10, h = 5, $fn = 120);

            for (i = [0 : 35]) {
                rotate([0, 0, i * 360 / 36])
                    translate([8, 0, 0])
                        cylinder(r = 0.5, h = 6, center = true, $fn = 20);
            }
        }
    }
}

// ---- 性能技巧 2: 缓存重复对象 ----
module bolt_pattern(n, radius, hole_d) {
    // ❌ 不好: 在每个调用点手写同一组孔位，容易重复出错。
    // ✅ 好: 把孔位阵列封装成模块；调用方只需传入一个子对象。
    for (i = [0 : n - 1]) {
        rotate([0, 0, i * 360 / n])
            translate([radius, 0, 0])
                children();  // children() 里放要复制的孔或螺钉
    }
}

// ---- 性能技巧 3: 合理使用 render() ----
module complex_chain(links, link_length, link_width) {
    render() {
        // render() 强制立即计算并缓存
        for (i = [0 : links - 1]) {
            translate([i * link_length, 0, 0])
                rotate([0, i % 2 ? 90 : 0, 0])
                    difference() {
                        torus(r1 = link_width / 2, r2 = link_width / 4);
                        // 链接槽
                    }
        }
    }
}

module torus(r1, r2) {
    rotate_extrude(angle = 270)
        translate([r1, 0, 0])
            circle(r = r2);
}

// ---- 大型装配管理: 面向对象风格 ----
module assembly() {
    // 使用模块分层组织
    module frame() {
        color("gray", alpha = 0.5) {
            for (x = [-50, 50]) {
                for (y = [-30, 30]) {
                    translate([x, y, 0])
                        cylinder(r = 3, h = 40, center = true);
                }
            }
            // 横梁
            for (y = [-30, 30]) {
                translate([0, y, 20])
                    cube([100, 5, 3], center = true);
                translate([0, y, -20])
                    cube([100, 5, 3], center = true);
            }
        }
    }

    module panel() {
        color("steelblue", alpha = 0.4)
            translate([0, 0, 0])
                cube([90, 50, 2], center = true);
    }

    module electronics() {
        color("darkgreen") {
            translate([0, 10, 5]) cube([30, 15, 3], center = true);
            translate([0, -10, 5]) cube([20, 10, 2], center = true);
        }
    }

    frame();
    panel();
    electronics();
}

// ---- 展示 ----
translate([-60, 0, 0])
    detailed_part();

translate([0, -40, 0])
    difference() {
        cylinder(r = 25, h = 8, $fn = 80);
        bolt_pattern(n = 6, radius = 18, hole_d = 5)
            children();
    }

translate([50, 0, 0])
    assembly();
