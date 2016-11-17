# dotscad.trains

This module is an attempt to create a comprehensive OpenSCAD library for
everything relating to modular toy trains most often seen under the Brio
and Thomas brand names (but not to exclude Bigjigs, Nuchi, Imaginarium, Maxim,
and several others I can no longer recall).

## module: tracklib.scad

The core of this is a `tracklib.scad` file, which contains OpenSCAD modules
for rendering various parts of train track for the different types of track
families (wooden, trackmaster, take-n-play).

To use this, you should link or install `tracklib.scad` into the correct [library location for your operating system](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Libraries) and then reference it from within any modules
you wish to create. E.g.

    use <tracklib.scad>;

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

Within each category, each Thing is organized into its own directory, where
you will find the necessary .scad file(s) along with the README, a rendered
STL file which you can interact examime directly in github, and possibly a
photo of the printed item.
