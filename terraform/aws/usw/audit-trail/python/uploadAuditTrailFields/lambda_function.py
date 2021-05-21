import pandas as pd
import urllib.parse
import awswrangler as wr

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
 
    parquetTypes = {'recordid': 'string', 'fieldname':'string', 'fieldtype':'string', 'oldval':'string', \
     'newval':'string', 'oldstrval':'string', 'newstrval':'string', 'oldintval':'int', \
     'newintval':'int', 'oldnumval':'float', 'newnumval':'float', \
     'olddateval':'datetime64[ms]', 'newdateval':'datetime64[ms]'}
    df = wr.s3.read_csv(inputCSV)
    df['oldintval'] = df['oldintval'].fillna(0)
    df['newintval'] = df['newintval'].fillna(0)
    df['oldnumval'] = df['oldnumval'].fillna(0)
    df['newnumval'] = df['newnumval'].fillna(0)
    df['olddateval'] = df['olddateval'].fillna(0)
    df['newdateval'] = df['newdateval'].fillna(0)
    df = df.astype(parquetTypes)
    wr.s3.to_parquet(df=df, path=outputParquet)


