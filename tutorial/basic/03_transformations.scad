//
// Example 03: Transformations - translate, rotate, scale
// Moving, turning, and resizing objects.
//

$fn = 64;

// translate([x, y, z]) - move an object
translate([-20, 0, 0])
    sphere(r = 8);

// rotate([x_deg, y_deg, z_deg]) - rotate around axes
rotate([0, 45, 0])
    cube([10, 10, 20], center = true);

// scale([x, y, z]) - scale an object
translate([20, 0, 0])
    scale([1, 1.5, 1])
        sphere(r = 8);

// Combined transformations
translate([40, 0, 0])
    rotate([0, 0, 45])
        cube([10, 10, 15], center = true);
