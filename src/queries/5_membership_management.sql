.open fittrackpro.db
.mode column

-- 5.1 
SELECT
    mbs.member_id,
    mem.first_name,
    mem.last_name,
    mbs.type AS membership_type,
    mbs.start_date AS join_date
FROM memberships mbs
LEFT JOIN members mem
ON mbs.member_id = mem.member_id
WHERE mbs.status = 'Active';

-- 5.2 
SELECT
    mbs.type AS membership_type,
    ROUND(AVG((julianday(a.check_out_time) - julianday(a.check_in_time)) * 24 * 60), 2) AS avg_visit_duration_minutes
FROM attendance a
LEFT JOIN memberships mbs
ON a.member_id = mbs.member_id
GROUP BY mbs.type;

-- 5.3 
SELECT
    mem.member_id,
    mem.first_name,
    mem.last_name,
    mem.email,
    mbs.end_date
FROM members mem
LEFT JOIN memberships mbs
ON mem.member_id = mbs.member_id
WHERE mbs.end_date < '2026-01-01' AND mbs.status = 'Active';
