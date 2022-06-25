// [Будет] всё для работы с версиями
var line_handler, script_full_path, script_version;

import fs from 'fs';

import readline from 'node:readline';

import {
  get_current
} from './settings.js';

import {
  cl,
  read_line_while,
  first
} from './auxiliary.js';

script_full_path = get_current().full_path;

line_handler = function(line) {
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

cl(script_version = (await read_line_while(script_full_path, line_handler)));
