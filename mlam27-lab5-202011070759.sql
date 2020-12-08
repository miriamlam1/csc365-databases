-- Lab 5
-- mlam27
-- Nov 7, 2020

USE `AIRLINES`;
-- AIRLINES-1
-- Find all airports with exactly 17 outgoing flights. Report airport code and the full name of the airport sorted in alphabetical order by the code.
SELECT Code, Name from airports
JOIN flights ON airports.Code = flights.Source
GROUP BY Code, Name
HAVING COUNT(FlightNo) = 17
ORDER BY Code;


USE `AIRLINES`;
-- AIRLINES-2
-- Find the number of airports from which airport ANP can be reached with exactly one transfer. Make sure to exclude ANP itself from the count. Report just the number.
SELECT COUNT(DISTINCT a1.source)
from flights as a1, flights as a2
    where a2.destination = 'ANP' and
    a1.destination = a2.source and
    a1.source <> 'ANP' and
    a1.source <> a2.destination;


USE `AIRLINES`;
-- AIRLINES-3
-- Find the number of airports from which airport ATE can be reached with at most one transfer. Make sure to exclude ATE itself from the count. Report just the number.
SELECT COUNT(DISTINCT a1.source) as AirportCount
from flights as a1, flights as a2
    where (a2.destination = 'ATE' and
    a1.destination = a2.source and
    a1.source <> 'ATE' and
    a1.source <> a2.destination) OR
    (a1.destination = 'ATE');


USE `AIRLINES`;
-- AIRLINES-4
-- For each airline, report the total number of airports from which it has at least one outgoing flight. Report the full name of the airline and the number of airports computed. Report the results sorted by the number of airports in descending order. In case of tie, sort by airline name A-Z.
select Name, COUNT(*) as Airports from
(select airlines.Name, COUNT(*)  from airlines
join flights on airlines.Id = flights.airline
join airports on airports.Code = flights.source
GROUP BY airlines.Name, source
HAVING count(source) >= 1) p
GROUP BY Name
ORDER BY Airports DESC, Name;


USE `BAKERY`;
-- BAKERY-1
-- For each flavor which is found in more than three types of items offered at the bakery, report the flavor, the average price (rounded to the nearest penny) of an item of this flavor, and the total number of different items of this flavor on the menu. Sort the output in ascending order by the average price.
SELECT Flavor, ROUND(AVG(PRICE),2) as AveragePrice, COUNT(Flavor) FROM goods
GROUP BY Flavor
HAVING COUNT(*) > 3
ORDER BY AveragePrice;


USE `BAKERY`;
-- BAKERY-2
-- Find the total amount of money the bakery earned in October 2007 from selling eclairs. Report just the amount.
SELECT SUM(price) as EclairRevenue from receipts
JOIN items ON items.Receipt = receipts.RNumber
JOIN goods ON goods.GId = items.Item
WHERE SaleDate >= '2007-10-01' and SaleDate <= '2007-10-31'
AND goods.Food = 'eclair';


USE `BAKERY`;
-- BAKERY-3
-- For each visit by NATACHA STENZ output the receipt number, sale date, total number of items purchased, and amount paid, rounded to the nearest penny. Sort by the amount paid, greatest to least.
SELECT RNumber, SaleDate, COUNT(*), ROUND(SUM(PRICE),2) as CheckAmount 
FROM receipts
JOIN customers ON customers.CId = receipts.Customer
JOIN items ON items.Receipt = receipts.RNumber
JOIN goods on goods.GId = items.Item
WHERE customers.LastName = "STENZ" AND FirstName = "NATACHA"
GROUP BY SaleDate, RNumber
ORDER BY CheckAmount DESC;


USE `BAKERY`;
-- BAKERY-4
-- For the week starting October 8, report the day of the week (Monday through Sunday), the date, total number of purchases (receipts), the total number of pastries purchased, and the overall daily revenue rounded to the nearest penny. Report results in chronological order.
SELECT DAYNAME(SaleDate) as Day, SaleDate, COUNT(DISTINCT RNumber) as Reciepts,
    COUNT(Item) as Items, ROUND(Sum(PRICE),2) as Revenue
