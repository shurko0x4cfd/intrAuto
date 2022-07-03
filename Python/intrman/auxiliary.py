
import os


ONLY = 0


def get_intrman_path ():
	return os .path .dirname (__file__)


def get_intrauto_path ():
	intrman_path = get_intrman_path ()
	return os .path .split (intrman_path) [ONLY]
