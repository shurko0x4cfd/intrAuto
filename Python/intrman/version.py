
import os
import re


def extract_version (file, id):
    with open (file, 'r', encoding = 'utf-8') as f:
        for line, line_text in enumerate (f):
            version = re .search('[\'"]+\d+\.\d+\.\d+[\'"]+', line_text)
            if version:
                start = version .start() + 1
                end = version .end() - 1
                version = version .string [start : end] .split('.')
                version = {
                    'start': start,
                    'end': end,
                    'version': version,
                    'version_string': '.'.join(version),
                    'line_text': line_text,
                    'line': line,
                    'id': id }
                return version
                

def increase_one  (filename, old_version, new_version_str):
    with open (filename, 'r+', encoding = 'utf-8') as f:
        lines = f .readlines ()
        line = old_version ['line']
        line_text = lines [line]
        start = old_version ['start']
        updated_line = line_text [0 : start] + new_version_str + line_text [old_version ['end'] :]
        lines [line] = updated_line
        import io
        f .seek (0, io.SEEK_SET)
        f .writelines (lines)


def increase_both (path, script_name):
    oldir = os .getcwd ()
    os .chdir (path)

    script_version = extract_version (script_name, 'script')
    manifest_version = extract_version ('manifest.json', 'manisest')

    version = script_version

    for s, m in zip (script_version ['version'], manifest_version ['version']):
        if s > m:
            version = script_version
            break
        if s < m:
            version = manifest_version
            break

    version_splitted = version ['version']
    minor_plus = str (int (version_splitted [2]) + 1)
    version_splitted [2] = minor_plus
    new_version_str = '.' .join (version_splitted)

    increase_one (script_name, script_version, new_version_str)
    increase_one ('manifest.json', manifest_version, new_version_str)

    os .chdir (oldir)
