// Global resolution for round edges
$fn=75;

// Length of the straight track.  Standard wooden unit is 53.5mm but I don't think we need that.
length = 40;

// Track width is 40mm
width=40;

// Standard track height is 12mm
height=12;

// Wood and trackmaster have slightly different heights for the wheel wells
wood_height=9;
tm_height=8.4;

// Overlap (to prevent printing glitches)
o=1;

/* ****************************************************************************** */

// Variation on the wood-sized plug, with an attempt at a spring/pressure fit
module wood_plug() {
	union() {
		translate(v=[-o,-1.75,0]) {
			hull() {
				translate([0,0,1])
					cube(size=[o+17,3.5,height-2]);
				translate([0,1,0])
					cube(size=[o+16.5,1.5,height]);
			}
		}
		difference() {
			translate(v=[12,0,0]) {
				union() {
					difference() {
						hull() {
							translate([0,0,1])
								cylinder(h=height-2,r=5.8);
							cylinder(h=height,r=4.8);
						}
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

// A dog-bone connector (eventually to be moved into its own file)
module dogbone() {
    center_w = 2.5;
	union() {
		wood_plug();
		translate([0,0,0]) rotate([0,0,180]) wood_plug();
		translate([.25,0,height/2]) hull() {
			translate([4,center_w/2,0]) {
				cylinder(h=height, r=1, center=true);
				cylinder(h=height-2, r=2, center=true);
			}
			translate([-4,center_w/2,0]) {
				cylinder(h=height, r=1, center=true);
				cylinder(h=height-2, r=2, center=true);
			}
			translate([-4,-center_w/2,0]) {
				cylinder(h=height, r=1, center=true);
				cylinder(h=height-2, r=2, center=true);
			}
			translate([4,-center_w/2,0]) {
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

//
// Render
//

dogbone();
