/* Pientä toistoja ja tämä on vscode harjoituksia ja osat on jo kopioitu tänne, ja huomioina muistutuksena on toi mysql on konffattu ja astettu kali linux, että täälä github löytyy backup ja kokonaisen verkkokauppan tiedoston.

*/


/*
SQL-perusasioista:

SELECT, FROM, WHERE

JOIN (INNER, LEFT, RIGHT, FULL OUTER)

GROUP BY, HAVING

ORDER BY

COUNT(), SUM(), AVG(), MAX(), MIN()

DISTINCT

Aliakset: AS

Subqueryt (aliakaskyselyt)

CASE-lauseet (ehdollinen logiikka)

*/


Pieni lunttilappu

-- kaksi tai useampi taulukkoa tulostettuna
SELECT * FROM Maksutavat, Tuotteet, Asiakkaat

------------------------------------
-- ALTER TABLE, jotta saldo-sarake lisätään ilman tietojen menetystä - eli lisätään taulukkon alle yksi rivi lisää
ALTER TABLE Asiakkaat
ADD COLUMN saldo DECIMAL(10,2) NOT NULL DEFAULT 0.00;

--lisätyn "Saldo" sarakkeen jälkeen niin päivitettään saldo satunnaisesti ja saldo voi olla esim. rahansakin
UPDATE Asiakkaat
SET saldo = ROUND(RAND() * 50000, 2);

-- päivitettään asiakkaiden saldo lisäämällä 10% jos saldo on alle 5000
UPDATE Asiakkaat SET saldo = saldo * 1.1 
WHERE saldo < 5000;

------------------------------------

-- lisätään 5 uutta henkilöä "Asiakkaan" taulukkoon - käytettään "INSERT INTO" - KOMENTOA

INSERT INTO Asiakkaat (nimi, sähköposti, osoite, rekisteröitymis_pvm, saldo) VALUES 
('William Taylor', 'william@example.com', 'Manchester, UK', '2025-05-22', ROUND(RAND() * 50000, 2)),
('Sophia Garcia', 'sophia@example.com', 'Madrid, Spain', '2023-07-15', ROUND(RAND() * 50000, 2)),
('James Anderson', 'james@example.com', 'Berlin, Germany', '2024-10-30', ROUND(RAND() * 50000, 2)),
('Olivia White', 'olivia@example.com', 'Paris, France', '2022-12-05', ROUND(RAND() * 50000, 2)),
('Daniel Lee', 'daniel@example.com', 'Tokyo, Japan', '2023-03-18', ROUND(RAND() * 50000, 2));


-- yksittäisen käyttäjän lisääminen ilman satunnaista lukua, et syöttää saldon itse
INSERT INTO Asiakkaat (nimi, sähköposti, osoite, rekisteröitymis_pvm, saldo) VALUES 
('Harry Shadows', 'harry@example.com', 'Newcastle, UK', '2005-07-13', 9999.00);

-- 5 henkilöä lisää ja rekisteröiymis pv n. 2000 - 2025 väliltä
INSERT INTO Asiakkaat (nimi, sähköposti, osoite, rekisteröitymis_pvm, saldo) VALUES 
('Nathan Reed', 'nathan@example.com', 'Dallas, USA', DATE_SUB('2025-12-31', INTERVAL FLOOR(RAND() * 9490) DAY), ROUND(RAND() * 50000, 2)),
('Isabella Evans', 'isabella@example.com', 'Auckland, New Zealand', DATE_SUB('2025-12-31', INTERVAL FLOOR(RAND() * 9490) DAY), ROUND(RAND() * 50000, 2)),
('Ethan Hall', 'ethan@example.com', 'Toronto, Canada', DATE_SUB('2025-12-31', INTERVAL FLOOR(RAND() * 9490) DAY), ROUND(RAND() * 50000, 2)),
('Lily Adams', 'lily@example.com', 'Berlin, Germany', DATE_SUB('2025-12-31', INTERVAL FLOOR(RAND() * 9490) DAY), ROUND(RAND() * 50000, 2)),
('Jackson Murphy', 'jackson@example.com', 'Sydney, Australia', DATE_SUB('2025-12-31', INTERVAL FLOOR(RAND() * 9490) DAY), ROUND(RAND() * 50000, 2));



-- saldoa n. alle 5 000
SELECT * FROM Asiakkaat WHERE floor(saldo) < 5000; 


-- päivitystä rekisteröitymis_pvm _ satunnaisesti n. 1950 - 2010
-- aloituspiste on 2010-12-31 josta päivämääriä vähennettään randomisti 21915 päivää - vastaa n. 60 vuotta.
UPDATE Asiakkaat
SET rekisteröitymis_pvm = DATE_SUB('2010-12-31', INTERVAL FLOOR(RAND() * 21915) DAY);



/*
===========================================
Tehtävät:

Kuinka monta asiakasta meillä on?

Kuinka monta tilausta on tehty kuukauden aikana?

Mitkä tuotteet ovat myydyimpiä?

Mikä oli viimeisin tilaus ja milloin se tehtiin?

Kuka asiakas on käyttänyt eniten rahaa?

Miten optimoisit tämän kyselyn?

Miten indeksointi vaikuttaa tähän?

===========================================
*/

-- ===========================================
-- MUUTAMIA HARJOITUKSIA W3SCHOOLS JA LISÄÄ EDITOITUNA


-- SELECT DISTINCT varmistaa, että jokainen asiakkaan nimi näkyy vain kerran tuloksessa ja käsky asiakkaan nimet käänteisenä & ASC nouseva aakkosjärjestys A-> ja DESC käänteinen aakkosjärjestys Z -> A
SELECT DISTINCT Asiakkaat.nimi
FROM Asiakkaat
ORDER BY Asiakkaat.nimi DESC ;


-- lasketaan yhteen koko Asiakkaat - taulukkon nimet
SELECT COUNT(DISTINCT Asiakkaat.nimi)
FROM Asiakkaat;



-- haettaan kohdetta, mutta %SANA% - prosenttiamerkkiä tarkoittaa mitä edessä ja taka onkaa ihan sama, esim. voi olla lontoo, UK ja jne. Tämä tarkoittaa osoite-sarakkeen arvo ei ole tarkalleen "UK" sisältyen muu kaupunki. Jos ois tarkka niin sitten ilman prosenttiamerkkiä (edessä/takana).
SELECT * FROM Asiakkaat 
WHERE osoite LIKE '%UK%';




-- toinen esim. haluttaisiin nimettyä maata, oiskin uk tai ranska. vaikka taulukkossa on uk, mutta ei ranskaa, niin nimettään haluttaisiin molemat että tuloksesta voi olla jompi kumppi
-- on useampi perään voi lisätä: OR osoite like '%Denmark%'
SELECT * FROM Asiakkaat 
WHERE osoite LIKE '%UK%' OR osoite LIKE '%French%'; 

-- WHERE osoite LIKE '%UK%' OR osoite LIKE '%Germany%' OR osoite LIKE '%Japan%';


-- Tämä on lyhyempi mutta tiivistettynä ja helpottakseen lukemista (ylempi maiden etsiminen) mutta ongelmana IN-operaattori ei toimi jokerimerkkien (%) kanssa, koska se etsii tarkkoja arvoja tietokannasta
SELECT * FROM Asiakkaat 
WHERE osoite IN ('%UK%', '%Germany%', '%Japan%');



-- ei jaksa tarkisella aina Asiakkaan taulukkoa, ja muutettaan muuta ja pätee operaattori merkit = haettaan täsmentävä ID, sitten id on suurempi kuin 3:nen
SELECT * FROM Tilaukset WHERE id > 3; 

-- haettaan joko pienempi tai yhtä pieni kuin 3, että kolmonen itsekin tulee siihen näkyviinsä
SELECT * FROM Tilaukset WHERE id <= 3; 

SELECT * FROM Tilaukset WHERE Tilaukset.asiakas_id = 3; 

-- haettaan id väliltä alkaen 3 ja 7 välistä.
SELECT * FROM Tilaukset WHERE Tilaukset.id BETWEEN 3 AND 7; 


-- ==========================================
-- SQL ORDER BY Keyword
-- ORDER BY on SQL-komento, joka järjestää tulokset tietyssä järjestyksessä.

SELECT * FROM Tuotteet ORDER BY nimi; 

/* ORDER BY (JOTAKIN) ASC - nouseva järjestys esim. pienestä suurempaan
    ORDER BY (JOTAKIN) DESC - lakseva järjestys esim. suuremmasta pienempään

*/

SELECT * FROM Tuotteet ORDER BY Tuotteet.hinta ASC; 


--haettaan tuotetta joka hinta on pienempi kuin 50, sekä toistettaan järjestyksessä ASC
SELECT * FROM Tuotteet
WHERE Tuotteet.hinta < 50
ORDER BY hinta ASC;


-- haettaan tuotetta koskien varastotilannetta on yhtä enemmän tai enemmän kuin 100 kpl:ta, käsketään suuremmasta pienempään DESC
SELECT * FROM Tuotteet 
WHERE Tuotteet.varastotilanne >= 100 
ORDER BY varastotilanne DESC; 

-- sama haettaisiin tuotteen hinnasta 50 ja 100 väliltä, ja käsketään järjestyksessä
SELECT * FROM Tuotteet
WHERE Tuotteet.hinta BETWEEN 50 AND 100 
ORDER BY hinta ASC;


-- kokeillaan muutama juttuja, eli select tuotteesta hinta, kategoria id, nimi - tuotteen taulukkosta, sitten käskettään haluttaan Tuotteen kategorian id järjestyksessä, ja hinta järjestys . 
SELECT Tuotteet.hinta, Tuotteet.kategoria_id, nimi 
FROM Tuotteet
ORDER BY Tuotteet.kategoria_id ASC, Tuotteet.hinta DESC;

/* Tulostus näköinen:
Oikeassa ollaa, koska halutaa id järjestys pienestä suurempaan kohti, ja hinnasta suuremmasta pienempään
kategoria_id	nimi	                hinta (€)
1	            Kannettava tietokone	1299.99
1	            Älypuhelin	            599.99
1	            Tabletti	            399.99
1	            Langaton kaiutin	    129.99
1	            Bluetooth-kuulokkeet	79.99
1	            Pelihiiri	            49.99
2	            Urheilutakki	        119.99
2	            Sadetakki	            79.99
2	            Farkut	                59.99
2	            T-paita	                19.99
3	            Kasviskokkikirja	    22.99
3	            Novellikokoelma	        17.99
*/

-- valittaan järkevämpi tulostus, koska jos normi SELECT * FROM Tuotteet sitten order by jotakin, niin se tulostaa Tuotteet taulukkon kokonaan, mutta haluttaan supistaa ja rajoittaa tulostusta.
SELECT Tuotteet.id, Tuotteet.nimi, Tuotteet.varastotilanne 
FROM Tuotteet 
ORDER BY id, nimi, varastotilanne; 

---

--==========================================
-- SQL AND Operator (AND vs OR)
-- WHERE- ja AND-operaattorit ovat osa SQL-kyselyiden ehtoja, joiden avulla voit suodattaa tietoa tietokannasta.

