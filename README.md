# Puppet Windows XML Task


##Overview

Creating windows schedule task from previously exported.

##Module Description

Windows schedule tasks are tricky. Sometimes you need to setup very special attributes like *parallel process run*. I have ended with simple solution: create task via GUI and export as xml file and import it later.

##Usage


	windows_xmltask {'My Task Name':
    	ensure => present,
    	overwrite => 'false',
    	xmlfile => 'puppet:///config/soft/my_exported_task.xml',
  	}


##License

[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0.html)


