#!/usr/bin/env node
/* Сырой JS для экспериментов для изучения node */

import { stat } from 'fs';
import readline from 'readline';
import { cwd } from 'process';

import { fileURLToPath } from 'url';
import { dirname } from 'path';
import { cl } from 'raffinade'

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);


cl (__filename, __dirname);
