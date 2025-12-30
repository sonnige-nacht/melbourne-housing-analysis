# Show raw data 
SELECT *
FROM first_project.melb_data;

# Create a new table from melb_data and Do the rest of analysis on this table
CREATE TABLE clean_data_melb_data AS
SELECT DISTINCT *
FROM melb_data;

# Show clean_data_melb_data
SELECT *
FROM clean_data_melb_data;




# ************************************************************************************************************ #




# To findout: is there any duplicated record?
SELECT Suburb, Address, Rooms, `Type`, Price, Method,SellerG,`Date`,Distance, Postcode, Bedroom2,Bathroom, Car,Landsize, BuildingArea, YearBuilt, CouncilArea, Lattitude, Longtitude, Regionname, Propertycount, COUNT(*) AS CNT
FROM clean_data_melb_data
GROUP BY Suburb, Address, Rooms, `Type`, Price, Method,SellerG,`Date`,Distance, Postcode, Bedroom2,Bathroom, Car,Landsize, BuildingArea, YearBuilt, CouncilArea, Lattitude, Longtitude, Regionname, Propertycount
HAVING CNT > 1;
# Result = Negative

# Clean Address: the numbers have to be removed. (Example: '123/56 Nicholson St' → 'Nicholson St')
UPDATE clean_data_melb_data
SET clean_data_melb_data.Address = CASE
    WHEN Address LIKE '% %'
    THEN SUBSTRING(Address, LOCATE(' ', Address) + 1)
    END;

# Clean Type: complete the data (Example: 'h' → 'House' or 'u' → 'unit')
UPDATE clean_data_melb_data
SET `Type` = REPLACE(`Type`, 'h', 'House')
	WHERE `Type` LIKE 'h';

UPDATE clean_data_melb_data
SET `Type` = REPLACE(`Type`, 'u', 'Unit')
WHERE `Type` LIKE 'u';

UPDATE clean_data_melb_data
SET `Type` = REPLACE(`Type`, 't', 'Townhouse')
WHERE `Type` LIKE 't';

UPDATE clean_data_melb_data
SET `Type` = REPLACE(`Type`, 'res', 'Others')
WHERE `Type` LIKE 'res';

# Drop some columns, which are not really important for analysis
ALTER TABLE clean_data_melb_data
DROP COLUMN Lattitude;

ALTER TABLE clean_data_melb_data
DROP COLUMN Longtitude;

# standardize the 'Date' cloumn
UPDATE clean_data_melb_data
SET `Date` = STR_TO_DATE(`date`, '%d/%m/%Y');
ALTER TABLE clean_data_melb_data
MODIFY COLUMN `Date` DATE;

# covert the records to NULL, where BuildingArea or YearBuilt are an empty string
UPDATE clean_data_melb_data
SET BuildingArea = NULL
WHERE BuildingArea = '';
UPDATE clean_data_melb_data
SET YearBuilt = NULL
WHERE YearBuilt = '';

# standardize the 'BuildingArea' and 'YearBuilt' cloumn
ALTER TABLE clean_data_melb_data
MODIFY COLUMN BuildingArea INT;
ALTER TABLE clean_data_melb_data
MODIFY COLUMN YearBuilt INT;