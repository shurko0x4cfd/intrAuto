
import os
import zipfile


def pack (intrauto_dir, path, name):
    oldir = os .getcwd ()
    os.chdir (path)

    try:
        zip_path = os .path .join (intrauto_dir, 'zip/', name)

        if not os .path .exists (zip_path):
            os .makedirs (zip_path)

        if not os .path .exists (zip_path):
            print ('Can\'t to create dir')
            os .sys .exit ()
    except:
            print ('Can\'t to create dir')
            os .sys .exit ()

    full_zip_path = os .path .join (zip_path, 'widget.zip')

    full_source_pathes = (os .path .join (current_path, file) for current_path, sub, files in os .walk ('.') for file in files)

    with zipfile .ZipFile (full_zip_path, 'w') as zip_file:
        for source_path in full_source_pathes: zip_file .write (source_path)


    os.chdir (oldir)
