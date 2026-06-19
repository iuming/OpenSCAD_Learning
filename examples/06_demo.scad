// Example: Cone Array
$fn=32;
for (x=[-2:2], y=[-2:2]) {
    translate([x*12, y*12, 0])
        cylinder(h=15, r1=5, r2=0);
}
