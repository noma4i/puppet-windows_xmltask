define windows_xmltask($taskname = $title, $xmlfile, $overwrite = false, $ensure = 'present') {
  if ! ($ensure in [ 'present', 'absent' ]) {
    fail('valid values for ensure are \'present\' or \'absent\'')
  }
  $null  = '$null'
  $false = '$false'
  if ($ensure == 'present') {
    if ($overwrite == true){
      $is_force = '-Force'
    }
    file {"C:\\Windows\\Temp\\${taskname}.xml":
      ensure             => file,
      source_permissions => 'ignore',
      source             => $xmlfile,
    } ->
    exec { "Importing task ${taskname}":
      command  => "
        Try{
          Register-ScheduledTask -Xml (get-content 'C:\Windows\Temp\${taskname}.xml' | out-string) -TaskName '${taskname}' ${is_force}
        }
        Catch{
          exit 0
        }
      ",
      provider => powershell,
      onlyif   => "if( ((Get-ScheduledTask '${taskname}') -eq ${null}) -Or ('${overwrite}' -eq 'true')){ exit 0 }else{ exit 1 }",
      require  => File["C:\\Windows\\Temp\\${taskname}.xml"],
    }
  }else{
    exec { "Removing task ${taskname}":
      command  => "
        Try{
          Unregister-ScheduledTask -TaskName '${taskname}' -Confirm:${false}
        }
        Catch{
          exit 0
        }
      ",
      provider => powershell,
      onlyif   => "Get-ScheduledTask '${taskname}'",
    }
  }
}
