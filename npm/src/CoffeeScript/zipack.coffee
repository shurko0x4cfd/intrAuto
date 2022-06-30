
# Плюует версии у скипта и манифеста и пакует каталог виджета

# Позже будет проверять файлы перед паковкой на допустимые и недопустимые выражения,
# Скрипт не вполне готов - не проверяет перед паковкой на test/yadro и др
# Сохраняет архив в каталоге Zip, а будет как в Python-версии в Zip/название-виджета


import { get_current } from './intrman/settings.js'
import { increase_both } from './intrman/version.js'
import { cl } from 'raffinade'
import { pack } from './intrman/zipack.js'

import \
    {
        joinormalize,
        intrman_path
    }\
from './intrman/auxiliary.js'




zip = JSZip()
settings = get_current()

zipath_rel = '../../../Zip/widget.zip'
zipath = joinormalize intrman_path, zipath_rel

wpath = settings .wpath

# name пока не используется
name = settings .name

script_full_path = settings .full_path
manifest_full_path = wpath + 'manifest.json'

increase_both script_full_path, manifest_full_path


pack zipath, wpath, name
