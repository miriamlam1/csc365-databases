-- Lab 4
-- mlam27
-- Oct 22, 2020

USE `STUDENTS`;
-- STUDENTS-1
-- Find all students who study in classroom 111. For each student list first and last name. Sort the output by the last name of the student.
SELECT FirstName, LastName FROM list WHERE Classroom = 111 ORDER BY LastName;


USE `STUDENTS`;
-- STUDENTS-2
-- For each classroom report the grade that is taught in it. Report just the classroom number and the grade number. Sort output by classroom in descending order.
SELECT DISTINCT Classroom, Grade FROM list ORDER BY Classroom DESC;


USE `STUDENTS`;
-- STUDENTS-3
-- Find all teachers who teach fifth grade. Report first and last name of the teachers and the room number. Sort the output by room number.
SELECT DISTINCT First, Last, teachers.Classroom FROM teachers
    JOIN list ON teachers.Classroom = list.Classroom
    WHERE list.Grade = 5;


USE `STUDENTS`;
-- STUDENTS-4
-- Find all students taught by OTHA MOYER. Output first and last names of students sorted in alphabetical order by their last name.
SELECT DISTINCT FirstName, LastName FROM list
    JOIN teachers ON teachers.Classroom = list.Classroom
    WHERE teachers.First = 'OTHA' and teachers.Last = 'MOYER'
    ORDER BY LastName;


USE `STUDENTS`;
-- STUDENTS-5
-- For each teacher teaching grades K through 3, report the grade (s)he teaches. Each name has to be reported exactly once. Sort the output by grade and alphabetically by teacher’s last name for each grade.
SELECT DISTINCT First, Last, Grade FROM teachers
    JOIN list ON teachers.Classroom = list.Classroom
    where list.Grade >= 0 and list.Grade <= 3
    ORDER BY GRADE, Last;


USE `BAKERY`;
-- BAKERY-1
-- Find all chocolate-flavored items on the menu whose price is under $5.00. For each item output the flavor, the name (food type) of the item, and the price. Sort your output in descending order by price.
SELECT Flavor, Food, Price from goods
    WHERE Price < 5 and Flavor = 'Chocolate'
    ORDER BY Price DESC;


USE `BAKERY`;
-- BAKERY-2
-- Report the prices of the following items (a) any cookie priced above $1.10, (b) any lemon-flavored items, or (c) any apple-flavored item except for the pie. Output the flavor, the name (food type) and the price of each pastry. Sort the output in alphabetical order by the flavor and then pastry name.
SELECT Flavor, Food, Price FROM goods
WHERE (Food = 'cookie' and Price > 1.1) OR
    (Flavor = 'lemon') OR
    (Flavor = 'apple' and Food <> 'pie')
    ORDER BY Flavor, Food;


USE `BAKERY`;
-- BAKERY-3
-- Find all customers who made a purchase on October 3, 2007. Report the name of the customer (last, first). Sort the output in alphabetical order by the customer’s last name. Each customer name must appear at most once.
SELECT DISTINCT LastName, FirstName from customers
    JOIN receipts ON customers.CId = receipts.Customer
    WHERE receipts.SaleDate = '2007-10-03'
    ORDER BY LastName;


USE `BAKERY`;
-- BAKERY-4
-- Find all different cakes purchased on October 4, 2007. Each cake (flavor, food) is to be listed once. Sort output in alphabetical order by the cake flavor.
SELECT DISTINCT Flavor, Food FROM goods
JOIN items ON items.Item = goods.GId
JOIN receipts ON receipts.RNumber = items.Receipt
WHERE receipts.SaleDate = '2007-10-04' and Food = 'cake'
ORDER BY Flavor;


USE `BAKERY`;
-- BAKERY-5
-- List all pastries purchased by ARIANE CRUZEN on October 25, 2007. For each pastry, specify its flavor and type, as well as the price. Output the pastries in the order in which they appear on the receipt (each pastry needs to appear the number of times it was purchased).
SELECT Flavor, Food, Price FROM goods
JOIN items ON items.Item = goods.GId
JOIN receipts ON receipts.RNumber = items.Receipt
JOIN customers ON customers.CId = receipts.Customer
WHERE receipts.SaleDate = '2007-10-25' and 
customers.FirstName = "ARIANE" and customers.LastName = "Cruzen"
ORDER BY items.Ordinal;