FROM receipts
JOIN items ON items.Receipt = receipts.RNumber
JOIN goods on items.Item = goods.GId
WHERE SaleDate >= '2007-10-08' and SaleDate <= '2007-10-14'
GROUP BY SaleDate
ORDER BY SaleDate;


USE `BAKERY`;
-- BAKERY-5
-- Report all dates on which more than ten tarts were purchased, sorted in chronological order.
SELECT SaleDate from receipts
JOIN items ON items.Receipt = receipts.RNumber
JOIN goods ON goods.GId = items.Item
WHERE food = "Tart"
GROUP BY SaleDate
HAVING COUNT(SaleDate) > 10;


USE `CSU`;
-- CSU-1
-- For each campus that averaged more than $2,500 in fees between the years 2000 and 2005 (inclusive), report the campus name and total of fees for this six year period. Sort in ascending order by fee.
SELECT Campus, SUM(fee) as Total from campuses
JOIN fees ON fees.CampusId = campuses.Id
WHERE fees.year >= 2000 and fees.year <= 2005
GROUP BY campus
HAVING Total/COUNT(*) > 2500
ORDER BY Total;


USE `CSU`;
-- CSU-2
-- For each campus for which data exists for more than 60 years, report the campus name along with the average, minimum and maximum enrollment (over all years). Sort your output by average enrollment.
SELECT Campus, AVG(Enrolled) as Average, MIN(Enrolled) as Minimum, MAX(Enrolled) as Maximum
FROM campuses
JOIN enrollments ON campuses.Id = enrollments.CampusId
GROUP BY Campus
HAVING COUNT(enrollments.year) > 60
ORDER BY Average;


USE `CSU`;
-- CSU-3
-- For each campus in LA and Orange counties report the campus name and total number of degrees granted between 1998 and 2002 (inclusive). Sort the output in descending order by the number of degrees.

SELECT Campus, SUM(degrees) as Total FROM campuses
JOIN degrees on degrees.CampusId = campuses.Id
WHERE degrees.year >= 1998 AND degrees.year <= 2002
AND (County = 'Los Angeles' OR County = 'Orange')
GROUP BY Campus
ORDER BY Total DESC;


USE `CSU`;
-- CSU-4
-- For each campus that had more than 20,000 enrolled students in 2004, report the campus name and the number of disciplines for which the campus had non-zero graduate enrollment. Sort the output in alphabetical order by the name of the campus. (Exclude campuses that had no graduate enrollment at all.)
SELECT Campus, COUNT(*) FROM campuses
JOIN discEnr ON discEnr.CampusId = campuses.Id
JOIN enrollments ON enrollments.CampusId = campuses.Id
WHERE enrollments.year = 2004 AND enrolled > 20000 AND Gr > 0
GROUP BY Campus
ORDER BY Campus;


USE `INN`;
-- INN-1
-- For each room, report the full room name, total revenue (number of nights times per-night rate), and the average revenue per stay. In this summary, include only those stays that began in the months of September, October and November. Sort output in descending order by total revenue. Output full room names.
SELECT RoomName, Round(SUM(Rate*DateDiff(CheckOut,CheckIn)),2) AS TotalRevenue,
    Round(AVG(Rate*DateDiff(CheckOut,CheckIn)),2) AS AveragePerStay
FROM rooms
JOIN reservations ON reservations.Room = rooms.roomCode
WHERE Month(CheckIn)>= 9 and Month(CheckIn)<=11
GROUP BY RoomName
ORDER BY TotalRevenue DESC;


USE `INN`;
-- INN-2
-- Report the total number of reservations that began on Fridays, and the total revenue they brought in.
SELECT COUNT(*) as Stays, Round(SUM(Rate * DateDiff(CheckOut,CheckIn)),2) as REVENUE
FROM reservations
WHERE DayName(CheckIn) = "Friday"
GROUP BY DayName(CheckIn);


USE `INN`;
-- INN-3
-- List each day of the week. For each day, compute the total number of reservations that began on that day, and the total revenue for these reservations. Report days of week as Monday, Tuesday, etc. Order days from Sunday to Saturday.
SELECT DayName(CheckIn) as Day, COUNT(*) as Stays,
    SUM(Rate * DateDiff(CheckOut,CheckIn)) as REVENUE
