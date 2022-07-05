#!/usr/bin/env node
;
var EXIT_OK, current, manifest_full_path, name, one_wrong, publicity, script_full_path, widget_dir, zipath, zipath_rel;

import {
  // Проверяет файлы перед паковкой на допустимые и недопустимые выражения,
  // плюсует версии у скипта и манифеста и пакует в каталог виджета
  get_current
} from './intrman/settings.js';

import {
  for_pack
} from './intrman/check.js';

import {
  increase_both
} from './intrman/version.js';

import {
  cl
} from 'raffinade';

import {
  pack
} from './intrman/zipack.js';

import {
  read_line_while,
  joinormalize,
  shared_dir,
  intrman_path
} from './intrman/auxiliary.js';

EXIT_OK = 0;

current = get_current();

zipath_rel = './Zip/';

zipath = joinormalize(shared_dir, zipath_rel);

widget_dir = current.wpath;

name = current.name;

script_full_path = current.full_path;

manifest_full_path = joinormalize(widget_dir, 'manifest.json');

publicity = current.publicity;

one_wrong = (await for_pack(script_full_path, publicity));

if (one_wrong) {
  cl("\nzipack: File like script.js should not contain '" + one_wrong + "'");
  process.exit(EXIT_OK);
}

increase_both(script_full_path, manifest_full_path);

pack(zipath, widget_dir, name);

// process .exit EXIT_OK
