DROP TABLE IF EXISTS Vocals;
DROP TABLE IF EXISTS Tracklists;
DROP TABLE IF EXISTS Performance;
DROP TABLE IF EXISTS Instruments;
DROP TABLE IF EXISTS Band;
DROP TABLE IF EXISTS Albums;
DROP TABLE IF EXISTS Songs;

CREATE TABLE Songs(
    SongId INTEGER PRIMARY KEY,
    Title VARCHAR(100)
);

CREATE TABLE Albums(
    AId INTEGER PRIMARY KEY,
    Title VARCHAR(100),
    Year CHAR(4),
    Label VARCHAR(100),
    `Type` VARCHAR(100)
);

CREATE TABLE Band(
    Id INTEGER PRIMARY KEY,
    Firstname VARCHAR(100),
    Lastname VARCHAR(100)
);

CREATE TABLE Instruments(
    SongId INTEGER,
    BandmateId INTEGER,
    Instrument VARCHAR(100),
    UNIQUE(SongId, BandmateId, Instrument),
    FOREIGN KEY (SongId) REFERENCES Songs(SongId),
    FOREIGN KEY (BandmateId) REFERENCES Band(Id)
);

CREATE TABLE Performance(
    SongId INTEGER,
    Bandmate INTEGER,
    StagePosition VARCHAR(100),
    CONSTRAINT SongBand PRIMARY KEY (SongId, Bandmate),
    FOREIGN KEY (SongId) REFERENCES Songs (SongId)
);

CREATE TABLE Tracklists(
    AlbumId INTEGER,
    Position INTEGER,
    SongId INTEGER
);

CREATE TABLE Vocals(
    SongId INTEGER,
    Bandmate INTEGER,
    Type VARCHAR(20)
);