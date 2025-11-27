*&---------------------------------------------------------------------*
*& Report ZMM_MATERIAL_DEPENDENCIES
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmm_material_dependencies.

INCLUDE zmm_material_dependencies_top.
INCLUDE zmm_material_dependencies_cd.
INCLUDE zmm_material_dependencies_ci.

START-OF-SELECTION.

  CREATE OBJECT select_missing_material.
  CREATE OBJECT display_missing_material.

  g_hc = '010116'.

  select_missing_material->get_coop_week(
  EXPORTING
    i_hc   = g_hc
    i_date = s_dat-low
  IMPORTING
    e_week = g_week
    e_year = g_year ).

  select_missing_material->get_lbs_from_vst( ).

  IF g_missing_material IS INITIAL.
    MESSAGE 'Keine fehlenden HC16 Artikel gefunden.' TYPE 'E'.
  ELSE.
    display_missing_material->display_salv( ).
  ENDIF.
