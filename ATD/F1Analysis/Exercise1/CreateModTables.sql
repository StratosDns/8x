DROP TABLE IF EXISTS NJ CASCADE;
DROP TABLE IF EXISTS DRIVER_STANDINGS_MODIFIED;
DROP TABLE IF EXISTS RACES_MODIFIED;
DROP TABLE IF EXISTS CIRCUITS_MODIFIED;
DROP TABLE IF EXISTS DRIVER_STANDINGS CASCADE;
DROP TABLE IF EXISTS RACES CASCADE;
DROP TABLE IF EXISTS CIRCUITS CASCADE;

CREATE TABLE CIRCUITS (
    circuitId INT NOT NULL,
    circuitRef TEXT NOT NULL,
    circuit_name TEXT NOT NULL,
    circuit_location TEXT NOT NULL,
    circuit_country TEXT NOT NULL,
    lat REAL,
    lng REAL,
    alt REAL,
    RaceURL TEXT,
    PRIMARY KEY (circuitId));

COPY CIRCUITS FROM 'C:\uni\8x\ATD\F1Analysis\Exercise1\circuits.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE RACES (
    raceId INT NOT NULL,
    year TEXT,
    round INT,
    circuitId INT NOT NULL,
    race_name TEXT NOT NULL,
    race_date TEXT,
    race_time TEXT,
    rurl TEXT,
    fp1_date TEXT,
    fp1_time TEXT,
    fp2_date TEXT,
    fp2_time TEXT,
    fp3_date TEXT,
    fp3_time TEXT,
    quali_date TEXT,
    quali_time TEXT,
    sprint_date TEXT,
    sprint_time TEXT,  
    FOREIGN KEY (circuitId) REFERENCES CIRCUITS(circuitId),
    PRIMARY KEY (raceId));

COPY RACES FROM 'C:\uni\8x\ATD\F1Analysis\Exercise1\races.csv' DELIMITER ',' CSV HEADER;



CREATE TABLE DRIVER_STANDINGS (
    driverStandingsId INT NOT NULL,
    raceId INT NOT NULL,
    driverId INT NOT NULL,
    points REAL,
    position INT,
    positionText TEXT,
    wins INT,
    FOREIGN KEY (raceId) REFERENCES RACES (raceId),
    PRIMARY KEY (driverStandingsId));

COPY DRIVER_STANDINGS FROM 'C:\uni\8x\ATD\F1Analysis\Exercise1\driver_standings.csv' DELIMITER ',' CSV HEADER;



CREATE TABLE DRIVER_STANDINGS_MODIFIED AS 
SELECT raceId, driverId, points FROM DRIVER_STANDINGS;

CREATE TABLE RACES_MODIFIED AS 
SELECT raceId, year FROM RACES;

CREATE TABLE CIRCUITS_MODIFIED AS 
SELECT circuitId, alt FROM CIRCUITS;

COPY CIRCUITS_MODIFIED TO 'C:\uni\8x\ATD\F1Analysis\Exercise1\circuits_modified.csv' DELIMITER ',' CSV HEADER;

COPY RACES_MODIFIED TO 'C:\uni\8x\ATD\F1Analysis\Exercise1\races_modified.csv' DELIMITER ',' CSV HEADER;

COPY DRIVER_STANDINGS_MODIFIED TO 'C:\uni\8x\ATD\F1Analysis\Exercise1\driver_standings_modified.csv' DELIMITER ',' CSV HEADER;




