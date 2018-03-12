-- CMPUT 291 - Winter 2018 
-- TABLES for Project #1, assuming SQLite as database engine (uses the TEXT data type) 


-- The following commands drops the tables in case they exist from earlier runs. 
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS service_fulfillments;
DROP TABLE IF EXISTS service_agreements;
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS drivers;
DROP TABLE IF EXISTS account_managers;
DROP TABLE IF EXISTS personnel;
DROP TABLE IF EXISTS container_waste_types;
DROP TABLE IF EXISTS waste_types;
DROP TABLE IF EXISTS containers;
DROP TABLE IF EXISTS maintenance_records;
DROP TABLE IF EXISTS trucks;


-- The following commands create the tables including FOREIGN KEY constraints

CREATE TABLE users (
  user_id	TEXT, 
  role		TEXT,
  login		TEXT, 
  password	TEXT, 
  PRIMARY KEY (user_id),
  FOREIGN KEY (user_id) REFERENCES personnel(pid) ON DELETE CASCADE
);


CREATE TABLE trucks (
  truck_id          TEXT,
  model             TEXT,
  truck_type        TEXT,
  PRIMARY KEY (truck_id) 
);

CREATE TABLE maintenance_records (
  truck_id          TEXT,
  service_date      DATE,
  description       TEXT,
  PRIMARY KEY (truck_id, service_date),
  FOREIGN KEY (truck_id) REFERENCES trucks ON DELETE CASCADE
);

CREATE TABLE containers (
  container_id      TEXT,
  container_type    TEXT,
  date_when_built   DATE,
  PRIMARY KEY (container_id)
);

CREATE TABLE waste_types (
    waste_type      TEXT,
    PRIMARY KEY (waste_type)
);

CREATE TABLE container_waste_types (
  container_id      TEXT,
  waste_type        TEXT,
  PRIMARY KEY (container_id, waste_type),
  FOREIGN KEY (container_id) REFERENCES containers,
  FOREIGN KEY (waste_type) REFERENCES waste_types
);

CREATE TABLE personnel (
  pid               TEXT, 
  name              TEXT, 
  email             TEXT, 
  address           TEXT, 
  supervisor_pid    TEXT, 
  PRIMARY KEY (PID)
);

CREATE TABLE account_managers (
  pid               TEXT,
  manager_title     TEXT,
  office_location   TEXT,
  PRIMARY KEY (pid),
  FOREIGN KEY (pid) REFERENCES personnel
);

CREATE TABLE drivers (
  pid               TEXT,
  certification     TEXT,
  owned_truck_id    TEXT,
  PRIMARY KEY (pid),
  FOREIGN KEY (pid) REFERENCES personnel,
  FOREIGN KEY (owned_truck_id) REFERENCES trucks(truck_id)
);

CREATE TABLE accounts (
  account_no        TEXT,
  account_mgr       TEXT,
  customer_name     TEXT,
  contact_info      TEXT,
  customer_type     TEXT,
  start_date        DATE,
  end_date          DATE,
  total_amount      REAL,
  PRIMARY KEY (account_no),
  FOREIGN KEY (account_mgr) REFERENCES account_managers(pid)
);

CREATE TABLE service_agreements (
  service_no        TEXT,
  master_account    TEXT,
  location          TEXT,
  waste_type        TEXT,
  pick_up_schedule  TEXT,
  local_contact     TEXT,
  internal_cost     REAL,
  price             REAL,
  PRIMARY KEY (master_account, service_no),
  FOREIGN KEY (master_account) REFERENCES accounts ON DELETE CASCADE, 
  FOREIGN KEY (waste_type) REFERENCES waste_types
); 
  
CREATE TABLE service_fulfillments (
  date_time         DATE,
  master_account    TEXT, 
  service_no        TEXT,
  truck_id          TEXT,
  driver_id         TEXT,
  cid_drop_off      TEXT,
  cid_pick_up       TEXT,
  PRIMARY KEY (date_time, master_account, service_no, truck_id, driver_id, cid_drop_off, cid_pick_up)
  FOREIGN KEY (master_account, service_no) REFERENCES service_agreements,
  FOREIGN KEY (truck_id) REFERENCES trucks,
  FOREIGN KEY (driver_id) REFERENCES drivers(pid),
  FOREIGN KEY (cid_drop_off) REFERENCES containers(container_id),
  FOREIGN KEY (cid_pick_up) REFERENCES containers(container_id)
);

--Data prepared by <Yuan Wang>,<wang17@ualberta.ca>,and published on <2018.2.6>


--trucks owned by drivers
INSERT INTO trucks VALUES('4T1BE','McLaren F1','front loader');
INSERT INTO trucks VALUES('KM8SC','Chevrolet LUV','garbage bin collector');
INSERT INTO trucks VALUES('3WKDD','Toyota Truck Xtracab SR5','front loader');
INSERT INTO trucks VALUES('JH4KA','Dodge Ram','roll-off');
INSERT INTO trucks VALUES('2FDJF','Chevrolet Blazer','roll-off');
INSERT INTO trucks VALUES('JH4DA','Chevrolet Tahoe','roll-off');
INSERT INTO trucks VALUES('3C8FY','Ford F-150','roll-off');
INSERT INTO trucks VALUES('2FDKF','Chevrolet Silverado','front loader');
INSERT INTO trucks VALUES('1D4HR','Toyota Tundra','roll-off');
INSERT INTO trucks VALUES('1F25D','Chevrolet Silverado','front loader');
INSERT INTO trucks VALUES('1ZVBP','Chevrolet Avalanche','roll-off');
INSERT INTO trucks VALUES('WP1AB','Dodge Ram Heavfy Duty','front loader');
INSERT INTO trucks VALUES('WAUAC','Ford F-Series','roll-off');
INSERT INTO trucks VALUES('2G1WF','Honda Ridgeline','garbage bin collector');
INSERT INTO trucks VALUES('3VWSE','Cadillac Escalade EXT','front loader');
INSERT INTO trucks VALUES('JHMSZ','Chevrolet Colorado','garbage bin collector');
INSERT INTO trucks VALUES('1FTRW','Chevrolet Silverado Hybrid','front loader');
INSERT INTO trucks VALUES('SCBCR','Dodge Dakota','front loader');
INSERT INTO trucks VALUES('1G8AZ','Dodge Ram 3500','garbage bin collector');
INSERT INTO trucks VALUES('ZAMGJ','Ford Explorer Sport Trac','roll-off');
INSERT INTO trucks VALUES('1HTMM','Ford','garbage bin collector');
INSERT INTO trucks VALUES('1HTNN','Ford','garbage bin collector');

