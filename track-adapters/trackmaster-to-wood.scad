/**
 * An adapter to connect Thomas Trackmaster plastic track to Thomas- and Brio-compatible
 * wooden train track.
 *
 * To render this shape, you will need
 * [tracklib.scad](http://www.thingiverse.com/thing:216915) installed in the same
 * directory as this file, or the [dotscad/trains](https://github.com/dotscad/trains)
 * repository cloned in its entirety (which will include this file and tracklib.scad).
 *
 * This OpenSCAD library is part of the [dotscad](https://github.com/dotscad/dotscad)
 * project, an open collection of modules and Things for 3d printing.  Please check there
 * for the latest versions of this and other related files.
 *
 * @copyright  Chris Petersen, 2014
 * @license    http://creativecommons.org/licenses/LGPL/2.1/
 * @license    http://creativecommons.org/licenses/by-sa/3.0/
 *
 * @see        http://www.thingiverse.com/thing:24072
 * @source     https://github.com/dotscad/trains/blob/master/track-adapters/trackmaster-to-wood.scad
 */

/* ******************************************************************************
 * Thingiverse Customizer parameters and rendering.
 * Unfortunately, Customizer doesn't support multiple .scad files so this won't work.
 * ****************************************************************************** */

/* [Global] */

// Length of the straight track.  Standard wooden unit is 53.5mm but you probably don't need more than 20-25.
length = 25;

// Render the male part?
render_male = true;

// Render the female part?
render_female = true;

/* [Hidden] */

// Render the part(s)
trackmaster_to_wood(length, render_male, render_female);

/* ******************************************************************************
 * Main module code below:
 * ****************************************************************************** */

// Not sure where tracklib might be, so try to load it from a couple of locations.
use <../tracklib.scad>; // github clone
use <tracklib.scad>;    // likely downloaded from thingiverse

/**
 * @param int  length      Length of the straight track piece
 * @param bool render_male Render the male variation of the connector?
 * @param bool render_male Render the female variation of the connector?
 */
module trackmaster_to_wood(length, render_male=true, render_female=true, $fn=25) {
	// Submodule to render the "base" piece of wooden-style track plus the trackmaster connectors
	module trackmaster_base() {
		union() {
			difference() {
				wood_track(length);
				translate(v=[length,6.6,0]) {
					rotate(a=[0,0,180]) {
						trackmaster_cutout();
					}
				}
			}
			translate(v=[length,33.4,0]) {
				trackmaster_plug();
			}
		}
	}
	// Female version
	module adapter_female() {
		difference() {
			trackmaster_base();
			translate(v=[0,wood_width()/2,0]) {
				wood_cutout();
			}
		}
	}
	// Male version
	module adapter_male() {
		union() {
			trackmaster_base();
			translate(v=[0,wood_width()/2,0]) {
				rotate(a=[0,0,180]) {
					wood_plug();
				}
			}
		}
	}
	// Render the requested part(s)
	if (render_male) {
		adapter_male();
	}
	if (render_female) {
		assign(offset=render_male ? wood_width() + 5 : 0) {
			translate(v=[0,offset,0]) adapter_female();
		}
	}
}
