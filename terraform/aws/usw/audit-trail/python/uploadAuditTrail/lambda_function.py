import pandas as pd
import urllib.parse
import awswrangler as wr

def lambda_handler(event, context):
    for record in event['Records']:
        bucketName = record['s3']['bucket']['name']
        keyName = record['s3']['object']['key']

    parquetFolder = 'audittrail-parquet'
    noExtension = keyName.rpartition('.')[0]
    newLocation = noExtension.partition('/')[2]
    inputCSV = 's3://'+bucketName+'/'+keyName
    inputCSV = urllib.parse.unquote(inputCSV)
    outputParquet = 's3://'+bucketName+'/'+parquetFolder+'/'+newLocation+'.parquet'
    outputParquet = urllib.parse.unquote(outputParquet)


    parquetTypes = {'recordid': 'string', 'objecttype':'string', 'objectkey':'string', 'objectdesc':'string', \
     'userid':'string', 'accesstime':'datetime64[ms]', 'accessmode':'string', 'ipaddress':'string', \
     'source':'string', 'workflowaction':'string'}
    df = wr.s3.read_csv(inputCSV)
    df = df.astype(parquetTypes)
    wr.s3.to_parquet(df=df, path=outputParquet)
