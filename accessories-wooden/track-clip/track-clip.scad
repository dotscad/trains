/**
 * track-clip.scad
 *
 * Joiner clip for wooden toy train track, similar to SureTrack.
 *
 * @copyright  Chris Petersen, 2013
 * @license    http://creativecommons.org/licenses/by-sa/3.0/
 *
 * @see        http://www.thingiverse.com/thing:24332
 * @source     https://github.com/dotscad/trains/tree/master/accessories-wooden/track-clip/
 *
 * This OpenSCAD library is part of the [dotscad](https://github.com/dotscad/dotscad)
 * project, an open collection of modules and Things for 3d printing.
 */

//
// Customizer parameters and rendering
//

/* [Options] */

// Pinch angle (0 is vertical).  Adjust as needed for plastic strength so that it's easy to get on/off but still holds firmly to track.  7 works well for PLA.
pinch_angle = 7; // [0:15]

/* [Hidden] */

track_clip(pinch_angle);

//
// Module code below:
//

module track_clip(pinch_angle, $fn=100) {

    // Dimensions
    width  = 42; // Width of the trac
    height = 14; // Height of the side walls
    len    = 32; // Length of the connector (front to back, rendered here as top to bottom)
    s_len  = 21; // Length of the side arms of the connector.
    thick  = 2;  // Thickness of walls and base

    // Adjust for the orientation of the walls
    pinch = 90 - pinch_angle;

    // Overlap adjustment for manifold edges
    o=1;

    // Render one of the side walls of the clip
    module wall(pinch) {
        w=2;
        rotate(a=[pinch+180,0,0]) {
            translate(v=[0,-height, -thick])
            difference() {
                union() {
                    hull() rotate([0,90,0]) {
                        translate([-thick/2,-2,0]) cylinder(r=thick/2,h=s_len);
                        translate([-thick/2,height+thick/2-.5,0]) cylinder(r=thick/2,h=s_len);
                    }
                    bar();
                }
            }
        }
    }

    // Render the bar that runs on top of the side wall
    module bar($fn=25) {
        rotate([90,0,0]) {
            translate(v=[len/2-.5,0,0])
            rotate(a=[0,90,0])
            mirror([0,1,0])
            hull() {
                difference() {
                    cylinder(h=len-8, r=5, center=true);
                    translate(v=[-5-o/2,-thick,-(len)/2]) cube(size=[5+o,5*3+o,len+o], center=false);
                    translate(v=[-thick,-6-o/2,-(len)/2]) cube(size=[5*2,5*3+o,len+o], center=false);
                }
                translate([-thick/2,-3.75,0]) cylinder(r=thick/2,h=len-8, center=true);
                translate([-5+thick/2,-thick/2,0]) cylinder(r=thick/2,h=len-8, center=true);
                translate([-thick*.75,-thick*.75,0]) cylinder(r=thick*.75,h=len, center=true);
            }
        }
    }

    // Render the entire part
    rotate(a=[0,-90,0]) {
        difference() {
            union() {
                translate(v=[0,0,thick-.1]) union() {
                    translate(v=[0,thick,-.2]) wall(pinch);
                    translate(v=[0,width+thick*1.5,-.2]) mirror([0,1,0]) wall(pinch);
                }
                translate(v=[0,0,0]) hull() {
                    translate([0,thick/2,thick/2]) rotate([0,90,0]) cylinder(r=thick/2, h=len-5);
                    translate([0,width+thick*2,thick/2]) rotate([0,90,0]) cylinder(r=thick/2, h=len-5);
                    translate(v=[len,thick,thick/3]) sphere(r=thick/3);
                    translate(v=[len,width+thick,thick/3]) sphere(r=thick/3);
                }
            }
            // Subtract everything below and behind the adapter
            translate([-2,-2,-2+.001]) cube([50,60,2]);
            rotate(a=[0,90,0]) translate([-48,-2,-2+.001]) cube([50,60,2]);
            // debug stuff:
            //#rotate(a=[0,-90-pinch,90]) translate(v=[thick,-len-o,-len+o]) cube(size=[5,len+2*o,len+2*o], center=false);
            //#mirror([0,1,0]) rotate(a=[0,-90-pinch,90]) translate(v=[thick+width,-len-o,-len+o]) cube(size=[5,len+2*o,len+2*o], center=false);
            //rotate(a=[0,-(90-pinch),90]) translate(v=[thick+width,-len-o,-4*o]) cube(size=[5,len+2*o,len+2*o], center=false);
        }
    }

}