--trucks owned by company
INSERT INTO trucks VALUES('1FAHP','Ford F-Series','roll-off');
INSERT INTO trucks VALUES('1FTHF','Honda Ridgeline','garbage bin collector');
INSERT INTO trucks VALUES('JTHCL','Cadillac Escalade EXT','front loader');
INSERT INTO trucks VALUES('1FD0W','Chevrolet Colorado','garbage bin collector');
INSERT INTO trucks VALUES('1G4HR','Chevrolet Silverado Hybrid','roll-off');
INSERT INTO trucks VALUES('1GBL7','Dodge Dakota','front loader');
INSERT INTO trucks VALUES('VF3BA','Dodge Ram 3500','garbage bin collector');
INSERT INTO trucks VALUES('1GTKP','Ford Explorer Sport Trac','roll-off');
INSERT INTO trucks VALUES('9BWBT','Ford','garbage bin collector');
INSERT INTO trucks VALUES('WVWUK','Ford','front loader');
INSERT INTO trucks VALUES('3A8FY','Dodge Dakota','front loader');
INSERT INTO trucks VALUES('WBAFG','Dodge Ram 3500','garbage bin collector');
INSERT INTO trucks VALUES('WAUGB','Ford Explorer Sport Trac','roll-off');
INSERT INTO trucks VALUES('1FDWX','Ford','garbage bin collector');
INSERT INTO trucks VALUES('1FTCR','Ford','front loader');
INSERT INTO trucks VALUES('JT3HN','Dodge Dakota','front loader');
INSERT INTO trucks VALUES('1FTRX','Dodge Ram 3500','garbage bin collector');
INSERT INTO trucks VALUES('1FV6J','Ford Explorer Sport Trac','roll-off');
INSERT INTO trucks VALUES('WP0CB','Ford','garbage bin collector');
INSERT INTO trucks VALUES('1C4RJ','Ford','front loader');

--maintenance_records of drivers owned trucks
INSERT INTO maintenance_records VALUES('4T1BE','2011-08-30 19:19:46','Inspection');
INSERT INTO maintenance_records VALUES('KM8SC','2014-05-05 19:05:21','Repair');
INSERT INTO maintenance_records VALUES('3WKDD','2016-04-29 02:04:22','Inspection');
INSERT INTO maintenance_records VALUES('JH4KA','2002-08-29 19:08:38','Repair');
INSERT INTO maintenance_records VALUES('2FDJF','2016-12-10 21:12:25','Inspection');
INSERT INTO maintenance_records VALUES('JH4DA','2006-10-24 11:10:56','Repair');
INSERT INTO maintenance_records VALUES('3C8FY','2005-12-02 12:12:05','Inspection');
INSERT INTO maintenance_records VALUES('2FDKF','2000-03-18 09:03:04','Repair');
INSERT INTO maintenance_records VALUES('1D4HR','2009-04-25 15:04:12','Inspection');
INSERT INTO maintenance_records VALUES('1F25D','2001-06-11 08:06:40','Repair');
INSERT INTO maintenance_records VALUES('1ZVBP','2010-05-02 06:05:28','Inspection');
INSERT INTO maintenance_records VALUES('WP1AB','2013-10-21 15:10:46','Repair');
INSERT INTO maintenance_records VALUES('WAUAC','2001-02-16 17:02:55','Inspection');
INSERT INTO maintenance_records VALUES('2G1WF','2001-06-19 10:06:53','Repair');
INSERT INTO maintenance_records VALUES('3VWSE','2001-07-04 20:07:13','Inspection');
INSERT INTO maintenance_records VALUES('JHMSZ','2005-07-12 11:07:49','Repair');
INSERT INTO maintenance_records VALUES('1FTRW','2008-06-18 13:06:43','Inspection');
INSERT INTO maintenance_records VALUES('SCBCR','2005-04-01 11:04:53','Repair');
INSERT INTO maintenance_records VALUES('1G8AZ','2016-12-07 18:12:29','Inspection');
INSERT INTO maintenance_records VALUES('ZAMGJ','2008-09-10 13:09:12','Repair');
INSERT INTO maintenance_records VALUES('1HTMM','2009-06-08 17:47:08','Inspection');
INSERT INTO maintenance_records VALUES('1HTNN','2016-01-28 09:30:52','Repair');

--maintenance_records of company owned trucks
INSERT INTO maintenance_records VALUES('1FAHP','2013-12-07 04:12:14','Inspection');
INSERT INTO maintenance_records VALUES('1FAHP','2011-06-13 12:12:45','Inspection');
INSERT INTO maintenance_records VALUES('9BWBT','2014-01-12 15:05:36','Inspection');
INSERT INTO maintenance_records VALUES('9BWBT','2017-02-25 08:26:06','Inspection');
INSERT INTO maintenance_records VALUES('9BWBT','2018-11-24 11:34:27','Inspection');
INSERT INTO maintenance_records VALUES('WVWUK','2018-12-06 14:28:27','Inspection');
INSERT INTO maintenance_records VALUES('WVWUK','2009-06-14 08:47:27','Inspection');
INSERT INTO maintenance_records VALUES('WVWUK','2012-12-21 06:36:27','Inspection');
INSERT INTO maintenance_records VALUES('VF3BA','2018-06-25 13:25:27','Repair');
INSERT INTO maintenance_records VALUES('VF3BA','2014-04-21 22:12:27','Repair');
INSERT INTO maintenance_records VALUES('JTHCL','2012-03-21 17:06:27','Inspection');
INSERT INTO maintenance_records VALUES('JTHCL','2011-12-21 16:44:27','Inspection');
INSERT INTO maintenance_records VALUES('JTHCL','2018-06-25 13:19:27','Repair');
INSERT INTO maintenance_records VALUES('1G4HR','2018-12-06 14:28:27','Inspection');
INSERT INTO maintenance_records VALUES('1G4HR','2013-02-25 08:47:27','Inspection');
INSERT INTO maintenance_records VALUES('1G4HR','2008-12-21 06:36:27','Inspection');
INSERT INTO maintenance_records VALUES('1G4HR','2018-04-13 13:25:27','Repair');
INSERT INTO maintenance_records VALUES('1G4HR','2014-02-21 22:12:27','Repair');
INSERT INTO maintenance_records VALUES('1FD0W','2017-03-14 08:47:27','Inspection');
INSERT INTO maintenance_records VALUES('1FD0W','2018-06-01 06:36:27','Inspection');
INSERT INTO maintenance_records VALUES('1FD0W','2011-04-13 13:25:27','Repair');
INSERT INTO maintenance_records VALUES('1FD0W','2015-02-21 22:12:27','Repair');
INSERT INTO maintenance_records VALUES('1FV6J','2010-04-23 09:22:28','Inspection');
INSERT INTO maintenance_records VALUES('1FV6J','2015-03-25 15:18:14','Inspection');
INSERT INTO maintenance_records VALUES('1FV6J','2013-10-30 23:07:51','Inspection');
INSERT INTO maintenance_records VALUES('1FV6J','2005-07-05 13:55:34','Repair');
INSERT INTO maintenance_records VALUES('1FV6J','2014-03-18 17:47:09','Repair');
INSERT INTO maintenance_records VALUES('WP0CB','2015-06-17 04:20:34','Inspection');
INSERT INTO maintenance_records VALUES('WP0CB','2009-01-30 06:38:52','Inspection');
INSERT INTO maintenance_records VALUES('WP0CB','2018-01-06 11:04:01','Inspection');
INSERT INTO maintenance_records VALUES('WP0CB','2013-12-27 23:25:52','Repair');
INSERT INTO maintenance_records VALUES('WP0CB','2012-10-01 10:09:02','Repair');
INSERT INTO maintenance_records VALUES('1C4RJ','2009-11-12 04:28:56','Inspection');
INSERT INTO maintenance_records VALUES('1C4RJ','2013-08-01 04:10:37','Inspection');
INSERT INTO maintenance_records VALUES('1C4RJ','2017-05-07 14:09:20','Inspection');
INSERT INTO maintenance_records VALUES('1C4RJ','2005-11-27 01:13:16','Repair');
INSERT INTO maintenance_records VALUES('1C4RJ','2008-10-18 00:23:32','Repair');
INSERT INTO maintenance_records VALUES('3A8FY','2010-01-19 11:39:37','Inspection');
INSERT INTO maintenance_records VALUES('3A8FY','2009-10-07 12:58:33','Inspection');
INSERT INTO maintenance_records VALUES('3A8FY','2017-01-20 04:39:50','Inspection');
INSERT INTO maintenance_records VALUES('3A8FY','2016-10-14 11:53:16','Repair');
INSERT INTO maintenance_records VALUES('3A8FY','2009-01-08 03:30:11','Repair');


