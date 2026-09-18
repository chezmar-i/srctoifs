/* =================================================================== */
/* Commande : SRCTOIFS                                                 */
/* ------------------------------------------------------------------- */
/* Exporte vers l'IFS les membres sources des bibliothèques dont       */
/* le nom commence par la valeur indiquée dans BIB.                    */
/* =================================================================== */

             CMD        PROMPT('Export des sources vers l''IFS')

             PARM       KWD(BIB) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Bibliothèque ou préfixe')