-- esim haettaisiin Asiakkaasta kennellä on saldo yli 30 000
SELECT * FROM Asiakkaat
WHERE saldo > 30000;



-- Esim. hakisi kennellä on yli 10k (10 000) saldoa ja kotoisin UK:sta
SELECT * FROM Asiakkaat 
WHERE saldo > 10000 AND osoite LIKE '%UK'; 

/* AND vs OR - operaattorit SQL:ssä

AND → Palauttaa vain rivit, joissa kaikki ehdot ovat totta.

OR → Palauttaa rivit, jos yksi tai useampi ehto on totta.

*/


-- haettana Asiakkaan taulukoa, joka sijaitsee osoitteessa USA, saldo on enemmän kuin 10k , ja rekisteröinyt ennen vuotta 1999. Rekisteröitymisestä käyttäen 1999-01-01 muotoa.
SELECT * FROM Asiakkaat
WHERE osoite like '%USA%'
AND saldo > 10000
AND rekisteröitymis_pvm < '1999-01-01';



-- kokeillaan haettaisiin USA jA UK, että sama tyyppisellä, sekä WHERE voi toimia ilman sulkeita mutta auttaa pientä hahmottamista
SELECT * FROM Asiakkaat
WHERE (osoite like '%USA%' OR osoite like '%UK%')
AND saldo > 10000
AND rekisteröitymis_pvm < '1999-01-01';

/*
WHERE ilman sulkeita toimii, mutta kuten aiemmin mainitsin, sulkeet voivat auttaa varmistamaan oikean loogisen järjestyksen etenkin kun yhdistetään AND ja OR-operaattoreita.

SQL käsittelee AND-ehtoja ennen OR-ehtoja, joten jos haluat varmistaa, että OR toimii ensin, sulkeet voivat olla hyödyllisiä. Mutta jos ehtosi toimivat ilman sulkeita ja saat oikeat tulokset, ei ole pakollista käyttää niitä.
*/

-- yhdistettään AND ja OR operaattoria, sekä tarvittaan vastaavasti LIKE operaattori mukaan joka kerta
-- Tässä tapahtuu haettaan missä osoite on kuin "UK", tai osoite on kuin "Saksa", tai osoite on kuin "japani" sitten saldo enemmän kuin 30k ja rekisteröitymis_pvm ennen 2010-01-01
SELECT * FROM Asiakkaat
WHERE osoite like '%UK%' OR osoite LIKE '%Germany%' OR osoite LIKE '%Japan%'
AND saldo > 30000
AND rekisteröitymis_pvm < '2010-01-01';


-- haettaan Asiakkaan taulukkosta, kuin missä sähköposti on "example.com", ja osoitteesta pitää sisältää joko USA ja Saksasta. & AND rivissä voi toimia ilman sulkeittakin
SELECT * FROM Asiakkaat 
WHERE sähköposti LIKE '%example.com' 
AND (osoite LIKE '%USA%' OR osoite LIKE '%Germany%');


/* Pieni huomoina koskien yhtäkuin = merkkiä ei tue % jokerimerkkiä - tämä ei palauta odotettujen tulosta siksi tulee ratkaisuksi ja käyttäen "LIKE" - jokerinmerkkin kanssa. Jos esim. just kaupunki ja maa (New York, USA) siksi vertailumerkkin tulee (=) ei toimi, vaan käyttäen %USA%

*/


--==========================================
-- SQL OR operaattori

-- Where voidaan sisältyä OR operaattoria

-- haettaan Tuotteen kategoriasta id mukaan joko 1 tai 4 
SELECT * FROM Tuotteet
WHERE kategoria_id = '1' OR Tuotteet.kategoria_id = '4';


-- SQL NOT Operator (kielteinen)
-- että haluttaan negatiivista ja tiettyä ominaisuutta ikään ei haluta. Kielteisen ehdon (NOT tai !=) ja samalla suodattaa tiettyjä kategorioita yhdellä SQL-kyselyllä

-- Haetaan Tuotteet-taulukosta, mutta EI haluta kategoria ID:tä 3
SELECT * FROM Tuotteet 
WHERE NOT Tuotteet.kategoria_id = '3'; 

-- METHOD 2
-- Haetaan tuotteet, mutta jätetään pois kategoria ID 3
SELECT * FROM Tuotteet 
WHERE kategoria_id != 3;


-- Tämä sulkee pois kategoriat, joissa id = 3, mutta näyttää kategoriat, joissa id = 4 , mutta silti näyttää kategoria_id siis numeroidut 1,2, 4 ja 5:sen vaikka haluttaisiin VAIN 4:sen
SELECT * FROM Tuotteet 
WHERE kategoria_id != 3 OR kategoria_id = 4;



-- Tämä näyttää vain kategoriassa 4 olevat tuotteet, eikä sisällä mitään kategoriasta 3.
SELECT * FROM Tuotteet 
WHERE kategoria_id = 4 AND kategoria_id != 3;


-- ANOTHER METHOD:
-- käytettään laajempaa kielteistä ehtoa ja jättää pois useita kategorioita. Tämä sulkee pois kategoriat 3 ja 5, mutta näyttää kaikki kategoriassa 4 olevat tuotteet.
SELECT * FROM Tuotteet 
WHERE kategoria_id NOT IN (3, 5) OR kategoria_id = 4;

-- NOT LIKE - jossa ei ole alkuun ja eikä päättyyn 'e' kirjainta, esim eero, dnaiel, jessica
SELECT * FROM Asiakkaat 
WHERE Asiakkaat.nimi NOT LIKE '%e%'; 


-- haettaan joiden nimi ei sisällä 'e' eikä 'u'
/*
| Rakenne | Selitys                                  | Esimerkki hakutulos           |
| ------- | ---------------------------------------- | ----------------------------- |
| `'a%'`  | Alkaa **a**:lla                          | Anna, Aleksi, Antti           |
| `'%a'`  | Päättyy **a**:han                        | Laura, Sofia, Elina           |
| `'%a%'` | **Sisältää** a\:n missä tahansa kohdassa | Paula, Jari, Sami, Anna, etc. |
| `'a'`   | On **tasan** yksi merkki: "a"            | vain jos arvo on tasan "a"    |
*/
SELECT * FROM Asiakkaat 
WHERE Asiakkaat.nimi NOT LIKE '%e%'
AND nimi NOT LIKE '%u%'; 


-- NOT BETWEEN , joka ei ole jonkin väliltä
-- esim. haettaan saldo joka ei ole 10k - ja 40k väliltä, eli tulostuu alle 10k ja yli 40k määrää
SELECT * FROM Asiakkaat 
WHERE saldo NOT BETWEEN 10000 AND 40000; 


-- haettaan id joka ei ole 5 ja 20 väliltä
SELECT * FROM Asiakkaat
WHERE id NOT BETWEEN 5 AND 120;



-- NOT IN
-- nimettään kielteisesti ettei haluta näitä kohteita Suomi, UK, Japan, USA - tulostettua taulukosta, eli nimetyt maat pois
SELECT * FROM Asiakkaat 
WHERE osoite NOT IN ('Suomi', 'UK' , 'Japan', 'USA'); 



-- NOT Greather than
-- haettaan id joka ei ole suurempi kuin kuin 5
SELECT * FROM Asiakkaat 
WHERE NOT id > 5; 


-- NOT Less than
-- id joka on vähintään 5
SELECT * FROM Asiakkaat 
WHERE NOT id < 5; 


-- ===========================
-- SQL INSERT INTO Statement

-- INSERT INTO - lauseketta käytetään uusien tietuiden lisäämistä taulukkoon

/*
INSERT INTO table_name (column1, column2, column3, ...)
VALUES (value1, value2, value3, ...);

INSERT INTO table_name
VALUES (value1, value2, value3, ...);

*/

-- eli tarkoittaa käyttäjän tai taulukon alle lisätään jotakin tietoa, esim. tähän Asiakkaan taulukon alle lisätään uusi henkilö tai jokin ominaisuus/uusi tieto. 
-- INSERT INTO ... VALUES-lauseke kertoo mihin taulukkoon haluat lisätä tietoa sekä mitkä arvot lisätään.


-- tässä pitää olla tarkanna, mitä tietoja tarvittaan jotta syöte menee oikein.
INSERT INTO Asiakkaat (id, nimi, sähköposti, osoite, rekisteröitymis_pvm, saldo)
VALUES (21, 'Olivia Mäkinen', 'olivia2@example.com', 'Suomi', '1999-04-15', 3456.67);


-- sama pätee jos sarakkeista ei ole erikseen määritelty (tämä toimii hyvinkin nopeammin)
INSERT INTO Asiakkaat 
VALUES (22, 'Leon Shawn', 'leon@example.com', 'UK', '1998-05-13', 44132.84);


-- entä jos INSERT INTO - lausekeessa sulkeiden sisällä ominaisuudet menee ristiin. SQL edellyttää, että arvojen järjestys vastaa sarakkeiden järjestystä.. (tämä menee läpi)
INSERT INTO Asiakkaat (nimi, saldo, sähköposti, osoite, rekisteröitymis_pvm, id) 
VALUES ('Gilbert Tate', 23634.87, 'gilbert@example.com', 'Australia', '1996-3-04', 23);


-- sama homma jos sarake puuttuu tai tietty tieto, se sitten menee NULL, mutta silti menee läpi ja esim. rekisteröitymis_pvm jätettäisiin välistä ja huomioina se sitten id lisääntyy automaattisesti, koska taulukossa on "AUTO_INCREMENT" käytössä. Tarkoittaa id-sarake lisäääntyy automaattisesti, kun uusi rivi lisätään.
INSERT INTO Asiakkaat (nimi, sähköposti, osoite, saldo) 
VALUES ('Nicole Colombi', 'nicole@example.com', 'Italy', 9999.12);


--===========================
-- Test for NULL Values

-- NULL-arvojen käsittely SQL:ssä toimii eri tavalla kuin normaalit vertailuoperaattorit.
-- NULL ei ole sama kuin tyhjä arvo – se tarkoittaa tuntematonta tai puuttuvaa arvoa.
-- = ja <> eivät tunnista NULL-arvoja, koska SQL käsittelee NULL-arvoja eri tavalla kuin tavalliset luvut tai merkkijonot.


-- tarkistettaan Tuotteet taulukosta, missä hinta on NULL 
SELECT * FROM Tuotteet 
WHERE hinta IS NULL; 


-- tarkistettaan Tuotteet-taulukosta, missä hinta ei ole NULL - se tuo mukaan jos "kategoria_id" on NULL pätee niitäkin ja "varastotilanne" jos sekin NULL.
SELECT * FROM Tuotteet 
WHERE hinta IS NOT NULL; 


/*jos käyttää erikoismerkin <> ja = näiden osalta se ei toimi ja mallina:

SELECT * FROM Tuotteet WHERE hinta = NULL;  -- Ei toimi!
SELECT * FROM Tuotteet WHERE hinta <> NULL; -- Ei toimi!
*/

-- Testauksena halutaan näyttää tuotteet joiden hinta on null tai hinta on pienempi kuin 50
SELECT * FROM Tuotteet 
WHERE hinta IS NULL OR hinta < 50;


