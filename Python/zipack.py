#!/usr/bin/python3

import os, sys
from intrman import check
from intrman.version import increase_both as increase
from intrman.zipack import pack
from intrman import settings


current = settings .get_current ()
widget_path = current ['path']
shared_dir = settings .shared_dir
zip_dir_rel = settings .get_all () ['path']['zip-dir']
zip_dir = os .path .join (shared_dir, zip_dir_rel)


check .for_pack (current ['full_path'], current ['publicity'])
increase (widget_path, current ['script'])
pack (zip_dir, widget_path, current ['name'])


sys .exit ()
