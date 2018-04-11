INSERT INTO "TypeTrain" ("Nom", "nbPlacesPrem", "nbPlacesSec", "vitesseMax") VALUES 
('Petit TER', 0, 452, 160),
('Grand TER', 60, 744, 160),
('Intercites', 210, 1008, 200),
('TGV Atlantique', 275, 600, 300),
('TGV Duplex', 364, 656, 320)
;

INSERT INTO "Gare" ("Nom", "Adresse", "Ville", "ZoneHor") VALUES
('Bordeaux Saint-Jean', '1 rue Charles Domercq', 'Bordeaux', 'UTC+2'),
('Gare de Compiegne', '1 place de la Gare', 'Compiegne', 'UTC+2'),
('Gare de Lyon', '1 place Louis Armand', 'Paris', 'UTC+2'),
('Gare de Maubeuge', '1 rue du Gazometre', 'Maubeuge', 'UTC+2'),
('Gare du Nord', '18 rue de Dunkerque', 'Paris', 'UTC+2'),
('Gare Montparnasse', '17 boulevard de Vaugirard', 'Paris', 'UTC+2'),
('Lyon Part-Dieu', '5 place Charles Beraudier', 'Lyon', 'UTC+2')
;

INSERT INTO "Ligne" ("Id", "NomGareDep", "VilleGareDep", "NomGareArr", "VilleGareArr", "TypeTrain") VALUES 
(1, 'Gare du Nord', 'Paris', 'Gare de Compiegne', 'Compiegne', 'Grand TER'),
(2, 'Gare de Compiegne', 'Compiegne', 'Gare du Nord', 'Paris', 'Grand TER'),
(3, 'Gare du Nord', 'Paris', 'Gare de Maubeuge', 'Maubeuge', 'Intercites'),
(4, 'Gare de Maubeuge', 'Maubeuge', 'Gare du Nord', 'Paris', 'Intercites'),
(5, 'Gare Montparnasse', 'Paris', 'Bordeaux Saint-Jean', 'Bordeaux', 'TGV Atlantique'),
(6, 'Bordeaux Saint-Jean', 'Bordeaux', 'Gare Montparnasse', 'Paris', 'TGV Atlantique'),
(7, 'Gare de Lyon', 'Paris', 'Lyon Part-Dieu', 'Lyon', 'TGV Duplex'),
(8, 'Lyon Part-Dieu', 'Lyon', 'Gare de Lyon', 'Paris', 'TGV Duplex'),
(9, 'Gare du Nord', 'Paris', 'Gare de Compiegne', 'Compiegne', 'Intercites'),
(10, 'Gare de Compiegne', 'Compiegne', 'Gare du Nord', 'Paris', 'Intercites')
;

INSERT INTO "Planning" ("Nom", "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi", "Dimanche") VALUES
('Tous les jours', true, true, true, true, true, true, true),
('Jours ouvres', true, true, true, true, true, false, false),
('Week end', false, false, false, false, false, true, true)
;

INSERT INTO "Trajet" ("Id", "Ligne", "HeureDepart", "HeureArrivee", "PrixPrem", "PrixSec", "Planning") VALUES
(1, 2, '07:35:00', '08:26:00', NULL, 015.00, 'Tous les jours'),
(2, 1, '07:34:00', '08:26:00', NULL, 015.00, 'Tous les jours'),
(3, 10, '19:00:00', '19:41:00', 015.00, 013.00, 'Jours ouvres'),
(4, 9, '19:16:00', '19:58:00', 015.00, 013.00, 'Jours ouvres')
;

INSERT INTO "Voyageur" ("idVoyageur", "nom", "prenom", "numeroTel", "numeroCarte", "ville", "adresse", "typeVoyageur") VALUES
(1, 'Zhao', 'Paul', '0605040302', '001234567890', 'Compiegne', (1, 'rue de la Joie'), 'Or'),
(2, 'Sabbagh', 'Guillaume', '0123456789', '314159265358', 'Compiegne', (12, 'place du Bonheur'), 'Argent'),
(3, 'Delabre', 'Martin', '0607080910', NULL, 'Compiegne', (7, 'avenue du Sourire'), 'Occasionnel'),
(4, 'Dubosc', 'Bertille', '0711235813', NULL, 'Compiegne', (88, 'boulevard du Chocolat'), 'Occasionnel')
;

INSERT INTO "Reservation" ("Id", "Voyageur", "Assurance", "MoyenPaiement") VALUES
(1, 4, false, 'carte_bleue'),
(2, 3, false, 'especes'),
(3, 1, true, 'cheque')
;

INSERT INTO "Billet" ("Id", "Trajet", "Date", "Classe", "Place", "Annule", "Reservation") VALUES
(1, 1, '2018-06-22', '2', 8, false, 1),
(2, 1, '2018-06-22', '2', 9, false, 1),
(3, 1, '2018-06-22', '2', 10, false, 1),
(4, 1, '2018-06-22', '2', 11, false, 1),
(5, 1, '2018-06-22', '2', 23, false, 2),
(6, 1, '2018-06-22', '2', 24, false, 2),
(7, 1, '2018-06-22', '2', 104, false, 3),
(8, 1, '2018-06-22', '2', 105, false, 3),
(9, 1, '2018-06-22', '2', 106, false, 3)
;
