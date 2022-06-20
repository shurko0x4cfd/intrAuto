#!/usr/bin/python3

import sys
from intrman import settings, check


current = settings .get_current ()

check .for_pull_request (current ['full_path'], current ['publicity'])

sys .exit ()
