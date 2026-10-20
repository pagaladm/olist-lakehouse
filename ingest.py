#Python code to convert CSV files to Parquet and upload them to S3.
import glob, os
import boto3
import pandas as pd

BUCKET = "diksha-olist-lakehouse" 
s3 = boto3.client("s3")

os.makedirs("parquet", exist_ok=True)

def clean_name(path):
    n = os.path.basename(path)
    return n.replace("olist_", "").replace("_dataset.csv", "").replace(".csv", "")

for f in glob.glob("csv/*.csv"):
    name = clean_name(f)

    #1)raw CSV to S3
    s3.upload_file(f, BUCKET, f"raw/csv/{os.path.basename(f)}")

    # 2)CSV to Parquet locally
    df = pd.read_csv(f)
    out = f"parquet/{name}.parquet"
    df.to_parquet(out, index=False)

    # 3) Parquet to S3 (one folder per table, needed later by Glue/Athena)
    s3.upload_file(out, BUCKET, f"raw/parquet/{name}/{name}.parquet")
    print(f"{name}: {len(df):,} rows uploaded")
