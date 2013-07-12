// Global resolution for round edges
$fn=50;

// Length of the straight track.  Standard wooden unit is 53.5mm but I don't think we need that.
length = 25;

// Track width is 40mm
width=40;

// Standard track height is 12mm
height=12;

// Wood and trackmaster have slightly different heights for the wheel wells
wood_height=9;
tm_height=8.4;

// Overlap (to prevent printing glitches)
o=1;

// Bevel size
bevel_length=1;

/* ****************************************************************************** */

bevel = o + bevel_length;

bevel_pad = sqrt(.5)*(o/2);

// Individual piece of straight track
module track(l) {
	well_width=5.7;
	well_spacing=19.25;
	well_padding=(width - well_spacing - (2*well_width))/2;
	blen = l + 2 * o;
	difference() {
		cube(size = [l,width,height]);
		// Wheel wells
		for (i = [well_padding, width - well_padding - well_width]) {
			translate(v=[-o,i,wood_height]) {
				cube(size = [l+o+o,well_width,height-wood_height+o]);
			}
		}
		// Bevels on wheel wells
		for (i = [ well_padding+bevel_pad, well_padding+well_width-bevel_pad, width - well_padding - well_width+bevel_pad, width - well_padding-bevel_pad ]) {
			// top side
			translate(v=[l/2,i,height + bevel_pad]) {
				rotate(a=[45,0,0]) {
					cube(size = [blen,bevel,bevel], center=true);
				}
			}
			// outer faces
			for (j=[-bevel_pad,l+bevel_pad]) {
				translate(v=[j,i,height-((height-wood_height-o)/2)]) {
					rotate(a=[0,0,45]) {
						cube(size = [bevel,bevel,height-wood_height+o], center=true);
					}
				}
			}
		}
		// Bevels on the track sides
		for (i=[ [l/2,-bevel_pad,height+bevel_pad], [l/2,width+bevel_pad,-bevel_pad] ]) {
			translate(v=i) {
				rotate(a=[45,0,0]) {
					cube(size = [blen,bevel,bevel], center=true);
				}
			}
		}
		for (i=[ [l/2,-bevel_pad,-bevel_pad], [l/2,width+bevel_pad,height+bevel_pad] ]) {
			translate(v=i) {
				rotate(a=[-45,0,0]) {
					cube(size = [blen,bevel,bevel], center=true);
				}
			}
		}
	}
}

// Trackmaster plug
module tm_plug() {
	difference() {
		union() {
			translate(v=[-o,-2.5,0]) {
				hull() {
					translate([0,0,1])
						cube(size=[o+4.75,5,tm_height-2]);
					translate([0,1,0])
						cube(size=[o+4.75,5-2,tm_height]);
				}
			}
			translate(v=[4.75,0,1]) {
				hull() {
					translate([0,0,-1])
						cylinder(h=tm_height,r=2.8);
					cylinder(h=tm_height-2,r=3.8);
				}
			}
		}
		translate(v=[2,-.6,-o]) {
			cube(size=[6+o,1.2,tm_height+o+o]);
		}
		translate(v=[4.75,0,-o]) {
			cylinder(h=tm_height+o+o, r=1.75);
		}
	}
}

// Cutout for trackmaster track, centered on its Y axis
module tm_cutout() {
	radius = 4.5;
	bh=sqrt(.5)*(bevel_length+o);
	rs=sqrt(.5)*(o/2);
	rb=bh-rs;
	hpad=sqrt(.5)*(bevel_length/2);
	union() {
		translate(v=[-o,-3.75,-o]) {
			cube(size=[o+3.75,7.5,height+o+o]);
		}
		translate(v=[(1/2)+radius,0,height/2]) {
			cylinder(h=height+o+o,r=radius,center=true);
		}
		// bevelled edges
		translate(v=[(1/2)+radius,0,height-hpad]) {
			cylinder(h=bh,r1=radius-rs, r2=radius+rb, center=true);
		}
		translate(v=[(1/2)+radius,0,hpad]) {
			cylinder(h=bh,r1=radius+rb,r2=radius-rs, center=true);
		}
		for (i=[ 3.4-bevel_pad, -3.4+bevel_pad ]) {
			for (j=[ height+bevel_pad, -bevel_pad ]) {
				translate(v=[(1-o)/2,i,j]) {
					rotate(a=[45,0,0]) {
						cube(size = [o+4.75,bevel,bevel], center=true);
					}
				}
			}
		}
	}
}

// Cutout for wooden track, centered on its Y axis
module wood_cutout() {
	radius=6.3;
	bh=sqrt(.5)*(bevel_length+o);
	rs=sqrt(.5)*(o/2);
	rb=bh-rs;
	hpad=sqrt(.5)*(bevel_length/2);
	union() {
		translate(v=[-o,-3.75,-o]) {
			cube(size=[o+11.8,7.5,height+o+o]);
		}
		translate(v=[4.5+radius,0,height/2]) {
			cylinder(h=height+o+o,r=radius, center=true);
		}
		// bevelled edges
		translate(v=[4.5+radius,0,height-hpad]) {
			cylinder(h=bh,r1=radius-rs, r2=radius+rb, center=true);
		}
		translate(v=[4.5+radius,0,hpad]) {
			cylinder(h=bh,r1=radius+rb,r2=radius-rs, center=true);
		}
		for (i=[ 3.75-bevel_pad, -3.75+bevel_pad ]) {
			for (j=[ height+bevel_pad, -bevel_pad ]) {
				translate(v=[(11.8-o)/2,i,j]) {
					rotate(a=[45,0,0]) {
						cube(size = [o+11.8,bevel,bevel], center=true);
					}
				}
			}
		}
	}
}

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

// Render the piece in trackmaster form
module render_trackmaster() {
	union() {
		difference() {
			track(length);
			translate(v=[length,6.6,0]) {
				rotate(a=[0,0,180]) {
					tm_cutout();
				}
			}
		}
		translate(v=[length,33.4,0]) {
			tm_plug();
		}
	}
}

// Female version
module adapter_female() {
	difference() {
		render_trackmaster();
		translate(v=[0,width/2,0]) {
			wood_cutout();
		}
	}
}

// Male version
module adapter_male() {
	union() {
		render_trackmaster();
		translate(v=[0,width/2,0]) {
			rotate(a=[0,0,180]) {
				wood_plug();
			}
		}
	}
}

//
// Render
//

translate(v=[0,25,0]) adapter_female();
difference() {
translate(v=[0,-25,0]) adapter_male();
//translate([-23,-30,-5]) #cube([50,50,50]);
}