USE `BAKERY`;
-- BAKERY-6
-- Find all types of cookies purchased by KIP ARNN during the month of October of 2007. Report each cookie type (flavor, food type) exactly once in alphabetical order by flavor.

SELECT DISTINCT Flavor, Food FROM goods
JOIN items ON items.Item = goods.GId
JOIN receipts ON receipts.RNumber = items.Receipt
JOIN customers ON customers.CId = receipts.Customer
WHERE receipts.SaleDate LIKE '2007-10-%' and
customers.FirstName = "KIP" and customers.LastName = "ARNN" and Food = 'cookie'
ORDER BY Flavor;


USE `CSU`;
-- CSU-1
-- Report all campuses from Los Angeles county. Output the full name of campus in alphabetical order.
SELECT Campus from campuses
WHERE County = 'Los Angeles'
ORDER BY Campus;


USE `CSU`;
-- CSU-2
-- For each year between 1994 and 2000 (inclusive) report the number of students who graduated from California Maritime Academy Output the year and the number of degrees granted. Sort output by year.
SELECT degrees.Year, Degrees from degrees
JOIN campuses ON campuses.Id = degrees.CampusId
WHERE degrees.Year >= 1994 and degrees.Year <= 2000 and campuses.Campus = 'California Maritime Academy'
ORDER BY degrees.Year;


USE `CSU`;
-- CSU-3
-- Report undergraduate and graduate enrollments (as two numbers) in ’Mathematics’, ’Engineering’ and ’Computer and Info. Sciences’ disciplines for both Polytechnic universities of the CSU system in 2004. Output the name of the campus, the discipline and the number of graduate and the number of undergraduate students enrolled. Sort output by campus name, and by discipline for each campus.
SELECT Campus, disciplines.Name, Gr, Ug FROM campuses
JOIN discEnr ON discEnr.CampusId = campuses.Id
JOIN disciplines ON disciplines.Id = discEnr.Discipline
WHERE (disciplines.Name = 'Mathematics' or disciplines.Name = 'Engineering' or disciplines.Name = 'Computer and Info. Sciences') and (Campus LIKE "%Poly%") and (discEnr.Year = 2004)
ORDER BY Campus, Discipline;


USE `CSU`;
-- CSU-4
-- Report graduate enrollments in 2004 in ’Agriculture’ and ’Biological Sciences’ for any university that offers graduate studies in both disciplines. Report one line per university (with the two grad. enrollment numbers in separate columns), sort universities in descending order by the number of ’Agriculture’ graduate students.
SELECT DISTINCT Campus, e1.Gr, e2.Gr FROM campuses

JOIN discEnr e1 ON e1.CampusId = campuses.Id
JOIN disciplines d1 ON d1.Id = e1.Discipline

JOIN discEnr e2 ON e2.CampusId = campuses.Id
JOIN disciplines d2 ON d2.Id = e2.Discipline

WHERE (d1.Name = 'Agriculture' and d2.Name = 'Biological Sciences') and (e1.Year = 2004 and e2.Year = 2004) and (e1.Gr > 0 and e2.Gr> 0)
ORDER BY e1.Gr DESC;


USE `CSU`;
-- CSU-5
-- Find all disciplines and campuses where graduate enrollment in 2004 was at least three times higher than undergraduate enrollment. Report campus names, discipline names, and both enrollment counts. Sort output by campus name, then by discipline name in alphabetical order.
SELECT Campus, disciplines.Name, Ug, Gr FROM campuses
JOIN discEnr ON discEnr.CampusId = campuses.Id
JOIN disciplines ON disciplines.Id = discEnr.Discipline
WHERE (discEnr.Year = 2004) and (Gr >= 3*Ug)
ORDER BY Campus, disciplines.Name;


USE `CSU`;
-- CSU-6
-- Report the amount of money collected from student fees (use the full-time equivalent enrollment for computations) at ’Fresno State University’ for each year between 2002 and 2004 inclusively, and the amount of money (rounded to the nearest penny) collected from student fees per each full-time equivalent faculty. Output the year, the two computed numbers sorted chronologically by year.
SELECT enrollments.Year,
enrollments.FTE * fees.fee,
ROUND((enrollments.FTE * fees.fee)/faculty.FTE,2)
FROM enrollments

