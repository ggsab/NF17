CREATE TYPE "Adresse" AS
(
	"Numero" integer,
	"NomVoie" text
);

CREATE TYPE "Classe" AS ENUM
    ('1', '2');
    
CREATE TYPE "MoyenPaiement" AS ENUM
    ('especes', 'cheque', 'carte_bleue');
    
CREATE TYPE "StatutVoyageur" AS ENUM
    ('Occasionnel', 'Argent', 'Or', 'Platine');



CREATE TABLE "Gare"
(
    "Nom" varchar NOT NULL,
    "Adresse" varchar NOT NULL,
    "Ville" varchar NOT NULL,
    "ZoneHor" varchar NOT NULL,
    CONSTRAINT "Gare_pkey" PRIMARY KEY ("Nom", "Ville")
);

CREATE TABLE "Hotel"
(
    "Nom" varchar NOT NULL,
    "Adresse" varchar NOT NULL,
    "Ville" varchar NOT NULL,
    "Gare" varchar,
    "PrixNuit" integer,
    CONSTRAINT "Hotel_pkey" PRIMARY KEY ("Nom", "Ville"),
    CONSTRAINT "Adresse_Ville_key" UNIQUE ("Adresse", "Ville"),
    CONSTRAINT "Gare_Ville_fkey" FOREIGN KEY ("Gare", "Ville")
        REFERENCES "Gare" ("Nom", "Ville") MATCH SIMPLE,
    CONSTRAINT "PrixNuit_pos" CHECK ("PrixNuit" > 0)
);

CREATE TABLE "TypeTrain"
(
    "Nom" varchar(20) NOT NULL,
    "nbPlacesPrem" integer NOT NULL,
    "nbPlacesSec" integer NOT NULL,
    "vitesseMax" integer NOT NULL,
    CONSTRAINT "TypeTrain_pkey" PRIMARY KEY ("Nom"),
    CONSTRAINT "nbPlacesPrem_pos" CHECK ("nbPlacesPrem" >= 0),
    CONSTRAINT "nbPlacesSec_pos" CHECK ("nbPlacesSec" > 0),
    CONSTRAINT "vitesseMax_pos" CHECK ("vitesseMax" > 0)
);

CREATE TABLE "Ligne"
(
    "Id" integer NOT NULL,
    "NomGareDep" varchar,
    "VilleGareDep" varchar,
    "NomGareArr" varchar,
    "VilleGareArr" varchar,
    "TypeTrain" varchar,
    CONSTRAINT "Ligne_pkey" PRIMARY KEY ("Id"),
    CONSTRAINT "Donnees_uniques" UNIQUE ("NomGareDep", "VilleGareDep", "NomGareArr", "VilleGareArr", "TypeTrain"),
    CONSTRAINT "GareArr_fkey" FOREIGN KEY ("NomGareArr", "VilleGareArr")
        REFERENCES "Gare" ("Nom", "Ville") MATCH SIMPLE,
    CONSTRAINT "GareDep_fkey" FOREIGN KEY ("NomGareDep", "VilleGareDep")
        REFERENCES "Gare" ("Nom", "Ville") MATCH SIMPLE,
    CONSTRAINT "Ligne_TypeTrain_fkey" FOREIGN KEY ("TypeTrain")
        REFERENCES "TypeTrain" ("Nom") MATCH SIMPLE,
    CONSTRAINT "Id_diff_0" CHECK ("Id" <> 0)
);

CREATE TABLE "Planning"
(
    "Nom" varchar NOT NULL,
    "Lundi" boolean NOT NULL,
    "Mardi" boolean NOT NULL,
    "Mercredi" boolean NOT NULL,
    "Jeudi" boolean NOT NULL,
    "Vendredi" boolean NOT NULL,
    "Samedi" boolean NOT NULL,
    "Dimanche" boolean NOT NULL,
    CONSTRAINT "Planning_pkey" PRIMARY KEY ("Nom"),
    CONSTRAINT "Donnees_key" UNIQUE ("Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi", "Dimanche")
);

CREATE TABLE "Exception"
(
    "Planning" varchar NOT NULL,
    "Ajoute" boolean NOT NULL,
    "DateDebut" date NOT NULL,
    "DateFin" date,
    "Id" integer NOT NULL,
    CONSTRAINT "Exception_pkey" PRIMARY KEY ("Id"),
    CONSTRAINT "Planning_fkey" FOREIGN KEY ("Planning")
        REFERENCES "Planning" ("Nom") MATCH SIMPLE,
    CONSTRAINT "DateDebut_DateFin_key" UNIQUE ("Planning", "DateDebut", "DateFin"),
    CONSTRAINT "DateDebutInferieurDateFin" CHECK ("DateDebut"<="DateFin"),
    CONSTRAINT "Id_diff_0" CHECK ("Id" <> 0),
    CONSTRAINT "overlapingExceptions" CHECK ("areExceptionsOverlaping"("DateDebut","DateFin")=0)
);

