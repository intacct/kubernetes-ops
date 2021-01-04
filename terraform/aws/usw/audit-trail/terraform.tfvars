environment_tag = "DevOps"
# ----------------------------------------------------------------------------------------------------------------------
# Glue table parameters
# ----------------------------------------------------------------------------------------------------------------------
create_table = true

# Table definitions
table_names = [
        "audittrail",
        "audittrailfields",
        "audittrail_parquet",
        "audittrailfields_parquet"
    ]
table_descriptions = [
        "audit trail header table for CSV data",
        "audit trail details table for CSV data",
        "audit trail header table for Parquet data",
        "audit trail details table for Parquet data"
    ]
table_input_formats = [
        "org.apache.hadoop.mapred.TextInputFormat",
        "org.apache.hadoop.mapred.TextInputFormat",
        "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat",
        "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    ]
table_output_formats = [
        "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat",
        "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat",
        "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat",
        "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"
    ]
table_serialization_libs = [
        "org.apache.hadoop.hive.serde2.OpenCSVSerde",
        "org.apache.hadoop.hive.serde2.OpenCSVSerde",
        "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe",
        "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
    ]
table_serde_parameters = [
        {"separatorChar" = ","},
        {"field.delim" = ","},
        {"serialization.format" = "1"},
        {"serialization.format" = "1"}
    ]
table_types = [
        "EXTERNAL_TABLE",
        "EXTERNAL_TABLE",
        "EXTERNAL_TABLE",
        "EXTERNAL_TABLE",
    ]
table_parameters = [
        {
            classification     = "csv",
            UPDATED_BY_CRAWLER = "ia-audittrail_csv_crawler"
        },
        {
            classification = "csv"
        },
        {
            classification     = "parquet",
            UPDATED_BY_CRAWLER = "ia-audittrail_parquet_crawler"
        },
        {
            classification = "parquet",
            UPDATED_BY_CRAWLER = "ia-audittrailfields_parquet_crawler"
        },
    ]
table_storage_parameters = [
        {
            UPDATED_BY_CRAWLER = "ia-audittrail_csv_crawler"
        },
        {
            classification = "csv",
            UPDATED_BY_CRAWLER = "ia-audittrail_csv_crawler"
        },
        {
            classification     = "parquet",
            UPDATED_BY_CRAWLER = "ia-audittrail_parquet_crawler"
        },
        {
            classification = "parquet",
            UPDATED_BY_CRAWLER = "ia-audittrailfields_parquet_crawler"
        },
    ]
table_columns = [
        [
            ["recordid", "string"],
            ["objecttype", "string"],
            ["objectkey", "string"],
            ["objectdesc", "string"],
            ["userid", "string"],
            ["accesstime", "bigint"],
            ["accessmode", "string"],
            ["ipaddress", "string"],
            ["source", "string"],
            ["workflowaction", "string"]
        ],
        [
            ["recordid", "string"],
            ["fieldname", "string"],
            ["fieldtype", "string"],
            ["oldval", "string"],
            ["newval", "string"],
            ["oldstrval", "string"],
            ["newstrval", "string"],
            ["oldintval", "bigint"],
            ["newintval", "bigint"],
            ["oldnumval", "bigint"],
            ["newnumval", "bigint"],
            ["olddateval", "bigint"],
            ["newdateval", "bigint"]
        ],
        [
            ["recordid", "string"],
            ["objecttype", "string"],
            ["objectkey", "string"],
            ["objectdesc", "string"],
            ["userid", "string"],
            ["accesstime", "timestamp"],
            ["accessmode", "string"],
            ["ipaddress", "string"],
            ["source", "string"],
            ["workflowaction", "string"]
        ],
        [
            ["recordid", "string"],
            ["fieldname", "string"],
            ["fieldtype", "string"],
            ["oldval", "string"],
            ["newval", "string"],
            ["oldstrval", "string"],
            ["newstrval", "string"],
            ["oldintval", "bigint"],
            ["newintval", "bigint"],
            ["oldnumval", "double"],
            ["newnumval", "double"],
            ["olddateval", "date"],
            ["newdateval", "date"]
        ]
    ]
table_partition_keys = [
        [
            ["cny", "int"],
            ["type", "string"],
            ["dt", "int"]
        ],
        [
            ["cny", "int"],
            ["type", "string"],
            ["dt", "int"]
        ],
        [
            ["cny", "int"],
            ["type", "string"],
            ["dt", "int"]
        ],
        [
            ["cny", "int"],
            ["type", "string"],
            ["dt", "int"]
        ]
    ]

obj_name     = ["audittrail/", "audittrailfields/", "audittrail-parquet/", "audittrailfields-parquet/"]

# view1 - audittrailview view table definitions
view1_name = "audittrailview" 
view1_description = "audit trail view" 
view1_type = "VIRTUAL_VIEW" 
view1_parameters = [
      {        
        presto_view = "true"
        comment     = "Presto View"    
      }
  ]
view1_columns = [
    ["cny", "int"],
    ["type", "string"],
    ["dt", "int"],
    ["recordid", "string"],
    ["objecttype", "string"],
    ["objectkey", "string"],
    ["objectdesc", "string"],
    ["userid", "string"],
    ["accesstime", "timestamp"],
    ["accessmode", "string"],
    ["ipaddress", "string"],
    ["source", "string"],
    ["workflowaction", "string"],
    ["fieldname", "string"],
    ["fieldtype", "string"],
    ["oldval", "string"],
    ["newval", "string"],
    ["oldstrval", "string"],
    ["newstrval", "string"],
    ["oldintval", "bigint"],
    ["newintval", "bigint"],
    ["oldnumval", "double"],
    ["newnumval", "double"],
    ["olddateval", "date"],
    ["newdateval", "date"]
  ]

# ----------------------------------------------------------------------------------------------------------------------
# Crawler
# ----------------------------------------------------------------------------------------------------------------------
crawler1_create                 = true
crawler1_name                   = "IA-AuditDataCrawler"
crawler1_schema_delete_behavior = "LOG"
# Run at 1:15a every day
# cron(Minutes Hours Day-of-month Month Day-of-week Year)
crawler1_schedule               = "cron(15 1 * * ? *)"
crawler1_configuration          = {}

crawler2_create                 = true
crawler2_name                   = "ia-audittrail_csv_crawler"
crawler2_schema_delete_behavior = "DEPRECATE_IN_DATABASE"
crawler2_schema_update_behavior = "UPDATE_IN_DATABASE"
# Run at 1:15a every day
# cron(Minutes Hours Day-of-month Month Day-of-week Year)
crawler2_schedule               = "cron(15 1 * * ? *)"
crawler2_configuration          = {
    CrawlerOutput = {
        Tables = {
            AddOrUpdateBehavior = "MergeNewColumns"
        }
    }
    Version       = 1
}

crawler3_create                 = true
crawler3_name                   = "ia-audittrail_parquet_crawler"
crawler3_schema_delete_behavior = "DEPRECATE_IN_DATABASE"
crawler3_schema_update_behavior = "LOG"
# Run at 1:15a every day
# cron(Minutes Hours Day-of-month Month Day-of-week Year)
crawler3_schedule               = "cron(15 1 * * ? *)"
crawler3_configuration          = {
    CrawlerOutput = {
      Partitions = {
        AddOrUpdateBehavior = "InheritFromTable"
      }
    }
    Grouping      = {
      TableGroupingPolicy = "CombineCompatibleSchemas"
    }
    Version       = 1
}

crawler4_create                 = true
crawler4_name                   = "ia-audittrailfields_parquet_crawler"
crawler4_schema_delete_behavior = "DEPRECATE_IN_DATABASE"
crawler4_schema_update_behavior = "LOG"
# Run at 1:15a every day
# cron(Minutes Hours Day-of-month Month Day-of-week Year)
crawler4_schedule               = "cron(15 1 * * ? *)"
crawler4_configuration          = {
    CrawlerOutput = {
      Partitions = {
        AddOrUpdateBehavior = "InheritFromTable"
      }
    }
    Grouping      = {
      TableGroupingPolicy = "CombineCompatibleSchemas"
    }
    Version       = 1
}


# ----------------------------------------------------------------------------------------------------------------------
# Lambda
# ----------------------------------------------------------------------------------------------------------------------
# lamdba_funct_name_1 = "IA-AuditTrail-Upload"
create_lambda = true
lambda_funct_name = [
    "uploadAuditTrail",
    "uploadAuditTrailFields"
]
lambda_funct_description = [
    "Transform audittrail csv table to Parquet",
    "Transform audittrailfields csv table to Parquet"
]
lambda_timeout = 20
lambda_memory_size = 128
lambda_handler = "lambda_function.lambda_handler"
# lambda_upload_role_name = "IA-AuditTrail-Lambda"
# lambda_upload_role_name = "uploadAuditTrail-role-4vhjyey0"
lambda_upload_role_name = "uploadAuditTrail-role"
lambda_role_path = "/service-role/"
# lambda_role_policy_name = "IA-AuditTrailLambda"
# lambda_role_policy_name = "AWSLambdaBasicExecutionRole-838b1669-00a0-4fbd-b8ae-1356ba5e02c8"
lambda_role_policy_name = "uploadAuditTrail-policy"
lambda_runtime = "python3.8"

# ----------------------------------------------------------------------------------------------------------------------
# Lambda Layer
# ----------------------------------------------------------------------------------------------------------------------
create_layer = true
layer_name = ["awsDataLayer"]
layer_description = ["An open-source Python package that extends the power of Pandas library to AWS"]
layer_runtime = ["python3.8"]
layer_license = ["https://github.com/awslabs/aws-data-wrangler/blob/master/LICENSE.txt"]

