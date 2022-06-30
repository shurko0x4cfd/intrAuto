
# Любого рода работа с настройками intrAuto

import fs from 'fs'
import path from 'path'
import { cl } from 'raffinade'

import \
    {
        joinormalize,
        intrman_path
    }\
from './auxiliary.js'


settings_file_rel_path = '../../../settings/settings.json'
settings_full_path = joinormalize intrman_path, settings_file_rel_path


get_all = ->
    JSON .parse fs .readFileSync settings_full_path, 'utf-8'


get_current = ->
    settings = get_all()
    current = settings .current
    defaults = settings .default
    repository = current .repository
    branch = current .branch
    name = current .widget
    publicity = current .publicity
    widget = settings .widgets[name][publicity]
    dir = widget .dir
    max_version = widget .max_version
    script = defaults .scriptname
    sub_dir = if publicity == 'public' then defaults .subdir else ''
    wpath = path .join repository, dir, sub_dir
    full_path = path .join wpath, script 

    {
        repository,
        branch,
        name,
        publicity,
        widget,
        dir,
        max_version,
        script,
        sub_dir,
        wpath,
        full_path
    }


save_all = (data_json) ->
    fs .readWriteSync settings_file_fullpath, JSON .stringify data_json
    true


export \
    {
        settings_full_path,
        get_all,
        get_current,
        save_all
    }
