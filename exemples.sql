
/*
12.Formulați în limbaj natural și implementați 5 cereri SQL complexe ce vor utiliza, în ansamblul lor, următoarele elemente:

a) subcereri sincronizate în care intervin cel puțin 3 tabele

b) subcereri nesincronizate în clauza FROM

c) grupări de date, funcții grup, filtrare la nivel de grupuri cu subcereri nesincronizate (în clauza de HAVING) în care intervin cel puțin 3 tabele (in cadrul aceleiași cereri)

d) ordonări și utilizarea funcțiilor NVL și DECODE (în cadrul aceleiași cereri)

e) utilizarea a cel puțin 2 funcții pe șiruri de caractere, 2 funcții pe date calendaristice, a cel puțin unei expresii CASE

f) utilizarea a cel puțin 1 bloc de cerere (clauza WITH)

Observație: Într-o cerere se vor regăsi mai multe elemente dintre cele enumerate mai sus, astfel încât cele 5 cereri să le cuprindă pe toate.
*/
/*
1.	Primul cerere SQL va fi sa afisam id-ul, numele, suma valorii burselor si anul studentilor care au suma valorii burselor mai mica decat valoarea medie a burselor si numarul burselor mai mic sau egal decat numarul de examene de dificultate usoara la care au participat, in ordine descrescatoare dupa suma valorii burselor.
Vom folosi NVL deoarece vom face LEFT JOIN intre studentii si burse, pentru a nu pierde studentii care nu au bursa, astfel vom obtine studenti cu bursa cu valoare NULL pe care o vom inlocui cu 0. Vom folosi DECODE pentru a afla de studiu al studentilor (1 va fi inlocuit cu Anul I, 2 cu Anul II si 3 cu Anul III) si vom ordona descrescator dupa suma valorii burselor. De asemenea, vom folosii clausa HAVING pentru a afla care sunt studentii cu suma burselor mai mica decat media valorii burselor si pentru a afla care sunt studentii care au numarul burselor mai mic sau egal decat numarul examenelor de dificultate usoara la care au participat. Aceasta subcerere va fi una sincronizata deoarece va trebuie sa vedem pentru fiecare student numarul de examene usoare la care a participat si vor intervenii tabelele student, student_examen si examen.
Aceasta cerere foloseste functiile NVL si DECODE impreuna cu ordonare cu ORDER BY, deci indeplineste subpunctul d) si de asemenea foloseste o subcerere sincronizate in care intervin cel putin 3 tabele, deci indeplineste subpunctul a).
*/


SELECT s.id_persoana, p.nume, SUM(NVL(b.valoare, 0)) AS suma_bursa, DECODE(s.an, 1, 'Anul I', 2, 'Anul II', 3 , 'Anul III') AS an

FROM studenti s JOIN persoane p ON s.id_persoana=p.id_persoana
LEFT JOIN burse b ON s.id_persoana = b.id_student

GROUP BY p.nume, s.id_persoana, an
HAVING COUNT(b.id_bursa)<=

(SELECT COUNT(e.id_examen) 
FROM examene e JOIN student_examen se ON e.id_examen=se.id_examen JOIN studenti st ON st.id_persoana=se.id_student 
                            WHERE e.dificultate='usoara' AND st.id_persoana=s.id_persoana)

AND SUM(NVL(b.valoare, 0))<(SELECT AVG(valoare) FROM burse)
ORDER BY -suma_bursa;


/*
2.	A doua cerere va fi sa afisam id-ul si suma valorii burselor studentilor cu suma valorii burselor maxima din clubul de sah.
Pentru aceasta cerere vom avea nevoie sa gasim suma valorii burselor studentiilor din clubul de sah, apoi sa comparam aceasta cu maximul sumei valorii burselor studentilor din clubul de sah. Vom gasi suma valorii burselor studentilor din clubul de sah iar apoi ii vom alege cu ajutorul clauzei HAVING pe cei care au suma valorii burselor egala cu maximul sumei valorii burselor din clubul de sah, pe care o vom afla cu o subcerere in care alegem maximul dintre suma valorii burselor studentilor la sah.
Aceasta cerere foloseste o subcerere nesincronizata in clauza FROM din subcerere, indeplinind astfel subpunctul b), iar subcererea este in clauza HAVING si implica 4 tabele, indeplinind astfel subpunctul c).
*/

SELECT s.id_persoana, SUM(b.valoare) 

FROM studenti s LEFT JOIN burse b ON s.id_persoana=b.id_student LEFT JOIN membri m ON s.id_persoana=m.id_student LEFT JOIN cluburi c ON m.id_club=c.id_club

