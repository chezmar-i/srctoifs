**free

// =====================================================================
// Programme : LISTSRC
// ---------------------------------------------------------------------
// Construit dans QTEMP la liste des membres sources à exporter.
//
// Le paramètre reçu représente un nom ou un préfixe de bibliothèque.
//
// Exemple :
//     NEGO
//
// sélectionnera les bibliothèques :
//     NEGO
//     NEGODTA
//     NEGODEV
//     NEGOTEST
//     ...
//
// Les bibliothèques système dont le nom commence par Q sont exclues.
//
// La table QTEMP/SOURCES produite par ce programme est ensuite lue
// par le programme CL SRCTOIFS.
// =====================================================================

ctl-opt dftactgrp(*no)
        actgrp(*caller)
        option(*srcstmt : *nodebugio);


// ---------------------------------------------------------------------
// Paramètre d'entrée
// ---------------------------------------------------------------------

dcl-pi *n;
   pBibliotheque char(10) const;
end-pi;


// ---------------------------------------------------------------------
// Variables
// ---------------------------------------------------------------------

dcl-s filtreBibliotheque varchar(11);


// ---------------------------------------------------------------------
// Options SQL
// ---------------------------------------------------------------------

exec sql
   set option commit = *none,
              closqlcsr = *endmod,
              usrprf = *user,
              dynusrprf = *user;


// ---------------------------------------------------------------------
// Construction du filtre.
//
// Le caractère % est ajouté au nom fourni afin de travailler sur
// l'ensemble des bibliothèques partageant le même préfixe.
//
// Exemple :
//     NEGO devient NEGO%
// ---------------------------------------------------------------------

filtreBibliotheque =
   %trim(%upper(pBibliotheque)) + '%';


// ---------------------------------------------------------------------
// Création de la table de travail.
//
// QTEMP garantit que chaque job dispose de sa propre liste de sources.
// Aucun objet permanent n'est nécessaire pour cette étape.
//
// Les noms système des colonnes sont volontairement courts afin de
// pouvoir être utilisés simplement par DCLF dans le programme CL.
// ---------------------------------------------------------------------

exec sql
   create or replace table QTEMP.SOURCES
   (
      BIB       char(10) not null,
      FICSRC    char(10) not null,
      MEMSRC    char(10) not null,
      TYPSRC    char(10)
   )
   rcdfmt SOURCER;


// ---------------------------------------------------------------------
// Recherche des membres sources.
//
// QSYS2.SYSPARTITIONSTAT fournit notamment :
//   - le nom système de la bibliothèque
//   - le nom système du fichier
//   - le nom du membre
//   - le type du source
//
// SOURCE_TYPE est renseigné pour les membres des fichiers sources.
//
// Les bibliothèques dont le nom commence par Q sont volontairement
// ignorées afin de ne pas exporter les bibliothèques système.
// ---------------------------------------------------------------------

exec sql
   insert into QTEMP.SOURCES

      select SYSTEM_TABLE_SCHEMA,
             SYSTEM_TABLE_NAME,
             SYSTEM_TABLE_MEMBER,
             SOURCE_TYPE

        from QSYS2.SYSPARTITIONSTAT

       where SYSTEM_TABLE_SCHEMA like :filtreBibliotheque
         and SOURCE_TYPE is not null
         and SOURCE_TYPE <> ''
         and SYSTEM_TABLE_SCHEMA not like 'Q%'

       order by SYSTEM_TABLE_SCHEMA,
                SYSTEM_TABLE_NAME,
                SYSTEM_TABLE_MEMBER;


// ---------------------------------------------------------------------
// Fin du programme
// ---------------------------------------------------------------------

*inlr = *on;

return;
