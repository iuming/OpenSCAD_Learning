//
// Example 05: Variables, Loops, and Modules
// From hard-coded to parametric - the real power of OpenSCAD.
//

$fn = 64;

// Variables
spacing = 25;
num = 5;
radius = 8;

// For loop: create a row of spheres
for (i = [0 : num - 1]) {
    translate([i * spacing - (num - 1) * spacing / 2, 0, 0])
        sphere(r = radius);
}

// Module: reusable component
module rounded_plate(w, d, h, r) {
    hull() {
        // Four corner cylinders
        for (x = [-1, 1], y = [-1, 1])
            translate([x * (w / 2 - r), y * (d / 2 - r), 0])
                cylinder(h = h, r = r);
    }
}

// Use the module
translate([0, -30, 0])
    rounded_plate(w = 40, d = 20, h = 5, r = 3);

translate([0, -50, 0])
    rounded_plate(w = 20, d = 20, h = 8, r = 5);
