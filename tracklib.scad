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
$o = .1;

// Constants for wooden track parts:
function wood_width()            = 40;
function wood_height()           = 12;
function wood_well_height()      = 9;
function wood_well_width()       = 5.7;
function wood_well_spacing()     = 19.25;
function wood_well_rim()         = (wood_width() - wood_well_spacing() - 2 * wood_well_width())/2;
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
bevel = $o + bevel_width;
function bevel() = bevel;

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
    translate([-5,-10,0]) rotate([0,0,90]) wood_track_arc(10, 25, $fn=120);
    translate([-14,-3,0]) rotate([0,0,90+25]) wood_track_slope(25, 30, $fn=120);
    #translate([-29,-10,6]) rotate([30,0,90+25]) wood_track_slope(25, -30, $fn=120);
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
    bevel_pad    = sqrt(.5)*($o/2);
    bevel_height = sqrt(.5)*(bevel_width+$o);
    bevel_radius = bevel_height-bevel_pad;
    height_pad   = sqrt(.5)*(bevel_width/2);
    union() {
        translate(v=[-$o,-3.75,-$o]) {
            cube(size=[$o+neck_length,7.5,track_height+$o+$o]);
        }
        translate(v=[neck_length,0,track_height/2]) {
            cylinder(h=track_height+$o+$o,r=radius, center=true);
        }
        // bevelled edges
        translate(v=[neck_length,0,track_height+$o-height_pad]) {
            cylinder(h=bevel_height+$o,r1=radius-bevel_pad, r2=radius+bevel_radius, center=true);
        }
        translate(v=[neck_length,0,height_pad-$o]) {
            cylinder(h=bevel_height+$o,r1=radius+bevel_radius,r2=radius-bevel_pad, center=true);
        }
        for (i=[ 3.75-bevel_pad, -3.75+bevel_pad ]) {
            for (j=[ track_height+bevel_pad, -bevel_pad ]) {
                translate(v=[(neck_length-$o)/2,i,j]) {
                    rotate(a=[45,0,0]) {
                        cube(size = [$o+neck_length,bevel,bevel], center=true);
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
 * 2d shape for basic wooden track.  To be used in conjunction with wood_rails_2d(),
 * linear_extrude(), and rotate_extrude().
 */
module wood_track_2d() {
    square(size = [wood_width(),wood_height()]);
}

/**
 * 2d shape for the rails (or wheel wells) in basic wooden track.  To be used with
 * wood_track_2d(), linear_extrude(), and rotate_extrude().
 */
module wood_rails_2d() {
    well_width   = wood_well_width();
    well_spacing = wood_well_spacing();
    well_padding = (wood_width() - well_spacing - (2*well_width))/2;
    bevel_pad    = bevel_width*sqrt(.5)*($o/2);
    union() {
        // Wheel wells
        for (i = [well_padding, wood_width() - well_padding - well_width]) {
            translate(v=[i,wood_well_height()]) {
                square([well_width,wood_height()-wood_well_height()+$o]);
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
    }
}

/**
 * Individual piece of wooden track.  Same gauge as Trackmaster but not the same shape.
 * @param int length Length of track to render.  Standard short wooden length is 53.5mm.
 * @param bool rails False if you do not want to include rails (wheel wells).
 */
module wood_track(length=53.5, rails=true) {
    difference() {
        rotate([90,0,90]) linear_extrude(length, convexity = 10) wood_track_2d();
        if (rails) {
            wood_rails(length);
        }
    }
}

/**
 * The rails for an individual piece of wooden track.  This module is intended to be used
 * inside of a difference() call to subtract the rails (wheel wells) from a piece of
 * track.  See wood_track() for usage example.
 * @param int length      Length of track to render.  Standard short wooden length is 53.5mm.
 * @param bool bevel_ends Bevel the outer edges of the rails.  Set to false if you intend to connect multiple rails together on the same piece of track.
 */
module wood_rails(length=53.5, bevel_ends=true) {
    well_width   = wood_well_width();
    well_spacing = wood_well_spacing();
    well_padding = (wood_width() - well_spacing - (2*well_width))/2;
    bevel_pad    = bevel_width*sqrt(.5)*($o/2);
    union() {
        rotate([90,0,90]) translate([0,0,-$o]) linear_extrude(length+2*$o, convexity = 20) wood_rails_2d();
        if (bevel_ends) {
            for (i = [ well_padding+bevel_pad, well_padding+well_width-bevel_pad, wood_width() - well_padding - well_width+bevel_pad, wood_width() - well_padding-bevel_pad ]) {
                for (j=[-bevel_pad,length+bevel_pad]) {
                    translate(v=[j,i,wood_height()-((wood_height()-wood_well_height()-$o)/2)]) {
                        rotate(a=[0,0,45]) {
                            cube(size = [bevel,bevel,wood_height()-wood_well_height()+$o], center=true);
                        }
                    }
                }
            }
        }
    }
}

/**
 * Individual piece of wooden track, curved along an arc.
 * Note:  For this to look good, I would suggest providing $fn=120 or greater.
 * @param int radius Radius of inner edge of the trac arc.  Standard track curves are 36cm and 17.5cm diameter.
 * @param int angle  Angle of track to render.  Standard track angle is 45 degrees.
 * @param bool rails False if you do not want to include rails (wheel wells).
 */
module wood_track_arc(radius = 245/2, angle=45, rails=true) {
    difference() {
        intersection() {
            pie(radius + wood_width(), angle, wood_height());
            rotate_extrude(convexity = 10)
                translate([radius,0,0])
                wood_track_2d();
        }
        if (rails) {
            wood_rails_arc(radius,angle);
        }
    }
}

/**
 * The rails for an individual piece of wooden track, curved along an arc.  This module
 * is intended to be used inside of a difference() call to subtract the rails (wheel
 * wells) from a piece of track.  See wood_track_arc() for usage example.
 * @param int radius      Radius of inner edge of the trac arc.  Standard track curves are 36cm and 17.5cm diameter.
 * @param int angle       Angle of track to render.  Standard track angle is 45 degrees.
 * @param bool bevel_ends Bevel the outer edges of the rails.  Set to false if you intend to connect multiple rails together on the same piece of track.
 */
module wood_rails_arc(radius = 245/2, angle=45, bevel_ends=true) {
    well_width   = wood_well_width();
    well_spacing = wood_well_spacing();
    well_padding = (wood_width() - well_spacing - (2*well_width))/2;
    bevel_pad    = bevel_width*sqrt(.5)*($o/2);
    union() {
        intersection() {
            rotate([0,0,-$o]) pie(radius + wood_width(), angle+2*$o, wood_height()+$o);
            rotate_extrude(convexity = 10)
                translate([radius,0,0])
                wood_rails_2d();
        }
        if (bevel_ends) {
            for (a=[0,angle]) {
                rotate([0,0,a])
                    translate([radius,0,0])
                    rotate([0,0,-90])
                    for (i = [ well_padding+bevel_pad, well_padding+well_width-bevel_pad, wood_width() - well_padding - well_width+bevel_pad, wood_width() - well_padding-bevel_pad ]) {
                        translate(v=[-bevel_pad,i,wood_height()-((wood_height()-wood_well_height()-$o)/2)]) {
                            rotate(a=[0,0,45]) {
                                cube(size = [bevel,bevel,wood_height()-wood_well_height()+$o], center=true);
                            }
                        }
                    }
            }
        }
    }
}

/**
 * Individual piece of wooden track, curved upward or downward at a slope.
 * Note:  For this to look good, I would suggest providing $fn=120 or greater.
 * @param int radius Radius of upper/top edge of the track slope.  Standard values seem to range 24.5-34cm
 * @param int angle  Positive or negative angle of slope to render.  Standard angles seem to range 20-30 degrees.
 * @param bool rails False if you do not want to include rails (wheel wells).
 */
module wood_track_slope(radius=25, angle=30, rails=true) {
    abs_angle = abs(angle); // convert the negative angle to positive

    // Really wish we could use "if" for this kind of stuff....
    angle_sign = (angle > 0) ? 1       : -1;
    trans_z    = (angle > 0) ? -radius : wood_height() - radius; // Note: inverted if angle > 0
    trans_x    = (angle > 0) ? 0       : -wood_width();          // Note: inverted if angle < 0

    difference() {
        rotate([0,90*angle_sign,0])
            translate([trans_z,0,trans_x])
            intersection() {
                pie(radius + wood_height(), abs_angle, wood_width());
                rotate_extrude(convexity = 10)
                    translate([radius,0,0])
                    rotate([0,0,90])
                    wood_track_2d();
            }
        if (rails) {
            wood_rails_slope(radius, angle);
        }
    }
}

/**
 * The rails for an individual piece of wooden track, curved up or down at a slope.  This
 * module is intended to be used inside of a difference() call to subtract the rails
 * (wheel wells) from a piece of track.  See wood_track_slope() for usage example.
 * @param int radius      Radius of upper/top edge of the track slope.  Standard values seem to range 24.5-34cm
 * @param int angle       Positive or negative angle of slope to render.  Standard angles seem to range 20-30 degrees.
 * @param bool bevel_ends Bevel the outer edges of the rails.  Set to false if you intend to connect multiple rails together on the same piece of track.
 */
module wood_rails_slope(radius=25, angle=30, bevel_ends=true) {
    abs_angle    = abs(angle) + 2 * $o; // convert the negative angle to positive, plus some overhang
    well_width   = wood_well_width();
    well_spacing = wood_well_spacing();
    well_padding = (wood_width() - well_spacing - (2*well_width))/2;
    bevel_pad    = bevel_width*sqrt(.5)*($o/2);

    // Really wish we could use "if" for this kind of stuff....
    angle_sign    = (angle > 0) ? 1                      : -1;
    pie_radius    = (angle > 0) ? radius + wood_height() : radius + $o;
    rails_radius  = (angle > 0) ? radius                 : radius - wood_height();
    bevels_radius = (angle > 0) ? radius                 : radius + wood_height() - (wood_height() - wood_well_height()) + $o;
    trans_z       = (angle > 0) ? -radius                : wood_height() - radius; // Note: inverted if angle > 0
    trans_x       = (angle > 0) ? 0                      : -wood_width();          // Note: inverted if angle < 0

    rotate([0,90*angle_sign,0])
        translate([trans_z,0,trans_x])
        union() {
            rotate([0,0,-$o])intersection() {
                pie(pie_radius, abs_angle, wood_width());
                rotate_extrude(convexity = 10)
                    translate([rails_radius, -trans_x,0])
                        rotate([0,0,90*angle_sign])
                        difference() {
                            wood_rails_2d();
                        }
            }
            if (bevel_ends) {
                for (a=[0,abs_angle]) {
                    rotate([0,0,a])
                        translate([bevels_radius,0,0])
                        rotate([90,0,0])
                        for (i = [ well_padding+bevel_pad, well_padding+well_width-bevel_pad, wood_width() - well_padding - well_width+bevel_pad, wood_width() - well_padding-bevel_pad ]) {
                            rotate([0,-90,0])
                            translate(v=[-bevel_pad,i,wood_height()-((wood_height()-wood_well_height()-$o)/2)]) {
                                rotate(a=[0,0,45]) {
                                    cube(size = [bevel,bevel,wood_height()-wood_well_height()+$o], center=true);
                                }
                            }
                        }
                }
            }
        }
}

/**
 * Plug (male) for wooden track, centered on its y axis.
 * @param float height      Height of the plug to render.  This should be left at the default but can be overridden in special cases.
 */
module wood_plug(height = wood_height()) {
    post_w = 6;
    // Render the part
    union() {
        translate(v=[-$o,-post_w/2,0])
            hull() {
                translate([0,0,1])
                    cube(size=[$o+wood_plug_neck_length(),post_w,height-2]);
                translate([0,1,0])
                    cube(size=[$o+wood_plug_neck_length(),post_w-2,height]);
        }
        translate(v=[wood_plug_neck_length(),0,0])
            hull() {
                translate([0,0,1])
                    cylinder(h=height-2,r=wood_plug_radius());
                cylinder(h=height,r=wood_plug_radius()-bevel_width);
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
            translate(v=[-$o,-2.5,0]) {
                hull() {
                    translate([0,0,1])
                        cube(size=[$o+neck_length,5,trackmaster_well_height()-2]);
                    translate([0,1,0])
                        cube(size=[$o+neck_length,5-2,trackmaster_well_height()]);
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
        translate(v=[2,-.6,-$o]) {
            cube(size=[7+$o,1.2,trackmaster_well_height()+$o+$o]);
        }
        translate(v=[4.75,0,-$o]) {
            cylinder(h=trackmaster_well_height()+$o+$o, r=1.75);
        }
    }
}

/**
 * Cutout (female) for Trackmaster track, centered on its Y axis
 */
module trackmaster_cutout() {
    plug_cutout(trackmaster_plug_radius() + .7, trackmaster_plug_neck_length(), trackmaster_height());
}

