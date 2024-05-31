drop database if exists smartfarmtest;
create database if not exists smartfarmtest;
use smartfarmtest;

DELIMITER $$
CREATE TABLE IF NOT EXISTS feed (
    feedKey CHAR(10) PRIMARY KEY,
    feedName TEXT,
    status BOOLEAN NOT NULL,
    type enum('sensor','button','task') NOT NULL,
    automated BOOLEAN NOT NULL
);

create table if not exists data (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    time_ timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    value FLOAT NOT NULL,
    feedKey CHAR(10),
    FOREIGN KEY (feedKey) REFERENCES feed(feedKey)
);

create table if not exists schedule (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    time_on time NOT NULL,
    time_off time NOT NULL,
    created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    changed_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    feedKey CHAR(10),
    FOREIGN KEY (feedKey) REFERENCES feed(feedKey)
);

create table if not exists result (
    status TEXT,
    time_ timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);

$$
SET FOREIGN_KEY_CHECKS=0;

$$
CREATE PROCEDURE updateSchedule (IN p_feedKey CHAR(10), IN p_id INT, IN p_time_on VARCHAR(10), IN p_time_off VARCHAR(10))
BEGIN
	UPDATE schedule
	SET `time_on` = str_to_date(p_time_on,'%H:%i:%s'), `time_off`=str_to_date(p_time_off,'%H:%i:%s')
	WHERE `feedKey` = feedKey AND `id` = p_id;
END $$

$$ 
CREATE PROCEDURE updateStatus(IN p_feedKey CHAR(10), IN newStatus BOOLEAN)
BEGIN
	UPDATE feed SET `status` = newStatus WHERE feedKey = p_feedKey;
        SELECT status FROM feed WHERE feedKey = p_feedKey;
END $$

$$
CREATE PROCEDURE updateAutomation(IN p_feedKey CHAR(10), IN p_automated BOOLEAN)
BEGIN 
        UPDATE feed SET `automated` = p_automated WHERE feedKey = p_feedKey;
        SELECT automated from feed WHERE feedKey = p_feedKey;
END $$

$$
CREATE PROCEDURE updateResult(IN status TEXT) 
BEGIN 
        UPDATE result SET `status` = status;
        SELECT status from result; 
END $$


CREATE TRIGGER scheduleModifierTrigger BEFORE UPDATE ON schedule FOR EACH ROW
BEGIN
	IF (NEW.time_on <> OLD.time_on or NEW.time_off <> OLD.time_off) THEN
		SET NEW.changed_at = CURRENT_TIMESTAMP();
	END IF;
END$$

 

INSERT INTO feed VALUES
('sensor001','Temperature', true, 'sensor', false),
('sensor002','Humidity', false, 'sensor', false),
('sensor003','Light', false, 'sensor', false),
('button001','Fan 1', false, 'button', false),
('button002','Lightbulb 1', false, 'button', false),
('button004','Water Bump 2', false, 'task', false),
('button003','Water Bump 1', true, 'button', false);

$$
INSERT INTO data(`value`,`feedKey`) VALUES
('25','sensor001'),
('24','sensor001'),
('25','sensor002'),
('26','sensor001'),
('40','sensor003'),
('29','sensor001'),
('30','sensor002'),
('25','sensor002'),
('27','sensor002'),
('29','sensor002'),
('40','sensor003'),
('45','sensor003'),
('44','sensor003'),
('25','sensor002'),
('24','sensor001'),
('26','sensor001'),
('43','sensor003'),
('30','sensor001');

$$
INSERT INTO schedule(`time_on`, `time_off`,`feedKey`) VALUES
(str_to_date('12:00:00','%H:%i:%s'), str_to_date('12:05:00','%H:%i:%s'), 'button001'),
(str_to_date('12:00:00','%H:%i:%s'), str_to_date('12:10:00','%H:%i:%s'), 'button002');
-- (str_to_date('18:00:00','%H:%i:%s'), str_to_date('18:05:00','%H:%i:%s'), 'button001');
-- INSERT INTO schedule(`time_on`, `time_off`,`feedKey`) VALUES ('18:00:00','18:05:00', 'button002');

$$
INSERT INTO result(`status`) VALUES 
('INIT');

$$
SET FOREIGN_KEY_CHECKS=1;
$$
select * from feed;
$$
select * from data;
$$
select * from schedule;

-- $$
-- call updateSchedule('button001','3','19:00:01','20:00:01'); test procedure
