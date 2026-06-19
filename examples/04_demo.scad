// Example: Spiral Platform
$fn=64;
n=12; h=2;
for (i=[0:n-1]) {
    rotate([0,0,i*360/n*3])
        translate([10+i*0.5,0,i*h])
            cube([8, 3, h]);
}
