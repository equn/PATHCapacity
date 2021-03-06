-- trip detail by route and service
SELECT trip.[ï»¿route_id] AS route_id
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
      --,times.arrival_time
      ,times.departure_time
      ,parent.[stop_lat]
      ,parent.[stop_lon]      
      --,exc.*      
      ,trip.[trip_id]
      --,trip.[trip_headsign]
FROM [KIPP_NJ].[dbo].[AUTOLOAD$trips] trip
JOIN [KIPP_NJ].[dbo].[AUTOLOAD$stop_times] times
  ON trip.trip_id = times.[ï»¿trip_id]
JOIN [KIPP_NJ].[dbo].[AUTOLOAD$stops] stops
  ON times.stop_id = stops.[ï»¿stop_id]
 AND stops.location_type = 0
JOIN [KIPP_NJ].[dbo].[AUTOLOAD$stops] parent
  ON stops.parent_station = parent.[ï»¿stop_id]
 AND parent.location_type = 1
JOIN [KIPP_NJ].[dbo].[AUTOLOAD$calendar] svc
  ON trip.service_id = svc.[service_id]
--LEFT OUTER JOIN [KIPP_NJ].[dbo].[AUTOLOAD$calendar_dates] exc
--  ON trip.service_id = exc.[service_id]
JOIN [KIPP_NJ].[dbo].[AUTOLOAD$routes] rte
  ON trip.[ï»¿route_id] = rte.route_id