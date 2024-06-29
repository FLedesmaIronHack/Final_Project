
-- Needed Converting Indian currency to dollars with a formula of 1 to 0.012 dollars
-- Dropping the table Amazon_product_cleaned if it exists (commented out)
-- drop table Amazon_product_cleaned

-- Select and transform data from the Amazon products table
Select 
    [product_id],
    [product_name],
    [category],
    -- Categorizing products into a new category_v2 based on keywords in the original category
    case 
        when category like ('%computer%') then 'Computer'
        when category like ('%electronic%') then 'Electronic'
        when category like ('%car%') then 'Car'
        when category like ('%Home%') then 'Home'
        when category like ('%office%') then 'Office'
        when category like ('%toy%') then 'Toys'
        when category like ('%Music%') then 'Music'
    end as category_v2,
    [discounted_price] as [discounted_price_Indian],
    [actual_price] as [indian_Price],
    -- Converting prices from Indian Rupees to US Dollars
    discounted_price * 0.012 as [discounted_price_USD],
    [actual_price] * 0.012 as [USD_Price],
    [discount_percentage],
    -- Converting rating to a decimal value
    Convert(decimal(10, 2), replace([rating], ',', '')) as rating,
    -- Converting rating count to an integer value
    Convert(int, replace(rating_count, ',', '')) as rating_count
-- Uncomment to insert the result into a new table Amazon_product_cleaned
--into Amazon_product_cleaned
from [dbo].[amazon_products] 
where rating is not null
and rating_count is not null 
and Convert(int, replace(rating_count, ',', '')) >= 1000
order by Convert(int, replace(rating_count, ',', '')) desc, rating desc;

-- Selecting music products from the cleaned Amazon products table and ordering by USD price
Select * 
from Amazon_product_cleaned 
where category_v2 = 'Music'
order by USD_Price;
-- Select specific products from the Amazon products table by product_id
Select * 
from [dbo].[amazon_products]
where product_id in ('B07JF9B592', 'B076B8G5D8');-- This are the music products that were messing the results

-- Dropping the table sum_data if it exists (commented out)
-- drop table sum_data

-- Aggregating data for each category in the cleaned Amazon products table
Select 
    category_v2,
    AVG(rating) as Rating,
    Count(category_v2) as Product_Count,
    avg(USD_Price) as AVG_USD_Price,
    sum(rating_count) as Sum_Rating_Count,
    Avg(rating_count) as AVG_Rating_count,
    Min(USD_Price) as min_Price,
    Max(USD_Price) as max_Price
-- Uncomment to insert the result into a new table sum_data
-- into sum_data
from [dbo].[Amazon_product_cleaned]  
group by category_v2;

-- Selecting data from the sum_data table and ordering by average rating count in descending order
Select *  
from sum_data 
order by AVG_Rating_count desc;

-- Selecting distinct categories from the cleaned Amazon products table (commented out)
-- Select Distinct category_v2 from Amazon_product_cleaned;

-- Counting the number of products per category in the cleaned Amazon products table
Select 
    category_v2,
    Count(category_v2) as Product_Count
from Amazon_product_cleaned
group by category_v2;
