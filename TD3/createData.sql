-- TD3 Rayan Outili

--Première partie

--1.1
ALTER TABLE etudiant add section varchar2(10);

--1.2
ALTER table etudiant add check (section in('INFO 1', 'INFO 2'))

--1.3
UPDATE etudiant 
SET section='INFO 1' 
WHERE rownum <= 5 

UPDATE etudiant 
SET section='INFO 2' 
WHERE section is null

--1.4
INSERT INTO etudiant
(email_etudiant, nom_etudiant, code_postal, section)
VALUES
('konrad.kevin@etu.unice.fr', 'Konrad', '06160', 'GEA 1')

--Nous obtenons ORA-02290: violation de contraintes (S2T2023_OR201305.SYS_C0070094) de vérification 
--car GEA 1 ne répond pas aux contraintes indiquées précédemment. 

--2.1
desc etudiant

--2.2
SELECT * 
FROM dictionary
WHERE table_name LIKE 'USER_CONS%';

-- USER_CONSTRAINTS                                                                                                                 
-- Constraint definitions on user's own tables 
-- USER_CONS_COLUMNS 
-- Information about accessible columns in constraint definitions                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
-- USER_CONS_OBJ_COLUMNS                                                                                                            
-- List of types an object column or attribute is constrained to in the tables owned by the user 

--2.3
desc USER_CONSTRAINTS; 

--2.4 
SELECT * FROM USER_CONSTRAINTS WHERE table_name LIKE 'INFO 1'

--2.5
ALTER table etudiant drop constraint SYS_C0070094;

--2.6
ALTER table etudiant add check (section in('INFO 1', 'INFO 2','GEA 1'));

--3.1
ALTER table etudiant drop constraint SYS_C0070118;

--3.2
CREATE TABLE section (section varchar2(10) PRIMARY KEY);

--3.3
INSERT INTO section select distinct section from etudiant;

--3.4
alter table etudiant add foreign key(section) references section(section); 

--3.5
INSERT INTO etudiant
VALUES('lanvin.laure@etu.unice.fr','Lanvin','06500','GEA 2');

--violation de contrainte d'intégrité (S2T2023_OR201305.SYS_C0070135) - clé parent introuvable
--Nous avons juste avant créé une contrainte de sorte à ce que la section existe dans la table section,
--or ici GEA 2 ne fait référence à aucune clé primaire dans la table section

--3.6
INSERT INTO section
VALUES('GEA 2');

--3.7
INSERT INTO etudiant
VALUES('lanvin.laure@etu.unice.fr','Lanvin','06500','GEA 2');

--4.1
SELECT USER from dual

--4.2
SELECT * from ALL_USERS;

--4.3
SELECT * from ALL_USERS WHERE USERNAME LIKE 'S2T2023_OR%';

--4.4
SELECT * FROM USER_ROLE_PRIVS;

--4.5
grant SELECT on ETUDIANT to S2T2023_PL206566; 
select * from S2T2023_PL206566.etudiant;

--4.6
grant SELECT,UPDATE,INSERT on participant to S2T2023_PL206566;

--4.7
SELECT * from USER_TAB_PRIVS where USER_TAB_PRIVS.TABLE_NAME like 'PARTICIPANT' AND owner like 'S2T2023_OR201305';

--5.1
select max(id_voyage) FROM voyage

--5.2
create sequence seqVoyage INCREMENT BY 1 START WITH 8;

--5.3
create sequence seqVoyage INCREMENT BY 1 START WITH 8;

INSERT INTO Voyage VALUES (seqVoyage.NEXTVAL,'irene@unice.fr','16/01/18',25);
INSERT INTO Participant VALUES (seqVoyage.CURRVAL,'henri@unice.fr',null);
INSERT INTO Participant VALUES (seqVoyage.CURRVAL,'chloe@unice.fr',null);

INSERT INTO Voyage VALUES (seqVoyage.NEXTVAL,'alfred@unice.fr','17/01/18',15);
INSERT INTO Participant VALUES (seqVoyage.CURRVAL,'henri@unice.fr',null);
INSERT INTO Participant VALUES (seqVoyage.CURRVAL,'chloe@unice.fr',null);

--6.1
ALTER TABLE PARTICIPANT DROP CONSTRAINT SYS_C0066747; 

ALTER TABLE PARTICIPANT
ADD CONSTRAINT cleetrangere_voyage
FOREIGN KEY (id_voyage)
REFERENCES VOYAGE(id_voyage)
ON DELETE CASCADE;  
DELETE FROM voyage WHERE id_voyage = 9;

--6.2
ALTER TABLE PARTICIPANT DROP CONSTRAINT SYS_C0070135; 
alter table etudiant add constraint contrainte_cp foreign key (code_postal) references ville(code_postal) on delete set null;




