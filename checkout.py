#!/usr/bin/python3

import os, sys
from intrman import settings


repath = settings .get_current () ['repository']
branch_name = sys .argv [1]


try:
    oldir = ''
    oldir = os .getcwd ()
    os .chdir (repath)

    os .system ('git checkout ' + branch_name)
    settings .set_current_branch (branch_name)
except:
    print ('Exception catched in ' + __file__ + ' Stopped')
finally:
    if oldir:
        os .chdir (oldir)


sys .exit ()
