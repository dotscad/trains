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
 * @source     https://github.com/dotscad/trains/blob/master/track-wooden/points-track-y.scad
 */

/* ******************************************************************************
 * Thingiverse Customizer parameters and rendering.
 * Unfortunately, Customizer doesn't support multiple .scad files so this won't work.
 * ****************************************************************************** */

/* [Global] */

// Curve radius.  Sizes provided are standard.
radius = 87.5; // [87.5:small, 180:large]

// Angle of track to render.  45 is standard.
angle = 45; // [1:360]

// Length of the straight center line of track.  Set to zero to disable.
// @todo add other straight track measurements
straight_length = 102; // [0:none, 102:switch_small, 153:switch_large]

// Add a curve to the right?
right_curve = true; // [true,false]

// Add a curve to the left?
left_curve = true; // [true,false]

// Connector to place on the base end of the piece.
base_connector = "female"; // [male,female,none]

// Connector to place on the end of the left curve (if enabled).
left_connector = "female"; // [male,female,none]

// Connector on the straight/center line of track (if enabled).
straight_connector = "male"; // [male,female,none]

// Connector to place on the end of the right curve (if enabled).
right_connector = "female"; // [male,female,none]

/* [Hidden] */

// Render the part
render_track(straight_length, right_curve, left_curve, radius, angle, $fn=120);

/* ******************************************************************************
 * Main module code below:
 * ****************************************************************************** */

// Not sure where tracklib might be, so try to load it from a couple of locations.
use <../tracklib.scad>;
use <tracklib.scad>;

/*
 * @param int straight_length Length of the straight center line of track.  Set to zero to disable.
 * @param bool right_curve    Add a curve to the right?
 * @param bool left_curve     Add a curve to the left?
 * @param int radius          Radius of inner edge of the trac arc.  Standard track curves are 36cm and 17.5cm diameter.
 * @param int angle           Angle of track to render.  Standard track angle is 45 degrees.
 */
module render_track(straight_length, right_curve, left_curve, radius, angle) {
    translate([-radius,0,0]) difference() {
        union() {
            if (straight_length > 0) {
                translate([radius+wood_width(),0,0]) rotate([0,0,90]) wood_track(straight_length, false);
                if (straight_connector == "male") {
                    translate([radius+wood_width()/2,straight_length,0])
                        rotate([0,0,90])
                        wood_plug();
                }
            }
            if (left_curve) {
                wood_track_arc(radius, angle, false);
                if (left_connector == "male") {
                    rotate([0,0,angle])
                        translate([radius+wood_width()/2,0,0])
                        rotate([0,0,90])
                        wood_plug();
                }
            }
            if (right_curve) {
                translate([radius*2+wood_width(),0,0]) rotate([0,0,180-angle]) wood_track_arc(radius, angle, false);
                if (right_connector == "male") {
                    translate([radius*2+wood_width(),0,0]) rotate([0,0,180-angle])
                        translate([radius+wood_width()/2,0,0])
                        rotate([0,0,-90])
                        wood_plug();
                }
            }
            if (base_connector == "male") {
                translate([radius+wood_width()/2,0,0])
                    rotate([0,0,-90])
                    wood_plug();
            }
        }
        if (straight_length > 0 && straight_connector == "female") {
            translate([radius+wood_width()/2,straight_length,0])
                rotate([0,0,-90])
                wood_cutout();
        }
        if (left_curve && left_connector == "female") {
            rotate([0,0,angle])
                translate([radius+wood_width()/2,0,0])
                rotate([0,0,-90])
                wood_cutout();
        }
        if (right_curve && right_connector == "female") {
            translate([radius*2+wood_width(),0,0]) rotate([0,0,180-angle])
                translate([radius+wood_width()/2,0,0])
                rotate([0,0,90])
                wood_cutout();
        }
        if (base_connector == "female") {
            translate([radius+wood_width()/2,0,0])
                rotate([0,0,90])
                wood_cutout();
        }
        // Now we can subtract the "rails"
        union() {
            if (straight_length > 0) {
                translate([radius+wood_width(),0,0]) rotate([0,0,90]) wood_rails(straight_length);
            }
            if (left_curve) {
                wood_rails_arc(radius, angle);
            }
            if (right_curve) {
                translate([radius*2+wood_width(),0,0]) rotate([0,0,180-angle]) wood_rails_arc(radius, angle);
            }
        }
    }
}
