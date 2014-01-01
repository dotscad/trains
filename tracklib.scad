/**
 * A parametric library of modules for creating parts compatible with toy trains
 * (currently focused primarily on Thomas- and Brio-compatible wooden trains, as well as
 * Thomas Trackmaster (motorized plastic) and Take-N-Play (die cast).
 *
 * Some functions in this library require other [dotscad](https://github.com/dotscad/)
 * files.  I would recommend cloning that repository into the same parent directory
 * that contains this repository.
 *
 * This OpenSCAD library is part of the [dotscad](https://github.com/dotscad/dotscad)
 * project, an open collection of modules and Things for 3d printing.  Please check there
 * for the latest versions of this and other related files.
 *
 * @copyright  Chris Petersen, 2014
 * @license    http://creativecommons.org/licenses/LGPL/2.1/
 * @license    http://creativecommons.org/licenses/by-sa/3.0/
 *
 * @see        http://www.thingiverse.com/thing:216915
 * @source     https://github.com/dotscad/trains/blob/master/tracklib.scad
 */

// A global overlap variable (to prevent printing glitches)
o = .1;

// Constants for wooden track parts:
function wood_width()            = 40;
function wood_height()           = 12;
function wood_well_height()      = 9;
function wood_well_width()       = 5.7;
function wood_well_spacing()     = 19.25;
function wood_plug_radius()      = 6;
function wood_plug_neck_length() = 12;

// Constants for trackmaster parts
function trackmaster_width()            = 40;
function trackmaster_height()           = 12;
function trackmaster_well_height()      = 8.4;
function trackmaster_plug_radius()      = 3.8;
function trackmaster_plug_neck_length() = 4.75;

// @todo need to figure out what to call these variables...
// Bevel size
bevel_width = 1;
bevel = o + bevel_width;

/* ******************************************************************************
 * Include some other libraries
 * ****************************************************************************** */

// Not sure where the main dotscad files might be, so try to load from a few locations.
use <../../dotscad/pie.scad>;
use <../dotscad/pie.scad>;
use <dotscad/pie.scad>;
use <pie.scad>;

/* ******************************************************************************
 * Examples
 * ****************************************************************************** */

/*
 * When this file is opened directly in OpenSCAD, the following code will render an
 * example of the functions it provides.  This example will *not* render if this module
 * is imported into your own project via the `use` statement.
 */
tracklib_example();
module tracklib_example($fn=25) {
    // Wood pieces
    wood_track(10);
    translate([15,30,0]) wood_plug();
    translate([15,10,0]) difference() {
       translate([0,-wood_plug_radius()-2]) cube([wood_plug_neck_length() + wood_plug_radius() + 2, wood_plug_radius() * 2 + 4, wood_height()]);
        wood_cutout();
    }
    translate([-5,-10,0]) rotate([0,0,90]) wood_track_arc(10, 25, $fn=100);
    // Trackmaster pieces
    translate([40,30,0]) trackmaster_plug();
    translate([40,10,0]) difference() {
       translate([0,-trackmaster_plug_radius()-2]) cube([trackmaster_plug_neck_length() + trackmaster_plug_radius() + 2, trackmaster_plug_radius() * 2 + 4, trackmaster_height()]);
       trackmaster_cutout();
    }
}

/* ******************************************************************************
 * Modules useful to all varieties of train/track parts
 * ****************************************************************************** */

/**
 * Cutout (female) for track connector, centered on its Y axis.  Parameters to adjust for
 * wood or Trackmaster.
 * @param float radius      Radius of the cutout (recommended .3-.8 larger than plug)
 * @param float neck_length Length of the post's neck (edge of track to center of round cutout)
 */