FROM reservations
GROUP BY Day, DayOfWeek(CheckIn)
ORDER BY DayOfWeek(CheckIn);


USE `INN`;
-- INN-4
-- For each room list full room name and report the highest markup against the base price and the largest markdown (discount). Report markups and markdowns as the signed difference between the base price and the rate. Sort output in descending order beginning with the largest markup. In case of identical markup/down sort by room name A-Z. Report full room names.
SELECT RoomName, MAX(Rate - BasePrice) as Markup,
    MIN(Rate - BasePrice) as Discount
FROM rooms
JOIN reservations ON reservations.Room = rooms.roomCode
GROUP BY RoomName
ORDER BY Markup DESC, RoomName;


USE `INN`;
-- INN-5
-- For each room report how many nights in calendar year 2010 the room was occupied. Report the room code, the full name of the room, and the number of occupied nights. Sort in descending order by occupied nights. (Note: this should be number of nights during 2010. Some reservations extend beyond December 31, 2010. The ”extra” nights in 2011 must be deducted).
SELECT RoomCode, Roomname, DateDiff(CheckOut,CheckIn) as DaysOccupied from rooms
JOIN reservations ON reservations.Room = rooms.roomCode
WHERE Year(CheckIn)<= 2010 and Year(CheckOut) >= 2010
GROUP BY RoomCode, DaysOccupied;


USE `KATZENJAMMER`;
-- KATZENJAMMER-1
-- For each performer, report first name and how many times she sang lead vocals on a song. Sort output in descending order by the number of leads. In case of tie, sort by performer first name (A-Z.)
SELECT FirstName, COUNT(*) as 'Lead' FROM Band
JOIN Vocals ON Vocals.Bandmate = Band.Id
WHERE VocalType = 'lead'
GROUP BY Bandmate
ORDER BY COUNT(*) DESC;


USE `KATZENJAMMER`;
-- KATZENJAMMER-2
-- Report how many different instruments each performer plays on songs from the album 'Le Pop'. Include performer's first name and the count of different instruments. Sort the output by the first name of the performers.
SELECT FirstName, COUNT(DISTINCT Instrument) as InstrumentCount
FROM Band
JOIN Instruments ON Instruments.Bandmate = Band.Id
JOIN Songs ON Songs.SongId = Instruments.Song
JOIN Tracklists ON Tracklists.Song = Songs.SongId
JOIN Albums ON Albums.AId = Tracklists.Album
WHERE Albums.Title = "Le Pop"
GROUP BY Bandmate
ORDER BY FirstName;


USE `KATZENJAMMER`;
-- KATZENJAMMER-3
-- List each stage position along with the number of times Turid stood at each stage position when performing live. Sort output in ascending order of the number of times she performed in each position.

SELECT StagePosition, COUNT(*) as Count
FROM Performance
JOIN Band ON Band.Id = Performance.Bandmate
WHERE FirstName = "Turid"
GROUP BY StagePosition
ORDER BY Count;


USE `KATZENJAMMER`;
-- KATZENJAMMER-4
-- Report how many times each performer (other than Anne-Marit) played bass balalaika on the songs where Anne-Marit was positioned on the left side of the stage. List performer first name and a number for each performer. Sort output alphabetically by the name of the performer.

select * from Performance

join Band b1 on Performance.Bandmate = b1.Id
join Instruments i1 on i1.Bandmate = b1.Id

join Band b2 on Performance.Bandmate = b2.Id
join Instruments i2 on i1.Bandmate = b2.Id

where (b1.FirstName = "Anne-Marit" and Performance.StagePosition = "left") and
(i2.Instrument = "bass balalaika" and b2.FirstName <> "Anne-Marit");


USE `KATZENJAMMER`;
-- KATZENJAMMER-5
-- Report all instruments (in alphabetical order) that were played by three or more people.
SELECT Instrument FROM Instruments
GROUP BY Instrument
HAVING COUNT(DISTINCT Bandmate) >= 3
ORDER BY Instrument;


