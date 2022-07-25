`#!/usr/bin/env node
`

# Проверка перед ПР. Заготовка

import { get_branch } from './intrman/auxiliary.js'
import { get_current } from './intrman/settings.js'
import { for_integrity, for_pr } from './intrman/check.js'
import { EXIT_OK, u, cl } from 'raffinade'


current = get_current u
widget = current .widget
publicity = current .publicity
allowed = widget['allowed-to-change']
script_full_path = current .full_path
source_branch = get_branch u
destination_branch = widget['target-for-pr-branch']


# TODO: Нужно извлекать целевую ветку из опций
# как вариант: cfpr --source some-name --dest other-name

if destination_branch
    integrity = for_integrity allowed, destination_branch, source_branch
else
    cl '\nTarget branch is not specified. Integrity check skipped !'

if integrity == 'ok'
    cl '\nIntegrity ok'

if integrity instanceof Array
    cl '\nIntegrity check failed !'
    cl 'Touched files and finded matchs:'
    cl integrity

check_result = await for_pr script_full_path, publicity

one_wrong = miss = warns = u

if check_result
    one_wrong = check_result .one_wrong
    miss = check_result .miss
    warns = check_result .warns

if one_wrong
    cl "\ncheck_for_pr: A file like script.js must not contain '" + one_wrong + "'"

if miss and miss .length > 1
    s = 's'
else
    s = ''

if miss
    cl "\ncheck_for_pr: A file like script.js must contain an expression" + s + " corresponding to the following pattern" + s + ": \n\t" + miss .join ' \n\t'

if warns
    cl "\ncheck_for_pr: warning: May be problem place: '" + warns + "'"

if one_wrong or miss
        process .exit EXIT_OK