module plug_cutout(radius, neck_length, track_height) {
    bevel_pad    = sqrt(.5)*(o/2);
    bevel_height = sqrt(.5)*(bevel_width+o);
    bevel_radius = bevel_height-bevel_pad;
    height_pad   = sqrt(.5)*(bevel_width/2);
    union() {
        translate(v=[-o,-3.75,-o]) {
            cube(size=[o+neck_length,7.5,track_height+o+o]);
        }
        translate(v=[neck_length,0,track_height/2]) {
            cylinder(h=track_height+o+o,r=radius, center=true);
        }
        // bevelled edges
        translate(v=[neck_length,0,track_height+o-height_pad]) {
            cylinder(h=bevel_height+o,r1=radius-bevel_pad, r2=radius+bevel_radius, center=true);
        }
        translate(v=[neck_length,0,height_pad-o]) {
            cylinder(h=bevel_height+o,r1=radius+bevel_radius,r2=radius-bevel_pad, center=true);
        }
        for (i=[ 3.75-bevel_pad, -3.75+bevel_pad ]) {
            for (j=[ track_height+bevel_pad, -bevel_pad ]) {
                translate(v=[(neck_length-o)/2,i,j]) {
                    rotate(a=[45,0,0]) {
                        cube(size = [o+neck_length,bevel,bevel], center=true);
                    }
                }
            }
        }
        // @todo if track_height < wood_height() then extend cylinder and edges upward to wood_height() so plug is properly subtracted from wood track
    }
}

/* ******************************************************************************
 * Modules dealing with wooden track/parts
 * ****************************************************************************** */

/**
 * 2d shape for basic wooden track.  To be used with linear_extrude() and rotate_extrude().
 */
module wood_track_2d() {
    well_width   = wood_well_width();
    well_spacing = wood_well_spacing();
    well_padding = (wood_width() - well_spacing - (2*well_width))/2;
    bevel_pad    = bevel_width*sqrt(.5)*(o/2);
    difference() {
        square(size = [wood_width(),wood_height()]);
        // Wheel wells
        for (i = [well_padding, wood_width() - well_padding - well_width]) {
            translate(v=[i,wood_well_height()]) {
                square([well_width,wood_height()-wood_well_height()+o]);
            }
        }
        // Bevels on wheel wells
        for (i = [ well_padding+bevel_pad, well_padding+well_width-bevel_pad, wood_width() - well_padding - well_width+bevel_pad, wood_width() - well_padding-bevel_pad ]) {
            // top side
            translate(v=[i,wood_height() + bevel_pad]) {
                rotate(a=[0,0,45]) {
                    square([bevel,bevel], center=true);
                }
            }
        }
        // Bevels on the track sides
        for (i=[ [-bevel_pad,wood_height()+bevel_pad], [wood_width()+bevel_pad,-bevel_pad], [-bevel_pad,-bevel_pad], [wood_width()+bevel_pad,wood_height()+bevel_pad] ]) {
            translate(v=i) {
                rotate(a=[0,0,45]) {
                    square([bevel,bevel], center=true);
                }
            }
        }
    }
}

/**
 * Individual piece of wooden track.  Same gauge as Trackmaster but not the same shape.
 * @param int length Length of track to render.  Standard short wooden length is 53.5mm.
 */
module wood_track(length=53.5) {
    well_width   = wood_well_width();
    well_spacing = wood_well_spacing();
    well_padding = (wood_width() - well_spacing - (2*well_width))/2;
    bevel_pad    = bevel_width*sqrt(.5)*(o/2);
    difference() {
        rotate([90,0,90]) linear_extrude(length, convexity = 10) wood_track_2d();
        // Bevels on outer faces of the wheel wells
        for (i = [ well_padding+bevel_pad, well_padding+well_width-bevel_pad, wood_width() - well_padding - well_width+bevel_pad, wood_width() - well_padding-bevel_pad ]) {
            for (j=[-bevel_pad,length+bevel_pad]) {
                translate(v=[j,i,wood_height()-((wood_height()-wood_well_height()-o)/2)]) {
                    rotate(a=[0,0,45]) {
                        cube(size = [bevel,bevel,wood_height()-wood_well_height()+o], center=true);
                    }
                }
            }
        }
    }
}

/**
 * Individual piece of wooden track, curved along an arc.
 * @param int radius Radius of inner edge of the trac arc.  Standard track curves are 36cm and 17.5cm diameter.
 * @param int angle  Angle of track to render.  Standard track angle is 45 degrees.
 */
