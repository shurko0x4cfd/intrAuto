// Любого рода работа с настройками intrAuto
var get_all, get_current, save_all, settings_file_rel_path, settings_full_path;

import fs from 'fs';

import path from 'path';

import {
  cl,
  joinormalize,
  intrman_path
} from './auxiliary.js';

settings_file_rel_path = '../../../settings/settings.json';

settings_full_path = joinormalize(intrman_path, settings_file_rel_path);

get_all = function() {
  return JSON.parse(fs.readFileSync(settings_full_path, 'utf-8'));
};

get_current = function() {
  var branch, current, defaults, dir, full_path, max_version, name, publicity, repository, script, settings, sub_dir, widget, wpath;
  settings = get_all();
  current = settings.current;
  defaults = settings.default;
  repository = current.repository;
  branch = current.branch;
  name = current.widget;
  publicity = current.publicity;
  widget = settings.widgets[name][publicity];
  dir = widget.dir;
  max_version = widget.max_version;
  script = defaults.scriptname;
  sub_dir = publicity === 'public' ? defaults.subdir : '';
  wpath = path.join(repository, dir, sub_dir);
  full_path = path.join(wpath, script);
  return {repository, branch, name, publicity, widget, dir, max_version, script, sub_dir, wpath, full_path};
};

save_all = function(data_json) {
  fs.readWriteSync(settings_file_fullpath, JSON.stringify(data_json));
  return true;
};

export {
  settings_full_path,
  get_all,
  get_current,
  save_all
};
