
# Плюует версии у скипта и манифеста и пакует каталог виджета

# Позже будет проверять файлы перед паковкой на допустимые и недопустимые выражения,
# Скрипт не вполне готов - не проверяет перед паковкой на test/yadro и др
# Сохраняет архив в каталоге Zip, а будет как в Python-версии в Zip/название-виджета


import { get_current } from './intrman/settings.js'
import { for_pack } from './intrman/check.js'
import { increase_both } from './intrman/version.js'
import { cl, first } from 'raffinade'
import { pack } from './intrman/zipack.js'

import \
    {
        read_line_while,
        joinormalize,
        intrman_path
    }\
from './intrman/auxiliary.js'


EXIT_OK = 0


current = get_current()

zipath_rel = '../../../Zip/'
zipath = joinormalize intrman_path, zipath_rel

widget_dir = current .wpath
name = current .name

script_full_path = current .full_path
manifest_full_path = widget_dir + 'manifest.json'
publicity = current .publicity

wrong = await for_pack script_full_path, publicity

if wrong
    cl "\nzipack: File like script.js should not contain '" + wrong + "'"
    process .exit EXIT_OK


increase_both script_full_path, manifest_full_path


pack zipath, widget_dir, name