-- sama pätee varastotilanne jos on NULL tai jos on yli 100 kpl:ta
SELECT * FROM Tuotteet 
WHERE Tuotteet.varastotilanne IS NULL OR Tuotteet.varastotilanne > 100;


-- haettaan joku Tuotteen taulukosta, joka hinta on null ja halutaan kategoria id on 1. 
SELECT * FROM Tuotteet 
WHERE hinta IS NULL AND kategoria_id = 1;


-- tässä esim. haettaan Tuotteen taulukosta, joka hinta ei ole NULL ja varastotilanne on NULL.
SELECT * FROM Tuotteet 
WHERE hinta IS NOT NULL AND varastotilanne IS NULL; 


--========================================
-- SQL UPDATE Statement

/*
UPDATE table_name
SET column1 = value1, column2 = value2, ...
WHERE condition;
*/


-- Kokeillaan päivittää tämä osuus BEFORE: id: 5 nimi: Romaani hinta:12.99 kategoria_id: 3 varastotilanne: 70
-- esim. muutettun jälkeen se muuttuu samantien. Huomoina tämä pitää mennä taulukkon nimetyn tekijän mukaan.
UPDATE Tuotteet
SET nimi = 'novelli', varastotilanne = '80'
WHERE id = 5;

SELECT * FROM Tuotteet;



-- UPDATE Multiple Records
-- tarkoittaa, että päivität useita rivejä kerralla, jos ne täyttävät tietyt ehdot, ja tämä ei vaikuta kaikkiin riveihin automaattisesti, vaan niihin, jotka vastaa WHERE ehtoa
-- kokeillaan tätä: id: 16 nimi: Sadetakki hinta 79.99 kategoria_id: 2 varastotilanne: 55

-- Otettaan kaikki kategoria id = 1 listaus
SELECT * FROM Tuotteet 
WHERE kategoria_id = 1; 


/*  BEFORE:
    Edit Edit 	Copy Copy 	Delete Delete   1 	Älypuhelin 	            599.99 	1 	50
	Edit Edit 	Copy Copy 	Delete Delete 	2 	Kannettava tietokone 	1299.99 1 	20
	Edit Edit 	Copy Copy 	Delete Delete 	7 	Bluetooth-kuulokkeet 	79.99 	1 	75
	Edit Edit 	Copy Copy 	Delete Delete 	9 	Pelihiiri 	            49.99 	1 	60
	Edit Edit 	Copy Copy 	Delete Delete 	10 	Tabletti 	            399.99 	1 	35
	Edit Edit 	Copy Copy 	Delete Delete 	15 	Langaton kaiutin 	    129.99 	1 	50
	Edit Edit 	Copy Copy 	Delete Delete 	19 	Älykello 	            NULL 	1 	45
*/

-- jos hinta on NULL alunperin, ja tekee update muutoksensa niin tämä ei muutu sitä, koska NULL ei ole arvo, eikä sitä voi kertoa millään arvolla


-- Nyt tehdään muutokset
UPDATE Tuotteet
SET hinta = hinta * 1.10 -- korotettaan hintaan 10%
WHERE kategoria_id = 1; -- vain kateogirat 1 tuotteet

SELECT * FROM Tuotteet
WHERE kategoria_id = 1;

/* AFTER:
 	Edit Edit 	Copy Copy 	Delete Delete 	1 	Älypuhelin 	            659.99 	1 	50
	Edit Edit 	Copy Copy 	Delete Delete 	2 	Kannettava tietokone 	1429.99 	1 	20
	Edit Edit 	Copy Copy 	Delete Delete 	7 	Bluetooth-kuulokkeet 	87.99 	1 	75
	Edit Edit 	Copy Copy 	Delete Delete 	9 	Pelihiiri 	            54.99 	1 	60
	Edit Edit 	Copy Copy 	Delete Delete 	10 	Tabletti 	            439.99 	1 	35
	Edit Edit 	Copy Copy 	Delete Delete 	15 	Langaton kaiutin 	    142.99 	1 	50
	Edit Edit 	Copy Copy 	Delete Delete 	19 	Älykello 	            NULL 	1 	45
*/

-- sama pätee oiskin hinta niin muutettaisiin se NULL:iksi
-- Kokeillaan tätä BEFORE: 11 	Farkut 	59.99 	2 	0
-- eli muutettan tämä farkku hinnasto NULL:iks ja missä sen id on 11

UPDATE Tuotteet
SET hinta = NULL
WHERE id = 11;

SELECT * FROM Tuotteet
WHERE id = 11;


-- kokeillaan yksittäistä tuotetta hinnan muutosta BEFOFRE - 4 	Juoksukengät 	89.99 	4 	45
-- kokeillaan lisätä varastotilannetta, mutta siihen pitää ennen sitä laittaa pilku, ja ei käytetä AND-operaattoria
UPDATE Tuotteet
SET hinta = 50.99, varastotilanne = 80
WHERE id = 4;

SELECT * FROM Tuotteet
WHERE id = 4;


-- sama pätee jos on useita tuoteitta, et niiden hinnat ja varastotilanne muuttu ettei tarvitse jokaista yksittäistä syötellä, varmistettaan id sitten pilku id numero ja jne, sekä jos on useampi menee näin "WHERE id IN (2, 5, 8, 12);"
UPDATE Tuotteet 
SET hinta = 50.99, varastotilanne = 80 
WHERE id IN (4, 10);


-- varoituksena UPDATE operaattorissa pitää olla WHERE - ehto mukana, muuten jos ilman sitä niin kaikki datat joutuu muuttaa käsin uudestaan


-- ===============================================
-- SQL DELETE Statement
-- DELETE - ehto tarkoittaa tietojen tai yksittäisen taulukkon sisällön poistoa

DELETE FROM table_name WHERE condition;

-- leikisti poistettaisiin tämä; 31 	Farkkutakki 	89.99 	2 	NULL 
-- huomoina tämä PHPmyadmin tietokanta kysyi kertalleen (yhteenvetona) että haluatko oikeasti poistaa tämän id:nsä niin vahvistettiin ja tarkistettuna tämä id 31 farkkutakki on poistunut Tuotteen-taulukon alta
DELETE FROM Tuotteet WHERE id = 31; 


-- ===============================================

-- SQL TOP, LIMIT, FETCH FIRST or ROWNUM Clause

/* SQL SELECT TOP Clause
SELECT TOP -lauseke käytetään SQL:ssä rajaamaan palautettavien rivien määrää. Tämä on hyödyllistä etenkin suurissa taulukoissa, joissa on tuhansia rivejä, sillä hakemalla vain tarvittavat tiedot voi parantaa suorituskykyä.

SELECT TOP toimii vain SQL Server -tietokannoissa. Jos käytät esimerkiksi MySQL, PostgreSQL tai SQLite - täyttyy käyttää LIMIT lauseketta TOP sanan sijaan.

Teoriassa tässä on mukaan melko samankaltaisia komentoja, SQL SELECT TOP -lauseke on syntaksi, jota käytetään erityisesti SQL Serverissä, MS Accessissa, Oracle SQL, MySQL/ POstreSQL / MariaDB ja SQLite rajaamaan palautettujen rivien määrää. Mutta eri tietokannat käyttävät eri tapoja toteuttaa sama toiminnallisuus.

| SQL-järjestelmä | Rajaaminen (SELECT TOP vastaava) |
|----------------|--------------------------------|
| **SQL Server / MS Access** | `SELECT TOP 5 * FROM Taulukko;` |
| **MySQL / PostgreSQL / MariaDB** | `SELECT * FROM Taulukko LIMIT 5;` |
| **Oracle SQL** | `SELECT * FROM Taulukko FETCH FIRST 5 ROWS ONLY;` |
| **SQLite** | `SELECT * FROM Taulukko LIMIT 5;` |

*/

SELECT * FROM Tuotteet LIMIT 5;


-- LIMIT 
-- tämä hakee 5 ensimmäistä riviä Tuotteen taulukosta, josta hakee hinnan mukaan suurimmasta pienempään , ei väliä id:stä mitä hintoja on onkaan 1-30 väliltä & kuitenkin 5 kalleinta tuotetta.
SELECT * FROM Tuotteet 
ORDER BY hinta DESC 
LIMIT 5;




-- sama tässäkin haettaisiin kaikki minimi hinnat, ja jos on NULL - nekin lasketaan mukaan
SELECT * FROM Tuotteet 
ORDER BY hinta ASC 
LIMIT 5; 


-- haettaan asiakkaan listasta rajoitettu 3 kpl:ta jotka osoite sijaitsee Suomi.
SELECT * FROM Asiakkaat
WHERE osoite = 'Suomi' 
LIMIT 3; 


-- haettaan raja maasta, italiasssa asiakkaan taulukossa oli vain 1, mutta saksassa muutama, mutta kuitekin haluttaa jomppaa kumppaa
SELECT * FROM Asiakkaat 
WHERE osoite = 'Italy' OR osoite = 'Germany' LIMIT 3; 


--=======================================================
-- SQL Aggregate Functions

/* SQL:n Aggregate Functions ovat funktioita, jotka suorittavat laskutoimituksia arvojoukosta ja palauttavat yhden arvon.

Ne auttavat ryhmittelemään ja analysoimaan tietoa suurissa tietokannoissa. Yhdessä GROUP BY-lauseen kanssa ne mahdollistavat datan ryhmittelyn ja yhteenvedon.


MIN()	Palauttaa pienimmän arvon sarakkeessa.
MAX()	Palauttaa suurimman arvon sarakkeessa.
COUNT()	Laskee rivien määrän joukoissa.
SUM()	Laskee sarakkeen kaikkien arvojen summan.
AVG()	Palauttaa sarakkeen keskiarvon.

*/


-- esim. laskettaisiin Tuotteen taulukosta hinnat keskihinnaksi (huom. keskihinta - sana - on itse tuotu)
-- "keskihinta"  ei ole Tuotteen sarakkeessa, vaan se on alias, joka annettaan SQL kyselyssä ja toimii kuin annetaan vain tilapäinen nimi, ja se ei tuhoa taulukkon sisällön rakennetta
SELECT AVG(hinta) AS keskihinta FROM Tuotteet; 

-- muita esimerkkejä
SELECT MIN(Tuotteet.hinta) AS pieninhinta FROM Tuotteet;

-- haluttaisiin tulostaa useampaa kuten minimi, maksimi ja keskiarvo
SELECT MIN(Tuotteet.hinta) AS pieninhinta , M
AX(Tuotteet.hinta) AS suurinhinta 
FROM Tuotteet; 


SELECT MIN(Tuotteet.hinta) AS pieninhinta,
MAX(Tuotteet.hinta) AS suurinhinta ,
AVG(Tuotteet.hinta) AS keskiarvo
FROM Tuotteet;


-- tämä laskee tuotteiden lukumäärää kategoriassa, mutta huomoina Tuotteen taulukkossa on mukana NULL arvoa
SELECT kategoria_id, COUNT(*) AS tuotteiden_maara 
FROM Tuotteet 
GROUP BY kategoria_id;

