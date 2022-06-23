
/* Сырой JS для экспериментов для изучения node */

import fs from 'fs';
import readline from 'readline';
import { cwd } from 'process';

import { fileURLToPath } from 'url';
import { dirname } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);


console .log (__filename, __dirname);
