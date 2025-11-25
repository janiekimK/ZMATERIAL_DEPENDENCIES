*&---------------------------------------------------------------------*
*& Include          ZMM_MATERIAL_DEPENDENCIES_TOP
*&---------------------------------------------------------------------*
CLASS lcl_select_missing_material DEFINITION DEFERRED.
CLASS lcl_display_material DEFINITION DEFERRED.

TYPES: BEGIN OF ty_missing_material,
         verkaufsstelle TYPE werks_d,
         artikelnummer  TYPE artnr,
         arikelname     TYPE maktx,
         layoutbaustein TYPE laygr,
         gultig_von     TYPE lm_date_fr,
         gultig_bis     TYPE lm_date_to,
         artikelgruppe  TYPE char20, "???
       END OF ty_missing_material.
TYPES: t_missing_material TYPE TABLE OF ty_missing_material.

DATA: select_missing_material TYPE REF TO lcl_select_missing_material.
DATA: display_missing_material TYPE REF TO lcl_display_material.
DATA: l_missing_material TYPE t_missing_material.

PARAMETERS:
p_vst TYPE werks_d OBLIGATORY,
p_dat TYPE sy-datum OBLIGATORY.
