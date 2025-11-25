*&---------------------------------------------------------------------*
*& Include          ZMM_MATERIAL_DEPENDENCIES_CD
*&---------------------------------------------------------------------*
CLASS lcl_select_missing_material DEFINITION.
  PUBLIC SECTION.
    METHODS:
      get_coop_week
        IMPORTING
          i_hc   TYPE wrf_struc_node
        EXPORTING
          e_week TYPE char6
          e_year TYPE char4,
      get_lbs_from_vst,
      check_lbs,
      compare_material.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_display_material DEFINITION.
  PUBLIC SECTION.
    METHODS:
      into_table,
      display_salv.
  PRIVATE SECTION.
ENDCLASS.