USE `KATZENJAMMER`;
-- KATZENJAMMER-6
-- For each performer, list first name and report the number of songs on which they played more than one instrument. Sort output in alphabetical order by first name of the performer
SELECT FirstName, COUNT(*) from (SELECT FirstName, COUNT(FirstName) as MultiInstrumentCount
from Instruments
JOIN Band ON Band.Id = Instruments.Bandmate
GROUP BY Bandmate, Song
having MultiInstrumentCount > 1) fd
GROUP BY FirstName
ORDER BY FirstName;


USE `MARATHON`;
-- MARATHON-1
-- List each age group and gender. For each combination, report total number of runners, the overall place of the best runner and the overall place of the slowest runner. Output result sorted by age group and sorted by gender (F followed by M) within each age group.
SELECT AgeGroup, Sex, Count(*), MIN(Place) as BestPlacing, MAX(Place) as SlowestPlacing
FROM marathon
GROUP BY AgeGroup, Sex
ORDER BY AgeGroup, Sex;


USE `MARATHON`;
-- MARATHON-2
-- Report the total number of gender/age groups for which both the first and the second place runners (within the group) are from the same state.
SELECT COUNT(*) FROM
(SELECT COUNT(*) FROM marathon
WHERE GroupPlace = 1 OR GroupPlace = 2
GROUP BY AgeGroup, Sex, State
HAVING COUNT(State) = 2) newTable;


USE `MARATHON`;
-- MARATHON-3
-- For each full minute, report the total number of runners whose pace was between that number of minutes and the next. In other words: how many runners ran the marathon at a pace between 5 and 6 mins, how many at a pace between 6 and 7 mins, and so on.
SELECT MINUTE(Pace) as PaceMinutes, COUNT(*)
FROM marathon
GROUP BY PaceMinutes;


USE `MARATHON`;
-- MARATHON-4
-- For each state with runners in the marathon, report the number of runners from the state who finished in top 10 in their gender-age group. If a state did not have runners in top 10, do not output information for that state. Report state code and the number of top 10 runners. Sort in descending order by the number of top 10 runners, then by state A-Z.
SELECT State, COUNT(*) as NumberOfTop10 from marathon
WHERE GroupPlace <= 10
GROUP BY State
ORDER BY NumberOfTop10 DESC;


USE `MARATHON`;
-- MARATHON-5
-- For each Connecticut town with 3 or more participants in the race, report the town name and average time of its runners in the race computed in seconds. Output the results sorted by the average time (lowest average time first).
SELECT Town, ROUND(AVG(TIME_TO_SEC(RunTime)),1) AS AverageTimeInSeconds
FROM marathon
WHERE State = "CT"
GROUP BY Town
HAVING COUNT(*) >= 3
ORDER BY AverageTimeInSeconds;


USE `STUDENTS`;
-- STUDENTS-1
-- Report the last and first names of teachers who have between seven and eight (inclusive) students in their classrooms. Sort output in alphabetical order by the teacher's last name.
SELECT teachers.last, teachers.first from teachers
JOIN list ON teachers.classroom = list.classroom
GROUP BY teachers.last, teachers.first
HAVING COUNT(*) >= 7 and COUNT(*) <= 8
ORDER BY teachers.last;


USE `STUDENTS`;
-- STUDENTS-2
-- For each grade, report the grade, the number of classrooms in which it is taught, and the total number of students in the grade. Sort the output by the number of classrooms in descending order, then by grade in ascending order.

SELECT Grade, COUNT(*), SUM(p) FROM
(SELECT Grade, COUNT(*) as p from list
GROUP BY Grade, Classroom) k
GROUP BY Grade
ORDER BY COUNT(*) DESC, Grade;


USE `STUDENTS`;
-- STUDENTS-3
-- For each Kindergarten (grade 0) classroom, report classroom number along with the total number of students in the classroom. Sort output in the descending order by the number of students.
SELECT classroom, COUNT(*) as Students
FROM list
WHERE grade = 0
GROUP BY classroom
ORDER BY Students DESC;


USE `STUDENTS`;
-- STUDENTS-4
-- For each fourth grade classroom, report the classroom number and the last name of the student who appears last (alphabetically) on the class roster. Sort output by classroom.
SELECT classroom, Max(LastName) as LastOnRoster
FROM list
WHERE grade = 4
GROUP BY classroom
ORDER BY classroom;


