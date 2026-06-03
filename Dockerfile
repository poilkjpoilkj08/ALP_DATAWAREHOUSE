# Menggunakan base image Python yang ringan
FROM python:3.10-slim

# Menentukan direktori kerja di dalam container
WORKDIR /usr/app

# Menginstal library sistem yang dibutuhkan
RUN apt-get update && apt-get install -y git build-essential

# Menginstal Jupyter, pandas, konektor MySQL, BigQuery, dan dbt
RUN pip install --no-cache-dir \
    jupyterlab \
    pandas \
    sqlalchemy \
    pymysql \
    pandas-gbq \
    google-cloud-bigquery \
    dbt-bigquery

# Mengekspos port untuk Jupyter Lab
EXPOSE 8888

# Command default saat container berjalan
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]