
# Для паковки в zip

import fs from 'fs';

import \
    {
        readFileSync as read_file_sync,
        writeFileSync as write_file_sync,
        existsSync as exists_sync,
        mkdirSync as mkdir_sync
    }\
from 'fs';

import { joinormalize } from './auxiliary.js'
import jszip from 'jszip'


zip = jszip()

# if global and global .JSZip
#    delete global .JSZip


fwalk = (widget_dir) ->
    for await dir_item from await fs .promises .opendir widget_dir
        chunk = joinormalize widget_dir, dir_item .name

        if dir_item .isDirectory()
            yield from await fwalk chunk
        else
            if dir_item .isFile()
                yield chunk
    undefined


pack = (zipath, widget_dir, name) ->
    zipath = joinormalize zipath, name

    if not exists_sync zipath
        mkdir_sync zipath, recursive: true

    zip_full_path = joinormalize zipath, './widget.zip'
    restr_index = widget_dir .length

    for await file_path from fwalk widget_dir
        path_inside_zip = file_path .slice restr_index
        zip .file path_inside_zip, read_file_sync file_path

    data = await zip .generateAsync type: 'uint8array', base64: false, compression: 'DEFLATE'
    write_file_sync zip_full_path, data, 'binary'
    true


export { pack }
