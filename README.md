# Toronto Retail Analytics - SQL Portfolio Project
Overview

This project simulates a retail analytics environment using SQL Server.
I designed and executed a series of SQL queries to answer real-world business questions around customers, revenue, product performance, marketing campaigns, and customer segmentation.

The goal of this project is to:

Strengthen advanced SQL skills (CTEs, window functions, aggregations)

Practice translating business needs into data-driven insights

Build a portfolio-ready project for analytics & BI roles

📂 Project Structure

TorontoRetailSQLServer/
│
├── schema/                # Database schema
│   └── create_tables.sql  # Table creation scripts
│
├── data/                  
│   └── insert_sample_data.sql  # Insert mock/sample data
│
├── procedures/            
│   └── stored_procedures.sql   # Example stored procedures
│
├── analysis/              
│   └── queries.sql        # Analytical SQL queries
│
├── screenshots/           
│   └── *.png              # Query results & visual outputs
│
└── README.md              # Project documentation

🔍 Analyses Performed
1️⃣ Customer Insights

Total number of orders per customer

Total revenue per customer (only completed orders, sorted by highest spenders)

2️⃣ Revenue Analysis

Monthly revenue for the last 6 months

Year-over-Year (YoY) Growth using LAG() to compare revenue trends across online vs in-store channels

3️⃣ Product Performance

Top 5 products by revenue & units sold in the last 90 days

4️⃣ Marketing Impact

Campaign Lift Analysis: revenue and orders attributed to each online campaign to measure ROI

5️⃣ Customer Segmentation

Built an RFM model (Recency, Frequency, Monetary)

Scored customers from 1–5 for each metric and generated an RFM_Code

🛠️ Skills Demonstrated

SQL Server (CTEs, joins, subqueries, window functions, aggregations)

Business Analytics (customer segmentation, campaign ROI, revenue growth analysis)

Data-Driven Thinking (translating raw transactions into insights)

📎 Repository Link
https://github.com/hmpaththini-durage/toronto-retail-sqlserver.git

🚀 Next Steps

Planned future extensions:

Cohort analysis (customer retention over time)

Churn analysis setup (identifying at-risk customers)

Data visualization layer (Power BI / Tableau)