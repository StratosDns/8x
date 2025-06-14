DROP TABLE IF EXISTS NJ CASCADE;
DROP TABLE IF EXISTS DRIVER_STANDINGS_MODIFIED;
DROP TABLE IF EXISTS RACES_MODIFIED;
DROP TABLE IF EXISTS CIRCUITS_MODIFIED;
DROP TABLE IF EXISTS DRIVER_STANDINGS CASCADE;
DROP TABLE IF EXISTS RACES CASCADE;
DROP TABLE IF EXISTS CIRCUITS CASCADE;

CREATE TABLE CIRCUITS(
circuitId INT NOT NULL,
alt INT NOT NULL,
PRIMARY KEY(circuitId));

COPY CIRCUITS FROM 'C:\uni\8x\ATD\F1Analysis\Exercise1\circuits_modified.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE RACES (
raceId INT NOT NULL,
year INT NOT NULL,
PRIMARY KEY (raceId));

COPY RACES FROM 'C:\uni\8x\ATD\F1Analysis\Exercise1\races_modified.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE DRIVER_STANDINGS (
raceId INT NOT NULL,
driverId INT NOT NULL,
points REAL NOT NULL,
FOREIGN KEY (raceId) REFERENCES RACES (raceId),
PRIMARY KEY(driverId,raceId));

COPY DRIVER_STANDINGS FROM 'C:\uni\8x\ATD\F1Analysis\Exercise1\driver_standings_modified.csv' DELIMITER ',' CSV HEADER;

COPY (
    SELECT * FROM CIRCUITS NATURAL JOIN RACES NATURAL JOIN DRIVER_STANDINGS
) TO 'C:\uni\8x\ATD\F1Analysis\Exercise1\NATURALJOINTABLE.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE NJ AS(
SELECT * FROM CIRCUITS NATURAL JOIN RACES NATURAL JOIN DRIVER_STANDINGS
);

SELECT * FROM NJ;