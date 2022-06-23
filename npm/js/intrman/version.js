// [Будет] всё для работы с версиями
var input, readInterface, typer;

import fs from 'fs';

import readline from 'readline';

import {
  settings_full_path
} from './settings.js';

input = fs.createReadStream(settings_full_path);

readInterface = readline.createInterface({
  input,
  console: false
});

typer = function(line) {
  return console.log(line);
};

readInterface.on('line', typer);
