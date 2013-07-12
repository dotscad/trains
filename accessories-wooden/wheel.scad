/*
 * http://www.thingiverse.com/thing:51968
 *
 * Wheel for building Brio/Thomas compatible wooden trains (and probably other small
 * vehicles, as well).
 *
 * There are instructions at the following site for how to build axels and assemble 
 * the wheels themselves:
 *
 *   https://sites.google.com/site/handmadewoodentrains/home/articles
 *
 * License: http://creativecommons.org/licenses/by-sa/3.0/
 *
 * Find the latest versions of this and other related designs at:
 *
 *   https://github.com/ex-nerd/3d
 */

/*
 * A small spacer to be glued to the inside of the wheel.  This will
 * help the final product roll better by reducing the surface area that
 * can come in contact with the body of the vehicle.
 *
 * It also just looks better.
 */
module wheel_spacer(axel_radius, $fn=100) {
	// Pad Thickness:
	thickness = 2.5;
	radius    = 3.5/.9;

	difference() {
		translate([radius + pad_radius + 1,0,0])
			rotate_extrude(convexity = 10)
				union() {
					translate([radius-thickness/2,thickness/2])
						circle(r = thickness/2);
					square([radius,thickness/2]);
					square([radius-thickness/2,thickness]);
				}
		// Axel cutout
		translate([0, 0, -.1])
			cylinder(h = thickness + .2, r = axel_radius);
	}
}

/*
 * Module to render a wheel for a toy train.  You'll want to print 4 or 6.
 */
module wheel(axel_radius, $fn=100) {

	// Diameters:
	//   Thomas: 19.4
	//   Thomas Early Engineers: 24
	//   Imaginarium: 20
	//   BigJigs: 21.8
	//   Brio: 20.4
	radius=10;

	// Wheel Thickness:
	// Note: Most wheels have a slight slant to them (.5mm or so), and were measured from the thicker end of the slant)
	//   Thomas: 2.5 collar,  3 - 4 - 7
	//   Thomas Early Engineers: 1.8 collar, 3.7 - 4.2 - 7.7
	//   Imaginarium: 2.8 - 5
	//   BigJigs: 3.2 - 6
	//   Brio: 3 - 5
	thickness = 3;
	bevel = 1;
	hub_thickness = 4;

	// Note: axel width
	// Thomas (all): 15mm (which is why the wheels need collars)
	// Everyone else: 20mm

	// Hub Radius
	// Based on a variety of Hillman's furniture tacks 10.7-11.8mm diameter, plus some wiggle
	hub_radius = 6;

	// Hub Collar
	// This thickness of the wall that is hub_thickness thick
	// measurement of 1.7mm is standard across non-Thomas wheels (Thomas wheels don't have a hub cap)
	hub_collar = 1.7;

	difference() {
		union() {
			rotate_extrude(height = 10, center = true, convexity = 10, twist = 0)
				polygon(points=[[0,0],[radius,0],[radius,thickness-bevel],[0,thickness]], paths=[[0,1,2,3,0]]);
			cylinder(h = hub_thickness, r = hub_radius+hub_collar, center = false);
		}
		union() {
			translate([0,0,thickness-bevel])
				cylinder(h = hub_thickness, r = hub_radius, center = false);
			translate([0,0,-.1])
				cylinder(h = hub_thickness + .1, r = axel_radius);
		}
	}
}


// Axel radius is based on 3/32" tubing size measuring 2.25mm outside diameter, with a little wiggle room and adjust for shrinking
axel_radius = 1.13 / .9;

// Render
wheel(axel_radius);
translate([15,0,0])
	wheel_spacer(axel_radius);
