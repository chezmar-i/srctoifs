-- =====================================================================
-- SRCTOIFS - Fichier modèle SOURCES
-- ---------------------------------------------------------------------
-- Ce fichier est nécessaire à la compilation du programme SRCTOIFS.
--
-- Le programme CL utilise DCLF FILE(SOURCES) afin de déclarer les
-- variables correspondant aux membres sources à exporter.
--
-- À l'exécution, LISTSRC crée une table SOURCES dans QTEMP.
-- L'OVRDBF réalisé par SRCTOIFS permet ensuite au programme CL
-- de lire cette table temporaire.
--
-- Ce fichier permanent sert donc uniquement de modèle de compilation.
-- =====================================================================

CREATE TABLE SOURCES
(
    BIB       CHAR(10) NOT NULL,
    FICSRC    CHAR(10) NOT NULL,
    MEMSRC    CHAR(10) NOT NULL,
    TYPSRC    CHAR(10)
)
RCDFMT SOURCER;