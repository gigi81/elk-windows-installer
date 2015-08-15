cd "%INSTDIR%\kibana\bin"
%NSSM% install kibana "%INSTDIR%\kibana\bin\kibana.bat"
%NSSM% set kibana DependOnService elasticsearch-service-x64
%NSSM% set kibana start SERVICE_DELAYED_AUTO_START