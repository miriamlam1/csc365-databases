-- Lab 6
-- mlam27
-- Nov 22, 2020

USE `BAKERY`;
-- BAKERY-1
-- Find all customers who did not make a purchase between October 5 and October 11 (inclusive) of 2007. Output first and last name in alphabetical order by last name.
select distinct FirstName, LastName from receipts
join customers on CId = Customer
where customer not in (
    select Customer from receipts
    where SaleDate >= '2007-10-05' and SaleDate <= '2007-10-11'
)
order by LastName, FirstName;


USE `BAKERY`;
-- BAKERY-2
-- Find the customer(s) who spent the most money at the bakery during October of 2007. Report first, last name and total amount spent (rounded to two decimal places). Sort by last name.
with spending as (select Customer, FirstName, LastName, SUM(price) as MoneySpent from receipts
join items on Receipt = RNumber
join customers on Customer = CId
join goods on GId = Item
where SaleDate >= '2007-10-01' and SaleDate <= '2007-10-31'
group by Customer)

select FirstName, LastName, round(MoneySpent,2) from spending
    where MoneySpent = (
        select MAX(MoneySpent) from spending
    );


USE `BAKERY`;
-- BAKERY-3
-- Find all customers who never purchased a twist ('Twist') during October 2007. Report first and last name in alphabetical order by last name.

select distinct FirstName, LastName from receipts
join customers on CId = Customer
where customer not in (
    select Customer from receipts
    join items on Receipt = RNumber
    join customers on Customer = CId
    join goods on GId = Item
    where SaleDate >= '2007-10-01' and SaleDate <= '2007-10-31'
    and Food = 'Twist'
)
order by LastName, FirstName;


USE `BAKERY`;
-- BAKERY-4
-- Find the baked good(s) (flavor and food type) responsible for the most total revenue.
with revenueTable as (
    select Food, Flavor, SUM(PRICE) as Revenue from receipts 
    join items on Receipt = RNumber
    join goods on GId = Item
    group by Food,Flavor
)
select Flavor, Food from revenueTable
where Revenue = (
    select MAX(Revenue) from revenueTable
);


USE `BAKERY`;
-- BAKERY-5
-- Find the most popular item, based on number of pastries sold. Report the item (flavor and food) and total quantity sold.
with goodsTable as (
    select Food, Flavor, COUNT(*) as total from receipts 
    join items on Receipt = RNumber
    join goods on GId = Item
    group by Food,Flavor
)
select Flavor, Food, total from goodsTable
where total = (
    select MAX(total) from goodsTable
);


USE `BAKERY`;
-- BAKERY-6
-- Find the date(s) of highest revenue during the month of October, 2007. In case of tie, sort chronologically.
with aTable as (
    select SaleDate, SUM(price) as total from receipts 
    join items on Receipt = RNumber
    join goods on GId = Item
    group by SaleDate
)
select SaleDate from aTable
where total = (
    select MAX(total) from aTable
)
order by SaleDate;


USE `BAKERY`;
-- BAKERY-7
-- Find the best-selling item(s) (by number of purchases) on the day(s) of highest revenue in October of 2007.  Report flavor, food, and quantity sold. Sort by flavor and food.
with aTable as (
    select SaleDate, Food, Flavor, COUNT(*) as acount, SUM(price) as total from receipts 
    join items on Receipt = RNumber
    join goods on GId = Item
    group by SaleDate, Food, Flavor
)
select Flavor, Food, acount from aTable
where total = (
    select MAX(total) from aTable
)
order by SaleDate;


USE `BAKERY`;
-- BAKERY-8
-- For every type of Cake report the customer(s) who purchased it the largest number of times during the month of October 2007. Report the name of the pastry (flavor, food type), the name of the customer (first, last), and the quantity purchased. Sort output in descending order on the number of purchases, then in alphabetical order by last name of the customer, then by flavor.
with atable as (
    select FirstName, LastName, Customer, Flavor, Food, COUNT(*) as total from receipts
    join items on Receipt = RNumber
    join goods on GId = Item
    join customers on Customer = CId
    where SaleDate >= '2007-10-01' and SaleDate <= '2007-10-31' and Food = 'Cake'
    group by Customer, Flavor, Food
)
select Flavor, Food, FirstName, LastName, total from atable a1
where total = (
    select MAX(total) from atable a2
    where a1.flavor = a2.flavor
)
order by total desc, LastName, flavor;