-- SQL-kysely laskee tuotteiden määrän per kategoria_id, eli se kertoo, kuinka monta tuotetta kuuluu kuhunkin kategoriaan
SELECT kategoria_id, COUNT(*) AS tuotteiden_maara 
FROM Tuotteet 
WHERE kategoria_id IS NOT NULL 
GROUP BY kategoria_id; 


-- tässä on parempi esim. joka laskee Asiakkaan taulukkon kaikki id:n määrät yhteen, ja monta kappaleta niitä onkaan.
SELECT Asiakkaat.id, COUNT(*) AS idmaara
FROM Asiakkaat 
GROUP BY Asiakkaat.id; 


-- sama jos halutaan COUNT kaksi kertaa, niin toistettaan count ominaisuus kategoria/asiansa kahesti ja pätee otettaan mukaan mitkä ei ole NULL
SELECT kategoria_id, COUNT(*) AS kategorianID, COUNT(varastotilanne) AS varastossa_olevat
FROM Tuotteet
WHERE kategoria_id IS NOT NULL
GROUP BY kategoria_id;


-- tämä on toinen methodi, mutta hakee vain tietyn kategorian tuotteet ja laskee niiden määrä
SELECT COUNT(*) AS tuotteiden_maara
FROM Tuotteet
WHERE kategoria_id IN (1, 2);  -- Vain kategoriat 1 ja 2 


-- summan laskenta SUM() jokaisesta tyyppistä
SELECT SUM(Asiakkaat.saldo) AS yhteisSaldo 
FROM Asiakkaat;



-- Esim halutaisiin laskea kahden tai useamman Taulukkon erikseen niin näin
SELECT 
    (SELECT SUM(saldo) FROM Asiakkaat) AS yhteisSaldo, 
    (SELECT SUM(hinta) FROM Tuotteet) AS yhteisHinta;

-- SUM() toimii vain numeeristen arvojen kanssa, eikä tekstimuotoisia tietoja, kuten nimet, voi laskea yhteen ja se ei laske NULL arvoja, jos jokin nimi/arvo puuttuu
SELECT COUNT(Asiakkaat.nimi) as NimiMaara FROM Asiakkaat;


-- AVG() keskimääräinen jotakin ja AVG() toimii vain numeeristen arvojen kanssa! Jos yrität käyttää AVG()-funktiota tekstimuotoiseen sarakkeeseen, kuten nimi, SQL antaa virheen, koska keskiarvoa ei voi laskea ei-numeerisista arvoista.
SELECT AVG(hinta) AS tuotteenHinta FROM Tuotteet;


-- =======================================================
-- SQL MIN() and MAX() Functions
-- perus minimaalinen ja maksimaalinen funtio palautus arvo jostakin sarakkeesta

-- tarkistetaan minimi hinta
SELECT MIN(Tuotteet.hinta) 
FROM Tuotteet; 


-- ajattelin tulostaisi minimi hinta 5 kpl:ta, mutta se sitte menisi toisenlaisella komennolla ja helpommalla, ja tapaa on monta mutta ei ole väärää ja oikeata, mutta sitä pitää vaan suunnitella jotta pääsee maaliin asti
SELECT hinta 
FROM Tuotteet 
WHERE hinta IS NOT NULL
ORDER BY hinta ASC 
LIMIT 5;


-- hinnasta/luvusta annettaan joku aliasta nimi (saldot) ja tulostettaan Asiakkaan taulukkosta
SELECT MIN(Asiakkaat.saldo) AS saldot
FROM Asiakkaat;


-- Use MIN() with GROUP BY
-- voidaan käyttää MIN() funktiota ja jotakin GROUP BY lauseketta, että palauttaa jotakin esim. minimi hintaa sarakkeen listasta
-- esim tässä haettaan minimi tuotteen hinta as minimihinta, kategoria_id ja nimi, Tuotteen taulukkosta ja ryhmitettynä kategoria id mukaan.
SELECT MIN(Tuotteet.hinta) AS minimiHinta, kategoria_id, nimi
FROM Tuotteet
GROUP BY kategoria_id;


--=========================================================
-- SQL COUNT() Function

-- tarkistaa Taulukkon kokorivinsä
SELECT COUNT(*)
FROM Tuotteet;

--toi tähti * symbooli tarkoittaa kaikki rivit, myös ne joissa on NULL arvoja , JOS count(column_name) vain ne rivit joissa on sarake ei ole NULL
SELECT COUNT(nimi) FROM Tuotteet;

-- seuraavaksi voidaan laskea yhteen esim. saldosta asiakkaan osalta että on enemmän kuin 500 
SELECT COUNT(Asiakkaat.saldo)
FROM Asiakkaat
WHERE saldo > 500;


-- sama muutettuna pikaksen, että on yhtä vähän tai sitä vähempi kuin 500
SELECT COUNT(Asiakkaat.saldo)
FROM Asiakkaat
WHERE saldo <= 500;


-- tässä sama kuin aikaisempi, mutta halusin tietää nimensä kuka (nimi, saldo, osoite), että kennellä on yhtä paljon tai vähemmän kuin 500. saldoArvo on aliasnimi tolle Asiakkaat.saldo
SELECT COUNT(Asiakkaat.saldo) AS saldoArvo, nimi, saldo, osoite
FROM Asiakkaat
WHERE saldo <= 500;


-- Ignore Duplicates
-- DISTINCT-avainsanaa käytetään COUNT()-funktiossa, kun halutaan laskea vain uniikit arvot, eikä samoja arvoja useaan kertaan.





--===============================
-- JOIN


-- Yhdistettään kahta taulukkoa, settä select mitä halutaan tulostaa ja mistä taulukkon nimeä ja join mikä toinen taulukkon nimi, sitten yhdistettään niiden Tilauksien.asiakas_id on yhtä kuin Asiakkaat.id
SELECT Tilaukset.id, Asiakkaat.nimi, Tilaukset.asiakas_id, Tilaukset.toimitus_status
FROM Tilaukset JOIN Asiakkaat ON Tilaukset.asiakas_id = Asiakkaat.id;


/*
id 	nimi 	asiakas_id 	toimitus_status 	
1 	Matti Meikäläinen 	1 	toimitettu
2 	Anna Virtanen 	2 	lähetetty
3 	Jari Korhonen 	3 	käsittelyssä
4 	Paula Laine 	4 	toimitettu
5 	Sami Nieminen 	5 	toimitettu
6 	Laura Hiltunen 	6 	lähetetty
7 	Tomi Salminen 	7 	käsittelyssä
8 	Riikka Mäkelä 	8 	lähetetty
9 	Eero Kallio 	9 	toimitettu
10 	Veera Lehtinen 	10 	käsittelyssä
101 	William Taylor 	11 	Toimitettu
102 	Sophia Garcia 	12 	Kadonnut
103 	Daniel Lee 	15 	Toimitettu
104 	Nathan Reed 	16 	Kadonnut
105 	Ethan Hall 	18 	

*/


-- mitä jos halutaan tarkistaa kaikkien "kadonneet" toimituksen status tilannetta niin lisätään WHERE lausekke, että on "kadonnut"
SELECT Tilaukset.id, Asiakkaat.nimi, Tilaukset.asiakas_id, Tilaukset.toimitus_status
FROM Tilaukset JOIN Asiakkaat ON Tilaukset.asiakas_id = Asiakkaat.id
WHERE Tilaukset.toimitus_status = 'kadonnut';

-- kysellään asiakkaiden nimi ja heidän viimeismmmän tilauksensa päivän määrä
SELECT Asiakkaat.nimi, MAX(Tilaukset.tilaus_pvm) 
FROM Asiakkaat JOIN Tilaukset ON Asiakkaat.id = Tilaukset.asiakas_id 
GROUP BY Asiakkaat.nimi;


--=================================================
-- SQL Aliases
-- alias eli aliasnimi, että tulostuksena mikä ei täsmenny Taulukkon sarakkeen nimeeseen vähä kuin nimettynä erikseen tulostuksena & 



SELECT Asiakkaat.id IDtunnus 
FROM Asiakkaat; 


-- as voidaan käyttää AS-avainsanalla - AS nimellä on vaihtoehtoinen ja sitä voi käyttää
SELECT Asiakkaat.saldo saldoArvot 
FROM Asiakkaat; 


--=================================================
-- SQL Joins

/*
JOIN-lauseke SQL:ssä yhdistää rivejä kahdesta tai useammasta taulusta yhteisen sarakkeen perusteella. Tämä mahdollistaa tiedon hakemisen useista tauluista yhdellä kyselyllä.



INNER JOIN	Palauttaa vain ne rivit, joilla on vastaava osuma molemmissa tauluissa.	✅ Vain vastaavat rivit

LEFT JOIN (LEFT OUTER JOIN)	Palauttaa kaikki vasemman taulun rivit ja vain vastaavat rivit oikeasta taulusta.	✅ Vasemman taulun kaikki rivit

RIGHT JOIN (RIGHT OUTER JOIN)	Palauttaa kaikki oikean taulun rivit ja vain vastaavat rivit vasemmasta taulusta.	✅ Oikean taulun kaikki rivit

LEFT and RIGHT JOIN taulukko, kun määrittää LEFT JOIN tai RIGHT JOIN, taulujen järjestys vaikuttaa siihen, kumpi on "vasen" ja kumpi "oikea".

- Vasemman taulun rivit säilyvät, vaikka ei olisi osumaa oikeassa taulussa (LEFT JOIN).
- Oikean taulun rivit säilyvät, vaikka ei olisi osumaa vasemmassa taulussa (RIGHT JOIN).

SELECT-lauseessa määritetään, mitä tietoja halutaan hakea, mutta itse JOIN-lauseen rakenne määrää, mikä taulu on "vasen" ja mikä "oikea".


FULL JOIN (FULL OUTER JOIN)	Palauttaa kaikki rivit molemmista tauluista, yhdistäen vastaavat tiedot.	✅ Molempien taulujen kaikki rivit

CROSS JOIN	Luo kaikkien rivien yhdistelmän molemmista tauluista (kartesiainen tulo).	✅ Kaikki mahdolliset yhdistelmät

===========================================================================
PIENI PELI/MUISTISÄÄNTÖ KOSKIEN JOIN KYSELLYYNSÄ: 

- INNER JOIN - vain yhteiset rivit, ja vain ne rivit, jotka löytyvät molemmista tauluista
- LEFT JOIN - kaikki vasemman taulun rivit + yhteiset, vaikka oikea taulussa vastaavaa tietoa ei olisi (NULL)
- RIGHT JOIN - kaikki oikea taulun rivit + yhteiset, vaikka oikean taulun rivit, vaikka vasemman taulun vastaavaa tietoa ei olisi (NULL)
- FULL JOIN - kaikki rivit molemmista tauluista , kaikki rivit molemmista tauluista, vaikka vastaavaa tietoa ei olisi toisessa taulussa ja NULL arvoja sallittaan
===========================================================================

LEFT JOIN vs. RIGHT JOIN - jotakin huomoittavaa SQL komennossa.

LEFT JOIN – Kaikki vasemman taulun rivit säilytetään
Palauttaa kaikki rivit vasemmasta taulusta, vaikka oikean taulun vastaavia tietoja ei olisi.

Jos oikeasta taulusta ei löydy vastaavia tietoja, NULL-arvo ilmestyy.

Hyöty: Käytetään silloin, kun halutaan säilyttää vasemman taulun rivit, vaikka oikeasta taulusta ei olisi vastaavuutta.



RIGHT JOIN – Kaikki oikean taulun rivit säilytetään
Palauttaa kaikki rivit oikeasta taulusta, vaikka vasemman taulun vastaavia tietoja ei olisi.

Jos vasemmasta taulusta ei löydy vastaavia tietoja, NULL-arvo ilmestyy.

Hyöty: Käytetään silloin, kun halutaan säilyttää oikean taulun rivit, vaikka vasemmasta taulusta ei löytyisi vastaavuutta.




ELI KUMPPAA VALITAAN/MITEN VALITA OIKEA JOIN?

Käytä LEFT JOIN, jos haluat säilyttää kaikki vasemman taulun rivit, mutta sallit oikean taulun NULL-arvot.

Käytä RIGHT JOIN, jos haluat säilyttää kaikki oikean taulun rivit, mutta sallit vasemman taulun NULL-arvot.

Jos et ole varma, kumpi on järkevämpi, mieti kumpi taulu on tärkeämpi säilyttää kokonaan!




===========================================================================
*/

