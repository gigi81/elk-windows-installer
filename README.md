# elk-windows-installer
Elasticsearch Logstash Kibana Installer for Windows
============

Here you can find an installer for the ELK stack (Elasticsearch - Logstash - Kibana) for Windows.
There are a few tutorials on the internet that describe how to do this operation manually.
This installer is designed to install the required files and install the ELK services on the system hopefully saving you some time in the process.

Prerequisites
============

You need to install the Java SDK x64 (not the JRE). You can download it from here: http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html

Credits
============

The installer is based on the work of:
- https://www.ulyaoth.net/resources/tutorial-install-logstash-and-kibana-on-a-windows-server.34/
- http://www.sexilog.fr/

The installer uses the following tools:
- curl
- nssm
- nsis
- 7zip
