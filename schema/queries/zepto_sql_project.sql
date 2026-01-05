drop table if exists zepto;

create table zepto(
sku_id serial primary key,
Category varchar(120),
name varchar(150) not null,
mrp numeric(8,2),
discountPercent numeric (5,2),
availableQuantity integer, 
discountedSellingPrice numeric(8,2),
weightInGms integer,
outOfStock boolean,
quantity integer
);

--data exploration

--count of rows

select count(*)
from zepto;

--sample data 

select *
from zepto;

--null values

select * from zepto
where name is null
or
sku_id  is null
or
Category is null
or
mrp is null
or
discountPercent is null
or
availableQuantity is null
or
discountedSellingPrice is null
or
weightInGms is null
or
outOfStock is null
or
quantity is null;

--different product categories

select distinct category
from zepto
order by category;

--products in stock vs out of stock

select outOfStock, count(sku_id)
from zepto
group by outOfStock;

--product name present multiple times

select name, count(sku_id)as "number_of_SKUs"
from zepto
group by name
having count (sku_id) >1
order by count (sku_id) desc;

---data cleaning

--products with price = 0

select *
from zepto
where mrp = 0 
or discountedSellingPrice = 0;

--convert paise to rupees

update zepto
set mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

---bussiness related questions

--1. find the top 10 best value products based on the discount percentage.

select *
from zepto
where discountPercent is not null
order by discountPercent desc
limit 10;

--2. what are the products with high MRP but out of stock

select name, mrp, outOfStock 
from zepto
where outOfStock = true and mrp >300
order by mrp desc;

--3. calculate estimated revenue for each category

select category,sum(discountedSellingPrice * availableQuantity) as total_revenue
from zepto
group by category
order by total_revenue;

--4. find all products where MRP is greter than 500 and discount is less than 10%

select distinct name, mrp, discountPercent
from zepto
where mrp >500 and discountPercent <10
ORDER BY mrp desc, discountPercent desc;

--5.identify the top 5 categories offering the highest average discount percentage.

select category, round(avg(discountPercent),2) as avg_discount
from zepto
group by category
order by  avg_discount desc
limit 5;

--6.find the price per gram for products above 100g and sort by best value.

select sku_id,
    category,
    name,
    weightInGms,
    discountedSellingPrice,
	round((discountedSellingPrice/weightInGms),2) as price_per_gm
from zepto
where weightInGms >100
and discountedSellingPrice is not null
and outOfStock = false
order by price_per_gm;

--7.group the products into categories like low, medium, bulk.

select distinct name, weightInGms,
case when weightInGms <1000 then 'low'
     when weightInGms <5000 then 'medium'
	 else 'bulk'
	 end as weight_category
from zepto;

--8.what is the total inventory weight per category.

select category,sum(weightInGms * availableQuantity)as total_weight
from zepto
group by category
order by total_weight;



