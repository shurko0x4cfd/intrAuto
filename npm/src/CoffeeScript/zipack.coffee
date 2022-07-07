`#!/usr/bin/env node
`

# Проверяет файлы перед паковкой на допустимые и недопустимые выражения,
# плюсует версии у скипта и манифеста и пакует в каталог виджета



import { get_current } from './intrman/settings.js'
import { for_pack } from './intrman/check.js'
import { increase_both } from './intrman/version.js'
import { cl, u } from 'raffinade'
import { pack } from './intrman/zipack.js'

import \
    {
        read_line_while,
        joinormalize,
        shared_dir,
        intrman_path
    }\
from './intrman/auxiliary.js'


EXIT_OK = 0


current = get_current()


zipath_rel = './Zip/'
zipath = joinormalize shared_dir, zipath_rel

widget_dir = current .wpath
name = current .name

script_full_path = current .full_path
manifest_full_path = joinormalize widget_dir, 'manifest.json'
publicity = current .publicity

check_result = await for_pack script_full_path, publicity
one_wrong = miss = u

if check_result
    one_wrong = check_result .one_wrong
    miss = check_result .miss

if one_wrong
    cl "\nzipack: A file like script.js must not contain '" + one_wrong + "'"
    process .exit EXIT_OK

if miss and miss .length > 1
    s = 's'
else
    s = ''

if miss
    cl "\nzipack: A file like script.js must contain an expression" + s + " corresponding to the following pattern" + s + ": \n\t" + miss .join ' \n\t'
    process .exit EXIT_OK


increase_both script_full_path, manifest_full_path
pack zipath, widget_dir, name


# process .exit EXIT_OK # <- крашит скрипт
