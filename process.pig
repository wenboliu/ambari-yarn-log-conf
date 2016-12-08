raw_yarn_logs = LOAD '/logs/flume/%year%/%month%/%day%/%time%' USING PigStorage() as (line:chararray);
REGISTER /usr/hdp/current/pig-client/filebeatlogparser.jar;
json_rows = FOREACH raw_yarn_logs {
   row = pri.wenbo.ParseJsonFields(line,'beat.hostname','source','message');
   log_time_million_seconds = pri.wenbo.GetLogTime(row.$2, 'yy/MM/dd HH:mm:ss');
   GENERATE row.$0 as host:chararray, pri.wenbo.GetApplicationId(row.$1) as application_id:chararray, pri.wenbo.GetContainerId(row.$1) as container_id:chararray, ToDate(log_time_million_seconds) as log_time:datetime, pri.wenbo.GetLogLevel(row.$2,'yy/MM/dd HH:mm:ss') as log_level:chararray,  pri.wenbo.GetLogClass(row.$2,'yy/MM/dd HH:mm:ss') as log_class:chararray,  pri.wenbo.GetLogContent(row.$2,'yy/MM/dd HH:mm:ss') as log_content:chararray;
}  
json_rows = FILTER json_rows BY log_level is not null; 
dump_json_rows = LIMIT json_rows 1; 
DUMP dump_json_rows;
STORE json_rows INTO '%targetTable%' USING org.apache.hive.hcatalog.pig.HCatStorer();
