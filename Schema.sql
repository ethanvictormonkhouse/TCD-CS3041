/*Table Creation*/

CREATE TABLE Warehouse(
warehouse_id INTEGER NOT NULL,
address VARCHAR(50) NOT NULL,
total_staff INTEGER,
total_lots INTEGER,
lots_available INTEGER,
PRIMARY KEY (warehouse_id),
CONSTRAINT check_lots_valid CHECK((total_lots >= lots_available)),
CONSTRAINT check_warehouse_valid CHECK(warehouse_id > 0 AND warehouse_id < 15)
);

CREATE TABLE Employee(
staff_id INTEGER NOT NULL,
ppsn VARCHAR(20) NOT NULL UNIQUE,
fname VARCHAR(30) NOT NULL,
lname VARCHAR(30) NOT NULL,
warehouse INTEGER NOT NULL,
role VARCHAR(50) NOT NULL,
dob DATE NOT NULL,
PRIMARY KEY (staff_id),
FOREIGN KEY (warehouse) REFERENCES Warehouse(warehouse_id)
ON DELETE RESTRICT
ON UPDATE CASCADE,
CONSTRAINT check_ppsn_valid CHECK((LENGTH(ppsn) > 7) AND (LENGTH(ppsn) <= 9)),
CONSTRAINT check_id_valid CHECK((LENGTH(staff_id) > 0) AND (LENGTH(staff_id) <= 999)),
CONSTRAINT check_role_valid CHECK (role IN ('Driver', 'Manager', 'Operator'))
);

CREATE TABLE Lot(
lot_id INTEGER NOT NULL,
warehouse_no INTEGER NOT NULL,
availability BOOLEAN,
PRIMARY KEY (lot_id),
FOREIGN KEY (warehouse_no) REFERENCES Warehouse(warehouse_id)
ON DELETE RESTRICT
ON UPDATE CASCADE
);

CREATE TABLE Batch(
batch_id INTEGER NOT NULL,
lot_no INTEGER NOT NULL,
warehouse_no INTEGER NOT NULL,
weight VARCHAR(50) NOT NULL,
expiry_date DATE NOT NULL,
allocation_date DATE NOT NULL,
PRIMARY KEY (batch_id),
FOREIGN KEY (warehouse_no) REFERENCES Warehouse(warehouse_id)
ON DELETE RESTRICT
ON UPDATE CASCADE,
FOREIGN KEY (lot_no) REFERENCES Lot(lot_id)
ON DELETE RESTRICT
ON UPDATE CASCADE
);

CREATE TABLE Vaccine(
vaccine_id INTEGER NOT NULL,
batch_no INTEGER NOT NULL,
vaccine_name VARCHAR(50) NOT NULL,
dosage VARCHAR(20) NOT NULL,
expiry_date DATE NOT NULL,
PRIMARY KEY (vaccine_id),
FOREIGN KEY (batch_no) REFERENCES Batch(batch_id)
ON DELETE RESTRICT
ON UPDATE CASCADE
);

CREATE TABLE Hospital(
hospital_name VARCHAR(50) NOT NULL,
hospital_address VARCHAR(150) NOT NULL,
hospital_type VARCHAR(30) NOT NULL,
status VARCHAR(10) NOT NULL DEFAULT 'Inactive',
driver INTEGER,
PRIMARY KEY (hospital_name),
FOREIGN KEY (driver) REFERENCES Employee(staff_id)
ON DELETE RESTRICT
ON UPDATE CASCADE,
CONSTRAINT check_hospital_status CHECK (status IN ('Active','Inactive')),
CONSTRAINT check_hospital_type CHECK (hospital_type IN ('Public','Private'))
);

CREATE TABLE Vehicle(
vehicle_id INTEGER NOT NULL,
vehicle_reg VARCHAR(50) NOT NULL,
deliver_to VARCHAR(50),
vehicle_type VARCHAR(50) NOT NULL,
warehouse INTEGER NOT NULL,
driver INTEGER NOT NULL,
PRIMARY KEY (vehicle_id),
FOREIGN KEY (driver) REFERENCES Employee(staff_id)
ON DELETE RESTRICT
ON UPDATE CASCADE,
FOREIGN KEY (warehouse) REFERENCES Warehouse(warehouse_id)
ON DELETE RESTRICT
ON UPDATE CASCADE
);

/*Triggers*/

