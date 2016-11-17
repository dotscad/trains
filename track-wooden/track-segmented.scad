/**
 * Parametric module to create a piece of segmented track for Thomas- and
 * Brio-compatible wooden train sets.  This is similar in play value to the
 * branded "wacky track" or "crazy track".  This includes its own brim to hold
 * the shape together while printing.  The included STL file matches size and
 * general curvature to standard "large curve" wooden tracks.

 * Advanced users can use parameters to customize the number of segments and
 * track appearance, but Thingiverse Customizer can't load the external
 * dependencies and the default values are the only ones that have been tested.
 *
 * To render this shape in OpenSCAD, you will need
 * [tracklib.scad](https://github.com/dotscad/trains) and
 * [dotscad](https://github.com/dotscad/dotscad).  See install instructions in
 * each of their github repositories.
 *
 * This OpenSCAD library is part of the [dotscad](https://github.com/dotscad/dotscad)
 * project, an open collection of modules and Things for 3d printing.  Please
 * check there for the latest versions of this and other related files.
 *
 * @copyright  Chris Petersen, 2014
 * @license    http://creativecommons.org/licenses/LGPL/2.1/
 * @license    http://creativecommons.org/licenses/by-sa/3.0/
 *
 * @see        http://www.thingiverse.com/thing:1897766
 * @source     https://github.com/dotscad/trains/blob/master/track-wooden/track-segmented.scad
 */

/* ******************************************************************************
 * Thingiverse Customizer parameters and rendering.
 * Unfortunately, Customizer doesn't support multiple .scad files so this won't work.
 * ****************************************************************************** */

/* [parameters] */

// Connector to place on the "left" end of the piece.
left = "male"; // [male,female]

// Connector to place on the "right" end of the piece.
right = "female"; // [male,female]

// Number of segments to render (9 matches a "large curve" wooden track).
segments = 9;

/* [Hidden] */

// A global overlap variable (to prevent printing glitches)
$o = .001;

// Lots of facets
$fn=25;

// A bunch of variables that I'd rather not be changed...

pad = .5; // extra to account for the bevel on the track edge
ring_buffer = 2;
ring_width = 6;
ring_length = 10 + ring_buffer;
ring_wall = 2.5;
hole_radius = (ring_length - 2*ring_wall)/2;
cutout_length = ring_length - ring_buffer + pad;
cutout_width1 = ring_width + pad;
cutout_width2 = cutout_width1 + 3;

pin_fudge = 1/cos(180/8); // see: https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/undersized_circular_objects
pin_r = 2*pin_fudge;

// Render the part
render_track(segments, left, right);

/* ******************************************************************************
 * Main module code below:
 * ****************************************************************************** */

// Import tracklib from globally-installed copy
use <tracklib.scad>;
use <dotscad/on_arc.scad>;
use <dotscad/pie.scad>;

module track_chain_segment(length=20, ring=true, pin=true) {

    // inside bevels of the pin cutout
    hole_edge_r = pin_fudge*(cutout_length/2);

    translate([0,-wood_width()/2, 0]) union() {
        difference() {
            wood_track(length);
            // Link pin cutout
            if (pin) {
                translate([length-cutout_length+$o,wood_width()/2 - ring_width/2, -$o]) {
                    hull() {
                        cube([$o,cutout_width1,wood_height()+2*$o]);
                        translate([cutout_length,ring_width/2-cutout_width2/2,0]) cube([$o,cutout_width2,wood_height()+2*$o]);
                    }
                }
            }
        }
        // Link ring
        if (ring) {
            translate([-ring_length,wood_width()/2 - ring_width/2, 0]) difference() {
                cube([ring_length+1,ring_width,wood_height()]); // pad 1 to account for the track's bevel edge
                hull() {
                    translate([hole_radius+ring_wall,ring_width+$o,hole_radius+ring_wall]) rotate([90,45/2,0]) cylinder(r=hole_radius, h=ring_width+2*$o, $fn=8);
                    translate([hole_radius+ring_wall,ring_width+$o,wood_height()-hole_radius-ring_wall]) rotate([90,45/2,0]) cylinder(r=hole_radius, h=ring_width+2*$o, $fn=8);
                    translate([ring_length-ring_buffer-hole_radius/pin_fudge-$o,ring_width+$o,wood_height()-hole_radius-ring_wall]) rotate([90,45/2,0]) cylinder(r=hole_radius, h=ring_width+2*$o, $fn=8);
                    translate([ring_length-ring_buffer-hole_radius/pin_fudge-$o,ring_width+$o,hole_radius+ring_wall]) rotate([90,45/2,0]) cylinder(r=hole_radius, h=ring_width+2*$o, $fn=8);
                }
                // TODO: bevel
                translate([-$o,ring_width/2,4+wood_height()]) rotate([0,45,0]) cube([ring_length,ring_width+2*$o,ring_length], center=true);
                translate([-$o,ring_width/2,-4]) rotate([0,45,0]) cube([ring_length,ring_width+2*$o,ring_length], center=true);
            }
        }
        // Link pin
        if (pin) {
            translate([length-pin_r/pin_fudge,wood_width()-$o, wood_height()/2]) {
                rotate([90,45/2,0]) cylinder(r=pin_r, h=wood_width()-2*$o, $fn=8);
            }
            translate([length-cutout_length-$o,wood_width()/2 - cutout_width2/2, 0])
                difference() {
                    cube([ring_buffer*2+$o,cutout_width2,wood_height()]);
                    translate([-ring_buffer+1,-$o,wood_height()/2]) rotate([0,45,0]) cube([wood_height(),cutout_width2+2*$o,wood_height()]);
                }
        }
     }
}

