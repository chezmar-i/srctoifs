# Installation de SRCTOIFS

SRCTOIFS est fourni sous forme de sources.

L'installation crée les objets suivants dans une bibliothèque IBM i :

- `SOURCES` : fichier modèle utilisé lors de la compilation
- `LISTSRC` : programme SQL RPGLE
- `SRCTOIFS` : programme CLLE
- `SRCTOIFS` : commande IBM i

## Prérequis

Le dépôt doit avoir été déposé ou cloné dans l'IFS.

Dans les exemples ci-dessous :

- `MABIB` désigne la bibliothèque dans laquelle SRCTOIFS sera installé ;
- `/chemin/vers/srctoifs` désigne la racine du dépôt dans l'IFS.

Par exemple :

    Bibliothèque : OUTILS
    Dépôt IFS    : /home/MARIE/srctoifs

Le profil réalisant l'installation doit disposer des droits nécessaires
pour créer les objets dans la bibliothèque choisie.

## 1. Choisir la bibliothèque d'installation

Positionnez comme bibliothèque courante celle dans laquelle vous souhaitez
installer SRCTOIFS.

Par exemple :

    CHGCURLIB CURLIB(MABIB)

## 2. Créer le fichier modèle SOURCES

Exécutez :

    RUNSQLSTM SRCSTMF('/chemin/vers/srctoifs/install/SOURCES.SQL') +
               COMMIT(*NONE) +
               NAMING(*SYS)

`SOURCES` sert de modèle au programme CL lors de sa compilation.

Il doit donc être créé avant la compilation de `SRCTOIFS`.

## 3. Compiler LISTSRC

Exécutez :

    CRTSQLRPGI OBJ(MABIB/LISTSRC) +
                SRCSTMF('/chemin/vers/srctoifs/src/LISTSRC.SQLRPGLE') +
                CLOSQLCSR(*ENDMOD) +
                OPTION(*EVENTF) +
                DBGVIEW(*SOURCE) +
                TGTRLS(*CURRENT) +
                CVTCCSID(*JOB) +
                RPGPPOPT(*LVL2) +
                COMPILEOPT('TGTCCSID(*JOB)')

## 4. Compiler SRCTOIFS

Exécutez :

    CRTBNDCL PGM(MABIB/SRCTOIFS) +
              SRCSTMF('/chemin/vers/srctoifs/src/SRCTOIFS.CLLE') +
              OPTION(*EVENTF) +
              DBGVIEW(*SOURCE)

## 5. Créer la commande SRCTOIFS

Exécutez :

    CRTCMD CMD(MABIB/SRCTOIFS) +
           PGM(MABIB/SRCTOIFS) +
           SRCSTMF('/chemin/vers/srctoifs/src/SRCTOIFS.CMD') +
           OPTION(*EVENTF)

## 6. Tester l'installation

Vous pouvez maintenant appeler la commande.

Par exemple :

    MABIB/SRCTOIFS BIB(MABIB)

Les sources exportées sont écrites dans :

    /home/SrcTxt

Le profil exécutant SRCTOIFS doit disposer des droits nécessaires pour
créer et alimenter ce répertoire.

## Ordre d'installation

L'ordre des étapes est important.

Le fichier `SOURCES` doit notamment exister au moment de la compilation
du programme CL, car celui-ci utilise :

    DCLF FILE(SOURCES)

À l'exécution, le programme `LISTSRC` crée la table de travail
`QTEMP/SOURCES`.