CREATE TABLE "Trajet"
(
    "Id" integer NOT NULL,
    "Ligne" integer NOT NULL,
    "HeureDepart" time without time zone NOT NULL,
    "HeureArrivee" time without time zone NOT NULL,
    "PrixPrem" numeric(5,2),
    "PrixSec" numeric(5,2) NOT NULL,
    "Planning" varchar,
    CONSTRAINT "Trajet_pkey" PRIMARY KEY ("Id"),
    CONSTRAINT "Pas_deux_departs_en_mm_tmps" UNIQUE ("HeureArrivee", "Ligne"),
    CONSTRAINT "Pas_deux_arrivees_en_mm_tmps" UNIQUE ("HeureDepart", "Ligne"),
    CONSTRAINT "Ligne_fkey" FOREIGN KEY ("Ligne")
        REFERENCES "Ligne" ("Id") MATCH SIMPLE,
    CONSTRAINT "Planning_fkey" FOREIGN KEY ("Planning")
        REFERENCES "Planning" ("Nom") MATCH SIMPLE,
    CONSTRAINT "Arrivee_apres_depart" CHECK ("HeureDepart" < "HeureArrivee"),
    CONSTRAINT "PrixSec_pos" CHECK ("PrixSec" > 0),
    CONSTRAINT "PrixPrem_pos" CHECK ("PrixPrem" > 0),
    CONSTRAINT "Id_diff_0" CHECK ("Id" <> 0)
);

CREATE TABLE "Voyageur"
(
    "idVoyageur" integer NOT NULL,
    "nom" varchar(20) NOT NULL,
    "prenom" varchar(20) NOT NULL,
    "numeroTel" numeric(10,0),
    "numeroCarte" numeric(12,0),
    ville varchar,
    "typeVoyageur" "StatutVoyageur" NOT NULL,
    adresse "Adresse",
    CONSTRAINT "Voyageur_pkey" PRIMARY KEY ("idVoyageur"),
    CONSTRAINT "Nom_prenom_adresse_ville_key" UNIQUE (nom, prenom, adresse, ville),
    CONSTRAINT "NumeroCarte_key" UNIQUE ("numeroCarte"),
    CONSTRAINT "NumeroTel_key" UNIQUE ("numeroTel"),
    CONSTRAINT "Id_diff_0" CHECK ("idVoyageur" <> 0)
);

CREATE TABLE "Reservation"
(
    "Id" integer NOT NULL,
    "Voyageur" integer NOT NULL,
    "Assurance" boolean NOT NULL,
    "MoyenPaiement" "MoyenPaiement" NOT NULL,
    CONSTRAINT "Reservation_pkey" PRIMARY KEY ("Id"),
    CONSTRAINT "Voyageur_fkey" FOREIGN KEY ("Voyageur")
        REFERENCES "Voyageur" ("idVoyageur") MATCH SIMPLE,
    CONSTRAINT "Id_diff_0" CHECK ("Id" <> 0)
);

CREATE TABLE "Billet"
(
    "Id" integer NOT NULL,
    "Trajet" integer NOT NULL,
    "Date" date NOT NULL,
    "Classe" "Classe" NOT NULL,
    "Place" integer,
    "Annule" boolean NOT NULL,
    "Reservation" integer NOT NULL,
    CONSTRAINT "Billet_pkey" PRIMARY KEY ("Id"),
    CONSTRAINT "Reservation_fkey" FOREIGN KEY ("Reservation")
        REFERENCES "Reservation" ("Id") MATCH SIMPLE,
    CONSTRAINT "Trajet_fkey" FOREIGN KEY ("Trajet")
        REFERENCES "Trajet" ("Id") MATCH SIMPLE,
    CONSTRAINT "Place_pos" CHECK ("Place" > 0),
    CONSTRAINT "Id_diff_0" CHECK ("Id" <> 0)
);




CREATE OR REPLACE FUNCTION "trouverLigne"(
	villed varchar,
	villea varchar)
RETURNS integer[]
    LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    lignes_ok integer[];

BEGIN
    SELECT array_agg("Id") INTO lignes_ok
    FROM "Ligne"
    WHERE "VilleGareDep" = VilleD
    AND "VilleGareArr" = VilleA;

    IF array_length(lignes_ok, 1) <= 0 THEN
        RAISE EXCEPTION 'Pas de train entre % et %.', VilleD, VilleA;
    END IF;

    RETURN lignes_ok;
END
$BODY$;

