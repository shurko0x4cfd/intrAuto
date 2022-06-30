
# [Будет] всё для паковки в zip

import fs from 'fs';

import \
    {
        readFileSync as read_file_sync,
        writeFileSync as write_file_sync
    }\
from 'fs';

import { joinormalize } from './auxiliary.js'
import 'node-zip';


zip = JSZip()


fwalk = (wpath) ->
	for await dir_item from await fs .promises .opendir wpath
		chunk = joinormalize wpath, dir_item .name

		if dir_item .isDirectory()
			yield from await fwalk chunk
		else
			if dir_item .isFile()
				yield chunk
	undefined


pack = (zipath, wpath, name) ->
    restr_index = wpath .length

    for await file_path from fwalk wpath
        path_in_zip = file_path .slice restr_index
        zip .file path_in_zip, read_file_sync file_path

    data = zip .generate base64: false, compression: 'DEFLATE'
    write_file_sync zipath, data, 'binary'


export { pack }
