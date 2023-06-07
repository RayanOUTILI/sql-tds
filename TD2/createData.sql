--TD2 OUTILI Rayan
--Requêtes SQL

--ex1
SELECT code_postal,nom_ville
FROM ville 
ORDER BY(distance) DESC;*

--ex2
SELECT DISTINCT(email_chauffeur)
FROM voyage;

--ex3
SELECT DISTINCT(email_etudiant)
FROM etudiant 
WHERE email_etudiant LIKE '_e%';

--ex4
SELECT nom_etudiant
FROM etudiant
WHERE code_postal=06160
ORDER BY (nom_etudiant);

--ex5
SELECT email_chauffeur,nb_places
FROM chauffeur
WHERE date_permis IS NOT NULL;

--ex6
SELECT nom_etudiant,nom_ville
FROM etudiant 
JOIN ville 
ON ville.code_postal=etudiant.code_postal
ORDER BY ville.nom_ville;

--ex7
SELECT nom_etudiant,nom_ville
FROM etudiant 
JOIN chauffeur
ON etudiant.email_etudiant=chauffeur.email_chauffeur
JOIN ville
ON ville.code_postal=etudiant.code_postal;

--ex8
SELECT COUNT(id_voyage)
FROM voyage;

--ex9
SELECT email_chauffeur
FROM chauffeur
WHERE date_permis = (SELECT MIN(date_permis) FROM chauffeur);

--ex10
SELECT date_heure_depart 
FROM voyage 
JOIN etudiant
ON voyage.email_chauffeur=etudiant.email_etudiant
JOIN ville
ON ville.code_postal=etudiant.code_postal
WHERE ville.nom_ville='MENTON' or ville.nom_ville='GRASSE' ;

--ex11  
SELECT chauffeur.email_chauffeur, COUNT(voyage.id_voyage) AS nb_voyages
FROM chauffeur
JOIN voyage
ON chauffeur.email_chauffeur=voyage.email_chauffeur
GROUP BY chauffeur.email_chauffeur;


--ex12
SELECT email_chauffeur
FROM chauffeur 
JOIN voyage 
ON voyage.email_chauffeur=chauffeur.email_chauffeur
WHERE email_chauffeur NOT IN(SELECT email_chauffeur FROM voyage);

--ex13  
SELECT chauffeur.email_chauffeur
FROM chauffeur
JOIN voyage 
ON chauffeur.email_chauffeur=voyage.email_chauffeur
GROUP BY chauffeur.email_chauffeur
HAVING COUNT(voyage.id_voyage)>= 3;

--ex14
SELECT DISTINCT chauffeur.email_chauffeur
FROM chauffeur
JOIN voyage
ON chauffeur.email_chauffeur=voyage.email_chauffeur
JOIN participant
ON voyage.id_voyage=participant.id_voyage
WHERE chauffeur.email_chauffeur=participant.email_etudiant;

--ex15
SELECT etudiant.nom_etudiant 
FROM etudiant 
JOIN participant
ON etudiant.email_etudiant = participant.email_etudiant 
JOIN voyage 
ON participant.id_voyage = voyage.id_voyage 
WHERE voyage.date_heure_depart = (SELECT min(voyage.date_heure_depart) FROM voyage)

--ex16
SELECT nom_etudiant
FROM etudiant 
WHERE email_etudiant NOT IN (SELECT email_etudiant FROM participant);

--ex17
SELECT email_chauffeur
FROM chauffeur
JOIN etudiant
ON etudiant.email_etudiant=chauffeur.email_chauffeur
WHERE email_chauffeur = (SELECT email_etudiant FROM participant)

SELECT DISTINCT email_chauffeur
FROM voyage voyage1
JOIN participant
ON voyage1.id_voyage=participant.id_voyage
JOIN voyage voyage2
ON participant.email_etudiant=voyage2.email_chauffeur
WHERE voyage1.email_chauffeur <> voyage2.email_chauffeur;

--ex18
SELECT voyage.id_voyage, voyage.email_chauffeur
FROM voyage
JOIN chauffeur
ON voyage.email_chauffeur = chauffeur.email_chauffeur
JOIN (SELECT id_voyage, COUNT(email_etudiant) as nb_participants
      FROM participant
      GROUP BY id_voyage) as inscrits ON voyage.id_voyage = inscrits.id_voyage
WHERE inscrits.nb_participants > chauffeur.nb_places;

--ex19
SELECT email_chauffeur
FROM voyage
WHERE to_char(date_heure_depart, 'MM/DD/YY') IN (
  SELECT to_char(date_heure_depart, 'MM/DD/YY')
  FROM voyage
  GROUP BY to_char(date_heure_depart, 'MM/DD/YY')
  HAVING COUNT(*) >= 2
)
GROUP BY email_chauffeur, to_char(date_heure_depart, 'MM/DD/YY')
HAVING COUNT(*) >= 2;

--ex20
SELECT nom_etudiant, ville1.nom_ville, ville1.nom_ville
FROM participant
JOIN etudiant ON participant.email_etudiant = etudiant.email_etudiant
JOIN voyage ON participant.id_voyage = voyage.id_voyage
JOIN chauffeur ON voyage.email_chauffeur = chauffeur.email_chauffeur
JOIN ville ville1 ON etudiant.code_postal = ville1.code_postal;


--creation de vues


CREATE VIEW voyage_par_chauffeur AS
SELECT voyage.id_voyage, chauffeur.email_chauffeur, voyage.date_heure_depart, ville.distance
FROM voyage
JOIN chauffeur
ON voyage.email_chauffeur = chauffeur.email_chauffeur
JOIN etudiant 
ON etudiant.email_etudiant=chauffeur.email_chauffeur
JOIN ville
ON ville.code_postal = etudiant.code_postal;


CREATE VIEW distance_par_chauffeur AS
SELECT chauffeur.email_chauffeur, SUM(ville.distance), MIN(voyage.date_heure_depart), MAX(voyage.date_heure_depart)
FROM voyage
JOIN chauffeur
ON voyage.email_chauffeur = chauffeur.email_chauffeur
JOIN etudiant 
ON etudiant.email_etudiant=chauffeur.email_chauffeur
JOIN ville
ON ville.code_postal = etudiant.code_postal
GROUP BY (chauffeur.email_chauffeur);
