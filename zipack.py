#!/usr/bin/python3

import sys
from intrman import check
from intrman.version import increase_both as increase
from intrman.zipack import pack
from intrman import settings


current = settings .get_current ()
path = current ['path']

check .for_pack (current ['full_path'], current ['publicity'])
increase (path, current ['script'])
pack (current ['intrauto'], path, current ['name'])

sys .exit ()
