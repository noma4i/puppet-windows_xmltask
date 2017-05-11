Facter.add('xmltask_temp_dir') do
  setcode do
    if Puppet::Util::Platform.windows?
      require 'win32/registry'

      value = nil
      begin
        # looking at current user may likely fail because it's likely going to be LocalSystem
        hive = Win32::Registry::HKEY_CURRENT_USER
        hive.open('Environment', Win32::Registry::KEY_READ | 0x100) do |reg|
          value = reg['TEMP']
        end
      rescue Win32::Registry::Error => e
        value = nil
      end

      if value.nil?
        begin
          hive = Win32::Registry::HKEY_LOCAL_MACHINE
          hive.open('SYSTEM\CurrentControlSet\Control\Session Manager\Environment', Win32::Registry::KEY_READ | 0x100) do |reg|
            value = reg['TEMP']
          end
        rescue Win32::Registry::Error => e
          value = nil
        end
      end

      value
    end
  end
end