USE `BAKERY`;
-- BAKERY-9
-- Output the names of all customers who made multiple purchases (more than one receipt) on the latest day in October on which they made a purchase. Report names (last, first) of the customers and the *earliest* day in October on which they made a purchase, sorted in chronological order, then by last name.

with first as (
    select customer, firstname, lastname, min(saledate) as earlyday
    from receipts
    join items on receipt = rnumber
    join goods on gid = item
    join customers on customer = cid
    group by customer
),
last as (
    select Customer, firstname, lastname, max(saledate) as lateday
    from receipts
    join items on receipt = rnumber
    join goods on gid = item
    join customers on customer = cid
    group by customer
)
select first.lastname, first.firstname, earlyday from receipts
join first on first.Customer = receipts.Customer 
join last on last.Customer = receipts.Customer  and saledate = lateday
group by receipts.Customer 
having count(RNumber) > 1
order by earlyday, lastname;


USE `BAKERY`;
-- BAKERY-10
-- Find out if sales (in terms of revenue) of Chocolate-flavored items or sales of Croissants (of all flavors) were higher in October of 2007. Output the word 'Chocolate' if sales of Chocolate-flavored items had higher revenue, or the word 'Croissant' if sales of Croissants brought in more revenue.

with Croissants as (
    select SUM(PRICE) as price from receipts 
    join items on Receipt = RNumber
    join goods on GId = Item
    where Food = 'Croissant'
),
Chocolates as (
    select SUM(PRICE) as price from receipts 
    join items on Receipt = RNumber
    join goods on GId = Item
    where Flavor = 'Chocolate'
)
select case when Croissants.price > Chocolates.price
then 'Croissant'
else 'Chocolate'
end as winner
from Croissants join Chocolates;


USE `INN`;
-- INN-1
-- Find the most popular room(s) (based on the number of reservations) in the hotel  (Note: if there is a tie for the most popular room, report all such rooms). Report the full name of the room, the room code and the number of reservations.

with atable as (
    select Count(*) as total, Room, RoomName from reservations
    join rooms on Room = RoomCode
    group by Room
)
select RoomName, Room, total from atable
where total = (
    select max(total) from atable
);


USE `INN`;
-- INN-2
-- Find the room(s) that have been occupied the largest number of days based on all reservations in the database. Report the room name(s), room code(s) and the number of days occupied. Sort by room name.
with atable as (
    select Room, RoomName, DateDiff(Checkout,CheckIn) as days from reservations
    join rooms on Room = RoomCode
    group by Room, days
)
select RoomName, Room, days from atable
where days = (
    select max(days) from atable
);


USE `INN`;
-- INN-3
-- For each room, report the most expensive reservation. Report the full room name, dates of stay, last name of the person who made the reservation, daily rate and the total amount paid (rounded to the nearest penny.) Sort the output in descending order by total amount paid.
with atable as (
    select Room, lastname, RoomName, rate,
        CheckIn, CheckOut,
        DateDiff(Checkout,CheckIn) * Rate as Cost from reservations
    join rooms on Room = RoomCode
    group by Room, Cost, rate, CheckIn, CheckOut, lastname
)
select RoomName, checkin, checkout, lastname, rate, cost from atable a1
where cost = (
    select max(cost) from atable a2
    where a2.room = a1.room
)
order by cost desc;


USE `INN`;
-- INN-4
-- For each room, report whether it is occupied or unoccupied on July 4, 2010. Report the full name of the room, the room code, and either 'Occupied' or 'Empty' depending on whether the room is occupied on that day. (the room is occupied if there is someone staying the night of July 4, 2010. It is NOT occupied if there is a checkout on this day, but no checkin). Output in alphabetical order by room code. 
with occupiedrooms as (
    select Room from reservations
    join rooms on Room = RoomCode
    where CheckIn <= '2010-07-04' and Checkout > '2010-07-04'
)
select distinct roomname, a.room, 
    case when 
    b.room is not null
    then "Occupied"
    else "Empty"
    end as status
from reservations a
join rooms on Room = RoomCode
left join occupiedrooms b
on a.room = b.room
order by room;


