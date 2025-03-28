CREATE TABLE persoane (
    id_persoana INT DEFAULT persoana_seq.NEXTVAL PRIMARY KEY,
    nume VARCHAR(100),
    varsta INT,
    email VARCHAR(100),
    telefon VARCHAR(10)
);
INSERT INTO persoane (nume, varsta, email, telefon) 
VALUES ('Nedelcu Daniel', 49, 'nedelcu.daniel@gmail.com', '0712345678');

INSERT INTO persoane (nume, varsta, email, telefon) 
VALUES ('Stanga Alexandru', 60, 'stanga.alexandru@gmail.com', '0712345678');

INSERT INTO persoane (nume, varsta, email, telefon) 
VALUES ('Boureanu Tudor', 19, 'boureanu.tudor@gmail.com', '0712345678');

INSERT INTO persoane (nume, varsta, email, telefon) 
VALUES ('Stan David', 20, 'stan.david@gmail.com', '0712345678');

INSERT INTO persoane (nume, varsta, email, telefon) 
VALUES ('Veisa Radu', 21, 'veisa.radu@gmail.com', '0712345678');

INSERT INTO persoane (nume, varsta, email, telefon) 
VALUES ('Dinca Mario', 20, 'dinca.mario@gmail.com', '0712345678');

INSERT INTO persoane (nume, varsta, email, telefon) 
VALUES ('Zaharia Lorin', 21, 'zaharia.lorin@gmail.com', '0712345678');

INSERT INTO persoane (nume, varsta, email, telefon) 
VALUES ('Nedelcu Vlad', 33, 'vlad.nedelcu@gmail.com', '0712345678');

INSERT INTO persoane (nume, varsta, email, telefon) 
VALUES ('Ion Popescu', 47, 'popescu.ion@gmail.com', '0712345678');

INSERT INTO persoane (nume, varsta, email, telefon) 
VALUES ('Mihail Eminescu', 55, 'eminescu.mihail@gmail.com', '0712345678');

CREATE TABLE departamente (
    id_departament INT DEFAULT departament_seq.NEXTVAL PRIMARY KEY,
    nume_departament VARCHAR(100)
);
INSERT INTO departamente (nume_departament) VALUES ('Web development');
INSERT INTO departamente (nume_departament) VALUES ('AI');
INSERT INTO departamente (nume_departament) VALUES ('Baze de date');
INSERT INTO departamente (nume_departament) VALUES ('OOP');
INSERT INTO departamente (nume_departament) VALUES ('Matematica');


CREATE TABLE grupe (
    id_grupa INT DEFAULT grupa_seq.NEXTVAL PRIMARY KEY,
    nume_grupa VARCHAR(100)
);

INSERT INTO grupe (nume_grupa) VALUES ('143');
INSERT INTO grupe (nume_grupa) VALUES ('243');
INSERT INTO grupe (nume_grupa) VALUES ('343');
INSERT INTO grupe (nume_grupa) VALUES ('142');
INSERT INTO grupe (nume_grupa) VALUES ('242');


CREATE TABLE studenti (
    id_persoana INT PRIMARY KEY,
    id_grupa INT,
    an INT CHECK (an in (1,2,3)),
    FOREIGN KEY (id_persoana) REFERENCES persoane(id_persoana),
    FOREIGN KEY (id_grupa) REFERENCES grupe(id_grupa)
);
INSERT INTO studenti (id_persoana, id_grupa, an) VALUES (3, 1, 1);
INSERT INTO studenti (id_persoana, id_grupa, an) VALUES (4, 2, 2);
INSERT INTO studenti (id_persoana, id_grupa, an) VALUES (5, 3, 3);
INSERT INTO studenti (id_persoana, id_grupa, an) VALUES (6, 5, 2);
INSERT INTO studenti (id_persoana, id_grupa, an) VALUES (7, 3, 3);


CREATE TABLE profesori (
    id_persoana INT PRIMARY KEY,
    id_departament INT,
    FOREIGN KEY (id_persoana) REFERENCES persoane(id_persoana),
    FOREIGN KEY (id_departament) REFERENCES departamente(id_departament)
);

INSERT INTO profesori (id_persoana, id_departament) VALUES (1, 1);
INSERT INTO profesori (id_persoana, id_departament) VALUES (2, 4);
INSERT INTO profesori (id_persoana, id_departament) VALUES (8, 3);
INSERT INTO profesori (id_persoana, id_departament) VALUES (9, 5);
INSERT INTO profesori (id_persoana, id_departament) VALUES (10, 2);


CREATE TABLE cluburi (
    id_club INT DEFAULT club_seq.NEXTVAL PRIMARY KEY,
    nume_club VARCHAR(100)
);

INSERT INTO cluburi (nume_club) VALUES ('Clubul de sah');
INSERT INTO cluburi (nume_club) VALUES ('Clubul de cibernetica');
INSERT INTO cluburi (nume_club) VALUES ('Clubul de arte');
INSERT INTO cluburi (nume_club) VALUES ('Clubul de jocuri video');
INSERT INTO cluburi (nume_club) VALUES ('Clubul de lectura');


