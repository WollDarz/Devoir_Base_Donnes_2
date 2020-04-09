/*Je veux Prosent mon travail Dari Hamza G2 17-49590040
 Moi et mon college on a penser a faire les travaux individuellement car il n'est pas bien effecace de faire ces travaux on binome c'est l'un ne peux pas desscute et voir som code on direct pas a hot distance.
Donc pour les travaux de BaseDonne2 et php on va etre sepparer on sauvgardent notre ancient progress de github dans diffrent compts
Merci de votre Comprehension. 
*/

--Q1
--1
CREATE OR REPLACE PROCEDURE ajoutPilote
(new_nopilot IN pilote.nopilot%TYPE, new_nom IN pilote.nom%TYPE, new_ville IN pilote.ville%TYPE, 
new_sal IN pilote.sal%TYPE, new_comm IN pilote.comm%TYPE, new_emb IN pilote.embauche%TYPE)
IS

CURSOR Cur IS
SELECT * FROM Pilote
WHERE new_nopilot=nopilot;

prow pilote%ROWTYPE;
e EXCEPTION;

BEGIN
    OPEN Cur;
    FETCH Cur INTO prow;
    IF Cur%FOUND THEN
        RAISE e;
    ELSE
        INSERT INTO PILOTE values( new_nopilot, new_nom, new_ville, new_sal, new_comm, new_emb);
        DBMS_OUTPUT.PUT_LINE('§§Pilote cree avec succes!§§');
    END IF;
    
EXCEPTION
    WHEN e THEN
        DBMS_OUTPUT.PUT_LINE('§§Code pilote dupilcate !§§');
END;

--2

CREATE OR REPLACE PROCEDURE supprimePilote(old_nopilot IN pilote.nopilot%TYPE) 
IS

CURSOR Cur IS
SELECT * FROM Pilote
WHERE nopilot=old_nopilot and nopilot not in(SELECT pilote FROM AFFECTATION);

prow pilote%ROWTYPE;
e EXCEPTION;

BEGIN
    OPEN Cur;
    FETCH Cur INTO prow;
    IF Cur%NOTFOUND THEN
        RAISE e;
    ELSE
        DELETE FROM PILOTE WHERE nopilot=old_nopilot;
        DBMS_OUTPUT.PUT_LINE('§§Pilote supprimé avec succès!§§');
    END IF;

EXCEPTION
    WHEN e THEN
        DBMS_OUTPUT.PUT_LINE('§§Pilote : n exist pas / affecter a un vol!§§');

END;

--3

CREATE OR REPLACE PROCEDURE affichePilote_N(n IN NUMBER) IS
CURSOR Cur IS
SELECT * FROM Pilote;

prow pilote%ROWTYPE;
e EXCEPTION;

BEGIN
    OPEN Cur;
    LOOP
        FETCH Cur INTO prow;
        IF Cur%NOTFOUND THEN
            RAISE e;
            EXIT;
        ELSIF Cur%ROWCOUNT<=n THEN
            DBMS_OUTPUT.PUT_LINE(prow.nopilot||' § '||prow.nom||' § '||prow.ville||' § '||prow.sal||' § '||prow.comm||' § '||prow.embauche||'\n');
        ELSE
            EXIT;
        END IF;
    END LOOP;
EXCEPTION
    WHEN e THEN
        DBMS_OUTPUT.PUT_LINE('pilote not found');
END;

--FONCTIONS STOCKEES

CREATE OR REPLACE FUNCTION nombreMoyenHeureVol(navion IN avion.nuavion%TYPE) RETURN NUMBER IS

CURSOR Cur IS
SELECT nbhvol FROM AVION
WHERE type in(SELECT type FROM AVION WHERE nuavion=navion);

nbh AVION.nbhvol%TYPE;
moy AVION.nbhvol%TYPE:=0;
e EXCEPTION;

BEGIN

    OPEN Cur;
    LOOP
        FETCH Cur INTO nbh;
        IF Cur%NOTFOUND THEN
            IF Cur%ROWCOUNT=0 THEN
                RAISE e;
            END IF;
            moy:=moy/Cur%ROWCOUNT;
            EXIT;
        END IF;
        moy:=moy+nbh;
    END LOOP;

EXCEPTION
    WHEN e THEN
        DBMS_OUTPUT.PUT_LINE('§§Code pilote n exist pas!§§');
    
RETURN moy;

END;


--PAQUETAGES

--1
CREATE OR REPLACE PACKAGE GEST_PILOTE IS
    PROCEDURE Affichage;
    PROCEDURE Error(npilot pilote.nopilot%TYPE);
    FUNCTION likeAh_pilote RETURN number;
    PROCEDURE Supp(npilot pilote.nopilot%TYPE);
    FUNCTION nnhm(avs avion.type%TYPE) RETURN avion.nbhvol%TYPE;
    PROCEDURE uppilote(nPilot pilote.nopilot%TYPE);
END GEST_PILOTE;

CREATE OR REPLACE PACKAGE BODY GEST_PILOTE IS
 PROCEDURE Affichage IS
    CURSOR Cur IS
    SELECT * FROM PILOTE;
    prow PILOTE%ROWTYPE;
    BEGIN
        OPEN Cur;
        LOOP
            FETCH Cur INTO prow;
            IF Cur%NOTFOUND THEN EXIT;
            ELSE
                DBMS_OUTPUT.PUT_LINE(prow.nopilot||': '||prow.nom||'  '||prow.ville||'  '||prow.sal);
            END IF;
        END LOOP;
    END;
    
    PROCEDURE Error(npilot pilote.nopilot%TYPE) IS
    CURSOR Cur IS
    SELECT * FROM PILOTE
    WHERE Nopilot=npilot;
    prow PILOTE%ROWTYPE;
    e EXCEPTION;
    BEGIN
        OPEN Cur;
        FETCH Cur INTO prow;
        IF Cur%NOTFOUND THEN
            DBMS_OUTPUT.PUT_LINE('§§Code Pilote n exist pas !§§');
        ELSE
            IF prow.comm>prow.sal THEN
                RAISE e;
            END IF;
        END IF;
    EXCEPTION
        WHEN e THEN
            DBMS_OUTPUT.PUT_LINE('§§ERREUR:La commission est plus grand que salaire!§§');
    END;
    
    FUNCTION likeAh_pilote RETURN number IS
    CURSOR Cur IS
    SELECT nopilot FROM PILOTE
    WHERE nom like 'Ah%';
    pro PILOTEw%ROWTYPE;
    nb number;
    BEGIN
        OPEN Cur;
        FETCH Cur INTO prow;
        IF Cur%FOUND THEN
            nb:=nb+1;
        END IF;
        return nb;
    END;
    
    --PROCEDURE Supp(npilot pilote.nopilot%TYPE);
    --FUNCTION nnhm(avs avion.type%TYPE) RETURN avion.nbhvol%TYPE;
    --PROCEDURE uppilote(nPilot pilote.nopilot%TYPE);
    
END GEST_PILOTE;

--2

CREATE OR REPLACE PACKAGE pkgCollectionPilote IS
    TYPE tab_Pilotes IS TABLE OF pilote.sal%TYPE;
    les_Pilotes tab_Pilotes;
    PROCEDURE garnirTabo(les_Pilotes tab_Pilotes);
    FUNCTION maximum(Sal1 pilote.sal%TYPE, Sal2 pilote.sal%TYPE) RETURN pilote.sal%TYPE;
    FUNCTION salMax(Tab tab_Pilotes) RETURN pilote.sal%TYPE;
    PROCEDURE TriTableau(Tab tab_Pilotes);
END pkgCollectionPilote;

--3


