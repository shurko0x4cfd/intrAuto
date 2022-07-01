// [Будет] всё для паковки в zip
var fwalk, pack, zip;

import fs from 'fs';

import {
  readFileSync as read_file_sync,
  writeFileSync as write_file_sync
} from 'fs';

import {
  joinormalize
} from './auxiliary.js';

import 'node-zip';

zip = JSZip();

fwalk = async function*(wpath) {
  var chunk, dir_item, ref;
  ref = (await fs.promises.opendir(wpath));
  for await (dir_item of ref) {
    chunk = joinormalize(wpath, dir_item.name);
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

pack = async function(zipath, wpath, name) {
  var data, file_path, path_in_zip, ref, restr_index;
  restr_index = wpath.length;
  ref = fwalk(wpath);
  for await (file_path of ref) {
    path_in_zip = file_path.slice(restr_index);
    zip.file(path_in_zip, read_file_sync(file_path));
  }
  data = zip.generate({
    base64: false,
    compression: 'DEFLATE'
  });
  return write_file_sync(zipath, data, 'binary');
};

export {
  pack
};
