import streamlit as st
import pandas as pd
import plotly.express as px
from google.cloud import bigquery
import os

# --- 1. SETUP KONEKSI KE BIGQUERY ---
# Sesuaikan path ini dengan lokasi file JSON credential kamu yang ada di VS Code
os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = ".secrets/bigquery-service-account.json"

st.set_page_config(page_title="Hotel BI Dashboard", page_icon="🏨", layout="wide")

# --- 2. LOAD DATA DARI BIGQUERY (DENGAN CACHE) ---
@st.cache_data
def load_data():
    client = bigquery.Client()
    # Mengambil kolom-kolom penting dari Fact Table yang sudah kamu buat
    query = """
        SELECT 
            arrival_date_full,
            estimated_revenue,
            guest_segment,
            lead_time_category,
            is_canceled,
            country_code,
            average_daily_rate
        FROM `afl3-dw-hotel.afl3_hotel_dwh.fact_bookings`
        WHERE arrival_date_full IS NOT NULL
    """
    df = client.query(query).to_dataframe()
    df['arrival_date_full'] = pd.to_datetime(df['arrival_date_full'])
    return df

with st.spinner("Menarik data dari Data Warehouse..."):
    df_raw = load_data()

# --- 3. SIDEBAR: 2 INTERACTIVE FILTERS ---
st.sidebar.header("🎛️ Dashboard Filters")

# Filter 1: Date Range
min_date = df_raw['arrival_date_full'].min().date()
max_date = df_raw['arrival_date_full'].max().date()
date_selection = st.sidebar.date_input(
    "1. Pilih Rentang Waktu Kedatangan:",
    value=(min_date, max_date),
    min_value=min_date,
    max_value=max_date
)

# Filter 2: Guest Segment (Multiselect)
segment_options = df_raw['guest_segment'].dropna().unique()
segment_selection = st.sidebar.multiselect(
    "2. Pilih Segmen Tamu:",
    options=segment_options,
    default=segment_options
)

# Terapkan filter ke dataframe
if len(date_selection) == 2:
    start_date, end_date = date_selection
    mask = (df_raw['arrival_date_full'].dt.date >= start_date) & \
           (df_raw['arrival_date_full'].dt.date <= end_date) & \
           (df_raw['guest_segment'].isin(segment_selection))
    df_filtered = df_raw.loc[mask]
else:
    df_filtered = df_raw.copy()

st.title("🏨 Hotel Business Intelligence Dashboard")
st.markdown("---")

# --- 4. SCORECARDS: 4 KPI CHARTS ---
kpi1, kpi2, kpi3, kpi4 = st.columns(4)

total_revenue = df_filtered['estimated_revenue'].sum()
total_bookings = len(df_filtered)
cancel_rate = (df_filtered['is_canceled'].sum() / total_bookings) * 100 if total_bookings > 0 else 0
avg_adr = df_filtered['average_daily_rate'].mean()

with kpi1:
    st.metric(label="💰 Total Estimated Revenue", value=f"€ {total_revenue:,.2f}")
with kpi2:
    st.metric(label="📦 Total Bookings", value=f"{total_bookings:,}")
with kpi3:
    st.metric(label="🚫 Cancellation Rate", value=f"{cancel_rate:.1f} %")
with kpi4:
    st.metric(label="📊 Average Daily Rate (ADR)", value=f"€ {avg_adr:,.2f}")

st.markdown("---")

# --- 5. DATA VISUALIZATIONS: 4 DISTINCT CHARTS ---
col1, col2 = st.columns(2)

# Chart 1: Line Chart - Tren Pendapatan per Bulan
with col1:
    st.subheader("📈 Tren Pendapatan (Revenue Over Time)")
    df_trend = df_filtered.groupby(df_filtered['arrival_date_full'].dt.to_period("M"))['estimated_revenue'].sum().reset_index()
    df_trend['arrival_date_full'] = df_trend['arrival_date_full'].dt.to_timestamp()
    fig1 = px.line(df_trend, x='arrival_date_full', y='estimated_revenue', markers=True, template="plotly_white")
    st.plotly_chart(fig1, use_container_width=True)

# Chart 2: Pie Chart - Distribusi Segmen Tamu
with col2:
    st.subheader("🥧 Distribusi Segmen Tamu")
    df_segment = df_filtered['guest_segment'].value_counts().reset_index()
    df_segment.columns = ['guest_segment', 'count']
    fig2 = px.pie(df_segment, names='guest_segment', values='count', hole=0.4, template="plotly_white")
    st.plotly_chart(fig2, use_container_width=True)

col3, col4 = st.columns(2)

# Chart 3: Bar Chart - Top 10 Negara Asal Tamu
with col3:
    st.subheader("🌍 Top 10 Negara Asal Tamu")
    df_country = df_filtered['country_code'].value_counts().reset_index().head(10)
    df_country.columns = ['country_code', 'total_bookings']
    fig3 = px.bar(df_country, x='country_code', y='total_bookings', text='total_bookings', template="plotly_white")
    fig3.update_traces(textposition='outside')
    st.plotly_chart(fig3, use_container_width=True)

# Chart 4: Histogram/Stacked Bar - Tingkat Pembatalan Berdasarkan Waktu Booking
with col4:
    st.subheader("⏳ Status Pembatalan vs Kategori Lead Time")
    df_filtered['Status'] = df_filtered['is_canceled'].apply(lambda x: 'Canceled' if x == 1 else 'Not Canceled')
    fig4 = px.histogram(df_filtered, x='lead_time_category', color='Status', barmode='group', template="plotly_white")
    st.plotly_chart(fig4, use_container_width=True)