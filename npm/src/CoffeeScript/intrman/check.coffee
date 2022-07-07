
# Проверяет файлы на отсутствие недопустимых выражений и наличие обязательных

import { read_line_while } from './auxiliary.js'
import { u, cl, first, arr } from 'raffinade'


# TODO:
# Так же необходимо проверять файл манифеста - webhook_url в манифесте
# проверять версию handler.js - должна быть последней
# проверять, реализован ли хотя бы onBlocked_
# проверять, что в одной ветке нет одновременного изменения фронта и бэка
# в публичных виджетах (по умолчаню) обязтелен каталог widget или backend. (но не оба сразу?)


wrongs_for_pack = ['yadro\\.introvert\\.bz']

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

        'settings\\s*\\(.*\\)+\\s*{+|settings:\\s*\\(.*\\)+\\s*=>\\s*',
        'bind_actions\\s*\\(.*\\)+\\s*{+|bind_actions:\\s*\\(.*\\)+\\s*=>\\s*',
        'onSave\\s*\\(.*\\)+\\s*{+|onSave:\\s*\\(.*\\)+\\s*=>\\s*',
        'init\\s*\\(.*\\)\\s*{+|init:\\s*\\(.*\\)\\s*=>\\s*',

        'return handler\\.wrap\\s*\\(.*\\);'
    ]

wrongs_for_private = ['something']
obligate_for_private = ['this\\.code\\s*=']

obligate_temp = ['settings\\(\.\*\\)+']


# obligate_for_all = \
#     [ ]


for_pack = (file, publicity) ->
	await check file, publicity, wrongs_for_pack


check = (file, publicity, wrongspec = [], obligatespec = []) ->

    if publicity == 'public'
        wrongs =  wrongs_for_public
        obligates = arr obligate_for_public
    else
        wrongs = wrongs_for_private
        obligates = arr obligate_for_private

    wrongs = join_re_lists wrongs, wrongspec
    obligates = obligates .concat obligatespec
    check_result = {}

    wrongs = await read_line_while file, wrongsearcher .bind null, wrongs

    if wrongs
        check_result .one_wrong = wrongs

    await read_line_while file, obligate_searcher .bind null, obligates

    obligates = obligates .filter (itm) -> itm

    if obligates .length
        check_result .miss = obligates

    if wrongs or obligates .length
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


join = (s, a) -> a .join s


export { for_pack }