INSERT INTO containers VALUES('2T3BF4','Auger Compactor','2015-03-10 20:42:44');
INSERT INTO containers VALUES('1M2P27','Roll-Off dumpster','2009-10-24 02:53:48');
INSERT INTO containers VALUES('5ASGRG','Closed-Topped','2016-12-10 06:14:33');
INSERT INTO containers VALUES('1FMEU1','Open-Topped','2012-04-23 09:35:36');
INSERT INTO containers VALUES('1G4AL7','Closed-Topped','2014-02-12 17:57:29');
INSERT INTO containers VALUES('3GNGK2','Roll-Off dumpster','2012-04-04 17:33:32');
INSERT INTO containers VALUES('JH2PC3','Auger Compactor','2014-08-25 16:34:39');
INSERT INTO containers VALUES('JF1AX4','Hydraulic Compactor','2017-07-19 09:48:20');
INSERT INTO containers VALUES('WA1VGA','Open-Topped','2016-02-06 12:31:12');
INSERT INTO containers VALUES('2GTHK3','Auger Compactor','2017-12-28 04:26:57');
INSERT INTO containers VALUES('JHLRE3','Closed-Topped','2011-12-05 11:47:34');
INSERT INTO containers VALUES('3FRWF7','Hydraulic Compactor','2013-08-26 10:02:35');
INSERT INTO containers VALUES('4S4BRE','Open-Topped','2002-11-10 23:35:14');
INSERT INTO containers VALUES('3C4PDC','Roll-Off dumpster','2017-03-06 06:23:54');
INSERT INTO containers VALUES('3B6WF3','Auger Compactor','2017-09-03 22:04:34');
INSERT INTO containers VALUES('3GTP1T','Roll-Off dumpster','2015-09-20 05:10:53');
INSERT INTO containers VALUES('1FDEE1','Hydraulic Compactor','2014-05-29 19:55:50');
INSERT INTO containers VALUES('WAUGGA','Closed-Topped','2015-10-16 06:04:39');
INSERT INTO containers VALUES('2HGEJ2','Open-Topped','2015-10-15 19:49:57');
INSERT INTO containers VALUES('WDDHF2','Hydraulic Compactor','2008-10-01 03:39:51');
INSERT INTO containers VALUES('JH2SC6','Hydraulic Compactor','2013-12-08 10:53:12');
INSERT INTO containers VALUES('WBAFR1','Open-Topped','2017-06-27 24:34:39');
INSERT INTO containers VALUES('KL7TN5','Hydraulic Compactor','2008-11-01 04:14:09');
INSERT INTO containers VALUES('1GCESB','Closed-Topped','2011-01-01 02:24:53');
INSERT INTO containers VALUES('4S2CG5','Open-Topped','2011-07-16 16:08:41');
INSERT INTO containers VALUES('1GCEK1','Open-Topped','2011-08-06 07:31:18');
INSERT INTO containers VALUES('1GDZ7U','Closed-Topped','2015-11-01 18:14:28');
INSERT INTO containers VALUES('WBAAM5','Auger Compactor','2009-05-28 05:18:48');
INSERT INTO containers VALUES('3C3ES4','Auger Compactor','2010-03-18 19:24:54');
INSERT INTO containers VALUES('JH4KB2','Roll-Off dumpster','2008-09-21 08:58:41');
INSERT INTO containers VALUES('1GKDT1','Roll-Off dumpster','2009-03-29 12:34:15');
INSERT INTO containers VALUES('JS1GV7','Hydraulic Compactor','2010-11-18 22:51:52');
INSERT INTO containers VALUES('1GTCT1','Closed-Topped','2012-07-17 14:07:54');


INSERT INTO containers VALUES('4S3BH6','Hydraulic Compactor','2008-10-01 03:39:51');
INSERT INTO containers VALUES('2G1FP3','Hydraulic Compactor','2013-01-01 10:53:12');
INSERT INTO containers VALUES('1FTNX2','Open-Topped','2017-06-27 24:34:39');
INSERT INTO containers VALUES('JM1NA3','Hydraulic Compactor','2008-11-01 04:14:09');
INSERT INTO containers VALUES('1C3CDW','Closed-Topped','2011-01-01 02:24:53');
INSERT INTO containers VALUES('4CDR5B','Open-Topped','2011-07-16 16:08:41');
INSERT INTO containers VALUES('1J4FT8','Open-Topped','2011-08-06 07:31:18');
INSERT INTO containers VALUES('3D7KS2','Closed-Topped','2015-11-01 18:14:28');
INSERT INTO containers VALUES('JTDBT9','Auger Compactor','2009-05-28 05:18:48');
INSERT INTO containers VALUES('2J4FY2','Auger Compactor','2010-03-18 19:24:54');
INSERT INTO containers VALUES('2FWBA2','Roll-Off dumpster','2008-09-21 08:58:41');
INSERT INTO containers VALUES('1FAFP5','Roll-Off dumpster','2009-03-29 12:34:15');
INSERT INTO containers VALUES('JTJBM7','Hydraulic Compactor','2010-11-18 22:51:52');
INSERT INTO containers VALUES('1GT5K0','Closed-Topped','2012-07-17 14:07:54');


