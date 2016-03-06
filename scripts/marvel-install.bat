cd "%INSTDIR%\elasticsearch"
bin\plugin install license
bin\plugin install marvel-agent

cd "%INSTDIR%\kibana"
bin\kibana plugin --install elasticsearch/marvel/latest