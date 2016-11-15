/**
 * Dog-bone (male-male) connector for Thomas- and Brio-compatible wooden train track.
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
 * @see        http://www.thingiverse.com/thing:97263
 * @source     https://github.com/dotscad/trains/blob/master/track-wooden/dog-bone.scad
 */

/* ******************************************************************************
 * Thingiverse Customizer parameters and rendering.
 * Unfortunately, Customizer doesn't support multiple .scad files so this won't work.
 * ****************************************************************************** */

/* [Options] */

// Nudge the length shorter, if necessary
length_nudge = 0; // [0:5]

/* [Hidden] */

// Don't need that many facets for a small part
$fn=50;

// Render the part
dogbone();

/* ******************************************************************************
 * Main module code below:
 * ****************************************************************************** */

// Not sure where tracklib might be, so try to load it from a couple of locations.
use <../tracklib.scad>; // github clone
use <tracklib.scad>;    // likely downloaded from thingiverse

module dogbone() {
    union() {
        wood_plug();
        translate([length_nudge,0,0]) rotate([0,0,180]) wood_plug();
    }
}
