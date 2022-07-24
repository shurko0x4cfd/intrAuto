
import sys
import re


wrongs_for_pull_request = \
	[
		'console.*log',
		'[\s]+cl[\s]*\(',
		'/\*[\s]*eslint-disable[\s]*\*/',

		'test\.introvert\.bz',
	]

warns_for_pr = \
	[
		'console.*trace',

		# Без закомментрованнго кода, того что похоже на него
		'((/\*|//).*(var|let).*=)',
		'((/\*|//).*function.*\(.*\).*{)',
		'((/\*|//).*\(.*\).*=>)',
	]
		
# На самом деле нет. Настройки могут быть, например, в конфиге
# obligate_for_pull_request = ['yadro\.introvert\.bz',]


wrongs_for_pack = ['yadro\.introvert\.bz',]
obligate_for_pack = ['something',]


wrongs_for_public = \
	[
		'yadroWidget',
		'YadroWidget',
		'yadroFunctions',
		'this\.code[\s]*='
	]

obligate_for_public = \
	[
		'const widget = this;',

		'this\.version =',
		'this\.intr_code =',
		'this\.modules =',

		'settings.*\(.*\)\s*{+|settings:[\s]*\(.*\)\s*=>',
		'bind_actions.*\(.*\)\s*{+|bind_actions:\s*\(.*\)\s*=>',
		'onSave.*\(.*\)\s*{+|onSave:\s*\(.*\)\s*=>',
		'init.*\(.*\)\s*{+|init:\s*\(.*\)\s*=>',

        'return handler\.wrap[\s]*\(.*\);',
	]


wrongs_for_private = ['something',]
obligate_for_private = ['this\.code =',]


wrongs_for_all = ['\s+\n+$',] # Без пробельных символов в концах строк
obligate_for_all = ['something',]


def join_re_lists (*regex_lists):
	return '|' .join (regex for regex_list in regex_lists for regex in regex_list)


def check (file, publicity, wrongspec = [], obligatespec = [], warn_spec = []):

	if publicity == 'public':
		wrongs =  wrongs_for_public
		obligate = obligate_for_public [:]
		
	else:
		wrongs =  wrongs_for_private
		obligate = obligate_for_private [:]

	obligate .extend (obligatespec)
	wrongs = join_re_lists (wrongs, wrongspec, wrongs_for_all)
	warn_spec = join_re_lists (warn_spec)
	bad_place = ''

	with open (file, 'r', encoding = 'utf-8') as f:

		for line_text in f:
			searched = re .search(wrongs, line_text)
			warns = re .search (warn_spec, line_text)

			if searched:
				string = searched .string
				bad_place = string [searched .start () : searched .end ()] .split ('\n') [0]

				if re .search ('\s+\n+$', string):
					print ('check: A lines must not ends with space chars')
				else:
					print ('check: A file like script.js must not contain \'' + bad_place + '\'')

			if warns:
				print ("\check: warning: May be problem place: '" + warns .string + "'")

	with open (file, 'r', encoding = 'utf-8') as f:
		for line_text in f:
			for idx, regex in enumerate (obligate):
				searched = re .search(regex, line_text)
				if searched:
					# Могут ли быть проблемы из-за изменения списка во время его итерирования?
					del obligate [idx]

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
	check (file, publicity, wrongs_for_pull_request, warn_spec = warns_for_pr)


def for_pack (file, publicity):
	check (file, publicity, wrongs_for_pack)
                