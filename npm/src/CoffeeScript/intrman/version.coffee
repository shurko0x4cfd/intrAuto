
# [Будет] всё для работы с версиями

import fs from 'fs'
import readline from 'readline'
import { get_current } from './settings.js'



get_version_str = (full_path) ->
    full_path = get_current() .full_path
    
    input = fs .createReadStream full_path
    readInterface = readline .createInterface { input, console: false }
    readInterface .on 'line', line_handler


line_handler = (line) ->
    console .log line