-- JOIN
-- esim. haettaan Tilauksen taulukkon mukaan id, Asiakkaan nimi, ja Tilauksen toimitus status, mistä taulukkosta (Tilaukset) sitten JOIN mukaan Asiakkaan taulukko sitten ON yhdistettään kahden taulukkojen kategoriat yhteen.
-- ON - ehto yhdistää taulujen niiden vastaavat ID-arvojen perusteella
SELECT Tilaukset.id, Asiakkaat.nimi, Tilaukset.toimitus_status 
FROM Tilaukset JOIN Asiakkaat ON Tilaukset.asiakas_id = Asiakkaat.id; 


-- INNER JOIN
-- tässä haettaan Asiakkaan taulukon alta id ja nimi ja Tilauksen taulukkon alta id ja toimitus status, että mistä Tilauksien alta, sitten palautetaan ne rivit johon vastaa molempien osumia tauluja siksi nimesin INNER JOIN Asiakkaat ja on Tilauksien id <==> Asiakkaan id
SELECT Asiakkaat.id, Asiakkaat.nimi , Tilaukset.id, Tilaukset.toimitus_status 
FROM Tilaukset INNER JOIN Asiakkaat ON Tilaukset.id = Asiakkaat.id; 

-- vähä tarkennusta INNER JOIN 
-- INNER JOIN on SQL-käsky, joka yhdistää kaksi taulukkoa ja valitsee vain ne rivit, joissa yhteiset arvot täsmäävät molemmissa tauluissa. Tämä tarkoittaa, että jos tietoa ei ole molemmissa tauluissa, sitä ei sisällytetä tuloksiin.
SELECT Tilaukset.id, Asiakkaat.nimi, Tilaukset.toimitus_status
FROM Tilaukset
INNER JOIN Asiakkaat ON Tilaukset.asiakas_id = Asiakkaat.id;


-- itse vähä rakennettu, mutta methodi 
SELECT Asiakkaat.id, Asiakkaat.nimi, Tilaukset.toimitus_status, Tilaukset.tilaus_pvm
FROM Tilaukset
INNER JOIN Asiakkaat ON Tilaukset.asiakas_id = Asiakkaat.id;


-- JOIN or INNER JOIN
-- Käytännössä JOIN ja INNER JOIN toimivat identtisesti

SELECT Tilaukset.id, Asiakkaat.nimi
FROM Tilaukset
JOIN Asiakkaat ON Tilaukset.asiakas_id = Asiakkaat.id;


SELECT Tilaukset.id, Asiakkaat.nimi
FROM Tilaukset
INNER JOIN Asiakkaat ON Tilaukset.asiakas_id = Asiakkaat.id;


-- join mukaan Tilauksen taulukko ja Asiakkaan taulukko, että verrattaan se asiakkaan id ja tilauksen id täsmentyy ja voidaan tarkistaa se onko toimitettu ja näin
SELECT Tilaukset.id AS tilaus_id, Asiakkaat.nimi, Tilaukset.toimitus_status
FROM Tilaukset
JOIN Asiakkaat ON Tilaukset.asiakas_id = Asiakkaat.id
WHERE Tilaukset.toimitus_status = 'toimitettu';




-- JOIN Three tables
-- eli kolme taulukkoa, ja jos tulee neljäs sitten tulee kolmas INNER JOIN lausekke
SELECT Asiakkaat.nimi AS AsiakasNimi, Tilaukset.id AS TilausID, 
       Tilaukset.toimitus_status AS TilausStatus, Maksutavat.tapa AS Maksutapa
FROM Tilaukset
INNER JOIN Asiakkaat ON Tilaukset.asiakas_id = Asiakkaat.id
INNER JOIN Maksutavat ON Tilaukset.maksutapa_id = Maksutavat.id;


SELECT Asiakkaat.nimi AS AsiakasNimi, Tilaukset.id AS TilausID, 
       Tilaukset.toimitus_status AS TilausStatus, Tuotteet.nimi AS TuoteNimi, 
       Tilauksen_rivit.määrä AS Määrä, Tilauksen_rivit.yhteishinta AS Yhteishinta
FROM Tilaukset
INNER JOIN Asiakkaat ON Tilaukset.asiakas_id = Asiakkaat.id
INNER JOIN Tilauksen_rivit ON Tilaukset.id = Tilauksen_rivit.tilaus_id
INNER JOIN Tuotteet ON Tilauksen_rivit.tuote_id = Tuotteet.id;





-- LEFT JOIN - josta näytä kaikki asiakkaat, vaikka heillä ei ole olisi tilausta ja tämä näyttää kaikki asiakkaat, mutta tilaukset näkyvät vain jos ne ovat olemassa. Tuloksena ainakin näytti mukaan lukien on NULL arvoja
SELECT Asiakkaat.nimi, Asiakkaat.id, Tilaukset.id, Tilaukset.toimitus_status
FROM Asiakkaat
LEFT JOIN Tilaukset ON Asiakkaat.id = Tilaukset.asiakas_id;

/*

 nimi 	id 	toimitus_status 	id 	
Matti Meikäläinen 	1 	toimitettu 	1
Anna Virtanen 	2 	lähetetty 	2
Jari Korhonen 	3 	käsittelyssä 	3
Paula Laine 	4 	toimitettu 	4
Sami Nieminen 	5 	toimitettu 	5
Laura Hiltunen 	6 	lähetetty 	6
Tomi Salminen 	7 	käsittelyssä 	7
Riikka Mäkelä 	8 	lähetetty 	8
Eero Kallio 	9 	toimitettu 	9
Veera Lehtinen 	10 	käsittelyssä 	10
William Taylor 	101 	Toimitettu 	11
Sophia Garcia 	102 	Kadonnut 	12
James Anderson 	NULL 	NULL 	13
Olivia White 	NULL 	NULL 	14
Daniel Lee 	103 	Toimitettu 	15

*/



--RIGHT JOIN – Näytä kaikki tilaukset, vaikka asiakastiedot puuttuisivat. Tämä palauttaa kaikki tilaukset, mutta asiakastiedot voivat olla NULL, jos asiakas on poistettu.
SELECT Tilaukset.id, Asiakkaat.nimi, Tilaukset.toimitus_status
FROM Tilaukset
RIGHT JOIN Asiakkaat ON Tilaukset.asiakas_id = Asiakkaat.id;

/*
 id 	nimi 	toimitus_status 	
1 	Matti Meikäläinen 	toimitettu
2 	Anna Virtanen 	lähetetty
3 	Jari Korhonen 	käsittelyssä
4 	Paula Laine 	toimitettu
5 	Sami Nieminen 	toimitettu
6 	Laura Hiltunen 	lähetetty
7 	Tomi Salminen 	käsittelyssä
8 	Riikka Mäkelä 	lähetetty
9 	Eero Kallio 	toimitettu
10 	Veera Lehtinen 	käsittelyssä
101 	William Taylor 	Toimitettu
102 	Sophia Garcia 	Kadonnut
NULL 	James Anderson 	NULL
NULL 	Olivia White 	NULL
103 	Daniel Lee 	Toimitettu

*/



-- FULL JOIN – Näytä kaikki rivit molemmista tauluista, yhdistäen yhteiset tiedot. Tämä yhdistää molemmat taulut, mutta näyttää kaikki rivit, vaikka vastaavaa tietoa toisessa taulussa ei olisi.
SELECT Tilaukset.id, Asiakkaat.nimi, Tilaukset.toimitus_status
FROM Tilaukset
RIGHT JOIN Asiakkaat ON Tilaukset.asiakas_id = Asiakkaat.id;

/*

 nimi 	toimitus_status 	id 	
Matti Meikäläinen 	toimitettu 	1
Anna Virtanen 	lähetetty 	2
Jari Korhonen 	käsittelyssä 	3
Paula Laine 	toimitettu 	4
Sami Nieminen 	toimitettu 	5
Laura Hiltunen 	lähetetty 	6
Tomi Salminen 	käsittelyssä 	7
Riikka Mäkelä 	lähetetty 	8
Eero Kallio 	toimitettu 	9
Veera Lehtinen 	käsittelyssä 	10
William Taylor 	Toimitettu 	101
Sophia Garcia 	Kadonnut 	102
James Anderson 	NULL 	NULL
Olivia White 	NULL 	NULL
Daniel Lee 	Toimitettu 	103
Nathan Reed 	Kadonnut 	104
*/


-- CROSS JOIN – Luo kaikkien asiakkaiden ja tuotteiden yhdistelmät
-- Tämä tuottaa kaikki mahdolliset asiakas-tuote-yhdistelmät, mikä voi olla hyödyllistä esim. kampanjoiden suunnittelussa.

SELECT Asiakkaat.nimi, Tuotteet.nimi AS Tuote
FROM Asiakkaat
CROSS JOIN Tuotteet;