USE `INN`;
-- INN-5
-- Find the highest-grossing month (or months, in case of a tie). Report the month name, the total number of reservations and the revenue. For the purposes of the query, count the entire revenue of a stay that commenced in one month and ended in another towards the earlier month. (e.g., a September 29 - October 3 stay is counted as September stay for the purpose of revenue computation). In case of a tie, months should be sorted in chronological order.
with rtotals as (
select month(CheckIn) as month, DateDiff(CheckOut,Checkin) * Rate as price from reservations
),
mtotals as (
select month, sum(price) as mtotal, count(*) as NumReservations from rtotals
group by month
)
select monthname(STR_TO_DATE(Month,'%m')) as Month, NumReservations, mtotal from mtotals
where mtotal = (
    select max(mtotal) from mtotals
)
order by month;


USE `STUDENTS`;
-- STUDENTS-1
-- Find the teacher(s) with the largest number of students. Report the name of the teacher(s) (last, first) and the number of students in their class.

with atable as (
select Last,First,COUNT(*) as nstudents
from teachers
join list on list.classroom = teachers.classroom
group by Last, First
)
select Last,First,nstudents from atable
where nstudents = (
    select MAX(nstudents) from atable
);


USE `STUDENTS`;
-- STUDENTS-2
-- Find the grade(s) with the largest number of students whose last names start with letters 'A', 'B' or 'C' Report the grade and the number of students. In case of tie, sort by grade number.
with atable as (
select Grade,COUNT(*) as nstudents
from teachers
join list on list.classroom = teachers.classroom
where lastname like "A%" or lastname like "B%" or lastname like "C%"
group by Grade
)
select grade, nstudents from atable
where nstudents = (
    select MAX(nstudents) from atable
);


USE `STUDENTS`;
-- STUDENTS-3
-- Find all classrooms which have fewer students in them than the average number of students in a classroom in the school. Report the classroom numbers and the number of student in each classroom. Sort in ascending order by classroom.
with atable as (
select list.classroom,COUNT(*) as nstudents
from teachers
join list on list.classroom = teachers.classroom
group by list.classroom
)
select classroom, nstudents from atable
where nstudents < (select AVG(nstudents) from atable)
order by classroom;


USE `STUDENTS`;
-- STUDENTS-4
-- Find all pairs of classrooms with the same number of students in them. Report each pair only once. Report both classrooms and the number of students. Sort output in ascending order by the number of students in the classroom.
with atable as (
select list.classroom,COUNT(*) as nstudents
from teachers
join list on list.classroom = teachers.classroom
group by list.classroom
)
select a1.classroom,a2.classroom,a1.nstudents from atable a1
join atable a2
on a1.classroom < a2.classroom
and a1.nstudents = a2.nstudents
order by a1.nstudents;


USE `STUDENTS`;
-- STUDENTS-5
-- For each grade with more than one classroom, report the grade and the last name of the teacher who teachers the classroom with the largest number of students in the grade. Output results in ascending order by grade.
with atable as (
select list.classroom, Last, grade,COUNT(*) as nstudents
from teachers
join list on list.classroom = teachers.classroom
group by list.classroom, grade
)
select grade, last from atable a1
where nstudents = (select MAX(nstudents) from atable a2
    where a1.grade = a2.grade
) and grade in (
    select grade from(
        select grade,COUNT(distinct teachers.classroom) as nclass from teachers
    join list on teachers.classroom = list.classroom
    group by grade) p
    where nclass > 1
)
order by grade;


USE `CSU`;
-- CSU-1
-- Find the campus(es) with the largest enrollment in 2000. Output the name of the campus and the enrollment. Sort by campus name.

select Campus, Enrolled from campuses
join enrollments on enrollments.CampusId = campuses.id
where enrollments.year = 2000
and enrolled = ( select max(enrolled) from enrollments 
where year = 2000);


USE `CSU`;
-- CSU-2
-- Find the university (or universities) that granted the highest average number of degrees per year over its entire recorded history. Report the name of the university, sorted alphabetically.

with atable as (
    select campus, sum(degrees) as total from campuses
    join degrees on degrees.campusid = campuses.id
    group by campus
) select campus from atable
where total = (select max(total) from atable);


USE `CSU`;
-- CSU-3
-- Find the university with the lowest student-to-faculty ratio in 2003. Report the name of the campus and the student-to-faculty ratio, rounded to one decimal place. Use FTE numbers for enrollment. In case of tie, sort by campus name.
with atable as (
    select campus, enrollments.fte/faculty.fte as ratio from campuses
    join enrollments on enrollments.campusid = id
    join faculty on faculty.campusid = id
    where faculty.year = enrollments.year and enrollments.year = 2003
) select campus, round(ratio, 1) from atable
where ratio = (select min(ratio) from atable);


