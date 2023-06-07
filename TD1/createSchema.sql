--TD1 OUTILI Rayan 

--ex1a
create table Etudiant
(
email_etudiant varchar2(50) primary key check (email_etudiant like '%_@_%.%_'),
nom_etudiant varchar2(50) not null,
code_postal char (5)
);

select * from Etudiant;

--ex2a
create table chauffeur
(
    email_chauffeur varchar(50) primary key references Etudiant(email_etudiant),
    nb_places int not null check(nb_places>0),
    date_permis date
);

--ex3a
DROP table voyage
create table voyage
(
id_voyage varchar2(50) primary key,
email_chauffeur varchar(50) references Etudiant(email_etudiant),
date_heure date not null,
cout_total int not null
);

--ex4a
DROP table participant
create table participant
(
id_voyage varchar2(50) references voyage(id_voyage) on delete cascade,
email_etudiant varchar2(50) references etudiant(email_etudiant),
participation int,
primary key(id_voyage,email_etudiant)
);

--ex5a  
create table ville
(
    -- avec le code INSEE code_insee char(5) primary key, (j'ai laissé le code_postal en PK pour pouvoir répondre correctement aux questions du td)
    code_postal char(5) primary key, -- si on utilise le code insee en PK, il faut enlever la PK du code_postal, voire le champ entier 
    nom varchar2(50) not null check(nom=upper(nom)),
    CONSTRAINT nom UNIQUE(nom),
    distance int check(distance>=0),
    duree_voyage int check(duree_voyage>=0)
);
ALTER TABLE ville
ADD CONSTRAINT chiffre
CHECK (REGEXP_LIKE(code_postal, '^[0-9]+$'));

--avec le code insee
--ALTER TABLE ville
--ADD CONSTRAINT chiffres
--CHECK (REGEXP_LIKE(code_insee, '^[0-9]+$'));


--ex5c
-- ajout de la clé étangère en ayant inséré au préalable les données dans la table ville (cf createData ex5c)
ALTER TABLE Etudiant
ADD FOREIGN KEY(code_postal)
REFERENCES ville(code_postal);

--avec le code insee
--ALTER TABLE Etudiant
--ADD FOREIGN KEY(code_insee)    il faudrait donc également modifier la table Etudiant pour remplacer (ajouter ?) le code_insee
--REFERENCES ville(code_insee);