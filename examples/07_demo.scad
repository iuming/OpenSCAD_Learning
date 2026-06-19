// Example: Twisted Square Pillar
$fn=64;
linear_extrude(height=30, twist=180, slices=50)
    square([10,10], center=true);
