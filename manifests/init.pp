define windows_xmltask($taskname = $title, $xmlfile, $overwrite = 'false', $ensure = 'present') {
  if ! ($ensure in [ 'present', 'absent' ]) {
    fail('valid values for ensure are \'present\' or \'absent\'')
  }
  $null = '$null'
  $temp_filename = fqdn_rand(3000, "$taskname")
  if ($ensure == 'present') {
    if ($overwrite == 'true'){
      $is_force = '-Force'
    }
    file {"c:\\Users\\Public\\$temp_filename.xml":
      ensure  => file,
      source_permissions => 'ignore',
      source  => $xmlfile
    } ->
    exec { "Importing task $taskname":
      command => "
        Try{
          if((Get-ScheduledTask '$taskname') -eq $null){
            Register-ScheduledTask -Xml (get-content 'C:\Users\Public\\$temp_filename.xml' | out-string) -TaskName '$taskname' $is_force
          }
          Remove-Item 'c:\Users\Public\\$temp_filename.xml'
        }
        Catch{
          exit 0
        }
      ",
      provider  => powershell,
    }
  }
}