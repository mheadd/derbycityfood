-- Create the derbycityfood database.
DROP DATABASE IF EXISTS derbycityfood;
CREATE DATABASE derbycityfood;

-- Create the inspections table.
USE derbycityfood;
DROP TABLE IF EXISTS inspections;
CREATE TABLE inspections (
  EstablishmentID INT(5),
  InspectionID INT(6),
  EstablishmentName VARCHAR(85),
  PlaceName VARCHAR(85),
  Address VARCHAR(150),
  Address2 VARCHAR(150),
  City VARCHAR(85),
  State CHAR(2),
  Zip INT(5),
  TypeDescription VARCHAR(85),
  Latitude DOUBLE,
  Longitude DOUBLE,
  InspectionDate VARCHAR(30), 
  Score INT(3),
  Grade CHAR(1),
  NameSearch VARCHAR(85),
  Intersection VARCHAR(85)
);

-- Load the inspections data into the new table.
LOAD DATA INFILE '/tmp/FoodServiceData.txt' INTO TABLE inspections
  	FIELDS TERMINATED BY '\t'
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES
	(EstablishmentID,InspectionID,EstablishmentName,PlaceName,Address,Address2,City,State,Zip,TypeDescription,Latitude,Longitude,InspectionDate,Score,Grade,NameSearch,Intersection);
	
-- May want to grant some privlidges here for a user of the new table.

