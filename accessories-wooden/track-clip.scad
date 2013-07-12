/*
 * http://www.thingiverse.com/thing:24332
 *
 * Joiner clip for wooden toy train track, similar to SureTrack.
 */

/* [Global] */

// Pinch angle (0 is vertical).  Adjust as needed for plastic strength so that it's  easy to get on/off but still holds firmly to track.
angle = 7; // [0:15]

/* [Hidden] */

// Other variables

width=42;

len = 32; // Length of the connector (front to back, though rendered here as top to bottom)
s_len=21; // Length of the side arms of the connector.

height = 14;

thick=2;

o=1;

/* ****************************************************************************** */

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
        bar2();
      }
    }
  }
}

module bar2($fn=25) {
rotate([90,0,0])
  translate(v=[len/2-.5,0,0])
  rotate(a=[0,90,0]) mirror([0,1,0])
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


module bar() {
  translate(v=[len/2-.5,0,0]) rotate(a=[0,90,0])
    difference() {
      union() {
        cylinder(h=len-8, r=5, center=true);
        translate(v=[0,0,-(len-8)/2]) sphere(5, center=false);
        translate(v=[0,0,(len-10)/2]) sphere(5, center=false);
      }
      translate(v=[-5-o/2,0,-(len+o)/2]) cube(size=[5+o,5+o,len+o], center=false);
      translate(v=[0,-6-o/2,-(len+o)/2]) cube(size=[5,5*5+o,len+o], center=false);
    }
}

module joiner(angle=10, $fn=100) {
  pinch = 90 - angle;
  rotate(a=[0,-90,0])
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
      //#rotate(a=[0,-90-pinch,90]) translate(v=[thick,-len-o,-len+o]) cube(size=[5,len+2*o,len+2*o], center=false);
      //#mirror([0,1,0]) rotate(a=[0,-90-pinch,90]) translate(v=[thick+width,-len-o,-len+o]) cube(size=[5,len+2*o,len+2*o], center=false);
      //rotate(a=[0,-(90-pinch),90]) translate(v=[thick+width,-len-o,-4*o]) cube(size=[5,len+2*o,len+2*o], center=false);
    }
}

joiner(angle);
