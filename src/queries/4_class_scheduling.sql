.open fittrackpro.db
.mode column

-- 4.1 
SELECT
    cs.class_id,
    c.name AS class_name,
    s.first_name || ' ' || s.last_name AS instructor_name
FROM class_schedule cs
LEFT JOIN classes c
ON cs.class_id = c.class_id
LEFT JOIN staff s
ON cs.staff_id = s.staff_id;

-- 4.2 
SELECT
    cs.class_id,
    c.name AS name,
    cs.start_time,
    cs.end_time,
    c.capacity - COUNT(ca.attendance_status) AS available_spots
FROM class_schedule cs
LEFT JOIN classes c
ON cs.class_id = c.class_id
LEFT JOIN class_attendance ca
ON cs.schedule_id = ca.schedule_id
WHERE DATE(cs.start_time) = '2025-02-01'
GROUP BY cs.class_id;


-- 4.3 
INSERT INTO class_attendance (schedule_id, member_id, attendance_status)
VALUES 
(
    (SELECT class_id FROM class_schedule WHERE class_schedule.schedule_id = 1),
    11,
    'Registered'
);


-- 4.4 
DELETE FROM class_attendance
WHERE member_id = 3 AND schedule_id = 7;

-- 4.5 
SELECT
    cs.class_id,
    c.name AS class_name,
    COUNT(CASE WHEN ca.attendance_status = 'Registered' THEN 1 END) AS registration_count
FROM class_schedule cs
LEFT JOIN classes c
ON cs.class_id = c.class_id
LEFT JOIN class_attendance ca
ON cs.schedule_id = ca.schedule_id
GROUP BY cs.class_id
ORDER BY registration_count DESC
LIMIT 1;

-- 4.6 
SELECT ROUND(AVG(classes_attended_or_registered), 2) AS avg_classes_per_member
FROM (
    SELECT
        member_id,
        COUNT(CASE WHEN attendance_status = 'Registered' OR attendance_status = 'Attended' THEN 1 END) AS classes_attended_or_registered
    FROM class_attendance
    GROUP BY member_id
);