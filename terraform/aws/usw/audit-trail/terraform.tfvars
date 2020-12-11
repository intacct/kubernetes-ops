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
        {"serialization.format" = 1},
        {"serialization.format" = 1},
        {"serialization.format" = 1},
        {"serialization.format" = 1},
    ]
table_types = [
        "EXTERNAL_TABLE",
        "EXTERNAL_TABLE",
        "EXTERNAL_TABLE",
        "EXTERNAL_TABLE",
    ]
table_parameters = [
        [{EXTERNAL = "TRUE"}],
        [{EXTERNAL = "TRUE"}],
        [{EXTERNAL = "TRUE"}],
        [{EXTERNAL = "TRUE"}],
    ]
table_columns = [
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
            ["oldintval", "string"],
            ["newintval", "string"],
            ["oldnumval", "string"],
            ["newnumval", "string"],
            ["olddateval", "string"],
            ["newdateval", "string"]
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
            ["oldintval", "string"],
            ["newintval", "string"],
            ["oldnumval", "string"],
            ["newnumval", "string"],
            ["olddateval", "string"],
            ["newdateval", "string"]
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


# Table1 - audittrail table definitions
# table1_name = "audittrail"
# table1_description = "audit trail table" 
# table1_input_format = "org.apache.hadoop.mapred.TextInputFormat"
# table1_output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
# table1_serialization_lib = "org.apache.hadoop.hive.serde2.OpenCSVSerde"
# table1_serde_parameters = {
#     "serialization.format" = 1
# }
# table1_type = "EXTERNAL_TABLE"
# table1_parameters = [
#         {
#             EXTERNAL = "TRUE"
#         }
#     ]
# table1_columns = [
#       ["recordid", "string"],
#       ["objecttype", "string"],
#       ["objectkey", "string"],
#       ["objectdesc", "string"],
#       ["userid", "string"],
#       ["accesstime", "timestamp"],
#       ["accessmode", "string"],
#       ["ipaddress", "string"],
#       ["source", "string"],
#       ["workflowaction", "string"]
#     ]
# table1_partition_keys = [
#       ["cny", "int"],
#       ["type", "string"],
#       ["dt", "int"]
#     ]

# # Table2 - audittrailfields table definitions
# table2_name = "audittrailfields" 
# table2_description = "audit trail fields table" 
# table2_input_format = "org.apache.hadoop.mapred.TextInputFormat"
# table2_output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
# table2_serialization_lib = "org.apache.hadoop.hive.serde2.OpenCSVSerde"
# table2_serde_parameters = {
#     "serialization.format" = 1
# }
# table2_partition_keys = [
#       ["cny", "int"],
#       ["type", "string"],
#       ["dt", "int"]
#     ]
# table2_type = "EXTERNAL_TABLE" 
# table2_parameters = [
#         {
#             EXTERNAL = "TRUE"
#         }
#     ]
# table2_columns = [
#       ["recordid", "string"],
#       ["fieldname", "string"],
#       ["fieldtype", "string"],
#       ["oldval", "string"],
#       ["newval", "string"],
#       ["oldstrval", "string"],
#       ["newstrval", "string"],
#       ["oldintval", "string"],
#       ["newintval", "string"],
#       ["oldnumval", "string"],
#       ["newnumval", "string"],
#       ["olddateval", "string"],
#       ["newdateval", "string"]
#     ]

# Table3 - audittrailview view table definitions
table3_name = "audittrailview" 
table3_description = "audit trail view" 
table3_type = "VIRTUAL_VIEW" 
table3_parameters = [
      {        
        presto_view = "true"
        comment     = "Presto View"    
      }
  ]
table3_columns = [
    ["cny", "int"],
    ["type", "string"],
    ["dt", "int"],
    ["recordid", "string"],
    ["objecttype", "string"],
    ["objectkey", "string"],
    ["objectdesc", "string"],
    ["userid", "string"],
    ["accesstime", "bigint"],
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
    ["oldintval", "string"],
    ["newintval", "string"],
    ["oldnumval", "string"],
    ["newnumval", "string"],
    ["olddateval", "string"],
    ["newdateval", "string"]
  ]


# table4_input_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
# table4_output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"
# table4_serialization_lib = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
# table4_serde_parameters = {
#     "serialization.format" = 1
# }
# table5_input_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
# table5_output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"
# table5_serialization_lib = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
# table5_serde_parameters = {
#     "serialization.format" = 1
# }

# ----------------------------------------------------------------------------------------------------------------------
# Lambda
# ----------------------------------------------------------------------------------------------------------------------
# lamdba_funct_name_1 = "IA-AuditTrail-Upload"
lambda_funct_name_2 = "IA-AuditTrailFields-Upload"
lambda_upload_role_name = "IA-AuditTrail-Lambda"
lambda_role_path = "/service-role/"
lambda_role_policy_name = "IA-AuditTrailLambda"
