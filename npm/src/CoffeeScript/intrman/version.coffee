
# [Будет] всё для работы с версиями

import fs from 'fs'
import readline from 'node:readline'
import { get_current } from './settings.js'
import { read_line_while } from './auxiliary.js'
import { cl, first, second, split } from 'shugar'


settings = get_current()
script_full_path = settings .full_path
manifest_full_path = settings .wpath + 'manifest.json'


check_for_version = (line) ->
    matches = first Array .from line .matchAll /(.*)([\'"]+\d+\.\d+\.\d+[\'"]+)(.*)/g

    if !matches
        return cond: true

    return cond: false, val: matches[1..3]


script_version = await read_line_while script_full_path, check_for_version
manifest_version = await read_line_while manifest_full_path, check_for_version


map = (f, arr) -> arr .map f
map_all = (f, ...args) -> map f, args
parse_int = (ent) -> parseInt ent


h = (version) ->
    if version
        map parse_int, split '.', first version[1] .match /\d+\.\d+\.\d+/

cl map_all h, script_version, manifest_version

