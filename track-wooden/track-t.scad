/**
 * Parametric module to create a T-shaped intersection piece of track for Thomas- and
 * Brio-compatible wooden train sets.  Parameters allow for changing between the two
 * standard sizes for this shape of track, as well as control over the types of
 * connectors at each end of the track.
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
 * @see        http://www.thingiverse.com/thing:406570
 * @source     https://github.com/dotscad/trains/blob/master/track-wooden/track-t.scad
 */

/* ******************************************************************************
 * Thingiverse Customizer parameters and rendering.
 * Unfortunately, Customizer doesn't support multiple .scad files so this won't work.
 * ****************************************************************************** */

/* [Options] */

// Curve radius.  Sizes provided are standard.
radius = 126; // [87.5:small, 126:medium]

// Connector to place on the base end of the piece.
base = "female"; // [male,female]

// Connector to place on the end of the left curve.
left = "female"; // [male,female]

// Connector to place on the end of the right curve.
right = "female"; // [male,female]

/* [Hidden] */

// Lots of facets
$fn=120;

// Render the part
render_track(base, left, right, radius);

/* ******************************************************************************
 * Main module code below:
 * ****************************************************************************** */

// Not sure where tracklib might be, so try to load it from a couple of locations.
use <../tracklib.scad>;
use <tracklib.scad>;

/*
 */
module render_track(base, left, right, radius) {
    angle=90;
    // This results in a straight track at the top of the T that is not of the standard 2-inch length unit.
    // However, if we rounded the length up to the nearest 2-inch unit, we'd end up with a piece that is
    // equally awkward to place in a layout.  No matter where we place the curves in relation to the extra
    // length of straight track, we end up with one or both curves "offset" compared to standard switch
    // pieces.  It's better to just stick with what the wood track makers do and lock the length of the
    // straight track to the radius of the curve.
    t_length = 2*radius + wood_width();
    // @todo center the straight track
    translate([-radius,0,0]) difference() {
        union() {
            translate([0,radius,0]) wood_track(t_length, false);
            wood_track_arc(radius, angle, false);
            if (left == "male") {
                rotate([0,0,angle])
                    translate([radius+wood_width()/2,0,0])
                    rotate([0,0,90])
                    wood_plug();
            }
            translate([radius*2+wood_width(),0,0]) rotate([0,0,180-angle]) wood_track_arc(radius, angle, false);
            if (right == "male") {
                translate([radius*2+wood_width(),0,0]) rotate([0,0,180-angle])
                    translate([radius+wood_width()/2,0,0])
                    rotate([0,0,-90])
                    wood_plug();
            }
            if (base == "male") {
                translate([radius+wood_width()/2,0,0])
                    rotate([0,0,-90])
                    wood_plug();
            }
        }
        // Subtract any requested female connector regions
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
        translate([0,radius,0]) wood_rails(t_length);
        wood_rails_arc(radius, angle);
        translate([radius*2+wood_width(),0,0]) rotate([0,0,180-angle]) wood_rails_arc(radius, angle);
    }
}