-- Self join
/* erityinen tapa yhdistäää taulu itsensä ja tätä käytettään silloin, kun taulussa on dataa, joka liittyy toisiinsa saman taulun sisällä, kuten organisaation työntekijän ja heidän esihenkilönsä. 

esim. tarkasteltaisiin Asiakkaita, joilla on sama rekisteröitymispvm ja tästä voi hyödyntää esim. analysoitaessa asiakaskäyttätymistä tai tarjousten kohdentamista.

self join-idean ydin on se, että samaa taulukkoa yhdistetään itseensä, jotta voidaan analysoida tietoja, joissa riveillä on jokin yhteinen tekijä. Voit käyttää self joinia, jos haluat vertailla rivejä taulukon sisällä, esimerkiksi etsimällä asiakkaita, joilla on sama rekisteröitymispäivämäärä, sama sähköpostidomain tai sama saldo.

----------------------------------------------------------------

HYVÄT JA HUONOT PUOLET ITSENSÄ (SELF JOIN):

- Self join on SQL:ssa vähemmän käytetty kuin tavalliset liittymisoperaatiot kuten INNER JOIN tai LEFT JOIN, mutta sitä tarvitaan erityistapauksissa, joissa tauluun tallennettu data viittaa itseensä. Esimerkiksi työntekijät-taulu, jossa työntekijöillä on esihenkilöitä, tallennetaan usein yhteen tauluun, jolloin self join auttaa löytämään yhteyksiä.


Huonot puolet:
❌ Voi olla hidas suurilla tietomäärillä – Self join liittyy samaan tauluun kahdesti, joten isoilla tauluilla suorituskyky voi heiketä. ❌ Vaatii alias-nimiä – Jotta kysely pysyy selkeänä, on käytettävä alias-nimiä (A, B jne.), mikä voi tehdä koodista monimutkaisempaa. ❌ Ei aina ole paras ratkaisu – Joissain tilanteissa eri taulujen liittymiset (JOIN) voivat olla tehokkaampia kuin self join.

Milloin self join kannattaa käyttää?
📌 Kun haluat vertailla rivejä saman taulun sisällä. 📌 Kun taulussa on hierarkkinen suhde (esim. esihenkilöt työntekijöille). 📌 Kun et halua luoda ylimääräisiä tauluja tietojen yhdistämiseen.

Joskus vaihtoehtoiset ratkaisut, kuten CTE (WITH-lauseke) tai alitaulut, voivat olla parempia vaihtoehtoja kuin self join. Riippuu täysin datan rakenteesta


*/

-- tämä kertoo ja hakee jotakin sentään
SELECT A.nimi AS Asiakas1, B.nimi AS Asiakas2, A.rekisteröitymis_pvm
FROM Asiakkaat A
JOIN Asiakkaat B
ON A.rekisteröitymis_pvm <=> B.rekisteröitymis_pvm 
AND A.id <> B.id;

/*
Tuloksena näin, koska tuloksena tarkoittaa molemmilla rekisteröitymis_pvm arvot on NULL. Koska self join -kysely yhdisti kaikki asiakkaat, joilla on sama rekisteröitymispäivämäärä, mutta eri id, ja koska NULL ei ole vertailtavissa tavallisella =-operaattorilla, käytetty <=>-operaattori mahdollisti sen, että NULL-arvot tulivat mukaan vertailuun.

 Asiakas1 	Asiakas2 	rekisteröitymis_pvm 	
Nicole Colombi 	Matti 	NULL
Matti 	Nicole Colombi 	NULL 
*/


-- self join kyselyä, joilla on sama saldo
SELECT A.nimi AS Asiakas1, B.nimi AS Asiakas2, A.saldo
FROM Asiakkaat A
JOIN Asiakkaat B
ON A.saldo = B.saldo
AND A.id <> B.id;


/*

 Asiakas1 	Asiakas2 	saldo 	
Emilia Ranta 	Sami Nieminen 	24327.57
Oliver Koskinen 	Laura Hiltunen 	16340.49
Noora Väänänen 	Nathan Reed 	31193.00
Sami Nieminen 	Emilia Ranta 	24327.57
Laura Hiltunen 	Oliver Koskinen 	16340.49
Nathan Reed 	Noora Väänänen 	31193.00
Sofia Leppänen 	Kasper Laakso 	12345.67
Kasper Laakso 	Sofia Leppänen 	12345.67

*/


--=========================================================================
-- SQL UNION Operator

/* SQL UNION -operaattori yhdistää kahden tai useamman SELECT-lauseen tulokset yhdeksi joukoksi.

Ehdot UNIONin käyttöön: ✅ Jokaisessa SELECT-lauseessa täytyy olla sama määrä sarakkeita. ✅ Sarakkeiden tietotyypit tulee olla samankaltaisia (esim. numerot eivät voi yhdistyä tekstiin). ✅ Sarakkeet täytyy olla samassa järjestyksessä kaikissa SELECT-lauseissa.

ID-arvoilla on iso merkitys tietokannan rakenteessa, varsinkin kun eri tauluissa käytetään eri ID-sarakkeita

Esimerkiksi Asiakkaat-taulussa id viittaa asiakkaan ID:hen, kun taas Tilaukset-taulussa id tarkoittaa tilausta. Tämä voi vaikuttaa esimerkiksi UNION-käyttöön, jos yritetään yhdistää dataa kahdesta eri taulusta, joissa ID-arvoilla on eri merkitys.

====================================================

TUOTANTO JA TÄMÄN UNION KOMENTO KÄYTTÖ


Missä UNIONia käytetään yleisesti?
✔ Raporttien yhdistäminen – Kun halutaan yhdistää eri taulujen dataa yhdeksi listaksi ilman monimutkaisia liittymiä. ✔ Eri lähteistä tulevan datan näyttäminen – Esimerkiksi yhdistää Asiakkaat- ja Työntekijät-taulujen tiedot yhdeksi näkymäksi. ✔ Erillisten kyselyiden yhdistäminen – Kun tietoa haetaan eri tauluista, mutta niiden rakenne on samanlainen.

Onko UNION tehokas?
❌ Ei aina tehokkain tapa – Jos tauluissa on suuria määriä dataa, UNION voi hidastaa kyselyä, koska se poistaa duplikaatit ennen tuloksen palauttamista. ❌ Vaatii samanlaiset sarakkeet – UNION toimii vain, jos SELECT-lauseissa on täsmälleen sama määrä sarakkeita ja niiden tietotyypit vastaavat toisiaan. ✔ UNION ALL voi parantaa suorituskykyä – Jos duplikaattien poistaminen ei ole tarpeen, UNION ALL on nopeampi.

Käytetäänkö UNIONia paljon tuotannossa?
Kyllä, mutta rajoitetusti. Tuotannossa JOIN on yleisempi tapa yhdistää tauluja, koska se on optimoitu liittymään rivejä tehokkaasti. UNIONia käytetään kun taulut eivät liity toisiinsa suoraan, mutta halutaan silti yhdistää niiden data.

*/

-- esim.
SELECT id AS asiakas_id, nimi FROM Asiakkaat
UNION
SELECT id AS tilaus_id, tilaus_pvm FROM Tilaukset;


/*
asiakas_id 	nimi 	
1 	Matti Meikäläinen
2 	Anna Virtanen
3 	Jari Korhonen
4 	Paula Laine
5 	Sami Nieminen
6 	Laura Hiltunen
7 	Tomi Salminen
8 	Riikka Mäkelä
9 	Eero Kallio

*/


-- esimerkissä yhdistää Asiakkaiden ja Tilaus-tiedot. Esim. haettaisiin asiakkaiden ja tilausten nimet, että saaadaan kaikki asiakkaat ja asiakkaiden tekemät tilaukset. 

-- Mitä tämä tekee? ✅ Ensimmäinen osa hakee asiakkaiden id, nimen ja rekisteröitymis_pvm taulusta Asiakkaat. ✅ Toinen osa hakee tilauksien id, tilauspäivämäärän, ja nimeää rivit "Tilaus X", jotta ne erottuvat selkeästi. ✅ UNION yhdistää molemmat tulokset yhdeksi listaksi. ✅ Lisäsarakkeena "tyyppi", joka kertoo, onko kyseessä asiakas vai tilaus.
SELECT id AS tunniste, nimi, rekisteröitymis_pvm, 'Asiakas' AS tyyppi 
FROM Asiakkaat 
UNION SELECT id AS tunniste, CONCAT('Tilaus ', id), tilaus_pvm, 'Tilaus' AS tyyppi FROM Tilaukset; 


/*
TULOSTUS VIEW:
 tunniste 	nimi 	rekisteröitymis_pvm 	tyyppi 	
1 	Matti Meikäläinen 	1965-06-05 	Asiakas
2 	Anna Virtanen 	1964-07-31 	Asiakas
3 	Jari Korhonen 	1975-08-18 	Asiakas
4 	Paula Laine 	1973-05-26 	Asiakas
5 	Sami Nieminen 	1989-02-08 	Asiakas
6 	Laura Hiltunen 	1954-05-05 	Asiakas
7 	Tomi Salminen 	1973-05-21 	Asiakas
8 	Riikka Mäkelä 	1992-11-25 	Asiakas
9 	Eero Kallio 	1973-05-07 	Asiakas


*/


-- UNION ALL Miten se eroaa UNIONista?
-- UNION poistaa automaattisesti päällekkäiset rivit tuloksista. 🔹 UNION ALL säilyttää kaikki duplikaatit eikä tee ylimääräistä suodatusta.


-- esim. tässä tulostettaan ja palautettaa kaikki asiakkaiden ja tilausten nimet, että jotka esiintyvät useammin kuin kerran
SELECT nimi FROM Asiakkaat
UNION ALL
SELECT nimi FROM Tilaukset;

/*
Milloin kannattaa käyttää UNION ALL?
✔ Jos et halua suodattaa duplikaatteja (esim. raportissa). ✔ Jos suorituskyvyn optimointi on tärkeää—UNION ALL on nopeampi kuin UNION, koska se ei tarkista rivien ainutlaatuisuutta. ✔ Kun yhdistetään tietoa eri tauluista ilman tarvetta muokata tuloksia.

❌ Huomio: UNION ALL voi tuottaa liikaa duplikaatteja, joten sitä kannattaa käyttää harkiten!
*/


--=========================================================================

-- SQL GROUP BY Statement

/*
🔹 GROUP BY ryhmittelee rivejä, joilla on samat arvot, ja luo niistä yhteenvedon. 🔹 Usein käytetään yhdessä aggregaattifunktioiden kanssa, kuten:

COUNT() – laskee rivien lukumäärän.

MAX() – löytää suurimman arvon.

MIN() – löytää pienimmän arvon.

SUM() – laskee arvot yhteen.

AVG()

GROUP BY on SQL:ssa ryhmittelyoperaattori, jota käytetään yhdistämään rivejä samojen arvojen perusteella. Se on erityisen hyödyllinen, kun halutaan tehdä tilastollisia laskelmia kuten keskiarvo (AVG()), summa (SUM()), suurin (MAX()) ja pienin (MIN()).

GROUP BY-lauseke on hyvin yleisesti käytetty SQL-kyselyissä, erityisesti tuotantoympäristöissä, joissa käsitellään suuria tietokantoja ja raportointia. Se on keskeinen, kun halutaan ryhmitellä dataa analyysiä ja tilastollista laskentaa varten.

🔹 Mihin GROUP BY käytetään eniten tuotannossa?
✅ Raportit ja tilastot – Myynnin, tilausten ja asiakaskäyttäytymisen analysointi. ✅ Data-analyysi – Keskiarvot, summat, määrät eri kategorioiden tai aikajaksojen mukaan. ✅ Kyselyt sovelluksissa – Verkkokaupan tilaukset, käyttäjätilastot, palvelupyynnöt. ✅ Dashboardit ja BI-työkalut – Analytiikkatyökaluissa kuten Power BI, Tableau ja MySQL Workbench.


❌ Mahdolliset haasteet
Suorituskyky: GROUP BY voi hidastua isoilla tietomäärillä, jos indeksointi ei ole optimoitu.

NULL-arvot: Jos tiedot ovat puutteellisia, aggregaattifunktiot voivat antaa vääriä tuloksia.

Virheet ryhmittelyssä: Jos väärät sarakkeet ryhmitellään, tulos voi olla epäselvä tai väärin laskettu.


*/


