
import os, sys
import json
from tkinter import FIRST


FIRST = 0
SECOND = 1


this_module_dir = os .path .dirname (__file__)

shared_dir =  os .path .join (this_module_dir, '../../')

settings_path_rel = './settings/settings.json'
settings_full_path = os .path .join (shared_dir, settings_path_rel)


def get_all ():
	try:
		with open (settings_full_path, 'r') as settings_fd:
			return json .load (settings_fd)
	except:
		print ('Exception catched in ' + __file__ + ' .get_all (). Stopped')
		sys .exit ()


def save_all (all_settings):
	try:
		with open (settings_full_path, 'w') as settings_fd:
			return json .dump (all_settings, settings_fd, indent = 4)
	except:
		print ('Exception catched in ' + __file__ + ' .save_all (). Stopped')
		sys .exit ()


def get_current ():
	try:
		with open (settings_full_path, 'r') as settings_fd:
			settings = json .load (settings_fd)

			current = settings ['current']
			default = settings ['default']

			repository = current ['repository']
			branch = current ['branch']
			name = current ['widget']
			publicity = current ['publicity']
			widget = settings ['widgets'] [name] [publicity]
			dir = widget ['dir']
			max_version = widget ['max-version']
			script = default ['scriptname']

			if publicity == 'public':
				sub_dir = default ['subdir']
			else:
				sub_dir = ''

			path = os .path .join (repository, dir, sub_dir)
			full_path = os .path .join (path, script)

			return \
			  { 'repository': repository,
				'branch': branch,
				'name': name,
				'publicity': publicity,
				'widget': widget,
				'dir': dir,
				'max-version': max_version,
				'script': script,
				'sub_dir': sub_dir,
				'path': path,
				'full_path': full_path, }
	except:
		print ('Exception catched in ' + __file__ + ' .get_current (). Stopped')
		sys .exit ()


def set_current_branch (branch_name):
	try:
		all_settings = get_all ()
		all_settings ['current'] ['branch'] = branch_name
		save_all (all_settings)
	except:
		print ('Exception catched in ' + __file__ + ' .set_current_branch (). Stopped')
		sys .exit ()
