// Example: Beveled Cube via hull
$fn=32;
hull() {
    translate([-10,-10,0])  sphere(r=2);
    translate([ 10,-10,0])  sphere(r=2);
    translate([-10, 10,0])  sphere(r=2);
    translate([ 10, 10,0])  sphere(r=2);
    translate([-10,-10,20]) sphere(r=2);
    translate([ 10,-10,20]) sphere(r=2);
    translate([-10, 10,20]) sphere(r=2);
    translate([ 10, 10,20]) sphere(r=2);
}
