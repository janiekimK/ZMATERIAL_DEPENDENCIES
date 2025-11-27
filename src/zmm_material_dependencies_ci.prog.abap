*&---------------------------------------------------------------------*
*& Include          ZMM_MATERIAL_DEPENDENCIES_CI
*&---------------------------------------------------------------------*
CLASS lcl_select_missing_material IMPLEMENTATION.

  METHOD get_coop_week.

    g_coop_week = zcl_assortment_week=>by_date(
    iv_node = i_hc
    iv_date = i_date ).

    g_yearweek = g_coop_week->data-yearweek.

    e_year = g_yearweek(4).
    e_week = g_yearweek+4(2).

  ENDMETHOD.

  METHOD get_lbs_from_vst.

    CLEAR g_lbs.

    SELECT *
    FROM twglv
    INTO TABLE g_lbs.

    IF g_lbs IS INITIAL.
      MESSAGE 'Keine Layoutbausteine gefunden.' TYPE 'E'.
    ENDIF.

    DATA: l_werk TYPE werks_d.
    l_werk  = |{ s_vst-low ALPHA = OUT }|.
    LOOP AT g_lbs ASSIGNING FIELD-SYMBOL(<fs>).
      IF  <fs>-layvr+2(4) NE l_werk.
        CLEAR <fs>.
      ENDIF.
    ENDLOOP.

    DELETE ADJACENT DUPLICATES FROM g_lbs.

    IF g_lbs IS INITIAL.
      MESSAGE 'Keine Layoutbausteine für diese Verkaufsstelle gefunden.' TYPE 'E'.
    ENDIF.

    check_lbs( ).

  ENDMETHOD.

  METHOD check_lbs.

    LOOP AT g_lbs INTO g_lbs_struc.
      g_laygr = g_lbs_struc-laygr.
      APPEND g_laygr TO g_laygr_table.
    ENDLOOP.

    IF g_laygr_table IS INITIAL.
      MESSAGE 'Keine Layoutbausteine gefunden.' TYPE 'E'.
    ENDIF.

    CLEAR g_malg.
    SELECT *
      FROM malg
       INTO TABLE @g_malg
       FOR ALL ENTRIES IN @g_laygr_table
       WHERE laygr = @g_laygr_table-laygr.

    IF g_malg IS INITIAL.
      MESSAGE 'Keine Artikel in den Layoutbausteinen gefunden.' TYPE 'E'.
    ENDIF.

    CLEAR g_wlmv.
    SELECT *
      FROM wlmv
       INTO TABLE g_wlmv
       FOR ALL ENTRIES IN g_laygr_table
       WHERE laygr = g_laygr_table-laygr
       AND lm_date_fr = s_dat-low
       AND lm_date_to = s_dat-high.

    IF g_wlmv IS INITIAL.
      MESSAGE 'Keine gültigen Layoutbausteine für das gewählte Datum gefunden.' TYPE 'E'.
    ENDIF.

    get_hc16_articles( ).
  ENDMETHOD.

  METHOD get_hc16_articles.

    CLEAR g_hc16_articles.

    SELECT *
       FROM wrf_matgrp_sku
       INTO TABLE g_hc16_articles
       WHERE node LIKE '010116%'.

    IF g_hc16_articles IS INITIAL.
      MESSAGE 'Keine HC16 Artikel gefunden.' TYPE 'E'.
    ENDIF.

    compare_material( ).
  ENDMETHOD.

  METHOD compare_material.

    LOOP AT g_malg INTO g_malg_struc.
      READ TABLE g_hc16_articles TRANSPORTING NO FIELDS
      WITH KEY matnr = g_malg_struc-matnr.
      IF sy-subrc = 0.
        APPEND g_malg_struc TO g_malg_filtered_table.
      ENDIF.
    ENDLOOP.

    IF g_malg_filtered_table IS INITIAL.
      MESSAGE 'Keine HC16 Artikel in den Layoutbausteinen gefunden.' TYPE 'E'.
    ENDIF.

    CLEAR g_wlk1.
    IF s_vst[] IS NOT INITIAL.
      SELECT *
        FROM wlk1
        INTO TABLE g_wlk1
        WHERE filia IN s_vst
        AND datbi = s_dat-high
        AND datab = s_dat-low.
    ENDIF.


    IF g_malg_filtered_table IS NOT INITIAL.
      CLEAR g_makt.
      SELECT *
        FROM makt
        INTO TABLE g_makt
        FOR ALL ENTRIES IN g_malg_filtered_table
        WHERE matnr = g_malg_filtered_table-matnr.
    ENDIF.

    LOOP AT g_malg_filtered_table INTO g_malg_struc.
      READ TABLE g_wlmv INTO g_wlmv_struc
      WITH KEY laygr = g_malg_struc-laygr
      laymod_ver = g_malg_struc-lmver.

      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      READ TABLE g_lbs INTO g_lbs_struc
      WITH KEY laygr = g_malg_struc-laygr.

      IF sy-subrc <> 0.
        CONTINUE.

      ENDIF.

      g_vst_struc = g_lbs_struc-layvr+2(4).
      g_found = abap_false.

      READ TABLE g_wlk1 INTO g_wlk1_struc
      WITH KEY filia = g_vst_struc
      artnr = g_malg_struc-matnr.

      IF sy-subrc = 0.
        g_found = abap_true.
      ENDIF.

      IF g_found = abap_false.
        CLEAR g_missing_struc.

        READ TABLE g_makt INTO g_makt_struc
        WITH KEY matnr = g_malg_struc-matnr.

        g_missing_struc-verkaufsstelle = g_vst_struc.
        g_missing_struc-artikelnummer  = g_malg_struc-matnr.
        g_missing_struc-arikelname     = g_makt_struc-maktx.
        g_missing_struc-layoutbaustein = g_malg_struc-laygr.
        g_missing_struc-gultig_von     = g_wlmv_struc-lm_date_fr.
        g_missing_struc-gultig_bis     = g_wlmv_struc-lm_date_to.
        g_missing_struc-artikelgruppe  = '010116'.

        APPEND g_missing_struc TO g_missing_material.
      ENDIF.
    ENDLOOP.

    display_missing_material->into_table( ).
  ENDMETHOD.

ENDCLASS.


CLASS lcl_display_material IMPLEMENTATION.

  METHOD into_table.

    display_salv( ).
  ENDMETHOD.

  METHOD display_salv.

    cl_salv_table=>factory( IMPORTING
      r_salv_table   = o_salv
    CHANGING
      t_table        = g_missing_material ).


    o_salv->get_functions( )->set_all( abap_true ).
    o_salv->get_columns( )->set_optimize( abap_true ).
    o_salv->get_display_settings( )->set_list_header( 'Gefundene Artikel' ).
    o_salv->get_display_settings( )->set_striped_pattern( abap_true ).
    o_salv->get_selections( )->set_selection_mode( if_salv_c_selection_mode=>row_column ).


    o_salv->display( ).
  ENDMETHOD.

ENDCLASS.
