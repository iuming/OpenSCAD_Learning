//
// Example 02: Basic Shapes - Cube, Sphere, Cylinder
// The three fundamental 3D primitives in OpenSCAD.
//

$fn = 64;  // Fragment number: higher = smoother circles

// Cube: [width, depth, height]
translate([-25, 0, 0])
    cube([15, 15, 15], center = true);

// Sphere: radius
translate([0, 0, 0])
    sphere(r = 10);

// Cylinder: height, bottom radius, top radius
translate([25, 0, 0])
    cylinder(h = 15, r1 = 8, r2 = 8, center = true);
