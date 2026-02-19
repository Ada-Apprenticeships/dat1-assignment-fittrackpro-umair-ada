.open fittrackpro.db
.mode column

-- 7.1 
SELECT
    staff_id,
    first_name,
    last_name,
    position AS role
FROM staff;


-- 7.2 
SELECT
    stf.staff_id AS trainer_id,
    stf.first_name || ' ' || stf.last_name AS trainer_name,
    COUNT(pts.session_id) AS session_count
FROM staff stf
JOIN personal_training_sessions pts
ON stf.staff_id = pts.staff_id 
WHERE stf.position = 'Trainer'
AND pts.session_date BETWEEN '2025-01-20' AND DATE('2025-01-20', '+30 days')
GROUP BY stf.staff_id
HAVING session_count >= 1;