CREATE OR REPLACE FUNCTION "trouverPlanning"(
	jour date)
RETURNS integer[]
    LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    jour_semaine integer;
    plannings_ok integer[];

BEGIN
    jour_semaine := extract(isodow from jour);
    
    CASE jour_semaine
    WHEN 1 THEN
        SELECT array_agg("Id") INTO plannings_ok
        FROM "Planning"
        WHERE "Lundi" = true;
        
    WHEN 2 THEN
        SELECT array_agg("Id") INTO plannings_ok
        FROM "Planning"
        WHERE "Mardi" = true;
        
    WHEN 3 THEN
        SELECT array_agg("Id") INTO plannings_ok
        FROM "Planning"
        WHERE "Mercredi" = true;
        
    WHEN 4 THEN
        SELECT array_agg("Id") INTO plannings_ok
        FROM "Planning"
        WHERE "Jeudi" = true;
        
    WHEN 5 THEN
        SELECT array_agg("Id") INTO plannings_ok
        FROM "Planning"
        WHERE "Vendredi" = true;
        
    WHEN 6 THEN
        SELECT array_agg("Id") INTO plannings_ok
        FROM "Planning"
        WHERE "Samedi" = true;
        
    WHEN 7 THEN
        SELECT array_agg("Id") INTO plannings_ok
        FROM "Planning"
        WHERE "Dimanche" = true;
        
    END CASE;
    
    IF array_length(plannings_ok, 1) <= 0 THEN
        RAISE EXCEPTION 'Aucun train planifie le %.', jour;
    END IF;
    
    RETURN plannings_ok;
END
$BODY$;

CREATE OR REPLACE FUNCTION "trouverTrajet"(
	villeD varchar,
	villeA varchar,
	jour date)
RETURNS TABLE(num_trajet integer,
    gare_dep varchar, 
    heure_dep time without time zone, 
    gare_arr varchar,
    heure_arr time without time zone, 
    prix_sec integer, 
    prix_prem integer,
    train varchar) 
    LANGUAGE 'plpgsql'
AS $BODY$

BEGIN
    RETURN QUERY SELECT "Trajet"."Id", "NomGareDep", "HeureDepart", "NomGareArr", "HeureArrivee", "PrixSec", "PrixPrem", "TypeTrain"
    FROM "Trajet" INNER JOIN "Ligne"
    ON "Trajet"."Ligne" = "Ligne"."Id"
    WHERE "Trajet"."Ligne" = ANY("trouverLigne"(villeD, villeA))
    AND "Trajet"."Planning" = ANY("trouverPlanning"(jour));
END
$BODY$;


CREATE OR REPLACE FUNCTION "areExceptionsOverlaping"(
  DateDebut Date,
  DateFin Date
)
RETURNS int
LANGUAGE 'plpgsql'
AS $BODY$

DECLARE
  Result int;
BEGIN
  Result:=0;
  IF EXISTS(SELECT * FROM "Exception" e WHERE NOT ((e."DateDebut"<DateDebut and e."DateFin"<DateDebut) or (e."DateDebut">DateFin and e."DateFin" > DateFin)))
	THEN
	Result := 1;
	END IF;
  RETURN Result;
END
$BODY$;



CREATE OR REPLACE FUNCTION "placesRestantes"(
    numTrain integer,
    jour date)
RETURNS TABLE(
    placesPrem integer,
    placesSec integer)
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    places_total1 integer;
    places_prises1 integer;
    places_total2 integer;
    places_prises2 integer;

BEGIN

    SELECT "nbPlacesPrem" INTO places_total1
    FROM "Trajet" INNER JOIN "Ligne"
    ON "Trajet"."Ligne" = "Ligne"."Id"
    INNER JOIN "TypeTrain"
    ON "Ligne"."TypeTrain" = "TypeTrain"."Nom"
    WHERE "Trajet"."Id" = numTrain;
    
    SELECT COUNT("Id") INTO places_prises1
    FROM "Billet"
    WHERE "Trajet" = numTrain
    AND "Date" = jour
    AND "Classe" = 1;
    
    SELECT "nbPlacesSec" INTO places_total2
    FROM "Trajet" INNER JOIN "Ligne"
    ON "Trajet"."Ligne" = "Ligne"."Id"
    INNER JOIN "TypeTrain"
    ON "Ligne"."TypeTrain" = "TypeTrain"."Nom"
    WHERE "Trajet"."Id" = numTrain;
    
    SELECT COUNT("Id") INTO places_prises2
    FROM "Billet"
    WHERE "Trajet"."Id" = numTrain
    AND "Date" = jour
    AND "Classe" = 2;
    
    RETURN QUERY SELECT places_total1-places_prises1, places_total2-places_prises2;

END
$BODY$;