INSERT INTO waste_types VALUES('plastic');
INSERT INTO waste_types VALUES('paper');
INSERT INTO waste_types VALUES('hazardous waste');
INSERT INTO waste_types VALUES('construction waste');
INSERT INTO waste_types VALUES('mixed waste');
INSERT INTO waste_types VALUES('metal');
INSERT INTO waste_types VALUES('compost');


INSERT INTO container_waste_types  VALUES('2T3BF4','mixed waste');
INSERT INTO container_waste_types  VALUES('1M2P27','paper');
INSERT INTO container_waste_types  VALUES('5ASGRG','mixed waste');
INSERT INTO container_waste_types  VALUES('1FMEU1','construction waste');
INSERT INTO container_waste_types  VALUES('1G4AL7','paper');
INSERT INTO container_waste_types  VALUES('3GNGK2','hazardous waste');
INSERT INTO container_waste_types  VALUES('JH2PC3','compost');
INSERT INTO container_waste_types  VALUES('JF1AX4','construction waste');
INSERT INTO container_waste_types  VALUES('WA1VGA','hazardous waste');
INSERT INTO container_waste_types  VALUES('2GTHK3','plastic');
INSERT INTO container_waste_types  VALUES('JHLRE3','hazardous waste');
INSERT INTO container_waste_types  VALUES('3FRWF7','metal');
INSERT INTO container_waste_types  VALUES('4S4BRE','construction waste');
INSERT INTO container_waste_types  VALUES('3C4PDC','hazardous waste');
INSERT INTO container_waste_types  VALUES('3B6WF3','compost');
INSERT INTO container_waste_types  VALUES('3GTP1T','plastic');
INSERT INTO container_waste_types  VALUES('1FDEE1','compost');
INSERT INTO container_waste_types  VALUES('WAUGGA','plastic');
INSERT INTO container_waste_types  VALUES('2HGEJ2','metal');
INSERT INTO container_waste_types  VALUES('WDDHF2','mixed waste');

INSERT INTO container_waste_types  VALUES('4S3BH6','hazardous waste');
INSERT INTO container_waste_types  VALUES('2G1FP3','plastic');
INSERT INTO container_waste_types  VALUES('1FTNX2','mixed waste');
INSERT INTO container_waste_types  VALUES('JM1NA3','mixed waste');
INSERT INTO container_waste_types  VALUES('1C3CDW','paper');
INSERT INTO container_waste_types  VALUES('4CDR5B','metal');
INSERT INTO container_waste_types  VALUES('1J4FT8','construction waste');
INSERT INTO container_waste_types  VALUES('3D7KS2','hazardous waste');
INSERT INTO container_waste_types  VALUES('JTDBT9','construction waste');
INSERT INTO container_waste_types  VALUES('2J4FY2','paper');
INSERT INTO container_waste_types  VALUES('2FWBA2','hazardous waste');
INSERT INTO container_waste_types  VALUES('1FAFP5','compost');
INSERT INTO container_waste_types  VALUES('JTJBM7','compost');
INSERT INTO container_waste_types  VALUES('1GT5K0','metal');
INSERT INTO container_waste_types  VALUES('1GCEK1','metal');
INSERT INTO container_waste_types  VALUES('1GCESB','hazardous waste');
INSERT INTO container_waste_types  VALUES('4S2CG5','compost');
INSERT INTO container_waste_types  VALUES('JH2SC6','compost');
INSERT INTO container_waste_types  VALUES('KL7TN5','metal');
INSERT INTO container_waste_types  VALUES('WBAFR1','metal');


--information about account managers
INSERT INTO personnel VALUES('34725','Dan Brown','matloff@sbcglobal.net','Windsor Drive','55263');
INSERT INTO personnel VALUES('42134','Charlotte Vazquez','mjewell@optonline.net','Maple Avenue','52284');
INSERT INTO personnel VALUES('16830','Grady Travis','panolex@sbcglobal.net','Hillcrest Avenue','37764');
INSERT INTO personnel VALUES('73709','Carina Herrera','phyruxus@me.com','Schoolhouse Lane','74321');
INSERT INTO personnel VALUES('15625','Cameron Baxter','harryh@icloud.com','Cambridge Court','16391');
INSERT INTO personnel VALUES('56468','Roderick Gould','policies@live.com','Elm Avenue','16046');
INSERT INTO personnel VALUES('81480','Katrina Espinoza','doormat@yahoo.com','Linden Street','55987');
INSERT INTO personnel VALUES('48660','Jeremy Dawson','devphil@yahoo.ca','Route 202','20637');
INSERT INTO personnel VALUES('36474','Kamron Ray','earmstro@outlook.com','Penn Street','83326');
INSERT INTO personnel VALUES('58123','Elliott Knapp','staikos@yahoo.com','Hickory Lane','41424');
INSERT INTO personnel VALUES('12858','Alondra Mercer','arnold@live.com','Woodland Avenue','55615');
INSERT INTO personnel VALUES('12661','Greta Garcia','jlbaumga@me.com','Route 32','88606');
INSERT INTO personnel VALUES('30173','Miracle Lopez','gemmell@yahoo.ca','Eagle Road','76445');
INSERT INTO personnel VALUES('61192','Rishi Fuentes','jbuchana@icloud.com','Pleasant Street','34776');
INSERT INTO personnel VALUES('13038','Gretchen Garza','corrada@verizon.net','Mulberry Lane','14358');
INSERT INTO personnel VALUES('83804','Nathaly Valenzuela','ilial@live.com','Fairway Drive','37181');
INSERT INTO personnel VALUES('18457','Chloe Cline','tromey@me.com','Brandywine Drive','53655');
INSERT INTO personnel VALUES('63403','Everett Chaney','cgarcia@sbcglobal.net','Ivy Court','85670');
INSERT INTO personnel VALUES('65898','Braden Odonnell','quantaman@mac.com','Lilac Lane','25573');
INSERT INTO personnel VALUES('44330','Abril Ayers','empathy@gmail.com','Delaware Avenue','60135');


