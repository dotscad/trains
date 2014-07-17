#!/usr/bin/python

import os, sys
from dotscad import Customizer

if __name__ == '__main__':
    os.chdir(os.path.dirname(__file__))
    s = Customizer('track-standard.scad', debug=True)
    seen = {}
    # Render the plain straight track
    s.vars['right_curve'].set(False)
    s.vars['left_curve'].set(False)
    for size in s.vars['straight_length'].possible.parameters.keys():
        if int(s.vars['straight_length'].possible[size]) < int(s.vars['straight_length'].possible['xsmall']):
            continue
        s.vars['straight_length'].set(int(s.vars['straight_length'].possible[size]))
        for base_connector in ('male', 'female'):
            s.vars['base_connector'].set(base_connector)
            for straight_connector in ('male', 'female'):
                s.vars['straight_connector'].set(straight_connector)
                # build a nice name
                name = 'track-{0}-straight-{1}-{2}'.format(base_connector, size, straight_connector)
                if name in seen:
                    continue
                print name
                s.render_stl(name)
                seen[name] = True
    # Followed by any curves and splits
    for size in ('small', 'large',):
        # The straight piece accompanying a large curve in a switch is of "medium" size
        switch_straight_size = s.vars['straight_length'].possible[size if size == 'small' else 'medium']
        s.vars['radius'].set(s.vars['radius'].possible[size])
        for right_curve in (True, False):
            s.vars['right_curve'].set(right_curve)
            for left_curve in (True, False):
                s.vars['left_curve'].set(left_curve)
                if not(right_curve or left_curve):
                    continue
                for straight_length in (0, switch_straight_size):
                    s.vars['straight_length'].set(straight_length)
                    for base_connector in ('male', 'female',):
                        s.vars['base_connector'].set(base_connector)
                        for straight_connector in ('male', 'female',) if straight_length else ('male',):
                            s.vars['straight_connector'].set(straight_connector)
                            for right_connector in ('male', 'female',) if right_curve else ('male',):
                                s.vars['right_connector'].set(right_connector)
                                for left_connector in ('male', 'female',) if left_curve else ('male',):
                                    s.vars['left_connector'].set(left_connector)
                                    # build a nice name
                                    name = 'track-{0}-curve-{1}'.format(base_connector, size)
                                    if right_curve:
                                        name += '-right-{0}'.format(right_connector)
                                    if left_curve:
                                        name += '-left-{0}'.format(left_connector)
                                    if straight_length:
                                        name += '-straight-{0}'.format(straight_connector)
                                    if name in seen:
                                        continue
                                    print name
                                    s.render_stl(name)
                                    seen[name] = True
