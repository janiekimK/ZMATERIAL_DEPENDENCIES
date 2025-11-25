*&---------------------------------------------------------------------*
*& Report ZMM_MATERIAL_DEPENDENCIES
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmm_material_dependencies.

INCLUDE zmm_material_dependencies_top.
INCLUDE zmm_material_dependencies_cd.
INCLUDE zmm_material_dependencies_ci.


DATA:
      l_hc                    TYPE wrf_struc_node,
      lv_week                 TYPE char6,
      lv_year                 TYPE char4.


START-OF-SELECTION.

  CREATE OBJECT select_missing_material.
  CREATE OBJECT display_missing_material.

  " 2) HC setzen, z.B. HC16
  l_hc = '16'.

  " 3) Coop-Woche ermitteln
  select_missing_material->get_coop_week(
  EXPORTING
    i_hc   = l_hc
  IMPORTING
    e_week = lv_week
    e_year = lv_year
    ).
