CREATE DATABASE logsdb;

CREATE TABLE yarnlogs(log_time TIMESTAMP, log_level STRING, log_class STRING,
	     log_content STRING)
 COMMENT 'yarn log'
 PARTITIONED BY(host STRING, application_id STRING, container_id STRING)
 STORED AS ORC;
