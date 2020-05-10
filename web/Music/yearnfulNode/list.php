<?php

function listFolder($folder) {
  $dir = array_diff(scandir($folder), array(".",".."));
  
  $files = array();
  $folders = array();
  
  foreach($dir as $name) {
    $path = $folder . DIRECTORY_SEPARATOR . $name;
    if (is_dir($path)) {
      $folders[$name] = listFolder($path);
    } else {
      $files[] = $name;
    }
  }
  
  return array("files" => $files, "folders" => $folders);
}

echo json_encode(listFolder(getcwd()));
?>