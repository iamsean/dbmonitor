create user dbmp identified by dbmp
default tablespace msy1
temporary tablespace temp;

GRANT CONNECT,
      RESOURCE,
      CREATE VIEW,
      CREATE SYNONYM   
   TO dbmp;
   
   -- 0.Data Dictionary
CREATE TABLE PLUS_DICT
(
  DICT_TYPE varchar2(10) not null,
  DICT_NAME varchar2(50) not null, -- 定議系統裡面所有會出現的縮寫字完整說明
  DICT_DESC varchar2(200),
  CONSTRAINT PLUS_DICT_PK PRIMARY KEY (DICT_TYPE, DICT_NAME)
)
TABLESPACE msy1
STORAGE ( INITIAL 50K);

Insert into DBMP.PLUS_DICT  (DICT_TYPE, DICT_NAME, DICT_DESC) Values  ('EQUIPMENT', 'SS', 'San Switch');
Insert into DBMP.PLUS_DICT  (DICT_TYPE, DICT_NAME, DICT_DESC) Values  ('EQUIPMENT', 'SW', 'Switch');
Insert into DBMP.PLUS_DICT  (DICT_TYPE, DICT_NAME, DICT_DESC) Values  ('EQUIPMENT', 'SR', 'Server');
Insert into DBMP.PLUS_DICT  (DICT_TYPE, DICT_NAME, DICT_DESC) Values  ('EQUIPMENT', 'ST', 'Storage');
Insert into DBMP.PLUS_DICT  (DICT_TYPE, DICT_NAME, DICT_DESC) Values  ('EQUIPMENT', 'TA', 'Tape Library');
Insert into DBMP.PLUS_DICT  (DICT_TYPE, DICT_NAME, DICT_DESC) Values  ('DATABASE', 'PA', 'Production');
Insert into DBMP.PLUS_DICT  (DICT_TYPE, DICT_NAME, DICT_DESC) Values  ('DATABASE', 'EA', 'Education');
Insert into DBMP.PLUS_DICT  (DICT_TYPE, DICT_NAME, DICT_DESC) Values  ('DATABASE', 'QA', 'Quality');
Insert into DBMP.PLUS_DICT  (DICT_TYPE, DICT_NAME, DICT_DESC) Values  ('DATABASE', 'DA', 'Develop');
Insert into DBMP.PLUS_DICT  (DICT_TYPE, DICT_NAME, DICT_DESC) Values  ('ETHERNET', 'LAN', 'GB Lan');
Insert into DBMP.PLUS_DICT  (DICT_TYPE, DICT_NAME, DICT_DESC) Values  ('ETHERNET', 'FIB2', '2G Fiber');
Insert into DBMP.PLUS_DICT  (DICT_TYPE, DICT_NAME, DICT_DESC) Values  ('ETHERNET', 'FIB8', '8G Fiber');


-- 1.Equipment
CREATE TABLE EQUIPMENT
( EQ_ID     varchar2(20) PRIMARY KEY, -- SER#### / SSW#### /SWI####
  EQ_NAME   varchar2(20),    -- 機房的NAMING
  EQ_TYPE   varchar2(5) not null, -- SR:Server / SW:Switch / SS:San Switch /ST:Storage /TA:Tape
  EQ_SITE   varchar2(2) not null,-- A/D/K
  EQ_LOC    varchar2(20) ,   -- 放在那個機房那個位置
  EQ_REMARK varchar2(100)  -- 補充資訊
)
TABLESPACE msy1
STORAGE ( INITIAL 50K);

