#!/usr/bin/env node
;
var branch;

import {
  // Черновики, тесты, эксперименты
  get_branch
} from './intrman/auxiliary.js';

import {
  cl
} from 'raffinade';

cl(branch = get_branch(''));
