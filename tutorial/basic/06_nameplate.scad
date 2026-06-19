//
// Example 06: Simple Project - A Desk Nameplate
// Combine everything learned to make something practical.
//

$fn = 64;

// --- Dimensions ---
plate_length = 80;
plate_width  = 25;
plate_height = 4;
letter_size  = 6;
letter_depth = 1.5;

module nameplate(text) {
    difference() {
        // Base plate
        cube([plate_length, plate_width, plate_height], center = true);

        // Engraved text on top face
        translate([0, 0, plate_height / 2 - letter_depth + 0.01])
            linear_extrude(height = letter_depth)
                text(text,
                     size   = letter_size,
                     font   = "Liberation Sans:style=Bold",
                     halign = "center",
                     valign = "center");
    }
}

// Make a nameplate
nameplate("OpenSCAD");

// Preview mode tip: press F5 to preview, F6 to render for export.
