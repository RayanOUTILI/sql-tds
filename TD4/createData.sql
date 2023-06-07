--Outili Rayan

--Td4

--ex1

--1
INSERT INTO ville
(code_postal,nom_ville,distance,duree)
VALUES('06800','CAGNES SUR MER', 9, 18);

INSERT INTO ville
(code_postal,nom_ville,distance,duree)
VALUES('06270','VILLENEUVE LOUBET', 12, 24);

-- 2
select substr(code_postal,0,2) as codep , nom_ville from VILLE;

--3
SELECT initcap(nom_etudiant) FROM etudiant;

--4  
select substr(nom_ville, 0,DECODE(instr(nom_ville,' '),0,LENGTH(nom_ville),instr(nom_ville,' '))) from ville;

--5
SELECT ROUND((distance/duree)*60) AS vitesse_en_km FROM ville;

--6
select date_heure_depart, to_char( date_heure_depart, 'day','nls_date_language=english') AS jour from voyage;

--7
select date_heure_depart, to_char(date_heure_depart, 'day') AS jour from voyage where lower(to_char( date_heure_depart, 'day')) = 'jeudi   ' ;

--ex2
set serveroutput on
begin
dbms_output.put_line('test');
end;
/

declare 
x integer;
begin
x:= &x;
dbms_output.put_line('la valeur de x est : ' || x);
end;
/

--3.1
SET SERVEROUTPUT ON
DECLARE
id varchar2(20) :='S2T2023_OR201305';
var_User varchar2(20);
m1 varchar2(20) :='qui etes-vous ?';
m2 varchar2(100) :='Bienvenue '|| id;
BEGIN
select user into VAR_USER from dual;
if id=var_user then
DBMS_OUTPUT.PUT_LINE(m2);
else
DBMS_OUTPUT.PUT_LINE(m1);
end if;
END;
/
--3.2
SET SERVEROUTPUT ON
DECLARE 
nbEtudiant integer := 0;
BEGIN
select count(username)into nbEtudiant from all_users where username like 'S2T2023_%';if mod(nbEtudiant,2) =0 then
DBMS_OUTPUT.PUT_LINE('le nombre d e�tudiant est '|| nbEtudiant || ', pair');
else
DBMS_OUTPUT.PUT_LINE('le nombre d e�tudiant est '|| nbEtudiant || ', impair');
end if;
END;
/

--4.1
SET SERVEROUTPUT ON
DECLARE
i int;
j int;
BEGIN
FOR i IN 0..10
LOOP
    FOR j IN 0..i
    LOOP
        DBMS_OUTPUT.PUT('*');    
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('');
END LOOP;
END;
/
-- 4.2
SET SERVEROUTPUT ON
DECLARE
i int ;
j varchar(30);
BEGIN
FOR i IN 1..seqvoyage.NEXTVAL
LOOP
    BEGIN 
       	SELECT email_chauffeur INTO j FROM voyage WHERE id_voyage = i;
        DBMS_OUTPUT.PUT_LINE(i || ' ' || j);    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE(i || ' VIDE');
    END;
END LOOP;
END;
/

--5
SET SERVEROUTPUT ON
Declare    
	res number:=0;
	type typNumArr10 is table of number(10);    
	Arr10prem typNumArr10;
Begin      
	Arr10prem := typNumArr10(1,2,3,4,5,6,7,8,9,10) ;    
	for i in 1..10    
    	loop
        	res := res + Arr10prem(i);
        end loop;   
        dbms_output.put_line(res);
End;
/

--6
DECLARE
v_id_voyage voyage.id_voyage%TYPE;
v_nb_participants INTEGER;
v_nom_chauffeur chauffeur.email_chauffeur%TYPE;
BEGIN    
    v_id_voyage := &v_id_voyage;
    if v_id_voyage > 8 then
          DBMS_OUTPUT.PUT_LINE('Le voyage ' || v_id_voyage || ' n''existe pas.');
    end if;    
    if v_id_voyage = 0 then
          DBMS_OUTPUT.PUT_LINE('Le voyage ' || v_id_voyage || ' n''existe pas.');    
    end if;   
   
      SELECT COUNT(*) INTO v_nb_participants FROM PARTICIPANT WHERE id_voyage = v_id_voyage;
 
    SELECT etudiant.nom_etudiant INTO v_nom_chauffeur
      FROM etudiant
      LEFT JOIN voyage ON voyage.email_chauffeur = etudiant.email_etudiant
      WHERE voyage.id_voyage = v_id_voyage;
    if v_nom_chauffeur IS NULL then
        DBMS_OUTPUT.PUT_LINE('Le voyage ' || v_id_voyage || ' n''existe pas.');
    else
        DBMS_OUTPUT.PUT_LINE('Chauffeur : ' || v_nom_chauffeur);
        DBMS_OUTPUT.PUT_LINE('Trajet : ' || v_id_voyage);
        DBMS_OUTPUT.PUT_LINE('Nombre de participants : ' || v_nb_participants);
end if;
END;
/