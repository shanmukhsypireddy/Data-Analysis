----- Step 1: Explore the Data

#1. View of the data to ensure the import was successful
SELECT * FROM project_supply_chain_data.supply_chain_table;
#2. Checking for missing values in each column
SELECT 
    COUNT(*) - COUNT(Product_type) AS Missing_Product_type,
    COUNT(*) - COUNT(SKU) AS Missing_SKU,
    COUNT(*) - COUNT(Availability) AS Missing_Availability,
    COUNT(*) - COUNT(Number_of_products_sold) AS Missing_Number_of_products_sold,
    COUNT(*) - COUNT(Revenue_generated) AS Missing_Revenue_generated
FROM supply_chain_table;

----- Step 2: Performing Basic Analysis

#1. Calculating Total Revenue
SELECT SUM(CAST(REPLACE(Revenue_generated, ',', '') AS DECIMAL(10, 2))) AS Total_Revenue
FROM supply_chain_table;

#2 Finding Top Selling Products
SELECT Product_type, SUM(Number_of_products_sold) AS Total_Sales
FROM supply_chain_table
GROUP BY Product_type
ORDER BY Total_Sales DESC;

# 3. Analyzing Stock Levels
SELECT Product_type, AVG(Stock_levels) AS Average_Stock_Level
FROM supply_chain_table
GROUP BY Product_type;

----- Step 3: Complaint Diagnostic Analysis 

#1. To Classify Complaints Create a view to classify complaints based on inspection results and defect rates
SELECT *,
    CASE 
        WHEN CAST(REPLACE(Defect_rates, '%', '') AS DECIMAL(5, 2)) > 5 THEN 'Product Defect'
        WHEN Shipping_times > Lead_times THEN 'Late Delivery'
        WHEN Inspection_results = 'Failed' THEN 'Damaged Shipment'
        ELSE 'No Issues'
    END AS Complaint_Category
FROM supply_chain_table;

#2. Count Complaints by Category

SELECT Complaint_Category, COUNT(*) AS Number_of_Complaints
FROM (
    SELECT *,
        CASE 
            WHEN CAST(REPLACE(Defect_rates, '%', '') AS DECIMAL(5, 2)) > 5 THEN 'Product Defect'
            WHEN Shipping_times > Lead_times THEN 'Late Delivery'
            WHEN Inspection_results = 'Failed' THEN 'Damaged Shipment'
            ELSE 'No Issues'
        END AS Complaint_Category
    FROM supply_chain_table
) AS categorized_complaints
GROUP BY Complaint_Category;

----- Step 4: Supplier and Location Analysis
#1. Identify Top Suppliers by Defect Rate:
SELECT 
    Supplier_name, 
    AVG(CAST(REPLACE(Defect_rates, '%', '') AS DECIMAL(5, 2))) AS Average_Defect_Rate
FROM supply_chain_table
GROUP BY Supplier_name
ORDER BY Average_Defect_Rate DESC;

#2. Analyze Shipping Costs by Location
SELECT 
    Location, 
    AVG(CAST(REPLACE(Shipping_costs, ',', '') AS DECIMAL(10, 2))) AS Average_Shipping_Cost
FROM supply_chain_table
GROUP BY Location
ORDER BY Average_Shipping_Cost DESC;

----- Step 5: Customer Demographics Analysis
#1. Analyze Sales by Customer Demographics
SELECT 
    Customer_demographics, 
    SUM(Number_of_products_sold) AS Total_Sales
FROM supply_chain_table
GROUP BY Customer_demographics
ORDER BY Total_Sales DESC;

#2. Check Complaint Distribution by Customer Demographics
SELECT 
    Customer_demographics, 
    Complaint_Category, 
    COUNT(*) AS Number_of_Complaints
FROM (
    SELECT *,
        CASE 
            WHEN CAST(REPLACE(Defect_rates, '%', '') AS DECIMAL(5, 2)) > 5 THEN 'Product Defect'
            WHEN Shipping_times > Lead_times THEN 'Late Delivery'
            WHEN Inspection_results = 'Failed' THEN 'Damaged Shipment'
            ELSE 'No Issues'
        END AS Complaint_Category
    FROM supply_chain_table
) AS categorized_complaints
GROUP BY Customer_demographics, Complaint_Category
ORDER BY Customer_demographics, Number_of_Complaints DESC;

----- Step 6: Revenue and Profitability Analysis
# 1. Analyze Revenue by Product Type
SELECT 
    Product_type, 
    SUM(CAST(REPLACE(Revenue_generated, ',', '') AS DECIMAL(10, 2))) AS Total_Revenue
FROM supply_chain_table
GROUP BY Product_type
ORDER BY Total_Revenue DESC;
# 2. Calculate Profit Margin for Each Product
SELECT 
    Product_type, 
    SUM(CAST(REPLACE(Revenue_generated, ',', '') AS DECIMAL(10, 2))) AS Total_Revenue,
    SUM(CAST(REPLACE(Manufacturing_costs, ',', '') AS DECIMAL(10, 2))) AS Total_Costs,
    (SUM(CAST(REPLACE(Revenue_generated, ',', '') AS DECIMAL(10, 2))) - 
     SUM(CAST(REPLACE(Manufacturing_costs, ',', '') AS DECIMAL(10, 2)))) / 
     SUM(CAST(REPLACE(Revenue_generated, ',', '') AS DECIMAL(10, 2))) * 100 AS Profit_Margin
FROM supply_chain_table
GROUP BY Product_type
ORDER BY Profit_Margin DESC;

----- Step 7: Inventory and Stock Optimization
# 1. Identify Low Stock Products
SELECT 
    Product_type, 
    SKU, 
    Stock_levels
FROM supply_chain_table
WHERE Stock_levels < 50
ORDER BY Stock_levels ASC;

# 2. Find Products with Excess Inventory
SELECT 
    Product_type, 
    SKU, 
    Stock_levels
FROM supply_chain_table
WHERE Stock_levels > 500
ORDER BY Stock_levels DESC;





