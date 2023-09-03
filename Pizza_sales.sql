select *
from pizza_sales


--jumlah price
select SUM(total_price) total_revenue
from pizza_sales

--rata-rata order
select SUM(total_price)/count(distinct order_id) avg_order
from pizza..pizza_sales



ALTER TABLE [dbo].[pizza_sales]
ALTER COLUMN [quantity] INT;

UPDATE [dbo].[pizza_sales]
SET [quantity] = CAST([quantity] AS INT);

--total kuantiti
select SUM(quantity)
from pizza..pizza_sales


--rata-rata kuantiti
select cast(cast (SUM(quantity) as  decimal(9,2))/cast(count(distinct order_id) as decimal(9,2)) as decimal(10,2))
from pizza..pizza_sales

--order setiap hari
select DATENAME(dw, order_date) as order_day, COUNT(distinct order_id) as total_orders
from pizza_sales
group by DATENAME(dw, order_date)

--order setiap bulan
select DATENAME(MONTH, order_date) as order_month, COUNT(distinct order_id) as total_orders
from pizza_sales
group by DATENAME(MONTH, order_date) 


--% price
select SUM(total_price) total_revenue
from pizza_sales 

--katogori pizza
select pizza_category,cast(SUM( total_price) * 100/(select SUM(total_price)
from pizza_sales
where MONTH(order_date) = 1) as decimal(10,2))
from pizza_sales
where MONTH(order_date) = 1
group by pizza_category

--%pizza size
select pizza_size,cast(SUM( total_price) * 100/(select SUM(total_price)
from pizza_sales)
 as decimal(10,2)) pct
from pizza_sales
where DATEPART(QUARTER,order_date) =1
group by pizza_size
order by pct desc


--5 pizza keuntungan besar

select top 5 pizza_name,count(distinct order_id) total_order ,sum(total_price) revenue
from pizza_sales
group by pizza_name
order by revenue desc
