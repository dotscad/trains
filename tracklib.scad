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
function wood_width()        = 40;
function wood_height()       = 12;
function wood_well_height()  = 9;
function wood_well_width()   = 5.7;
function wood_well_spacing() = 19.25;

// Constants for trackmaster parts
function trackmaster_width()       = 40;
function trackmaster_height()      = 12;
function trackmaster_well_height() = 8.4;

// A global overlap variable (to prevent printing glitches)
o = .1;

// @todo need to figure out what to call these variables...
// Bevel size
bevel_width = 1;
bevel = o + bevel_width;
bevel_pad = sqrt(.5)*(o/2);

/* ******************************************************************************
 * Modules dealing with wooden track/parts
 * ****************************************************************************** */

/**
 * Individual piece of wooden track.  Same gauge as Trackmaster but not the same shape.
 * @param int l Length of track to render.  Standard short wooden length is 53.5mm
 */
module wood_track(length) {
	well_width   = wood_well_width();
	well_spacing = wood_well_spacing();
	well_padding = (wood_width() - well_spacing - (2*well_width))/2;
	assign(bevel_length = length + 2 * o)
	difference() {
		cube(size = [length,wood_width(),wood_height()]);
		// Wheel wells
		for (i = [well_padding, wood_width() - well_padding - well_width]) {
			translate(v=[-o,i,wood_well_height()]) {
				cube(size = [length+o+o,well_width,wood_height()-wood_well_height()+o]);
			}
		}
		// Bevels on wheel wells
		for (i = [ well_padding+bevel_pad, well_padding+well_width-bevel_pad, wood_width() - well_padding - well_width+bevel_pad, wood_width() - well_padding-bevel_pad ]) {
			// top side
			translate(v=[length/2,i,wood_height() + bevel_pad]) {
				rotate(a=[45,0,0]) {
					cube(size = [bevel_length,bevel,bevel], center=true);
				}
			}
			// outer faces
			for (j=[-bevel_pad,length+bevel_pad]) {
				translate(v=[j,i,wood_height()-((wood_height()-wood_well_height()-o)/2)]) {
					rotate(a=[0,0,45]) {
						cube(size = [bevel,bevel,wood_height()-wood_well_height()+o], center=true);
					}
				}
			}
		}
		// Bevels on the track sides
		for (i=[ [length/2,-bevel_pad,wood_height()+bevel_pad], [length/2,wood_width()+bevel_pad,-bevel_pad] ]) {
			translate(v=i) {
				rotate(a=[45,0,0]) {
					cube(size = [bevel_length,bevel,bevel], center=true);
				}
			}
		}
		for (i=[ [length/2,-bevel_pad,-bevel_pad], [length/2,wood_width()+bevel_pad,wood_height()+bevel_pad] ]) {
			translate(v=i) {
				rotate(a=[-45,0,0]) {
					cube(size = [bevel_length,bevel,bevel], center=true);
				}
			}
		}
	}
}

/**
 * Plug (male) for wooden track, centered on its y axis.
 * @param bool solid Render as a solid plug, or set to false for the "spring" variant.
 */
module wood_plug(solid=true, $fn=50) {
    // The width of the post depends on whether this is a "solid" or "spring" plug
    post_w = solid ? 6 : 3.5;
    // Render the part
    union() {
        translate(v=[-o,-post_w/2,0]) hull() {
            translate([0,0,1])
                cube(size=[o+17,post_w,wood_height()-2]);
            translate([0,1,0])
                cube(size=[o+16.5,post_w-2,wood_height()]);
        }
        difference() {
            translate(v=[12,0,0]) {
                union() {
                    difference() {
                        hull() {
                            translate([0,0,1])
                                cylinder(h=wood_height()-2,r=6);
                            cylinder(h=wood_height(),r=5);
                        }
                        if (!solid) {
                            translate(v=[-6,-3.2,-o])
                                cube(size=[6,6.4,wood_height()+o+o]);
                            translate(v=[0,0,-o])
                                cylinder(h=wood_height()+o+o,r=3.8);
                            translate(v=[-5,0,4+o+o]) rotate([0,0,45])
                                cube(size=[7,7,wood_height()+o+o], center=true);
                            translate(v=[-5,0,4+o+o]) rotate([0,0,0])
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
	radius=6.3;
	bh=sqrt(.5)*(bevel_width+o);
	rs=sqrt(.5)*(o/2);
	rb=bh-rs;
	hpad=sqrt(.5)*(bevel_width/2);
	union() {
		translate(v=[-o,-3.75,-o]) {
			cube(size=[o+11.8,7.5,wood_height()+o+o]);
		}
		translate(v=[4.5+radius,0,wood_height()/2]) {
			cylinder(h=wood_height()+o+o,r=radius, center=true);
		}
		// bevelled edges
		translate(v=[4.5+radius,0,wood_height()-hpad]) {
			cylinder(h=bh,r1=radius-rs, r2=radius+rb, center=true);
		}
		translate(v=[4.5+radius,0,hpad]) {
			cylinder(h=bh,r1=radius+rb,r2=radius-rs, center=true);
		}
		for (i=[ 3.75-bevel_pad, -3.75+bevel_pad ]) {
			for (j=[ wood_height()+bevel_pad, -bevel_pad ]) {
				translate(v=[(11.8-o)/2,i,j]) {
					rotate(a=[45,0,0]) {
						cube(size = [o+11.8,bevel,bevel], center=true);
					}
				}
			}
		}
	}
}

/* ******************************************************************************
 * Modules dealing with Trackmaster compatible track/parts
 * ****************************************************************************** */

/**
 * Plug (male) for Trackmaster track, centered on its Y axis
 */
module trackmaster_plug() {
	difference() {
		union() {
			translate(v=[-o,-2.5,0]) {
				hull() {
					translate([0,0,1])
						cube(size=[o+4.75,5,trackmaster_well_height()-2]);
					translate([0,1,0])
						cube(size=[o+4.75,5-2,trackmaster_well_height()]);
				}
			}
			translate(v=[4.75,0,1]) {
				hull() {
					translate([0,0,-1])
						cylinder(h=trackmaster_well_height(),r=2.8);
					cylinder(h=trackmaster_well_height()-2,r=3.8);
				}
			}
		}
		translate(v=[2,-.6,-o]) {
			cube(size=[6+o,1.2,trackmaster_well_height()+o+o]);
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
	radius = 4.5;
	bh=sqrt(.5)*(bevel_width+o);
	rs=sqrt(.5)*(o/2);
	rb=bh-rs;
	hpad=sqrt(.5)*(bevel_width/2);
	union() {
		translate(v=[-o,-3.75,-o]) {
			cube(size=[o+3.75,7.5,wood_height()+o+o]);
		}
		translate(v=[(1/2)+radius,0,wood_height()/2]) {
			cylinder(h=wood_height()+o+o,r=radius,center=true);
		}
		// bevelled edges
		translate(v=[(1/2)+radius,0,wood_height()-hpad]) {
			cylinder(h=bh,r1=radius-rs, r2=radius+rb, center=true);
		}
		translate(v=[(1/2)+radius,0,hpad]) {
			cylinder(h=bh,r1=radius+rb,r2=radius-rs, center=true);
		}
		for (i=[ 3.4-bevel_pad, -3.4+bevel_pad ]) {
			for (j=[ wood_height()+bevel_pad, -bevel_pad ]) {
				translate(v=[(1-o)/2,i,j]) {
					rotate(a=[45,0,0]) {
						cube(size = [o+4.75,bevel,bevel], center=true);
					}
				}
			}
		}
	}
}