--information about drivers
INSERT INTO personnel VALUES('43743','Valery Mendoza','wayward@yahoo.ca','Valley Road','50513');
INSERT INTO personnel VALUES('52994','Finley Key','wagnerch@icloud.com','Route 202','33868');
INSERT INTO personnel VALUES('50150','Zechariah Douglas','tbmaddux@optonline.net','Windsor Drive','75686');
INSERT INTO personnel VALUES('15822','Antwan Chapman','sethbrown@outlook.com','Williams Street','32844');
INSERT INTO personnel VALUES('68722','Oscar Lloyd','dobey@live.com','Brown Street','48825');
INSERT INTO personnel VALUES('37547','Kaeden Roberson','forsberg@hotmail.com','Lawrence Street','59734');
INSERT INTO personnel VALUES('16392','Arielle Nguyen','frosal@aol.com','Warren Avenue','84967');
INSERT INTO personnel VALUES('29609','Regina Higgins','burns@msn.com','Chestnut Avenue','29116');
INSERT INTO personnel VALUES('43058','Quintin Newton','cisugrad@yahoo.com','Country Club Road','31482');
INSERT INTO personnel VALUES('58256','Nina Griffith','conteb@verizon.net','Riverside Drive','63506');
INSERT INTO personnel VALUES('58753','Felipe Golden','hakim@icloud.com','Chestnut Street','69709');
INSERT INTO personnel VALUES('41024','Giuliana Maynard','dkasak@gmail.com','Route 64','88979');
INSERT INTO personnel VALUES('74406','Ryland Mercer','jbearp@att.net','Beech Street','80263');
INSERT INTO personnel VALUES('59267','Rachael Lynn','gemmell@optonline.net','Virginia Avenue','13622');
INSERT INTO personnel VALUES('63925','Israel Padilla','sjmuir@icloud.com','Creek Road','13672');
INSERT INTO personnel VALUES('17253','Trevor Stafford','rhavyn@aol.com','Sherwood Drive','67123');
INSERT INTO personnel VALUES('86923','Kaylee Ware','chrisk@aol.com','Hawthorne Lane','85030');
INSERT INTO personnel VALUES('77131','Abigail Schroeder','meinkej@msn.com','Route 17','54376');
INSERT INTO personnel VALUES('88563','Estrella David','smeier@aol.com','State Street East','26442');
INSERT INTO personnel VALUES('88569','Samir Beck','rkobes@verizon.net','Union Street','69793');
INSERT INTO personnel VALUES('23769','Steve Gates','stega@hotmail.com','Apple Street','74569');
INSERT INTO personnel VALUES('12345','Gates Steve','stega@hotmail.com','Apple Street','74569');


INSERT INTO account_managers VALUES('34725','small accounts manager','8th Street South');
INSERT INTO account_managers VALUES('42134','major accounts manager','Main Street West');
INSERT INTO account_managers VALUES('16830','medium accounts manager','Magnolia Court');
INSERT INTO account_managers VALUES('73709','medium accounts manager','Route 4');
INSERT INTO account_managers VALUES('15625','medium accounts manager','Park Avenue');
INSERT INTO account_managers VALUES('56468','major accounts manager','Westminster Drive');
INSERT INTO account_managers VALUES('81480','medium accounts manager','Spruce Avenue');
INSERT INTO account_managers VALUES('48660','major accounts manager','Atlantic Avenue');
INSERT INTO account_managers VALUES('36474','small accounts manager','2nd Avenue');
INSERT INTO account_managers VALUES('58123','major accounts manager','Ridge Street');
INSERT INTO account_managers VALUES('12858','medium accounts manager','Woodland Drive');
INSERT INTO account_managers VALUES('12661','medium accounts manager','7th Street');
INSERT INTO account_managers VALUES('30173','small accounts manager','Andover Court');
INSERT INTO account_managers VALUES('61192','major accounts manager','Windsor Drive');
INSERT INTO account_managers VALUES('13038','small accounts manager','Willow Street');
INSERT INTO account_managers VALUES('83804','medium accounts manager','5th Street East');
INSERT INTO account_managers VALUES('18457','small accounts manager','Willow Avenue');
INSERT INTO account_managers VALUES('63403','major accounts manager','3rd Street East');
INSERT INTO account_managers VALUES('65898','small accounts manager','Cottage Street');
INSERT INTO account_managers VALUES('44330','major accounts manager','Washington Avenue');


INSERT INTO drivers VALUES('43743','Single Trailer','4T1BE');
INSERT INTO drivers VALUES('52994','Single Trailer','KM8SC');
INSERT INTO drivers VALUES('50150','HAZMAT','3WKDD');
INSERT INTO drivers VALUES('15822','Doubles/Triples','JH4KA');
INSERT INTO drivers VALUES('68722','Tanker','2FDJF');
INSERT INTO drivers VALUES('37547','Single Trailer','JH4DA');
INSERT INTO drivers VALUES('16392','Doubles/Triples','3C8FY');
INSERT INTO drivers VALUES('29609','Tanker','2FDKF');
INSERT INTO drivers VALUES('43058','Single Trailer','1D4HR');
INSERT INTO drivers VALUES('58256','HAZMAT','1F25D');
INSERT INTO drivers VALUES('58753','Doubles/Triples','1ZVBP');
INSERT INTO drivers VALUES('41024','Tanker','WP1AB');
INSERT INTO drivers VALUES('74406','Doubles/Triples','WAUAC');
INSERT INTO drivers VALUES('59267','Doubles/Triples','2G1WF');
INSERT INTO drivers VALUES('63925','Tanker','3VWSE');
INSERT INTO drivers VALUES('17253','HAZMAT','JHMSZ');
INSERT INTO drivers VALUES('86923','Single Trailer','1FTRW');
INSERT INTO drivers VALUES('77131','HAZMAT','SCBCR');
INSERT INTO drivers VALUES('88563','HAZMAT','1G8AZ');
INSERT INTO drivers VALUES('88569','Tanker','ZAMGJ');
INSERT INTO drivers VALUES('23769','Doubles/Triples','1HTMM');
INSERT INTO drivers VALUES('12345','Doubles/Triples','1HTNN');


