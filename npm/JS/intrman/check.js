// Проверяет файлы на отсутствие недопустимых выражений и наличие обязательных
var check, for_pack, join, join_re_lists, obligate_for_private, obligate_for_public, obligate_searcher, obligate_temp, wrongs_for_pack, wrongs_for_private, wrongs_for_public, wrongsearcher;

import {
  read_line_while
} from './auxiliary.js';

import {
  u,
  cl,
  first
} from 'raffinade';

wrongs_for_pack = ['yadro\\.introvert\\.bz'];

wrongs_for_public = ['yadroWidget', 'YadroWidget', 'yadroFunctions', 'this\\.code\\s*='];

obligate_for_public = ['this\\.version =', 'this\\.intr_code =', 'settings\\s*\\(.*\\)+\\s*{+|settings:\\s*\\(.*\\)+\\s*=>\\s*{+', 'bind_actions', 'onSave', 'init\\s*\\(.*\\)\\s*{+|init:\\s*\\(.*\\)\\s*=>\\s*{+'];

wrongs_for_private = ['something'];

obligate_for_private = ['this\\.code\\s*='];

obligate_temp = ['settings\\(\.\*\\)+'];

// obligate_for_all = \
//     [ ]
for_pack = async function(file, publicity) {
  return (await check(file, publicity, wrongs_for_pack));
};

check = async function(file, publicity, wrongspec) {
  var wrongs;
  if (publicity === 'public') {
    wrongs = wrongs_for_public;
  } else {
    wrongs = wrongs_for_private;
  }
  wrongs = join_re_lists(wrongs, wrongspec);
  //    if not wrongs
  //        return
  wrongs = (await read_line_while(file, wrongsearcher.bind(null, wrongs)));
  if (wrongs) {
    return wrongs;
  }
  return (await read_line_while(file, obligate_searcher.bind(null, obligate_for_public)));
};

wrongsearcher = function(regex, line) {
  var match;
  match = line.match(regex);
  if (!match) {
    return {
      cond: true
    };
  }
  match = first(match);
  return {
    cond: false,
    val: match
  };
};

obligate_searcher = function(regex_set, line) {
  var i, len, match, regex;
  for (i = 0, len = regex_set.length; i < len; i++) {
    regex = regex_set[i];
    match = line.match(regex);
    if (match) {
      cl(match);
    }
  }
  return {
    cond: true
  };
  if (!match) {
    return {
      cond: true
    };
  }
  match = first(match);
  return {
    cond: false,
    val: match
  };
};

join_re_lists = function(...regex_lists) {
  var i, j, len, len1, regex, regex_list, regexes;
  regexes = [];
  for (i = 0, len = regex_lists.length; i < len; i++) {
    regex_list = regex_lists[i];
    for (j = 0, len1 = regex_list.length; j < len1; j++) {
      regex = regex_list[j];
      regexes.push(regex);
    }
  }
  return join('|', regexes);
};

join = function(s, a) {
  return a.join(s);
};

export {
  for_pack
};
