--1.1.
create or replace trigger T_SEQVOYAGE
before insert on voyage
for each row
begin
    select SEQVOYAGE.nextval into :new.id_voyage from dual;
end;
/
--1.2. Tester.
insert into voyage (id_voyage, email_chauffeur, date_heure_depart)
values( null, 'irene@unice.fr', '11/05/2020'); 


--2.1.
create or replace trigger T_UPDATE
before update of code_postal on ville
for each row
begin
    update etudiant set code_postal = :new.code_postal where code_postal = :old.code_postal;
end;
/
--2.2. Tester.
update ville set code_postal = '06501' where NOM_VILLE = 'MENTON';


--3.1. 
create or replace trigger T_CONTRAINTE
before insert on participant
for each row
declare
chauffeur participant.email_etudiant%type;
begin
select email_chauffeur into chauffeur from voyage where id_voyage = :new.id_voyage;
if chauffeur = :new.email_etudiant then
raise_application_error (-20001,'Chauffeur ne peut pas s''inscrire à son voyage !!!');
else
dbms_output.put_line('Chauffeur inscrit à son voyage.');
end if;
end;
/
--3.2. Tester.
insert into PARTICIPANT (ID_VOYAGE, EMAIL_ETUDIANT) values (28, 'irene@unice.fr'); -- KO
insert into PARTICIPANT(ID_VOYAGE, EMAIL_ETUDIANT) values (4, 'damien@unice.fr'); -- OK 