-- 1. Count the number of athletes from each country
SELECT *, COUNT(*) AS TotalAthletes
FROM athletes
GROUP BY Country
ORDER BY TotalAthletes DESC;

-- 2. Countries with the most diverse medal wins (across disciplines)
SELECT TeamCountry, COUNT(DISTINCT Discipline) AS UniqueDisciplines
FROM medals
GROUP BY TeamCountry
ORDER BY UniqueDisciplines DESC;

-- 3. Athletes who participated in the most disciplines
SELECT PersonName, Country, COUNT(DISTINCT Discipline) AS NumDisciplines
FROM athletes
GROUP BY PersonName, Country
ORDER BY NumDisciplines DESC
LIMIT 10;

-- 4. Rank countries by total medals
SELECT *, RANK() OVER (ORDER BY Total DESC) AS CountryRank
FROM (
    SELECT TeamCountry, SUM(Gold + Silver + Bronze) AS Total
    FROM medals
    GROUP BY TeamCountry
) AS MedalSummary;

-- 5. Compare male vs female participation by discipline
SELECT Discipline,
       SUM(Female) AS TotalFemale,
       SUM(Male) AS TotalMale,
       ROUND(SUM(Female)*1.0 / NULLIF(SUM(Female + Male), 0), 2) AS FemaleRatio
FROM entriesgender
GROUP BY Discipline
ORDER BY FemaleRatio DESC;

-- 6. Disciplines where a country earned more than 5 gold medals
SELECT TeamCountry, Discipline, SUM(Gold) AS GoldMedals
FROM medals
GROUP BY TeamCountry, Discipline
HAVING SUM(Gold) > 5
ORDER BY GoldMedals DESC;

-- 7. Top 3 countries per discipline by total medals
WITH MedalCounts AS (
  SELECT TeamCountry, Discipline, SUM(Gold + Silver + Bronze) AS TotalMedals
  FROM medals
  GROUP BY TeamCountry, Discipline
),
Ranked AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY Discipline ORDER BY TotalMedals DESC) AS rank
  FROM MedalCounts
)
SELECT * FROM Ranked WHERE rank <= 3;

-- 8. Countries with highest gold medal to total medal ratio
SELECT TeamCountry,
       SUM(Gold) AS TotalGold,
       SUM(Gold + Silver + Bronze) AS TotalMedals,
       ROUND(SUM(Gold)*1.0 / NULLIF(SUM(Gold + Silver + Bronze), 0), 2) AS GoldRatio
FROM medals
GROUP BY TeamCountry
ORDER BY GoldRatio DESC
LIMIT 10;

-- 9. Athletes with same name in multiple countries
SELECT PersonName, COUNT(DISTINCT Country) AS CountryCount
FROM athletes
GROUP BY PersonName
HAVING COUNT(DISTINCT Country) > 1;

-- 10. Disciplines with largest gender gap
SELECT Discipline,
       SUM(Female) AS TotalFemale,
       SUM(Male) AS TotalMale,
       ABS(SUM(Female) - SUM(Male)) AS GenderGap
FROM entriesgender
GROUP BY Discipline
ORDER BY GenderGap DESC
LIMIT 10;

-- 11. Countries that earned medals in the most disciplines
SELECT TeamCountry, COUNT(DISTINCT Discipline) AS DisciplinesWithMedals
FROM medals
GROUP BY TeamCountry
ORDER BY DisciplinesWithMedals DESC;

-- 12. Discipline with highest total medal count
SELECT Discipline, SUM(Gold + Silver + Bronze) AS TotalMedals
FROM medals
GROUP BY Discipline
ORDER BY TotalMedals DESC;

-- 13. Top 5 countries with most athletes in one discipline
SELECT Country, Discipline, COUNT(*) AS AthleteCount
FROM athletes
GROUP BY Country, Discipline
ORDER BY AthleteCount DESC
LIMIT 5;

-- 14. Disciplines each country participated in
SELECT Country, COUNT(DISTINCT Discipline) AS DisciplinesParticipated
FROM athletes
GROUP BY Country
ORDER BY DisciplinesParticipated DESC;

-- 15. Most balanced medal counts (low diff between medal types)
SELECT TeamCountry, Discipline, 
       MAX(Gold) - MIN(Gold) AS DiffGold,
       MAX(Silver) - MIN(Silver) AS DiffSilver,
       MAX(Bronze) - MIN(Bronze) AS DiffBronze
FROM medals
GROUP BY TeamCountry, Discipline
ORDER BY (DiffGold + DiffSilver + DiffBronze) ASC
LIMIT 10;

-- 16. Countries that won all 3 medal types
SELECT TeamCountry
FROM medals
GROUP BY TeamCountry
HAVING SUM(Gold) > 0 AND SUM(Silver) > 0 AND SUM(Bronze) > 0
ORDER BY TeamCountry;

-- 17. Most represented disciplines in the Olympics
SELECT Discipline, COUNT(*) AS AthleteCount
FROM athletes
GROUP BY Discipline
ORDER BY AthleteCount DESC;

-- 18. Countries with the highest % of female athletes
SELECT Country,
       COUNT(*) AS TotalAthletes,
       SUM(CASE WHEN Gender = 'F' THEN 1 ELSE 0 END)*1.0 / COUNT(*) AS FemalePercentage
FROM athletes
GROUP BY Country
ORDER BY FemalePercentage DESC;

-- 19. Athletes with medals in more than one discipline
SELECT PersonName, COUNT(DISTINCT Discipline) AS MedalDisciplines
FROM medals
GROUP BY PersonName
HAVING COUNT(DISTINCT Discipline) > 1;

-- 20. Disciplines where one country dominated medals
WITH DiscCountry AS (
    SELECT Discipline, TeamCountry, SUM(Gold + Silver + Bronze) AS TotalMedals
    FROM medals
    GROUP BY Discipline, TeamCountry
),
Ranked AS (
    SELECT *, RANK() OVER (PARTITION BY Discipline ORDER BY TotalMedals DESC) AS rnk
    FROM DiscCountry
)
SELECT * FROM Ranked WHERE rnk = 1;

-- 21. Top 5 most successful athletes (by total medals)
SELECT PersonName, SUM(Gold + Silver + Bronze) AS TotalMedals
FROM medals
GROUP BY PersonName
ORDER BY TotalMedals DESC
LIMIT 5;

-- 22. Most common discipline per country
WITH DiscCounts AS (
  SELECT Country, Discipline, COUNT(*) AS Count
  FROM athletes
  GROUP BY Country, Discipline
),
Ranked AS (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY Country ORDER BY Count DESC) AS rnk
  FROM DiscCounts
)
SELECT * FROM Ranked WHERE rnk = 1;

-- 23. Number of unique athletes per team
SELECT TeamName, COUNT(DISTINCT PersonName) AS UniqueAthletes
FROM teams
GROUP BY TeamName
ORDER BY UniqueAthletes DESC;

-- 24. Countries that only won bronze medals
SELECT TeamCountry
FROM medals
GROUP BY TeamCountry
HAVING SUM(Gold) = 0 AND SUM(Silver) = 0 AND SUM(Bronze) > 0;

-- 25. Countries with equal number of male and female participants
SELECT Country
FROM entriesgender
GROUP BY Country
HAVING SUM(Female) = SUM(Male);
