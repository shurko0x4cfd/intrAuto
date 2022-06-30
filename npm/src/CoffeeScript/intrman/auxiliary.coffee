
# Разные вспомогательные функции

import \
	{
		dirname,
		normalize,
		join
	}\
from 'path'

import { createReadStream as create_read_stream } from 'fs'
import { createInterface as create_interface } from 'node:readline'
import { fileURLToPath as file_url_to_path } from 'url'


joinormalize = (...components) -> normalize join ...components

__this_module_name = 'auxiliary'
this_file_full_path = file_url_to_path import .meta .url
intrman_path = this_file_dirname = dirname this_file_full_path
intrauto_path = dirname intrman_path


# async read_line_on_condition: condition, file_name, line_handler -> undefined or callback return value
# sync  line_handler: line -> cond: bool [, ret: any]
read_line_on_condition = (cond, file_name, line_handler) ->
	warn_header = __this_module_name + ': read_line_on_condition: '

	if not file_name or not line_handler
		throw  message: warn_header + 'file_name or line_handler is not presented'

	if typeof file_name != 'string'
		throw  message: warn_header + 'file_name is not a string'

	if typeof file_name == ''
		throw  message: warn_header + 'file_name is empty'

	if typeof line_handler != 'function'        
		throw  message: warn_header + 'line_handler is not a function'

	input = create_read_stream joinormalize file_name
	read_interface = create_interface { input, console: false, crlfDelay: Infinity }

	for await i from read_interface
		ret = line_handler i
		if ret .cond == cond
			read_interface .close()
			return ret .val


# Read file line by line while callback return true or until return true 
read_line_while = read_line_on_condition .bind null, false
read_line_until = read_line_on_condition .bind null, true


export \
	{
		joinormalize,
		intrman_path,
		intrauto_path,
		read_line_on_condition,
		read_line_while,
		read_line_until
	}
