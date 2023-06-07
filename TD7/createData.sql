 --Rayan Outili 

--Exercice 1 
set serveroutput on
DECLARE
id voyage.id_voyage%type;
nom etudiant.nom_etudiant%type;
email chauffeur.email_chauffeur%type;
BEGIN
id := &id;
select email_chauffeur into email from voyage where voyage.id_voyage = id; 
select nom_etudiant into nom from etudiant where email_etudiant = email; DBMS_OUTPUT.PUT_LINE ('Nom: '|| nom);
EXCEPTION
WHEN no_data_found THEN dbms_output.put_line('Ce chauffeur n''existe pas !');
WHEN others THEN dbms_output.put_line('Erreur !');
END; 

--Exercice 2 
set serveroutput on
declare
email varchar2(20);
ex_trop_long exception; 
adr varchar2(20);
pragma exception_init( ex_trop_long, -6502);
email_invalide exception; 
begin
email := '&email';
if length(email) > 20 then raise ex_trop_long;
else dbms_output.put_line('adr valide !');
end if;
adr := REGEXP_SUBSTR(email, '[[:alnum:]]+\@[[:alnum:]]+\.[[:alnum:]]+');
if adr is null THEN raise email_invalide;
end if;
EXCEPTION
when ex_trop_long then
    dbms_output.put_line( 'Chaîne de caractères trop longue !') ;
when email_invalide then 
    dbms_output.put_line('Chaine invalide');
end;
/

--Exercice 3 
create or replace procedure affiche_voyages (email in varchar2) is
adr varchar2(20);
voy voyage%rowtype;
exist_voy number;
email_invalide exception; 
chauffeur_inexistant exception;
trop_long exception;
begin

adr := REGEXP_SUBSTR(email, '[[:alnum:]]+\@[[:alnum:]]+\.[[:alnum:]]+');
if adr is null THEN 
    dbms_output.put_line(email);
    raise email_invalide; end if;

if length(email) > 20 then raise trop_long; end if;

select count(*) into exist_voy from voyage where email_chauffeur = email;
    if exist_voy = 0 then 
    dbms_output.put_line(email);
    raise chauffeur_inexistant; end if;
    
dbms_output.put_line(voy.email_chauffeur);
for voy in (select * from voyage where email_chauffeur = email)
    loop 
        dbms_output.put_line(' voyage : ' || voy.id_voyage || ' depart le : ' || voy.date_heure_depart || ' cout : ' || voy.cout_total);
    end loop;
EXCEPTION
when trop_long then
    dbms_output.put_line( 'Chaîne de caractères trop longue !') ;
when email_invalide then 
    dbms_output.put_line('Chaine invalide');
when chauffeur_inexistant then
    DBMS_OUTPUT.PUT_LINE('Pas un chauffeur');
end;
/

BEGIN
AFFICHE_VOYAGES('toto');
AFFICHE_VOYAGES('toto@unice.fr');
AFFICHE_VOYAGES('alfred@unice.fr');
END; 

--Exercice 4 
create or replace PROCEDURE INSCRIPTION 
(
  EMAIL IN ETUDIANT.EMAIL_ETUDIANT%TYPE 
, IDV IN VOYAGE.ID_VOYAGE%TYPE 
) AS 
nb_participants int;
inscrit number ;
cout number ;
nom ETUDIANT.NOM_ETUDIANT%TYPE;
idvoy VOYAGE.ID_VOYAGE%TYPE;

voyage_inexistant exception; 
etudiant_inexistant exception;
voyage_complet exception; 
deja_inscrit exception;
BEGIN
  -- verif validit� param�tres
  select nom_etudiant into nom from ETUDIANT where email_etudiant = EMAIL;
  if nom is null then raise etudiant_inexistant;
	return; 
  end if;
  select id_voyage into idvoy from VOYAGE where id_voyage = IDV;
  if idvoy is null then raise voyage_inexistant;
	return; 
  end if;
  
 -- v�rifier que le voyage n'est pas plein.
  if ResteDesPlacesVoyage(IDV) = 'False' then raise voyage_complet; 
    return ;
  end if ;
  
  -- �tudiant d�j� dans le voyage ?
  select count(*) into inscrit from participant where EMAIL_ETUDIANT = EMAIL and id_voyage = IDV ;
  if( inscrit > 0 ) then raise deja_inscrit; 
    return ;
  end if ;
  
  -- tout est correct, on peut faire l'inscription
  insert into participant( id_voyage, email_etudiant ) values( IDV, EMAIL);
  
  -- nbre de participants :
  select count(*) into nb_participants  from participant where id_voyage = IDV ;
  DBMS_OUTPUT.put_line( 'Nb de participants apr�s inscription : ' || nb_participants );

  -- cout du voyage ?
  select cout_total into cout from voyage where id_voyage = IDV ;
   
  -- mise � jour des participations :
  update participant 
  set participation = cout / nb_participants
  where id_voyage = IDV ;

  dbms_output.put_line( email ||' est bien inscrit au voyage n� ' || IDV );
  dbms_output.put_line( 'Il est le ' || nb_participants || '�me participant' );
  dbms_output.put_line( 'Sa participation sera de : ' || ( cout / nb_participants ) || ' �' );
  DBMS_OUTPUT.PUT_LINE('**********************');

EXCEPTION 
when NO_DATA_FOUND then
        dbms_output.put_line('étudiant inexistant');
when voyage_inexistant then 
        DBMS_OUTPUT.PUT_LINE('voyage inexistant');
when etudiant_inexistant then 
        DBMS_OUTPUT.PUT_LINE('étudiant inexistant');