INSERT INTO accounts VALUES('87625036','34725','Rhianna Wilkinson','(201) 874-4399','residential','2006-05-19 13:16:14','2018-02-12 06:50:29',837646.52);
INSERT INTO accounts VALUES('73833854','42134','Reese Thornton','(745) 516-3060','commercial','2004-01-18 03:26:06','2013-02-09 15:56:27',893618.73);
INSERT INTO accounts VALUES('34910788','16830','Jarrett Castro','(883) 338-6912','commercial','2007-01-28 20:29:51','2019-11-06 10:14:50',658737.09);
INSERT INTO accounts VALUES('12029871','73709','Areli Lowery','(706) 692-2734','industrial','2000-08-03 20:48:36','2018-03-07 04:15:21',322370.9);
INSERT INTO accounts VALUES('85043375','15625','Lilyana Gaines','(425) 810-3987','municipal','2003-04-02 7:38:38','2016-02-10 21:45:17',111695.11);
INSERT INTO accounts VALUES('72149574','56468','Lila Sloan','(626) 284-7432','industrial','2002-11-15 12:31:42','2018-04-04 02:55:07',767403.0);
INSERT INTO accounts VALUES('23593363','34725','Alonzo Shea','(496) 102-3035','commercial','2006-07-25 10:39:12','2019-07-22 16:51:29',428144.53);
INSERT INTO accounts VALUES('47129366','48660','Luz Kim','(796) 248-8999','industrial','2002-05-03 8:23:36','2018-04-16 19:32:56',834604.63);
INSERT INTO accounts VALUES('11755945','36474','Tomas Young','(581) 306-2155','residential','2003-02-01 16:20:19','2016-11-23 19:19:38',173250.09);
INSERT INTO accounts VALUES('84319749','58123','Josue Avila','(401) 172-5651','commercial','2000-03-01 20:12:42','2015-03-18 14:02:29',640219.2);
INSERT INTO accounts VALUES('77905025','34725','Julie Herrera','(359) 306-2012','industrial','2002-01-24 17:53:26','2018-02-25 17:28:58',793215.43);
INSERT INTO accounts VALUES('86352274','12661','Jamarion Kane','(998) 516-7925','residential','2000-06-24 12:43:22','2018-03-08 15:30:36',379703.78);
INSERT INTO accounts VALUES('72061292','34725','Sidney Preston','(506) 127-2567','residential','2007-06-15 14:49:30','2020-01-19 15:13:21',413547.42);
INSERT INTO accounts VALUES('57573804','61192','Mollie Ray','(940) 530-6245','industrial','2004-04-18 19:23:38','2017-08-25 10:32:41',773982.78);
INSERT INTO accounts VALUES('55767889','13038','Alivia Crane','(893) 347-8760','municipal','2008-03-13 10:22:27','2018-01-21 08:59:22',376701.63);
INSERT INTO accounts VALUES('41074726','83804','Brodie Hobbs','(796) 508-6104','commercial','2008-07-09 18:31:51','2016-01-19 14:49:47',777713.3);
INSERT INTO accounts VALUES('34161631','18457','Sebastian Dickerson','(273) 202-5585','commercial','2008-04-29 12:13:22','2018-06-07 09:21:18',692683.04);
INSERT INTO accounts VALUES('28548963','34725','Ronald Sanchez','(473) 491-9025','residential','2004-11-09 23:12:18','2017-03-11 04:40:08',529090.23);
INSERT INTO accounts VALUES('56384545','65898','Itzel Guerrero','(287) 679-5399','industrial','2004-03-10 15:16:31','2018-02-16 18:35:46',123909.94);
INSERT INTO accounts VALUES('19924453','34725','Ahmad Cummings','(941) 357-9021','commercial','2007-11-05 13:53:05','2012-05-22 21:53:32',597017.16);