module left_segment(connector,segment_length) {
    if (connector == "female") {
        segment_left_pad = max(0, 32-segment_length);
        translate([-segment_left_pad,0,0]) difference() {
            track_chain_segment(segment_length+segment_left_pad, ring=false);
            translate([0,0,0]) wood_cutout();
        }
    } else {
        union() {
            track_chain_segment(segment_length, ring=false);
            rotate([0,0,180]) wood_plug();
        }
    }
}

module right_segment(connector,segment_length) {
    if (connector == "female") {
        segment_right_pad = max(0, 24-segment_length);
        difference() {
            track_chain_segment(segment_length+segment_right_pad, pin=false);
            translate([segment_length+segment_right_pad,0,0]) rotate([0,0,180]) wood_cutout();
        }
    } else {
        union() {
            track_chain_segment(segment_length, pin=false);
            translate([segment_length,0,0]) wood_plug();
        }
    }
}

/*
 * @param string left              Connector to place on the "left" end of the piece.
 * @param string right             Connector to place on the "right" end of the piece.
 * @param int    segnents          Number of track segments to render
 */
module render_track(segments, left, right) {
    // TODO: calculate some info based on segments
    segment_length = 14; // up to 20

    segment_left_pad = (left == "female") ? max(0, 32-segment_length) : 0;

    offset = segment_length+2.5;

    // Rotation angle, and radius that we'll need to move around
    a = 8;
    rad = (segment_length/2+ring_buffer) / sin(a/2);

    // Render the parts along an arc.
    // Note: no real point to do this because 12 segments is the same size
    //       straight or curved, and past that you need a print bed >24cm.
    arc = false;

    chain_segments = segments - 2;
    union() {
        // Left segment
        if (arc) {
            on_arc(rad, 0) rotate([0,0,-90])
                left_segment(left,segment_length);
        }
        else {
            left_segment(left,segment_length);
        }
        // Center chain links
        if (chain_segments > 0) {
            for (i = [1:chain_segments]) {
                if (arc) {
                    on_arc(rad, -a*i) rotate([0,0,-90]) track_chain_segment(segment_length);
                } else {
                    translate([segment_left_pad+i*(offset),0,0]) track_chain_segment(segment_length);
                }
            }
        }
        // Right segment
        if (arc) {
            on_arc(rad, -a*(chain_segments+1)) rotate([0,0,-90])
                right_segment(right, segment_length);
        } else {
            translate([segment_left_pad+(segments-1)*(offset),0,0])
                right_segment(right, segment_length);
        }
        // anti-peeling brim
        if (arc) {
            // See note about printing on an arc.  Wasn't worth continuing the
            // math to make this fit.  If you enable this, you're on your own
            // for a brim
            // translate([rad,0,0]) {
            //     union() {
            //         difference() {
            //             cylinder(r=rad+wood_width()/2-1, h=.2, $fn=100);
            //             translate([0,0,-$o]) cylinder(r=rad+wood_width()/2-3, h=1, $fn=100);
            //         }
            //         difference() {
            //             cylinder(r=rad+1, h=.2, $fn=100);
            //             translate([0,0,-$o]) cylinder(r=rad-1, h=1, $fn=100);
            //         }
            //         difference() {
            //             cylinder(r=rad-wood_width()/2+3.5, h=.2, $fn=100);
            //             translate([0,0,-$o]) cylinder(r=rad-wood_width()/2+1.5, h=1, $fn=100);
            //         }
            //     }
            // }
        } else {
            translate([3,-1,0]) cube([(offset)*(segments-1),2,.2]);
            translate([-5,wood_width()/2-2-.5*sqrt(2),0]) cube([(offset)*(segments+1),2,.2]);
            translate([-5,-wood_width()/2+.5*sqrt(2),0]) cube([(offset)*(segments+1),2,.2]);
        }
    }
}