DELIMITER $$
CREATE TRIGGER addLot AFTER INSERT ON Lot
AS
BEGIN
    UPDATE Warehouse
        SET total_lots = total_lots + 1, lots_available = lots_available + 1
        WHERE warehouse_id = new.warehouse_no AND new.availability = TRUE;
END;$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER addStaff AFTER INSERT ON Employee
AS
BEGIN
    UPDATE Warehouse
        SET total_staff = total_staff + 1
        WHERE warehouse_id = new.warehouse;
END;$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER removeLot AFTER DELETE ON Lot
AS
BEGIN
    UPDATE Warehouse
        SET lots_available = lots_available - 1, total_lots = total_lots - 1
        WHERE warehouse_id = old.warehouse;
END;$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER increaseAvailableLots AFTER UPDATE ON Lot
AS
BEGIN
    UPDATE Warehouse
        SET lots_available = lots_available + 1
        WHERE warehouse_id = old.warehouse AND availability = TRUE;
END;$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER decreaseAvailableLots AFTER UPDATE ON Lot
AS
BEGIN
    UPDATE Warehouse
        SET lots_available = lots_available - 1
        WHERE warehouse_id = old.warehouse AND availability = FALSE;
END;$$
DELIMITER ;

/*Database Population*/

INSERT INTO Warehouse VALUES (1, 'Cork, Ireland', 0, 0, 0);
INSERT INTO Warehouse VALUES (2, 'Dublin, Ireland', 0, 0, 0);
INSERT INTO Warehouse VALUES (3, 'Galway, Ireland', 0, 0, 0);
INSERT INTO Warehouse VALUES (4, 'Limerick, Ireland', 0, 0, 0);
INSERT INTO Warehouse VALUES (5, 'Sligo, Ireland', 0, 0, 0);
INSERT INTO Warehouse VALUES (6, 'Wexford, Ireland', 0, 0, 0);

INSERT INTO Employee VALUES (212, '2846277E', 'John', 'Smith', 2, 'Driver', '1982-09-23' );
INSERT INTO Employee VALUES (238, '8295625E', 'Mary', 'Adams', 5, 'Operator', '1993-02-01' );
INSERT INTO Employee VALUES (844, '2810386YF', 'Milo', 'Greene', 3, 'Manager', '1976-07-10' );
INSERT INTO Employee VALUES (118, '8373826R', 'Grant', 'Haynes', 2, 'Driver', '1991-12-08' );
INSERT INTO Employee VALUES (428, '2823238UE', 'Farah', 'Willow', 4, 'Driver', '1962-03-25' );
INSERT INTO Employee VALUES (248, '2840719D', 'Sarah', 'Davis', 3, 'Operator', '1995-11-21' );
INSERT INTO Employee VALUES (836, '2846245E', 'Sandra', 'Wells', 3, 'Driver', '1998-01-23' );
INSERT INTO Employee VALUES (318, '8295324E', 'Jamie', 'Stock', 5, 'Operator', '1978-02-01' );
INSERT INTO Employee VALUES (102, '2810323YF', 'Richard', 'Fitzpatrick', 3, 'Manager', '1986-07-10' );
INSERT INTO Employee VALUES (208, '8243826R', 'Alexa', 'Hynes', 2, 'Driver', '1997-12-08' );
INSERT INTO Employee VALUES (142, '2842232FE', 'William', 'Skerry', 4, 'Driver', '1968-03-25' );
INSERT INTO Employee VALUES (104, '2840721R', 'Ciara', 'Murray', 6, 'Operator', '1991-11-21' );

INSERT INTO Lot VALUES (317, 3, TRUE);
INSERT INTO Lot VALUES (333, 3, TRUE);
INSERT INTO Lot VALUES (113, 1, TRUE);
INSERT INTO Lot VALUES (414, 4, TRUE);
INSERT INTO Lot VALUES (294, 2, TRUE);
INSERT INTO Lot VALUES (319, 3, TRUE);
INSERT INTO Lot VALUES (518, 5, TRUE);
INSERT INTO Lot VALUES (495, 4, TRUE);
INSERT INTO Lot VALUES (228, 2, TRUE);
INSERT INTO Lot VALUES (195, 1, TRUE);
INSERT INTO Lot VALUES (557, 5, TRUE);
INSERT INTO Lot VALUES (528, 5, TRUE);
INSERT INTO Lot VALUES (174, 2, TRUE);
INSERT INTO Lot VALUES (418, 4, TRUE);
INSERT INTO Lot VALUES (559, 5, TRUE);
INSERT INTO Lot VALUES (853, 3, TRUE);
INSERT INTO Lot VALUES (219, 2, TRUE);
INSERT INTO Lot VALUES (295, 2, TRUE);
INSERT INTO Lot VALUES (618, 6, TRUE);
INSERT INTO Lot VALUES (385, 3, TRUE);