INSERT INTO service_agreements VALUES('1','87625036','Elm Avenue','hazardous waste','every Tuesday of every week','(904) 694-9532',566.45,1994);
INSERT INTO service_agreements VALUES('2','73833854','Essex Court','mixed waste','every Wednesday of every week','(947) 900-1946',657.8,1643);
INSERT INTO service_agreements VALUES('3','34910788','Circle Drive','construction waste','every Monday of every week','(149) 953-8810',360.87,1225);
INSERT INTO service_agreements VALUES('4','12029871','Delaware Avenue','hazardous waste','every Friday of every week','(306) 162-4684',464.2,1609);
INSERT INTO service_agreements VALUES('5','85043375','Atlantic Avenue','metal','every Saturday of every week','(923) 798-0938',412.44,2601);
INSERT INTO service_agreements VALUES('6','23593363','Route 4','metal','every Saturday of every week','(979) 186-4729',301.5,2687);
INSERT INTO service_agreements VALUES('7','47129366','Division Street','construction waste','every Monday of every week','(408) 705-0130',625.72,1217);
INSERT INTO service_agreements VALUES('8','11755945','Howard Street','mixed waste','every Sunday of every week','(759) 240-3008',235.79,1821);
INSERT INTO service_agreements VALUES('9','84319749','Route 6','hazardous waste','every Wednesday of every week','(664) 327-0990',326.89,1888);
INSERT INTO service_agreements VALUES('10','77905025','Jackson Avenue','compost','every Thursday of every week','(583) 636-4313',696.72,2547);
INSERT INTO service_agreements VALUES('11','86352274','Franklin Avenue','paper','every Wednesday of every week','(880) 824-2017',465.4,2867);
INSERT INTO service_agreements VALUES('12','72061292','Academy Street','mixed waste','every Thursday of every week','(812) 880-7941',200.96,2115);
INSERT INTO service_agreements VALUES('13','57573804','Hanover Court','hazardous waste','every Tuesday of every week','(663) 847-0513',515.39,2224);
INSERT INTO service_agreements VALUES('14','55767889','Route 7','compost','every Saturday of every week','(975) 365-1735',479.2,2395);
INSERT INTO service_agreements VALUES('15','41074726','Overlook Circle','hazardous waste','every Thursday of every week','(798) 925-1247',829.89,1971);
INSERT INTO service_agreements VALUES('16','34161631','Ridge Road','plastic','every Sunday of every week','(829) 690-6594',591.71,2815);
INSERT INTO service_agreements VALUES('17','28548963','Victoria Court','paper','every Friday of every week','(805) 776-6753',398.85,2820);
INSERT INTO service_agreements VALUES('18','56384545','Pin Oak Drive','compost','every Monday of every week','(202) 798-8388',408.02,1513);
INSERT INTO service_agreements VALUES('19','19924453','Hickory Street','metal','every Friday of every week','(209) 164-7895',886.99,1281);
INSERT INTO service_agreements VALUES('20','73833854','Essex Court','construction waste','every Wednesday of every week','(947) 900-1946',719.04,2108);
INSERT INTO service_agreements VALUES('21','72149574','Catherine Street','hazardous waste','every Wednesday of every week','(916) 326-7817',562.01,2615);
INSERT INTO service_agreements VALUES('22','72149574','Catherine Street','paper','every Wednesday of every week','(916) 326-7817',835.7,2455);
INSERT INTO service_agreements VALUES('23','72149574','Catherine Street','plastic','every Wednesday of every week','(916) 326-7817',256.36,1991);
INSERT INTO service_agreements VALUES('24','77905025','Jackson Avenue','hazardous waste','every Thursday of every week','(583) 636-4313',938.28,1620);
INSERT INTO service_agreements VALUES('25','77905025','Jackson Avenue','construction waste','every Thursday of every week','(583) 636-4313',649.4,1836);
INSERT INTO service_agreements VALUES('26','57573804','Hanover Court','compost','every Tuesday of every week','(663) 847-0513',394.41,1603);
INSERT INTO service_agreements VALUES('27','19924453','Hickory Street','hazardous waste','every Friday of every week','(209) 164-7895',436.22,2225);
INSERT INTO service_agreements VALUES('28','72149574','Catherine Street','paper','every Wednesday of every week','(916) 326-7817',562.01,2615);
INSERT INTO service_agreements VALUES('29','72149574','Catherine Street','compost','every Monday of every week','(916) 326-7817',835.7,2455);
INSERT INTO service_agreements VALUES('30','72149574','Catherine Street','hazardous waste','every Wednesday of every week','(916) 326-7817',256.36,1991);
INSERT INTO service_agreements VALUES('31','72149574','Catherine Street','metal','every Wednesday of every week','(916) 326-7817',562.01,2615);
INSERT INTO service_agreements VALUES('32','72149574','Catherine Street','construction waste','every Thursday of every week','(916) 326-7817',835.7,2455);
INSERT INTO service_agreements VALUES('33','72149574','Catherine Street','mixed waste','every Tuesday of every week','(916) 326-7817',256.36,1991);
INSERT INTO service_agreements VALUES('34','72149574','Catherine Street','hazardous waste','every Wednesday of every week','(916) 326-7817',562.01,2615);
INSERT INTO service_agreements VALUES('35','72149574','Catherine Street','mixed waste','every Sunday of every week','(916) 326-7817',835.7,2455);
INSERT INTO service_agreements VALUES('36','72149574','Catherine Street','mixed waste','every Wednesday of every week','(916) 326-7817',256.36,1991);
INSERT INTO service_agreements VALUES('37','12029871','Elm Avenue','hazardous waste','every Tuesday of every week','(904) 694-9532',566.45,1994);
INSERT INTO service_agreements VALUES('38','73833854','Essex Court','mixed waste','every Wednesday of every week','(947) 900-1946',657.8,1643);
INSERT INTO service_agreements VALUES('39','56384545','Circle Drive','construction waste','every Monday of every week','(149) 953-8810',360.87,1225);
INSERT INTO service_agreements VALUES('40','72149574','Delaware Avenue','hazardous waste','every Friday of every week','(306) 162-4684',464.2,1609);
INSERT INTO service_agreements VALUES('41','28548963','Atlantic Avenue','metal','every Saturday of every week','(923) 798-0938',412.44,2601);
INSERT INTO service_agreements VALUES('42','47129366','Route 4','metal','every Saturday of every week','(979) 186-4729',301.5,2687);
INSERT INTO service_agreements VALUES('43','19924453','Division Street','construction waste','every Monday of every week','(408) 705-0130',625.72,1217);
INSERT INTO service_agreements VALUES('44','72149574','Howard Street','mixed waste','every Sunday of every week','(759) 240-3008',235.79,1821);
INSERT INTO service_agreements VALUES('45','11755945','Route 6','hazardous waste','every Wednesday of every week','(664) 327-0990',326.89,1888);
INSERT INTO service_agreements VALUES('46','73833854','Jackson Avenue','compost','every Thursday of every week','(583) 636-4313',696.72,2547);
INSERT INTO service_agreements VALUES('47','77905025','Franklin Avenue','paper','every Wednesday of every week','(880) 824-2017',465.4,2867);
INSERT INTO service_agreements VALUES('48','19924453','Academy Street','mixed waste','every Thursday of every week','(812) 880-7941',200.96,2115);
INSERT INTO service_agreements VALUES('49','47129366','Hanover Court','hazardous waste','every Tuesday of every week','(663) 847-0513',515.39,2224);
INSERT INTO service_agreements VALUES('50','72149574','Route 7','compost','every Saturday of every week','(975) 365-1735',479.2,2395);
INSERT INTO service_agreements VALUES('51','11755945','Overlook Circle','hazardous waste','every Thursday of every week','(798) 925-1247',829.89,1971);
INSERT INTO service_agreements VALUES('52','19924453','Ridge Road','plastic','every Sunday of every week','(829) 690-6594',591.71,2815);
INSERT INTO service_agreements VALUES('53','23593363','Victoria Court','paper','every Friday of every week','(805) 776-6753',398.85,2820);
INSERT INTO service_agreements VALUES('54','11755945','Overlook Circle','hazardous waste','every Thursday of every week','(798) 925-1247',829.89,1971);
INSERT INTO service_agreements VALUES('55','73833854','Ridge Road','plastic','every Sunday of every week','(829) 690-6594',591.71,2815);
INSERT INTO service_agreements VALUES('56','19924453','Victoria Court','paper','every Friday of every week','(805) 776-6753',398.85,2820);
INSERT INTO service_agreements VALUES('57','28548963','Atlantic Avenue','metal','every Saturday of every week','(923) 798-0938',412.44,2601);
INSERT INTO service_agreements VALUES('58','28548963','Atlantic Avenue','metal','every Saturday of every week','(923) 798-0938',412.44,2601);
INSERT INTO service_agreements VALUES('59','28548963','Atlantic Avenue','metal','every Saturday of every week','(923) 798-0938',412.44,2601);
INSERT INTO service_agreements VALUES('60','28548963','Atlantic Avenue','metal','every Saturday of every week','(923) 798-0938',412.44,2601);
INSERT INTO service_agreements VALUES('61','11755945','Overlook Circle','hazardous waste','every Thursday of every week','(798) 925-1247',829.89,1971);
INSERT INTO service_agreements VALUES('62','11755945','Overlook Circle','hazardous waste','every Thursday of every week','(798) 925-1247',829.89,1971);

