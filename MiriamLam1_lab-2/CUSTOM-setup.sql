DROP TABLE IF EXISTS Survived;
DROP TABLE IF EXISTS Passenger;
DROP TABLE IF EXISTS Tickets;

CREATE TABLE Tickets(
    TicketNo VARCHAR(30),
    Fare FLOAT
);

CREATE TABLE Passenger(
    PassengerId INTEGER PRIMARY KEY NOT NULL,
    LName VARCHAR(100) NOT NULL,
    FName VARCHAR(100) NOT NULL,
    Sex VARCHAR(100),
    Age INTEGER,
    TicketNo VARCHAR(30),
    UNIQUE(Lname,FName)
);

CREATE TABLE Survived(
    PassengerId INTEGER NOT NULL,
    Survived INTEGER NOT NULL
);