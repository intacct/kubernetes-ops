CREATE EXTERNAL TABLE IF NOT EXISTS audittrail (
  recordid STRING,
  objecttype STRING,
  objectkey STRING,
  objectdesc STRING,
  userid STRING,
  accesstime TIMESTAMP,
  accessmode STRING,
  ipaddress STRING,
  source STRING,
  workflowaction STRING
  ) Partitioned by (cny int, type string, dt int)
  ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
  WITH SERDEPROPERTIES ( 'serialization.format' = '1')
  LOCATION 's3://krose-audittest/AuditData/'