-- tässä esim. haettaan Asiakkaiden osoitteen kautta laskettuna AS maat, Asiakkaan taulukosta ja ryhmitettynä kuin osoite(maa). Tämä kuitenkin ryhmittelee asiakkaiden osoitteen (maan) mukaan ja laskee kuinka monta asiakasta on kustakin maasta.
SELECT Asiakkaat.osoite, COUNT(*) AS maa 
FROM Asiakkaat 
GROUP BY osoite; 


/*TULOSTUS VIEW;

osoite 	maa 	
Australia 	4
Belgium 	3
Canada 	1
France 	1
Germany 	5
Italy 	1
Japan 	4
New Zealand 	4
Spain 	3
Suomi 	16
UK 	5
USA 	4
*/



-- Haettaan Tilauksien taulukkosta se id, avg
SELECT Tilaukset.id, AVG(Tilaukset.asiakas_id) AS keskimääräinen_summa 
FROM Tilaukset 
GROUP BY Tilaukset.id; 


-- sama idea kuin ylempi, mutta haettaan TÄMÄN yksittäisen taulukkon nimettyä tuotetta id ja sen kateogria määrä
-- periaatteessa kuitenkin tuotteen id, tuotteen nimi ja summattuna tuotteen kategoria id AS tuotteen kategoria 
SELECT Tuotteet.id, Tuotteet.nimi, SUM(Tuotteet.kategoria_id) as TuotteenKategoria 
FROM Tuotteet 
GROUP BY Tuotteet.id; 


-- saattii korjattu tapa, mutta tässä saattua tuloksena näyttää maksutavan mukaan laskettujen tilausten määrää, vähä kuin esim. käteisellä x kpl:ta. 
SELECT Tilaukset.maksutapa_id, COUNT(*) AS tilausten_maara
FROM Tilaukset
GROUP BY Tilaukset.maksutapa_id;


/*
maksutapa_id 	tilauksien_maara Descending 1 	
1 	9
2 	8
3 	8
*/


-- ==================================================================
-- ALKAEN TÄSTÄ W3SCHOOLS-HARJ2.SQL

-- SQL HAVING Clause
-- 🔹 HAVING lisättiin SQL:ään, koska WHERE ei voi suodattaa aggregaattifunktioita kuten SUM(), AVG(), COUNT(), MAX() ja MIN(). 🔹 Se toimii yhdessä GROUP BY -lauseen kanssa, jotta voidaan suodattaa ryhmän tuloksia aggregaattifunktioiden perusteella.


-- Tämä näyttää vain ne asiakkaat, joilla on enemmän kuin yksi tilaus. Esim. yksi tai useammalla henkilöllä on pari-muutama tilausta laskettuna
SELECT asiakas_id, COUNT(*) AS tilauksien_maara
FROM Tilaukset
GROUP BY asiakas_id
HAVING tilauksien_maara > 1;


-- lisäsin JOIN yhdistämällä Tilauksen ja Asiakkaan taulukon, että esim. varmistettaan molempien taulukkojen asiakkaiden ja tilauksen id täsmentyvät - ihan kuin reallisessa maailmassa että menee oikeaan tilaan. HAVING-lauseketta voidaan käyttää, mikäli jos haluttaisiin ryhmiteltyjä tulosta aggregaattifunktiolla. Ja tässä suodataan tilausta, joka on yli 2 tilausta.
/*
✅ Mitä tämä tekee?

JOIN yhdistää asiakkaat ja tilaukset asiakas-ID:n perusteella.

COUNT(Tilaukset.id) laskee, montako tilausta kullakin asiakkaalla on.

GROUP BY ryhmittelee tulokset asiakas ID:n ja nimen mukaan.

HAVING tilauksien_maara > 2 suodattaa vain ne asiakkaat, joilla on yli 2 tilausta.


📌 Milloin HAVING kannattaa käyttää?
✔ Kun suodatetaan ryhmiteltyjä tuloksia, esimerkiksi yli 3 tilausta tehneet asiakkaat. ❌ WHERE ei toimi tässä, koska aggregaattifunktioita ei voi käyttää siinä suoraan.

*/
SELECT Asiakkaat.id, Asiakkaat.nimi, COUNT(Tilaukset.id) AS tilauksien_maara, Tilaukset.toimitus_status 
FROM Asiakkaat JOIN Tilaukset ON Asiakkaat.id = Tilaukset.asiakas_id 
GROUP BY Asiakkaat.id, Asiakkaat.nimi 
HAVING tilauksien_maara > 2; 



-- Laske, kuinka monta kappaletta kutakin tuotetta on tilattu (GROUP BY) ja halutaan nähdä tästä kuinka monta kpl:tta kutakin uotetta on tilattu. 
-- Ideana on ryhmittellä tuotenimen mukaan ja laskea kuinka monta kappaleta kutakin tuotetta on ostettu.
SELECT Tuotteet.nimi, SUM(Tilauksen_rivit.määrä) AS kokonaistilaukset 
FROM Tilauksen_rivit JOIN Tuotteet ON Tilauksen_rivit.tuote_id = Tuotteet.id 
GROUP BY Tuotteet.nimi; 


-- Suodata tuotteet, joiden tilaukset ylittävät tietyn määrän (HAVING)
-- tästä suodataan vain tuotteet, joita on tilattu yli esim. 5 kplta ja vain niitä tuotetta
SELECT Tuotteet.nimi, SUM(Tilauksen_rivit.määrä) AS kokonaistilaukset 
FROM Tilauksen_rivit JOIN Tuotteet ON Tilauksen_rivit.tuote_id = Tuotteet.id 
GROUP BY Tuotteet.nimi HAVING kokonaistilaukset > 5; 



-- Laske asiakkaan kokonaisostokset (JOIN Tilaukset + GROUP BY)
-- eli haluttaan nähdä asiakkaiden tilattua kokonais ostosta ja sitä summaa, kukin asiakas on käyttänyt rahaa/saldoa
SELECT Tilaukset.asiakas_id, SUM(Tilauksen_rivit.yhteishinta) AS asiakkaan_kulut 
FROM Tilauksen_rivit JOIN Tilaukset ON Tilauksen_rivit.tilaus_id = Tilaukset.id 
GROUP BY Tilaukset.asiakas_id; 


-- GROUP BY voidaan yhdistää WHERE, JOIN, INNER JOIN, ja HAVING COUNT erikseen.

-- esim. laskettaisiin varastontilannetta, että mukaan ja suodattaa vain tuotteet jotka maksavat esim. yli 50e, ja käytettään WHERE ennen GROUP BY
SELECT varastotilanne, COUNT(*) AS tuote_maara
FROM Tuotteet
WHERE hinta > 50
GROUP BY varastotilanne;


-- sama kuin ylempi, mutta ryhmitettynä mukaan ja tulostettuna nimet, suodatettaan jolla on alle 5k saldoa
SELECT Asiakkaat.nimi, Asiakkaat.saldo, COUNT(*) AS saldoMäärä 
FROM Asiakkaat WHERE Asiakkaat.saldo < 5000 
GROUP BY Asiakkaat.nimi; 


-- GROUP BY + INNER JOIN
-- jos halutaisiin laskea, kuinka monta tuotetta on tilattu per kategoria ja yhdistetään Tuotteet ja Tilauksen_rivit INNER JOIN:illa molempia taulukkoita.
SELECT Tuotteet.kategoria_id, COUNT(Tilauksen_rivit.tuote_id) AS tilattu_maara
FROM Tuotteet
INNER JOIN Tilauksen_rivit ON Tuotteet.id = Tilauksen_rivit.tuote_id
GROUP BY Tuotteet.kategoria_id;


-- GROUP BY + HAVING COUNT
-- haluttaan näyttää vain tuotteet, joita on tilattu enemmän kuin 2 kertaa, niin käytettään HAVING COUNT ja ideana on suodattaa pois tuotteet, joita on tilattu ja näyttää vain ne joita on tilattu enemmän
SELECT tuote_id, COUNT(*) AS tilattu_maara 
FROM Tilauksen_rivit 
GROUP BY tuote_id HAVING tilattu_maara > 2; 


-- GROUP BY + JOIN + HAVING COUNT
-- haluttaan näyttää asiakkaiden nimet, jotka ovat tehneet yli 5 tilausta (sen mukaan mitä määrittää) ja yhdistämällä Tilausket ja Asiakkaan taulukkoa, ja suodataan HAVING COUNT-lauseella.

SELECT Asiakkaat.nimi, COUNT(Tilaukset.id) AS tilausten_maara
FROM Asiakkaat
JOIN Tilaukset ON Asiakkaat.id = Tilaukset.asiakas_id
GROUP BY Asiakkaat.nimi
HAVING tilausten_maara > 5;


-- =========================================================================================
-- SQL EXISTS Operator

/* 
✅ EXISTS-operaattori tarkistaa, onko alikyselyssä yhtään riviä. 
✅ Se palauttaa TRUE, jos alikysely löytää vähintään yhden rivin. 
✅ Jos alikysely ei palauta mitään, EXISTS palauttaa FALSE.
EXISTS on hyödyllinen, kun haluat varmistaa, että tietty ehto täyttyy ilman turhaa tiedon hakemista

SELECT nimi 
FROM Asiakkaat 
WHERE EXISTS (SELECT 1 FROM Tilaukset WHERE Asiakkaat.id = Tilaukset.asiakas_id);

*/

-- esim. tämä näyttää VAIN asiakkaat, jotka ovat tehneet vähintään yhden 1 tilauksensa
SELECT nimi 
FROM Asiakkaat 
WHERE EXISTS (SELECT 1 FROM Tilaukset WHERE Asiakkaat.id = Tilaukset.asiakas_id);


-- kokeillaan pikkasen muuta että tarkistellaan Tuotteen nimen ja varastotilannetta, että tilauksensa joka varastotilanne on yli 50kpl:ta
-- samaan voihan jos tietää on tasa luku vaikappa = 80 - esim. tuotteen tilanteesta niin se löytää täsmällisen määrän
SELECT Tuotteet.nimi, Tuotteet.varastotilanne 
FROM Tuotteet 
WHERE EXISTS (SELECT 1 FROM Tilaukset WHERE Tilaukset.id AND Tuotteet.varastotilanne > 50); 



-- muita esimerkkejä, ja kokeillaan onko Asiakkaiden taulukosta, joilla on tilausta ja tämä komento hakee vain ne asiakkaat joilla on esim. vähintään yksi tilaus (SELECT 1 FROM Tilaukset)
SELECT * FROM Asiakkaat
WHERE EXISTS (
    SELECT 1 FROM Tilaukset 
    WHERE Tilaukset.asiakas_id = Asiakkaat.id
);


