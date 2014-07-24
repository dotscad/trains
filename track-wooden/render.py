#!/usr/bin/python

import os, sys
from dotscad import Customizer

if __name__ == '__main__':
    os.chdir(os.path.dirname(__file__))
    s = Customizer('track-standard.scad', debug=False)
    seen = {}

    # Render the plain straight track
    s.vars['right'].set('none')
    s.vars['left'].set('none')
    for size in s.vars['straight_size'].possible.parameters.keys():
        if size == "auto":
            continue
        s.vars['straight_size'].set(int(s.vars['straight_size'].possible[size]))
        for base in ('male', 'female',):
            s.vars['base'].set(base)
            for straight in ('male', 'female',):
                s.vars['straight'].set(straight)
                # build a nice name
                name = 'track-{0}-straight-{1}-{2}'.format(base, size, straight)
                if name in seen:
                    continue
                print name
                s.render_stl(name)
                seen[name] = True

    # Followed by any curves and splits
    s.vars['straight_size'].set('auto')
    for right in ('none', 'male', 'female',):
        s.vars['right'].set(right)
        for left in ('none', 'male', 'female',):
            s.vars['left'].set(left)
            # This set of track renderings requires at least one curve
            if (right == 'none' and left == 'none'):
                continue
            # Continue with the other vars
            for radius in ('small', 'large',):
                s.vars['radius'].set(s.vars['radius'].possible[radius])
                for straight in ('none', 'male', 'female',):
                    s.vars['straight'].set(straight)
                    for base in ('male', 'female',):
                        s.vars['base'].set(base)
                        # build a nice name
                        name = 'track-{0}-curve-{1}'.format(base, radius)
                        if right != 'none':
                            name += '-right-{0}'.format(right)
                        if left != 'none':
                            name += '-left-{0}'.format(left)
                        if straight != 'none':
                            name += '-straight-{0}'.format(straight)
                        if name in seen:
                            continue
                        print name
                        s.render_stl(name)
                        seen[name] = True
