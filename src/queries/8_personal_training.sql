.open fittrackpro.db
.mode column

-- 8.1 
SELECT
    pts.session_id,
    mem.first_name || ' ' || mem.last_name AS member_name,
    pts.session_date,
    pts.start_time,
    pts.end_time
FROM personal_training_sessions pts
LEFT JOIN members mem
ON pts.member_id = mem.member_id
LEFT JOIN staff s
ON pts.staff_id = s.staff_id
WHERE s.first_name = 'Ivy' AND s.last_name = 'Irwin';