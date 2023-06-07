--OUTILI Rayan

--1. 
SET SERVEROUTPUT ON
DECLARE
nom ville.nom_ville%TYPE;
CURSOR ville_info IS
SELECT nom_ville FROM ville ORDER BY nom_ville;
BEGIN
OPEN ville_info ;
LOOP
FETCH ville_info INTO nom;
EXIT WHEN ville_info%NOTFOUND;
DBMS_OUTPUT.PUT_LINE('-----' || nom);
END LOOP;
CLOSE ville_info ;
END;
/

--2.
SET SERVEROUTPUT ON
BEGIN
FOR elt in (SELECT nom_ville FROM ville ORDER BY nom_ville)
loop
DBMS_OUTPUT.PUT_LINE('-----' || elt.nom_ville);
END LOOP;
END;
/

--3.

--3.2
--drop view nb_pass_voyage;
create view nb_pass_voyage as 
SELECT count(*) as nb_participants 
from participant 
join voyage on voyage.id_voyage = participant.id_voyage
group by voyage.id_voyage;

select * from nb_pass_voyage;

--3.3
SET SERVEROUTPUT ON

DECLARE 
	CURSOR c$nb_p_v IS
	SELECT * FROM nb_pass_voyage;
	t$nb_p_v c$nb_p_v%ROWTYPE;
	s$email VARCHAR2(50);
	n$nb_places INTEGER;
	id_v nb_pass_voyage.id%TYPE;
	nb nb_pass_voyage.nb%TYPE;
BEGIN
	OPEN c$nb_p_v;
	FETCH c$nb_p_v INTO t$nb_p_v;
	WHILE c$nb_p_v%FOUND LOOP
	SELECT email_chauffeur INTO s$email FROM voyage WHERE voyage.id_voyage=t$nb_p_v.id_voyage;
	DBMS_OUTPUT.PUT_LINE('Voyage ' || t$nb_p_v.id_voyage || ' : chauffeur = ' || s$email);
	SELECT nb_places INTO n$nb_places FROM chauffeur WHERE email_chauffeur=s$email;
	IF (t$nb_p_v.nb_pers-n$nb_places)>1 THEN
		DBMS_OUTPUT.PUT_LINE('!! Ce voyage a '||(t$nb_p_v.nb_pers-n$nb_places)||' passagers en trop !!');
	END IF;
	IF n$nb_places-nb=1 THEN
		DBMS_OUTPUT.PUT_LINE('!! Ce voyage a '||(n$nb_places-nb)||' passager en trop !!');
	END IF;
	FETCH c$nb_p_v INTO t$nb_p_v;
	END LOOP;
	CLOSE c$nb_p_v;
END;
/



--4
SET SERVEROUTPUT ON
DECLARE
	CURSOR participants(num number) IS
	SELECT *
	FROM participant
	WHERE id_voyage = num;
	nb_pers INT := 0;
	cout INT := 0;
	nb_voyages voyage.id_voyage%TYPE;
BEGIN
	SELECT COUNT(id_voyage) INTO nb_voyages FROM voyage;
	FOR voyage IN 1..nb_voyages
	LOOP
	BEGIN
	FOR participant_i IN participants(voyage)
	LOOP
	SELECT COUNT(p.id_voyage) INTO nb_pers FROM participant p WHERE p.id_voyage = participant_i.id_voyage;
	cout := participant_i.cout_total/nb_pers;
	DBMS_OUTPUT.PUT_LINE('Destinataire : ' || participant_i.email_participant);
	DBMS_OUTPUT.PUT_LINE('Sujet : Votre co-voiturage du ' || TO_CHAR(participant_i.date_heure_depart, 'DD/MM/YYYY HH24:MI'));
	DBMS_OUTPUT.PUT_LINE('Corps : Vous allez voyager avec le chauffeur ' || participant_i.nom_etudiant || '. Le coût total du voyage est de ' || participant_i.cout_total || '. Vous serez ' || nb_pers || ' en plus du chauffeur. Votre participation sera donc de ' || cout || '\n');
	END LOOP;
	EXCEPTION
	WHEN NO_DATA_FOUND THEN
	DBMS_OUTPUT.PUT_LINE(voyage || ' aucun voyage associé');
	END;
	END LOOP;
END;
/