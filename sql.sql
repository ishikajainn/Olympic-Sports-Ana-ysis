# Q1 Calculate the frequency of cities for hosting Olympic Games?

SELECT c.city_name, COUNT(*) AS count_of_games
FROM games as g
INNER JOIN games_city as gc ON g.id = gc.games_id
INNER JOIN city as c ON gc.city_id = c.id
GROUP BY 1
ORDER BY 2 DESC;


# Q2 How has the duration of Olympic Games changed over time?

with cte AS (
    SELECT
        games_year,
        LAG(games_year) OVER (ORDER BY games_year) AS previous_year 
        FROM Games)
SELECT games_year, previous_year,
    CASE WHEN previous_year IS NOT NULL THEN games_year - previous_year
	ELSE NULL 
    END AS duration
FROM cte
ORDER BY games_year;


# Q3 Are there any emerging sports that have been recently added to the Olympics?

with cte as (
SELECT e.id, e.event_name, COUNT(distinct g.id) AS Occurrences
FROM Games AS g
INNER JOIN games_competitor AS gc ON gc.games_id = g.id
INNER JOIN competitor_event AS ce ON ce.competitor_id = gc.id
INNER JOIN event AS e ON e.id = ce.event_id
INNER JOIN Sport AS s ON e.sport_id = s.id
GROUP BY 1,2
)
select distinct(g.games_year), cte.event_name, cte.Occurrences 
from cte
INNER JOIN event AS e ON e.id = cte.id
INNER JOIN competitor_event AS ce ON e.id = ce.event_id
INNER JOIN games_competitor AS gc ON ce.competitor_id = gc.id
INNER JOIN games AS g ON g.id = gc.games_id
where cte.Occurrences =1
order by 1 desc
limit 4;


# Q4 Are there any sports that have a higher number of events for one gender compared to others?

# Male > Female
SELECT S.sport_name,
COUNT(DISTINCT CASE WHEN P.gender = 'M' THEN e.id END) AS male_events,
COUNT(DISTINCT CASE WHEN P.gender = 'F' THEN e.id END) AS female_events
FROM Sport S
JOIN Event E ON S.id = E.sport_id
JOIN Competitor_Event CE ON E.id = CE.event_id
JOIN games_competitor GC ON GC.id = CE.competitor_id
JOIN Person P ON GC.person_id = P.id
GROUP BY S.sport_name
HAVING male_events > female_events;


# Female > Male
SELECT S.sport_name,
COUNT(DISTINCT CASE WHEN P.gender = 'M' THEN e.id END) AS male_events,
COUNT(DISTINCT CASE WHEN P.gender = 'F' THEN e.id END) AS female_events
FROM Sport S
JOIN Event E ON S.id = E.sport_id
JOIN Competitor_Event CE ON E.id = CE.event_id
JOIN games_competitor GC ON GC.id = CE.competitor_id
JOIN Person P ON GC.person_id = P.id
GROUP BY S.sport_name
HAVING male_events < female_events;



# Q5 Find the regions that have had a notable impact on the overall medal tally?

SELECT NR.region_name, 
COUNT(CASE WHEN CE.medal_id IN (1, 2, 3) THEN CE.medal_id END) AS total_medals 
FROM NOC_Region NR
JOIN Person_Region PR ON NR.id = PR.region_id
JOIN games_competitor GC ON GC.person_id = PR.person_id
JOIN Competitor_Event CE ON GC.id = CE.competitor_id
JOIN MEDAL M ON M.id = CE.MEDAL_ID
GROUP BY 1
ORDER BY 2 DESC;


# Q6 Calculate the medal counts as per Gold, Silver and Bronze.
select * from medal;
select * from competitor_event;

select m.medal_name, count(medal_id)
from competitor_event c
join medal m 
on c.medal_id = m.id
group by medal_name;
