WITH turnstile AS (
  SELECT date
        ,time
        ,station
        ,[entry] AS entered
        ,[exit] AS exited
  FROM KIPP_NJ..AUTOLOAD$turnstiles
  WHERE DATEPART(WEEKDAY,date) NOT IN (6,7)
 )

,sched AS (
  -- trip detail by route and service
  SELECT trip.[﻿route_id] AS route_id
        ,rte.route_long_name
        ,trip.[service_id]
        ,svc.service_name
        ,times.stop_id AS stop_id      
        ,CASE
          WHEN parent.stop_name = '14th Street' THEN '14t'
          WHEN parent.stop_name = '23rd Street' THEN '23r'
          WHEN parent.stop_name = '33rd Street' THEN '33r'
          WHEN parent.stop_name = '9th Street' THEN '9th'
          WHEN parent.stop_name = 'Christopher Street' THEN 'Chr'
          WHEN parent.stop_name = 'Exchange Place' THEN 'Exc'
          WHEN parent.stop_name = 'Grove Street' THEN 'Gro'
          WHEN parent.stop_name = 'Harrison' THEN 'Har'
          WHEN parent.stop_name = 'Hoboken' THEN 'Hob'
          WHEN parent.stop_name = 'Journal Square' THEN 'Jou'
          WHEN parent.stop_name = 'Newark Penn Station' THEN 'New'
          WHEN parent.stop_name = 'Newport' THEN 'Pav'
          WHEN parent.stop_name = 'World Trade Center' THEN 'WTC'
         END AS stop_name
        ,times.stop_sequence
        ,trip.[direction_id]
        ,times.arrival_time
        ,times.departure_time
        ,parent.[stop_lat]
        ,parent.[stop_lon]      
        --,exc.*      
        ,trip.[trip_id]
        --,trip.[trip_headsign]
  FROM [KIPP_NJ].[dbo].[AUTOLOAD$trips] trip
  JOIN [KIPP_NJ].[dbo].[AUTOLOAD$stop_times] times
    ON trip.trip_id = times.[﻿trip_id]
  JOIN [KIPP_NJ].[dbo].[AUTOLOAD$stops] stops
    ON times.stop_id = stops.[﻿stop_id]
   AND stops.location_type = 0
  JOIN [KIPP_NJ].[dbo].[AUTOLOAD$stops] parent
    ON stops.parent_station = parent.[﻿stop_id]
   AND parent.location_type = 1
  JOIN [KIPP_NJ].[dbo].[AUTOLOAD$calendar] svc
    ON trip.service_id = svc.[service_id]
  --LEFT OUTER JOIN [KIPP_NJ].[dbo].[AUTOLOAD$calendar_dates] exc
  --  ON trip.service_id = exc.[service_id]
  JOIN [KIPP_NJ].[dbo].[AUTOLOAD$routes] rte
    ON trip.[﻿route_id] = rte.route_id
 )

,scaffold AS (
SELECT stop_name
      ,departure_time
      ,LAG(departure_time) OVER(
         PARTITION BY stop_name
           ORDER BY departure_time) AS prev_departure_time
FROM 
    (
     SELECT DISTINCT 
            stop_name                  
           ,departure_time      
     FROM sched
     --JOIN turnstile
     --  ON sched.stop_name = turnstile.station
     -- AND 
     WHERE route_long_name = 'Journal Square - 33rd Street'
       AND service_name = 'Yearly Service (Mon-Fri)'     
    ) sub
)

SELECT stop_name
      ,departure_time
      ,date
      ,SUM(CONVERT(INT,entered)) AS entered
      ,SUM(CONVERT(INT,exited)) AS exited
FROM
   (
    SELECT *
    FROM scaffold s
    JOIN turnstile t
      ON s.stop_name = t.station
     AND t.time > s.prev_departure_time 
     AND t.time <= s.departure_time
   ) sub
GROUP BY stop_name
        ,departure_time
        ,date