Insert into DBMP.EQUIPMENT (EQ_ID, EQ_NAME, EQ_TYPE, EQ_SITE, EQ_LOC) Values ('SR0001', 'TYNBADB001', 'SR', 'A', 'G5');
Insert into DBMP.EQUIPMENT (EQ_ID, EQ_NAME, EQ_TYPE, EQ_SITE, EQ_LOC) Values ('SR0002', 'TPEDB001', 'SR', 'A', 'G4');
Insert into DBMP.EQUIPMENT (EQ_ID, EQ_NAME, EQ_TYPE, EQ_SITE, EQ_LOC) Values ('SR0003', 'TPEDB002', 'SR', 'A', 'G8');
Insert into DBMP.EQUIPMENT (EQ_ID, EQ_NAME, EQ_TYPE, EQ_SITE, EQ_LOC) Values ('SR0004', 'NYCDB001', 'SR', 'D', 'N1');
Insert into DBMP.EQUIPMENT (EQ_ID, EQ_NAME, EQ_TYPE, EQ_SITE, EQ_LOC) Values ('SR0005', 'NYCDB002', 'SR', 'D', 'N2');
Insert into DBMP.EQUIPMENT (EQ_ID, EQ_NAME, EQ_TYPE, EQ_SITE, EQ_LOC) Values ('SW0001', 'SW001', 'SW', 'A', 'YY');
Insert into DBMP.EQUIPMENT (EQ_ID, EQ_NAME, EQ_TYPE, EQ_SITE, EQ_LOC) Values ('SS0001', 'SS001', 'SS', 'A', 'WW');
Insert into DBMP.EQUIPMENT (EQ_ID, EQ_NAME, EQ_TYPE, EQ_SITE, EQ_LOC) Values ('ST0001', 'DS8300', 'ST', 'A', 'X1');
Insert into DBMP.EQUIPMENT (EQ_ID, EQ_NAME, EQ_TYPE, EQ_SITE, EQ_LOC) Values ('ST0002', 'DS8700', 'ST', 'A', 'X2');
Insert into DBMP.EQUIPMENT (EQ_ID, EQ_NAME, EQ_TYPE, EQ_SITE, EQ_LOC) Values ('TA0001', 'TS3310', 'TA', 'A', 'T1');


-- 2.Service_Master
CREATE TABLE SERVICE_MASTER
( SERVICE_ID   varchar2(20) PRIMARY KEY,  -- SOL,GLS,TOSPRO,SEDI
  SERVICE_NAME varchar2(20),   -- Shipmentonline / SEDI / .....
  SERVICE_REMARK varchar2(100) -- 補充資訊
)
TABLESPACE msy1
STORAGE ( INITIAL 50K);

Insert into DBMP.SERVICE_MASTER  (SERVICE_ID, SERVICE_NAME) Values  ('DBREPORT', 'DBREPORT');
Insert into DBMP.SERVICE_MASTER  (SERVICE_ID, SERVICE_NAME) Values  ('SOL', 'ShipmentOnline');
Insert into DBMP.SERVICE_MASTER  (SERVICE_ID, SERVICE_NAME) Values  ('HUB', 'ShipmentHUB');


-- 3.Service_Detail
CREATE TABLE SERVICE_DETAIL
(
  SERVICE_ID REFERENCES SERVICE_MASTER(SERVICE_ID) ON DELETE CASCADE,
  EQ_ID REFERENCES EQUIPMENT(EQ_ID) ON DELETE CASCADE,
  MONITOR varchar2(1),
  SERVICE_TYPE  varchar2(5), -- PA/EA/QA/DA
  DATABASE_TYPE   varchar2(10) , --ORACLE /SQLSERVER
  DATABASE_VER    VARCHAR2(20) , -- 11.2.0.4 / 2008 R2
  DATABASE_NAME   varchar2(10) , --ORCPA1
  SERVICE_NAME    varchar2(10) , --ORCPA
  DATABASE_ROLE   varchar2(1) --P/S
)
TABLESPACE msy1
STORAGE ( INITIAL 50K);

Insert into DBMP.SERVICE_DETAIL  (SERVICE_ID, EQ_ID, SERVICE_TYPE, DATABASE_TYPE, DATABASE_VER, DATABASE_NAME) Values  ('DBREPORT', 'SR0001', 'PA', 'Oracle', '11.2.0.4', 'DBREPORT');
Insert into DBMP.SERVICE_DETAIL  (SERVICE_ID, EQ_ID, SERVICE_TYPE, DATABASE_TYPE, DATABASE_VER, DATABASE_NAME, SERVICE_NAME, DATABASE_ROLE) Values  ('SOL', 'SR0002', 'PA', 'Oracle', '11.2.0.4', 'ORCPA1', 'ORCPA', 'P');
Insert into DBMP.SERVICE_DETAIL  (SERVICE_ID, EQ_ID, SERVICE_TYPE, DATABASE_TYPE, DATABASE_VER, DATABASE_NAME, SERVICE_NAME, DATABASE_ROLE) Values  ('SOL', 'SR0003', 'PA', 'Oracle', '11.2.0.4', 'ORCPA2', 'ORCPA', 'P');
Insert into DBMP.SERVICE_DETAIL  (SERVICE_ID, EQ_ID, SERVICE_TYPE, DATABASE_TYPE, DATABASE_VER, DATABASE_NAME, SERVICE_NAME, DATABASE_ROLE) Values  ('SOL', 'SR0004', 'PA', 'Oracle', '11.2.0.4', 'ORCPA1', 'ORCPA', 'S');
Insert into DBMP.SERVICE_DETAIL  (SERVICE_ID, EQ_ID, SERVICE_TYPE, DATABASE_TYPE, DATABASE_VER, DATABASE_NAME, SERVICE_NAME, DATABASE_ROLE) Values  ('SOL', 'SR0005', 'PA', 'Oracle', '11.2.0.4', 'ORCPA2', 'ORCPA', 'S');
Insert into DBMP.SERVICE_DETAIL  (SERVICE_ID, EQ_ID, SERVICE_TYPE, DATABASE_TYPE, DATABASE_VER, DATABASE_NAME) Values  ('HUB', 'SR0003', 'PA', 'Oracle', '11.2.0.4', 'HUBPB');


