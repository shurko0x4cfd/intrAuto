
import sys
import re


wrongs_for_pull_request = \
		['test\.introvert\.bz',
		'/\*[\s]*eslint-disable[\s]*\*/',]
		
obligate_for_pull_request = ['yadro\.introvert\.bz',]

wrongs_for_pack = ['yadro\.introvert\.bz',]
obligate_for_pack = ['something',]

wrongs_for_public = \
	['yadroWidget',
	'YadroWidget',
	'yadroFunctions',
	'this\.code =']

obligate_for_public = \
   ['this\.version =',
	'this\.intr_code =',]

wrongs_for_private = ['',]
obligate_for_private = ['this\.code =',]

wrongs_for_all = ['something',]
obligate_for_all = ['something',]


def join_re_lists (*regex_lists):
	return '|' .join (regex for regex_list in regex_lists for regex in regex_list)


def check (file, publicity, wrongspec):
	if publicity == 'public':
		wrongs =  wrongs_for_public
	else:
		wrongs =  wrongs_for_private

	wrongs = join_re_lists (wrongs, wrongspec, wrongs_for_all)

	if not wrongs:
		return

	with open (file, 'r', encoding = 'utf-8') as f:
		for line_text in f:
			searched = re .search(wrongs, line_text)
			if searched:
				bad_place = searched .string [searched .start () : searched .end ()]
				print ('File should not contain \'' + bad_place + '\'. Stopped')
				sys .exit ()


def for_pull_request (file, publicity):
	check (file, publicity, wrongs_for_pull_request)


def for_pack (file, publicity):
	check (file, publicity, wrongs_for_pack)
                