JOIN campuses ON enrollments.CampusId = campuses.Id
JOIN fees ON fees.CampusId = campuses.Id and fees.Year = enrollments.Year
JOIN faculty ON faculty.CampusId = campuses.Id and faculty.Year = enrollments.Year

WHERE Campus = 'Fresno State University' and 
    (enrollments.Year >= 2002 and enrollments.Year <= 2004)
ORDER BY enrollments.Year;


USE `CSU`;
-- CSU-7
-- Find all campuses where enrollment in 2003 (use the FTE numbers), was higher than the 2003 enrollment in ’San Jose State University’. Report the name of campus, the 2003 enrollment number, the number of faculty teaching that year, and the student-to-faculty ratio, rounded to one decimal place. Sort output in ascending order by student-to-faculty ratio.
SELECT DISTINCT campuses.Campus, enrollments.FTE, faculty.FTE, ROUND(enrollments.FTE/faculty.FTE,1)
FROM enrollments
    JOIN campuses on campuses.Id = enrollments.CampusId 
    JOIN campuses SJSU
    JOIN enrollments e1 on
        e1.CampusId = SJSU.Id
        and e1.CampusId != campuses.Id
        and e1.FTE < enrollments.FTE
    JOIN faculty on campuses.Id = faculty.CampusId
        and faculty.year = enrollments.year
        and faculty.FTE > e1.FTE

WHERE SJSU.Campus = 'San Jose State University' and enrollments.Year = '2003'
ORDER BY enrollments.FTE/faculty.FTE;


USE `INN`;
-- INN-1
-- Find all modern rooms with a base price below $160 and two beds. Report room code and full room name, in alphabetical order by the code.
SELECT RoomCode, RoomName FROM rooms
WHERE decor = 'modern' and basePrice < 160 and beds = 2
ORDER BY RoomCode;


USE `INN`;
-- INN-2
-- Find all July 2010 reservations (a.k.a., all reservations that both start AND end during July 2010) for the ’Convoke and sanguine’ room. For each reservation report the last name of the person who reserved it, checkin and checkout dates, the total number of people staying and the daily rate. Output reservations in chronological order.
SELECT LastName, CheckIn, Checkout, Adults+Kids, Rate FROM reservations
JOIN rooms ON rooms.RoomCode = reservations.Room
WHERE CheckIn LIKE '2010-07-%' and Checkout LIKE '2010-07-%' and RoomName = 'Convoke and Sanguine'
ORDER BY CheckIn;


USE `INN`;
-- INN-3
-- Find all rooms occupied on February 6, 2010. Report full name of the room, the check-in and checkout dates of the reservation. Sort output in alphabetical order by room name.
SELECT RoomName, CheckIn, Checkout FROM rooms
JOIN reservations ON rooms.RoomCode = reservations.Room
WHERE CheckIn <='2010-02-06' and CheckOut > '2010-02-06'
ORDER BY RoomName;


USE `INN`;
-- INN-4
-- For each stay by GRANT KNERIEN in the hotel, calculate the total amount of money, he paid. Report reservation code, room name (full), checkin and checkout dates, and the total stay cost. Sort output in chronological order by the day of arrival.

SELECT Code, RoomName, CheckIn, Checkout,
Rate*DATEDIFF(Checkout, CheckIn) FROM rooms
JOIN reservations ON rooms.RoomCode = reservations.Room
WHERE LastName = 'KNERIEN' and FirstName = 'GRANT'
ORDER BY CheckIn;


USE `INN`;
-- INN-5
-- For each reservation that starts on December 31, 2010 report the room name, nightly rate, number of nights spent and the total amount of money paid. Sort output in descending order by the number of nights stayed.
SELECT RoomName, Rate, DATEDIFF(Checkout, CheckIn), Rate * DATEDIFF(Checkout, CheckIn) FROM rooms
JOIN reservations ON rooms.RoomCode = reservations.Room
WHERE CheckIn ='2010-12-31'
ORDER BY DATEDIFF(Checkout, CheckIn) DESC;


