-- Final Exam Part b
-- mlam27
-- Dec 4, 2020

USE `BAKERY`;
-- BAKERY-1
-- Find all Cookies (any flavor) or Lemon-flavored items (any type) that have been purchased on either Saturday or Sunday (or both days). List each food and flavor once. Sort by food then flavor.
select DISTINCT(Food), flavor from receipts
join items on Receipt = RNumber
join goods on GId = Item
join customers on Customer = CId
where (DAYOFWEEK(SaleDate) = 7 or DAYOFWEEK(SaleDate) = 1)
and (Food = 'Cookie' or Flavor = 'Lemon')
group by Customer, Flavor, Food
order by food, flavor;


USE `BAKERY`;
-- BAKERY-2
-- For customers who have purchased at least one Cookie, find the customer's favorite flavor(s) of Cookie based on number of purchases.  List last name, first name, flavor and purchase count. Sort by customer last name, first name, then flavor.
with favorite_cookie as (
    select count(flavor) as total, flavor, Customer from receipts
    join items on Receipt = RNumber
    join goods on GId = Item
    where food = "cookie"
    group by flavor, customer
)
select LastName, FirstName, Flavor, total from favorite_cookie f2
join customers on customers.Cid = f2.customer
where total = (select max(total) from favorite_cookie f1
    where f1.customer = f2.customer)
order by lastname, firstname, flavor;


USE `BAKERY`;
-- BAKERY-3
-- Find all customers who purchased a Cookie on two or more consecutive days. List customer ID, first, and last name. Sort by customer ID.
with cust as (
    select * from customers
    join receipts on Customer = CId
    join items on Receipt = RNumber
    join goods on GId = Item
    where food = "cookie"
)
select distinct c1.CId, c1.LastName, c1.Firstname from cust c1
join cust c2 on
c2.cid = c1.cid
where c1.saledate <> c2.saledate and c1.saledate = c2.saledate+1
order by c1.CID;


USE `BAKERY`;
-- BAKERY-4
-- Find customers who have purchased every Almond-flavored item or who have purchased every Walnut-flavored item. Include customers who have purchased all items of both flavors. Report customer ID, first name and last name. Sort by customer ID.
with almondlovers as ( 
    select lastname, firstname, cid
    from customers as c
     join receipts r on cid = customer
     join items i on rnumber = receipt
     join goods g on g.Gid = i.Item
    where g.flavor = 'almond'
    group by lastname, firstname, cid
    having count(distinct food) = (
     select count(distinct food)
     from goods g2 where g2.flavor = 'almond'
    )
) ,
walnutlovers as (
    select lastname, firstname, cid
    from customers as c
     join receipts r on cid = customer
     join items i on rnumber = receipt
     join goods g on g.Gid = i.Item
    where g.flavor = 'walnut'
    group by lastname, firstname, cid
    having count(distinct food) = (
     select count(distinct food)
     from goods g2 where g2.flavor = 'walnut'
    )
)
select cid, firstname, lastname from walnutlovers
union
select cid, firstname, lastname from almondlovers
order by cId;


USE `INN`;
-- INN-1
-- Find all rooms that are vacant during the entire date range June 1st and June 8th, 2010 (inclusive). Report room codes, sorted alphabetically.
with occupied as (
    select distinct roomcode from rooms
    join reservations on Roomcode = reservations.room
    where checkin < '2010-06-08' and checkout > '2010-06-01'
)
select distinct roomcode from rooms
join reservations on Roomcode = reservations.room
where roomcode not in (
    select * from occupied
)
order by roomcode;


USE `INN`;
-- INN-2
-- For calendar year 2010, create a monthly report for room with code AOB. List each calendar month and the number of reservations that began in that month. Include a plus or minus sign, indicating whether the month is at/above (+) or below (-) the average number of reservations per month for the room. Sort in chronological order by month.
with mtotals as (
    select month(CheckIn) as month, count(*) as NumReservations from reservations
    where year(checkin) = 2010 and room = "AOB"
    group by month
),
findavg as (
    select avg(NumReservations) from mtotals
)
select monthname(STR_TO_DATE(Month,'%m')) as MonthStr, NumReservations,
case
    when NumReservations > (select * from findavg) then "+"
    else "-"
end as 	ComparedToAvg
from mtotals
order by month;


USE `INN`;
-- INN-3
-- For each room, find the longest vacancy (number of nights) between a reservation and the next reservation in the same room. Exclude from consideration the "last" reservation in each room, for which there is no future reservation. List room code and the length in nights of the longest vacancy. Report 0 if there are no periods of vacancy for a given room. Sort by room code.
-- No attempt


USE `AIRLINES`;
-- AIRLINES-1
-- List the name of every airline along with the number of that airline's flights which depart from airport ACV. If an airline does not fly from ACV, show the number 0. Sort alphabetically by airline name.
with acv as(
    select name, count(*) as c from airlines
    join flights on flights.airline = airlines.id
    where source = "ACV"
    group by name
)

select name, 
case when name in
    (select name from acv) then (select c from acv where acv.name = airlines.name)
    else 0
end as FlightsFromACV
from airlines

order by name;


USE `AIRLINES`;
-- AIRLINES-2
-- Find the airports with the highest and lowest percentages of inbound flights on Frontier Airlines. For example, airport ANQ is the destination of 10 flights, 1 of which is a Frontier flight, yielding a "Frontier percentage" of 10. Report airport code and Frontier percentage rounded to two decimal places. Sort by airport code.
with ff as(
    select name, destination, count(*) as c from airlines
    join flights on flights.airline = airlines.id
    where abbr = "Frontier"
    group by name, destination
),
tf as (
    select source, count(*) as b from airlines
    join flights on flights.airline = airlines.id
    group by name, source
),
totalairport as (
    select source, sum(b) as b from tf
    group by source
),
percentages as (
    select destination,(c/(select b from totalairport where totalairport.source = ff.destination))*100 as pct
    from ff
), 
maxi as(
    select distinct pct from percentages
    where pct = (select max(pct) from percentages)
),
mini as(
    select distinct pct from percentages
    where pct = (select min(pct) from percentages)
)
select destination, pct from percentages
where pct = (select* from maxi) or 
pct =  (select* from mini)

order by destination;


USE `AIRLINES`;
-- AIRLINES-3
-- If a passenger begins a one-transfer flight at airport ACV, which intermediate transfer airport(s) will allow the greatest number of possible final destinations? List the origin airport, transfer airport, and number of different possible destinations. Sort by the transfer airport.
-- No attempt


