#!/usr/bin/python3

import sys
from intrman import check
from intrman.version import increase_both as increase
from intrman.zipack import pack
from intrman import settings
from intrman.auxiliary import get_intrauto_path


current = settings .get_current ()
path = current ['path']
intrauto_path = get_intrauto_path ()
print (intrauto_path)

check .for_pack (current ['full_path'], current ['publicity'])
increase (path, current ['script'])
pack (intrauto_path, path, current ['name'])


sys .exit ()
