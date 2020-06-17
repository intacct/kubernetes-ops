-- Values are all declared as string because Athena doesn't like empty values as int, etc.
--  Specific queries can convert data as needed to match specific types.
CREATE EXTERNAL TABLE IF NOT EXISTS audittrailfields (
  recordid STRING,
  fieldname STRING,
  fieldtype STRING,
  oldval STRING,
  newval STRING,
  oldstrval STRING,
  newstrval STRING,
  oldintval STRING,
  newintval STRING,
  oldnumval STRING,
  newnumval STRING,
  olddateval STRING,
  newdateval STRING
  ) Partitioned by (cny int, type string, dt int)
  ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
  WITH SERDEPROPERTIES ( 'serialization.format' = '1')
  LOCATION 's3://ia-audittrailbucket/AuditFieldsData/'
