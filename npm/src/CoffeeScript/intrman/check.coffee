
# Проверяет файлы на отсутствие недопустимых выражений и наличие обязательных

import { execSync as exec_sync  } from 'child_process'
import { read_line_while, get_branch } from './auxiliary.js'
import { FIRST, u, cl, first, arr, join, empty, aprodec } from 'raffinade'


# TODO:
# Так же необходимо проверять файл манифеста - webhook_url в манифесте
# проверять версию handler.js - должна быть последней
# проверять, реализован ли хотя бы onBlocked_
# проверять, что в одной ветке нет одновременного изменения фронта и бэка
# в публичных виджетах (по умолчаню) обязтелен каталог widget или backend.
# (но не оба сразу?)

# переместить регулярки в таблицы со строками вида:
# 1: regex_uid, regex, comment и
# 2: rule_uid, regex_uid, comment, flags,
# где flags - последовательность или массив флагов наподобии wrong, obligate,
# warning, notice, pack, pr, pull_request, public, private,
# флаг нечувствительности к регистру (по умолчанию чувствително), а так же
# необязательные js и php, если из расширеня файла нельзя правильно
# определить содержимое
# текст сообщения при ошибке, строковый идентификатор правила, чтобы добавлять
# в исключения по нему


wrongs_for_pack = ['yadro\\.introvert\\.bz']
obligate_for_pack = ['something']


wrongs_for_pr = \
	[
		'console.*log',
		'\\s+cl\\s*\\(',
		'/\\*\\s*eslint-disable\\s*\\*/',
		'test\\.introvert\\.bz'
	]

warns_for_pr = \
	[
		'console.*trace',

		# Без закомментрованнго кода, того что похоже на него
		'((/\\*|//).*(var|let).*=)',
		'((/\\*|//).*function.*(.*).*{)',
		'((/\\*|//).*(.*).*=>)',
	]

# На самом деле нет. Настройки могут быть, например, в конфиге
# obligate_for_pull_request = ['yadro\\.introvert\\.bz',]

wrongs_for_public = \
	[
		'yadroWidget',
		'YadroWidget',
		'yadroFunctions',
		'this\\.code\\s*='
	]

obligate_for_public = \
	[
		'const widget = this;',

		'this\\.version\\s*=',
		'this\\.intr_code\\s*=',
		'this\\.modules\\s*=',

		'settings.*\\(.*\\)\\s*{+|settings:\\s*\\(.*\\)\\s*=>',
		'bind_actions.*\\(.*\\)\\s*{+|bind_actions:\\s*\\(.*\\)\\s*=>',
		'onSave.*\\(.*\\)\\s*{+|onSave:\\s*\\(.*\\)\\s*=>',
		'init.*\\(.*\\)\\s*{+|init:\\s*\\(.*\\)\\s*=>',

		'return handler\\.wrap\\s*\\(.*\\);'
	]

wrongs_for_private = ['something']
obligate_for_private = ['this\\.code\\s*=']


wrongs_for_all = ['\\s+$'] # Без пробельных символов в концах строк

obligate_for_all = ['/\\*\\*|//']


for_pack = (file, publicity) ->
	await check file, publicity, wrongs_for_pack


for_pr = (file, publicity) ->
	await check file, publicity, wrongs_for_pr, u, warns_for_pr


check = (file, publicity, wrongspec = [], obligatespec = [], warn_spec = []) ->

	if publicity == 'public'
		wrongs =  wrongs_for_public
		obligates = arr obligate_for_public
	else
		wrongs = wrongs_for_private
		obligates = arr obligate_for_private

	wrongs = join_re_lists wrongs, wrongs_for_all, wrongspec
	obligates = obligates .concat obligatespec
	check_result = {}

	wrongs = await read_line_while file, wrongsearcher .bind null, wrongs

	if wrongs
		check_result .one_wrong = wrongs

	await read_line_while file, obligate_searcher .bind null, obligates

	obligates = obligates .filter (itm) -> itm

	if obligates .length
		check_result .miss = obligates

	warn_spec = join_re_lists warn_spec
	warns = await read_line_while file, wrongsearcher .bind null, warn_spec

	if warns
		check_result .warns = warns

	if wrongs or obligates .length or warns
		return check_result
	else
		return u


wrongsearcher = (regex, line) ->
	match = line .match regex

	if not match
		return cond: true

	match = first match

	return cond: false, val: match


obligate_searcher = (regex_set, line) ->
	for regex in regex_set
		match = line .match regex 

		if match
			idx = regex_set .indexOf regex
			delete regex_set[idx]

	return cond: true


join_re_lists = (...regex_lists) ->
	regexes = []

	for regex_list in regex_lists
		for regex in regex_list
			regexes .push regex

	join '|', regexes


# Проверяет, не затронуты ли файлы не имеющие отношения к делу

for_integrity = (allowed = [], target_for_pr_branch = 'master', source_branch_name) ->

	NULL = 0
	LAST = -1

	if not allowed .length
		throw message: 'check: for_integrity: allowed list is not presented'

	if not source_branch_name
		throw message: 'check: for_integrity: branch name is not presented'

	allowed = join '|', allowed
	allowed = new RegExp '(' + allowed + ').*\n', 'g'

	git_diff_response = String exec_sync 'git diff --name-only ' + target_for_pr_branch + ' ' + source_branch_name
	touched = git_diff_response .split '\n'

	if '' == touched .at LAST
		touched .pop u

	if '' == touched .at FIRST
		touched .shift u

	touched_num = touched .length
	matchs = git_diff_response .match allowed

	matchs_num = NULL

	if matchs
		matchs_num = empty matchs

	if touched_num == matchs_num
		return 'ok'
	
	return { touched, matchs }




export { for_integrity, for_pack, for_pr }
