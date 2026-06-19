//
// Example 04: Boolean Operations - union, difference, intersection
// Combining and cutting shapes like a real CAD.
//

$fn = 128;

// difference() - subtract the second (and later) objects from the first
difference() {
    // Main body
    cube([30, 30, 20], center = true);

    // Hole through the middle
    cylinder(h = 25, r = 8, center = true);
}

// union() - combine multiple objects (usually implicit, but explicit for clarity)
translate([40, 0, 0])
    union() {
        cube([20, 20, 10], center = true);
        cylinder(h = 20, r = 6, center = true);
    }

// intersection() - keep only the overlapping volume
translate([-40, 0, 0])
    intersection() {
        cube([20, 20, 20], center = true);
        sphere(r = 14);
    }
