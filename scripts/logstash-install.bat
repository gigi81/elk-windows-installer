cd  "%INSTDIR%\logstash\bin"
%NSSM% install logstash "%INSTDIR%\logstash\bin\logstash.bat" "-f %INSTDIR%\logstash\conf"
%NSSM% set logstash DependOnService elasticsearch-service-x64
%NSSM% set logstash start SERVICE_DELAYED_AUTO_START