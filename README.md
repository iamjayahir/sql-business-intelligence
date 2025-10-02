SQL Business Intelligence Project
# Project Overview
This project demonstrates a complete SQL-based data analytics pipeline - from database creation and dimensional modeling to advanced business intelligence reporting. The project implements a star schema data warehouse and provides comprehensive business insights through SQL queries and automated reports.

# Project Structure
The project is organized into logical modules for easy navigation and understanding:

 **[SQL Business Intelligence](./sql-business-intelligence/)**
│
├── **[1.create_schema](./advance_analysis/create_schema.sql)**             ### Database setup and table creation
├── **[2.EDA_Analysis.sql](./advance_analysis/EDA_Analysis.sql)**           ### Exploratory Data Analysis
├── **[3.advance_analysis.sql](./advance_analysis/advance_analysis.sql)**   ### Advanced analytics and business insights
├── **[4.customer_report.sql](./advance_analysis/customer_report.sql)**     ### Comprehensive customer analytics
├── **[5.product_report.sql](./advance_analysis/product_report)**           ### Product performance analysis
└── **[README](./README.md)**                                               ### Project documentation

## File Details
**[1.create_schema](./advance_analysis/create_schema.sql)**
**Purpose:** Database initialization and star schema implementation

**Key Components:**

- Creates DataWarehouseAnalytics database

- Defines dimension tables (dim_customers, dim_products)

- Creates fact table (fact_sales) with proper relationships

- Implements primary keys and foreign key constraints

**[2.EDA_Analysis.sql](./advance_analysis/EDA_Analysis.sql)**

**Purpose:** Comprehensive exploratory data analysis

**Key Analyses:**

- Data profiling and quality assessment

- Timeframe analysis (date ranges, customer ages)

- Basic metric calculations (total sales, orders, customers)

- Distribution analysis by country, gender, and product categories

- Top N and Bottom N performance analysis

**[3.advance_analysis.sql](./advance_analysis/advance_analysis.sql)**

**Purpose:** Advanced business intelligence and trend analysis

**Key Features:**

- Time series analysis (yearly, monthly trends)

- Cumulative metrics (running totals, moving averages)

- Year-over-Year performance comparisons

- Part-to-Whole analysis (category contributions)

- Customer and product segmentation

- Window functions for advanced analytics

**[4.customer_report.sql](./advance_analysis/customer_report.sql)**

**Purpose:** Comprehensive customer analytics and segmentation

**Key Metrics:**

- Customer segmentation (VIP, Regular, New)

- Age group categorization

- RFM analysis (Recency, Frequency, Monetary)

- Customer Lifetime Value (CLV) calculations

- Average Order Value (AOV) and monthly spend

- Complete customer profile view

**[5.product_report.sql](./advance_analysis/product_report)**

**Purpose:** Product performance and inventory analysis

**Key Metrics:**

- Product segmentation (High Performer, Mid-Range, Low Performer)

- Revenue and quantity analysis

- Customer engagement metrics

- Average selling price and order revenue

- Product lifecycle analysis

- Complete product performance view

## Database Architecture
- The project implements a star schema data warehouse design:

**Dimension Tables**

**dim_customers:** Customer demographics and attributes

**dim_products:** Product hierarchy and cost information

**Fact Table**

**fact_sales:** Transactional sales data with foreign keys to dimensions

###Getting Started

Execution Order

For first-time setup, run the files in this sequence:

## Start with schema creation:

sql
 **[SOURCE 1.create_schema.sql;](./advance_analysis/create_schema.sql)**

## Perform exploratory analysis:

sql
 **[SOURCE 2.EDA_Analysis.sql;](./advance_analysis/EDA_Analysis.sql)**

## Run advanced analytics:

sql
 **[SOURCE 3.advance_analysis.sql;](./advance_analysis/advance_analysis.sql)**

## Generate business reports:

sql
 **[SOURCE 4.customer_report.sql;](./advance_analysis/customer_report.sql)**
 **[SOURCE 5.product_report.sql;](./advance_analysis/product_report)**

### Quick Access to Reports
sql
-- Customer Analytics
SELECT * FROM **[report_customer;](./advance_analysis/customer_report.sql)**

-- Product Performance
SELECT * FROM **[product_report;](./advance_analysis/product_report)**

## Technical Skills Demonstrated

**Database Design:** Star schema implementation with proper constraints

**SQL Proficiency:** Complex queries, CTEs, window functions, advanced joins

**Data Modeling:** Dimension and fact table design principles

**Business Intelligence:** KPI development and performance analysis

**Automated Reporting:** Reusable views for ongoing business monitoring

## Key Business Insights

**Customer Segmentation:** Identified VIP customers driving significant revenue

**Product Performance:** Categorized products by revenue contribution

**Trend Analysis:** Month-over-month and year-over-year growth patterns

**Geographic Distribution:** Sales performance across different countries

**Customer Lifetime Value:** Calculated average monthly spend per customer segment

## Usage Examples
- For Business Analysis
- Use customer report for targeted marketing campaigns
- Leverage product report for inventory optimization
- Analyze trends for strategic planning
- For Technical Learning
- Study star schema implementation
- Learn advanced SQL techniques
- Understand business intelligence reporting

## Requirements
- MySQL or compatible SQL database
- Basic understanding of SQL and database concepts

This project showcases end-to-end data analytics capabilities from raw data to actionable business intelligence using SQL and data warehousing principles.
