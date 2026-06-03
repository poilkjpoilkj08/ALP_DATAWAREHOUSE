# 🏨 Hotel Booking Demand Data Warehouse

## Kelompok

| NIM           | Nama                           |
| ------------- | ------------------------------ |
| 0706022410010 | Lennard Lucius Huang           |
| 0706022410025 | Maxwell Ethan Muliadi          |
| 0706022410030 | Stephen Jonathan Onggowarsitto |
| 0706022410036 | Matthew Iyawan                 |

---

## 📖 Project Overview

Project ini merupakan implementasi Data Warehouse menggunakan pendekatan Modern ELT (Extract, Load, Transform) untuk mengolah data pemesanan hotel dari berbagai sumber operasional menjadi model analitik berbentuk Star Schema yang siap digunakan untuk kebutuhan Business Intelligence (BI) dan dashboard analitik.

Dataset yang digunakan adalah:

**Scenario 05 – Hotel Booking Demand** sesuai dengan ketentuan AFL-3 & ALP Mata Kuliah Data Warehousing.

Sumber data terdiri dari kombinasi data MySQL dan CSV yang merepresentasikan aktivitas pemesanan hotel, data referensi negara, hotel, tipe kamar, dan channel pemesanan.

---

## 🎯 Project Objectives

* Mengintegrasikan data dari berbagai sumber operasional.
* Membersihkan dan menstandarisasi data menggunakan proses ELT.
* Membangun Data Warehouse berbasis Star Schema.
* Menyediakan data yang siap digunakan untuk analisis bisnis.
* Menghasilkan dashboard interaktif yang mendukung pengambilan keputusan.

---

## 🗂️ Dataset Description

### Source 1 – MySQL

Database: `hotel_booking`

Tabel utama:

* Bookings

### Source 2 – CSV Files

* Hotels
* Countries
* Room Types
* Booking Channels

---

## 🏗️ Data Warehouse Architecture

```text
CSV Files + MySQL
        │
        ▼
Python ETL Pipeline
(Extract & Load)
        │
        ▼
Google BigQuery
        │
        ▼
dbt Staging Layer
(Data Cleaning)
        │
        ▼
dbt Core Layer
(Dimension & Fact Tables)
        │
        ▼
Star Schema
        │
        ▼
Looker Studio Dashboard
```

---

## 📊 Dimensional Model

### Fact Table

#### fact_bookings

Menyimpan seluruh transaksi pemesanan hotel.

Metrik utama:

* Total Booking
* Total Cancellation
* Average Daily Rate (ADR)
* Total Guest
* Total Stay Nights

### Dimension Tables

#### dim_hotels

Informasi hotel.

#### dim_countries

Informasi negara asal tamu.

#### dim_room_types

Informasi tipe kamar.

#### dim_booking_channels

Informasi channel distribusi dan market segment.

Dataset referensi tersebut berasal dari tabel Hotels, Countries, Room Types, dan Booking Channels.

---

## ⚙️ Technologies Used

* Python
* Pandas
* MySQL
* Google BigQuery
* dbt (Data Build Tool)
* Docker
* SQL
* Looker Studio

---

## 🚀 How to Run

### 1. Start Docker Environment

```bash
docker-compose up -d
```

### 2. Access dbt Container

```bash
docker exec -it afl3_de_container bash
```

```bash
cd dbt_hotel_model
```

### 3. Configure dbt Profile

```bash
mkdir -p /root/.dbt
cp ../profiles.yml /root/.dbt/profiles.yml
```

### 4. Run dbt Models

```bash
dbt run
```

### 5. Run Data Tests

```bash
dbt test
```

### 6. Generate Documentation

```bash
dbt docs generate
```

```bash
dbt docs serve --host 0.0.0.0 --port 8081
```

Open:

```text
http://localhost:8081
```

---

## 📈 Business Questions

Dashboard yang dibangun ditujukan untuk menjawab pertanyaan berikut:

1. Berapa total booking yang terjadi?
2. Berapa tingkat pembatalan booking?
3. Negara mana yang menghasilkan booking terbanyak?
4. Hotel mana yang memiliki performa terbaik?
5. Channel pemesanan mana yang paling efektif?
6. Bagaimana tren booking berdasarkan waktu?
7. Bagaimana distribusi tipe kamar yang paling banyak dipesan?

---

## 📁 Project Structure

```text
ALP_DATAWAREHOUSE/
│
├── .secrets/
├── data/
│   └── raw/
│
├── notebook/
│   └── ETL_pipeline.ipynb
│
├── dbt_hotel_model/
│   ├── models/
│   │   ├── staging/
│   │   └── core/
│   ├── macros/
│   ├── snapshots/
│   ├── analyses/
│   └── dbt_project.yml
│
└── README.md
```

---

## 👨‍💻 Contributors

* Lennard Lucius Huang
* Maxwell Ethan Muliadi
* Stephen Jonathan Onggowarsitto
* Matthew Iyawan

---

## 📚 Course Information

**Course:** Data Warehousing (ISB02303401)

**Project Type:** AFL-3 & ALP

**Scenario:** Hotel Booking Demand 05

**Academic Year:** 2025/2026 Even Semester

Universitas Ciputra Surabaya
