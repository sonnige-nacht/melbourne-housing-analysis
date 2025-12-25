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
    WHEN address LIKE '% %'
    THEN SUBSTRING(clean_data_melb_data.Address, LOCATE(' ', clean_data_melb_data.Address) + 1)
    ELSE address
END;

# Clean Type: complete the data (Example: 'h' → 'House' or 'u' → 'unit')
UPDATE clean_data_melb_data
SET clean_data_melb_data.`Type` = REPLACE(clean_data_melb_data.`Type`, 'h', 'House')
WHERE clean_data_melb_data.`Type` LIKE 'h';

UPDATE clean_data_melb_data
SET clean_data_melb_data.`Type` = REPLACE(clean_data_melb_data.`Type`, 'u', 'Unit')
WHERE clean_data_melb_data.`Type` LIKE 'u';

UPDATE clean_data_melb_data
SET clean_data_melb_data.`Type` = REPLACE(clean_data_melb_data.`Type`, 't', 'Townhouse')
WHERE clean_data_melb_data.`Type` LIKE 't';

UPDATE clean_data_melb_data
SET clean_data_melb_data.`Type` = REPLACE(clean_data_melb_data.`Type`, 'res', 'Others')
WHERE clean_data_melb_data.`Type` LIKE 'res';