INSERT INTO Batch VALUES (242, 317, 3, '30438g', '2020-12-30', '2020-12-01');
INSERT INTO Batch VALUES (424, 333, 3, '30438g', '2020-12-30', '2020-12-01');
INSERT INTO Batch VALUES (145, 113, 1, '30438g', '2020-12-31', '2020-12-02');
INSERT INTO Batch VALUES (732, 414, 4, '30438g', '2020-12-31', '2020-12-02');
INSERT INTO Batch VALUES (827, 294, 2, '30438g', '2020-12-31', '2020-12-02');
INSERT INTO Batch VALUES (917, 319, 3, '30438g', '2020-12-31', '2020-12-02');
INSERT INTO Batch VALUES (149, 518, 5, '30438g', '2020-12-31', '2020-12-02');
INSERT INTO Batch VALUES (184, 495, 4, '30438g', '2020-12-31', '2020-12-02');
INSERT INTO Batch VALUES (194, 228, 2, '30438g', '2020-12-31', '2020-12-02');
INSERT INTO Batch VALUES (645, 195, 1, '30438g', '2020-12-31', '2020-12-02');
INSERT INTO Batch VALUES (143, 557, 5, '30438g', '2020-12-31', '2020-12-02');
INSERT INTO Batch VALUES (329, 528, 5, '30438g', '2020-12-31', '2020-12-02');

INSERT INTO Vaccine VALUES (2834, 242, 'CoronaVac Sinovac', '1', '2020-12-30');
INSERT INTO Vaccine VALUES (2835, 242, 'CoronaVac Sinovac', '1', '2020-12-30');
INSERT INTO Vaccine VALUES (2836, 242, 'CoronaVac Sinovac', '1', '2020-12-30');
INSERT INTO Vaccine VALUES (2837, 242, 'CoronaVac Sinovac', '1', '2020-12-30');
INSERT INTO Vaccine VALUES (2838, 242, 'CoronaVac Sinovac', '1', '2020-12-30');
INSERT INTO Vaccine VALUES (2839, 242, 'CoronaVac Sinovac', '1', '2020-12-30');
INSERT INTO Vaccine VALUES (2840, 242, 'CoronaVac Sinovac', '1', '2020-12-30');

INSERT INTO Vaccine VALUES (2934, 145, 'CoronaVac Sinovac', '1', '2020-12-31');
INSERT INTO Vaccine VALUES (2935, 145, 'CoronaVac Sinovac', '1', '2020-12-31');
INSERT INTO Vaccine VALUES (2936, 145, 'CoronaVac Sinovac', '1', '2020-12-31');
INSERT INTO Vaccine VALUES (2937, 145, 'CoronaVac Sinovac', '1', '2020-12-31');
INSERT INTO Vaccine VALUES (2938, 145, 'CoronaVac Sinovac', '1', '2020-12-31');
INSERT INTO Vaccine VALUES (2939, 145, 'CoronaVac Sinovac', '1', '2020-12-31');
INSERT INTO Vaccine VALUES (2940, 145, 'CoronaVac Sinovac', '1', '2020-12-31');

INSERT INTO Vaccine VALUES (3834, 827, 'CoronaVac Sinovac', '1', '2020-12-31');
INSERT INTO Vaccine VALUES (3835, 827, 'CoronaVac Sinovac', '1', '2020-12-31');
INSERT INTO Vaccine VALUES (3836, 827, 'CoronaVac Sinovac', '1', '2020-12-31');
INSERT INTO Vaccine VALUES (3837, 827, 'CoronaVac Sinovac', '1', '2020-12-31');
INSERT INTO Vaccine VALUES (3838, 827, 'CoronaVac Sinovac', '1', '2020-12-31');
INSERT INTO Vaccine VALUES (3839, 827, 'CoronaVac Sinovac', '1', '2020-12-31');
INSERT INTO Vaccine VALUES (3840, 827, 'CoronaVac Sinovac', '1', '2020-12-31');

