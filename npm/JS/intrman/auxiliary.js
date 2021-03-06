// Разные вспомогательные функции
var __this_module_name, get_branch, intrauto_path, intrman_path, joinormalize, read_line_on_condition, read_line_until, read_line_while, shared_dir, this_file_dirname, this_file_full_path;

import {
  dirname,
  normalize,
  join
} from 'path';

import {
  execSync as exec_sync
} from 'child_process';

import {
  createReadStream as create_read_stream
} from 'fs';

import {
  createInterface as create_interface
} from 'node:readline';

import {
  fileURLToPath as file_url_to_path
} from 'url';

import {
  cl,
  second
} from 'raffinade';

joinormalize = function(...components) {
  return normalize(join(...components));
};

__this_module_name = 'auxiliary';

this_file_full_path = file_url_to_path(import.meta.url);

intrman_path = this_file_dirname = dirname(this_file_full_path);

intrauto_path = dirname(intrman_path);

shared_dir = joinormalize(intrauto_path, '../../');

// async read_line_on_condition: condition, file_name, line_handler -> undefined or callback return value
// sync  line_handler: line -> cond: bool [, ret: any]
read_line_on_condition = async function(cond, file_name, line_handler) {
  var i, input, read_interface, ret, warn_header;
  warn_header = __this_module_name + ': read_line_on_condition: ';
  if (!file_name || !line_handler) {
    throw {
      message: warn_header + 'file_name or line_handler is not presented'
    };
  }
  if (typeof file_name !== 'string') {
    throw {
      message: warn_header + 'file_name is not a string'
    };
  }
  if (typeof file_name === '') {
    throw {
      message: warn_header + 'file_name is empty'
    };
  }
  if (typeof line_handler !== 'function') {
    throw {
      message: warn_header + 'line_handler is not a function'
    };
  }
  input = create_read_stream(joinormalize(file_name));
  read_interface = create_interface({
    input,
    console: false,
    crlfDelay: 2e308
  });
  for await (i of read_interface) {
    ret = line_handler(i);
    if (ret.cond === cond) {
      read_interface.close();
      return ret.val;
    }
  }
};

// Read file line by line while callback return true or until return true 
read_line_while = read_line_on_condition.bind(null, false);

read_line_until = read_line_on_condition.bind(null, true);

get_branch = function() {
  var branch_name, git_on_status_response, match;
  git_on_status_response = String(exec_sync('git status'));
  match = git_on_status_response.match(/On branch (.+)\n/);
  if (!match) {
    throw {
      message: __this_module_name + ': get_branch: Can\'t to recognize branch name'
    };
  }
  return branch_name = second(match);
};

export {
  joinormalize,
  shared_dir,
  intrman_path,
  intrauto_path,
  read_line_on_condition,
  read_line_while,
  read_line_until,
  get_branch
};