USE `INN`;
-- INN-6
-- Report all reservations in rooms with double beds that contained four adults. For each reservation report its code, the room abbreviation, full name of the room, check-in and check out dates. Report reservations in chronological order, then sorted by the three-letter room code (in alphabetical order) for any reservations that began on the same day.
SELECT Code, RoomCode, RoomName, CheckIn, Checkout FROM rooms
JOIN reservations ON rooms.RoomCode = reservations.Room
WHERE bedType = 'Double' and Adults = 4
ORDER BY CheckIn, RoomCode;


USE `MARATHON`;
-- MARATHON-1
-- Report the overall place, running time, and pace of TEDDY BRASEL.
SELECT Place, RunTime, Pace FROM marathon
WHERE FirstName = 'TEDDY' and LastName = "BRASEL";


USE `MARATHON`;
-- MARATHON-2
-- Report names (first, last), overall place, running time, as well as place within gender-age group for all female runners from QUNICY, MA. Sort output by overall place in the race.
SELECT FirstName, LastName, Place, RunTime, GroupPlace FROM marathon
WHERE Sex = 'F' and Town = 'QUNICY' and State = 'MA' 
ORDER BY Place;


USE `MARATHON`;
-- MARATHON-3
-- Find the results for all 34-year old female runners from Connecticut (CT). For each runner, output name (first, last), town and the running time. Sort by time.
SELECT FirstName, LastName, Town, RunTime FROM marathon
WHERE State = 'CT' and Sex = 'F' and Age = 34
ORDER BY RunTime;


USE `MARATHON`;
-- MARATHON-4
-- Find all duplicate bibs in the race. Report just the bib numbers. Sort in ascending order of the bib number. Each duplicate bib number must be reported exactly once.
SELECT BibNumber FROM marathon
GROUP BY BibNumber
HAVING COUNT(*) > 1
ORDER BY BibNumber;


USE `MARATHON`;
-- MARATHON-5
-- List all runners who took first place and second place in their respective age/gender groups. List gender, age group, name (first, last) and age for both the winner and the runner up (in a single row). Order the output by gender, then by age group.
SELECT a.Sex, a.AgeGroup, a.FirstName, a.LastName, a.Age,
    b.FirstName, b.LastName, b.Age FROM marathon a, marathon b
WHERE (a.GroupPlace = 1 and b.GroupPlace = 2) and (a.Sex = b.Sex) and (a.AgeGroup = b.AgeGroup)
ORDER BY a.GroupPlace, a.Sex, a.AgeGroup;


USE `AIRLINES`;
-- AIRLINES-1
-- Find all airlines that have at least one flight out of AXX airport. Report the full name and the abbreviation of each airline. Report each name only once. Sort the airlines in alphabetical order.
SELECT DISTINCT Name, Abbr from airlines
JOIN flights ON airlines.Id = flights.Airline
WHERE Source = 'AXX'
ORDER BY Name;


USE `AIRLINES`;
-- AIRLINES-2
-- Find all destinations served from the AXX airport by Northwest. Re- port flight number, airport code and the full name of the airport. Sort in ascending order by flight number.

SELECT DISTINCT FlightNo, Code, airports.Name from airlines
JOIN flights ON airlines.Id = flights.Airline
JOIN airports ON airports.code = Destination
WHERE Source = 'AXX' and airlines.Name = 'Northwest Airlines'
ORDER BY FlightNo ASC;


USE `AIRLINES`;
-- AIRLINES-3
-- Find all *other* destinations that are accessible from AXX on only Northwest flights with exactly one change-over. Report pairs of flight numbers, airport codes for the final destinations, and full names of the airports sorted in alphabetical order by the airport code.
SELECT DISTINCT f1.FlightNo, f2.FlightNo, a1.Code, a1.Name from airlines

JOIN flights f1 ON airlines.Id = f1.Airline
JOIN airports a1 ON a1.code = f1.Destination

JOIN flights f2 ON airlines.Id = f2.Airline
JOIN airports a2 ON a1.code = f2.Destination

WHERE f2.Source = 'AXX' and airlines.Name = 'Northwest Airlines'

ORDER BY a1.Code;


USE `AIRLINES`;
-- AIRLINES-4
-- Report all pairs of airports served by both Frontier and JetBlue. Each airport pair must be reported exactly once (if a pair X,Y is reported, then a pair Y,X is redundant and should not be reported).
SELECT DISTINCT air1.Destination, air1.Source FROM

