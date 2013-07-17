# dotscad.trains

This module is an attempt to create a comprehensive OpenSCAD library for everything
relating to modular toy trains most often seen under the Brio and Thomas brand names
(but not to exclude Bigjigs, Nuchi, Imaginarium, Maxim, and several others I can no
longer recall).

## module: tracklib.scad

The core of this will eventually be a `tracklib.scad` file (not currently separated from
the individual Things used to test its modules) which will contain OpenSCAD modules for
rendering various parts of train track for the different types of track families (wooden,
trackmaster, take-n-play).

I hope to have this module figured out over the next few weeks.

## Things

The actual Things in this repository are grouped together by category and
family:

* `parts.*`
    * Parts used to build compatible train toys
* `accessories.*`
    * Things used to accessorize the trains and enhance/improve play (e.g. a
      snow plow for wooden trains, or a clip to hold track together).
* `track-*`
    * Actual pieces of track, to supplement your own supply
* `track-adapters`
    * A special category for adapters used to bridge different families of
      track, or even different types of toy (e.g. Lego).

Within each category, each Thing is organized into its own directory, where you will
find the necessary .scad file(s) along with the README, an OpenSCAD screenshot, and
possibly a photo of the printed item.
