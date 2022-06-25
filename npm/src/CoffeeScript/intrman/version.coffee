
# [Будет] всё для работы с версиями

import fs from 'fs'
import readline from 'node:readline'
import { get_current } from './settings.js'
import { cl, read_line_while, first } from './auxiliary.js'


script_full_path = get_current() .full_path


line_handler = (line) ->
    matches = first Array .from line .matchAll /(.*)([\'"]+\d+\.\d+\.\d+[\'"]+)(.*)/g

    if !matches
        return cond: true

    return cond: false, val: matches[1..3]



cl script_version = await read_line_while script_full_path, line_handler


