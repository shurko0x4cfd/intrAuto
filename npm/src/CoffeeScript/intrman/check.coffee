
# Проверяет файлы на отсутствие недопустимых выражений и наличие обязательных

import { read_line_while } from './auxiliary.js'
import { u, cl, first } from 'raffinade'


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
        'this\\.version =',
        'this\\.intr_code =',

        'settings\\s*\\(.*\\)+\\s*{+|settings:\\s*\\(.*\\)+\\s*=>\\s*{+',
        'bind_actions',
        'onSave',
        'init\\s*\\(.*\\)\\s*{+|init:\\s*\\(.*\\)\\s*=>\\s*{+'
    ]

wrongs_for_private = ['something']
obligate_for_private = ['this\\.code\\s*=']

obligate_temp = ['settings\\(\.\*\\)+']


# obligate_for_all = \
#     [ ]


for_pack = (file, publicity) ->
	await check file, publicity, wrongs_for_pack


check = (file, publicity, wrongspec) ->

    if publicity == 'public'
        wrongs =  wrongs_for_public
    else
        wrongs =  wrongs_for_private

    wrongs = join_re_lists wrongs, wrongspec

#    if not wrongs
#        return
    
    wrongs = await read_line_while file, wrongsearcher .bind null, wrongs

    if wrongs
        return wrongs

    await read_line_while file, obligate_searcher .bind null, obligate_for_public


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
            cl match
    return cond: true

    if not match
        return cond: true

    match = first match

    return cond: false, val: match


join_re_lists = (...regex_lists) ->
    regexes = []

    for regex_list in regex_lists
        for regex in regex_list
            regexes .push regex

    join '|', regexes


join = (s, a) -> a .join s


export { for_pack }
