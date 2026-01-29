.open fittrackpro.db
.mode column

-- 3.1 
SELECT
    equipment_id, name, next_maintenance_date
FROM equipment
WHERE next_maintenance_date < '2025-02-01'
AND next_maintenance_date >= '2025-01-01';

-- 3.2 
SELECT
    type AS equipment_type,
    COUNT(equipment_id) AS count
FROM equipment
GROUP BY type;

-- 3.3 
SELECT
    type AS equipment_type,
    ROUND(AVG(julianday('now') - julianday(purchase_date)), 1) AS avg_age_days
FROM equipment
GROUP BY type;