WHERE nume_club='Clubul de sah'

GROUP BY id_persoana,nume_club

HAVING SUM(b.valoare)=
(SELECT MAX(suma) FROM (SELECT s.id_persoana, SUM(b.valoare) as suma,c.nume_club

FROM studenti s LEFT JOIN burse b ON s.id_persoana=b.id_student LEFT JOIN membri m ON s.id_persoana=m.id_student LEFT JOIN cluburi c ON m.id_club=c.id_club

WHERE nume_club='Clubul de sah'

GROUP BY id_persoana,nume_club));

/*
3.	A treia cerere va fi sa afisam numele, departamentul si numarul de premii 1 ale profesorului care a castigat cele mai multe premii 1 la proiectele de cercetare.
Pentru aceasta cerere vom avea nevoie sa aflam numarul de premii 1 pe care le are fiecare profesor, iar apoi vom alege profesorul cu numarul maxim de premii 1. Pentru a afla numarul de premii 1 al fiecarui profesor folosim functia COUNT pe coloana premiilor pe care o vom grupa dupa nume si departament. Apoi pentru a afla profesorul cu numarul maxim de premii 1 vom compara numarul de premii 1 al fiecarui profesor cu numarul maxim de premii 1 al profesorilor prin clausa WHERE. Putem folosii tabelul obtinut mai devreme si in subcererea din clauza WHERE, deci ar fi folositor tinem minte tabelul cu clauza WITH.
Aceasta cerere foloseste clauza WITH deci indeplineste subpunctul f).
*/

WITH profesori_premii as (SELECT pe.nume,nume_departament,COUNT(premiu) as premii

FROM persoane pe JOIN profesori p ON p.id_persoana=pe.id_persoana JOIN departamente d ON d.id_departament=p.id_departament 
JOIN cercetari c ON p.id_persoana=c.id_profesor JOIN proiecte_cercetare pc ON pc.id_proiect=c.id_proiect

                            	      WHERE premiu='Premiul 1'

                            	      GROUP BY nume,nume_departament)

SELECT nume,nume_departament,premii FROM profesori_premii

WHERE premii=(SELECT MAX(premii) FROM profesori_premii);

/*
4.	A patra cerere va afisa numele studentilor, numele materiilor la care au dat examen, data examenelor, daca examenul a fost recent sau vechi, dificultatea examenului si data examenului urmator, stiind ca toate examenele se repeta pe aceeasi data an de an.
Pentru a rezolva aceasta cerere vom afla toate examenele fiecarui student si materiile la care a fost examenul, vom afisa data cu functia TO_CHAR, vom folosi expresia CASE pentru a afla daca examenul a fost recent sau vechi, verificand daca au trecut mai mult de 190 de zile de la examen pana pe data de 01-01-2024, data pe care o vom transforma in data prin functia TO_DATE, dificultatea examenului o vom afisa cu litere mari prin functia UPPER, iar data urmatorului examen o vom afla cu functia ADD_MONTHS.
Aceasta cerere foloseste 2 functii pe siruri de caractere: TO_DATE si UPPER, 2 functii pe date caractereistice:TO_CHAR, ADD_MONTHS si expresia CASE, deci indeplineste subpunctul e).
*/

SELECT p.nume, m.nume_materie, TO_CHAR(e.data, 'DD-MON-YYYY') AS data_examen,
    CASE
        WHEN TO_DATE('2024-01-01','YYYY-MM-DD')-e.data < '190' THEN 'Examen recent'
        WHEN TO_DATE('2024-01-01','YYYY-MM-DD')-e.data >= '190' THEN 'Examen vechi'
    END AS recenta_examen,
    UPPER(e.dificultate), TO_CHAR(ADD_MONTHS(e.data, 12),'DD-MON-YYYY') AS data_examen_urmator
FROM studenti s JOIN persoane p ON s.id_persoana = p.id_persoana JOIN student_examen se ON s.id_persoana = se.id_student JOIN examene e ON se.id_examen = e.id_examen JOIN materii m on m.id_materie=e.id_materie
ORDER BY p.nume, e.data;

/*
5.	Ultima cerere va fi sa afisam numele si numarul de cluburi la care participa studentii care participa la mai multe cluburi decat numarul de grupe care au curs la materia 'Baze de date'.
Pentru aceasta cerere vom afla numarul de cluburi la care participa fiecare student si il vom compara cu numarul de grupe care au curs la materia 'Baze de date' cu ajutorul clauzei HAVING.
Aceasta cerere utilizeaza o subcerere nesincronizata pe 3 tabelele in clauza HAVING, grupare de date dupa nume si functia group COUNT, deci indeplineste subpunctul c)
*/

