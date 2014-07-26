#!/usr/bin/python

import os, sys
from dotscad import Customizer

if __name__ == '__main__':
    os.chdir(os.path.dirname(__file__))
    s = Customizer('track-t.scad', debug=False)
    seen = {}

    # Render all possible options
    for radius in s.vars['radius'].possible.parameters.keys():
        s.vars['radius'].set(s.vars['radius'].possible[radius])
        for base in s.vars['base'].possible.parameters.keys():
            s.vars['base'].set(base)
            for left in s.vars['left'].possible.parameters.keys():
                s.vars['left'].set(left)
                for right in s.vars['right'].possible.parameters.keys():
                    s.vars['right'].set(right)
                    # build a nice name
                    name = 'track-t-stl/track-t-{0}-{1}-left-{2}-right-{3}'.format(radius, base, left, right)
                    if name in seen:
                        continue
                    print name
                    s.render_stl(dest=name, overwrite=False)
                    seen[name] = True