-- 4.Server_Detail
CREATE TABLE SERVER_DETAIL
( EQ_ID REFERENCES EQUIPMENT(EQ_ID) ON DELETE CASCADE,
  CPU  varchar2(50) ,
  RAM  varchar2(50) ,
  DISK varchar2(100),
  OS   varchar2(100),
  REMARK varchar2(100)
  )
TABLESPACE msy1
STORAGE ( INITIAL 50K);

Insert into DBMP.SERVER_DETAIL  (EQ_ID, CPU, RAM, DISK, OS) Values  ('SR0001', '4*VMware CPU', '32G', '500G', 'RHLE 6.4 x64');
Insert into DBMP.SERVER_DETAIL  (EQ_ID, CPU, RAM, OS) Values  ('SR0002', '12*P7', '256G', 'AIX 6.1');
Insert into DBMP.SERVER_DETAIL  (EQ_ID, CPU, RAM, OS) Values  ('SR0003', '10*P7', '256G', 'AIX 6.1');
Insert into DBMP.SERVER_DETAIL  (EQ_ID, CPU, RAM, OS) Values  ('SR0004', '10*P7', '256G', 'AIX 6.1');
Insert into DBMP.SERVER_DETAIL  (EQ_ID, CPU, RAM, OS) Values  ('SR0005', '10*P7', '256G', 'AIX 6.1');


-- 5.Ethernet_Master
CREATE TABLE ETHERNET_MASTER
(
   EQ_ID REFERENCES EQUIPMENT(EQ_ID) ON DELETE CASCADE,
   ENT_TYPE varchar2(5) not null, -- FIB/LAN
   ETH_ID VARCHAR2(10) PRIMARY KEY,
   MODEL VARCHAR2(20) ,  -- 卡片型號
   PORTS NUMBER,         -- 幾個PORT
   ADDR  VARCHAR2(20) ,  -- 主機插槽位置
   PART# VARCHAR2(50)    -- ibm 主機需要FRU PART NO.
)
TABLESPACE msy1
STORAGE ( INITIAL 50K);

Insert into DBMP.ETHERNET_MASTER  (EQ_ID, ENT_TYPE, ETH_ID, MODEL, PORTS, ADDR) Values  ('SR0001', 'LAN', 'ETH0001', 'Realtek', 4, 'slot2');
Insert into DBMP.ETHERNET_MASTER  (EQ_ID, ENT_TYPE, ETH_ID, MODEL, PORTS, ADDR) Values  ('SR0002', 'LAN', 'ETH0002', 'IBM', 2, 'slot1');
Insert into DBMP.ETHERNET_MASTER  (EQ_ID, ENT_TYPE, ETH_ID, MODEL, PORTS, ADDR) Values  ('SR0002', 'FIB8', 'ETH0003', 'IBM', 2, 'slot4');
Insert into DBMP.ETHERNET_MASTER  (EQ_ID, ENT_TYPE, ETH_ID, MODEL, PORTS, ADDR) Values  ('SR0003', 'LAN', 'ETH0004', 'Realtek', 4, 'slot1');
Insert into DBMP.ETHERNET_MASTER  (EQ_ID, ENT_TYPE, ETH_ID, MODEL, PORTS, ADDR) Values  ('SR0004', 'FIB8', 'ETH0005', 'IBM', 2, 'slot9');


-- 6.Ethernet_Detail
CREATE TABLE ETHERNET_DETAIL
( ETHD_ID VARCHAR2(10) PRIMARY KEY,
  ETH_ID REFERENCES ETHERNET_MASTER(ETH_ID) ON DELETE CASCADE,
  PORT_NO NUMBER , -- 卡片上的第幾個PORT
  MAC     VARCHAR2(50) , -- 注意大小寫
  IP      VARCHAR2(30) , -- xxx.xxx.xxx.xxx
  LAN     VARCHAR2(5)  , -- USER/DG/BK/MN/IC
  TRUNK   VARCHAR2(1)   -- Y
)
TABLESPACE msy1
STORAGE ( INITIAL 50K);


