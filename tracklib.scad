/**
 * tracklib.scad
 *
 * A library of modules for creating parts compatible with toy trains (currently focused
 * primarily on Thomas- and Brio-compatible wooden trains, as well as Thomas Trackmaster
 * (motorized plastic) and Take-N-Play (die cast).
 *
 * This openSCAD library is part of the [dotscad](https://github.com/dotscad/dotscad)
 * project.
 *
 * @copyright  Chris Petersen, 2013
 * @license    http://creativecommons.org/licenses/LGPL/2.1/
 * @license    http://creativecommons.org/licenses/by-sa/3.0/
 *
 * @see        http://www.thingiverse.com/thing:?????
 * @source     https://github.com/dotscad/trains/blob/master/tracklib.scad
 */

// Constants for wooden track parts:
function wood_width()       = 40;
function wood_height()      = 12;
function wood_well_height() = 9;

// Constants for trackmaster parts
function trackmaster_width()       = 40;
function trackmaster_height()      = 12;
function trackmaster_well_height() = 8.4;

// A global overlap variable (to prevent printing glitches)
o=.1;

// A plug Variation on the wood-sized plug, with an attempt at a spring/pressure fit
module wood_plug(solid=true, $fn=50) {
    height = wood_height();
    // The width of the post depends on whether this is a "solid" or "spring" plug
    post_w = solid ? 6 : 3.5;
    // Render the part
    union() {
        translate(v=[-o,-post_w/2,0]) hull() {
            translate([0,0,1])
                cube(size=[o+17,post_w,height-2]);
            translate([0,1,0])
                cube(size=[o+16.5,post_w-2,height]);
        }
        difference() {
            translate(v=[12,0,0]) {
                union() {
                    difference() {
                        hull() {
                            translate([0,0,1])
                                cylinder(h=height-2,r=6);
                            cylinder(h=height,r=5);
                        }
                        if (!solid) {
                            translate(v=[-6,-3.2,-o])
                                cube(size=[6,6.4,height+o+o]);
                            translate(v=[0,0,-o])
                                cylinder(h=height+o+o,r=3.8);
                            translate(v=[-5,0,4+o+o]) rotate([0,0,45])
                                cube(size=[7,7,height+o+o], center=true);
                            translate(v=[-5,0,4+o+o]) rotate([0,0,0])
                                cube(size=[2,10,height+o+o], center=true);
                        }
                    }
                }
            }
        }
    }
}

