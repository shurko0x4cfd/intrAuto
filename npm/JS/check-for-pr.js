#!/usr/bin/env node
;
var all_settings, allowed, check_result, current, integrity, miss, one_wrong, publicity, s, script_full_path, source_branch, target_for_pr_branch, warns, widget;

import {
  // Проверка перед ПР. Заготовка
  get_branch
} from './intrman/auxiliary.js';

import {
  get_all,
  get_current
} from './intrman/settings.js';

import {
  for_integrity,
  for_pr
} from './intrman/check.js';

import {
  EXIT_OK,
  u,
  cl
} from 'raffinade';

source_branch = get_branch(u);

all_settings = get_all(u);

current = get_current(u);

widget = current.widget;

publicity = current.publicity;

allowed = current.widget['allowed-to-change'];

script_full_path = current.full_path;

// TODO: Нужно извлекать целевую ветку из опций и возможность устанавливать
// целевую ветку по умолчанию для виджета в настройках виджетов в settings.json
target_for_pr_branch = u;

integrity = for_integrity(allowed, target_for_pr_branch, source_branch);

if (integrity === 'ok') {
  cl('Integrity ok');
}

if (integrity !== 'ok') {
  cl('Integrity check failed !');
  cl('Touched files and finded matchs:');
  cl(integrity);
  cl('Stopped');
}

check_result = (await for_pr(script_full_path, publicity));

one_wrong = miss = warns = u;

if (check_result) {
  one_wrong = check_result.one_wrong;
  miss = check_result.miss;
  warns = check_result.warns;
}

if (one_wrong) {
  cl("\ncheck_for_pr: A file like script.js must not contain '" + one_wrong + "'");
}

if (miss && miss.length > 1) {
  s = 's';
} else {
  s = '';
}

if (miss) {
  cl("\ncheck_for_pr: A file like script.js must contain an expression" + s + " corresponding to the following pattern" + s + ": \n\t" + miss.join(' \n\t'));
}

if (warns) {
  cl("\ncheck_for_pr: warning: May be problem place: '" + warns + "'");
}

if (one_wrong || miss) {
  process.exit(EXIT_OK);
}
