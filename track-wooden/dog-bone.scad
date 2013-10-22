/**
 * dog-bone.scad
 *
 * A simple dog-bone (male-male) connector for Thomas- and Brio-compatible wooden train
 * track.
 *
 * This renders in "solid" and "spring" variations.  The spring version is the original
 * design but the now-default solid version looks better and actually uses quite a bit
 * less filament (5-15% less for 25-15% infill).
 *
 * This openSCAD library is part of the [dotscad](https://github.com/dotscad/dotscad)
 * project.
 *
 * @copyright  Chris Petersen, 2013
 * @license    http://creativecommons.org/licenses/LGPL/2.1/
 * @license    http://creativecommons.org/licenses/by-sa/3.0/
 *
 * @see        http://www.thingiverse.com/thing:97263
 * @source     https://github.com/dotscad/trains/blob/master/track-wooden/dog-bone.scad
 */

/* ******************************************************************************
 * Customizer parameters and rendering
 * ****************************************************************************** */

/* [Global] */

// Render as a solid shape, or a spring?
solid = true;

/* [Hidden] */

// Render the part
dogbone(solid);

/* ******************************************************************************
 * Main module code below:
 * ****************************************************************************** */

// Not sure where tracklib might be, so try to load it from a couple of locations.
use <../tracklib.scad>; // github clone
use <tracklib.scad>;    // likely downloaded from thingiverse

/*
 * @param bool solid Render as a solid plug, or set to false for the "spring" variant.
 */
module dogbone(solid=true, $fn=25) {
    height = wood_height();
    // The width of the post depends on whether this is a "solid" or "spring" plug.
    // Post width is 6mm, but if the part is rendered in solid mode it will be handled
    // directly by the wood_plug() module.  When in "spring" mode, we must render a
    // thicker portion in the middle to prevent track pieces from wiggling/shearing
    // against each other.  To do this, we'll make slight adjustments from 6mm in order
    // to accommodate the hull() and cylinder() calls below.
    post_w = (6 - 1)/2;
    // Render the part
    union() {
        // Render the plugs
        wood_plug(solid);
        translate([0,0,0]) rotate([0,0,180]) wood_plug(solid);
        // If "spring" variant, render the thicker middle portion (no need to do so for
        // "solid" variants because it'd be covered up by the plug's own post).
        if (!solid) {
            translate([.25,0,height/2]) hull() {
                translate([4,post_w/2,0]) {
                    cylinder(h=height, r=1, center=true);
                    cylinder(h=height-2, r=2, center=true);
                }
                translate([-4,post_w/2,0]) {
                    cylinder(h=height, r=1, center=true);
                    cylinder(h=height-2, r=2, center=true);
                }
                translate([-4,-post_w/2,0]) {
                    cylinder(h=height, r=1, center=true);
                    cylinder(h=height-2, r=2, center=true);
                }
                translate([4,-post_w/2,0]) {
                    cylinder(h=height, r=1, center=true);
                    cylinder(h=height-2, r=2, center=true);
                }
                translate([6,0,0]) {
                    cylinder(h=height, r=1, center=true);
                    cylinder(h=height-2, r=2, center=true);
                }
                translate([-6,0,0]) {
                    cylinder(h=height, r=1, center=true);
                    cylinder(h=height-2, r=2, center=true);
                }
            }
        }
    }
}
