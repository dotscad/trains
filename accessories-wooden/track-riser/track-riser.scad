/**
 * Parametric module to create a riser to support sloped wooden train tracks for
 * Thomas- and Brio-compatible wooden train sets.  Parameters allow for multiple
 * heights based on standard measurements
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
 * @copyright  Chris Petersen, 2016
 * @license    http://creativecommons.org/licenses/LGPL/2.1/
 * @license    http://creativecommons.org/licenses/by-sa/3.0/
 *
 * @see        http://www.thingiverse.com/thing:1656406
 * @source     https://github.com/dotscad/trains/blob/master/accessories-wooden/track-riser/track-riser.scad
 */

/* ******************************************************************************
 * Thingiverse Customizer parameters and rendering.
 * Unfortunately, Customizer doesn't support multiple .scad files so this won't work.
 * ****************************************************************************** */

/* [Options] */

// Connector to place each side of the piece.
left = "female"; // [male,female]
right = "male"; // [male,female]

// Length of the straight track, or auto to use the best fit for the requested curve radius.
length = 51; // [25:xxxsmall, 40:xxsmall, 51:xsmall]

// Height (one "unit" is 2.5 inches)
height = 63.5; // [auto:auto, 63.5:one, 127:two, 190.5:three]

// Height of the base support
base_height = 5; // [5..15]

/* [Hidden] */

// Overlap
$o = .01;

// Lots of facets
$fn=120;

// Render the part
render_part(left, right, length, height);


/* ******************************************************************************
 * Main module code below:
 * ****************************************************************************** */

// This needs to be installed somewhere global: https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Libraries
use <tracklib.scad>;

/*
 * @param string left              Male or female connector on the "left".
 * @param string right             Male or female connector on the "right".
 * @param float length             Length of track to render.
 * @param float height             Height of the riser.
 */
module render_part(left, right, length, height) {
    column_w = 10;
    difference() {
        union() {
            // Track
            translate([0,0,height])
                render_track(left, right, length);
            // Render the track again, slightly lower, to cover up the bottom edge bevel for male/female plugs
            translate([0,0,height-1])
                intersection() {
                    translate([wood_width()/4,-length/2,0])
                        cube([wood_width()/2,length*2, 10]);
                    render_track(left, right, length);
                }
            // Flate base structure
            render_base(length, base_height);
            // Vertical riser
            translate([wood_width()/2-(column_w/2),0,0])
                render_riser(length, column_w, height);
            // support for the track and any left/right plugs
            translate([0,0,height+$o])
                render_support(left, right, length);
        }
        // Cut out some space from the support, to save plastic
        *translate([wood_width()/2-column_w/2-$o,length/2,wood_width()/2+base_height])
            rotate([0,90,0])
            cylinder(h=column_w+2*$o, r=(height*.3));
    }
}

module render_riser(length, width, height, corner=3) {
    hull() {
        translate([corner,corner,0])
            cylinder(r=corner, h=height);
        translate([width-corner,corner,0])
            cylinder(r=corner, h=height);
        translate([corner,length-corner,0])
            cylinder(r=corner, h=height);
        translate([width-corner,length-corner,0])
            cylinder(r=corner, h=height);
    }
}

module render_base(length, height, corner=3) {
    intersection() {
        cube([wood_width(),length,height]);
        hull() {
            // Bottom layer
            translate([corner,corner,0])
                sphere(r=corner);
            translate([wood_width()-corner,corner,0])
                sphere(r=corner);
            translate([corner,length-corner,0])
                sphere(r=corner);
            translate([wood_width()-corner,length-corner,0])
                sphere(r=corner);
            // Top layer
            translate([corner,corner,height-corner])
                sphere(r=corner);
            translate([wood_width()-corner,corner,height-corner])
                sphere(r=corner);
            translate([corner,length-corner,height-corner])
                sphere(r=corner);
            translate([wood_width()-corner,length-corner,height-corner])
                sphere(r=corner);
        }
    }
}

