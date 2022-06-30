
# [Будет] всё для работы с версиями

import { writeFileSync as write_file_sync } from 'fs'
import readline from 'node:readline'
import { read_line_while } from './auxiliary.js'
import { SECOND, FIRST, u, cl, first, last, second, split, map, mapk, twix, pack, max, arr } from 'raffinade'


__this_module_name = 'version'


check_for_version = () ->
	linum = 0

	return (line) ->
		matches = first arr line .matchAll /(.*[\'"]+)(\d+\.\d+\.\d+)([\'"]+.*)/g

		if !matches
			linum++
			return cond: true

		val = line: matches[1..3], linum: linum

		return cond: false, val: val


parse_int = (ent) -> parseInt ent


split_version = (version) ->
	if version
		map parse_int, split '.', second version .line
	else
		throw message: __this_module_name + ': parse_version: Version is not presented. Stop'


increase_one = (full_path, version, new_version) ->
	version .line[SECOND] = new_version
	updated_line = version .line .join ''
	lines = []
	app_line = (line) -> lines .push line
	await read_line_while full_path, app_line
	lines[version .linum] = updated_line
	write_file_sync full_path, lines .join '\n'


increase_both = (script_full_path, manifest_full_path) ->
	script_version = await read_line_while script_full_path, check_for_version()
	manifest_version = await read_line_while manifest_full_path, check_for_version()

	versions = pack ...mapk split_version, script_version, manifest_version

	max_version = versions .at FIRST

	for i in versions
		if max i .at FIRST > i .at SECOND
			break
		if max i .at FIRST < i .at SECOND
			max_version = versions .at SECOND
			break

	max_version[2]++
	new_version = max_version .join '.'
	increase_one script_full_path, script_version, new_version
	increase_one manifest_full_path, manifest_version, new_version




export { increase_both }
