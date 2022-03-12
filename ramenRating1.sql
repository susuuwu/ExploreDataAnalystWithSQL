
SELECT name FROM sys.columns WHERE object_id= OBJECT_ID('ramenRatings')

/* try to get the best ramen of each country
*/
SELECT Max(Stars) as Stars, Country, Brand FROM PortfolioProject..ramenRatings
GROUP BY Country, Brand
ORDER BY Country ASC, Brand ASC

/*there are multiple brands in the same country that receive the maximum star. 
To get a smaller data set, get only the 5 star brands that has number in its name of every country
*/
SELECT Max(Stars) as Star_Max, Variety, Brand, Country FROM PortfolioProject..ramenRatings
WHERE Brand LIKE '%[0,1,2,3,4,5,6,7,9]%'
GROUP BY Brand, Country, Variety
ORDER BY Star_Max DESC

SELECT DISTINCT Style FROM PortfolioProject..ramenRatings;

With nonNullRamenRatings ( Brand, Variety, Style, Country, Stars)
as
( SELECT Brand, Variety, Style, Country, Stars FROM PortfolioProject..ramenRatings
WHERE Style IS NOT NULL
)
SELECT Top 3 * FROM nonNullRamenRatings
ORDER BY Stars DESC, Country ASC

--a temporary table of country and the count of ramen brands it has
--CREATE TABLE CountryRamenBrand (Country nvarchar(255), NumberOfBrand numeric)

--commenting out after creating the table

INSERT INTO CountryRamenBrand
SELECT Country, COUNT(Brand) FROM PortfolioProject..ramenRatings
GROUP BY Country


--get the top 5 of country with the most ramen brand. Japan is #1, not a surprise at all!
SELECT DISTINCT TOP (5) * FROM CountryRamenBrand 
ORDER BY NumberOfBrand DESC

--there's duplication so we have to delete them

DELETE T FROM
(SELECT *, duplicate = ROW_NUMBER() OVER (PARTITION BY Country, NumberOfBrand ORDER BY (NumberOfBrand)) FROM CountryRamenBrand)
AS T
WHERE duplicate >1

--try get top 5 again without DISTINCT keyword
SELECT TOP (5) * FROM CountryRamenBrand 
ORDER BY NumberOfBrand DESC


