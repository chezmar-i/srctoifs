# SRCTOIFS

**SRCTOIFS** est un petit outil IBM i permettant d'exporter simplement
les membres sources d'une ou plusieurs bibliothèques vers l'IFS.

Les sources sont exportées en **UTF-8** avec des fins de ligne **LF**,
afin de pouvoir ensuite être utilisées facilement avec Git, VS Code,
Code for IBM i ou d'autres outils modernes.

## Utilisation

```cl
SRCTOIFS BIB(NEGO)
```

Le paramètre `BIB` représente un nom ou un préfixe de bibliothèque.

Ainsi :

```cl
SRCTOIFS BIB(NEGO)
```

peut exporter les sources présents dans :

- `NEGO`
- `NEGODTA`
- `NEGODEV`
- `NEGOTEST`
- etc.

Les bibliothèques système dont le nom commence par `Q` sont exclues.

## Résultat

Les sources sont créées sous :

```text
/home/SrcTxt/<bibliothèque>/<fichier source>/<membre>.<type source>
```

Par exemple :

```text
/home/SrcTxt/NEGO/QRPGLESRC/CLIENT.RPGLE
/home/SrcTxt/NEGO/QCLLESRC/TRAITEMENT.CLLE
```

Le type du membre source est conservé comme extension du fichier.

Les fichiers produits sont :

- encodés en UTF-8 (CCSID 1208) ;
- terminés par des fins de ligne LF ;
- remplacés s'ils existent déjà.

## Fonctionnement

SRCTOIFS est constitué de trois sources :

### `SRCTOIFS.CMD`

Définit la commande `SRCTOIFS` et son paramètre `BIB`.

### `LISTSRC.SQLRPGLE`

Interroge `QSYS2.SYSPARTITIONSTAT` afin de rechercher les membres
sources appartenant aux bibliothèques correspondant au préfixe demandé.

La liste obtenue est placée dans `QTEMP/SOURCES`.

### `SRCTOIFS.CLLE`

Lit `QTEMP/SOURCES`, crée l'arborescence nécessaire dans l'IFS et
exporte chaque membre avec `CPYTOSTMF`.

À la fin du traitement, le programme indique le nombre de membres
trouvés, copiés et en erreur.

## Installation

Les sources du projet se trouvent dans le répertoire `src`.

Le fichier `install/SOURCES.SQL` permet de créer le fichier modèle
`SOURCES` nécessaire à la compilation de `SRCTOIFS.CLLE`.

L'installation automatisée n'est pas encore disponible.

Pour cette première version, les objets doivent être compilés
manuellement dans la bibliothèque de votre choix.

## Pourquoi ce projet ?

Sur IBM i, une grande partie du patrimoine applicatif est encore
stockée sous forme de fichiers sources et de membres.

SRCTOIFS fournit une passerelle volontairement simple entre cette
organisation traditionnelle et l'IFS, où les sources peuvent ensuite
être utilisés avec Git et les outils de développement modernes.

Le projet est volontairement écrit et documenté en français afin de
rester accessible aux développeurs IBM i francophones, y compris ceux
qui connaissent encore peu Git ou les outils open source.

## État du projet

SRCTOIFS est actuellement dans une première version fonctionnelle.

L'objectif est de conserver un outil simple, compréhensible et sans
dépendances inutiles.

## Licence

SRCTOIFS est distribué sous licence MIT.
