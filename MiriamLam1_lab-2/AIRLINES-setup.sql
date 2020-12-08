DROP TABLE IF EXISTS flights;
DROP TABLE IF EXISTS airports;
DROP TABLE IF EXISTS airlines;

CREATE TABLE airlines(
    Id INTEGER PRIMARY KEY NOT NULL,
    Airline VARCHAR(100) NOT NULL,
    Abbreviation VARCHAR(30) NOT NULL,
    Country VARCHAR(30) NOT NULL,
    UNIQUE(Airline),
    UNIQUE(Abbreviation)
);

CREATE TABLE airports(
    City VARCHAR(30) NOT NULL,
    AirportCode CHAR(3) PRIMARY KEY NOT NULL,
    AirportName VARCHAR(100) NOT NULL,
    Country VARCHAR(30) NOT NULL,
    CountryAbbrev VARCHAR(3) NOT NULL 
);

CREATE TABLE flights(
    Airline INTEGER NOT NULL,
    FlightNo VARCHAR(10) NOT NULL,
    SourceAirport CHAR(3) NOT NULL,
    DestAirport CHAR(3) NOT NULL,
    CONSTRAINT FlightAir PRIMARY KEY (FlightNo,Airline),
    FOREIGN KEY (Airline) REFERENCES airlines(Id),
    FOREIGN KEY (SourceAirport) REFERENCES airports(AirportCode),
    FOREIGN KEY (DestAirport) REFERENCES airports(AirportCode)
);