CREATE TABLE membri (
    id_student INT,
    id_club INT,
    PRIMARY KEY (id_student, id_club),
    FOREIGN KEY (id_club) REFERENCES cluburi(id_club),
    FOREIGN KEY (id_student) REFERENCES studenti(id_persoana)
);

INSERT INTO membri (id_student, id_club) VALUES (3, 1);
INSERT INTO membri (id_student, id_club) VALUES (4, 2);
INSERT INTO membri (id_student, id_club) VALUES (5, 3);
INSERT INTO membri (id_student, id_club) VALUES (6, 4);
INSERT INTO membri (id_student, id_club) VALUES (7, 5);
INSERT INTO membri (id_student, id_club) VALUES (3, 2);
INSERT INTO membri (id_student, id_club) VALUES (4, 3);
INSERT INTO membri (id_student, id_club) VALUES (5, 4);
INSERT INTO membri (id_student, id_club) VALUES (6, 5);
INSERT INTO membri (id_student, id_club) VALUES (7, 1);


CREATE TABLE burse (
    id_bursa INT DEFAULT bursa_seq.NEXTVAL PRIMARY KEY,
    id_student INT,
    tip VARCHAR(20) CHECK (tip IN ('sociala', 'de performanta')),
    valoare INT,
    FOREIGN KEY (id_student) REFERENCES studenti(id_persoana)
);

INSERT INTO burse (id_student, tip, valoare) VALUES (3, 'sociala', 500);
INSERT INTO burse (id_student, tip, valoare) VALUES (5, 'de performanta', 1000);
INSERT INTO burse (id_student, tip, valoare) VALUES (4, 'sociala', 600);
INSERT INTO burse (id_student, tip, valoare) VALUES (7, 'de performanta', 1100);
INSERT INTO burse (id_student, tip, valoare) VALUES (5, 'sociala', 700);


CREATE TABLE activitati (
    id_activitate INT DEFAULT activitate_seq.NEXTVAL PRIMARY KEY,
    locatie VARCHAR(100),
    data DATE
);

INSERT INTO activitati (locatie, data) 
VALUES ('Sala Palatului', TO_DATE('2023-05-01', 'YYYY-MM-DD'));
INSERT INTO activitati (locatie, data) 
VALUES ('Gradina Botanica', TO_DATE('2023-06-01', 'YYYY-MM-DD'));
INSERT INTO activitati (locatie, data) 
VALUES ('Gradina Japoneza', TO_DATE('2023-07-01', 'YYYY-MM-DD'));
INSERT INTO activitati (locatie, data) 
VALUES ('Centrul vechi', TO_DATE('2023-08-01', 'YYYY-MM-DD'));
INSERT INTO activitati (locatie, data) 
VALUES ('Parc', TO_DATE('2023-09-01', 'YYYY-MM-DD'));


CREATE TABLE participanti (
    id_persoana INT,
    id_activitate INT,
    PRIMARY KEY (id_persoana, id_activitate),
    FOREIGN KEY (id_persoana) REFERENCES persoane(id_persoana),
    FOREIGN KEY (id_activitate) REFERENCES activitati(id_activitate)
);

INSERT INTO participanti (id_persoana, id_activitate) VALUES (1, 1);
INSERT INTO participanti (id_persoana, id_activitate) VALUES (2, 2);
INSERT INTO participanti (id_persoana, id_activitate) VALUES (7, 3);
INSERT INTO participanti (id_persoana, id_activitate) VALUES (4, 4);
INSERT INTO participanti (id_persoana, id_activitate) VALUES (5, 5);
INSERT INTO participanti (id_persoana, id_activitate) VALUES (6, 2);
INSERT INTO participanti (id_persoana, id_activitate) VALUES (5, 3);
INSERT INTO participanti (id_persoana, id_activitate) VALUES (8, 4);
INSERT INTO participanti (id_persoana, id_activitate) VALUES (1, 5);
INSERT INTO participanti (id_persoana, id_activitate) VALUES (2, 1);


CREATE TABLE proiecte_cercetare (
    id_proiect INT DEFAULT proiect_seq.NEXTVAL PRIMARY KEY,
    premiu VARCHAR(100)
);

INSERT INTO proiecte_cercetare (premiu) VALUES ('Premiul 3');
INSERT INTO proiecte_cercetare (premiu) VALUES ('Premiul 2');
INSERT INTO proiecte_cercetare (premiu) VALUES ('Premiul 1');
INSERT INTO proiecte_cercetare (premiu) VALUES ('Premiul 3');
INSERT INTO proiecte_cercetare (premiu) VALUES ('Premiul 1');


CREATE TABLE cercetari (
    id_proiect INT,
    id_profesor INT,
    PRIMARY KEY (id_proiect, id_profesor),
    FOREIGN KEY (id_proiect) REFERENCES proiecte_cercetare(id_proiect),
    FOREIGN KEY (id_profesor) REFERENCES profesori(id_persoana)
);

