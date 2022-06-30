
# Только плюсует версии у скипта и манифеста, не пакует

import { get_current } from './intrman/settings.js'
import { increase_both } from './intrman/version.js'


settings = get_current()
script_full_path = settings .full_path
manifest_full_path = settings .wpath + 'manifest.json'


increase_both script_full_path, manifest_full_path
