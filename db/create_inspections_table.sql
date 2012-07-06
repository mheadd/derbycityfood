-- Create the derbycityfood database.
DROP DATABASE IF EXISTS derbycityfood;
CREATE DATABASE derbycityfood;

-- Create the inspections table.
USE derbycityfood;
DROP TABLE IF EXISTS inspections;
CREATE TABLE inspections (
  Est_Name VARCHAR(85),
  Est_Addr2 VARCHAR(150),
  Est_City VARCHAR(25),	
  Est_St	CHAR(2),
  Est_Zip	 CHAR(5),
  Latitude DOUBLE,
  Longitude DOUBLE,	
  Date_Insp VARCHAR(30),
  Score INT(3),
  Grade CHAR(1)
);

-- Load the inspections data into the new table.
LOAD DATA INFILE '/tmp/FoodServiceInspection.txt' INTO TABLE inspections
  	FIELDS TERMINATED BY '\t'
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES
	(Est_Name, Est_Addr2, Est_City, Est_St, Est_Zip, Latitude, Longitude, Date_Insp, Score, Grade);
	
-- May want to grant some privlidges here for a user of the new table.
