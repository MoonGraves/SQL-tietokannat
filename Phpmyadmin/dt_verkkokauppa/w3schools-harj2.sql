
-- ==================================================================
-- ALKAEN TÄSTÄ W3SCHOOLS-HARJ2.SQL
-- MUUTAMIA HARJOITUKSIA W3SCHOOLS JA LISÄÄ EDITOITUNA

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