when voyage_complet then 
        DBMS_OUTPUT.PUT_LINE('voyage complet');
when deja_inscrit then 
        DBMS_OUTPUT.PUT_LINE('étudiant déjà inscrit');
END INSCRIPTION;
/

begin
-- voyage inexistant
INSCRIPTION ('alfred@unice.fr',50);
-- etudiant inexistant
INSCRIPTION('loekdd@unice.fr',50);
-- etudiant deja inscrit
INSCRIPTION ('damien@unice.fr',3);
-- inscription réussi
INSCRIPTION ('alfred@unice.fr',6);
end;
/

--EXERCICE supplémentaire
--Comme mise en application du cours sur les transactions, vous programmerez également l'échange de chauffeurs (vu en cours), sous forme de bloc anonyme et sous forme de procédure. Vous rajouterez également toutes les exceptions nécessaires.

--Bloc anonyme
set serveroutput on
DECLARE
  voyage1 voyage%ROWTYPE;
  voyage2 voyage%ROWTYPE;
  ch1 voyage.email_chauffeur%TYPE;
  ch2 voyage.email_chauffeur%TYPE;
  valider VARCHAR2(3);
  chauffeur_inexistant exception;
  voyage_inexistant exception;
  meme_chauffeur exception;
BEGIN
  select * into voyage1 from voyage where id_voyage = &n1;
  select * into voyage2 from voyage where id_voyage = &n2;
  --si un des deux voyages n'existe pas
  IF voyage1.id_voyage is null or voyage2.id_voyage is null THEN
    raise voyage_inexistant;
    return;
  END IF;

  --si un des deux chauffeurs n'existe pas
  select email_chauffeur into ch1 from voyage where id_voyage = voyage1.id_voyage;
  select email_chauffeur into ch2 from voyage where id_voyage = voyage2.id_voyage;
  IF ch1 is null or ch2 is null THEN
    raise chauffeur_inexistant;
    return;
  END IF;

  ch1 := voyage1.email_chauffeur;
  ch2 := voyage2.email_chauffeur;
  
  --si les deux chauffeurs sont les mêmes
  IF ch1 = ch2 THEN
    raise meme_chauffeur;
    return;
  END IF;

  UPDATE voyage set email_chauffeur = ch2 where id_voyage = voyage1.id_voyage;
  UPDATE voyage set email_chauffeur = ch1 where id_voyage = voyage2.id_voyage;

  valider := '&valider';

  IF valider = 'oui' THEN
  dbms_output.put_line('Chauffeurs échangés avec succès !');
    COMMIT;
  ELSE
    ROLLBACK;
  END IF;
EXCEPTION 
  WHEN chauffeur_inexistant THEN
    dbms_output.put_line('Chauffeur inexistant');
  WHEN voyage_inexistant THEN
    dbms_output.put_line('Voyage inexistant');
  WHEN meme_chauffeur THEN
    dbms_output.put_line('Les deux voyages ont le même chauffeur');
  WHEN NO_DATA_FOUND THEN 
  dbms_output.put_line('Erreur de saisie');
END;
/

--pareil mais en procédure
CREATE OR REPLACE PROCEDURE echanger_chauffeurs AS
  voyage1 voyage%ROWTYPE;
  voyage2 voyage%ROWTYPE;
  ch1 voyage.email_chauffeur%TYPE;
  ch2 voyage.email_chauffeur%TYPE;
  valider VARCHAR2(3);
  chauffeur_inexistant EXCEPTION;
  voyage_inexistant EXCEPTION;
  meme_chauffeur EXCEPTION;
BEGIN
  select * into voyage1 from voyage where id_voyage = &n1;
  select * into voyage2 from voyage where id_voyage = &n2;

  -- Si l'un des deux voyages n'existe pas
  IF voyage1.id_voyage IS NULL OR voyage2.id_voyage IS NULL THEN
    RAISE voyage_inexistant;
    RETURN;
  END IF;

  -- Si l'un des deux chauffeurs n'existe pas
  select email_chauffeur into ch1 from voyage where id_voyage = voyage1.id_voyage;
  select email_chauffeur into ch2 from voyage where id_voyage = voyage2.id_voyage;
  IF ch1 IS NULL OR ch2 IS NULL THEN
    RAISE chauffeur_inexistant;
    RETURN;
  END IF;

  ch1 := voyage1.email_chauffeur;
  ch2 := voyage2.email_chauffeur;

  -- Si les deux chauffeurs sont les mêmes
  IF ch1 = ch2 THEN
    RAISE meme_chauffeur;
    RETURN;
  END IF;

  UPDATE voyage set email_chauffeur = ch2 where id_voyage = voyage1.id_voyage;
  UPDATE voyage set email_chauffeur = ch1 where id_voyage = voyage2.id_voyage;

  valider := '&valider';

  IF valider = 'oui' THEN
    DBMS_OUTPUT.PUT_LINE('Chauffeurs échangés avec succès !');
    COMMIT;
  ELSE
    ROLLBACK;
  END IF;
EXCEPTION
  WHEN chauffeur_inexistant THEN
    DBMS_OUTPUT.PUT_LINE('Chauffeur inexistant');
  WHEN voyage_inexistant THEN
    DBMS_OUTPUT.PUT_LINE('Voyage inexistant');
  WHEN meme_chauffeur THEN
    DBMS_OUTPUT.PUT_LINE('Les deux voyages ont le même chauffeur');
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Erreur de saisie');
END;
/

begin 
echanger_chauffeurs;
end;
/