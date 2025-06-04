DROP TABLE IF EXISTS tcase CASCADE;
DROP TABLE IF EXISTS Driver_Standings CASCADE;
DROP TABLE IF EXISTS RACES CASCADE;


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
    PRIMARY KEY (raceId));

COPY RACES FROM 'C:\uni\8x\ATD\archive\races.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE Driver_Standings (
    driverStandingsId INT NOT NULL,
    raceId INT NOT NULL,
    driverId INT NOT NULL,
    points REAL,
    position INT,
    positionText TEXT,
    wins INT,
    FOREIGN KEY (raceId) REFERENCES RACES (raceId),
    PRIMARY KEY (driverStandingsId));

COPY Driver_Standings FROM 'C:\uni\8x\ATD\archive\driver_standings.csv' DELIMITER ',' CSV HEADER;




SELECT ds.driverId, ds.points, ds.raceId, r.year
FROM Driver_Standings ds
JOIN RACES r ON ds.raceId = r.raceId
ORDER BY ds.points DESC;


/*
CREATE TABLE UNIVERSALV2 AS 
SELECT driverStandingsId, raceId, driverId, points FROM Driver_Standings;

COPY UNIVERSALV2 TO 'C:\uni\8x\ATD\archive\UNIVERSALV2.csv' DELIMITER ',' CSV HEADER;

*/
