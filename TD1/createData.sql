--td1 OUTILI Rayan

--ex 1b1
INSERT INTO Etudiant
(nom_etudiant,code_postal,email_etudiant)
VALUES ('Outili','06800');
--error, not enough values 

--1b2
INSERT INTO Etudiant
(nom_etudiant,code_postal,email_etudiant)
VALUES ('Outili','06800','rayan.outili@.com');
-- violation de contraintes de vérification car @ est suivi d'un point

--1b3
INSERT INTO Etudiant
(nom_etudiant,code_postal,email_etudiant)
VALUES 
('Outili','06800','rayan.o@gmail.com');
INSERT INTO Etudiant
(nom_etudiant,code_postal,email_etudiant)
VALUES 
('Marconcini','06610','maud@gmail.com');
INSERT INTO Etudiant
(nom_etudiant,code_postal,email_etudiant)
VALUES 
('Duflot','06200','raph.t@gmail.com');

--2b1
INSERT INTO Chauffeur 
(email_chauffeur,nb_places,date_permis)
VALUES
('existepas@gmail.com',5,'01-01-2022');
-- violation de contrainte d'intégrité (S2T2023_OR201305.SYS_C0060536) - clé parent introuvable

--2b2
INSERT INTO Chauffeur 
(email_chauffeur,nb_places,date_permis)
VALUES
('rayan.o@gmail.com','01-01-2022');
--nombre de valeurs insuffisant

--2b3
INSERT INTO Chauffeur 
(email_chauffeur,nb_places,date_permis)
VALUES
('rayan.o@gmail.com',3,'01-01-2022');

--3b
INSERT INTO VOYAGE
VALUES 
('100','rayan.o@gmail.com',to_date('2023/01/31 07:00','YYYY/MM/DD hh24:mi'),10);

--4b  
INSERT INTO participant
(id_voyage,email_etudiant)
VALUES('100','maud@gmail.com');

INSERT INTO participant
(id_voyage,email_etudiant)
VALUES('100','raph.t@gmail.com');

--4c
DELETE FROM Voyage
WHERE id_voyage='100';
--Les participants sont effectivement supprimés. 

--5b1
INSERT INTO ville
(code_postal,nom,distance,duree_voyage)
VALUES ('ANTIBES',20,80);
--impossible d'insérer NULL dans ("S2T2023_OR201305"."VILLE"."CODE_POSTAL")

INSERT INTO ville
(code_postal,nom,distance,duree_voyage)
VALUES ('06160','ANTIBES',20,80);

--5b2
INSERT INTO ville
(code_postal,nom,distance,duree_voyage)
VALUES ('NIC06','NICE',3,10);
--violation de contraintes (S2T2023_OR201305.CHIFFRE) de vérification


--5b3
INSERT INTO ville
(code_postal,nom,distance,duree_voyage)
VALUES ('06000','Nice centre',3,10);
--violation de contraintes (S2T2023_OR201305.SYS_C0061488) de vérification

INSERT INTO ville
(code_postal,nom,distance,duree_voyage)
VALUES ('06000','NICE CENTRE',3,10);


--5b4
INSERT INTO ville
(code_postal,nom,distance,duree_voyage)
VALUES ('06000','NICE CENTRE',3,10);
--violation de contrainte unique (S2T2023_OR201305.NOM)

INSERT INTO ville
(code_postal,nom,distance,duree_voyage)
VALUES ('06300','VIEUX NICE',4,15);

--5b5
INSERT INTO ville
(code_postal,nom,distance,duree_voyage)
VALUES ('06200','NICE OUEST',-1,15);
--violation de contraintes (S2T2023_OR201305.SYS_C0061489) de vérification

INSERT INTO ville
(code_postal,nom,distance,duree_voyage)
VALUES ('06200','NICE OUEST',3,10);

--5b6
INSERT INTO ville
(code_postal,nom,distance,duree_voyage)
VALUES ('06130','GRASSE',40,100);


--5c
INSERT INTO ville
(code_postal,nom,distance,duree_voyage)
VALUES ('06800','CAGNES-SUR-MER',8,45);

INSERT INTO ville
(code_postal,nom,distance,duree_voyage)
VALUES ('06610','LA GAUDE',15,75);

