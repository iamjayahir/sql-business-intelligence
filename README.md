# SQL & Business Intelligence Project

##  Project Overview
This project demonstrates a complete **SQL-based data analytics pipeline** - from database creation and dimensional modeling to advanced business intelligence reporting. The project analyzes sales data for a fictional company, providing actionable insights through comprehensive SQL queries and automated reports.

##  Database Architecture
The project implements a **star schema** data warehouse design:

### **Dimension Tables**
- `dim_customers`: Customer demographics and attributes
- `dim_products`: Product hierarchy and cost information

### **Fact Table**
- `fact_sales`: Transactional sales data with foreign keys to dimensions

##  Analysis Performed

### **1. Exploratory Data Analysis (EDA)**
- Data profiling and quality assessment
- Timeframe analysis (date ranges, customer ages)
- Key metric calculation (total sales, orders, customers)

### **2. Business Intelligence Reporting**
- **Customer Segmentation**: VIP/Regular/New classification with RFM analysis
- **Product Performance**: High/Mid/Low performer categorization
- **Sales Trends**: Year-over-year and month-over-month analysis
- **Geographic Analysis**: Sales distribution by country

### **3. Advanced Analytics**
- **Window Functions**: Running totals, moving averages, rankings
- **Customer Lifetime Value (CLV)**: Average monthly spend calculation
- **Product Contribution Analysis**: Part-to-whole percentage calculations
- **Time Intelligence**: Year-over-year growth comparisons

## 🛠️ Technical Skills Demonstrated
- **Database Design**: Star schema implementation with proper primary/foreign keys
- **SQL Proficiency**: Complex queries, CTEs, window functions, joins
- **Data Modeling**: Dimension and fact table design
- **Business Intelligence**: KPI development and performance analysis
- **Automated Reporting**: Created reusable views for customer and product reports

##  Key Features
- **2 Comprehensive Reports**: Customer and Product analysis views
- **Segmentation Logic**: Business rules for customer and product categorization
- **Performance Metrics**: AOV, CLV, recency, frequency, monetary values
- **Trend Analysis**: Time-based performance tracking

##  How to Use
1. Execute the SQL script in your MySQL environment
2. Run `SELECT * FROM report_customers;` for customer insights
3. Run `SELECT * FROM product_report;` for product performance
4. Explore individual queries for specific business questions

## Files
- `advance_analysis.sql`: Complete SQL script with all queries and views

---
*This project showcases the ability to transform raw data into actionable business intelligence using SQL*
