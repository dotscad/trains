/**
 * Parametric module to create a piece of track for Thomas- and Brio-compatible wooden
 * train sets.  Parameters allow for straight or curved track as well as combinations
 * (switches or points), including recommended measurements based on wooden track for
 * "small" and "large" curves.
 *
 * To render this shape, you will need
 * [tracklib.scad](http://www.thingiverse.com/thing:216915) installed in the same
 * directory as this file, or the [dotscad/trains](https://github.com/dotscad/trains)
 * repository cloned in its entirety (which will include this file and tracklib.scad).
 *
 * This OpenSCAD library is part of the [dotscad](https://github.com/dotscad/dotscad)
 * project, an open collection of modules and Things for 3d printing.  Please check there
 * for the latest versions of this and other related files.
 *
 * @copyright  Chris Petersen, 2014
 * @license    http://creativecommons.org/licenses/LGPL/2.1/
 * @license    http://creativecommons.org/licenses/by-sa/3.0/
 *
 * @see        http://www.thingiverse.com/thing:395610
 * @source     https://github.com/dotscad/trains/blob/master/track-wooden/track-standard.scad
 */

/* ******************************************************************************
 * Thingiverse Customizer parameters and rendering.
 * Unfortunately, Customizer doesn't support multiple .scad files so this won't work.
 * ****************************************************************************** */

/* [Options] */

// Connector to place on the base end of the piece.
base = "female"; // [male,female]

// Render a curve to the left with the requested connector, or none for no curve.
left = "female"; // [male,female,none]

// Render a straight center track with the requested connector, or none for no straight track.
straight = "male"; // [male,female,none]

// Render a curve to the left with the requested connector, or none for no curve.
right = "female"; // [male,female,none]

// Length of the straight track, or auto to use the best fit for the requested curve radius.
straight_size = "auto"; // [auto:auto, 51:xsmall, 102:small, 152:medium, 203:large, 254:xlarge, 305:xxlarge]

// Curve radius.  Sizes provided are standard.
radius = 180; // [87.5:small, 180:large]

/* [Hidden] */

// Angle of track to render.  45 is standard.
angle = 45; // [1:360]

// Lots of facets
$fn=120;

// Render the part
render_track(base, left, straight, right, straight_size, radius, angle);

/* ******************************************************************************
 * Main module code below:
 * ****************************************************************************** */

// Not sure where tracklib might be, so try to load it from a couple of locations.
use <../tracklib.scad>;
use <tracklib.scad>;

/*
 * @param string base              Connector to place on the base end of the piece.
 * @param string left              Render a curve to the left with the requested connector, or none for no curve.
 * @param string straight          Render a straight center track with the requested connector, or none for no straight track.
 * @param string right             Render a curve to the left with the requested connector, or none for no curve.
 * @param string|int straight_size Length of the straight track, or auto to use the best fit for the requested curve radius.
 * @param float radius             Curve radius (usually 87.5 or 180)
 * @param float angle              Angle of track to render.  45 is standard
 */
module render_track(base, left, straight, right, straight_size, radius, angle) {
    straight_length = (
        straight_size == "auto"
        ? ((left == "none" && right == "none")
            ? -1 // Wish we could throw an exception in OpenSCAD
            : ((radius ==  87.5)
                ? 102
                : 152
            )
        )
        : straight_size
    );
    if (straight_length == -1) {
        echo("ERROR: When using straight_size==auto, you must render a right or left curve.");
    }
    else {
        translate([-radius,0,0]) difference() {
            union() {
                if (straight != "none") {
                    translate([radius+wood_width(),0,0])
                        rotate([0,0,90])
                        wood_track(straight_length, false);
                    if (straight == "male") {
                        translate([radius+wood_width()/2,straight_length,0])
                            rotate([0,0,90])
                            wood_plug();
                    }
                }
                if (left != "none") {
                    wood_track_arc(radius, angle, false);
                    if (left == "male") {
                        rotate([0,0,angle])
                            translate([radius+wood_width()/2,0,0])
                            rotate([0,0,90])
                            wood_plug();
                    }
                }
                if (right != "none") {
                    translate([radius*2+wood_width(),0,0])
                        rotate([0,0,180-angle])
                        wood_track_arc(radius, angle, false);
                    if (right == "male") {
                        translate([radius*2+wood_width(),0,0]) rotate([0,0,180-angle])
                            translate([radius+wood_width()/2,0,0])
                            rotate([0,0,-90])
                            wood_plug();
                    }
                }
                if (base == "male") {
                    translate([radius+wood_width()/2,0,0])
                        rotate([0,0,-90])
                        wood_plug();
                }
            }
            // Subtract any requested female connector regions
            if (straight == "female") {
                translate([radius+wood_width()/2,straight_length,0])
                    rotate([0,0,-90])
                    wood_cutout();
            }
            if (left == "female") {
                rotate([0,0,angle])
                    translate([radius+wood_width()/2,0,0])
                    rotate([0,0,-90])
                    wood_cutout();
            }
            if (right == "female") {
                translate([radius*2+wood_width(),0,0]) rotate([0,0,180-angle])
                    translate([radius+wood_width()/2,0,0])
                    rotate([0,0,90])
                    wood_cutout();
            }
            if (base == "female") {
                translate([radius+wood_width()/2,0,0])
                    rotate([0,0,90])
                    wood_cutout();
            }
            // Now we can subtract the "rails"
            if (straight != "none") {
                translate([radius+wood_width(),0,0]) rotate([0,0,90]) wood_rails(straight_length);
            }
            if (left != "none") {
                wood_rails_arc(radius, angle);
            }
            if (right != "none") {
                translate([radius*2+wood_width(),0,0]) rotate([0,0,180-angle]) wood_rails_arc(radius, angle);
            }
        }
    }
}