(SELECT DISTINCT Source,Destination FROM flights
JOIN airlines ON Airline = ID
WHERE airlines.Name = 'Frontier Airlines') air1

JOIN

(SELECT DISTINCT Source,Destination FROM flights
JOIN airlines ON Airline = ID
WHERE airlines.Name = 'JetBlue Airways') air2

ON air1.Destination = air2.Destination and air1.Source = air2.Source and air1.Destination < air1.Source;


USE `AIRLINES`;
-- AIRLINES-5
-- Find all airports served by ALL five of the airlines listed below: Delta, Frontier, USAir, UAL and Southwest. Report just the airport codes, sorted in alphabetical order.
SELECT DISTINCT air1.Source  from

(SELECT DISTINCT Source FROM flights
JOIN airlines ON Airline = ID
WHERE airlines.Name = 'Frontier Airlines') air1

JOIN

(SELECT DISTINCT Source FROM flights
JOIN airlines ON Airline = ID
WHERE airlines.Name = 'Southwest Airlines') air2
ON air1.Source = air2.Source

JOIN

(SELECT DISTINCT Source FROM flights
JOIN airlines ON Airline = ID
WHERE airlines.Name = 'US Airways') air3
ON air2.Source = air3.Source

JOIN

(SELECT DISTINCT Source FROM flights
JOIN airlines ON Airline = ID
WHERE airlines.Name = 'Delta Airlines') air4
ON air3.Source = air4.Source

JOIN

(SELECT DISTINCT Source FROM flights
JOIN airlines ON Airline = ID
WHERE airlines.Name = 'United Airlines') air5
ON air4.Source = air5.Source
ORDER BY air1.Source;


USE `AIRLINES`;
-- AIRLINES-6
-- Find all airports that are served by at least three Southwest flights. Report just the three-letter codes of the airports — each code exactly once, in alphabetical order.
SELECT Destination FROM flights 
JOIN airlines ON flights.Airline = airlines.ID
WHERE airlines.Name = 'Southwest Airlines'
GROUP BY Destination
HAVING COUNT(Destination) >= 3
ORDER BY Destination;


USE `KATZENJAMMER`;
-- KATZENJAMMER-1
-- Report, in order, the tracklist for ’Le Pop’. Output just the names of the songs in the order in which they occur on the album.
SELECT Songs.Title from Songs
JOIN Tracklists ON Tracklists.Song = Songs.SongId
JOIN Albums ON Albums.Aid = Tracklists.Album
WHERE Albums.Title = "Le Pop"
ORDER BY Position;


USE `KATZENJAMMER`;
-- KATZENJAMMER-2
-- List the instruments each performer plays on ’Mother Superior’. Output the first name of each performer and the instrument, sort alphabetically by the first name.
SELECT DISTINCT FirstName, Instrument FROM Instruments
JOIN Band ON Band.Id = Instruments.Bandmate
JOIN Performance ON Band.Id = Performance.Bandmate
JOIN Songs ON Songs.SongId = Performance.Song and Instruments.Song = Songs.SongId
WHERE Songs.Title = "Mother Superior"
ORDER BY FirstName, Instrument;


USE `KATZENJAMMER`;
-- KATZENJAMMER-3
-- List all instruments played by Anne-Marit at least once during the performances. Report the instruments in alphabetical order (each instrument needs to be reported exactly once).
SELECT DISTINCT Instrument from Instruments
JOIN Band ON Band.Id = Instruments.Bandmate
JOIN Performance ON Band.Id = Performance.Bandmate
JOIN Songs ON Songs.SongId = Performance.Song
WHERE FirstName = "Anne-Marit"
ORDER BY Instrument;


USE `KATZENJAMMER`;
-- KATZENJAMMER-4
-- Find all songs that featured ukalele playing (by any of the performers). Report song titles in alphabetical order.
SELECT DISTINCT Songs.Title from Songs
JOIN Performance ON Songs.SongId = Performance.Song
JOIN Band ON Band.Id = Performance.Bandmate
JOIN Instruments ON Band.Id = Instruments.Bandmate and Instruments.Song = Songs.SongId
WHERE Instrument = 'Ukalele'
ORDER BY Songs.Title;


