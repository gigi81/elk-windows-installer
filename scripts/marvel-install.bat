rem this plugin requires license plugin installed

cd "%INSTDIR%\elasticsearch"
bin\plugin install -b marvel-agent

cd "%INSTDIR%\kibana"
bin\kibana plugin --install elasticsearch/marvel/latest