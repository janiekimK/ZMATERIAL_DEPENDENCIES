*&---------------------------------------------------------------------*
*& Include          ZMM_MATERIAL_DEPENDENCIES_TOP
*&---------------------------------------------------------------------*
CLASS lcl_select_missing_material DEFINITION DEFERRED.
CLASS lcl_display_material DEFINITION DEFERRED.
TABLES: wlk1.
TYPES: BEGIN OF ty_missing_material,
         verkaufsstelle TYPE werks_d,
         artikelnummer  TYPE artnr,
         arikelname     TYPE maktx,
         layoutbaustein TYPE laygr,
         gultig_von     TYPE lm_date_fr,
         gultig_bis     TYPE lm_date_to,
         artikelgruppe  TYPE char20,
       END OF ty_missing_material.

TYPES: t_missing_material TYPE TABLE OF ty_missing_material,
       g_vst_range        TYPE RANGE OF werks.

SELECT-OPTIONS: s_dat FOR sy-datum OBLIGATORY.
DATA: g_vst TYPE werks.
SELECT-OPTIONS: s_vst FOR wlk1-filia NO INTERVALS.

DATA: select_missing_material  TYPE REF TO lcl_select_missing_material,
      display_missing_material TYPE REF TO lcl_display_material,
      g_coop_week              TYPE REF TO zcl_assortment_week,
      o_salv                   TYPE REF TO cl_salv_table.
TYPES: BEGIN OF ty_laygr,
         laygr TYPE laygr,
       END OF ty_laygr.

DATA: g_laygr_table         TYPE TABLE OF ty_laygr,
      g_malg_filtered_table TYPE TABLE OF malg,
      g_lbs                 TYPE TABLE OF twglv,
      g_malg                TYPE TABLE OF malg,
      g_wlmv                TYPE TABLE OF wlmv,
      g_wlk1                TYPE TABLE OF wlk1,
      g_hc16_articles       TYPE TABLE OF wrf_matgrp_sku,
      g_makt                TYPE TABLE OF makt,
      g_missing_material    TYPE t_missing_material,
      g_missing_struc       TYPE ty_missing_material,
      g_laygr               TYPE laygr,
      g_matnr               TYPE matnr,
      g_lbs_struc           TYPE twglv,
      g_malg_struc          TYPE malg,
      g_wlmv_struc          TYPE wlmv,
      g_makt_struc          TYPE makt,
      g_vst_struc           TYPE werks_d,
      g_hc                  TYPE wrf_struc_node,
      g_wlk1_struc          TYPE wlk1,
      g_yearweek            TYPE char6,
      g_found               TYPE abap_bool,
      g_week                TYPE char6,
      g_year                TYPE char4.