USE `CSU`;
-- CSU-4
-- Find the university where, in the year 2004, undergraduate students in the discipline 'Computer and Info. Sciences'  represented the largest percentage out of all enrolled students (use the total from the enrollments table). Output the name of the campus and the percent of these undergraduate students on campus. In case of tie, sort by campus name.
with atable as (
    select distinct campus, (discEnr.ug/enrollments.enrolled)*100 as perc from campuses
    join enrollments on enrollments.campusid = id
    join faculty on faculty.campusid = id
    join discEnr on campuses.id = discEnr.campusid
    join disciplines on disciplines.Id = Discipline
    where Name = 'Computer and Info. Sciences'
    and discEnr.year= enrollments.year and enrollments.year = 2004
    )
select campus, round(perc,1) from atable
where perc = (
select max(perc) from atable);


USE `CSU`;
-- CSU-5
-- For each year between 1997 and 2003 (inclusive) find the university with the highest ratio of total degrees granted to total enrollment (use enrollment numbers). Report the year, the name of the campuses, and the ratio. List in chronological order.
with atable as (
select campus, enrollments.year, degrees/enrolled as ratio from campuses
join degrees on degrees.CampusId = Id
join enrollments on enrollments.campusid = id
where degrees.year >= 1997 and degrees.year <= 2003
and degrees.year = enrollments.year
)
select year, campus, ratio from atable a1
where ratio = (
select max(ratio) from atable a2
where a2.year = a1.year)
order by year;


USE `CSU`;
-- CSU-6
-- For each campus report the year of the highest student-to-faculty ratio, together with the ratio itself. Sort output in alphabetical order by campus name. Use FTE numbers to compute ratios and round to two decimal places.
with atable as (
select distinct campus, enrollments.year, enrollments.fte/faculty.fte as ratio from campuses
join degrees on degrees.CampusId = Id
join enrollments on enrollments.campusid = id
join faculty on faculty.campusid = id
and faculty.year = enrollments.year
)
select campus,year, round(ratio,2) from atable a1
where ratio = (
    select max(ratio) from atable a2
    where a2.campus = a1.campus)
order by campus;


USE `CSU`;
-- CSU-7
-- For each year for which the data is available, report the total number of campuses in which student-to-faculty ratio became worse (i.e. more students per faculty) as compared to the previous year. Report in chronological order.

with atable as (
select distinct campus, enrollments.year, max(enrollments.fte/faculty.fte) as ratio from campuses
join enrollments on enrollments.campusid = id
join faculty on faculty.campusid = id
and faculty.year = enrollments.year
group by enrollments.year, campus
)
select year, count(campus) from atable a1
where ratio > (
    select max(ratio) from atable a2
    where a1.campus = a2.campus
    and a1.year = a2.year +1
)
group by year
order by year;


USE `MARATHON`;
-- MARATHON-1
-- Find the state(s) with the largest number of participants. List state code(s) sorted alphabetically.

with atable as (
    select state, count(*) as total from marathon
    group by state
) 
select state from atable 
where total = (select max(total) from atable);


USE `MARATHON`;
-- MARATHON-2
-- Find all towns in Rhode Island (RI) which fielded more female runners than male runners for the race. Include only those towns that fielded at least 1 male runner and at least 1 female runner. Report the names of towns, sorted alphabetically.

with girls as
(select town, count(*) as total from marathon where sex = "f"
and state = "RI" group by town)
, boys as
(select town, count(*) as total from marathon where sex = "m"
and state = "RI"
group by town)
select girls.town from girls
join boys on boys.town = girls.town
where girls.total > boys.total
and girls.total >= 1 and boys.total >= 1
order by town;


USE `MARATHON`;
-- MARATHON-3
-- For each state, report the gender-age group with the largest number of participants. Output state, age group, gender, and the number of runners in the group. Report only information for the states where the largest number of participants in a gender-age group is greater than one. Sort in ascending order by state code, age group, then gender.
with atable as (
    select state, agegroup, sex, count(*) as total from marathon
    group by state, agegroup, sex
) 
select * from atable a1
where total = (
    select MAX(total) from atable a2
    where a1.state = a2.state)
and total > 1
order by state, agegroup, sex;