-- nyt etsitään Asiakkasta, joilla EI OLE tilauksia eli käänteinen logiikka
SELECT * FROM Asiakkaat
WHERE NOT EXISTS (
    SELECT 1 FROM Tilaukset 
    WHERE Tilaukset.asiakas_id = Asiakkaat.id
);


-- etsitään asiakkasta, jotka ovat ostaneet tietyn tuotteen Jos haluat löytää asiakkaat, jotka ovat tilanneet tietyn tuotteen. Tässä on käytetty 3 taulukkoa yhdistettynä.
SELECT * FROM Asiakkaat 
WHERE EXISTS ( SELECT 1 FROM Tilauksen_rivit JOIN Tilaukset ON Tilauksen_rivit.tilaus_id = Tilaukset.id 
WHERE Tilauksen_rivit.tuote_id = 5 AND Tilaukset.asiakas_id = Asiakkaat.id ); 


-- etsitään ja suodatettaan asiakkaan, joiden tilaukset on käsitelty Jos haluat listata vain ne asiakkaat, joiden tilauksia on käsitelty (toimitus_status = 'käsittelyssä'),
SELECT Asiakkaat.nimi, Asiakkaat.id 
FROM Asiakkaat 
WHERE EXISTS ( SELECT 1 FROM Tilaukset 
WHERE Tilaukset.asiakas_id = Asiakkaat.id AND Tilaukset.toimitus_status = 'käsittelyssä' ); 




-- kokeillaan jotekin saada lisäättyä saldoa +100, mutta ennen tarkistellaan se tuloksensa, mitä tässä komennossa tulostuukaan.
SELECT id, nimi, saldo 
FROM Asiakkaat WHERE EXISTS ( SELECT 1 FROM Tilaukset 
WHERE Tilaukset.asiakas_id = Asiakkaat.id AND Tilaukset.toimitus_status = 'käsittelyssä' ); 

/*
BEFORE:
Full texts
	id 	nimi 	saldo 	
	Edit Edit 	Copy Copy 	Delete Delete 	1 	Matti Meikäläinen 	6860.87
	Edit Edit 	Copy Copy 	Delete Delete 	3 	Jari Korhonen 	28267.12
	Edit Edit 	Copy Copy 	Delete Delete 	7 	Tomi Salminen 	8819.74
	Edit Edit 	Copy Copy 	Delete Delete 	10 	Veera Lehtinen 	50003.36
	Edit Edit 	Copy Copy 	Delete Delete 	17 	Isabella Evans 	42731.48
	Edit Edit 	Copy Copy 	Delete Delete 	21 	Olivia Mäkinen 	3902.34
	Edit Edit 	Copy Copy 	Delete Delete 	22 	Leon Shawn 	44232.84
	Edit Edit 	Copy Copy 	Delete Delete 	106 	Yuki Nakamura 	27660.88
	Edit Edit 	Copy Copy 	Delete Delete 	108 	Jessica Carter 	42487.92
	Edit Edit 	Copy Copy 	Delete Delete 	109 	Brandon Mitchell 	19972.65
	Edit Edit 	Copy Copy 	Delete Delete 	111 	Oliver Bennett 	28835.67


*/

-- sitten suoritettaan tällainen komento UPDATE ja mukaan lukien on toi EXISTS komento
UPDATE Asiakkaat
SET saldo = saldo + 100
WHERE EXISTS (
    SELECT 1 FROM Tilaukset 
    WHERE Tilaukset.asiakas_id = Asiakkaat.id
    AND Tilaukset.toimitus_status = 'käsittelyssä'
)


-- sitten toistettaan se sama komento, jossa tarkistellaan henkilön id, nimi ja heidän saldonsa ja muutos kyllä tapahtui eli after:
SELECT id, nimi, saldo 
FROM Asiakkaat WHERE EXISTS ( SELECT 1 FROM Tilaukset 
WHERE Tilaukset.asiakas_id = Asiakkaat.id AND Tilaukset.toimitus_status = 'käsittelyssä' ); 

/*
AFTER
Full texts
	id 	nimi 	saldo 	
	Edit Edit 	Copy Copy 	Delete Delete 	1 	Matti Meikäläinen 	6960.87
	Edit Edit 	Copy Copy 	Delete Delete 	3 	Jari Korhonen 	28367.12
	Edit Edit 	Copy Copy 	Delete Delete 	7 	Tomi Salminen 	8919.74
	Edit Edit 	Copy Copy 	Delete Delete 	10 	Veera Lehtinen 	50103.36
	Edit Edit 	Copy Copy 	Delete Delete 	17 	Isabella Evans 	42831.48
	Edit Edit 	Copy Copy 	Delete Delete 	21 	Olivia Mäkinen 	4002.34
	Edit Edit 	Copy Copy 	Delete Delete 	22 	Leon Shawn 	44332.84
	Edit Edit 	Copy Copy 	Delete Delete 	106 	Yuki Nakamura 	27760.88
	Edit Edit 	Copy Copy 	Delete Delete 	108 	Jessica Carter 	42587.92
	Edit Edit 	Copy Copy 	Delete Delete 	109 	Brandon Mitchell 	20072.65
	Edit Edit 	Copy Copy 	Delete Delete 	111 	Oliver Bennett 	28935.67

*/



--===========================================================================================
-- SQL ANY and ALL Operators

/*

SQL ANY ja ALL -operaattorit
✅ ANY ja ALL-operaattorit mahdollistavat vertailun yhden sarakkeen arvon ja joukon muiden arvojen välillä. ✅ Näitä käytetään yleensä subqueryjen kanssa ja toimivat vertailuoperaattoreiden kuten <, >, = ja != kanssa.


🔹 SQL ANY -operaattori
✔ Palauttaa TRUE, jos yksi tai useampi alikyselyn arvo täyttää ehdon. ✔ Ehto toteutuu, jos vertailuoperaatio pitää paikkansa minkä tahansa alikyselyn arvon kohdalla.

*/

-- esim näyttää tuotteen, joka on halvempi kuin mikä tahansa tilattu tuote. ANY tässä tarkoittaa, että tuote näytetään, jos se on halvempi kuin yksikin tilauksen yhteishinta.
SELECT nimi FROM Tuotteet 
WHERE hinta < ANY (SELECT yhteishinta FROM Tilauksen_rivit);


-- 🔹 SQL ALL -operaattori
-- ✔ Palauttaa TRUE, jos ehto täyttyy kaikille alikyselyn palauttamille arvoille. ✔ Ehto toteutuu vain, jos vertailuoperaatio on tosi jokaisen alikyselyn arvon kohdalla.

-- tämä näyttää tuotteensa, jotka ovat kalliimpia kuin kaikki tilatut ja ALL tässä tarkoittaa, että tuote näytetään vain jos se on kalliimpi kuin jokainen tilauksen yhteishinta.
SELECT Tuotteet.nimi, Tuotteet.hinta 
FROM Tuotteet 
WHERE hinta > ALL (SELECT yhteishinta FROM Tilauksen_rivit); 


/* ANY vs. ALL - eronsa

WHERE hinta < ANY (...)	✅ TRUE, jos hinta on vähemmän kuin jokin alikyselyn arvoista
WHERE hinta > ALL (...)	✅ TRUE, vain jos hinta on suurempi kuin kaikki alikyselyn arvot

Näitä käytetään erityisesti vertailuja varten, kun halutaan tarkastella dataa dynaamisesti

🔹 ANY tarkoittaa mikä tahansa arvo alikyselystä voi täyttää ehdon. Jos yksikin arvo täyttää vertailuehdon, koko ehto on TRUE. 
🔹 ALL tarkoittaa kaikkien alikyselyn arvojen täytyy täyttää ehto. Ehto pitää paikkansa vain jos se pätee kaikille

Eli ANY antaa joustavuutta, kun taas ALL pakottaa täyttämään ehdon kaikille arvoille
*/


-- tämä näyttää tuotteet, joita ei ole tilattu yhtään ja ✅ ALL tässä varmistaa, että vain tuotteet, joita ei ole tilattu yhtään, näkyvät.
SELECT nimi FROM Tuotteet
WHERE id != ALL (SELECT tuote_id FROM Tilauksen_rivit);



-- ANY ja ALL voivat olla erittäin tehokkaita yhdistettynä WHERE- ja HAVING-lausekkeisiin.

-- ANY + WHERE + HAVING: Näytä asiakkaat, joiden saldo on pienempi kuin minkä tahansa tilausten yhteishinta
-- tämä WHERE saldo < ANY (...) antaa asiakkaan saldo on pienempi kuin ainakin yksi tilauksen yhteishinta. 
-- HAVING saldo > 0: Näytetään vain asiakkaat, joilla on saldoa jäljellä.
SELECT Asiakkaat.nimi, Asiakkaat.saldo
FROM Asiakkaat
WHERE saldo < ANY (SELECT yhteishinta FROM Tilauksen_rivit)
HAVING saldo > 0;

/* OUTOA?
Tämä (ylempi) komento antoi tuloksensa jolla yhdellä henkilöllä on noin 269.30 (saldoa), eikä lähellä nollaa? 


1️⃣ WHERE saldo < ANY (...):

Tämä tarkoittaa, että asiakkaan saldo on pienempi kuin ainakin yksi Tilauksen_rivit-taulun yhteishinta.
Koska ANY sallii vertailun mihin tahansa arvoon, se ei vaadi, että saldo on pienempi kuin kaikki yhteishinnat.

2️⃣ HAVING saldo > 0:

Tämä suodattaa pois kaikki asiakkaat, joiden saldo on 0 tai negatiivinen.
Vain positiivisen saldon omaavat jäävät jäljelle.

ainakin tämä kertoi ja antoi kaikki ainutlaatuisen yhteishinnan, jotta näkee mikä saattaa olla llähellä asiakkaan saldoa.. 
*/

-- nyt tämä sisältää myös asiakkaansa, joiden saldo on yli 200 €, mutta silti pienempi kuin joku yhteishinta.
SELECT Asiakkaat.nimi, Asiakkaat.saldo
FROM Asiakkaat
WHERE saldo < ANY (SELECT yhteishinta FROM Tilauksen_rivit)
HAVING saldo > 200;


--===========================================================================================

-- SQL INSERT INTO SELECT Statement
/*
✅ INSERT INTO SELECT kopioi dataa yhdestä taulusta toiseen. 
✅ Tämä vaatii, että lähde- ja kohdetaulujen tietotyypit vastaavat toisiaan. 
✅ Käytetään usein varmuuskopiointiin, tietojen siirtämiseen tai raporttien luomiseen.

*/

-- ArkistoidutTilaukset-taulukko täytyy luoda ensin, jotta INSERT INTO SELECT toimii. Jos taulukkoa ei ole olemassa, kysely aiheuttaa virheen. Tämä toimii kuin backup prosessi, mutta kopsaa nykyisen Tilauksen-taulukon dataa ja se liittää sinne jos on luonut uuden X- taulukkon
INSERT INTO ArkistoidutTilaukset (id, asiakas_id, tilaus_pvm, toimitus_status, maksutapa_id)
SELECT id, asiakas_id, tilaus_pvm, toimitus_status, maksutapa_id FROM Tilaukset;