INSERT INTO Vaccine VALUES (2834, 194, 'CoronaVac Sinovac', '1', '2020-12-31');
INSERT INTO Vaccine VALUES (2835, 194, 'CoronaVac Sinovac', '1', '2020-12-31');
INSERT INTO Vaccine VALUES (2836, 194, 'CoronaVac Sinovac', '1', '2020-12-31');
INSERT INTO Vaccine VALUES (2837, 194, 'CoronaVac Sinovac', '1', '2020-12-31');
INSERT INTO Vaccine VALUES (2838, 194, 'CoronaVac Sinovac', '1', '2020-12-31');
INSERT INTO Vaccine VALUES (2839, 194, 'CoronaVac Sinovac', '1', '2020-12-31');
INSERT INTO Vaccine VALUES (2840, 194, 'CoronaVac Sinovac', '1', '2020-12-31');

INSERT INTO Hospital VALUES ('Mercy', 'St. Patricks Street, Cork', 'Private', 'Active', 212);
INSERT INTO Hospital VALUES ('St. James', 'The Liberties, Dublin 8', 'Public', 'Active', 118);
INSERT INTO Hospital VALUES ('UCD', 'Donnybrook, Dublin', 'Public', 'Active', 428);
INSERT INTO Hospital VALUES ('Bonds', 'Sundays Wells, Cork', 'Private', 'Active', 836);
INSERT INTO Hospital VALUES ('Kinsale Hospital', 'Main Street, Cork', 'Public', 'Active', 208);

INSERT INTO Vehicle VALUES (12, '131-C-19381', 'Mercy', 'Temperature-Controlled Van', 2, 212);
INSERT INTO Vehicle VALUES (13, '131-C-19382', 'St. James', 'Temperature-Controlled Van', 2, 118);
INSERT INTO Vehicle VALUES (14, '131-C-19383', 'UCD', 'Temperature-Controlled Van', 4, 428);
INSERT INTO Vehicle VALUES (15, '131-C-19384', 'Bonds', 'Temperature-Controlled Van', 3, 836);
INSERT INTO Vehicle VALUES (16, '131-C-19385', 'Kinsale Hospital', 'Temperature-Controlled Van', 2, 208);

/*Role Creation*/

CREATE ROLE Manager;
GRANT CREATE Employee TO Manager;
GRANT DELETE Employee TO Manager;
GRANT UPDATE Employee TO Manager;
GRANT CREATE Hospital TO Manager;
GRANT DELETE Hospital TO Manager;
GRANT UPDATE Hospital TO Manager;
GRANT CREATE Vehicle TO Manager;
GRANT DELETE Vehicle TO Manager;
GRANT UPDATE Vehicle TO Manager;
GRANT CREATE Batch TO Manager;
GRANT DELETE Batch TO Manager;
GRANT UPDATE Batch TO Manager;
GRANT CREATE Lot TO Manager;
GRANT DELETE Lot TO Manager;
GRANT UPDATE Lot TO Manager;
GRANT CREATE Vaccine TO Manager;
GRANT DELETE Vaccine TO Manager;
GRANT UPDATE Vaccine TO Manager;
GRANT CREATE Warehouse TO Manager;
GRANT DELETE Warehouse TO Manager;
GRANT UPDATE Warehouse TO Manager;

CREATE ROLE Driver;
GRANT UPDATE Vehicle TO Driver;
GRANT UPDATE Hospital TO Driver;

CREATE ROLE Operator;
GRANT UPDATE Warehouse TO Operator;
GRANT UPDATE Batch TO Operator;
GRANT UPDATE Lot TO Operator;

GRANT Manager TO 'Milo Greene';
GRANT Driver TO 'John Smith';
GRANT Operator TO 'Sarah Davis';

/*View Creation*/

CREATE VIEW drivers_assigned_vehicles AS
SELECT Employee.fname AS 'Driver First Name',
  Employee.lname AS 'Driver Last Name',
  Employee.ppsn AS 'Driver PPSN',
  Vehicle.driver AS 'Driver Staff Number',
  Vehicle.vehicle_reg AS 'Vehicle Registration'
FROM Vehicle
INNER JOIN Employee ON Vehicle.driver=Employee.staff_id;


CREATE VIEW lot_locations AS
SELECT Warehouse.warehouse_id AS 'Warehouse',
  Warehouse.address AS 'Address',
  Lot.lot_id AS 'Location (Lot)'
FROM Warehouse
INNER JOIN Lot
ON Warehouse.warehouse_id = Lot.warehouse_no AND Lot.availability = TRUE;