USE `MARATHON`;
-- MARATHON-4
-- Find the 30th fastest female runner. Report her overall place in the race, first name, and last name. This must be done using a single SQL query (which may be nested) that DOES NOT use the LIMIT clause. Think carefully about what it means for a row to represent the 30th fastest (female) runner.
select place, firstname, lastname from marathon m1
where sex = 'F' and (
    select count(*) from marathon m2
    where sex = 'F' and m1.place  > m2.place
) = 29
group by place;


USE `MARATHON`;
-- MARATHON-5
-- For each town in Connecticut report the total number of male and the total number of female runners. Both numbers shall be reported on the same line. If no runners of a given gender from the town participated in the marathon, report 0. Sort by number of total runners from each town (in descending order) then by town.

with girls as
(select town, count(*) as gtotal from marathon where sex = "f"
and state = "CT" group by town)
, boys as
(select town, count(*) as btotal from marathon where sex = "m"
and state = "CT"
group by town)

select distinct marathon.town,
case when 
    boys.btotal is null then 0
    else boys.btotal
    end as bb,
case when 
    girls.gtotal is null then 0
    else girls.gtotal
    end as gg
from marathon
left join girls on girls.town = marathon.town
left join boys on boys.town = marathon.town
where state = "ct"

order by gg+bb desc, town;


USE `KATZENJAMMER`;
-- KATZENJAMMER-1
-- Report the first name of the performer who never played accordion.

select firstname from Band
where id not in (
select distinct bandmate from Instruments
where instrument = "accordion");


USE `KATZENJAMMER`;
-- KATZENJAMMER-2
-- Report, in alphabetical order, the titles of all instrumental compositions performed by Katzenjammer ("instrumental composition" means no vocals).

select title from Songs
where SongId not in (
select Song from Vocals)
order by title;


USE `KATZENJAMMER`;
-- KATZENJAMMER-3
-- Report the title(s) of the song(s) that involved the largest number of different instruments played (if multiple songs, report the titles in alphabetical order).
with atable as (
select title, songid, count(*) as total from Instruments
join Songs on Songs.SongId = Instruments.song
group by title, songid)
select title from atable
where total = (select max(total) from atable)
order by title;


USE `KATZENJAMMER`;
-- KATZENJAMMER-4
-- Find the favorite instrument of each performer. Report the first name of the performer, the name of the instrument, and the number of songs on which the performer played that instrument. Sort in alphabetical order by the first name, then instrument.

with atable as (
    select firstname, instrument, count(*) as total from Band
    join Instruments on Bandmate = id
    group by id, instrument
)
select * from atable a1
where total = (
    select MAX(total) from atable a2
    where a1.firstname = a2.firstname
)
order by firstname, instrument;


USE `KATZENJAMMER`;
-- KATZENJAMMER-5
-- Find all instruments played ONLY by Anne-Marit. Report instrument names in alphabetical order.
with atable as (
    select instrument from Band
    join Instruments on Bandmate = id
    where firstname <> "Anne-marit"
)
select instrument from Instruments
join Band on Bandmate = id
where instrument not in (select * from atable)
and firstname = "anne-marit";


USE `KATZENJAMMER`;
-- KATZENJAMMER-6
-- Report, in alphabetical order, the first name(s) of the performer(s) who played the largest number of different instruments.

with atable as (
    select distinct firstname, count(distinct instrument) as total from Band
    join Instruments on Id = Bandmate
    group by firstname
)
select firstname from atable
where total = (
    select MAX(total) from atable
)
order by firstname;


USE `KATZENJAMMER`;
-- KATZENJAMMER-7
-- Which instrument(s) was/were played on the largest number of songs? Report just the names of the instruments, sorted alphabetically (note, you are counting number of songs on which an instrument was played, make sure to not count two different performers playing same instrument on the same song twice).
with atable as(
    select instrument, count(distinct song) as total from Songs
    join Instruments on Instruments.Song = SongId
    group by Instrument
)
select instrument from atable
where total = 
(select max(total) from atable);


USE `KATZENJAMMER`;
-- KATZENJAMMER-8
-- Who spent the most time performing in the center of the stage (in terms of number of songs on which she was positioned there)? Return just the first name of the performer(s), sorted in alphabetical order.

with atable as (
    select firstname, bandmate, count(*) as total from Band
    join Performance on Performance.Bandmate = Band.Id
    where stageposition = 'center'
    group by bandmate
) select firstname from atable
where total = 
(select max(total) from atable)
order by firstname;


