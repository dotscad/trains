/**
 * Curved piece of track for Thomas- and Brio-compatible wooden train track.
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
 * @see        http://www.thingiverse.com/thing:216944
 * @source     https://github.com/dotscad/trains/blob/master/track-wooden/curved-track.scad
 */

/* ******************************************************************************
 * Thingiverse Customizer parameters and rendering.
 * Unfortunately, Customizer doesn't support multiple .scad files so this won't work.
 * ****************************************************************************** */

/* [Global] */

// Curve radius.  Sizes provided are standard.  Edit the .scad file manually for more control.
radius = 87.5; // [87.5:small, 180:large]

// Angle of track to render.  45 is standard.
angle = 45; // [1:360]

/* [Hidden] */

// Render the part
curved_track(radius, angle);

/* ******************************************************************************
 * Main module code below:
 * ****************************************************************************** */

// Not sure where tracklib might be, so try to load it from a couple of locations.
use <../tracklib.scad>;
use <tracklib.scad>;

/*
 * @param int radius Radius of inner edge of the trac arc.  Standard track curves are 36cm and 17.5cm diameter.
 * @param int angle  Angle of track to render.  Standard track angle is 45 degrees.
 */
module curved_track(radius, angle, $fn=100) {
    difference() {
        union() {
            wood_track_arc(radius=radius, angle=angle);
            translate([radius+wood_width()/2,0,0])
                rotate([0,0,-90])
                wood_plug();
        }
        rotate([0,0,angle])
            translate([radius+ wood_width()/2,0,0])
            rotate([0,0,-90])
            wood_cutout();
    }
}
