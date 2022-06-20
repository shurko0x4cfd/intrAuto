#!/usr/bin/python3

import sys
from intrman.version import increase_both as increase
from intrman import settings

current = settings .get_current ()
increase (current ['path'], current ['script'])

sys .exit ()
