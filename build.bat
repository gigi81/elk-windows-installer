SET CURL=tools\curl\bin\curl.exe
SET NSIS=tools\nsis\makensis.exe
SET NSSM=tools\nssm\win64\nssm.exe
SET ZIP=tools\7zip\7za.exe

SET VERSION=1.0.0
SET ELASTIC_SEARCH_VERSION=1.7.1
SET LOGSTASH_VERSION=1.5.3
SET KIBANA_VERSION=4.1.1

rem ---------- Download packages ----------
if not exist "downloads" mkdir downloads

rem %CURL% "https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-%ELASTIC_SEARCH_VERSION%.zip" -o downloads\elasticsearch.zip
rem %CURL% "https://download.elastic.co/logstash/logstash/logstash-%LOGSTASH_VERSION%.zip" -o downloads\logstash.zip
rem %CURL% "https://download.elastic.co/kibana/kibana/kibana-%KIBANA_VERSION%-windows.zip" -o downloads\kibana.zip
rem --------------------------------------

rem ---------- Unzip packages ----------
if not exist "temp" mkdir temp

rem %ZIP% x -otemp downloads\elasticsearch.zip
rem %ZIP% x -otemp downloads\logstash.zip
rem %ZIP% x -otemp downloads\kibana.zip

move temp\elasticsearch-%ELASTIC_SEARCH_VERSION% temp\elasticsearch
move temp\logstash-%LOGSTASH_VERSION% temp\logstash
move temp\kibana-%KIBANA_VERSION%-windows temp\kibana
rem ------------------------------------

rem ---------- Run makensis ----------
if not exist "dist" mkdir dist
%NSIS% /Dversion="%VERSION%" elk.nsis