module render_track(left, right, length) {
    difference() {
        union() {
            translate([wood_width(),0,0])
                rotate([0,0,90])
                wood_track(length);
            if (left == "male") {
                translate([wood_width()/2,length,0])
                    rotate([0,0,90])
                    wood_plug();
            }
            if (right == "male") {
                translate([wood_width()/2,0,0])
                    rotate([0,0,-90])
                    wood_plug();
            }
        }
        // Subtract any requested female connector regions
        if (left == "female") {
            translate([wood_width()/2,length,0])
                rotate([0,0,-90])
                wood_cutout();
        }
        if (right == "female") {
            translate([wood_width()/2,0,0])
                rotate([0,0,90])
                wood_cutout();
        }
    }
}

module render_support(left, right, length) {
    w = wood_width()/sqrt(2);
    difference() {
        union() {
            translate([0,0,-w])
                difference() {
                    intersection() {
                        cube([wood_width(),length,w]);
                        translate([0,0,w])
                            rotate([0,45,0])
                            cube([w,length,w]);
                    }
                    if (right == "female") {
                        translate([wood_width(),(-w*sqrt(2))/2,w/sqrt(2)-wood_height()])
                            rotate([0,45,90])
                            cube([w,wood_width(),w]);
                    }
                    if (left == "female") {
                       translate([wood_width(),length+(-w*sqrt(2))/2,w/sqrt(2)-wood_height()])
                            rotate([0,45,90])
                            cube([w,wood_width(),w]);
                    }
                }
            if (right == "male") {
                translate([0,-wood_plug_neck_length()-wood_plug_radius(),0])
                    render_plug_support();
            }
            else {
                translate([0,-5,0])
                    render_cutout_support();
            }
            if (left == "male") {
                translate([wood_width(),length+wood_plug_neck_length()+wood_plug_radius(),0])
                    rotate([0,0,180])
                    render_plug_support();
            }
            else {
                translate([wood_width(),length+5,0])
                    rotate([0,0,180])
                    render_cutout_support();
            }
        }
        // Save a little plastic, and make something that looks a tiny bit like a trestle support
        if (length > 44) {
            translate([wood_width(),length/2+(-w*sqrt(2))/2,w/sqrt(2)-wood_height()-w-1])
                rotate([0,45,90])
                cube([w,wood_width(),w]);
        }
    }
}

module render_cutout_support() {
    w = wood_width()/sqrt(2);
   translate([0,-1.5,0]) {
       intersection() {
            translate([wood_width()/2,wood_width()+1,-20])
                cylinder(h=40, r=wood_width());
            translate([0,0,-w])
                intersection() {
                    cube([wood_width(),w,w]);
                    translate([0,0,w])
                        rotate([0,45,0])
                        cube([w,w,w]);
                }
            translate([wood_width(),0,0])
                rotate([0,45,90])
                cube([w,wood_width(),w]);
        }
    }
}

module render_plug_support() {
    w = wood_width()/sqrt(2);
    // This supports only the plug.  Code left in place in case someone wants to change the design later.
    // intersection() {
    //     translate([wood_width()/2,0,-w+1+$o])
    //         rotate([0,0,-90])
    //         wood_plug(w+1+$o);
    //     translate([wood_width(),-wood_plug_neck_length()-wood_plug_radius(),0])
    //         rotate([0,45,90])
    //         cube([w,wood_width(),w]);
    // }
    // This supports everything around/under the plug
    intersection() {
        translate([wood_width()/2,.2+wood_width()/2,-20])
            cylinder(h=40, r=wood_width()/2+.2);
        translate([0,0,-w])
            intersection() {
                cube([wood_width(),w,w]);
                translate([0,0,w])
                    rotate([0,45,0])
                    cube([w,w,w]);
            }
        translate([wood_width(),0,0])
            rotate([0,45,90])
            cube([w,wood_width(),w]);
    }
}
