#!/usr/bin/env node
;
var all_settings, allowed, branch_name, current, integrity, publicity, widget;

import {
  // Черновики, тесты, эксперименты
  get_branch
} from './intrman/auxiliary.js';

import {
  get_all
} from './intrman/settings.js';

import {
  for_integrity
} from './intrman/check.js';

import {
  u,
  cl
} from 'raffinade';

branch_name = get_branch(u);

all_settings = get_all(u);

current = all_settings.current;

widget = current.widget;

publicity = current.publicity;

allowed = all_settings.widgets[widget][publicity]['allowed-to-change'];

integrity = for_integrity(allowed, branch_name);

if (integrity === 'ok') {
  cl('Integrity ok');
}

if (integrity !== 'ok') {
  cl('Integrity check failed !');
  cl('Touched files and finded matchs:');
  cl(integrity);
  cl('Stopped');
}