INSERT INTO cercetari (id_proiect, id_profesor) VALUES (1, 1);
INSERT INTO cercetari (id_proiect, id_profesor) VALUES (2, 2);
INSERT INTO cercetari (id_proiect, id_profesor) VALUES (5, 9);
INSERT INTO cercetari (id_proiect, id_profesor) VALUES (4, 10);
INSERT INTO cercetari (id_proiect, id_profesor) VALUES (5, 2);
INSERT INTO cercetari (id_proiect, id_profesor) VALUES (1, 8);
INSERT INTO cercetari (id_proiect, id_profesor) VALUES (4, 1);
INSERT INTO cercetari (id_proiect, id_profesor) VALUES (3, 9);
INSERT INTO cercetari (id_proiect, id_profesor) VALUES (2, 8);
INSERT INTO cercetari (id_proiect, id_profesor) VALUES (5, 1);


CREATE TABLE materii (
    id_materie INT DEFAULT materie_seq.NEXTVAL PRIMARY KEY,
    nume_materie VARCHAR(100),
    an INT CHECK (an IN (1, 2, 3))
);

INSERT INTO materii (nume_materie, an) VALUES ('Baze de date', 1);
INSERT INTO materii (nume_materie, an) VALUES ('Tehnici web', 2);
INSERT INTO materii (nume_materie, an) VALUES ('Programarea algoritmilor', 3);
INSERT INTO materii (nume_materie, an) VALUES ('Sisteme de operare', 1);
INSERT INTO materii (nume_materie, an) VALUES ('Structuri de date', 2);


CREATE TABLE examene (
    id_examen INT DEFAULT examen_seq.NEXTVAL PRIMARY KEY,
    id_materie INT,
    dificultate VARCHAR(10) CHECK (dificultate IN ('usoara', 'medie', 'grea')),
    data DATE,
    FOREIGN KEY (id_materie) REFERENCES materii(id_materie)
);
INSERT INTO examene (id_materie, dificultate, data) 
VALUES (1, 'usoara', TO_DATE('2023-06-15', 'YYYY-MM-DD'));
INSERT INTO examene (id_materie, dificultate, data) 
VALUES (2, 'medie', TO_DATE('2023-06-20', 'YYYY-MM-DD'));
INSERT INTO examene (id_materie, dificultate, data) 
VALUES (3, 'grea', TO_DATE('2023-06-25', 'YYYY-MM-DD'));
INSERT INTO examene (id_materie, dificultate, data) 
VALUES (2, 'usoara', TO_DATE('2023-06-30', 'YYYY-MM-DD'));
INSERT INTO examene (id_materie, dificultate, data)
 VALUES (5, 'medie', TO_DATE('2023-07-05', 'YYYY-MM-DD'));


CREATE TABLE student_examen (
    id_student INT,
    id_examen INT,
    PRIMARY KEY (id_student, id_examen),
    FOREIGN KEY (id_student) REFERENCES studenti(id_persoana),
    FOREIGN KEY (id_examen) REFERENCES examene(id_examen)
);

INSERT INTO student_examen (id_student, id_examen) VALUES (3, 1);
INSERT INTO student_examen (id_student, id_examen) VALUES (4, 2);
INSERT INTO student_examen (id_student, id_examen) VALUES (4, 4);
INSERT INTO student_examen (id_student, id_examen) VALUES (7, 5);
INSERT INTO student_examen (id_student, id_examen) VALUES (4, 5);
INSERT INTO student_examen (id_student, id_examen) VALUES (6, 2);
INSERT INTO student_examen (id_student, id_examen) VALUES (6, 4);
INSERT INTO student_examen (id_student, id_examen) VALUES (7, 3);
INSERT INTO student_examen (id_student, id_examen) VALUES (5, 3);
INSERT INTO student_examen (id_student, id_examen) VALUES (6, 5);


CREATE TABLE cursuri (
    id_grupa INT,
    id_profesor INT,
    id_materie INT,
    PRIMARY KEY (id_grupa, id_profesor, id_materie),
    FOREIGN KEY (id_grupa) REFERENCES grupe(id_grupa),
    FOREIGN KEY (id_profesor) REFERENCES profesori(id_persoana),
    FOREIGN KEY (id_materie) REFERENCES materii(id_materie)
);

INSERT INTO cursuri (id_grupa, id_profesor, id_materie) VALUES (1, 1, 1);
INSERT INTO cursuri (id_grupa, id_profesor, id_materie) VALUES (2, 2, 2);
INSERT INTO cursuri (id_grupa, id_profesor, id_materie) VALUES (3, 9, 3);
INSERT INTO cursuri (id_grupa, id_profesor, id_materie) VALUES (4, 10, 4);
INSERT INTO cursuri (id_grupa, id_profesor, id_materie) VALUES (5, 1, 5);
INSERT INTO cursuri (id_grupa, id_profesor, id_materie) VALUES (1, 8, 4);
INSERT INTO cursuri (id_grupa, id_profesor, id_materie) VALUES (2, 9, 5);
INSERT INTO cursuri (id_grupa, id_profesor, id_materie) VALUES (3, 10, 3);
INSERT INTO cursuri (id_grupa, id_profesor, id_materie) VALUES (4, 1, 4);
INSERT INTO cursuri (id_grupa, id_profesor, id_materie) VALUES (5, 2, 2);
