[![Build status](https://ci.appveyor.com/api/projects/status/5y1w99hoscil3xql?svg=true)](https://ci.appveyor.com/project/gigi81/elk-windows-installer)
[![Github All Releases](https://img.shields.io/github/downloads/gigi81/elk-windows-installer/total.svg?maxAge=2592000)]()

# elk-windows-installer
Elasticsearch Logstash Kibana Installer for Windows
============

Here you can find an installer for the ELK stack (Elasticsearch - Logstash - Kibana) for Windows.
There are a few tutorials on the internet that describe how to do this operation manually.
This installer is designed to install the required files and install the ELK services on the system hopefully saving you some time in the process.

Prerequisites
============

You need to install the Java SDK x64 (not the JRE). You can download it from here: http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html

Usage
============
You can download the installer from the [releases](https://github.com/gigi81/elk-windows-installer/releases) section.

The installer will create these windows services for you:
- elasticsearch-service-x64
- logstash
- kibana

You can customize the services configuration like network ports, logstash input filters and outputs, data folders, in the installation folder.

After installation, you can open kibana browsing to http://localhost:5601

Silent Install
============
It's possible to run the installer from the command line without ui:

elk-x64-installer.exe /S /D=C:\Elk Install Dir

Note: the installation dir must be the last parameter without quotes even when there are spaces in the path.

For more details [check the nsis documentation](http://nsis.sourceforge.net/Docs/Chapter4.html#silent)

Credits
============

Elasticsearch, Logstash and Kibana are developed by Elastichsearch (http://www.elasticsearch.com).

The installer is based on the work of:
- https://www.ulyaoth.net/resources/tutorial-install-logstash-and-kibana-on-a-windows-server.34/
- http://www.sexilog.fr/

The installer uses the following tools:
- curl
- nssm
- nsis
- 7zip
