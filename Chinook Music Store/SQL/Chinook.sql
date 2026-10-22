use Chinook
go

--List every track along with its album title. Include tracks even if album info is missing.
 select t.TrackId ,
 t.Name as TrackName,
 a.Title as AlbumTitle
 from Track t left join Album a 
 on t.AlbumId=a.AlbumId;
 ---------------------------------------------------------------------------------------------------------------------------------------

 -- Which music genres have more than 10 tracks, and what is the average price of tracks in each genre?

  select g.Name as Genre_Name, count(t.TrackId) as num_track ,
 avg(t.UnitPrice)as Average_Price
 from Genre g left join track t 
 on g.GenreId=t.GenreId
 group by g.Name
 having count(t.TrackId) > 10;
 --------------------------------------------------------------------------------------------------------------------

---- Which customers have spent more than $100 in total across all their purchases? --> CTE/GROUP BY/ CONCAT / JOIN

with CustomerSpending as
 ( 
   select CustomerId,
   sum(Total) AS Total_Spending
   from Invoice
   group by CustomerId
 )
 select concat_ws(' ',c.FirstName,c.LastName) as Full_name,
  cs.Total_Spending
  from Customer c join CustomerSpending cs
  on c.CustomerId= cs.CustomerId
-- where cs.Total_Spending < 100;
 where cs.Total_Spending > 100
 ORDER BY cs.Total_Spending DESC;

  ----------------------------------------------------------------------------------------------------------------
--Which countries generate the highest total sales revenue?

select c.Country, sum(i.Total) as Total_Revenue
from Customer c left join Invoice i
on c.CustomerId=i.CustomerId
group by c.Country
order by Total_Revenue desc;

---------------------------------------------------------------------------------------------------------------------
--Which employees support the largest number of customers?

select concat_ws(' ',e.FirstName , e.LastName) as Full_name
,count(c.CustomerId) as total_customer
from Employee e join Customer c 
on e.EmployeeId= c.SupportRepId
group by e.EmployeeId, e.FirstName,e.LastName
order by total_customer desc;

---------------------------------------------------------------------------------------------------------------------------------
-- How can invoices be categorized based on their total value as High, Medium, or Low?

select InvoiceId ,Total,
case 
    when Total >= 10 then 'High'
    when Total >= 5 then 'Medium'
    else 'Low'
    end as InvoiceCategory
from Invoice;

------------------------------------------------------------------------------------------------------------------------------
--Which unique customer countries are represented in the database?

select distinct country 
from Customer
order by country;

-----------------------------------------------------------------------------------------------------------
--Which customers are located in the USA, Canada, or Brazil?

select concat_ws(' ',FirstName,LastName) as Full_Name,Country
from Customer
where country in('USA','Canada','Brazil')
order by Country;

----------------------------------------------------------------------------------------------------------------------
---Which tracks are more expensive than the average track price?

Select
    Name,
    UnitPrice
from Track
where UnitPrice >
(
    select AVG(UnitPrice)
    from Track
);

------------------------------------------------------------------------------------------------------
-- Which customers have first names that start with the letter 'A'?

select FirstName , LastName
from Customer
where FirstName like 'A%';

--------------------------------------------------------------------------------------------------------------
-- Rank customers based on their total spending from highest to lowest.

with CustomerSpending as
 ( 
   select CustomerId,
   sum(Total) AS Total_Spending
   from Invoice
   group by CustomerId
 )
 select concat_ws(' ',c.FirstName,c.LastName) as Full_name,
  cs.Total_Spending,
  rank() over(order by cs.Total_Spending desc) as spending_rank
  from Customer c left join CustomerSpending cs
  on c.CustomerId= cs.CustomerId
  order by spending_rank;