module wood_track_arc(radius = 245/2, angle=45) {
    well_width   = wood_well_width();
    well_spacing = wood_well_spacing();
    well_padding = (wood_width() - well_spacing - (2*well_width))/2;
    bevel_pad    = bevel_width*sqrt(.5)*(o/2);
    difference() {
        intersection() {
            pie(radius + wood_width(), angle, wood_height());
            rotate_extrude(convexity = 10)
                translate([radius,0,0])
                wood_track_2d();
        }
        // Bevels on outer faces of the wheel wells
        for (a=[0,angle]) {
            rotate([0,0,a])
                translate([radius,0,0])
                rotate([0,0,-90])
                for (i = [ well_padding+bevel_pad, well_padding+well_width-bevel_pad, wood_width() - well_padding - well_width+bevel_pad, wood_width() - well_padding-bevel_pad ]) {
                    translate(v=[-bevel_pad,i,wood_height()-((wood_height()-wood_well_height()-o)/2)]) {
                        rotate(a=[0,0,45]) {
                            cube(size = [bevel,bevel,wood_height()-wood_well_height()+o], center=true);
                        }
                    }
                }
        }
    }
}

/**
 * Plug (male) for wooden track, centered on its y axis.
 * @param bool solid Render as a solid plug, or set to false for the "spring" variant.
 */
module wood_plug(solid=true) {
    neck_length = wood_plug_neck_length();
    // The width of the post depends on whether this is a "solid" or "spring" plug
    post_w = solid ? 6 : 3.5;
    // Render the part
    union() {
        translate(v=[-o,-post_w/2,0]) hull()
            assign(adjusted_length = solid ? neck_length : neck_length + wood_plug_radius() - bevel_width - o)
            {
                translate([0,0,1])
                    cube(size=[o+adjusted_length,post_w,wood_height()-2]);
                translate([0,1,0])
                    cube(size=[o+adjusted_length,post_w-2,wood_height()]);
        }
        difference() {
            translate(v=[neck_length,0,0]) {
                union() {
                    difference() {
                        hull() {
                            translate([0,0,1])
                                cylinder(h=wood_height()-2,r=wood_plug_radius());
                            cylinder(h=wood_height(),r=wood_plug_radius()-bevel_width);
                        }
                        if (!solid) {
                            translate(v=[-6,-3.2,-o])
                                cube(size=[6,6.4,wood_height()+o+o]);
                            translate(v=[0,0,-o])
                                cylinder(h=wood_height()+o+o,r=3.8);
                            translate(v=[-5,0,wood_height()/2+o]) rotate([0,0,45])
                                cube(size=[7,7,wood_height()+o+o], center=true);
                            translate(v=[-5,0,wood_height()/2+o]) rotate([0,0,0])
                                cube(size=[2,10,wood_height()+o+o], center=true);
                        }
                    }
                }
            }
        }
    }
}

/**
 * Cutout (female) for wooden track, centered on its Y axis
 */
module wood_cutout() {
    plug_cutout(wood_plug_radius() + .3, wood_plug_neck_length(), wood_height());
}

/* ******************************************************************************
 * Modules dealing with Trackmaster compatible track/parts
 * ****************************************************************************** */

/**
 * Plug (male) for Trackmaster track, centered on its Y axis
 */
module trackmaster_plug() {
    neck_length = trackmaster_plug_neck_length();
    difference() {
        union() {
            translate(v=[-o,-2.5,0]) {
                hull() {
                    translate([0,0,1])
                        cube(size=[o+neck_length,5,trackmaster_well_height()-2]);
                    translate([0,1,0])
                        cube(size=[o+neck_length,5-2,trackmaster_well_height()]);
                }
            }
            translate(v=[neck_length,0,0]) {
                hull() {
                    cylinder(h=trackmaster_well_height(),r=trackmaster_plug_radius()-bevel_width);
                    translate([0,0,1])
                        cylinder(h=trackmaster_well_height()-2,r=trackmaster_plug_radius());
                }
            }
        }
        translate(v=[2,-.6,-o]) {
            cube(size=[7+o,1.2,trackmaster_well_height()+o+o]);
        }
        translate(v=[4.75,0,-o]) {
            cylinder(h=trackmaster_well_height()+o+o, r=1.75);
        }
    }
}

/**
 * Cutout (female) for Trackmaster track, centered on its Y axis
 */
module trackmaster_cutout() {
    plug_cutout(trackmaster_plug_radius() + .7, trackmaster_plug_neck_length(), trackmaster_height());
}

