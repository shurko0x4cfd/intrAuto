// Разные вспомогательные функции
var cl, intrauto_path, intrman_path, joinormalize, this_file_dirname, this_file_full_path;

import {
  dirname,
  normalize,
  join
} from 'path';

import {
  fileURLToPath
} from 'url';

cl = console.log;

joinormalize = function(...components) {
  return normalize(join(...components));
};

this_file_full_path = fileURLToPath(import.meta.url);

intrman_path = this_file_dirname = dirname(this_file_full_path);

intrauto_path = dirname(intrman_path);

export {
  cl,
  joinormalize,
  intrman_path,
  intrauto_path
};