USE `KATZENJAMMER`;
-- KATZENJAMMER-5
-- Find all instruments Turid ever played on the songs where she sang lead vocals. Report the names of instruments in alphabetical order (each instrument needs to be reported exactly once).
SELECT DISTINCT Instrument from Instruments
JOIN Band ON Band.Id = Instruments.Bandmate
JOIN Performance ON Band.Id = Performance.Bandmate
JOIN Songs ON Songs.SongId = Performance.Song and Instruments.Song = Songs.SongId
JOIN Vocals ON Songs.SongId = Vocals.Song and Vocals.Bandmate = Band.Id
WHERE FirstName = 'Turid' and Vocals.VocalType = 'Lead'
ORDER BY Instrument;


USE `KATZENJAMMER`;
-- KATZENJAMMER-6
-- Find all songs where the lead vocalist is not positioned center stage. For each song, report the name, the name of the lead vocalist (first name) and her position on the stage. Output results in alphabetical order by the song, then name of band member. (Note: if a song had more than one lead vocalist, you may see multiple rows returned for that song. This is the expected behavior).
SELECT DISTINCT Songs.Title, Band.FirstName, StagePosition from Songs
JOIN Performance ON Songs.SongId = Performance.Song
JOIN Band ON Band.Id = Performance.Bandmate
JOIN Instruments ON Band.Id = Instruments.Bandmate
JOIN Vocals ON Songs.SongId = Vocals.Song and Vocals.Bandmate = Band.Id
WHERE Vocals.VocalType = 'lead' and StagePosition <> 'center'
ORDER BY Songs.Title, FirstName;


USE `KATZENJAMMER`;
-- KATZENJAMMER-7
-- Find a song on which Anne-Marit played three different instruments. Report the name of the song. (The name of the song shall be reported exactly once)
SELECT DISTINCT Songs.Title from Songs

JOIN Performance p1 ON Songs.SongId = p1.Song 
JOIN Band b1 ON b1.Id = p1.Bandmate
JOIN Instruments i1 ON b1.Id = i1.Bandmate and i1.Song = Songs.SongId

JOIN Performance p2 ON Songs.SongId = p2.Song
JOIN Band b2 ON b2.Id = p2.Bandmate
JOIN Instruments i2 ON b2.Id = i2.Bandmate and i2.Song = Songs.SongId

JOIN Performance p3 ON Songs.SongId = p3.Song
JOIN Band b3 ON b3.Id = p3.Bandmate
JOIN Instruments i3 ON b3.Id = i3.Bandmate and i3.Song = Songs.SongId

WHERE (i1.Instrument <> i2.Instrument and
    i2.Instrument <> i3.Instrument and
    i1.Instrument <> i3.Instrument) and
    (b1.FirstName = b2.FirstName and
    b2.FirstName = b3.FirstName and
    b3.FirstName = "Anne-Marit");


USE `KATZENJAMMER`;
-- KATZENJAMMER-8
-- Report the positioning of the band during ’A Bar In Amsterdam’. (just one record needs to be returned with four columns (right, center, back, left) containing the first names of the performers who were staged at the specific positions during the song).
select r.FirstName, center.FirstName, back.FirstName, l.FirstName AS 'LEFT' FROM
(
    (SELECT * FROM Songs 
    JOIN Performance ON Song = SongId
    JOIN Band ON Id = Bandmate
    WHERE StagePosition = 'right' and Title = 'A Bar in Amsterdam') r

    JOIN

    (SELECT * FROM Songs 
    JOIN Performance ON Song = SongId
    JOIN Band ON Id = Bandmate
    WHERE StagePosition = 'left' and Title = 'A Bar in Amsterdam') l

    JOIN

    (SELECT * FROM Songs 
    JOIN Performance ON Song = SongId
    JOIN Band ON Id = Bandmate
    WHERE StagePosition = 'center' and Title = 'A Bar in Amsterdam') center

    JOIN

    (SELECT * FROM Songs 
    JOIN Performance ON Song = SongId
    JOIN Band ON Id = Bandmate
    WHERE StagePosition = 'back' and Title = 'A Bar in Amsterdam') back
);