SELECT p.nume,COUNT(c.id_club)

FROM persoane p join studenti s on p.id_persoana=s.id_persoana join membri m on s.id_persoana=m.id_student join cluburi c on  c.id_club=m.id_club

GROUP BY p.nume

HAVING COUNT(c.id_club)>(SELECT COUNT(g.id_grupa) 

FROM grupe g JOIN cursuri cr ON g.id_grupa=cr.id_grupa
 
JOIN materii mt ON cr.id_materie=mt.id_materie

                         			WHERE mt.nume_materie='Baze de date') ;


//13. Implementarea a 3 operații de actualizare și de suprimare a datelor utilizând subcereri. 
/*

1.	Stergerea activitatilor care s-au intamplat inainte de data de 30-05-2023 si de asemenea stergerea din tabelul asociativ participanti a participarea persoanelor la aceste activitati.
Pentru a putea sterge activitati, mai intai vom sterge din participanti intrarile cu id-ul activitatii egal cu id-ul activitatilor pe care le vom sterge. Activitatile pe care le vom sterge sunt cele care au data mai mica decat data 30-05-2023.
*/

DELETE FROM participanti
WHERE id_activitate=(SELECT id_activitate FROM activitati WHERE data<TO_DATE('30-05-2023','DD-MM-YYYY'));

DELETE FROM activitati
WHERE data<TO_DATE('30-05-2023','DD-MM-YYYY');

/*
2.	Actualizarea valorii burselor sociale care au valoarea mai mica decat cea mai mica valoare a unei burse de performanta, crescandu-le cu 500 RON.
Pentru aceasta actualizare vom lua toate bursele sociale care au valoarea mai mica decat valoarea minima a burselor de performanta si le vom schimba valoarea ca fiind valoarea initiala plus 500.
*/

UPDATE burse
SET valoare=valoare+500
WHERE tip='sociala' and valoare<(SELECT MIN(valoare) FROM burse WHERE tip='de performanta');

/*
3.	Actualizarea premiilor proiectelor de cercetare la care a lucrat profesorul Nedelcu Daniel, transformand premiile 3 in premii 2.
Pentru aceasta actualizare vom afla care sunt proiectele care au luat premiul 3 la care a lucrat Nedelcu Daniel si le vom schimba premiul in premiul 2.
*/

UPDATE proiecte_cercetare
SET premiu='Premiul 2'
WHERE premiu='Premiul 3' 
and id_proiect in (SELECT pc.id_proiect

   FROM proiecte_cercetare pc JOIN cercetari c ON pc.id_proiect=c.id_proiect
   JOIN profesori p on p.id_persoana=c.id_profesor JOIN persoane per on
   p.id_persoana=per.id_persoana 

                                WHERE per.nume='Nedelcu Daniel');

//14. Crearea unei vizualizări complexe. Dați un exemplu de operație LMD permisă pe vizualizarea respectivă și un exemplu de operație LMD nepermisă. 

/*
Voi crea o vizualizare care sa memoreze cererea prin care afisam id-ul, numele, grupa si anul studentilor care au la curs un profesor care a lucrat la un proiect de cercetare ce a obtinut premiul 3.
Deoarece nu exista niciun proiect care a luat premiul 3, voi insera in proiecte cercetare inca un proiect care va avea premiul 3 si in cercetari voi asocia acest proiect cu un profesor.
*/

INSERT INTO proiecte_cercetare (premiu) VALUES ('Premiul 3');
INSERT INTO cercetari (id_proiect, id_profesor) VALUES (6,8);

/* 
Pentru a face cererea vom face o subcerere in care vom gasi grupele care au cursuri cu cel putin un profesor care a lucrat la un proiect de cercetare ce a obtinut premiul 3, apoi vom afla pentru fiecare student grupa din care face parte si apoi vom verifica ca id-ul grupei sa fie printre cele obtinute din subcerere.
*/

CREATE VIEW studenti_cu_profesori_premianti AS
SELECT s.id_persoana,p.nume,s.id_grupa,s.an
FROM persoane p JOIN studenti s ON p.id_persoana=s.id_persoana JOIN grupe g on g.id_grupa=s.id_grupa 
WHERE g.id_grupa in (SELECT cr.id_grupa
FROM proiecte_cercetare pc JOIN cercetari ce ON pc.id_proiect=ce.id_proiect JOIN profesori pr on pr.id_persoana=ce.id_profesor JOIN cursuri cr on cr.id_profesor=pr.id_persoana
                        WHERE premiu='Premiul 3')
WITH CHECK OPTION;
  
