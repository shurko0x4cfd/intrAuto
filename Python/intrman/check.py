
import sys
import re


wrongs_for_pull_request = \
		[
	        'console.*log',
			'[\s]+cl[\s]*\(',
			'/\*[\s]*eslint-disable[\s]*\*/',

			'test\.introvert\.bz',
		]
		
# На самом деле нет. Настройки могут быть, например, в конфиге
# obligate_for_pull_request = ['yadro\.introvert\.bz',]


wrongs_for_pack = ['yadro\.introvert\.bz',]
obligate_for_pack = ['something',]


wrongs_for_public = \
	['yadroWidget',
	'YadroWidget',
	'yadroFunctions',
	'this\.code[\s]*=']

obligate_for_public = \
	[
		'const widget = this;',

		'this\.version =',
		'this\.intr_code =',
		'this\.modules =',

		'settings[\s]*\(.*\)+[\s]*{+|settings:[\s]*\(.*\)+[\s]*=>[\s]*',
        'bind_actions[\s]*\(.*\)+[\s]*{+|bind_actions:[\s]*\(.*\)+[\s]*=>[\s]*',
        'onSave[\s]*\(.*\)+[\s]*{+|onSave:[\s]*\(.*\)+[\s]*=>[\s]*',
        'init[\s]*\(.*\)[\s]*{+|init:[\s]*\(.*\)[\s]*=>[\s]*',

        'return handler\.wrap[\s]*\(.*\);',
	]


wrongs_for_private = ['something',]
obligate_for_private = ['this\.code =',]


wrongs_for_all = ['[\s]+$',] # Без пробельных символов в концах строк
obligate_for_all = ['something',]


def join_re_lists (*regex_lists):
	return '|' .join (regex for regex_list in regex_lists for regex in regex_list)


def check (file, publicity, wrongspec = [], obligatespec = []):
	if publicity == 'public':
		wrongs =  wrongs_for_public
		obligate = obligate_for_public [:]
	else:
		wrongs =  wrongs_for_private
		obligate = obligate_for_private [:]

	obligate .extend (obligatespec)
	wrongs = join_re_lists (wrongs, wrongspec, wrongs_for_all)
	bad_place = ''

	with open (file, 'r', encoding = 'utf-8') as f:
		for line_text in f:
			searched = re .search(wrongs, line_text)
			if searched:
				bad_place = searched .string [searched .start () : searched .end ()]
				print ('check: A file like script.js must not contain \'' + bad_place + '\'. Stopped')

	with open (file, 'r', encoding = 'utf-8') as f:
		for line_text in f:
			for idx, regex in enumerate (obligate):
				searched = re .search(regex, line_text)
				if searched:
					del obligate [idx] # <- Могут быть проблемы из-за изменения списка во время его итерирования?

	oblen = obligate .__len__ ()

	if oblen > 1:
		s = 's'
	else:
		s = ''

	if oblen:
		print ('check: A file like script.js must contain an expression' + s +
			' corresponding to the following pattern' + s +
			': \n\t' + ' \n\t' .join (obligate) +
			'\n\tStopped')

	if bad_place or oblen: sys .exit ()


def for_pull_request (file, publicity):
	check (file, publicity, wrongs_for_pull_request)


def for_pack (file, publicity):
	check (file, publicity, wrongs_for_pack)
                