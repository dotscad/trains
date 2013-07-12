/*
 * http://www.thingiverse.com/thing:55815
 *
 * Plastic collar to wrap around front/rear magnets on Brio style toy trains.
 *
 * Design is based on the style used by Thomas and Brio brand trains, with the
 * base of the cup between the magnet and the train.
 *
 * If you really want to produce an over-magnet version similar to what the
 * BigJigs brand uses, just call magnet_collar(false).  However, by placing
 * a layer of plastic between the magnet and nail head, you considerably
 * diminish the magnet's ability to hold your train cars together.
 *
 * Measurements are based on parts from Cherry Tree Toys.
 *
 *   magnet: http://www.cherrytreetoys.com/Ceramic-Magnet-P3616.aspx
 *
 *   nail:   http://www.cherrytreetoys.com/Nickel-Plated-Round-Head-Nail-P6052.aspx
 *
 *           Note that they changed suppliers and the nails you receive will
 *           not be barbed like the one in the photo.
 *
 * Copyright 2013 to Chris Petersen
 * License: http://creativecommons.org/licenses/by-sa/3.0/
 *
 * Find the latest versions of this and other related designs at:
 *
 *   https://github.com/ex-nerd/3d
 */

module magnet_collar(std_type=true, $fn=75) {
	// Magnet measurements:
	// First test got about 10% diameter shrinkage after cooling.  Compensate.
	radius = 6.25 / .95;
	height = 5.5;
	// Collar thickness; adjust to accommodate your extruder width
	thickness = .6;
	// Printing standard or BigJigs style?
	nail = std_type ? 1 : 5;
	// Render
	union() {
		difference() {
			cylinder(h = thickness+.4, r = radius + thickness/2, center = false);
			translate([0,0,-thickness])
				cylinder(h = 3 * thickness, r = nail, center = false);
		}
		rotate_extrude(convexity = 10)
			union() {
				if (std_type == true) {
					translate([radius+thickness/2,height+thickness])
						circle(r = thickness/2);
				}
				translate([radius, 0])
					square([thickness,height+thickness]);
			}
	}
}

// Print two (for front and rear)
for(i=[1:2]) {
	translate([0, 17 * (i-1), 0])
		magnet_collar();
}