//Un exemplu de operatie LMD permisa este actualizarea numelui studentilor.

UPDATE studenti_cu_profesori_premianti
SET nume='Boureanu Tudor2'
WHERE nume='Boureanu Tudor';
 
/* 
Un exemplu de operatie LMD nepermisa ar fi sa schimbam id-ul grupei studentilor. Aceasta operatie nu va merge deoarece la creearea view-ului am pus WITH CHECK OPTION, asa ca nu vom putea actualiza id-ul grupei, deoarece daca vom pune orice alta grupa, studentul nu ar mai aparea in view.
*/

UPDATE studenti_cu_profesori_premianti
SET id_grupa=4
WHERE nume='Boureanu Tudor2';

//15. Formulați în limbaj natural și implementați în SQL: o cerere ce utilizează operația outer-join pe minimum 4 tabele, o cerere ce utilizează operația division și o cerere care implementează analiza top-n

/*
1.	O cerere care utilizeaza operatia outer-join pe minimum 4 tabele ar fi sa afisam pentru fiecare student numele,anul, tipul si valoarea burselor pe care le are si examenele pe care le-a dat.
Vom folosi outer join deoarece vrem sa pastram si studentii care nu au bursa sau care nu au dat examen.
/*

SELECT 
    s.id_persoana, p.nume, s.an,
    b.tip AS tip_bursa, b.valoare,
    e.id_examen, e.dificultate, TO_CHAR(e.data, 'DD-MON-YYYY') AS data_examen 
FROM studenti s JOIN persoane p ON s.id_persoana = p.id_persoana LEFT JOIN burse b ON s.id_persoana = b.id_student
     LEFT JOIN student_examen se ON s.id_persoana = se.id_student LEFT JOIN examene e ON se.id_examen = e.id_examen;

/*
2.	O cerere care utilizeaza operatia division ar fi sa afisam studentii care au participat la toate activitatile.
Deoarece nu exista niciun student care sa indeplineasca conditia voi insera in tabelul participanti astfel incat studentul cu id-ul 5 sa fi participat la toate activitatile.
*/

INSERT INTO PARTICIPANTI (id_persoana,id_activitate) VALUES (5,2);
INSERT INTO PARTICIPANTI (id_persoana,id_activitate) VALUES (5,4);

/*
Aceasta cerere va folosi division deoarece va trebui sa verificam pentru fiecare student ca nu exista nicio activitate astfel incat sa nu fi participat studentul la ea. Vom folosi sintaxa de division cu clauza WHERE NOT EXISTS in alta clauza WHERE NOT EXISTS.
*/

SELECT s.id_persoana, p.nume
FROM studenti s JOIN persoane p ON s.id_persoana = p.id_persoana
WHERE NOT EXISTS (
    SELECT a.id_activitate
    FROM activitati a
    WHERE NOT EXISTS (
        SELECT pt.id_activitate
        FROM participanti pt
        WHERE pt.id_activitate = a.id_activitate
        AND pt.id_persoana = s.id_persoana
    )
);

/*
3.	O cerere care implementeaza analiza top-n este sa afisam id-ul, numele si anul a studentilor care au suma valorii burselor in primele 3 ordinati dupa suma valorii burselor.
Aceasta cerere foloseste analiza top-n deoarece trebuie sa afisam studentii care au suma valorii bursei in primele 3 sume de valori. Pentru a verifica aceasta conditie putem folosi functia RANK care creeaza o coloana avand valorile egale cu al catelea element ar fi ordonat dupa coloana pe care o vrem. Deoarece functia RANK la egalitate sare peste urmatoarea valoare, iar noi dorim sa gasim primele 3 valori si nu doar primele 3 sume de burse, vom folosi functia DENSE_RANK.
Vom rezolva aceasta cerere facand o subcerere care ne da pentru fiecare student id-ul,numele,anul,suma valorii bursei si o coloana in care folosim functia DENSE_RANK pentru a afla ordinea in care se afla acestea. Cererea principala va lua elementele din subcerere care au rezultatul coloanei obtinute cu DENSE_RANK<=3.
*/

SELECT id_persoana, nume, an, total_bursa

FROM (
    SELECT s.id_persoana, p.nume, s.an, SUM(b.valoare) AS total_bursa,
    DENSE_RANK() OVER (ORDER BY -SUM(b.valoare)) AS ranking

    FROM studenti s
    JOIN persoane p ON s.id_persoana = p.id_persoana
    JOIN burse b ON s.id_persoana = b.id_student

    GROUP BY s.id_persoana, p.nume, s.an
)

WHERE ranking <= 3

ORDER BY ranking;

