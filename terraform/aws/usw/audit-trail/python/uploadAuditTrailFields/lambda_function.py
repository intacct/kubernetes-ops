import pandas as pd
import urllib.parse

def lambda_handler(event, context):
    for record in event['Records']:
        bucketName = record['s3']['bucket']['name']
        keyName = record['s3']['object']['key']

    parquetFolder = 'audittrailfields-parquet'
    noExtension = keyName.rpartition('.')[0]
    newLocation = noExtension.partition('/')[2]
    inputCSV = 's3://'+bucketName+'/'+keyName
    inputCSV = urllib.parse.unquote(inputCSV)
    outputParquet = 's3://'+bucketName+'/'+parquetFolder+'/'+newLocation+'.parquet'
    outputParquet = urllib.parse.unquote(outputParquet)
    
    print('## inputCSV\r')
    print(inputCSV)
    df = pd.read_csv(inputCSV)
    print('## outputParquet\r')
    print(outputParquet)
    df.to_parquet(outputParquet)