INSERT INTO service_fulfillments VALUES('2015-07-30 03:47:43','87625036','1','4T1BE','43743','2T3BF4','WDDHF2');
INSERT INTO service_fulfillments VALUES('2016-01-05 15:53:41','73833854','2','KM8SC','88569','1M2P27','2HGEJ2');
INSERT INTO service_fulfillments VALUES('2011-10-16 23:43:14','34910788','3','3WKDD','50150','5ASGRG','WAUGGA');
INSERT INTO service_fulfillments VALUES('2015-08-04 19:53:02','28548963','57','JH4KA','15822','1FMEU1','1FDEE1');
INSERT INTO service_fulfillments VALUES('2017-04-05 10:56:42','85043375','5','2FDJF','68722','3GNGK2','3GTP1T');
INSERT INTO service_fulfillments VALUES('2017-11-29 23:59:08','23593363','6','3C8FY','16392','JH2PC3','3B6WF3');
INSERT INTO service_fulfillments VALUES('2014-09-15 08:50:04','47129366','7','2FDKF','29609','JF1AX4','3C4PDC');
INSERT INTO service_fulfillments VALUES('2015-05-23 21:01:52','11755945','8','1D4HR','77131','WA1VGA','4S4BRE');
INSERT INTO service_fulfillments VALUES('2011-08-17 05:57:42','84319749','9','1F25D','58256','2GTHK3','3FRWF7');
INSERT INTO service_fulfillments VALUES('2015-11-10 04:13:37','77905025','10','1ZVBP','58753','JHLRE3','2GTHK3');
INSERT INTO service_fulfillments VALUES('2017-09-25 14:46:44','28548963','58','WP1AB','41024','3FRWF7','JHLRE3');
INSERT INTO service_fulfillments VALUES('2011-05-25 11:49:58','28548963','59','WAUAC','88569','4S4BRE','WA1VGA');
INSERT INTO service_fulfillments VALUES('2016-06-08 06:18:07','57573804','13','2G1WF','59267','3C4PDC','JF1AX4');
INSERT INTO service_fulfillments VALUES('2010-12-05 06:20:45','55767889','14','3VWSE','63925','3B6WF3','JH2PC3');
INSERT INTO service_fulfillments VALUES('2010-02-01 01:48:13','41074726','15','JHMSZ','17253','3GTP1T','3GNGK2');
INSERT INTO service_fulfillments VALUES('2012-07-01 11:60:57','34161631','16','1FTRW','86923','1FDEE1','1G4AL7');
INSERT INTO service_fulfillments VALUES('2015-06-23 11:18:42','28548963','17','SCBCR','77131','WAUGGA','1FMEU1');
INSERT INTO service_fulfillments VALUES('2016-03-05 23:54:47','56384545','18','1G8AZ','88563','2HGEJ2','5ASGRG');
INSERT INTO service_fulfillments VALUES('2015-04-03 11:15:42','19924453','19','ZAMGJ','88563','WDDHF2','1M2P27');
INSERT INTO service_fulfillments VALUES('2007-05-11 17:48:15','73833854','20','WAUAC','12345','4S3BH6','WA1VGA');
INSERT INTO service_fulfillments VALUES('2012-06-10 07:45:14','72149574','21','2G1WF','17253','2G1FP3','JF1AX4');
INSERT INTO service_fulfillments VALUES('2006-04-08 06:03:43','72149574','22','3VWSE','17253','1FTNX2','5ASGRG');
INSERT INTO service_fulfillments VALUES('2005-05-05 02:43:40','72149574','23','JHMSZ','17253','JM1NA3','3GNGK2');
INSERT INTO service_fulfillments VALUES('2008-03-08 17:01:30','77905025','24','1FTRW','86923','1C3CDW','1G4AL7');
INSERT INTO service_fulfillments VALUES('2011-10-01 07:18:26','77905025','25','SCBCR','86923','4CDR5B','1FMEU1');
INSERT INTO service_fulfillments VALUES('2015-10-23 06:42:59','57573804','26','1G8AZ','88563','4CDR5B','5ASGRG');
INSERT INTO service_fulfillments VALUES('2008-10-06 16:30:17','19924453','27','ZAMGJ','88563','5ASGRG','1M2P27');
INSERT INTO service_fulfillments VALUES('2015-04-23 22:38:37','72149574','28','1D4HR','17253','2G1FP3','5ASGRG');
INSERT INTO service_fulfillments VALUES('2016-07-23 03:16:44','72149574','29','SCBCR','17253','JM1NA3','WA1VGA');
INSERT INTO service_fulfillments VALUES('2014-01-28 05:55:54','72149574','30','1FTRW','17253','2G1FP3','1FMEU1');
INSERT INTO service_fulfillments VALUES('2016-01-08 01:44:47','72149574','31','3VWSE','17253','1FTNX2','4S4BRE');
INSERT INTO service_fulfillments VALUES('2014-12-11 10:59:01','72149574','32','3WKDD','17253','4CDR5B','3GNGK2');
INSERT INTO service_fulfillments VALUES('2016-03-22 06:10:29','72149574','33','4T1BE','17253','5ASGRG','1C3CDW');
INSERT INTO service_fulfillments VALUES('2017-09-04 22:37:28','72149574','34','1G8AZ','17253','1J4FT8','2GTHK3');
INSERT INTO service_fulfillments VALUES('2017-09-18 10:53:17','72149574','35','JHMSZ','17253','1C3CDW','1FDEE1');
INSERT INTO service_fulfillments VALUES('2014-10-27 03:53:14','72149574','36','1G8AZ','17253','3GTP1T','4S3BH6');
INSERT INTO service_fulfillments VALUES('2014-03-30 06:19:10','12029871','37','4T1BE','74406','2G1FP3','5ASGRG');
INSERT INTO service_fulfillments VALUES('2016-05-07 01:06:27','73833854','38','1ZVBP','77131','2G1FP3','1FTNX2');
INSERT INTO service_fulfillments VALUES('2016-04-08 04:57:37','56384545','39','WP1AB','58753','2G1FP3','1FTNX2');
INSERT INTO service_fulfillments VALUES('2013-09-12 13:44:18','11755945','62','WAUAC','15822','5ASGRG','1C3CDW');
INSERT INTO service_fulfillments VALUES('2013-08-09 14:22:12','28548963','41','2G1WF','23769','2G1FP3','3GNGK2');
INSERT INTO service_fulfillments VALUES('2014-01-29 07:45:57','47129366','42','3VWSE','15822','2G1FP3','1C3CDW');
INSERT INTO service_fulfillments VALUES('2013-04-12 19:03:25','28548963','60','4T1BE','12345','2G1FP3','1FTNX2');
INSERT INTO service_fulfillments VALUES('2014-02-15 11:51:01','72149574','44','1FTRW','43058','2G1FP3','1C3CDW');
INSERT INTO service_fulfillments VALUES('2015-01-17 09:01:39','11755945','45','ZAMGJ','88569','2G1FP3','JF1AX4');
INSERT INTO service_fulfillments VALUES('2013-12-06 15:21:13','73833854','46','1D4HR','23769','4CDR5B','1GDZ7U');
INSERT INTO service_fulfillments VALUES('2015-10-01 05:33:08','77905025','47','2G1WF','58753','4CDR5B','WBAAM5');
INSERT INTO service_fulfillments VALUES('2015-03-22 24:35:52','19924453','48','3WKDD','58753','4CDR5B','3C3ES4');
INSERT INTO service_fulfillments VALUES('2013-07-28 04:41:06','47129366','49','WP1AB','17253','4CDR5B','1GTCT1');
INSERT INTO service_fulfillments VALUES('2014-04-27 14:25:38','72149574','50','1ZVBP','17253','4CDR5B','JH4KB2');
INSERT INTO service_fulfillments VALUES('2015-12-01 22:05:05','11755945','51','1FTRW','23769','4CDR5B','1G4AL7');
INSERT INTO service_fulfillments VALUES('2017-08-19 11:30:42','19924453','52','1G8AZ','43743','4CDR5B','1GKDT1');
INSERT INTO service_fulfillments VALUES('2016-08-03 23:59:30','11755945','61','JHMSZ','12345','4CDR5B','JS1GV7');
INSERT INTO service_fulfillments VALUES('2016-03-25 23:59:30','11755945','54','WP1AB','41024','3FRWF7','JHLRE3');
INSERT INTO service_fulfillments VALUES('2007-04-16 23:59:30','73833854','55','WP1AB','41024','3FRWF7','JHLRE3');
INSERT INTO service_fulfillments VALUES('2014-09-25 23:59:30','19924453','56','WP1AB','41024','3FRWF7','JHLRE3');


--Data oreoared by Nikolai Teterski
INSERT INTO users VALUES('43743','driver', 'Nik', 'pass123');
