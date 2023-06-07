--Outili Rayan

--Exercice 1
SET SERVEROUTPUT ON
CREATE OR REPLACE FUNCTION nbJours (id_voy voyage.id_voyage%TYPE)
RETURN NUMBER
IS
  nbjours NUMBER;
  date_actuelle DATE;
  date_heure_depart voyage.date_heure_depart%TYPE;
  voyage_id voyage.id_voyage%TYPE;
BEGIN
    voyage_id := id_voy;
    SELECT date_heure_depart INTO date_heure_depart FROM voyage WHERE id_voyage=id_voy;
    SELECT SYSDATE INTO date_actuelle FROM DUAL;
    nbjours := ROUND(date_heure_depart - date_actuelle);
    IF nbjours < 0 THEN 
        DBMS_OUTPUT.PUT_LINE('La date du de départ est dépassée');
    END IF;
RETURN nbjours;
END;
/

--1.2
SELECT nbJours(1) AS nbjours FROM voyage ORDER BY nbjours DESC;

--1.3
SELECT nbJours(id_voyage) AS nbjours FROM voyage ORDER BY nbjours DESC;

--Exercice 2
SET SERVEROUTPUT ON
CREATE OR REPLACE FUNCTION ResteDesPlacesVoyage_BOOL (id_voy voyage.id_voyage%TYPE)
RETURN BOOLEAN
IS
  nb_places INT;
  nb_participants INT;
  voyage_id voyage.id_voyage%TYPE;
BEGIN
    voyage_id := id_voy;
    SELECT nb_places INTO nb_places FROM chauffeur WHERE email_chauffeur=(SELECT email_chauffeur FROM voyage WHERE id_voyage=id_voy);
    SELECT count(*) INTO nb_participants FROM participant WHERE id_voyage=id_voy;
    IF nb_places > nb_participants THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
/
select ResteDesPlacesVoyage_BOOL(1) from dual;

--2.2
CREATE OR REPLACE FUNCTION ResteDesPlacesVoyage (IDV IN NUMBER)
RETURN char
IS
BEGIN
RETURN CASE
    WHEN ResteDesPlacesVoyage_BOOL(idv) THEN 'True'
    WHEN NOT ResteDesPlacesVoyage_BOOL(idv) THEN 'False'
    ELSE 'Null' END;
END;
/

--2.3
select ResteDesPlacesVoyage(1) from dual;
--Nous obtenons True

--2.4
SELECT ResteDesPlacesVoyage(id_voyage) AS nbjours FROM voyage ORDER BY nbjours DESC;


set serveroutput on 
--Exercice 3
--Nous allons maintenant écrire la procédure incription (email, idv) qui ajoutera l'étudiant concerné à un voyage. 
CREATE or replace PROCEDURE inscription (email IN VARCHAR2, idv IN NUMBER) IS
exist_etu number;
exist_voy number;
exist_part number;
etudiant_inexistant exception; 
voyage_inexistant exception; 
voyage_complet exception;
deja_inscrit exception;
BEGIN 
    --if idv > 8 or idv < 0 then return; --'Voyage inexistant';
    --end if;
    select count(*) into exist_etu from etudiant where email_etudiant = email;
    if exist_etu = 0 then raise etudiant_inexistant ;--'Etudiant inexistant'
    end if;
    select count(*) into exist_voy from voyage where id_voyage = idv;
    if exist_voy = 0 then raise voyage_inexistant;--'Voyage inexistant'
    end if;
    if ResteDesPlacesVoyage_Bool(idv) = false then raise voyage_complet; --'Voyage complet';
    end if;
    select count(*) into exist_part from participant where email_etudiant = email and id_voyage = idv;
    if exist_part > 0 then raise deja_inscrit;--'Etudiant déjà inscrit'
    end if;
    insert into participant (id_voyage,email_etudiant,participation) values (idv, email, null);
    dbms_output.put_line('insertion réalisée');
    EXCEPTION 
        when NO_DATA_FOUND then
            dbms_output.put_line('étudiant inexistant');
        when etudiant_inexistant then 
            DBMS_OUTPUT.PUT_LINE('étudiant inexistant');
        when voyage_inexistant then 
            DBMS_OUTPUT.PUT_LINE('voyage inexistant');
        when voyage_complet then 
            DBMS_OUTPUT.PUT_LINE('voyage complet');
        when deja_inscrit then 
            DBMS_OUTPUT.PUT_LINE('étudiant déjà inscrit');
END;
/
BEGIN 
     inscription('alfred@unice.fr',1);
END;

--Exercice 4 
set serveroutput on
CREATE or replace PROCEDURE inscription (email IN VARCHAR2, idv IN NUMBER) IS
exist_etu number;
exist_voy number;
exist_part number;
etudiant_inexistant exception;
voyage_inexistant exception;
voyage_complet exception;
deja_inscrit exception;
nb_participants number;
cout_t number;
participation_individuelle number;
BEGIN
    --if idv > 8 or idv < 0 then return; --'Voyage inexistant';
    --end if;
    select count(*) into exist_etu from etudiant where email_etudiant = email;
    if exist_etu = 0 then raise etudiant_inexistant ;--'Etudiant inexistant'
    end if;
    select count(*) into exist_voy from voyage where id_voyage = idv;
    if exist_voy = 0 then raise voyage_inexistant;--'Voyage inexistant'
    end if;
    if ResteDesPlacesVoyage_Bool(idv) = false then raise voyage_complet; --'Voyage complet';
    end if;
    select count(*) into exist_part from participant where email_etudiant = email and id_voyage = idv;
    if exist_part > 0 then raise deja_inscrit;--'Etudiant déjà inscrit'
    end if;
    insert into participant (id_voyage,email_etudiant,participation) values (idv, email, null);
    select count(*) into nb_participants from participant where id_voyage = idv;
    select cout_total into cout_t from voyage where id_voyage = idv;
    participation_individuelle := cout_t / nb_participants;
    update participant set participation = participation_individuelle where id_voyage = idv;
    dbms_output.put_line(email || ' est bien inscrit au voyage n°' || idv || '. Il est le ' || nb_participants || 'eme participant et sa participation sera de ' || participation_individuelle || '€.');
    EXCEPTION
        when NO_DATA_FOUND then
            dbms_output.put_line('étudiant inexistant');
        when etudiant_inexistant then
            DBMS_OUTPUT.PUT_LINE('étudiant inexistant');
        when voyage_inexistant then
            DBMS_OUTPUT.PUT_LINE('voyage inexistant');
        when voyage_complet then
            DBMS_OUTPUT.PUT_LINE('voyage complet');
        when deja_inscrit then
            DBMS_OUTPUT.PUT_LINE('étudiant déjà inscrit');
END;
/

execute inscription('alfred@unice.fr',4);
--changer de mail ou de voyage si l'étudiant est déjà inscrit ou le voyage est complet