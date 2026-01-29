.open fittrackpro.db
.mode column

DROP TABLE IF EXISTS locations;
DROP TABLE IF EXISTS members;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS equipment;
DROP TABLE IF EXISTS classes;
DROP TABLE IF EXISTS class_schedule;
DROP TABLE IF EXISTS memberships;
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS class_attendance;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS personal_training_sessions;
DROP TABLE IF EXISTS member_health_metrics;
DROP TABLE IF EXISTS equipment_maintenance_log;


-- Locations Table Creation
CREATE TABLE locations (
    location_id INTEGER PRIMARY KEY NOT NULL,
    name VARCHAR,
    address VARCHAR,
    phone_number VARCHAR CHECK (length(replace(phone_number, ' ', '')) >= 10),
    email VARCHAR CHECK (email LIKE '%_@_%._%'),
    opening_hours VARCHAR CHECK (opening_hours LIKE '__:__-__:__')
);

-- Members Table Creation
CREATE TABLE members (
    member_id INTEGER PRIMARY KEY NOT NULL,
    first_name VARCHAR,
    last_name VARCHAR,
    email VARCHAR CHECK (email LIKE '%_@_%._%'),
    phone_number VARCHAR CHECK (length(replace(phone_number, ' ', '')) >= 10),
    date_of_birth DATE,
    join_date DATE,
    emergency_contact_name VARCHAR,
    emergency_contact_phone VARCHAR CHECK (length(replace(emergency_contact_phone, ' ', '')) >= 10)
);

-- Staff Table Creation
CREATE TABLE staff (
    staff_id INTEGER PRIMARY KEY NOT NULL,
    first_name VARCHAR,
    last_name VARCHAR,
    email VARCHAR CHECK (email LIKE '%_@_%._%'),
    phone_number VARCHAR CHECK (length(replace(phone_number, ' ', '')) >= 10),
    position VARCHAR CHECK (position IN ('Trainer', 'Manager', 'Receptionist', 'Maintenance')),
    hire_date DATE,
    location_id INTEGER,
    FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Equipment Table Creation
CREATE TABLE equipment (
    equipment_id INTEGER PRIMARY KEY NOT NULL,
    name VARCHAR,
    type VARCHAR CHECK (type IN ('Cardio', 'Strength')),
    purchase_date DATE,
    last_maintenance_date DATE,
    next_maintenance_date DATE,
    location_id INTEGER,
    FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE SET NULL ON UPDATE CASCADE
);
-- Classes Table Creation
CREATE TABLE classes (
    class_id INTEGER PRIMARY KEY NOT NULL,
    name VARCHAR,
    description VARCHAR,
    capacity INTEGER,
    duration INTEGER,
    location_id INTEGER,
    FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE SET NULL ON UPDATE CASCADE
);
-- Class Schedule Table Creation
CREATE TABLE class_schedule (
    schedule_id INTEGER PRIMARY KEY NOT NULL,
    class_id INTEGER,
    staff_id INTEGER,
    start_time DATETIME,
    end_time DATETIME,
    FOREIGN KEY (class_id) REFERENCES classes(class_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE SET NULL ON UPDATE CASCADE
);
-- Memberships Table Creation
CREATE TABLE memberships (
    membership_id INTEGER PRIMARY KEY NOT NULL,
    member_id INTEGER,
    type VARCHAR,
    start_date DATE,
    end_date DATE,
    status VARCHAR CHECK (status IN ('Active', 'Inactive')),
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE ON UPDATE CASCADE
);
-- Attendance Table Creation
CREATE TABLE attendance (
    attendance_id INTEGER PRIMARY KEY NOT NULL,
    member_id INTEGER,
    location_id INTEGER,
    check_in_time DATETIME,
    check_out_time DATETIME,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE SET NULL ON UPDATE CASCADE
);
-- Class Attendance Table Creation
CREATE TABLE class_attendance (
    class_attendance_id INTEGER PRIMARY KEY NOT NULL,
    schedule_id INTEGER,
    member_id INTEGER,
    attendance_status VARCHAR CHECK (attendance_status IN ('Registered', 'Attended', 'Unattended')),
    FOREIGN KEY (schedule_id) REFERENCES class_schedule(schedule_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE ON UPDATE CASCADE
);
-- Payments Table Creation
CREATE TABLE payments (
    payment_id INTEGER PRIMARY KEY NOT NULL,
    member_id INTEGER,
    amount REAL,
    payment_date DATETIME,
    payment_method VARCHAR CHECK (payment_method IN ('Credit Card', 'Bank Transfer', 'PayPal', 'Cash')),
    payment_type VARCHAR CHECK (payment_type IN ('Monthly membership fee', 'Day pass')),
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE ON UPDATE CASCADE
);
-- Personal Training Sessions Table Creation
CREATE TABLE personal_training_sessions (
    session_id INTEGER PRIMARY KEY NOT NULL,
    member_id INTEGER,
    staff_id INTEGER,
    session_date DATE,
    start_time TIME,
    end_time TIME,
    notes VARCHAR,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE SET NULL ON UPDATE CASCADE
);
-- Member Health Metrics Table Creation
CREATE TABLE member_health_metrics (
    metric_id INTEGER PRIMARY KEY NOT NULL,
    member_id INTEGER,
    measurement_date DATE,
    weight REAL,
    body_fat_percentage REAL,
    muscle_mass REAL,
    bmi REAL,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE ON UPDATE CASCADE
);
-- Equipment Maintenance Log Table Creation
CREATE TABLE equipment_maintenance_log (
    log_id INTEGER PRIMARY KEY NOT NULL,
    equipment_id INTEGER,
    maintenance_date DATE,
    description VARCHAR,
    staff_id INTEGER,
    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE SET NULL ON UPDATE CASCADE
);