-- 8.Fiber_Detail
CREATE TABLE FIBER_DETAIL
(
  ETH_ID REFERENCES ETHERNET_MASTER(ETH_ID) ON DELETE CASCADE,
  PORT_NO  NUMBER,
  WWN  varchar2(50),
  FIB_ID VARCHAR2(10) PRIMARY KEY
)
TABLESPACE msy1
STORAGE ( INITIAL 50K);


-- 9.Switch_Detail
CREATE TABLE SWITCH_DETAIL
( ETHD_ID REFERENCES ETHERNET_DETAIL(ETHD_ID) ON DELETE CASCADE,
  FIB_ID REFERENCES FIBER_DETAIL (FIB_ID) ON DELETE CASCADE,
  CONNECT_SWITCH_ID REFERENCES EQUIPMENT(EQ_ID) ON DELETE CASCADE,
  CONNECT_SWITCH_PORT_NO number
)
TABLESPACE msy1
STORAGE ( INITIAL 50K);

-- 10.Zoning
CREATE TABLE ZONING
(
   ZONE_ID  VARCHAR2(10) PRIMARY KEY,
   ZONE_GROUP VARCHAR2(10) , -- 自行定議的GROUP NAME
   ZONE_NAME VARCHAR2(50),
   FROM_ALIAS VARCHAR2(50),
   FROM_FIB_ID REFERENCES FIBER_DETAIL(FIB_ID) ON DELETE CASCADE,
   TO_ALIAS VARCHAR2(50),
   TO_FIB_ID REFERENCES FIBER_DETAIL(FIB_ID) ON DELETE CASCADE
)
TABLESPACE msy1
STORAGE ( INITIAL 50K);


-- [view] Server_Info  --
create or replace view server_info as
select a.eq_id,
       eq_name,
       cpu,
       ram,
       disk,
       os,
       listagg('('||nvl(lan,'Fiber')||')'||':'||nvl(ip,wwn),';') within group (order by null) ethernet
  from equipment a, server_detail b, ethernet_master c , ethernet_detail d ,fiber_detail f
 where a.eq_id = b.eq_id
   and a.eq_id = c.eq_id
   and c.eth_id = d.eth_id(+)
   and c.eth_id = f.eth_id(+)
group by a.eq_id,
         eq_name,
         cpu,
         ram,
         disk,
         os;


EQ_NAME    CPU             RAM        DISK       OS              ETHERNET
---------- --------------- ---------- ---------- --------------- ---------------------------
NYCDB001   10*P7           256G                  AIX 6.1         FIB8:WWW2
TPEDB001   12*P7           256G                  AIX 6.1         FIB8:www1;LAN:172.16.28.12
TPEDB002   10*P7           256G                  AIX 6.1         LAN:172.16.22.33
TYNBADB001 4*VMware CPU    32G        500G       RHLE 6.4 x64    LAN:172.16.11.22



-- [view] Service_Info --
create or replace view service_info as
select a.service_name service,
       b.database_type,
       B.service_type,
       b.database_ver,
       b.database_name,
       b.service_name,
       b.database_role,
       c.eq_name,
       c.ethernet
  from service_master a , service_detail b, server_info c
 where a.service_id = b.service_id
   and b.eq_id = c.eq_id
order by service,database_name,database_role


SERVICE         DATABASE_TYPE  SERVICE_TYPE  DATABASE_VER  DATABASE_NAME SERVICE_NAME DATABASE_ROLE EQ_NAME     ETHERNET
--------------  -------------  ------------  ------------- ------------- ------------ ------------- ----------- ---------------------------------
DBREPORT        Oracle         PA            11.2.0.4      DBREPORT                                 TYNBADB001  (USER):172.16.11.22
ShipmentHUB     Oracle         PA            11.2.0.4      HUBPB                                    TPEDB002    (USER):172.16.22.33
ShipmentOnline  Oracle         PA            11.2.0.4      ORCPA1        ORCPA        P             TPEDB001    (Fiber):www1;(USER):172.16.28.12
ShipmentOnline  Oracle         PA            11.2.0.4      ORCPA1        ORCPA        S             NYCDB001    (Fiber):WWW2
ShipmentOnline  Oracle         PA            11.2.0.4      ORCPA2        ORCPA        P             TPEDB002    (USER):172.16.22.33

-- [view] Zoning Info --

CREATE OR REPLACE VIEW ZONE_INFO AS 
select zone_name,
       from_alias,
       from_fib_id,
       (select WWN from fiber_detail f where f.fib_id = z.from_fib_id) from_wwn,            
       to_alias,
       to_fib_id,
       (select WWN from fiber_detail f where f.fib_id = z.to_fib_id) to_wwn    
  from zoning z;
  
  
