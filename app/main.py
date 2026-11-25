import os
import psycopg2
from fastapi import FastAPI, HTTPException

app = FastAPI(title="Cloud Scalable Service")

DB_HOST = os.getenv("DB_HOST", "localhost")
DB_NAME = os.getenv("DB_NAME", "appdb")
DB_USER = os.getenv("DB_USER", "cloudadmin")
DB_PASSWORD = os.getenv("DB_PASSWORD", "postgres")
DB_PORT = os.getenv("DB_PORT", "5432")

@app.get("/health")
def health_check():
    return {"status": "healthy"}

@app.get("/db-check")
def db_check():
    try:
        connection = psycopg2.connect(
            host=DB_HOST,
            database=DB_NAME,
            user=DB_USER,
            password=DB_PASSWORD,
            port=DB_PORT,
            connect_timeout=3
        )
        cursor = connection.cursor()
        cursor.execute("SELECT version();")
        db_version = cursor.fetchone()
        cursor.close()
        connection.close()
        return {"database": "connected", "version": db_version[0]}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
