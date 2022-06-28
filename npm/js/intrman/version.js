// [Будет] всё для работы с версиями
var check_for_version, h, manifest_full_path, manifest_version, map, map_all, parse_int, script_full_path, script_version, settings;

import fs from 'fs';

import readline from 'node:readline';

import {
  get_current
} from './settings.js';

import {
  read_line_while
} from './auxiliary.js';

import {
  cl,
  first,
  second,
  split
} from 'raffinade';

settings = get_current();

script_full_path = settings.full_path;

manifest_full_path = settings.wpath + 'manifest.json';

check_for_version = function(line) {
  var matches;
  matches = first(Array.from(line.matchAll(/(.*)([\'"]+\d+\.\d+\.\d+[\'"]+)(.*)/g)));
  if (!matches) {
    return {
      cond: true
    };
  }
  return {
    cond: false,
    val: matches.slice(1, 4)
  };
};

script_version = (await read_line_while(script_full_path, check_for_version));

manifest_version = (await read_line_while(manifest_full_path, check_for_version));

map = function(f, arr) {
  return arr.map(f);
};

map_all = function(f, ...args) {
  return map(f, args);
};

parse_int = function(ent) {
  return parseInt(ent);
};

h = function(version) {
  if (version) {
    return map(parse_int, split('.', first(version[1].match(/\d+\.\d+\.\d+/))));
  }
};

cl(map_all(h, script_version, manifest_version));
