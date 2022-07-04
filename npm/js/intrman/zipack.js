// Для паковки в zip
var fwalk, pack, zip;

import fs from 'fs';

import {
  readFileSync as read_file_sync,
  writeFileSync as write_file_sync,
  existsSync as exists_sync,
  mkdirSync as mkdir_sync
} from 'fs';

import {
  joinormalize
} from './auxiliary.js';

import 'node-zip';

zip = JSZip();

// if global and global .JSZip
//    delete global .JSZip
fwalk = async function*(widget_dir) {
  var chunk, dir_item, ref;
  ref = (await fs.promises.opendir(widget_dir));
  for await (dir_item of ref) {
    console.log(dir_item);
    chunk = joinormalize(widget_dir, dir_item.name);
    if (dir_item.isDirectory()) {
      yield* (await fwalk(chunk));
    } else {
      if (dir_item.isFile()) {
        yield chunk;
      }
    }
  }
  return void 0;
};

pack = async function(zipath, widget_dir, name) {
  var data, file_path, path_inside_zip, ref, restr_index, zip_full_path;
  zipath = joinormalize(zipath, name);
  if (!exists_sync(zipath)) {
    mkdir_sync(zipath, {
      recursive: true
    });
  }
  zip_full_path = joinormalize(zipath, './widget.zip');
  restr_index = widget_dir.length;
  ref = fwalk(widget_dir);
  for await (file_path of ref) {
    path_inside_zip = file_path.slice(restr_index);
    zip.file(path_inside_zip, read_file_sync(file_path));
  }
  data = zip.generate({
    base64: false,
    compression: 'DEFLATE'
  });
  write_file_sync(zip_full_path, data, 'binary');
  return true;
};

export {
  pack
};
