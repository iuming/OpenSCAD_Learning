// Example: Stacked Pyramids
$fn=4;
for (h=[0:3]) {
    translate([0, 0, h*10])
        cylinder(h=8, r1=12-h*2, r2=4);
}
