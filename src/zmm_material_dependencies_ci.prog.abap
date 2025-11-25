*&---------------------------------------------------------------------*
*& Include          ZMM_MATERIAL_DEPENDENCIES_CI
*&---------------------------------------------------------------------*
CLASS lcl_select_missing_material IMPLEMENTATION.

  METHOD get_coop_week. "Eventuell cleaner code mit de berechnig
    DATA: l_current_date TYPE sy-datum,
          l_coop_week    TYPE REF TO zcl_assortment_week,
          l_yearweek     TYPE char6.

    l_current_date = sy-datum.

    l_coop_week = zcl_assortment_week=>by_date(
    iv_node = i_hc
    iv_date = l_current_date ).


    l_yearweek = l_coop_week->data-yearweek.

    e_year = l_yearweek(4).
    e_week = l_yearweek+4(2).

    get_lbs_from_vst( ).
  ENDMETHOD.

  METHOD get_lbs_from_vst.

    DATA: ls_missing TYPE ty_missing_material.

    CLEAR l_missing_material.

    SELECT laygr
    FROM twglv
    INTO TABLE l_missing_material.
      IF l_missing_material IS INITIAL.
        WRITE: 'Keine Daten gefunden.'.
      ELSE.
        display_missing_material->display_salv( ).
      ENDIF.
    ENDMETHOD.

    METHOD check_lbs.
    ENDMETHOD.

    METHOD compare_material.
    ENDMETHOD.

ENDCLASS.


CLASS lcl_display_material IMPLEMENTATION.

METHOD into_table.
ENDMETHOD.

METHOD display_salv.
  DATA: o_salv TYPE REF TO cl_salv_table.

  cl_salv_table=>factory( IMPORTING
    r_salv_table   = o_salv
  CHANGING
    t_table        = l_missing_material ).


  o_salv->get_functions( )->set_all( abap_true ).
  o_salv->get_columns( )->set_optimize( abap_true ).
  o_salv->get_display_settings( )->set_list_header( 'Gefundene Artikel' ).
  o_salv->get_display_settings( )->set_striped_pattern( abap_true ).
  o_salv->get_selections( )->set_selection_mode( if_salv_c_selection_mode=>row_column ).


  o_salv->display( ).
ENDMETHOD.

ENDCLASS.
