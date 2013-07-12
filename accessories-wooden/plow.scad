/*
 * http://www.thingiverse.com/thing:54071
 *
 * Clip-on snow plow attachment designed for Brio/Thomas style wooden trains.
 *
 * This vertical-print version is designed to look more like the plow on the
 * "Adventures of Thomas" train than the original pattern (thing:54071).  It
 * also has a tilted-up bottom edge of the blade to hopefully prevent it from
 * getting stuck when the toy train goes down a slope.
 *
 * Because this version can snag at the bottom of a steep slope, I also have
 * a vertical-printing version designed to allow for a tilted bottom
 * edge that is less likely to have issues.  You can find it here:
 *
 *   http://www.thingiverse.com/thing:87677
 *
 * I also highly encourage you to use the mounting magnet cavity.  Just insert
 * the magnet (after double-checking polarity) and glue it into place with
 * epoxy or by manually extruding epoxy into the hole.
 * 
 * Mounting-magnet dimensions are based on:
 *
 *   http://www.cherrytreetoys.com/Ceramic-Magnet-P3616.aspx
 *
 * Copyright 2013 to Chris Petersen
 * License: http://creativecommons.org/licenses/by-sa/3.0/
 *
 * Find the latest versions of this and other related designs at:
 *
 *   https://github.com/ex-nerd/3d
 */

/*
 * Simple intersection method to implement a flat/truncated teardrop
 * (technique gathered from comments made by whosawhatsis on various forums/blogs).
 */
module flat_teardrop(radius, length, angle, $fn=100) {
	// From https://github.com/SolidCode/MCAD/blob/master/teardrop.scad but with the hard-coded $fn values removed
	module teardrop(radius, length, angle) {
		rotate([0, angle, 0]) {
			union() {
				linear_extrude(height = length, center = true, convexity = radius, twist = 0)
					circle(r = radius, center = true);
				linear_extrude(height = length, center = true, convexity = radius, twist = 0)
					projection(cut = false) rotate([0, -angle, 0]) translate([0, 0, radius * sin(45) * 1.5]) cylinder(h = radius * sin(45), r1 = radius * sin(45), r2 = 0, center = true);
			}
		}
	}
	intersection() {
		rotate([0, angle, 0]) {
			cube(size=[radius * 2, radius * 2, length], center=true);
		}
		teardrop(radius, length, angle);
	}
}

/*
 * Render the snow plow
 */
module plow($fn=100) {
	// Basic configuration
	w = 25.4; // Width of plow
	h = 19.8; // Height of plow
	d = 19;   // Depth (distance to tip) of plow (plus a little extra for the bullnose effect)
	// Radius of the hole to cut for the train's magnet to be insert into
	magnet_radius = 6.6;

	/*
	 * Creates one side of the curve of the plow blade.
	 * Intended to be mirrored.
	 */
	module half_cutout() {
	  hull() {
	    translate([70,44,h])
	      scale(v=[1,1,.05])
	          sphere(r=75);
	    translate([46,47.5,0])
	      scale(v=[1,1,.05])
	        sphere(r=50);
	  }
	}

	/*
	 * Creates both sides of the curve of the plow blade.
	 * Intended to be used with difference().
	 */
	module cutout() {
	  union() {
	    mirror([0,1,0])
	      half_cutout();
	    half_cutout();
	  }
	}

	/*
	 * The plow blade
	 */
	module blade() {
	  difference() {
	    translate([0,-w/2,0]) {
	      union() {
	        cube(size = [d,w,h]);
			// bullnose
	        translate([d-2.25,w/2,.75])
	          sphere(6);
	      }
	    }
	    translate([0,-w/2,-h])
	      cube([d*2,w,h]);
	    cutout();
	/*
	 * This section tilts the tip of blade of the plow slightly upwards.  It's commented out 
	 * because the overhang doesn't print.  However, the nose of the plow catches on the bottom
	 * of downward track slopes, so I've left it in for anyone who might want to try.  You'll
	 * need to adjust the depth (d) and bullnose section above to get things to look right.  I
	 * would also encourage you to look at the vertical-print version (thing:87677).
	 *
	    translate([14,-w/2-1,-h])
	      rotate(a=[0,-12,0])
	        cube(size = [d*2,w+2,h]);
	 */
	  }
	}

	/*
	 * Plow bpade and assembly to mount it to a wooden train.
	 */
	difference() {
	  union() {
	    blade();
	    translate([-4,-w/2,0])
	      cube(size = [5,w,h-5.4]);
	    /*
	     * These three tabs are meant to hold the plow in place, but may be cut off of the final
	     * piece if it fits your train particularly well.
	     */
	    translate([-12,8,0])
	      cube(size = [12,.6,11]);
	    translate([-12,-8,0])
	      cube(size = [12,.6,11]);
	    translate([-12,-8,0])
	      cube(size = [4,16,.5]);
	  }
	  // Train-magnet cavity
	  translate([-1,0,magnet_radius+.5])
	    flat_teardrop(magnet_radius, 8+1, 90);
	  // Mounting-magnet cavity (.2mm wall between it and the train's magnet)
	  translate([6.7,0,magnet_radius+.5])
	    union() {
	      flat_teardrop(magnet_radius, 6, 90);
		  translate([0,0,-magnet_radius/2-1])
	        cube(size=[6,magnet_radius * 2, magnet_radius+1], center=true);
	    } 
	}
}

plow();
