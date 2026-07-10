create or replace package as_pdf
is
  --
  use_utl_file    constant boolean := true;
  use_utl_http    constant boolean := true;
  use_dbms_crypto constant boolean := false;
  use_apex        constant boolean := false;
  --
-- to do
-- signature
-- https://www.gemboxsoftware.com/pdf/examples/c-sharp-vb-net-pdf-advanced-electronic-signature-pades/1103#pades-b-b
-- acroforms
-- https://github.com/phihag/pdfform.js/tree/master/test/data
-- https://www.sejda.com/pdf-forms
-- https://jsfiddle.net/Hopding/bct7vngL/4/
--GSUB
--https://learn.microsoft.com/en-gb/typography/script-development/arabic
--https://learn.microsoft.com/en-us/windows/terminal/cascadia-code
--https://simoncozens.github.io/fonts-and-layout//
--https://support.creativemarket.com/hc/en-us/articles/360037478813-Using-Fonts-with-Special-Features-OpenType#msword
  --
  c_get_cp_page_width     constant pls_integer := 0;
  c_get_cp_page_height    constant pls_integer := 1;
  c_get_cp_margin_top     constant pls_integer := 2;
  c_get_cp_margin_right   constant pls_integer := 3;
  c_get_cp_margin_bottom  constant pls_integer := 4;
  c_get_cp_margin_left    constant pls_integer := 5;
  c_get_pdf_page_width    constant pls_integer := 6;
  c_get_pdf_page_height   constant pls_integer := 7;
  c_get_pdf_margin_top    constant pls_integer := 8;
  c_get_pdf_margin_right  constant pls_integer := 9;
  c_get_pdf_margin_bottom constant pls_integer := 10;
  c_get_pdf_margin_left   constant pls_integer := 11;
  c_get_x                 constant pls_integer := 12;
  c_get_y                 constant pls_integer := 13;
  c_get_fontsize          constant pls_integer := 14;
  c_get_current_font      constant pls_integer := 15;
  c_get_total_fonts       constant pls_integer := 16;
  c_get_total_pages       constant pls_integer := 17;
  c_get_current_page      constant pls_integer := 18;
  c_get_font_name         constant pls_integer := 30;
  c_get_font_style        constant pls_integer := 31;
  c_get_font_family       constant pls_integer := 32;
  c_get_font_win_ascent   constant pls_integer := 33;
  c_get_font_win_descent  constant pls_integer := 34;
  --
  type tp_numbers   is table of number;
  type tp_varchar2s is table of varchar2(32767);
  type tp_num_tab   is table of number index by pls_integer;
  type tp_pls_tab   is table of pls_integer index by pls_integer;
  --
  function get( p_what pls_integer
              , p_idx  pls_integer := null
              )
  return number;
  --
  function get_string( p_what pls_integer
                     , p_idx  pls_integer := null
                     )
  return varchar2;
  --
  function get_font_index
    ( p_fontname varchar2 := null
    , p_family   varchar2 := null
    , p_style    varchar2 := null
    )
  return pls_integer;
  --
  procedure set_font
    ( p_index       pls_integer
    , p_fontsize_pt number := null
    );
  --
  procedure set_font
    ( p_fontname    varchar2
    , p_fontsize_pt number := null
    );
  --
  procedure set_font
    ( p_family      varchar2
    , p_style       varchar2 := 'N'
    , p_fontsize_pt number   := null
    );
  --
  function str_len
    ( p_txt        varchar2 character set any_cs
    , p_font_index pls_integer := null
    , p_fontsize   number      := null
    )
  return number;
  --
  procedure put_txt
    ( p_x                number
    , p_y                number
    , p_txt              varchar2 character set any_cs
    , p_degrees_rotation number      := null
    , p_font_index       pls_integer := null
    , p_fontsize         number      := null
    , p_color            varchar2    := null
    , p_page_proc        pls_integer := null
    , p_options          varchar2 character set any_cs := null
    , p_alpha            number      := null
    , p_outline_lvl      pls_integer := null
    );
  --
  procedure write_txt
    ( p_txt        varchar2 character set any_cs
    , p_x          number      := null
    , p_y          number      := null
    , p_font_index pls_integer := null
    , p_fontsize   number      := null
    , p_color      varchar2    := null
    , p_options    varchar2 character set any_cs := null
    );
  --
  procedure link
    ( p_txt        varchar2 character set any_cs
    , p_url        varchar2
    , p_x          number
    , p_y          number
    , p_font_index pls_integer := null
    , p_fontsize   number      := null
    , p_color      varchar2    := null
    , p_page_proc  pls_integer := null
    );
  --
  procedure underline
    ( p_txt        varchar2 character set any_cs
    , p_x          number
    , p_y          number
    , p_font_index pls_integer := null
    , p_fontsize   number      := null
    , p_line_width number      := null
    , p_color      varchar2    := null
    , p_txt_color  varchar2    := null
    , p_page_proc  pls_integer := null
    );
  --
  procedure strikeout
    ( p_txt        varchar2 character set any_cs
    , p_x          number
    , p_y          number
    , p_font_index pls_integer := null
    , p_fontsize   number      := null
    , p_line_width number      := null
    , p_color      varchar2    := null
    , p_txt_color  varchar2    := null
    , p_page_proc  pls_integer := null
    );
  --
  procedure outline
    ( p_title varchar2
    , p_level pls_integer
    , p_page  pls_integer
    , p_y     number
    );
  --
  procedure multi_cell
    ( p_txt        varchar2 character set any_cs
    , p_x          number
    , p_y          number
    , p_width      number      := null
    , p_height     number      := null
    , p_padding    number      := null
    , p_font_index pls_integer := null
    , p_fontsize   number      := null
    , p_txt_color  varchar2    := null
    , p_fill_color varchar2    := null
    , p_line_color varchar2    := null
    , p_align      varchar2    := null
    , p_line_width number      := null
    , p_url        varchar2    := null
    , p_options    varchar2 character set any_cs := null
    , p_page_proc  pls_integer := null
    );
  --
  procedure table_row
    ( p_txt        tp_varchar2s
    , p_x          number
    , p_y          number
    , p_widths     tp_numbers  := null
    , p_padding    number      := null
    , p_font_index pls_integer := null
    , p_fontsize   number      := null
    , p_min_height number      := null
    , p_align      varchar2    := null
    , p_txt_color  varchar2    := null
    , p_fill_color varchar2    := null
    , p_line_color varchar2    := null
    , p_line_width number      := null
    , p_options    varchar2 character set any_cs := null
    );
  --
  procedure cursor2table
    ( p_rc         sys_refcursor
    , p_x          number
    , p_y          number
    , p_headers    tp_varchar2s := null
    , p_widths     tp_numbers   := null
    , p_font_index pls_integer  := null
    , p_fontsize   number       := null
    , p_txt_color  varchar2     := null
    , p_odd_color  varchar2     := null
    , p_even_color varchar2     := null
    , p_line_color varchar2     := null
    , p_line_width number       := null
    , p_min_height number       := null
    , p_options    varchar2 character set any_cs := null
    );
  --
  procedure query2table
    ( p_query      varchar2
    , p_x          number
    , p_y          number
    , p_headers    tp_varchar2s := null
    , p_widths     tp_numbers   := null
    , p_font_index pls_integer  := null
    , p_fontsize   number       := null
    , p_txt_color  varchar2     := null
    , p_odd_color  varchar2     := null
    , p_even_color varchar2     := null
    , p_line_color varchar2     := null
    , p_line_width number       := null
    , p_min_height number       := null
    , p_options    varchar2 character set any_cs := null
    );
  --
  function load_image( p_img blob )
  return pls_integer;
  --
  function load_image
    ( p_dir       varchar2
    , p_file_name varchar2
    )
  return pls_integer;
  --
  function load_image( p_url varchar2 )
  return pls_integer;
  --
  procedure put_image
    ( p_img_idx   pls_integer
    , p_x         number               -- left
    , p_y         number               -- bottom
    , p_width     number      := null
    , p_height    number      := null
    , p_align     varchar2    := null
    , p_valign    varchar2    := null
    , p_alpha     number      := null
    , p_page_proc pls_integer := null
    );
  --
  procedure put_image
    ( p_url       varchar2
    , p_x         number               -- left
    , p_y         number               -- bottom
    , p_width     number      := null
    , p_height    number      := null
    , p_align     varchar2    := null
    , p_valign    varchar2    := null
    , p_alpha     number      := null
    , p_page_proc pls_integer := null
    );
  --
  procedure put_image
    ( p_img       blob
    , p_x         number               -- left
    , p_y         number               -- bottom
    , p_width     number      := null
    , p_height    number      := null
    , p_align     varchar2    := null
    , p_valign    varchar2    := null
    , p_alpha     number      := null
    , p_page_proc pls_integer := null
    );
  --
  procedure put_image
    ( p_dir       varchar2
    , p_file_name varchar2
    , p_x         number               -- left
    , p_y         number               -- bottom
    , p_width     number      := null
    , p_height    number      := null
    , p_align     varchar2    := null
    , p_valign    varchar2    := null
    , p_alpha     number      := null
    , p_page_proc pls_integer := null
    );
  --
  procedure add_embedded_file
    ( p_name    varchar2
    , p_content blob
    , p_descr   varchar2 := null
    , p_mime    varchar2 := null
    , p_af_key  varchar2 := null
    );
  --
  procedure set_info
    ( p_title    varchar2 := null
    , p_author   varchar2 := null
    , p_subject  varchar2 := null
    , p_creator  varchar2 := null
    , p_keywords varchar2 := null
    );
  --
  procedure set_pdf_version( p_version number := 1.4 );
  --
  procedure set_pdfA3
    ( p_conformance                  varchar2 := 'B'
    , p_extra_meta_data_descriptions varchar2 := null
    );
  --
  procedure set_proxy
    ( p_proxy            varchar2
    , p_no_proxy_domains varchar2 := null
    );
  --
  procedure set_wallet
    ( p_path     varchar2
    , p_password varchar2 := null
    );
  --
  procedure set_initial_zoom( p_zoom_factor number := null );
  --
  procedure set_open_type_features
    ( p_enabled_features varchar2 := null
    , p_script           varchar2 := null
    , p_language         varchar2 := null
    , p_apply_GSUB       boolean  := null
    , p_apply_GPOS       boolean  := null
    );
  --
  procedure set_current_page( p_page number );
  --
  procedure set_line_spacing_factor( p_factor number := 1.2 );
  --
  procedure set_color( p_rgb varchar2 := '000000' ); -- RGB-hex or X11 name
  --
  procedure set_color  -- numbers between 0 and 255
    ( p_red   number := 0
    , p_green number := 0
    , p_blue  number := 0
    );
  --
  procedure set_bk_color( p_rgb varchar2 := 'ffffff' ); -- RGB-hex or X11 name
  --
  procedure set_bk_color  -- numbers between 0 and 255
    ( p_red   number := 255
    , p_green number := 255
    , p_blue  number := 255
    );
  --
  procedure line
    ( p_x1         number
    , p_y1         number
    , p_x2         number
    , p_y2         number
    , p_line_width number      := null
    , p_line_color varchar2    := null
    , p_alpha      number      := null
    , p_page_proc  pls_integer := null
    );
  --
  procedure horizontal_line
    ( p_x          number
    , p_y          number
    , p_width      number
    , p_line_width number      := null
    , p_line_color varchar2    := null
    , p_alpha      number      := null
    , p_page_proc  pls_integer := null
    );
  --
  procedure vertical_line
    ( p_x          number
    , p_y          number
    , p_height     number
    , p_line_width number      := null
    , p_line_color varchar2    := null
    , p_alpha      number      := null
    , p_page_proc  pls_integer := null
    );
  --
  procedure rect
    ( p_x           number
    , p_y           number
    , p_width       number
    , p_height      number
    , p_line_color  varchar2    := null
    , p_fill_color  varchar2    := null
    , p_line_width  number      := null
    , p_radius      number      := null
    , p_transparant boolean     := null
    , p_alpha       number      := null
    , p_page_proc   pls_integer := null
    );
  --
  procedure path
    ( p_steps      tp_numbers
    , p_line_width number      := null
    , p_line_color varchar2    := null
    , p_alpha      number      := null
    , p_page_proc  pls_integer := null
    );
  --
  procedure bezier
    ( p_x1         number
    , p_y1         number
    , p_x2         number
    , p_y2         number
    , p_x3         number
    , p_y3         number
    , p_x4         number
    , p_y4         number
    , p_line_width number      := null
    , p_line_color varchar2    := null
    , p_alpha      number      := null
    , p_page_proc  pls_integer := null
    );
  --
  procedure bezier_v
    ( p_x1         number
    , p_y1         number
    , p_x2         number
    , p_y2         number
    , p_x3         number
    , p_y3         number
    , p_line_width number      := null
    , p_line_color varchar2    := null
    , p_alpha      number      := null
    , p_page_proc  pls_integer := null
    );
  --
  procedure bezier_y
    ( p_x1         number
    , p_y1         number
    , p_x2         number
    , p_y2         number
    , p_x3         number
    , p_y3         number
    , p_line_width number      := null
    , p_line_color varchar2    := null
    , p_alpha      number      := null
    , p_page_proc  pls_integer := null
    );
  --
  procedure circle
    ( p_x           number
    , p_y           number
    , p_radius      number
    , p_line_color  varchar2    := null
    , p_fill_color  varchar2    := null
    , p_line_width  number      := null
    , p_transparant boolean     := false
    , p_alpha       number      := null
    , p_page_proc   pls_integer := null
    );
  --
  procedure ellips
    ( p_x                number -- central point
    , p_y                number -- central point
    , p_major_radius     number
    , p_minor_radius     number
    , p_line_color       varchar2    := null
    , p_fill_color       varchar2    := null
    , p_line_width       number      := null
    , p_degrees_rotation number      := null
    , p_transparant      boolean     := false
    , p_alpha            number      := null
    , p_page_proc        pls_integer := null
    );
  --
  function load_font
    ( p_font              blob
    , p_embed             boolean := true
    , p_subset            boolean := true
    , p_opentype_features boolean := true
    )
  return pls_integer;
  --
  function load_font
    ( p_dir               varchar2
    , p_filename          varchar2
    , p_embed             boolean := true
    , p_subset            boolean := true
    , p_opentype_features boolean := true
    )
  return pls_integer;
  --
  function load_google_font
    ( p_family            varchar2             -- one or more font families, separate the names with a pipe character (|)
    , p_variant           varchar2 := 'normal' -- a list of styles or weights separated by commas (,)
    , p_subset            varchar2 := null     -- Some of the fonts in the Google Font Directory support multiple scripts (like Latin, Cyrillic, and Greek for example)
    , p_embed             boolean  := true
    , p_opentype_features boolean  := true
    )
  return pls_integer;
  --
  procedure load_font
    ( p_font              blob
    , p_embed             boolean := true
    , p_subset            boolean := true
    , p_opentype_features boolean := true
    );
  --
  procedure load_font
    ( p_dir               varchar2
    , p_filename          varchar2
    , p_embed             boolean := true
    , p_subset            boolean := true
    , p_opentype_features boolean := true
    );
  --
  procedure load_google_font
    ( p_family            varchar2
    , p_variant           varchar2 := 'normal'
    , p_subset            varchar2 := null
    , p_embed             boolean  := true
    , p_opentype_features boolean  := true
    );
  --
  function conv2uu( p_value number, p_unit varchar2 )
  return number;
  --
  procedure set_page_format( p_format varchar2 := 'A4' );
  --
  procedure set_page_orientation( p_orientation varchar2 := 'PORTRAIT' );
  --
  procedure set_text_direction( p_text_direction varchar2 := 'L2R' );
  --
  procedure set_page_size
    ( p_width  number
    , p_height number
    , p_unit   varchar2 := 'cm'
    );
  --
  procedure new_page( p_page_size        varchar2 := null
                    , p_page_orientation varchar2 := null
                    , p_page_width       number   := null
                    , p_page_height      number   := null
                    , p_margin_left      number   := null
                    , p_margin_right     number   := null
                    , p_margin_top       number   := null
                    , p_margin_bottom    number   := null
                    , p_unit             varchar2 := null
                    , p_text_direction   varchar2 := null
                    );
  --
  procedure set_margins
    ( p_top number    := null
    , p_left number   := null
    , p_bottom number := null
    , p_right number  := null
    , p_unit varchar2 := null
    );
  --
  procedure init_pdf( p_page_size        varchar2 := null
                    , p_page_orientation varchar2 := null
                    , p_page_width       number   := null
                    , p_page_height      number   := null
                    , p_margin_left      number   := null
                    , p_margin_right     number   := null
                    , p_margin_top       number   := null
                    , p_margin_bottom    number   := null
                    , p_unit             varchar2 := null
                    , p_text_direction   varchar2 := null
                    );
  --
  procedure init;
  --
  procedure finish_pdf( p_password varchar2 := null );
  --
  function finish_pdf( p_password varchar2 := null )
  return blob;
  --
  function get_pdf( p_password varchar2 := null )
  return blob;
  --
  procedure save_pdf
    ( p_dir      varchar2
    , p_filename varchar2
    , p_password varchar2 := null
    );
  --
end as_pdf;
/

create or replace package body as_pdf
is
  c_version            constant varchar2(10) := '0.4.0.2';
  c_db_charset         constant varchar2(100) := nls_charset_name( nls_charset_id( 'C' ) );
  c_db_ncharset        constant varchar2(100) := nls_charset_name( nls_charset_id( 'N' ) );
  c_producer           constant varchar2(100) := 'AS-PDF ' || c_version || ' by Anton Scheffer';
  c_eol                constant varchar2(4) := chr( 13 ) || chr( 10 );
  c_default_fontsize   constant number := 12;
  c_default_line_width constant number := 0.5;
  c_tab_spaces         constant varchar2(10) := rpad( ' ', 4 );
  e_no_fit             exception;
  c_CFF                constant varchar2(8) := utl_raw.cast_to_raw( 'CFF ' );
  c_CFF2               constant varchar2(8) := utl_raw.cast_to_raw( 'CFF2' );
  c_cvt                constant varchar2(8) := utl_raw.cast_to_raw( 'cvt ' );
  c_fpgm               constant varchar2(8) := utl_raw.cast_to_raw( 'fpgm' );
  c_glyf               constant varchar2(8) := utl_raw.cast_to_raw( 'glyf' );
  c_head               constant varchar2(8) := utl_raw.cast_to_raw( 'head' );
  c_hhea               constant varchar2(8) := utl_raw.cast_to_raw( 'hhea' );
  c_hmtx               constant varchar2(8) := utl_raw.cast_to_raw( 'hmtx' );
  c_loca               constant varchar2(8) := utl_raw.cast_to_raw( 'loca' );
  c_maxp               constant varchar2(8) := utl_raw.cast_to_raw( 'maxp' );
  c_prep               constant varchar2(8) := utl_raw.cast_to_raw( 'prep' );
  --
  c_LOCAL_FILE_HEADER        constant raw(4) := hextoraw( '504B0304' ); -- Local file header signature
  c_CENTRAL_FILE_HEADER      constant raw(4) := hextoraw( '504B0102' ); -- Central directory file header signature
  c_END_OF_CENTRAL_DIRECTORY constant raw(4) := hextoraw( '504B0506' ); -- End of central directory signature
  --
  c_lt constant raw(1) := utl_raw.cast_to_raw( '<' );
  c_gt constant raw(1) := utl_raw.cast_to_raw( '>' );
  --
  -- Bidi classes
  c_no_bidi_class constant pls_integer := 0;
  c_class_RLE     constant pls_integer := 1;
  c_class_LRE     constant pls_integer := 2;
  c_class_RLO     constant pls_integer := 3;
  c_class_LRO     constant pls_integer := 4;
  c_class_PDF     constant pls_integer := 5;
  c_class_BN      constant pls_integer := 6;
  c_class_FSI     constant pls_integer := 7;
  c_class_LRI     constant pls_integer := 8;
  c_class_RLI     constant pls_integer := 9;
  c_class_PDI     constant pls_integer := 10;
  c_class_ON      constant pls_integer := 11;
  c_class_R       constant pls_integer := 12;
  c_class_AL      constant pls_integer := 13;
  c_class_L       constant pls_integer := 14;
  c_class_EN      constant pls_integer := 15;
  c_class_AN      constant pls_integer := 16;
  c_class_ES      constant pls_integer := 17;
  c_class_CS      constant pls_integer := 18;
  c_class_ET      constant pls_integer := 19;
  c_class_B       constant pls_integer := 20;
  c_class_S       constant pls_integer := 21;
  c_class_WS      constant pls_integer := 22;
  c_class_NSM     constant pls_integer := 23;
  --
  type tp_hex is table of pls_integer index by varchar2(2);
  g_hex tp_hex;
  g_wallet_path     varchar2(32767);
  g_wallet_password varchar2(32767);
  g_proxy           varchar2(32767);
  g_no_proxy        varchar2(32767);
  g_unicode_data    tp_pls_tab;
  --
  type tp_zip_info is record
    ( len integer
    , cnt integer
    , len_cd integer
    , idx_cd integer
    , idx_eocd integer
    );
  type tp_cfh is record
    ( offset integer
    , compressed_len integer
    , original_len integer
    , len pls_integer
    , n   pls_integer
    , m   pls_integer
    , k   pls_integer
    , utf8 boolean
    , encrypted boolean
    , crc32 raw(4)
    , external_file_attr raw(4)
    , encoding varchar2(3999)
    , idx   integer
    , name1 raw(32767)
    );
  --
  type tp_annot is record
    ( subtype   varchar2(32)
    , url       varchar2(1024)
    , color     varchar2(128)
    , extra     number
    , width     number
    , lt_x      number
    , lt_y      number
    , rb_x      number
    , rb_y      number
    , object_nr number(10)
    );
  type tp_annots is table of tp_annot index by pls_integer;
  type tp_page_proc is record
    ( page_nr pls_integer
    , proc    pls_integer
    , nums    tp_numbers
    , chars   tp_varchar2s
    , nchar   nvarchar2(32767)
    );
  type tp_page_procs is table of tp_page_proc index by pls_integer;
  type tp_objects is table of number(10) index by pls_integer;
  type tp_settings is record
    ( page_width     number
    , page_height    number
    , margin_left    number
    , margin_right   number
    , margin_top     number
    , margin_bottom  number
    , text_direction varchar2(3)
    );
  type tp_page is record
    ( settings   tp_settings
    , font_index pls_integer
    , fontsize   number
    , color      varchar2(100)
    , bk_color   varchar2(100)
    , annots     tp_annots
    , content    blob
    );
  type tp_pages is table of tp_page index by pls_integer;
  type tp_img is record
    ( crc32        varchar2(8)
    , width        pls_integer
    , height       pls_integer
    , color_res    pls_integer
    , color_tab    raw(768) -- max 256 * 3  8 bit values
    , greyscale    boolean
    , pixels       blob
    , type         varchar2(5)
    , nr_colors    pls_integer
    , transparancy pls_integer
    , smask        blob
    , object       number(10)
    );
  type tp_images is table of tp_img index by pls_integer;
  type tp_outline is record
    ( title varchar2(1000)
    , lvl   pls_integer
    , page  pls_integer
    , y     number
    );
  type tp_outlines is table of tp_outline index by pls_integer;
  type tp_matrix is table of tp_pls_tab index by pls_integer;
  type tp_features is table of varchar2(4);
  type tp_lang_sys is record
    ( tag             varchar2(4)
    , feature_indices tp_pls_tab
    );
  type tp_script_table is table of tp_lang_sys index by pls_integer;
  type tp_script is record
    ( tag varchar2(4)
    , script_table tp_script_table
    );
  type tp_script_list is table of tp_script index by pls_integer;
  type tp_feature is record
    ( tag     varchar2(4)
    , lookups tp_pls_tab
    );
  type tp_feature_list is table of tp_feature index by pls_integer;
  type tp_anchor is record
    ( xCoordinate pls_integer
    , yCoordinate pls_integer
    );
  type tp_value_record is record
    ( xPlacement pls_integer
    , yPlacement pls_integer
    , xAdvance   pls_integer
    , yAdvance   pls_integer
    );
  type tp_value_records is table of tp_value_record index by pls_integer;
  type tp_vr_list is table of tp_value_records index by pls_integer;
  type tp_subtable is record
    ( coverage           tp_pls_tab
    , data_list          tp_pls_tab
    , matrix             tp_matrix
    , value_records_list tp_vr_list
    );
  type tp_subtables is table of tp_subtable index by pls_integer;
  type tp_lookup is record
    ( lookup_type        pls_integer
    , lookup_flags       pls_integer
    , mark_filtering_set pls_integer
    , coverage           tp_matrix
    , subtables          tp_subtables
    );
  type tp_lookup_list is table of tp_lookup index by pls_integer;
  type tp_gsub_gpos is record
    ( table_type   varchar2(4)
    , script_list  tp_script_list
    , lookup_list  tp_lookup_list
    , feature_list tp_feature_list
    );
  type tp_font_gsub_gpos is table of tp_gsub_gpos index by pls_integer;
  type tp_gdef is record
    ( class_def tp_pls_tab
    );
  type tp_font_gdef is table of tp_gdef index by pls_integer;
  type tp_font is record
    ( standard boolean
    , used     boolean
    , family varchar2(100)
    , style varchar2(2)  -- N Normal
                         -- I Italic
                         -- B Bold
                         -- BI Bold Italic
    , subtype          varchar2(15)
    , name             varchar2(100)  -- embedded name
    , fontname         varchar2(100)  -- real     name
    , fontsize         number
    , unit_norm        number
    , notdef           pls_integer
    , bb_xmin          pls_integer
    , bb_ymin          pls_integer
    , bb_xmax          pls_integer
    , bb_ymax          pls_integer
    , flags            pls_integer
    , italic_angle     number
    , ascent           pls_integer
    , descent          pls_integer
    , linegap          pls_integer
    , capheight        pls_integer
    , stemv            pls_integer
    , win_ascent       pls_integer
    , win_descent      pls_integer
    , underline_pos    pls_integer
     ,strikeout_pos    pls_integer
    , subset           boolean
    , ttf_offset       integer
    , numGlyphs        pls_integer
    , indexToLocFormat pls_integer
    , cff              boolean
    , delete_in_gsub_type6 boolean
    );
  type tp_fonts is table of tp_font index by pls_integer;
  type tp_embedded_file is record
    ( name    varchar2(1024)
    , descr   varchar2(1024)
    , mime    varchar2(1024)
    , af_key  varchar2(1024)
    , content blob
    );
  type tp_embedded_files is table of tp_embedded_file index by pls_integer;
  type tp_extgstate is record
    ( stroking_alpha     number
    , non_stroking_alpha number
    , blend_mode         varchar2(32)
    );
  type tp_blobs is table of blob index by pls_integer;
  type tp_egs_dir is table of tp_extgstate index by pls_integer;
  type tp_pdf is record
    ( pdf_blob            blob
    , pdf_version         number
    , pdf_a3_conformance  varchar2(1)
    , zoom                number
    , fonts_used          boolean
    , current_font        pls_integer
    , current_page        pls_integer
    , current_font_index  pls_integer
    , x                   number
    , y                   number
    , line_spacing_factor number
    , current_font_size   varchar2(1024)
    , title               varchar2(1024)
    , author              varchar2(1024)
    , subject             varchar2(1024)
    , creator             varchar2(1024)
    , producer            varchar2(1024)
    , keywords            varchar2(8096)
    , color               varchar2(100)
    , bk_color            varchar2(100)
    , meta_rdf_descr      varchar2(32767)
    , key                 raw(128)
    , fonts               tp_fonts
    , pages               tp_pages
    , images              tp_images
    , egs_dir             tp_egs_dir
    , objects             tp_objects
    , font_code_cache     tp_matrix
    , font_glyph_cache    tp_matrix
    , font_width_cache    tp_matrix
    , font_old_new        tp_matrix
    , gsub_gpos           tp_font_gsub_gpos
    , gdef                tp_font_gdef
    , page_procs          tp_page_procs
    , page_settings       tp_settings
    , outlines            tp_outlines
    , embedded_files      tp_embedded_files
    , font_files          tp_blobs
    );
  type tp_color_names is table of varchar2(6) index by varchar2(20);
  --
  g_pdf         tp_pdf;
  g_color_names tp_color_names;
  --
  function file2blob
    ( p_dir varchar2
    , p_file_name varchar2
    )
  return blob
  is
    file_lob bfile;
    file_blob blob;
  begin
    file_lob := bfilename( p_dir, p_file_name );
    dbms_lob.open( file_lob, dbms_lob.file_readonly );
    dbms_lob.createtemporary( file_blob, true );
    dbms_lob.loadfromfile( file_blob, file_lob, dbms_lob.lobmaxsize );
    dbms_lob.close( file_lob );
    return file_blob;
  exception
    when others then
      if dbms_lob.isopen( file_lob ) = 1
      then
        dbms_lob.close( file_lob );
      end if;
      if dbms_lob.istemporary( file_blob ) = 1
      then
        dbms_lob.freetemporary( file_blob );
      end if;
      raise;
  end file2blob;
  --
  function hash_md5( p_msg raw )
  return raw
  is
$IF dbms_db_version.ver_le_11
$THEN
  begin
$IF as_pdf.use_dbms_crypto
$THEN
    return dbms_crypto.hash( p_msg, dbms_crypto.hash_md5 );
$ELSE
    raise_application_error( -20028, 'MD5 hash function not available.' );
$END
$ELSE
    l_rv raw(32);
  begin
    select standard_hash( p_msg, 'MD5' ) into l_rv from dual;
    return l_rv;
$END
  end hash_md5;
  --
  function encrypt_rc4( p_src blob, p_key raw )
  return blob
  is
    l_rv   blob;
    l_src  varchar2(32767);
    l_xor  varchar2(32767);
    l_i    pls_integer;
    l_j    pls_integer;
    l_sz   pls_integer;
    l_tmp  pls_integer;
    l_tmp2 pls_integer;
    l_init constant varchar2(512) := substr( rpad( p_key, 512, p_key ), 1, 512 );
    type tp_sbox is table of pls_integer index by pls_integer;
    l_arcfour tp_sbox;
  begin
    for i in 0 .. 255
    loop
      l_arcfour(i) := i;
    end  loop;
    l_j := 0;
    for i in 0 .. 255
    loop
      l_j := bitand( l_j + l_arcfour( i ) + g_hex( substr( l_init, 1 + 2 * i, 2 ) ), 255 );
      l_tmp := l_arcfour( i ) ;
      l_arcfour( i ) := l_arcfour( l_j );
      l_arcfour( l_j ) := l_tmp;
    end  loop;
    --
    l_i := 0;
    l_j := 0;
    l_sz := 16380;
    dbms_lob.createtemporary( l_rv, true );
    --
    for i in 0 .. trunc( ( dbms_lob.getlength( p_src ) - 1 ) / l_sz )
    loop
      l_xor := null;
      l_src := dbms_lob.substr( p_src, 2 * l_sz, 1 + 2* i * l_sz );
      for j in 0 .. length( l_src ) / 2 - 1
      loop
        l_i := bitand( l_i + 1, 255 );
        l_j := bitand( l_j + l_arcfour( l_i ), 255 );
        l_tmp := l_arcfour( l_i  );
        l_arcfour( l_i ) := l_arcfour( l_j );
        l_arcfour( l_j ) := l_tmp;
        --
        l_tmp  := l_arcfour( bitand( l_arcfour( l_i ) + l_tmp, 255 ) );
        l_tmp2 := g_hex( substr( l_src, 1 + 2 * j, 2 ) );
        l_xor := l_xor || to_char( bitand( l_tmp + l_tmp2 - 2 * bitand( l_tmp, l_tmp2 ), 255 ), 'fm0x' );
      end loop;
      dbms_lob.writeappend( l_rv, length( l_xor ) / 2, l_xor );
    end loop;
    --
    return l_rv;
  end encrypt_rc4;
  --
  function xjv
    ( p_json varchar2 character set any_cs
    , p_path varchar2
    , p_unescape varchar2 := 'Y'
    )
  return varchar2 character set p_json%charset
  is
    c_double_quote  constant varchar2(4)  character set p_json%charset := u'"';
    c_single_quote  constant varchar2(4)  character set p_json%charset := u'''';
    c_back_slash    constant varchar2(4)  character set p_json%charset := u'\\';
    c_space         constant varchar2(4)  character set p_json%charset := u' ';
    c_colon         constant varchar2(4)  character set p_json%charset := u':';
    c_comma         constant varchar2(4)  character set p_json%charset := u',';
    c_end_brace     constant varchar2(4)  character set p_json%charset := u'}';
    c_start_brace   constant varchar2(4)  character set p_json%charset := u'{';
    c_end_bracket   constant varchar2(4)  character set p_json%charset := u']';
    c_start_bracket constant varchar2(4)  character set p_json%charset := u'[';
    c_ht            constant varchar2(4)  character set p_json%charset := unistr( '\0009' );
    c_lf            constant varchar2(4)  character set p_json%charset := unistr( '\000A' );
    c_cr            constant varchar2(4)  character set p_json%charset := unistr( '\000D' );
    c_ws            constant varchar2(12) character set p_json%charset := c_space || c_ht || c_cr || c_lf;
    --
    g_idx number;
    g_end number;
    --
    l_nchar boolean := isnchar( c_space );
    l_pos number;
    l_ind number;
    l_start number;
    l_rv_end number;
    l_rv_start number;
    l_path varchar2(32767);
    l_name varchar2(32767);
    l_tmp_name varchar2(32767);
    l_rv varchar2(32767) character set p_json%charset;
    l_chr varchar2(10) character set p_json%charset;
    l_cnt pls_integer;
    --
    procedure skip_whitespace
    is
    begin
      while substrc( p_json, g_idx, 1 ) in ( c_space, c_lf, c_cr, c_ht )
      loop
        g_idx:= g_idx+ 1;
      end loop;
      if g_idx > g_end
      then
        raise_application_error( -20001, 'Unexpected end of JSON' );
      end if;
    end;
    --
    procedure skip_value;
    procedure skip_array;
    --
    procedure skip_object
    is
    begin
      if substrc( p_json, g_idx, 1 ) = c_start_brace
      then
        g_idx := g_idx + 1;
        loop
          skip_whitespace;
          exit when substrc( p_json, g_idx, 1 ) = c_end_brace; -- empty object or object with "trailing comma"
          skip_value; -- skip name
          skip_whitespace;
          if substrc( p_json, g_idx, 1 ) != c_colon
          then
            raise_application_error( -20002, 'No valid JSON, expected a colon at position ' || g_idx );
          end if;
          g_idx := g_idx + 1; -- skip colon
          skip_value; -- skip value
          skip_whitespace;
          case substrc( p_json, g_idx, 1 )
            when c_comma then g_idx := g_idx + 1;
            when c_end_brace then exit;
            else raise_application_error( -20003, 'No valid JSON, expected a comma or end brace at position ' || g_idx );
          end case;
        end loop;
        g_idx := g_idx + 1;
      end if;
    end;
    --
    procedure skip_array
    is
    begin
      if substrc( p_json, g_idx, 1 ) = c_start_bracket
      then
        g_idx := g_idx + 1;
        loop
          skip_whitespace;
          exit when substrc( p_json, g_idx, 1 ) = c_end_bracket; -- empty array or array with "trailing comma"
          skip_value;
          skip_whitespace;
          case substrc( p_json, g_idx, 1 )
            when c_comma then g_idx := g_idx + 1;
            when c_end_bracket then exit;
            else raise_application_error( -20004, 'No valid JSON, expected a comma or end bracket at position ' || g_idx );
          end case;
        end loop;
        g_idx := g_idx + 1;
      end if;
    end;
    --
    procedure skip_value
    is
    begin
      skip_whitespace;
      case substrc( p_json, g_idx, 1 )
        when c_double_quote
        then
          loop
            g_idx := instrc( p_json, c_double_quote, g_idx + 1 );
            exit when substrc( p_json, g_idx - 1, 1 ) != c_back_slash
                   or g_idx = 0
                   or (   substrc( p_json, g_idx - 2, 2 ) = c_back_slash || c_back_slash
                      and substrc( p_json, g_idx - 3, 1 ) != c_back_slash
                      ); -- doesn't handle cases of values ending with multiple (escaped) \
          end loop;
          if g_idx = 0
          then
            raise_application_error( -20005, 'No valid JSON, no end string found' );
          end if;
          g_idx := g_idx + 1;
        when c_single_quote  -- lax parsing
        then
          g_idx := instrc( p_json, c_single_quote, g_idx + 1 );
          if g_idx = 0
          then
            raise_application_error( -20006, 'No valid JSON, no end string found' );
          end if;
          g_idx := g_idx + 1;
        when c_start_brace
        then
          skip_object;
        when c_start_bracket
        then
          skip_array;
        else -- should be a JSON-number, TRUE, FALSE or NULL, but we don't check for it
             -- any whitespace after this value is also skipped
          g_idx := least( coalesce( nullif( instrc( p_json, c_comma, g_idx ), 0 ), g_end + 1 )
                        , coalesce( nullif( instrc( p_json, c_end_brace, g_idx ), 0 ), g_end + 1 )
                        , coalesce( nullif( instrc( p_json, c_end_bracket, g_idx ), 0 ), g_end  + 1 )
                        );
          if g_idx = g_end + 1
          then
            raise_application_error( -20007, 'No valid JSON, no end string found' );
          end if;
      end case;
    end;
  begin
    if p_json is null
    then
      return null;
    end if;
    l_path := ltrim( p_path, c_ws || '$.' );
    if l_path is null
    then
      return null;
    end if;
    g_idx := 1;
    g_end := lengthc( p_json );
    for i in 1 .. 20 -- max 20 levels deep in p_path
    loop
      l_path := ltrim( l_path, c_ws );
      l_pos := least( nvl( nullif( instrc( l_path, '.' ), 0 ), 32768 )
                    , nvl( nullif( instrc( l_path, c_start_bracket ), 0 ), 32768 )
                    , nvl( nullif( instrc( l_path, c_end_bracket ), 0 ), 32768 )
                    );
      if l_pos = 32768
      then
        l_name := l_path;
        l_path := null;
      elsif substrc( l_path, l_pos, 1 ) = '.'
      then
        l_name := substrc( l_path, 1, l_pos - 1 );
        l_path := substrc( l_path, l_pos + 1 );
      elsif substrc( l_path, l_pos, 1 ) = c_start_bracket and l_pos > 1
      then
        l_name := substrc( l_path, 1, l_pos - 1 );
        l_path := substrc( l_path, l_pos );
      elsif substrc( l_path, l_pos, 1 ) = c_start_bracket and l_pos = 1
      then
        l_pos := instrc( l_path, c_end_bracket );
        if l_pos = 0
        then
          raise_application_error( -20008, 'No valid path, end bracket expected' );
        end if;
        l_name := substrc( l_path, 1, l_pos );
        if substrc( l_path, l_pos + 1, 1 ) = '.'
        then
          l_path := substrc( l_path, l_pos + 2 );
        else
          l_path := substrc( l_path, l_pos + 1 );
        end if;
      end if;
      l_name := rtrim( l_name, c_ws );
      --
      skip_whitespace;
      if substrc( p_json, g_idx, 1 ) = c_start_brace and substrc( l_name, 1, 1 ) != c_start_bracket
      then -- search for a name inside JSON object
           -- json unescape name?
        l_cnt := 0;
        loop
          g_idx := g_idx + 1; -- skip start brace or comma
          skip_whitespace;
          if substrc( p_json, g_idx, 1 ) = c_end_brace
          then
            return case when l_name = 'length()' and l_path is null then l_cnt end;
          elsif substrc( p_json, g_idx, 1 ) = c_comma
          then  -- two commas without a key-value pair in between is strictly not valid JSON
            continue;
          end if;
          l_start := g_idx;
          skip_value;  -- skip a name
          l_tmp_name := substrc( p_json, l_start, g_idx - l_start ); -- look back to get the name skipped
           -- json unescape name?
          skip_whitespace;
          if substrc( p_json, g_idx, 1 ) != c_colon
          then
            raise_application_error( -20002, 'No valid JSON, expected a colon at position ' || g_idx );
          end if;
          g_idx := g_idx + 1;  -- skip colon
          skip_whitespace;
          l_rv_start := g_idx;
          skip_value;
          if l_tmp_name in ( c_double_quote || l_name || c_double_quote
                           , c_single_quote || l_name || c_single_quote
                           , l_name
                           )
          then
            l_rv_end := g_idx;
            exit;
          else
            l_cnt := l_cnt + 1;
            skip_whitespace;
            if substrc( p_json, g_idx, 1 ) = c_comma
            then
              null; -- OK, keep on searching for name
            else
              -- searched name not found
              return case when l_name = 'length()' and l_path is null then l_cnt end;
            end if;
          end if;
        end loop;
      elsif substrc( p_json, g_idx, 1 ) = c_start_bracket and substrc( l_name, 1, 1 ) = c_start_bracket
      then
        begin
          l_ind := to_number( rtrim( ltrim( l_name, c_start_bracket ), c_end_bracket ) );
        exception
          when value_error
          then
            raise_application_error( -20009, 'No valid path, array index number expected' );
        end;
        for i in 0 .. l_ind loop
          g_idx := g_idx + 1; -- skip start bracket or comma
          skip_whitespace;
          if substrc( p_json, g_idx, 1 ) = c_end_bracket
          then
            return null;
          end if;
          l_rv_start := g_idx;
          skip_value;
          if i = l_ind
          then
            l_rv_end := g_idx;
            if l_rv_end = l_rv_start
            then
              return null;
            end if;
            exit;
          else
            skip_whitespace;
            if substrc( p_json, g_idx, 1 ) = c_comma
            then
              null; -- OK
            else
              return null;
            end if;
          end if;
        end loop;
      elsif substrc( p_json, g_idx, 1 ) = c_start_bracket and l_name = 'length()' and l_path is null
      then
        l_cnt := 0;
        loop
          g_idx := g_idx + 1; -- skip start bracket or comma
          skip_whitespace;
          exit when substrc( p_json, g_idx, 1 ) = c_end_bracket;
          l_cnt := l_cnt + 1;
          skip_value;
          skip_whitespace;
          exit when substrc( p_json, g_idx, 1 ) = c_end_bracket;
          if substrc( p_json, g_idx, 1 ) != c_comma
          then
            raise_application_error( -20010, 'No valid JSON, expected a comma at position ' || g_idx );
          end if;
        end loop;
        return l_cnt;
      else
        return null;
      end if;
      exit when l_path is null;
      g_idx := l_rv_start;
      g_end := l_rv_end - 1;
    end loop;
    if (  (   substrc( p_json, l_rv_start, 1 ) = c_double_quote
          and substrc( p_json, l_rv_end - 1, 1 ) = c_double_quote
          )
       or (   substrc( p_json, l_rv_start, 1 ) = c_single_quote
          and substrc( p_json, l_rv_end - 1, 1 ) = c_single_quote
          )
       )
    then
      l_rv_start := l_rv_start + 1;
      l_rv_end := l_rv_end - 1;
    end if;
    l_pos := instrc( p_json, c_back_slash, l_rv_start );
    if l_pos = 0 or l_pos >= l_rv_end or nvl( substrc( upper( p_unescape ), 1, 1 ), 'Y' ) = 'N'
    then -- no JSON unescaping needed
      return trim( substrc( p_json, l_rv_start, l_rv_end - l_rv_start ) );
    end if;
    l_start := l_rv_start;
    loop
      l_chr := substrc( p_json, l_pos + 1, 1 );
      if l_chr in ( '"', '\', '/' )
      then
        l_rv := l_rv || ( substrc( p_json, l_start, l_pos - l_start ) || l_chr );
      elsif l_chr in ( 'b', 'f', 'n', 'r', 't' )
      then
        l_chr := translate( l_chr
                          , 'btnfr'
                          , chr(8) || chr(9) || chr(10) || chr(12) || chr(13)
                          );
        l_rv := l_rv || ( substrc( p_json, l_start, l_pos - l_start ) || l_chr );
      elsif l_chr = 'u'
      then -- unicode character
        if l_nchar
        then
          l_chr := utl_i18n.raw_to_nchar( hextoraw( substrc( p_json, l_pos + 2, 4 ) ), 'AL16UTF16' );
        else
          l_chr := utl_i18n.raw_to_char( hextoraw( substrc( p_json, l_pos + 2, 4 ) ), 'AL16UTF16' );
        end if;
        l_rv := l_rv || ( substrc( p_json, l_start, l_pos - l_start ) || l_chr );
        l_pos := l_pos + 4;
      else
        raise_application_error( -20011, 'No valid JSON, unexpected back slash  at position ' || l_pos );
      end if;
      l_start := l_pos + 2;
      l_pos := instrc( p_json, c_back_slash, l_start );
      if l_pos = 0 or l_pos >= l_rv_end
      then
        l_rv := l_rv || substrc( p_json, l_start, l_rv_end - l_start );
        exit;
      end if;
    end loop;
    return trim( l_rv );
  end xjv;
  --
  -- convert a JSON number from xjv stored in a varchar2 result to number
  function jvs2n( p_val varchar2 )
  return number
  is
    l_pos pls_integer;
    l_fmt varchar2(32767) := upper( translate( p_val, '012345678, ', '999999999' ) );
  begin
    l_pos := instr( l_fmt, 'E' );
    if l_pos > 0
    then
      l_fmt := substr( l_fmt, 1, l_pos ) || 'EEE';
    end if;
    return to_number( rtrim( ltrim( p_val, '+ ' ) ), ltrim( l_fmt, '+-' ), 'NLS_NUMERIC_CHARACTERS = ''.,''' );
  exception
    when others then return null;
  end jvs2n;
  --
  function jvs2n( p_options varchar2 character set any_cs, p_path varchar2 )
  return number
  is
  begin
    return coalesce( jvs2n( xjv( p_options, p_path ) )
                   , conv2uu( jvs2n( xjv( p_options, p_path || '.value' ) ), xjv( p_options, p_path || '.unit' ) )
                   );
  end jvs2n;
  --
  function jvs2b( p_options varchar2 character set any_cs, p_path varchar2 )
  return boolean
  is
  begin
    return coalesce( upper( rtrim( ltrim( xjv( p_options, p_path ) ) ) ) = 'TRUE', false );
  end jvs2b;
  --
  function gfi( p_font_index pls_integer )
  return pls_integer
  is
  begin
    if p_font_index is not null and g_pdf.fonts.exists( p_font_index )
    then
      return p_font_index;
    end if;
    if g_pdf.current_font is null
    then
      set_font( p_family => 'helvetica' );
    end if;
    return g_pdf.current_font;
  end gfi;
  --
  procedure annot
    ( p_subtype    varchar2
    , p_txt        varchar2 character set any_cs
    , p_x          number
    , p_y          number
    , p_font_index pls_integer := null
    , p_fontsize   number      := null
    , p_line_width number      := null
    , p_txt_color  varchar2    := null
    , p_color      varchar2    := null
    , p_url        varchar2    := null
    , p_put_txt    boolean     := true
    , p_page_proc  pls_integer := null
    );
  --
  procedure set_info
    ( p_title    varchar2 := null
    , p_author   varchar2 := null
    , p_subject  varchar2 := null
    , p_creator  varchar2 := null
    , p_keywords varchar2 := null
    )
  is
  begin
    g_pdf.title    := substr( p_title,    1, 1024 );
    g_pdf.author   := substr( p_author,   1, 1024 );
    g_pdf.subject  := substr( p_subject,  1, 1024 );
    g_pdf.creator  := substr( p_creator,  1, 1024 );
    g_pdf.keywords := substr( p_keywords, 1, 8096 );
  end;
  --
  procedure set_pdf_version( p_version number := 1.4 )
  is
  begin
    if p_version is null
    then
      set_pdf_version;
    else
      g_pdf.pdf_version := p_version;
    end if;
  end set_pdf_version;
  --
  procedure set_pdfA3
    ( p_conformance                  varchar2 := 'B'
    , p_extra_meta_data_descriptions varchar2 := null
    )
  is
  begin
    g_pdf.pdf_a3_conformance := upper( substr( p_conformance, 1, 1 ) );
    g_pdf.meta_rdf_descr := p_extra_meta_data_descriptions;
  end set_pdfA3;
  --
  procedure set_proxy
    ( p_proxy            varchar2
    , p_no_proxy_domains varchar2 := null
    )
  is
  begin
    g_proxy := p_proxy;
    g_no_proxy := p_no_proxy_domains;
  end set_proxy;
  --
  procedure set_wallet
    ( p_path     varchar2
    , p_password varchar2 := null
    )
  is
  begin
    g_wallet_path := p_path;
    g_wallet_password := p_password;
  end set_wallet;
  --
  procedure set_initial_zoom( p_zoom_factor number := null )
  is
  begin
    g_pdf.zoom := p_zoom_factor;
  end set_initial_zoom;
  --
  procedure set_open_type_features
    ( p_enabled_features varchar2 := null
    , p_script           varchar2 := null
    , p_language         varchar2 := null
    , p_apply_GSUB       boolean  := null
    , p_apply_GPOS       boolean  := null
    )
  is
  begin
null;
  end set_open_type_features;
  --
  procedure set_current_page( p_page number )
  is
  begin
    if p_page between 0 and g_pdf.pages.count - 1
    then
      g_pdf.current_page := p_page;
    end if;
  end set_current_page;
  --
  procedure set_line_spacing_factor( p_factor number := 1.2 )
  is
  begin
    if p_factor is null
    then
      set_line_spacing_factor;
    else
      g_pdf.line_spacing_factor := p_factor;
    end if;
  end set_line_spacing_factor;
  --
  function conv2uu( p_value number, p_unit varchar2 )
  return number
  is
    c_inch constant number := 25.40025;
  begin
    return round( case coalesce( lower( p_unit ), 'cm' )
                    when 'mm'    then p_value * 72 / c_inch
                    when 'cm'    then p_value * 720 / c_inch
                    when 'point' then p_value
                    when 'pt'    then p_value       -- also point
                    when 'inch'  then p_value * 72
                    when 'in'    then p_value * 72  -- also inch
                    when 'pica'  then p_value * 12
                    when 'p'     then p_value * 12  -- also pica
                    when 'pc'    then p_value * 12  -- also pica
                    when 'px'    then p_value * 1.0007 -- Jasper Reports pixel
                    when 'pixel' then p_value * 1.0007 -- Jasper Reports pixel
                    else null
                  end
                , 3
                );
  end conv2uu;
  --
  procedure set_settings( p_page_size        varchar2
                        , p_page_orientation varchar2
                        , p_page_width       number
                        , p_page_height      number
                        , p_margin_left      number
                        , p_margin_right     number
                        , p_margin_top       number
                        , p_margin_bottom    number
                        , p_unit             varchar2
                        , p_text_direction   varchar2
                        , p_settings in out tp_settings
                        )
  is
    l_swap  number;
    l_short number;
    l_long  number;
  begin
    if p_page_size is not null
    then
      if     upper( substr( p_page_size, 1, 1 ) ) in ( 'A', 'B', 'C' )
         and ltrim( substr( p_page_size, 2 ), '0123456789' ) is null
         and to_number( substr( p_page_size, 2 ) ) between 0 and 10
      then
        case upper( substr( p_page_size, 1, 1 ) )
          when 'A' then
            l_short := 841;
            l_long  := 1189;
          when 'B' then
            l_short := 1000;
            l_long  := 1414;
          when 'C' then
            l_short := 917;
            l_long  := 1297;
        end case;
        for i in 1 .. to_number( substr( p_page_size, 2 ) )
        loop
          l_swap  := l_short;
          l_short := l_long / 2;
          l_long  := l_swap;
        end loop;
      elsif upper( p_page_size ) in ( 'EXECUTIVE', 'MONARCH' )
      then
        l_short := 184;
        l_long  := 267;
      elsif upper( p_page_size ) in ( 'FOLIO', 'FOOLSCAP', 'CAP', 'FC' )
      then
        l_short := 216;
        l_long  := 343;
      elsif upper( p_page_size ) = 'LEGAL'
      then
        l_short := 216;
        l_long  := 356;
      elsif upper( p_page_size ) = 'LETTER'
      then
        l_short := 216;
        l_long  := 279;
      elsif upper( p_page_size ) in ( 'TABLOID', 'LEDGER' )
      then
        l_short := 279;
        l_long  := 432;
      end if;
      p_settings.page_width  := conv2uu( trunc( l_short ), 'mm' );
      p_settings.page_height := conv2uu( trunc( l_long  ), 'mm' );
    else
      p_settings.page_width  := coalesce( conv2uu( p_page_width,  p_unit ), g_pdf.page_settings.page_width,  595.28 ); -- A4 portrait width
      p_settings.page_height := coalesce( conv2uu( p_page_height, p_unit ), g_pdf.page_settings.page_height, 841.89 ); -- A4 portrait height
    end if;
    p_settings.margin_left   := coalesce( conv2uu( p_margin_left,   p_unit ), g_pdf.page_settings.margin_left,   72 );     -- one inch
    p_settings.margin_right  := coalesce( conv2uu( p_margin_right,  p_unit ), g_pdf.page_settings.margin_right,  72 );
    p_settings.margin_top    := coalesce( conv2uu( p_margin_top,    p_unit ), g_pdf.page_settings.margin_top,    72 );
    p_settings.margin_bottom := coalesce( conv2uu( p_margin_bottom, p_unit ), g_pdf.page_settings.margin_bottom, 72 );
    if    (   substr( upper( p_page_orientation ), 1, 1 ) = 'L'
          and p_settings.page_width < p_settings.page_height
          )
       or (   substr( upper( p_page_orientation ), 1, 1 ) = 'P'
          and p_settings.page_width > p_settings.page_height
          )
    then
      l_swap := p_settings.page_width;
      p_settings.page_width := p_settings.page_height;
      p_settings.page_height := l_swap;
      -- assume turn clock wise
      l_swap                   := p_settings.margin_left;
      p_settings.margin_left   := p_settings.margin_bottom;
      p_settings.margin_bottom := p_settings.margin_right;
      p_settings.margin_right  := p_settings.margin_top;
      p_settings.margin_top    := l_swap;
    end if;
    if upper( p_text_direction ) in ( 'L2R', 'R2L' )
    then
      p_settings.text_direction := upper( p_text_direction );
    else
      p_settings.text_direction := coalesce( g_pdf.page_settings.text_direction, 'L2R' );
    end if;
  end set_settings;
  --
  procedure set_page_format( p_format varchar2 := 'A4' )
  is
  begin
    init_pdf( p_page_size => p_format );
  end;
  --
  procedure set_page_orientation( p_orientation varchar2 := 'PORTRAIT' )
  is
  begin
    init_pdf( p_page_orientation => p_orientation );
  end;
  --
  procedure set_text_direction( p_text_direction varchar2 := 'L2R' )
  is
  begin
    init_pdf( p_text_direction => p_text_direction );
  end set_text_direction;
  --
  procedure set_page_size
    ( p_width  number
    , p_height number
    , p_unit   varchar2 := 'cm'
    )
  is
  begin
    init_pdf( p_page_width  => p_width
            , p_page_height => p_height
            , p_unit        => p_unit
            );
  end;
  --
  procedure set_margins
    ( p_top number    := null
    , p_left number   := null
    , p_bottom number := null
    , p_right number  := null
    , p_unit varchar2 := null
    )
  is
  begin
    init_pdf( p_margin_left   => p_left
            , p_margin_right  => p_right
            , p_margin_top    => p_top
            , p_margin_bottom => p_bottom
            , p_unit          => p_unit
            );
  end;
  --
  procedure init_core_fonts
  is
    function uncompress_withs( p_compressed_tab varchar2 )
    return tp_pls_tab
    is
      l_rv tp_pls_tab;
      l_tmp varchar2(32767);
    begin
      if p_compressed_tab is not null
      then
        l_tmp := utl_compress.lz_uncompress( utl_encode.base64_decode( utl_raw.cast_to_raw( p_compressed_tab ) ) );
        for i in 0 .. 255
        loop
          l_rv( i ) := to_number( substr( l_tmp, 1 + 8 * i, 8 ), 'XXXXXXXX' );
        end loop;
      end if;
      return l_rv;
    end;
    --
    procedure init_core_font
      ( p_ind            pls_integer
      , p_family         varchar2
      , p_style          varchar2
      , p_name           varchar2
      , p_flags          pls_integer
      , p_ascent         pls_integer
      , p_descent        pls_integer
      , p_linegap        pls_integer
      , p_compressed_tab varchar2
      )
    is
      l_font tp_font;
    begin
      l_font.family   := p_family;
      l_font.style    := p_style;
      l_font.name     := p_name;
      l_font.fontname := p_name;
      l_font.standard := true;
      l_font.flags    := p_flags;
      l_font.unit_norm := 1;
      l_font.ascent  := p_ascent;
      l_font.descent := p_descent;
      l_font.linegap := p_linegap;
      l_font.win_ascent := p_ascent + 0.5 * p_linegap;
      l_font.win_descent := p_descent - 0.5 * p_linegap;
      g_pdf.fonts( p_ind ) := l_font;
      g_pdf.font_width_cache( - p_ind ) := uncompress_withs( p_compressed_tab );
    end;
  begin
    init_core_font( 1, 'helvetica', 'N', 'Helvetica', 32, 800, -200, 90
      ,  'H4sIAAAAAAAAC81Tuw3CMBC94FQMgMQOLAGVGzNCGtc0dAxAT+8lsgE7RKJFomOA'
      || 'SLT4frHjBEFJ8XSX87372C8A1Qr+Ax5gsWGYU7QBAK4x7gTnGLOS6xJPOd8w5NsM'
      || '2OvFvQidAP04j1nyN3F7iSNny3E6DylPeeqbNqvti31vMpfLZuzH86oPdwaeo6X+'
      || '5X6Oz5VHtTqJKfYRNVu6y0ZyG66rdcxzXJe+Q/KJ59kql+bTt5K6lKucXvxWeHKf'
      || '+p6Tfersfh7RHuXMZjHsdUkxBeWtM60gDjLTLoHeKsyDdu6m8VK3qhnUQAmca9BG'
      || 'Dq3nP+sV/4FcD6WOf9K/ne+hdav+DTuNLeYABAAA' );
    --
    init_core_font( 2, 'helvetica', 'I', 'Helvetica-Oblique', 96, 800, -200, 90
      ,  'H4sIAAAAAAAAC81Tuw3CMBC94FQMgMQOLAGVGzNCGtc0dAxAT+8lsgE7RKJFomOA'
      || 'SLT4frHjBEFJ8XSX87372C8A1Qr+Ax5gsWGYU7QBAK4x7gTnGLOS6xJPOd8w5NsM'
      || '2OvFvQidAP04j1nyN3F7iSNny3E6DylPeeqbNqvti31vMpfLZuzH86oPdwaeo6X+'
      || '5X6Oz5VHtTqJKfYRNVu6y0ZyG66rdcxzXJe+Q/KJ59kql+bTt5K6lKucXvxWeHKf'
      || '+p6Tfersfh7RHuXMZjHsdUkxBeWtM60gDjLTLoHeKsyDdu6m8VK3qhnUQAmca9BG'
      || 'Dq3nP+sV/4FcD6WOf9K/ne+hdav+DTuNLeYABAAA' );
    --
    init_core_font( 3, 'helvetica', 'B', 'Helvetica-Bold', 32, 800, -200, 90
      ,  'H4sIAAAAAAAAC8VSsRHCMAx0SJcBcgyRJaBKkxXSqKahYwB6+iyRTbhLSUdHRZUB'
      || 'sOWXLF8SKCn+ZL/0kizZuaJ2/0fn8XBu10SUF28n59wbvoCr51oTD61ofkHyhBwK'
      || '8rXusVaGAb4q3rXOBP4Qz+wfUpzo5FyO4MBr39IH+uLclFvmCTrz1mB5PpSD52N1'
      || 'DfqS988xptibWfbw9Sa/jytf+dz4PqQz6wi63uxxBpCXY7uUj88jNDNy1mYGdl97'
      || '856nt2f4WsOFed4SpzumNCvlT+jpmKC7WgH3PJn9DaZfA42vlgh96d+wkHy0/V95'
      || 'xyv8oj59QbvBN2I/iAuqEAAEAAA=' );
    --
    init_core_font( 4, 'helvetica', 'BI', 'Helvetica-BoldOblique', 96, 800, -200, 90
      ,  'H4sIAAAAAAAAC8VSsRHCMAx0SJcBcgyRJaBKkxXSqKahYwB6+iyRTbhLSUdHRZUB'
      || 'sOWXLF8SKCn+ZL/0kizZuaJ2/0fn8XBu10SUF28n59wbvoCr51oTD61ofkHyhBwK'
      || '8rXusVaGAb4q3rXOBP4Qz+wfUpzo5FyO4MBr39IH+uLclFvmCTrz1mB5PpSD52N1'
      || 'DfqS988xptibWfbw9Sa/jytf+dz4PqQz6wi63uxxBpCXY7uUj88jNDNy1mYGdl97'
      || '856nt2f4WsOFed4SpzumNCvlT+jpmKC7WgH3PJn9DaZfA42vlgh96d+wkHy0/V95'
      || 'xyv8oj59QbvBN2I/iAuqEAAEAAA=' );
    --
    init_core_font( 5, 'times', 'N', 'Times-Roman', 32, 800, -200, 90
      ,  'H4sIAAAAAAAAC8WSKxLCQAyG+3Bopo4bVHbwHGCvUNNT9AB4JEwvgUBimUF3wCNR'
      || 'qAoGRZL9twlQikR8kzTvZBtF0SP6O7Ej1kTnSRfEhHw7+Jy3J4XGi8w05yeZh2sE'
      || '4j312ZDeEg1gvSJy6C36L9WX1urr4xrolfrSrYmrUCeDPGMu5+cQ3Ur3OXvQ+TYf'
      || '+2FGexOZvTM1L3S3o5fJjGQJX2n68U2ur3X5m3cTvfbxsk9pcsMee60rdTjnhNkc'
      || 'Zip9HOv9+7/tI3Oif3InOdV/oLdx3gq2HIRaB1Ob7XPk35QwwxDyxg3e09Dv6nSf'
      || 'rxQjvty8ywDce9CXvdF9R+4y4o+7J1P/I9sABAAA' );
    --
    init_core_font( 6, 'times', 'I', 'Times-Italic', 96, 800, -200, 90
      ,  'H4sIAAAAAAAAC8WSPQ6CQBCFF+i01NB5g63tPcBegYZTeAB6SxNLjLUH4BTEeAYr'
      || 'Kwpj5ezsW2YgoKXFl2Hnb9+wY4x5m7+TOOJMdIFsRywodkfMBX9aSz7bXGp+gj6+'
      || 'R4TvOtJ3CU5Eq85tgGsbxG3QN8iFZY1WzpxXwkckFTR7e1G6osZGWT1bDuBnTeP5'
      || 'KtW/E71c0yB2IFbBphuyBXIL9Y/9fPvhf8se6vsa8nmeQtU6NSf6ch9fc8P9DpqK'
      || 'cPa5/I7VxDwruTN9kV3LDvQ+h1m8z4I4x9LIbnn/Fv6nwOdyGq+d33jk7/cxztyq'
      || 'XRhTz/it7Mscg7fT5CO+9ahnYk20Hww5IrwABAAA' );
    --
    init_core_font( 7, 'times', 'B', 'Times-Bold', 32, 800, -200, 90
      , 'H4sIAAAAAAAAC8VSuw3CQAy9XBqUAVKxAZkgHQUNEiukySxpqOjTMQEDZIrUDICE'
      || 'RHUVVfy9c0IQJcWTfbafv+ece7u/Izs553cgAyN/APagl+wjgN3XKZ5kmTg/IXkw'
      || 'h4JqXUEfAb1I1VvwFYysk9iCffmN4+gtccSr5nlwDpuTepCZ/MH0FZibDUnO7MoR'
      || 'HXdDuvgjpzNxgevG+dF/hr3dWfoNyEZ8Taqn+7d7ozmqpGM8zdMYruFrXopVjvY2'
      || 'in9gXe+5vBf1KfX9E6TOVBsb8i5iqwQyv9+a3Gg/Cv+VoDtaQ7xdPwfNYRDji09g'
      || 'X/FvLNGmO62B9jSsoFwgfM+jf1z/SPwrkTMBOkCTBQAEAAA=' );
    --
    init_core_font( 8, 'times', 'BI', 'Times-BoldItalic', 96, 800, -200, 90
      ,  'H4sIAAAAAAAAC8WSuw2DMBCGHegYwEuECajIAGwQ0TBFBnCfPktkAKagzgCRIqWi'
      || 'oso9fr+Qo5RB+nT2ve+wMWYzf+fgjKmOJFelPhENnS0xANJXHfwHSBtjfoI8nMMj'
      || 'tXo63xKW/Cx9ONRn3US6C/wWvYeYNr+LH2IY6cHGPkJfvsc5kX7mFjF+Vqs9iT6d'
      || 'zwEL26y1Qz62nWlvD5VSf4R9zPuon/ne+C45+XxXf5lnTGLTOZCXPx8v9Qfdjdid'
      || '5vD/f/+/pE/Ur14kG+xjTHRc84pZWsC2Hjk2+Hgbx78j4Z8W4DlL+rBnEN5Bie6L'
      || 'fsL+1u/InuYCdsdaeAs+RxftKfGdfQDlDF/kAAQAAA==' );
    --
    init_core_font( 9, 'courier', 'N', 'Courier', 33, 800, -200, 90, null );
    for i in 0 .. 255
    loop
      g_pdf.font_width_cache( - 9 )( i ) := 600;
    end loop;
    --
    init_core_font( 10, 'courier', 'I', 'Courier-Oblique', 97, 800, -200, 90, null );
    g_pdf.font_width_cache( - 10 ) := g_pdf.font_width_cache( - 9 );
    --
    init_core_font( 11, 'courier', 'B', 'Courier-Bold', 33, 800, -200, 90, null );
    g_pdf.font_width_cache( - 11 ) := g_pdf.font_width_cache( - 9 );
    --
    init_core_font( 12, 'courier', 'BI', 'Courier-BoldOblique', 97, 800, -200, 90, null );
    g_pdf.font_width_cache( - 12 ) := g_pdf.font_width_cache( - 9 );
    --
    init_core_font( 13, 'symbol', 'N', 'Symbol', 4, 800, -200, 90
      ,  'H4sIAAAAAAAAC82SIU8DQRCFZ28xIE+cqcbha4tENKk/gQCJJ6AweIK9H1CHqKnp'
      || 'D2gTFBaDIcFwCQkJSTG83fem7SU0qYNLvry5nZ25t7NnZkv7c8LQrFhAP6GHZvEY'
      || 'HOB9ylxGubTfNVRc34mKpFonzBQ/gUZ6Ds7AN6i5lv1dKv8Ab1eKQYSV4hUcgZFq'
      || 'J/Sec7fQHtdTn3iqfvdrb7m3e2pZW+xDG3oIJ/Li3gfMr949rlU74DyT1/AuTX1f'
      || 'YGhOzTP8B0/RggsEX/I03vgXPrrslZjfM8/pGu40t2ZjHgud97F7337mXP/GO4h9'
      || '3WmPPaOJ/jrOs9yC52MlrtUzfWupfTX51X/L+13Vl/J/s4W2S3pSfSh5DmeXerMf'
      || '+LXhWQAEAAA=' );
    --
    init_core_font( 14, 'zapfdingbats', 'N', 'ZapfDingbats', 4, 800, -200, 90
      ,  'H4sIAAAAAAAAC83ROy9EQRjG8TkzjdJl163SSHR0EpdsVkSi2UahFhUljUKUIgoq'
      || 'CrvJCtFQyG6EbSSERGxhC0ofQAQFxbIi8T/7PoUPIOEkvzxzzsycdy7O/fUTtToX'
      || 'bnCuvHPOV8gk4r423ovkGQ5od5OTWMeesmBz/RuZIWv4wCAY4z/xjipeqflC9qAD'
      || 'aRwxrxkJievSFzrRh36tZ1zttL6nkGX+A27xrLnttE/IBji9x7UvcIl9nPJ9AL36'
      || 'd1L9hyihoDW10L62cwhNyhntryZVExYl3kMj+zym+CrJv6M8VozPmfr5L8uwJORL'
      || 'tox7NFHG/Obj79FlwhqZ1X292xn6CbAXP/fjjv6rJYyBtUdl1vxEO6fcRB7bMmJ3'
      || 'GYZsTN0GdrDL/Ao5j1GZNr5kwqydX5z1syoiYEq5gCtlSrXi+mVbi3PfVAuhoQAE'
      || 'AAA=' );
    --
  end init_core_fonts;
  --
  procedure init_color_names
  is
    l_ind pls_integer;
    l_pos pls_integer;
    l_rgb varchar2(4000);
  begin
    -- https://www.w3.org/TR/css-color-3/#svg-color
    l_rgb := 'H4sIAAAAAAAAA2VW2bLrKAz8JbxgQ/lrBBIxExtyvZxU5utHAic5tya8oAaDlm6R'
         ||  'oIIJAZboyS0nTQHI4QjpiH9Oes7xoEmpwD/4c8I08gR7ma6wxcTb69q/58ZzHTR6'
         ||  'R/HG80C9713c+RQ+QH5uAX+XBeeR58nPhLCsOWHZEEK530DrqJXpT8wLHRPoFlpw'
         ||  'W36mCckZM7pzW17PnHHSwRIoD0hH+VjcU8rPsB0bnTtN2A62IT9nnxc4xK0xaOXz'
         ||  'Bss09FYT8jyFJT9pq+GHYNALuMflPqFv+s77La57Tlci/AtS8dg4hO1ePhOjmmWV'
         ||  'vRxUMW95QUob+wpWRsE2ePEXQ69UNYnSX8v0mhy6cSgn3Ge4x8m4930r3CgdMGk9'
         ||  'uDYIkpf4Q/UU9t7XUznExHWwtmu9r4CfI5aD6o6NcCJrhxHE2kspJhOcN+XUnaCe'
         ||  '2ZsO69W75LDE24aexwcrEf0PI4nSEzaCHef258yRa2Il7k6wq8IhNL3tkOjxiOnO'
         ||  '3zhhGZv7/VVuG6wMjGu555fFNzRkuSqY8XZV0LXyC3Ejt8VCuADM0kVqXvnctoY3'
         ||  'hbzRfrzTVkp7+nmPwEWXcYOYdpe3PLFAWCK3Oe9HPYDvG5WS0k4IzE/1rbJRMq4K'
         ||  'G870VV0MoQ1l/qKF6fbZyCEUDak5J3ohPfn0wbp+zkfJhkfttY8JIySpWC9EaMW+'
         ||  'ZYmNv4w/eZNTaDC+soUGGljT8EMJaZNtKui3yVna52n0gZmywDO9UxDA40JMAuZJ'
         ||  'CFmcRkPDEm9zVVcoLhe7KoiKHiogtOdEA7bF/mTkCpcLzqMuSXKsIi7cZcv9f22Q'
         ||  'pAQ3+KbYJQ/snhqh2BdVW+VauJA3V83oKVzYRZ5xNMbaCn24+n9QNKd8j1TBg2h5'
         ||  'N4RA1dErFKEKZy6uNLG2sGtleiURpAoLN8Y3p95qNaUFctPM7PkwsCJhJYzn+quX'
         ||  'yg6PFa5UBq2xq8AlX9uNCl2FHuf2WNgJ77qxqdAnEaMbDNEFfmTLHnGXudAHX3p7'
         ||  'Sxwb7yv+FaofG210RatUhYCNbeyo1ojpSwwt7FljOvxGsJbmT80a9+O15b0+Bk6v'
         ||  '2XvYo2QGCTDBD/yT3y+MiIURrjsGTQOzh18LKipRqjS4aXCG2q7McQMnjNC8Vvtc'
         ||  'CP3HEC8ROE/DlTQiMgAPWOgrVMudzpqCVYUG3kVifxPAPVjZTrBv+BxLQP3g017A'
         ||  'zj8kGnD2QeDnxxkCC9boLjxoO3nJK+8KfRFBIT6Wc2WaEZPkkZ94dSxTor+qKbRR'
         ||  'Sm6SRmwCJ/BVH7++GSw1W35BZaZxvW66nVW6UN0RwKixveQReugHtUPC6/uWjNPj'
         ||  'hyFcMk3E5j4zrydQum1xj5QSTOw2D34Bf7h7iKbIfXoxaO4TX0qN7LpVv5T12y46'
         ||  'lq6wp0s4Y/iLd4NpXf8VG7Jl/FHeVyn9Qdxl+PEJaI6Z6VTyM3T9eOQVjjz1nEpU'
         ||  '34JxnVt6/3HgPyPkuudMcNRGGa7urWWU+b7me5W4Upe6LYikq1Gc/A+WnCdqIQkA'
         ||  'AA==';
    l_rgb := utl_raw.cast_to_varchar2(
             utl_compress.lz_uncompress(
             utl_encode.base64_decode(
             utl_raw.cast_to_raw( l_rgb ) ) ) ) || ';';
    l_ind := 1;
    for i in 1 .. 147
    loop
      l_pos := instr( l_rgb, ';', l_ind );
      g_color_names( substr( l_rgb, l_ind + 6, l_pos - l_ind - 6 ) )
          := substr( l_rgb, l_ind, 6 );
      l_ind := l_pos + 1;
    end loop;
  end init_color_names;
  --
  procedure init_unicode_data
  is
    procedure init_some_unicode_data( p_start pls_integer, p_class pls_integer, p_end pls_integer := null )
    is
    begin
      for i in p_start .. coalesce( p_end, p_start )
      loop
        g_unicode_data( i ) := p_class;
      end loop;
    end init_some_unicode_data;
    --
    procedure init_some_compr_unicode_data( p_class pls_integer, p_cmpr varchar2 )
    is
      l_len  pls_integer;
      l_pos1 pls_integer;
      l_pos2 pls_integer;
      l_pos3 pls_integer;
      l_tmp varchar2(32767);
    begin
      l_tmp := utl_raw.cast_to_varchar2( utl_compress.lz_uncompress( utl_encode.base64_decode( utl_raw.cast_to_raw( p_cmpr ) ) ) );
      l_tmp := l_tmp || ';';
      l_len := length( l_tmp );
      l_pos1 := 1;
      loop
        exit when l_pos1 > l_len;
        l_pos2 := instr( l_tmp, ';', l_pos1 + 1 ) + 1;
        l_pos3 := instr( l_tmp, ';', l_pos2 );
        exit when l_pos2 = 1 or l_pos3 = 0;
        init_some_unicode_data( substr( l_tmp, l_pos1, l_pos2 - l_pos1 - 1 ), p_class, substr( l_tmp, l_pos2, l_pos3 - l_pos2 ) );
        l_pos1 := l_pos3 + 1;
      end loop;
    end init_some_compr_unicode_data;
    --
  begin
    --
    init_some_compr_unicode_data( c_class_ON,
        'H4sIAAAAAAAAAy2U2xXEIAgFWxJQgWP/fe1csh8ZEiTyEIx4sV/U2/5Ov7tf2+v7' ||
        'zIMHee0BvfSzNB7n2TznWS0WC0WhqHzGz27nPd/53u3kqZfrvrR+6f4yzsttPHwf' ||
        '5M1X/F11XvV+r9fiIYYV7L0MlW0r0U3A29kDIjxnCQrryCaJ8vkiH194iUVOscgK' ||
        '3PfC2oUiY0GOzloFLN8xJ5+TJALqXXMhyML2BgdsNhNLoGCXgO49RG9O4jCFBgQA' ||
        'AhzpjnSpz5R16bPXK8d/eWDsmwWXnV991n0VNsAkwgVqtXcJ2G1SB9KdK+BIscFc' ||
        'gguyrhAU4SY/kUrV4WgAf5G8oE/XG8kA/lSd6+h4TsmOClZyFGDrpAKweRtptBmn' ||
        '58TTXnojvw527iDQ3pxWV/drFd6WBz21ttrNpuFsWs5UL5FVFNLv/ljwWAy1mil7' ||
        'IoO9tujS45T2XbKhG+gWV21hznvFUKveo/lanvOHQacg1GQwhjJVDuZ7NJuGENV0' ||
        'fsgDkaFNUkPipTDwow2rhq0A2vdQlp0pMjMWS8FDNDGjBUkq/E92izDNYk+e3QwO' ||
        'E+GaXI3g9rNaxGjTPpgi3IcB8+g9OchNRMS9YxE+JK3NIe0hu0ZpPxj0uFIQ7d2z' ||
        'OHaJvYYtUtB7jGEVzxtRI2wNS/R5dxvu4R1+pjH7etnQh1pX/9wTVAWa9BHyGhrH' ||
        'Eyn7mL/UyKK8nbE845ktxFB8SRMh6si0w4fzvmXaFOhdpl/B1KaakMuMa4xbCLJJ' ||
        'EvcW6TuOm2LC9mHC1DhsHd3Xind6kWEecUZLTBKXS4q6/HuHiypH6iqR1E4jFQ5e' ||
        'U6cuoS7C2bTa1+C5pqnyu7P5cdZMV6PEp7z5ifnB6lOWNuNathHT2KmrWyL/PT1h' ||
        '5jcHuddEx2W7PzHb5QwDF0KOGP+Vu0YoW8T9TO4oa/xXzdRxE89azyRy/8eIb1BW' ||
        'zNSo5SS+GbKpBZfNWNpMbc91gRgPbT2z5Wt9wkbMIPZefzH+9sTSe2rRdyrK4cza' ||
        '3Z9yUul7PuW5n/iUkxjTOHvez8N3WPSNf2Is0z8Rn8n+TM739eXeU+zuL1vkD3nV' ||
        'anifBwAA' );
    --
    init_some_compr_unicode_data( c_class_NSM,
        'H4sIAAAAAAAAAy2WWZYFIQjFtuSIet7+99XJrf4JJeIESHnq/u55v973BtV/fQ2+' ||
        'VqFbp//kFEuUOOLRs/cABaozsKZYl56zmyjBRKeWOOKCY6/T3uY8d9G+hfXbdD9s' ||
        'RhsHzA3W/kHGgClUXr9uvjS8Dzx0fR5Bc2zhiOGI2QqwWblC+udRe7ttZ5uv/8Zq' ||
        'QzByzUnPeiNk5t2aYNdjTz8589jsGpafLDBqtJ/cgvl1DLDHA5VbrOWadVS6x8Kt' ||
        '0HPUY+KjH9n4FEfQc8qe0h/nlqDn9ia2cI7LkaR7vJwMLPA8yWtdsOjrSzDqLexn' ||
        'a1eOLtmVVN/nEgXWEDZXmg+wNXAB8QH9N0dzjsFWIXMAjMa7gjFzXOEX2wc22R3A' ||
        'eDVON9fwkxSYixV+U19LTDfJAtxhGR2Ibbm5IodnEQGi6h5Mu3mO7esXzp1X3cWF' ||
        'Mx6BO3SVh7fZRAlWeo58JD7A/uHL+V4wf+TIBezotzqxXHpm6ZnVt03mAuo4wdJH' ||
        'i0QXGxBiMH6LrAXdL84sbXNccGwzz28953ikwH6kMbhgCryx3wn6rxqhBRNwAvBA' ||
        'OohBNXJGqiQS1c3j8uaXmywDBRhIxOlZpCxYAvPFWrW42fIIlHXEbcIxx8hABlkE' ||
        'QNo4QjLKoJDs7Ok46mTUdaVLytfDFWVe1vOWluEoD1iGQ+Lx0/oD5MdpbAp0QKSO' ||
        '5zztqrvqmP1YJo7ZK5dI+9kmVMdQHUMAmHYMvwY6iwO4wBkn8QLMsKgCJ5l6Vh9h' ||
        'CdYuv7zRYIv3u5pfnUmVJTYyxXYR4N71FcS6j0ngJUZjcShpahA/2VsYDTcVmmDD' ||
        'vOeycA8klrNhGbE+8SI4tyxpWNhSW6Edgw1C/ALLrGM3I1Q1p0Yzc+gJ6eC1Yroy' ||
        '7crotUc45Uu3xVFWqNEmpnKGzrTvienzHnCjs/f6b1E+1jythTN0zOnR9B5mKX87' ||
        'Uj+ccjT+35+4EV9yj9yG3caSJjhhKWlyVn47FJNkHdYjpJ9/1gkZQe3t4Qiv7NHs' ||
        'aAiPfF+K79ApHgeRXNRHFQ7Ne70I3cZLdUPcmwtgtz8BWA64/eMKT6jljT1zwzfU' ||
        'v9lDF3u5LlYIhbkKvTL+X+WV19vVTHe4v/vWwxnWp7phbmKLavKLV5we3lzP3M+m' ||
        'xoIBKxpv92m4P9R093xnUyffJ9f8jHyPXO+RhSwtud1b5kw3FxyRArBu7n06cscb' ||
        'DpEcoHf31A2d/DTWhc4NkGpSCro1WaZWjNlDjUh+VdO/uGKFDpk7KrNfptRQ/GH1' ||
        'MHocdfoZoYfo3lup5Xs7rNB6N76Ije65RqrWMLnklv5tLV+pZAZm+BuWKWZrhtFn' ||
        '8MjgXPOTR5JM9023dTPVCK4RrtDVrOlSe58kJ2+SM+JvXh491P7eaO4IZxjLa2Ul' ||
        'uSQpLD0nBaeFPZxhjKZenYkT3OGLqqcnuTXNLS/UCEuekB2Q+k6CwL3yQl6g1uB5' ||
        'WTHCIs3baH5iR9TX8tWq+G/5aH6jt09E6fMygoo+khUKFkL4nlT4Zh5JhkgfWUqu' ||
        'EWJ/Rvk/GGaVcWJEfcLpeMStT5wI1x95z0XUJz5Lz0Tu3hXx8oepcSN8spMRsyKW' ||
        'lnvsf4GD+C/pUk773h+b4qxfLAwAAA==' );
    --
    init_some_compr_unicode_data( c_class_R,
        'H4sIAAAAAAAAAyWSURYFMQRDt9QqFaf739ckmZ/LIIr3dvZ6b2eHWSZE4O3aKQwR' ||
        '9Ab5YsUljtFEUknq+w7RqW/8hDjM7b2EICTdUoHF790M1G9aZLUI8lAkhnlNqPSE' ||
        'E7HNY6bpolPvdnEEccThczIKXY4tKnFzmflsnLhONHt3c0yy7JfiWBD1Dvn7jvtN' ||
        'XHVAS4WRP+uo9VyWYmlU0r4ew6olamfoOmKZbY6oNbHT/l2mOuy2Smtij7RR0gaU' ||
        '9UFwjrRHa3BCMZdqUtdE6hJI3QB5HWnXaHSUK0sLozxDheLXEU5N9pGKe5NYiqB+' ||
        'qgaX+04kRP0QE6NzjH9kku3maI1JrT2lEadapVft5ka8HUk5TW39C2XahjeXgYN0' ||
        'fjPP9v7RPr/Bb+YD9ENq3PECAAA=' );
    --
    init_some_compr_unicode_data( c_class_AL,
        'H4sIAAAAAAAAAy2Q0RXAIAgDVxIEhNf992og/NxZxCgVN/s+cXvDasZtWCM+CTmA' ||
        'eeM16pM3CG+g5T1r9GfiM483XiOBDsiLExlAOTYKq08Fdytu/VTRqKqNewDcFHZv' ||
        'gIa7wOhKaq/TEiyRoTV71w9CQD2g9FkXm7UpqA+VTMwFFnLK1JoYDcSrwB5J41By' ||
        'taWnRjGy/jGtR7FYTrFY2cJ7PvqupwnPoYKaAFdhj27v3bPX129dtAl1KSYbI/F7' ||
        'xr6Zvpm+Wb5ZvlnBrFDKtjqz+DsUNx8nSxaTtydvT+7VvrzmRByhpjU4bahTj2Lx' ||
        'suVyz+UHrZiRP5sCAAA=' );
    --
    init_some_compr_unicode_data( c_class_EN,
        'H4sIAAAAAAAAAyXM2Q1EMQhD0ZYAh03uv68x8z5yLkIib5hN79Fb+iQ1dN0mObDH' ||
        'c4RDhB3LRYZoZ2VsSViyKhrn6quwnrjoVOlA/PMUmOHL8x9BUEQKggAAAA==' );
    --
    init_some_compr_unicode_data( c_class_BN,
        'H4sIAAAAAAAAAyXL2w3AQAwCwZaCHfwQ/fcV7vKzYwkZnVKBI008eUJnxtk48ZUe' ||
        'itErATnx/rRZkJcKLZr+vmYdKvEBPzS5umEAAAA=' );
    --
    init_some_compr_unicode_data( c_class_ET,
        'H4sIAAAAAAAAAyXO2REAIQgD0Ja4Ajrpv68N7gdPEFETzKF3KECfVqiuSNJRWLTX' ||
        'FWRsKkYAqo85maZBZmub7SZPlC3FkwhxkqduqTN7b2mknmDD/XKXuGuaDA2s24bV' ||
        '88/3DNw42Tef+ly8xz/wl63aygAAAA==' );
    --
    init_some_compr_unicode_data( c_class_AN,
        'H4sIAAAAAAAAAx3GwRHAMAwCsJnAGLfH/nslzkcndDloIXDx8qZaFExPQo4Sfz+4EvHFq3wA5vGEBkEAAAA=' );
    --
    init_some_compr_unicode_data( c_class_WS,
        'H4sIAAAAAAAAAxXIsREAMAgDsZXAHMG533+vkEaFStBzApxXWPGpXcsDKdk8jwVK7CYAAAA=' );
    --
    init_some_compr_unicode_data( c_class_CS,
        'H4sIAAAAAAAAAyXKURIAMARDwSsVoUzuf69SP29NBkAiiEtPUuJ0HH2mWk1nCZeDJZYatHTBr3etHx7/m1ofUwAAAA==' );
    --
    init_some_compr_unicode_data( c_class_ES,
        'H4sIAAAAAAAAAx3HwREAIAjEwJaEA9FJ/30JfjaTEETCkcWQjdZgnHKHHX6rk9Y3qvVr/IgHi4oMjUIAAAA=' );
    --
    init_some_unicode_data( 8233, c_class_B );
    init_some_unicode_data( 8234, c_class_LRE );
    init_some_unicode_data( 8235, c_class_RLE );
    init_some_unicode_data( 8236, c_class_PDF );
    init_some_unicode_data( 8237, c_class_LRO );
    init_some_unicode_data( 8238, c_class_RLO );
    init_some_unicode_data( 8294, c_class_LRI );
    init_some_unicode_data( 8295, c_class_RLI );
    init_some_unicode_data( 8296, c_class_FSI );
    init_some_unicode_data( 8297, c_class_PDI );
    --
  end init_unicode_data;
  --
  procedure cleanup
  is
  begin
    for i in 1 .. g_pdf.fonts.count
    loop
      if g_pdf.font_code_cache.exists( i )
      then
        g_pdf.font_code_cache( i ).delete;
      end if;
      if g_pdf.font_glyph_cache.exists( i )
      then
        g_pdf.font_glyph_cache( i ).delete;
      end if;
      if g_pdf.font_width_cache.exists( i )
      then
        g_pdf.font_width_cache( i ).delete;
      end if;
      if g_pdf.font_old_new.exists( i )
      then
        g_pdf.font_old_new( i ).delete;
      end if;
      if g_pdf.font_files.exists( i ) and dbms_lob.istemporary( g_pdf.font_files( i ) ) = 1
      then
        dbms_lob.freetemporary( g_pdf.font_files( i ) );
      end if;
    end loop;
    g_pdf.font_code_cache.delete;
    g_pdf.font_glyph_cache.delete;
    g_pdf.font_width_cache.delete;
    g_pdf.font_old_new.delete;
    g_pdf.font_files.delete;
    g_pdf.gdef.delete;
    g_pdf.outlines.delete;
    g_pdf.gsub_gpos.delete;
    g_pdf.fonts.delete;
    for i in 0 .. g_pdf.pages.count - 1
    loop
      g_pdf.pages( i ).annots.delete;
      dbms_lob.freetemporary( g_pdf.pages( i ).content );
    end loop;
    for i in 1 .. g_pdf.images.count
    loop
      dbms_lob.freetemporary( g_pdf.images( i ).pixels );
      if dbms_lob.istemporary( g_pdf.images( i ).smask ) = 1
      then
        dbms_lob.freetemporary( g_pdf.images( i ).smask );
      end if;
    end loop;
    for i in 0 .. g_pdf.page_procs.count - 1
    loop
      g_pdf.page_procs( i ).nums.delete;
      g_pdf.page_procs( i ).chars.delete;
    end loop;
    for i in 0 .. g_pdf.embedded_files.count - 1
    loop
     dbms_lob.freetemporary( g_pdf.embedded_files( i ).content );
    end loop;
    g_pdf.pages.delete;
    g_pdf.images.delete;
    g_pdf.egs_dir.delete;
    g_pdf.objects.delete;
    g_pdf.page_procs.delete;
    g_pdf.embedded_files.delete;
    g_color_names.delete;
    g_hex.delete;
    g_unicode_data.delete;
  end cleanup;
  --
  procedure init
  is
  begin
    cleanup;
    if dbms_lob.istemporary( g_pdf.pdf_blob ) = 1
    then
      dbms_lob.freetemporary( g_pdf.pdf_blob );
    end if;
$IF dbms_db_version.ver_le_11
$THEN
    g_pdf := null;
$ELSIF dbms_db_version.ver_le_12
$THEN
    g_pdf := null;
$ELSE
    g_pdf := tp_pdf();
$END
    init_pdf;
    init_core_fonts;
    init_color_names;
    init_unicode_data;
    --
    g_hex.delete;
    for i in 0 .. 255
    loop
      g_hex( to_char( i, 'fm0X' ) ) := i;
    end loop;
  end init;
  --
  function blob2num( p_blob blob, p_len integer, p_pos integer )
  return number
  is
  begin
    return to_number( rawtohex( dbms_lob.substr( p_blob, p_len, p_pos ) ), 'XXXXXXXX' );
  end;
  --
  function num2raw( p_value number )
  return raw
  is
  begin
    return hextoraw( to_char( p_value, 'FM0XXXXXXX' ) );
  end;
  --
  function raw2num( p_value raw )
  return number
  is
  begin
    return to_number( rawtohex( p_value ), 'XXXXXXXX' );
  end;
  --
  function raw2num( p_value raw, p_pos pls_integer, p_len pls_integer )
  return pls_integer
  is
  begin
    return to_number( rawtohex( utl_raw.substr( p_value, p_pos, p_len ) ), 'XXXXXXXX' );
  end;
  --
  function to_char_round
    ( p_value number
    , p_precision pls_integer := 2
    )
  return varchar2
  is
  begin
    return to_char( round( p_value, p_precision ), 'TM9', 'NLS_NUMERIC_CHARACTERS=.,' );
  end;
  --
  procedure raw2page( p_txt raw, p_page pls_integer := null )
  is
    l_len pls_integer;
    l_page pls_integer;
  begin
    if g_pdf.current_page is null
    then
      new_page;
    end if;
    l_page := coalesce( p_page - 1, g_pdf.current_page );
    l_len := utl_raw.length(  p_txt );
    if l_len < 32765
    then
      dbms_lob.writeappend( g_pdf.pages( l_page ).content
                          , l_len + 2
                          , utl_raw.concat( p_txt, hextoraw( '0D0A' ) )
                          );
    else
      dbms_lob.writeappend( g_pdf.pages( l_page ).content
                          , l_len
                          , p_txt
                          );
      dbms_lob.writeappend( g_pdf.pages( l_page ).content
                          , 2
                          , hextoraw( '0D0A' )
                          );
    end if;
  end raw2page;
  --
  procedure txt2page( p_txt varchar2, p_page pls_integer := null )
  is
  begin
    raw2page( utl_raw.cast_to_raw( p_txt ), p_page );
  end txt2page;
  --
  procedure font2page
    ( p_font_index pls_integer := null
    , p_fontsize   number      := null
    )
  is
    l_fontsize   number;
    l_font_index pls_integer := coalesce( p_font_index, g_pdf.current_font );
  begin
    if l_font_index is not null
    then
      l_fontsize := coalesce( p_fontsize, g_pdf.fonts( l_font_index ).fontsize, g_pdf.pages( g_pdf.current_page ).fontsize, c_default_fontsize );
      g_pdf.pages( g_pdf.current_page ).fontsize := l_fontsize;
      g_pdf.pages( g_pdf.current_page ).font_index := l_font_index;
      g_pdf.current_font_index := l_font_index;
      g_pdf.current_font_size := to_char_round( l_fontsize );
      txt2page( 'BT /F' || l_font_index || ' '
              || g_pdf.current_font_size || ' Tf ET'
              );
    end if;
  end font2page;
  --
  procedure font2page_i
    ( p_font_index pls_integer
    , p_fontsize   number
    )
  is
  begin
    if    p_font_index != g_pdf.current_font_index
       or to_char_round( p_fontsize ) != g_pdf.current_font_size
    then
      font2page( p_font_index, p_fontsize );
    elsif p_font_index is null
    then
      font2page( g_pdf.current_font, coalesce( g_pdf.fonts( g_pdf.current_font ).fontsize, g_pdf.pages( g_pdf.current_page ).fontsize, c_default_fontsize ) );
    end if;
  end font2page_i;
  --
  procedure new_page( p_page_size        varchar2 := null
                    , p_page_orientation varchar2 := null
                    , p_page_width       number := null
                    , p_page_height      number := null
                    , p_margin_left      number := null
                    , p_margin_right     number := null
                    , p_margin_top       number := null
                    , p_margin_bottom    number := null
                    , p_unit             varchar2 := null
                    , p_text_direction   varchar2 := null
                    )
  is
    l_new tp_page;
  begin
    l_new.font_index := g_pdf.current_font;
    l_new.fontsize   := case when g_pdf.current_font is not null then g_pdf.fonts( g_pdf.current_font ).fontsize end;
    l_new.color      := g_pdf.color;
    l_new.bk_color   := g_pdf.bk_color;
    set_settings( p_page_size
                , p_page_orientation
                , p_page_width
                , p_page_height
                , p_margin_left
                , p_margin_right
                , p_margin_top
                , p_margin_bottom
                , p_unit
                , p_text_direction
                , l_new.settings
                );
    dbms_lob.createtemporary( l_new.content, true );
    g_pdf.current_page := g_pdf.pages.count;
    g_pdf.pages( g_pdf.current_page ) := l_new;
    font2page( g_pdf.current_font );
    if g_pdf.color is not null or g_pdf.bk_color is not null
    then
      txt2page( ltrim( g_pdf.color || ' ' ) || g_pdf.bk_color );
    end if;
  end new_page;
  --
  procedure raw2pdfdoc( p_raw raw )
  is
  begin
    dbms_lob.writeappend( g_pdf.pdf_blob, utl_raw.length( p_raw ), p_raw );
  end;
--
  procedure txt2pdfdoc( p_txt varchar2 )
  is
  begin
    raw2pdfdoc( utl_i18n.string_to_raw( p_txt || c_eol, 'AL32UTF8' ) );
  end;
  --
  function add_object( p_txt varchar2 := null )
  return number
  is
    l_self number(10);
  begin
    l_self := g_pdf.objects.count;
    g_pdf.objects( l_self ) := dbms_lob.getlength( g_pdf.pdf_blob );
    if p_txt is null
    then
      txt2pdfdoc( l_self || ' 0 obj' );
    else
      txt2pdfdoc( l_self || ' 0 obj' || c_eol || '<<' || p_txt || '>>' || c_eol || 'endobj' );
    end if;
    return l_self;
  end;
  --
  procedure add_object( p_txt varchar2 := null )
  is
    l_dummy number(10) := add_object( p_txt );
  begin
    null;
  end;
  --
  function adler32( p_val blob )
  return varchar2
  is
    s1 pls_integer := 1;
    s2 pls_integer := 0;
    l_val  varchar2(32766);
    l_pos  number := 1;
    l_len  constant integer := dbms_lob.getlength( p_val );
  begin
    loop
      exit when l_pos > l_len;
      l_val := rawtohex( dbms_lob.substr( p_val, 16383, l_pos ) );
      for i in 1 .. length( l_val ) / 2
      loop
        s1 := s1 + g_hex( substr( l_val, i * 2 - 1, 2 ) );
        s2 := s2 + s1;
        if s2 >= 2143305900
        then
          s2 := mod( s2, 65521 );
        end if;
      end loop;
      l_pos := l_pos + 16383;
      s1 := mod( s1, 65521 );
    end loop;
    return to_char( mod( s2, 65521 ), 'fm0XXX' ) || to_char( s1, 'fm0XXX' );
  end adler32;
  --
  function flate_encode( p_val blob )
  return blob
  is
    l_blob blob;
  begin
    l_blob := hextoraw( '789C' );
    dbms_lob.copy( l_blob, utl_compress.lz_compress( p_val ), dbms_lob.lobmaxsize, 3, 11 );
    dbms_lob.trim( l_blob, dbms_lob.getlength( l_blob ) - 8 );
    dbms_lob.writeappend( l_blob, 4, hextoraw( adler32( p_val ) ) );
    return l_blob;
  end flate_encode;
  --
  function encode_utf16_be( p_val varchar2 )
  return varchar2
  is
  begin
    if p_val is null
    then
      return null;
    end if;
    return ' <FEFF' || utl_i18n.string_to_raw( p_val, 'AL16UTF16' ) || '>';
  end encode_utf16_be;
  --
  procedure put_stream
    ( p_stream blob
    , p_object integer
    , p_compress boolean := true
    , p_extra varchar2 := ''
    , p_tag boolean := true
    )
  is
    l_len integer;
    l_blob blob;
    l_compress boolean := false;
  begin
    l_len := nvl( dbms_lob.getlength( p_stream ), 0 );
    if p_compress and l_len > 0
    then
      l_compress := true;
      l_blob := flate_encode( p_stream );
      l_len := nvl( dbms_lob.getlength( l_blob ), 0 );
    end if;
    txt2pdfdoc( case when p_tag then '<<' end
                || case when l_compress then '/Filter /FlateDecode ' end
                || '/Length ' || l_len
                || p_extra
                || '>>'
                || c_eol
                || 'stream'
                );
    if l_compress
    then
      if g_pdf.key is not null
      then
        dbms_lob.append( g_pdf.pdf_blob
                       , encrypt_rc4( l_blob
                                    , hash_md5( utl_raw.concat( g_pdf.key, utl_raw.reverse( substr( to_char( p_object, 'fm0XXXXXXX' ), -6 ) ), '0000' ) )
                                    )
                       );
      else
        dbms_lob.append( g_pdf.pdf_blob, l_blob );
      end if;
    else
      if g_pdf.key is not null
      then
        dbms_lob.append( g_pdf.pdf_blob
                       , encrypt_rc4( p_stream
                                    , hash_md5( utl_raw.concat( g_pdf.key, utl_raw.reverse( substr( to_char( p_object, 'fm0XXXXXXX' ), -6 ) ), '0000' ) )
                                    )
                       );
      else
        dbms_lob.append( g_pdf.pdf_blob, p_stream );
      end if;
    end if;
    txt2pdfdoc( c_eol || 'endstream' );
    if dbms_lob.istemporary( l_blob ) = 1
    then
      dbms_lob.freetemporary( l_blob );
    end if;
  end put_stream;
  --
  function add_stream
    ( p_stream blob
    , p_extra varchar2 := ''
    , p_compress boolean := true
    )
  return number
  is
    l_self number(10);
  begin
    l_self := add_object;
    put_stream( p_stream
              , l_self
              , p_compress
              , p_extra
              );
    txt2pdfdoc( 'endobj' );
    return l_self;
  end add_stream;
  --
  function add_image( p_img tp_img )
  return number
  is
    l_self   number(10);
    l_pallet number(10);
    l_smask  number(10);
  begin
    if p_img.color_tab is not null
    then
      l_pallet := add_stream( p_img.color_tab );
    end if;
    if p_img.smask is not null
    then
      l_smask := add_object;
      txt2pdfdoc( '<</Type/XObject/Subtype/Image/Width ' || to_char( p_img.width )|| '/Height ' || to_char( p_img.height ) || '/ColorSpace/DeviceGray/BitsPerComponent 8/Interpolate false' );
      put_stream( p_img.smask, l_smask, p_tag => false );
      txt2pdfdoc( 'endobj' );
    end if;
--
    l_self := add_object;
    txt2pdfdoc( '<</Type/XObject/Subtype/Image'
              ||  '/Width ' || to_char( p_img.width )
              || '/Height ' || to_char( p_img.height )
              || '/BitsPerComponent ' || to_char( p_img.color_res )
              );
--
    if p_img.transparancy is not null
    then
      txt2pdfdoc( '/Mask [' || p_img.transparancy || ' ' || p_img.transparancy || ']' );
    elsif l_smask is not null
    then
      txt2pdfdoc( '/SMask ' || l_smask || ' 0 R' );
    end if;
    if p_img.color_tab is null
    then
      if p_img.greyscale
      then
        txt2pdfdoc( '/ColorSpace /DeviceGray' );
      else
        txt2pdfdoc( '/ColorSpace /DeviceRGB' );
      end if;
    else
      txt2pdfdoc(    '/ColorSpace [/Indexed /DeviceRGB '
                || to_char( utl_raw.length( p_img.color_tab ) / 3 - 1 )
                || ' ' || to_char( l_pallet ) || ' 0 R]'
                );
    end if;
    --
    if p_img.type = 'jpg'
    then
      put_stream( p_img.pixels, l_self, false, '/Filter /DCTDecode', false );
    elsif p_img.type = 'png'
    then
      put_stream( p_img.pixels, l_self, false
                ,  '/Interpolate false/Filter/FlateDecode/DecodeParms <</Predictor 15'
                || '/Colors ' || p_img.nr_colors
                || '/BitsPerComponent ' || p_img.color_res
                || '/Columns ' || p_img.width
                || '>> '
                , false );
    else
      put_stream( p_img.pixels, l_self, p_tag => false );
    end if;
    txt2pdfdoc( 'endobj' );
    return l_self;
  end add_image;
  --
  function rgb( p_hex varchar2 )
  return varchar2
  is
  begin
    return to_char_round( nvl( g_hex( substr( p_hex, 1, 2 ) ) / 255
                             , 0 ), 5 ) || ' '
        || to_char_round( nvl( g_hex( substr( p_hex, 3, 2 ) ) / 255
                             , 0 ), 5 ) || ' '
        || to_char_round( nvl( g_hex( substr( p_hex, 5, 2 ) ) / 255
                             , 0 ), 5 ) || ' ';
  end rgb;
  --
  function rgb( p_color varchar2 )
  return varchar2
  is
  begin
    if g_color_names.exists( lower( p_color ) )
    then
      return rgb( p_hex => upper( g_color_names( lower( p_color ) ) ) );
    else
      return rgb( p_hex => upper( ltrim( p_color, '#' ) ) );
    end if;
  exception
    when value_error then
      return rgb( p_hex => '000000' );
  end rgb;
  --
  procedure set_color( p_rgb varchar2, p_backgr boolean )
  is
  begin
    if p_backgr
    then
      g_pdf.bk_color := rgb( p_color => p_rgb ) || 'RG ';
      txt2page( g_pdf.bk_color );
    else
      g_pdf.color := rgb( p_color => p_rgb ) || 'rg ';
      txt2page( g_pdf.color );
    end if;
  end set_color;
  --
  procedure set_color
    ( p_red    number
    , p_green  number
    , p_blue   number
    , p_backgr boolean
    )
  is
  begin
    if (     p_red between 0 and 255
       and p_blue  between 0 and 255
       and p_green between 0 and 255
       )
    then
      set_color(  to_char( p_red, 'fm0x' )
               || to_char( p_green, 'fm0x' )
               || to_char( p_blue, 'fm0x' )
               , p_backgr
               );
    end if;
  end set_color;
  --
  procedure set_color( p_rgb varchar2 := '000000' )
  is
  begin
    set_color( p_rgb, false);
  end set_color;
--
  procedure set_color
    ( p_red   number := 0
    , p_green number := 0
    , p_blue  number := 0
    )
  is
  begin
    set_color( p_red, p_green, p_blue, false );
  end set_color;
  --
  procedure set_bk_color( p_rgb varchar2 := 'ffffff' )
  is
  begin
    set_color( p_rgb, true );
  end set_bk_color;
--
  procedure set_bk_color
    ( p_red   number := 255
    , p_green number := 255
    , p_blue  number := 255
    )
  is
  begin
    set_color( p_red, p_green, p_blue, true );
  end set_bk_color;
  --
  function uint16( p_val varchar2 )
  return pls_integer
  is
  begin
    return to_number( p_val, 'XXXX' );
  end uint16;
  --
  function int16( p_val varchar2 )
  return pls_integer
  is
    pragma inline( uint16, 'YES' );
    l_uint constant pls_integer := uint16( p_val );
  begin
    return l_uint - case when l_uint > 32767 then 65536 else 0 end;
  end int16;
  --
  function subset_font( p_index pls_integer )
  return blob
  is
    l_subset  blob;
    l_fmt     varchar2(16);
    l_tmp     varchar2(32767);
    l_buf     varchar2(32767);
    l_header  varchar2(32767);
    l_sz      pls_integer;
    l_cnt     pls_integer;
    l_idx     pls_integer;
    l_len     pls_integer;
    l_mod     pls_integer;
    l_tags    pls_integer;
    l_loca_s  pls_integer;
    l_loca_e  pls_integer;
    l_font    tp_font;
    l_loca    tp_pls_tab;
    l_pos     integer;
    l_offset  integer;
    --
  procedure cff( p_cff blob, p_offset integer := 1 )
    is
    -- https://adobe-type-tools.github.io/font-tech-notes/pdfs/5176.CFF.pdf
      l_buf          varchar2(32767);
      l_name         varchar2(32767);
      l_offs         integer;
      l_sz           pls_integer;
      l_to_do        pls_integer;
      l_offs_sz      pls_integer;
      l_name_idx     pls_integer;
      l_subr_bias    pls_integer;
      l_gsubr_bias   pls_integer;
      l_new2old      tp_pls_tab;
      l_glyph2cid    tp_pls_tab;
      l_glyph2font   tp_pls_tab;
      l_used_subrs   tp_pls_tab;
      l_used_gsubrs  tp_pls_tab;
      l_used_strings tp_pls_tab;
      --
      type tp_dict_entry is record
        ( operator raw(2)
        , operand1 integer
        , operand2 integer
        , operand3 integer
        , entry    raw(100)
        );
      type tp_dict_entries is table of tp_dict_entry index by varchar2(4);
      type tp_dict is record
        ( cnt       pls_integer
        , offs      integer
        , data_end  integer
        , arr_start tp_pls_tab
        , arr_len   tp_pls_tab
        );
      l_names       tp_dict;
      l_topdict     tp_dict;
      l_strings     tp_dict;
      l_gsubrs      tp_dict;
      l_priv_subrs  tp_dict;
      l_charstrings tp_dict;
      l_fd_array    tp_dict;
      l_top_data    tp_dict_entries;
      l_font_dict   tp_dict_entries;
      l_priv_dict   tp_dict_entries;
      --
      type tp_operators is table of varchar2(4);
      l_SID_operators constant tp_operators :=
        tp_operators( '00'   -- version
                    , '01'   -- Notice
                    , '02'   -- FullName
                    , '03'   -- FamilyName
                    , '04'   -- Weight
                    , '0C00' -- Copyright
                    , '0C15' -- PostScript
                    , '0C16' -- BaseFontName
                    , '0C26' -- FD FontName
                    );
      --
      function parse_dict( p_offs integer )
      return tp_dict
      is
        l_dict    tp_dict;
        l_offs    integer;
        l_sz      pls_integer;
        l_cur     pls_integer;
        l_idx     pls_integer;
        l_prev    pls_integer;
        l_to_do   pls_integer;
        l_offs_sz pls_integer;
        l_fmt     constant varchar2(8) := 'XXXXXXXX';
      begin
        l_buf := dbms_lob.substr( p_cff, 3, p_offs );
        l_dict.cnt := to_number( substr( l_buf, 1, 4 ), 'XXXX' );
        if l_dict.cnt = 0
        then
          l_dict.data_end := p_offs + 2;
          return l_dict;
        end if;
        l_offs_sz := g_hex( substr( l_buf, 5, 2 ) );
        l_to_do := l_dict.cnt;
        l_offs := p_offs + 3 + l_offs_sz;
        l_sz := 16000 / l_offs_sz;
        l_prev := 1;
        l_dict.arr_start( 1 ) := 1;
        for i in 0 .. 1000
        loop
          exit when l_to_do < 1;
          l_buf := dbms_lob.substr( p_cff, least( l_sz, l_to_do ) * l_offs_sz, l_offs );
          for j in 0 .. length( l_buf ) / ( 2 * l_offs_sz ) - 1
          loop
            l_idx := i * l_sz + j + 1;
            l_cur := to_number( substr( l_buf, 1 + j * 2 * l_offs_sz, 2 * l_offs_sz ), l_fmt );
            l_dict.arr_start( l_idx + 1 ) := l_cur;
            l_dict.arr_len( l_idx ) := l_cur - l_prev;
            l_prev := l_cur;
          end loop;
          l_offs := l_offs + l_sz * l_offs_sz;
          l_to_do := l_to_do - l_sz;
        end loop;
        l_dict.offs := p_offs + 2 + ( l_dict.cnt + 1 ) * l_offs_sz;
        l_dict.data_end := l_dict.offs + l_dict.arr_start( l_dict.cnt + 1 );
        l_dict.arr_start.delete( l_dict.cnt + 1 );
        return l_dict;
      end parse_dict;
      --
      function parse_dict_data( p_offs integer, p_len pls_integer )
      return tp_dict_entries
      is
        l_cnt        pls_integer;
        l_len        pls_integer;
        l_pos        pls_integer;
        l_start      pls_integer;
        l_real       varchar2(100);
        l_buf        varchar2(32767);
        l_operand    number;
        l_entries    tp_dict_entries;
        l_entry      tp_dict_entry;
        l_null_entry tp_dict_entry;
      begin
        if coalesce( p_len, 0 ) = 0 or coalesce( p_offs, 0 ) = 0
        then
          return l_entries;
        end if;
        l_buf := dbms_lob.substr( p_cff, p_len, p_offs );
        l_cnt := 0;
        l_pos := 1;
        l_start := l_pos;
        l_len := length( l_buf );
        loop
          exit when l_pos > l_len;
          l_operand := g_hex( substr( l_buf, l_pos, 2 ) );
          exit when l_operand is null;
          if l_operand between 32 and 246
          then
            l_operand := l_operand - 139;
          elsif l_operand between 247 and 250
          then
            l_operand := ( l_operand - 247 ) * 256 + 108 + g_hex( substr( l_buf, l_pos + 2, 2 ) );
            l_pos := l_pos + 2;
          elsif l_operand between 251 and 254
          then
            l_operand := - ( l_operand - 251 ) * 256 - 108 - g_hex( substr( l_buf, l_pos + 2, 2 ) );
            l_pos := l_pos + 2;
          elsif l_operand = 28
          then
            l_operand := to_number( substr( l_buf, l_pos + 2, 4 ), 'XXXX' );
            l_pos := l_pos + 4;
            if l_operand > 32767
            then
              l_operand := l_operand - 65536;
            end if;
          elsif l_operand = 29
          then
            l_operand := to_number( substr( l_buf, l_pos + 2, 8 ), 'XXXXXXXX' );
            l_pos := l_pos + 8;
            if l_operand > 2147483647
            then
              l_operand := l_operand - 4294967296;
            end if;
          elsif l_operand = 30
          then
            l_real := null;
            loop
              case substr( l_buf, l_pos + 2, 1 )
                when 'F' then exit;
                when 'A' then l_real := l_real || '.';
                when 'B' then l_real := l_real || 'E';
                when 'C' then l_real := l_real || 'E-';
                when 'E' then l_real := '-' || l_real;
                when 'D' then null;
                else l_real := l_real || substr( l_buf, l_pos + 2, 1 );
              end case;
              l_pos := l_pos + 1;
              exit when l_pos > l_len;
            end loop;
            if bitand( l_pos, 1 ) = 0
            then
              l_pos := l_pos + 1;
            end if;
            declare
              l_mantisse number;
              l_mant     varchar2(100);
              l_pos_e    constant pls_integer := instr( l_real, 'E' );
            begin
              if l_pos_e > 0
              then
                l_mant := substr( l_real, 1, l_pos_e - 1 );
                l_mantisse := to_number( l_mant, translate( l_mant, '012345678-', '999999999' ), 'NLS_NUMERIC_CHARACTERS=''.,''' );
                if abs( l_mantisse ) >= 10
                then
                  l_operand := l_mantisse * power( 10, to_number( substr( l_real, l_pos_e + 1 ) ) );
                else
                  l_operand := to_number( l_real, translate( substr( l_real, 1, l_pos_e - 1 ), '012345678-', '999999999' ) || 'EEEE', 'NLS_NUMERIC_CHARACTERS=''.,''' );
                end if;
              else
                l_operand := to_number( l_real, translate( l_real, '012345678-', '999999999' ), 'NLS_NUMERIC_CHARACTERS=''.,''' );
              end if;
            exception
              when value_error then
                l_operand := 0;
            end;
          else
            if l_operand = 12
            then
              l_pos := l_pos + 2;
              l_entry.operator := hextoraw( '0C' || substr( l_buf, l_pos, 2 ) );
            else
              l_entry.operator := hextoraw( substr( l_buf, l_pos, 2 ) );
            end if;
            l_cnt := 0;
            l_operand := null;
            l_entry.entry := hextoraw( substr( l_buf, l_start, l_pos + 2 - l_start ) );
            l_entries( rawtohex( l_entry.operator ) ) := l_entry;
            l_start := l_pos + 2;
            l_entry := l_null_entry;
          end if;
          l_pos := l_pos + 2;
          if l_operand is not null
          then
            l_cnt := l_cnt + 1;
            case l_cnt
              when 1 then l_entry.operand1 := l_operand;
              when 2 then l_entry.operand2 := l_operand;
              when 3 then l_entry.operand3 := l_operand;
              else null;
            end case;
          end if;
        end loop;
        return l_entries;
      end parse_dict_data;
      --
      procedure parse_type2( p_offs integer, p_len pls_integer )
      is
        l_sz       constant pls_integer := 16000;
        l_lastn    number;
        l_stems    pls_integer := 0;
        l_stack_sz pls_integer := 0;
        --
        procedure parse_type2_int( p_offs integer, p_len pls_integer )
        is
          l_offs  integer;
          l_op    number;
          l_dummy number;
          l_idx   pls_integer;
          l_len   pls_integer;
          l_pos   pls_integer;
          l_buf   varchar2(32767);
          --
          function get_byte
          return pls_integer
          is
            l_x   pls_integer;
            l_tmp pls_integer;
            l_hex varchar2(2);
          begin
            l_hex := substr( l_buf, l_pos, 2 );
            if l_hex is null
            then
              l_tmp := least( l_sz, l_len );
              if l_tmp < 1
              then
                return to_number( null );
              end if;
              l_buf := dbms_lob.substr( p_cff, l_tmp, l_offs );
              l_len := l_len - l_tmp;
              l_offs := l_offs + l_tmp;
              l_pos := 1;
              l_hex := substr( l_buf, 1, 2 );
            end if;
            l_x := g_hex( l_hex );
            l_pos := l_pos + 2;
            return l_x;
          end get_byte;
          --
        begin
          l_pos := 1;
          l_len := p_len;
          l_offs := p_offs;
          loop
            l_op := get_byte;
            exit when l_op is null;
            if l_op between 32 and 255 or l_op = 28
            then
              if l_op between 32 and 246
              then
                l_op := l_op - 139;
              elsif l_op between 247 and 250
              then
                l_op := ( l_op - 247 ) * 256 + 108 + get_byte;
                exit when l_op is null;
              elsif l_op between 251 and 254
              then
                l_op := - ( l_op - 251 ) * 256 - 108 - get_byte;
                exit when l_op is null;
              elsif l_op = 28
              then
                l_op := get_byte * 256 + get_byte;
                exit when l_op is null;
                if l_op > 32767
                then
                  l_op := l_op - 65536;
                end if;
              elsif l_op = 255
              then
                l_op := ( get_byte * 256 + get_byte ) * 256 + get_byte;
                l_op := l_op * 256 + get_byte;
                exit when l_op is null;
                if l_op > 2147483647
                then
                  l_op := l_op - 4294967296;
                end if;
                l_op := l_op / 65536;
              end if;
              l_lastn := l_op;
              l_stack_sz := l_stack_sz + 1;
            elsif l_op = 11 -- return
            then
              exit;
            elsif l_op = 14 -- endchar
            then
              l_stack_sz := 0;
              exit;
            elsif l_op in ( 4  -- vmoveto
                          , 15 -- vsindex
                          , 22 -- hmoveto
                          )
            then
              l_lastn := null;
              l_stack_sz := l_stack_sz - 1;
            elsif l_op = 21 -- rmoveto
            then
              l_lastn := null;
              l_stack_sz := l_stack_sz - 2;
            elsif l_op in ( 5  -- rlineto
                          , 6  -- hlineto
                          , 7  -- vlineto
                          , 8  -- rrcurveto
                          , 16 -- blend
                          , 24 -- rcurveline
                          , 25 -- rlinecurve
                          , 26 -- vvcurveto
                          , 27 -- hhcurveto
                          , 30 -- vhcurveto
                          , 31 -- hvcurveto
                          )
            then
              l_lastn := null;
              l_stack_sz := 0;
            elsif l_op in ( 1  -- hstem
                          , 3  -- vstem
                          , 18 -- hstemhm
                          , 23 -- vstemhm
                          )
            then
              l_stems := l_stems + trunc( l_stack_sz / 2 );
              l_lastn := null;
              l_stack_sz := 0;
            elsif l_op in ( 19 -- hintmask
                          , 20 -- cntrmask
                          )
            then
              l_stems := l_stems + trunc( l_stack_sz / 2 );
              l_lastn := null;
              l_stack_sz := 0;
              for s in 1 .. trunc( ( l_stems + 7 ) / 8 )
              loop
                l_dummy := get_byte;
              end loop;
            elsif l_op = 10 -- callsubr
            then
              l_stack_sz := l_stack_sz - 1;
              l_idx := l_subr_bias + l_lastn + 1;
              l_lastn := null;
              parse_type2_int( l_priv_subrs.offs + l_priv_subrs.arr_start( l_idx ), l_priv_subrs.arr_len( l_idx ) );
              l_used_subrs( l_idx ) := 0;
            elsif l_op = 29 -- callgsubr
            then
              l_stack_sz := l_stack_sz - 1;
              l_idx := l_gsubr_bias + l_lastn + 1;
              l_lastn := null;
              parse_type2_int( l_gsubrs.offs + l_gsubrs.arr_start( l_idx ), l_gsubrs.arr_len( l_idx ) );
              l_used_gsubrs( l_idx ) := 0;
            elsif l_op = 12 -- escape
            then
              l_op := get_byte;
              l_lastn := null;
              exit when l_op is null;
              if l_op in ( 3  -- and
                         , 4  -- or
                         , 10 -- add
                         , 11 -- sub
                         , 12 -- div
                         , 15 -- eq
                         , 18 -- drop
                         , 24 -- mul
                         )
              then
                l_stack_sz := l_stack_sz - 1;
              elsif l_op in ( 5  -- not
                            , 9  -- abs
                            , 14 -- neg
                            , 21 -- get
                            , 26 -- sqrt
                            , 28 -- exch
                            , 29 -- index
                            )
              then
                null;
              elsif l_op = 22 -- ifelse
              then
                l_stack_sz := l_stack_sz - 3;
              elsif l_op in ( 20 -- put
                            , 30 -- roll
                            )
              then
                l_stack_sz := l_stack_sz - 2;
              elsif l_op = 27 -- dup
              then
                l_stack_sz := l_stack_sz + 1;
              elsif l_op = 34 -- hflex
              then
                l_stack_sz := l_stack_sz - 7;
              elsif l_op = 35 -- flex
              then
                l_stack_sz := l_stack_sz - 13;
              elsif l_op = 36 -- hflex1
              then
                l_stack_sz := l_stack_sz - 9;
              elsif l_op = 37 -- flex1
              then
                l_stack_sz := l_stack_sz - 11;
              else
                raise_application_error( -20063, 'Unexpected operator ' || to_char( l_op, '0X' ) || ' in CFF font file ' || l_name );
              end if;
            else
              raise_application_error( -20064, 'Unexpected operator ' || to_char( l_op, '0X' ) || ' in CFF font file ' || l_name );
            end if;
          end loop;
        end parse_type2_int;
        --
      begin
        parse_type2_int( p_offs, p_len );
      end parse_type2;
      --
      function get_cff_value( p_dict tp_dict, p_idx pls_integer )
      return raw
      is
      begin
        return dbms_lob.substr( p_cff, p_dict.arr_len( p_idx ), p_dict.offs + p_dict.arr_start( p_idx ) );
      end get_cff_value;
      --
      function get_cff_string( p_idx pls_integer )
      return varchar2
      is
      begin
        return utl_raw.cast_to_varchar2( get_cff_value( l_strings, p_idx ) );
      end get_cff_string;
      --
      procedure mark_used_strings( p_dict tp_dict_entries )
      is
        procedure mark( p_sid pls_integer, p_operator varchar2 )
        is
          l_sid pls_integer := p_sid;
        begin
          if l_sid > 389
          then
            l_sid := l_sid - 390;
            l_used_strings( l_sid ) := 0;
          end if;
        end;
      begin
        for i in l_SID_operators.first .. l_SID_operators.last
        loop
          if p_dict.exists( l_SID_operators( i ) )
          then
            mark( p_dict( l_SID_operators( i ) ).operand1, l_SID_operators( i ) );
          end if;
        end loop;
        if p_dict.exists( '0C1E' ) -- ROS
        then
          mark( p_dict( '0C1E' ).operand1, '0C1E ROS 1' );
          mark( p_dict( '0C1E' ).operand2, '0C1E ROS 2' );
        end if;
      end mark_used_strings;
      --
      function needed_length( p_len pls_integer, p_count pls_integer )
      return pls_integer
      is
      begin
        return case
                 when p_len <= 254      then p_count + 1
                 when p_len <= 65534    then 2 * ( p_count + 1 )
                 when p_len <= 16777214 then 3 * ( p_count + 1 )
                 else 4 * ( p_count + 1 )
               end + 3 + p_len;
      end needed_length;
      --
      function needed_length( p_dict tp_dict, p_used tp_pls_tab, p_zero boolean, p_plus pls_integer := 0 )
      return pls_integer
      is
        l_idx pls_integer;
        l_len pls_integer;
      begin
        if p_used.count = 0
        then
          return 2;
        end if;
        l_len := 0;
        l_idx := p_used.first;
        loop
          exit when l_idx is null;
          if p_plus > 0
          then
            l_len := l_len + p_dict.arr_len( p_used( l_idx ) + 1 );
          else
            l_len := l_len + p_dict.arr_len( l_idx );
          end if;
          l_idx := p_used.next( l_idx );
        end loop;
        if p_zero
        then -- set length of unused entries to zero
          l_len := needed_length( l_len, p_dict.cnt );
        else
          l_len := needed_length( l_len, p_used.count );
        end if;
        return l_len;
      end needed_length;
      --
      procedure copy_dict( p_dict tp_dict, p_used tp_pls_tab, p_zero boolean, p_plus pls_integer := 0 )
      is
        l_x     pls_integer;
        l_sz    pls_integer;
        l_idx   pls_integer;
        l_len   pls_integer;
        l_start pls_integer;
        l_fmt   varchar2(10);
        l_buf   varchar2(32767);
      begin
        if p_used.count = 0
        then
          dbms_lob.writeappend( l_subset, 2, hextoraw( '0000' ) );
        else
          l_len := 0;
          l_idx := p_used.first;
          loop
            exit when l_idx is null;
            if p_plus > 0
            then
              l_len := l_len + p_dict.arr_len( p_used( l_idx ) + 1 );
            else
              l_len := l_len + p_dict.arr_len( l_idx + p_plus );
            end if;
            l_idx := p_used.next( l_idx );
          end loop;
          l_sz := case
                    when l_len <= 254      then 1
                    when l_len <= 65534    then 2
                    when l_len <= 16777214 then 3
                    else 4
                  end;
          l_fmt := rpad( 'fm0', 2 + 2 * l_sz, 'X' );
          if p_zero
          then -- set length of unused entries to zero
            l_buf := to_char( p_dict.cnt, 'fm0XXX' );
          else
            l_buf := to_char( p_used.count, 'fm0XXX' );
          end if;
          l_buf := l_buf || to_char( l_sz, 'fm0X' );
          l_buf := l_buf || to_char( 1, l_fmt );
          l_len := 3 + l_sz;
          l_start := 1;
          if p_zero
          then -- set length of unused entries to zero
            for i in 1 .. p_dict.cnt
            loop
              if p_used.exists( i )
              then
                l_start := l_start + p_dict.arr_len( i );
              end if;
              l_buf := l_buf || to_char( l_start, l_fmt );
              l_len := l_len + l_sz;
              if l_len > 16380
              then
                dbms_lob.writeappend( l_subset, l_len, hextoraw( l_buf ) );
                l_len := 0;
                l_buf := null;
              end if;
            end loop;
            if l_len > 0
            then
              dbms_lob.writeappend( l_subset, l_len, hextoraw( l_buf ) );
              l_len := 0;
              l_buf := null;
            end if;
            for i in 1 .. p_dict.cnt
            loop
              if p_used.exists( i )
              then
                if l_len + p_dict.arr_len( i ) > 16380
                then
                  dbms_lob.writeappend( l_subset, l_len, hextoraw( l_buf ) );
                  l_len := 0;
                  l_buf := null;
                end if;
                l_len := l_len + p_dict.arr_len( i );
                l_buf := l_buf || rawtohex( dbms_lob.substr( p_cff, p_dict.arr_len( i ), p_dict.offs + p_dict.arr_start( i ) ) );
              end if;
            end loop;
          else
            l_idx := p_used.first;
            loop
              exit when l_idx is null;
              if p_plus > 0
              then
                l_start := l_start + p_dict.arr_len( p_used( l_idx ) + 1 );
              else
                l_start := l_start + p_dict.arr_len( l_idx );
              end if;
              l_buf := l_buf || to_char( l_start, l_fmt );
              l_len := l_len + l_sz;
              if l_len > 16380
              then
                dbms_lob.writeappend( l_subset, l_len, hextoraw( l_buf ) );
                l_len := 0;
                l_buf := null;
              end if;
              l_idx := p_used.next( l_idx );
            end loop;
            if l_len > 0
            then
              dbms_lob.writeappend( l_subset, l_len, hextoraw( l_buf ) );
              l_len := 0;
              l_buf := null;
            end if;
            l_idx := p_used.first;
            loop
              exit when l_idx is null;
              if p_plus > 0
              then
                l_x := p_used( l_idx ) + 1;
              else
                l_x := l_idx;
              end if;
              if l_len + p_dict.arr_len( l_x ) > 16380
              then
                dbms_lob.writeappend( l_subset, l_len, hextoraw( l_buf ) );
                l_len := 0;
                l_buf := null;
              end if;
              l_len := l_len + p_dict.arr_len( l_x );
              l_buf := l_buf || rawtohex( dbms_lob.substr( p_cff, p_dict.arr_len( l_x ), p_dict.offs + p_dict.arr_start( l_x ) ) );
              l_idx := p_used.next( l_idx );
            end loop;
          end if;
          if l_len > 0
          then
            dbms_lob.writeappend( l_subset, l_len, hextoraw( l_buf ) );
          end if;
        end if;
      end copy_dict;
      --
      function get_bias( p_cnt pls_integer )
      return pls_integer
      is
      begin
        return case
                 when l_top_data.exists( '0C06' )
                  and l_top_data( '0C06' ).operand1 = 1 then 0
                 when p_cnt < 1240                  then 107
                 when p_cnt < 33900                 then 1131
                 else 32768
               end;
      end get_bias;
      --
      procedure cid2subset_cid
      is
        l_entry      raw(4);
        l_tmp        raw(32767);
        l_buf        varchar2(32767);
        l_offs       integer;
        l_len        pls_integer;
        l_old        pls_integer;
        l_fd_idx     pls_integer;
        l_pds_len    pls_integer;
        l_priv_d_sz  pls_integer;
        l_new_fd_idx pls_integer;
        l_used_fds   tp_pls_tab;
        l_pds_offset tp_pls_tab;
        l_all_used   tp_matrix;
      begin
        l_fd_array := parse_dict( p_offset + l_top_data( '0C24' ).operand1 );
        l_offs := p_offset + l_top_data( '0C25' ).operand1;
        l_buf := dbms_lob.substr( p_cff, 3, l_offs );
        if substr( l_buf, 1, 2 ) = '00'
        then
          l_sz := 16000;
          l_offs := l_offs + 1;
          l_to_do := l_charstrings.cnt;
          for i in 0 .. 10
          loop
            exit when l_to_do < 1;
            l_buf := dbms_lob.substr( p_cff, least( l_to_do, l_sz ), l_offs );
            for j in 1 .. least( l_to_do, l_sz )
            loop
              l_glyph2font( j - 1 + i * l_sz ) := g_hex( substr( l_buf, 2 * j - 1, 2 ) );
            end loop;
            l_offs := l_offs + l_sz;
            l_to_do := l_to_do - l_sz;
          end loop;
        elsif substr( l_buf, 1, 2 ) = '03'
        then
          l_sz := 5400;
          l_offs := l_offs + 3;
          l_to_do := to_number( substr( l_buf, 3 ), 'XXXX' );
          declare
            l_fd    pls_integer;
            l_last  pls_integer;
            l_first pls_integer;
          begin
            for i in 0 .. 100
            loop
              exit when l_to_do < 1;
              l_buf := dbms_lob.substr( p_cff, 3 * least( l_to_do, l_sz ), l_offs );
              for j in 0 .. least( l_to_do, l_sz ) - 1
              loop
                l_last := to_number( substr( l_buf, 1 + j * 6, 4 ), 'XXXX' );
                for g in coalesce( l_first, l_last ) .. l_last - 1
                loop
                  l_glyph2font( g ) := l_fd;
                end loop;
                l_first := l_last;
                l_fd    := g_hex( substr( l_buf, 5 + j * 6, 2 ) );
              end loop;
              l_offs := l_offs + 3 * l_sz;
              l_to_do := l_to_do - l_sz;
            end loop;
            for g in coalesce( l_first, l_charstrings.cnt ) .. l_charstrings.cnt - 1
            loop
              l_glyph2font( g ) := l_fd;
            end loop;
          end;
        else
          raise_application_error( -20062, 'Unexpected value in CFF font file' || l_name );
        end if;
        --
        l_new2old( 0 ) := 0;
        for i in 0 .. l_new2old.count - 1
        loop
          if not l_used_fds.exists( l_glyph2font( l_new2old( i ) ) )
          then
            l_new_fd_idx := l_used_fds.count;
            l_used_fds( l_glyph2font( l_new2old( i ) ) ) := l_new_fd_idx;
          end if;
        end loop;
        l_pds_len := 0;
        l_fd_idx := l_used_fds.first;
        loop
          exit when l_fd_idx is null;
          l_font_dict := parse_dict_data( l_fd_array.offs + l_fd_array.arr_start( l_fd_idx + 1 ), l_fd_array.arr_len( l_fd_idx + 1 ) );
          mark_used_strings( l_font_dict );
          if l_font_dict.exists( '12' ) and l_font_dict( '12' ).operand1 > 0
          then
            l_pds_offset( l_fd_idx ) := l_pds_len;
            l_pds_len := l_pds_len + l_font_dict( '12' ).operand1;
            l_priv_dict := parse_dict_data( p_offset + l_font_dict( '12' ).operand2, l_font_dict( '12' ).operand1 );
            --
            if l_priv_dict.exists( '13' )
            then
              l_priv_subrs := parse_dict( p_offset + l_font_dict( '12' ).operand2 + l_priv_dict( '13' ).operand1 );
              l_subr_bias := get_bias( l_priv_subrs.cnt );
              l_pds_len := l_pds_len + 2 - utl_raw.length( l_priv_dict( '13' ).entry );
            end if;
          end if;
          l_used_subrs.delete;
          for i in 0 .. l_new2old.count - 1
          loop
            l_old := l_new2old( i );
            if l_glyph2font( l_old ) = l_fd_idx
            then
              parse_type2( l_charstrings.offs + l_charstrings.arr_start( l_old + 1 ), l_charstrings.arr_len( l_old + 1 ) );
            end if;
          end loop;
          if l_priv_dict.exists( '13' )
          then
            l_pds_len := l_pds_len + needed_length( l_priv_subrs, l_used_subrs, true );
            l_all_used( l_fd_idx ) := l_used_subrs;
          end if;
          l_fd_idx := l_used_fds.next( l_fd_idx );
        end loop;
        mark_used_strings( l_top_data );
        --
        l_tmp := l_top_data( '0C1E' ).entry;  -- ROS
        l_entry := l_top_data.first;
        loop
          exit when l_entry is null;
          if l_entry not in ( '0F'   -- charset
                            , '10'   -- Encoding
                            , '11'   -- CharStrings
                            , '0C1E' -- ROS
                            , '0C24' -- FDArray
                            , '0C25' -- FDSelect
                            , '0C22' -- CIDCount
                            )
          then
            l_tmp := utl_raw.concat( l_tmp, l_top_data( l_entry ).entry );
          end if;
          l_entry := l_top_data.next( l_entry );
        end loop;
        l_tmp := utl_raw.concat( l_tmp, hextoraw( '1D' || to_char( l_new2old.count, 'fm0XXXXXXX' ) || '0C22' ) ); -- CIDCount
        l_offs := 4 + needed_length( l_names.arr_len( l_name_idx ), 1 )  -- header + names
                    + needed_length( utl_raw.length( l_tmp ) + 26, 1 )   -- topdict
                    + needed_length( l_strings, l_used_strings, true )   -- strings
                    + needed_length( l_gsubrs, l_used_gsubrs, true );    -- gsubrs
        l_tmp := utl_raw.concat( l_tmp, hextoraw( '1D' || to_char( l_offs, 'fm0XXXXXXX' ) || '0F' ) ); -- charset
        l_offs := l_offs + 5; -- charset type 2, charstring/numGlyphs <  65536
        l_tmp := utl_raw.concat( l_tmp, hextoraw( '1D' || to_char( l_offs, 'fm0XXXXXXX' ) || '11' ) );   -- CharStrings
        l_offs := l_offs + needed_length( l_charstrings, l_new2old, false, 1 );                          -- CharStrings
        l_tmp := utl_raw.concat( l_tmp, hextoraw( '1D' || to_char( l_offs, 'fm0XXXXXXX' ) || '0C25' ) ); -- FDSelect
        l_offs := l_offs + 1 + l_new2old.count;                                                          -- FDSelect type 0
        l_tmp := utl_raw.concat( l_tmp, hextoraw( '1D' || to_char( l_offs + l_pds_len, 'fm0XXXXXXX' ) || '0C24' ) ); -- FDArray
        l_len := utl_raw.length( l_tmp );
        if l_len > 254
        then
          dbms_lob.writeappend( l_subset
                              , l_len + 7
                              , utl_raw.concat( hextoraw( '0001020001' )
                                              , hextoraw( to_char( l_len + 1, 'fm0XXX' ) )
                                              , l_tmp
                                              )
                              );
        else
          dbms_lob.writeappend( l_subset
                              , l_len + 5
                              , utl_raw.concat( hextoraw( '00010101' )
                                              , hextoraw( to_char( l_len + 1, 'fm0X' ) )
                                              , l_tmp
                                              )
                              );
        end if;
        copy_dict( l_strings, l_used_strings, true );
        copy_dict( l_gsubrs, l_used_gsubrs, true );
        if l_new2old.count > 1
        then
          dbms_lob.writeappend( l_subset, 5, hextoraw( '020001' || to_char( l_new2old.count - 2, 'fm0XXX' ) ) );
          copy_dict( l_charstrings, l_new2old, false, 1 );
        end if;
        -- FDSelect
        l_buf := '00';
        for i in 0 .. l_new2old.count - 1
        loop
          l_buf := l_buf || to_char( l_used_fds( l_glyph2font( l_new2old( i ) ) ), 'fm0X' );
          if length( l_buf ) > 16000
          then
            dbms_lob.writeappend( l_subset, 2 * length( l_buf ), hextoraw( l_buf ) );
            l_buf := null;
          end if;
        end loop;
        if length( l_buf ) > 0
        then
          dbms_lob.writeappend( l_subset, 0.5 * length( l_buf ), hextoraw( l_buf ) );
        end if;
        -- Private Font Dicts
        l_fd_idx := l_used_fds.first;
        loop
          exit when l_fd_idx is null;
          l_font_dict := parse_dict_data( l_fd_array.offs + l_fd_array.arr_start( l_fd_idx + 1 ), l_fd_array.arr_len( l_fd_idx + 1 ) );
          if l_font_dict.exists( '12' ) and l_font_dict( '12' ).operand1 > 0
          then
            l_priv_dict := parse_dict_data( p_offset + l_font_dict( '12' ).operand2, l_font_dict( '12' ).operand1 );
            l_len := 0;
            l_buf := null;
            l_entry := l_priv_dict.first;
            loop
              exit when l_entry is null;
              if l_entry != '13'
              then
                l_len := l_len + utl_raw.length( l_priv_dict( l_entry ).entry );
                l_buf := l_buf || rawtohex( l_priv_dict( l_entry ).entry );
              end if;
              l_entry := l_priv_dict.next( l_entry );
            end loop;
            dbms_lob.writeappend( l_subset, 0.5 * length( l_buf ), hextoraw( l_buf ) );
            if l_priv_dict.exists( '13' )
            then
              l_buf := to_char( l_len + 2 + 139, 'fm0X' ) || '13';
              dbms_lob.writeappend( l_subset, 0.5 * length( l_buf ), hextoraw( l_buf ) );
              l_priv_subrs := parse_dict( p_offset + l_font_dict( '12' ).operand2 + l_priv_dict( '13' ).operand1 );
              copy_dict( l_priv_subrs, l_all_used( l_fd_idx ), true );
            end if;
          end if;
          l_fd_idx := l_used_fds.next( l_fd_idx );
        end loop;
        -- FDArray
        l_len := 1;
        l_tmp := null;
        l_buf := to_char( l_used_fds.count, 'fm0XXX' ) || '020001';
        l_fd_idx := l_used_fds.first;
        loop
          exit when l_fd_idx is null;
          l_font_dict := parse_dict_data( l_fd_array.offs + l_fd_array.arr_start( l_fd_idx + 1 ), l_fd_array.arr_len( l_fd_idx + 1 ) );
          l_entry := l_font_dict.first;
          loop
            exit when l_entry is null;
            if l_entry != '12'
            then
              l_len := l_len + utl_raw.length( l_font_dict( l_entry ).entry );
              l_tmp := utl_raw.concat( l_tmp, l_font_dict( l_entry ).entry );
            end if;
            l_entry := l_font_dict.next( l_entry );
          end loop;
          if l_font_dict.exists( '12' ) and l_font_dict( '12' ).operand1 > 0
          then
            l_priv_d_sz := l_font_dict( '12' ).operand1;
            l_priv_dict := parse_dict_data( p_offset + l_font_dict( '12' ).operand2, l_font_dict( '12' ).operand1 );
            if l_priv_dict.exists( '13' )
            then
              l_priv_d_sz := l_priv_d_sz - utl_raw.length( l_priv_dict( '13' ).entry ) + 2;
            end if;
            l_len := l_len + 7;
            l_tmp := utl_raw.concat( l_tmp, hextoraw( to_char( l_priv_d_sz + 139, 'fm0X' ) || '1D' || to_char( l_offs + l_pds_offset( l_fd_idx ), 'fm0XXXXXXX' ) || '12' ) );
          end if;
          l_buf := l_buf || to_char( l_len, 'fm0XXX' );
          l_fd_idx := l_used_fds.next( l_fd_idx );
        end loop;
        dbms_lob.writeappend( l_subset, 0.5 * length( l_buf ), hextoraw( l_buf ) );
        dbms_lob.writeappend( l_subset, utl_raw.length( l_tmp ), l_tmp );
      end cid2subset_cid;
      --
      procedure nocid2subset_cid
      is
        l_entry   raw(4);
        l_fmt     varchar2(10);
        l_cur     pls_integer;
        l_new     pls_integer;
        l_old     pls_integer;
        l_sid     pls_integer;
        l_str_len pls_integer;
      begin
        if l_top_data.exists( '12' ) and l_top_data( '12' ).operand1 > 0
        then
          l_priv_dict := parse_dict_data( p_offset + l_top_data( '12' ).operand2, l_top_data( '12' ).operand1 );
          if l_priv_dict.exists( '13' )
          then
            l_priv_subrs := parse_dict( p_offset + l_top_data( '12' ).operand2 + l_priv_dict( '13' ).operand1 );
            l_subr_bias := get_bias( l_priv_subrs.cnt );
          end if;
        end if;
        --
        l_new2old( 0 ) := 0;
        for i in 0 .. l_new2old.count - 1
        loop
          l_old := l_new2old( i ) + 1;
          parse_type2( l_charstrings.offs + l_charstrings.arr_start( l_old ), l_charstrings.arr_len( l_old ) );
        end loop;
        --
        l_tmp := hextoraw( 'F81BF81C8B0C1E' ); -- ROS Adobe Identity 0
        l_str_len := 13;
        l_entry := l_top_data.first;
        loop
          exit when l_entry is null;
          if l_entry not in ( '0F'   -- charset
                            , '10'   -- Encoding
                            , '11'   -- CharStrings
                            , '0C1E' -- ROS
                            , '0C24' -- FDArray
                            , '0C25' -- FDSelect
                            , '0C22' -- CIDCount
                            )
          then
            if l_entry member of l_SID_operators and l_top_data( l_entry ).operand1 > 389
            then
              l_sid := l_top_data( l_entry ).operand1 - 390;
              l_str_len := l_str_len + l_strings.arr_len( l_sid );
              l_new := l_used_strings.count + 1;
              l_used_strings( l_new ) := l_sid;
              l_tmp := utl_raw.concat( l_tmp, hextoraw( 'F8' || to_char( l_new + 28, 'fm0X' ) ), l_entry );
            else
              l_tmp := utl_raw.concat( l_tmp, l_top_data( l_entry ).entry );
            end if;
          end if;
          l_entry := l_top_data.next( l_entry );
        end loop;
        l_tmp := utl_raw.concat( l_tmp, hextoraw( '1D' || to_char( l_new2old.count, 'fm0XXXXXXX' ) || '0C22' ) ); -- CIDCount
        l_offs := 4 + needed_length( l_names.arr_len( l_name_idx ), 1 )    -- header + names
                    + needed_length( utl_raw.length( l_tmp ) + 26, 1 )     -- topdict
                    + needed_length( l_str_len, l_used_strings.count + 2 ) -- strings
                    + needed_length( l_gsubrs, l_used_gsubrs, true );      -- gsubrs
        l_tmp := utl_raw.concat( l_tmp, hextoraw( '1D' || to_char( l_offs, 'fm0XXXXXXX' ) || '0F' ) );   -- charset
        l_offs := l_offs + 5; -- charset type 2, charstring/numGlyphs <  65536
        l_tmp := utl_raw.concat( l_tmp, hextoraw( '1D' || to_char( l_offs, 'fm0XXXXXXX' ) || '11' ) );   -- CharStrings
        l_offs := l_offs + needed_length( l_charstrings, l_new2old, false, 1 );                          -- CharStrings
        l_tmp := utl_raw.concat( l_tmp, hextoraw( '1D' || to_char( l_offs, 'fm0XXXXXXX' ) || '0C25' ) ); -- FDSelect
        l_offs := l_offs + 1 + l_new2old.count;                                                          -- FDSelect type 0
        l_tmp := utl_raw.concat( l_tmp, hextoraw( '1D' || to_char( l_offs, 'fm0XXXXXXX' ) || '0C24' ) ); -- FDArray
        l_len := utl_raw.length( l_tmp );
        if l_len > 254
        then
          dbms_lob.writeappend( l_subset
                              , l_len + 7
                              , utl_raw.concat( hextoraw( '0001020001' )
                                              , hextoraw( to_char( l_len + 1, 'fm0XXX' ) )
                                              , l_tmp
                                              )
                              );
        else
          dbms_lob.writeappend( l_subset
                              , l_len + 5
                              , utl_raw.concat( hextoraw( '00010101' )
                                              , hextoraw( to_char( l_len + 1, 'fm0X' ) )
                                              , l_tmp
                                              )
                              );
        end if;
        l_tmp := utl_raw.cast_to_raw( 'AdobeRegistry' );
        l_buf := to_char( l_used_strings.count + 2, 'fm0XXX' );
        if l_str_len > 254
        then
          l_fmt := 'fm0XXX';
          l_buf := l_buf || '02';
        else
          l_fmt := 'fm0X';
          l_buf := l_buf || '01';
        end if;
        l_buf := l_buf || to_char( 1, l_fmt ) || to_char( 6, l_fmt ) || to_char( 14, l_fmt );
        l_cur := 14;
        for i in 1 .. l_used_strings.count
        loop
          l_cur := l_cur + l_strings.arr_len( l_used_strings( i ) );
          l_buf := l_buf || to_char( l_cur, l_fmt );
          l_tmp := utl_raw.concat( l_tmp, get_cff_value( l_strings, l_used_strings( i ) ) );
        end loop;
        dbms_lob.writeappend( l_subset, 0.5 * length( l_buf ), hextoraw( l_buf ) );
        dbms_lob.writeappend( l_subset, l_str_len, l_tmp );
        copy_dict( l_gsubrs, l_used_gsubrs, true );
        if l_new2old.count > 1
        then
          dbms_lob.writeappend( l_subset, 5, hextoraw( '020001' || to_char( l_new2old.count - 2, 'fm0XXX' ) ) );
          copy_dict( l_charstrings, l_new2old, false, 1 );
        end if;
        -- FDSelect
        l_buf := '00';
        for i in 0 .. l_new2old.count - 1
        loop
          l_buf := l_buf || '00';
          if length( l_buf ) > 16000
          then
            dbms_lob.writeappend( l_subset, 2 * length( l_buf ), hextoraw( l_buf ) );
            l_buf := null;
          end if;
        end loop;
        if length( l_buf ) > 0
        then
          dbms_lob.writeappend( l_subset, 0.5 * length( l_buf ), hextoraw( l_buf ) );
        end if;
        -- FDArray
        l_tmp := null;
        l_entry := l_priv_dict.first;
        loop
          exit when l_entry is null;
          if l_entry != '13' -- Subrs
          then
            l_tmp := utl_raw.concat( l_tmp, l_priv_dict( l_entry ).entry );
          end if;
          l_entry := l_priv_dict.next( l_entry );
        end loop;
        l_tmp := utl_raw.concat( l_tmp, hextoraw( '1D' || to_char( utl_raw.length( l_tmp ) + 6, 'fm0XXXXXXX' ) || '13' ) ); -- Subrs
        l_buf := '000101010C' ||
                 '1D' || to_char( utl_raw.length( l_tmp ), 'fm0XXXXXXX' ) ||
                 '1D' || to_char( l_offs + 16, 'fm0XXXXXXX' ) || '12';
        dbms_lob.writeappend( l_subset, 0.5 * length( l_buf ), hextoraw( l_buf ) );
        dbms_lob.writeappend( l_subset, utl_raw.length( l_tmp ), l_tmp );
        copy_dict( l_priv_subrs, l_used_subrs, true );
      end nocid2subset_cid;
    begin
      l_buf := dbms_lob.substr( p_cff, 4, p_offset );
      if substr( l_buf, 1, 2 ) != '01'
      then
        raise_application_error( -20064, 'unsupported CFF version ' || substr( l_buf, 1, 4 ) || ' in CFF font file ' || l_font.fontname );
      end if;
      for i in reverse g_pdf.font_old_new( p_index ).first .. - 1
      loop
        l_new2old( - i ) := g_pdf.font_old_new( p_index )( i );
      end loop;
      l_offs_sz := g_hex( substr( l_buf, 7, 2 ) );
      l_names := parse_dict( p_offset + g_hex( substr( l_buf, 5, 2 ) ) );
      l_topdict := parse_dict( l_names.data_end );
      l_strings := parse_dict( l_topdict.data_end );
      l_gsubrs := parse_dict( l_strings.data_end );
      --
      l_gsubr_bias := get_bias( l_gsubrs.cnt );
      for i in 1 .. l_topdict.cnt
      loop
        l_top_data := parse_dict_data( l_topdict.offs + l_topdict.arr_start( i ), l_topdict.arr_len( i ) );
        l_name := utl_raw.cast_to_varchar2( dbms_lob.substr( p_cff, l_names.arr_len( i ), l_names.offs + l_names.arr_start( i ) ) );
        l_name_idx := i;
        exit;
      end loop;
      --
      l_charstrings := parse_dict( p_offset + l_top_data( '11' ).operand1 );
      -- 0 ISOAdobe
      -- 1 Expert
      -- 2 ExpertSubset
      if l_top_data.exists( '0F' ) and l_top_data( '0F' ).operand1 > 2
      then
        declare
          l_cid  pls_integer;
          l_gid  pls_integer;
        begin
          l_offs := p_offset + l_top_data( '0F' ).operand1 + 1;
          l_to_do := l_charstrings.cnt;
          case dbms_lob.substr( p_cff, 1, l_offs - 1 )
            when '00'
            then
              l_sz := 8000;
              for i in 0 .. 100
              loop
                exit when l_to_do < 1;
                l_buf := dbms_lob.substr( p_cff, 2 * least( l_to_do, l_sz ), l_offs );
                for j in 0 .. least( l_to_do, l_sz ) - 2
                loop
                  l_glyph2cid( j + 1 + i * l_sz ) := to_number( substr( l_buf, 1 + 4 * j, 4 ), 'XXXX' );
                end loop;
                l_offs := l_offs + l_sz;
                l_to_do := l_to_do - l_sz;
              end loop;
            when '01'
            then
              l_gid := 1;
              l_sz := 5400;
              <<charset_loop_01>>
              for i in 0 .. 100
              loop
                exit when l_gid >= l_to_do;
                l_buf := dbms_lob.substr( p_cff, 3 * l_sz, l_offs );
                for j in 0 .. l_sz - 1
                loop
                  l_cid := to_number( substr( l_buf, 1 + 6 * j, 4 ), 'XXXX' );
                  for g in 0 .. g_hex( substr( l_buf, 5 + 6 * j, 2 ) )
                  loop
                    l_glyph2cid( l_gid ) := l_cid + g;
                    l_gid := l_gid + 1;
                  end loop;
                  exit charset_loop_01 when l_gid >= l_to_do;
                end loop;
                l_offs := l_offs + l_sz;
              end loop;
            when '02'
            then
              l_gid := 1;
              l_sz := 4050;
              <<charset_loop_02>>
              for i in 0 .. 100
              loop
                exit when l_gid >= l_to_do;
                l_buf := dbms_lob.substr( p_cff, 4 * l_sz, l_offs );
                for j in 0 .. l_sz - 1
                loop
                  l_cid := to_number( substr( l_buf, 1 + 8 * j, 4 ), 'XXXX' );
                  for g in 0 .. to_number( substr( l_buf, 5 + 8 * j, 4 ), 'XXXX' )
                  loop
                    l_glyph2cid( l_gid ) := l_cid + g;
                    l_gid := l_gid + 1;
                  end loop;
                  exit charset_loop_02 when l_gid >= l_to_do;
                end loop;
                l_offs := l_offs + l_sz;
              end loop;
          end case;
        end;
      end if;
      --
      l_len := l_names.arr_len( l_name_idx );
      if l_len > 254
      then
        l_subset := utl_raw.concat( hextoraw( '01000404' )
                                  , hextoraw( '0001020001' )
                                  , hextoraw( to_char( l_len + 1, 'fm0XXX' ) )
                                  , utl_raw.cast_to_raw( l_name )
                                  );
      else
        l_subset := utl_raw.concat( hextoraw( '01000404' )
                                  , hextoraw( '00010101' )
                                  , hextoraw( to_char( l_len + 1, 'fm0X' ) )
                                  , utl_raw.cast_to_raw( l_name )
                                  );
      end if;
      if l_top_data.exists( '0C1E' )
      then
        cid2subset_cid;
      else
        nocid2subset_cid;
      end if;
    end cff;
  --
  begin
    l_font := g_pdf.fonts( p_index );
    if not l_font.subset
    then
      return g_pdf.font_files( p_index );
    end if;
    g_pdf.font_glyph_cache( p_index )( 0 ) := l_font.notdef;
    l_buf := dbms_lob.substr( g_pdf.font_files( p_index ), 4096, l_font.ttf_offset );
    l_cnt := to_number( substr( l_buf, 9, 4 ), 'XXXX' );
    --
    l_tags := 6; -- head, hhea, hmtx, maxp, glyph, loca
    for i in 0 .. l_cnt - 1
    loop
      if substr( l_buf, 25 + i * 32, 8 ) = c_loca
      then
        l_sz := 4000;
        l_offset := to_number( substr( l_buf, 41 + i * 32, 8 ), 'XXXXXXXX' ) + 1;
        for j in 0 .. l_font.numGlyphs
        loop
          if mod( j, l_sz ) = 0
          then
            l_idx := 0;
            l_tmp := dbms_lob.substr( g_pdf.font_files( p_index )
                                    , l_sz * l_font.indexToLocFormat
                                    , l_offset
                                    );
            l_offset := l_offset + l_sz * l_font.indexToLocFormat;
          end if;
          l_loca( j ) := to_number( substr( l_tmp, 1 + l_idx, 2 * l_font.indexToLocFormat ), 'XXXXXXXX' );
          l_idx := l_idx + 2 * l_font.indexToLocFormat;
        end loop;
      elsif substr( l_buf, 25 + i * 32, 8 ) in ( c_cvt, c_fpgm, c_prep )
      then
        l_tags := l_tags + 1;
      end if;
    end loop;
    --
    l_sz := case when l_font.indexToLocFormat = 4 then 1 else 2 end;
    l_offset := 12 + 16 * l_tags;
    l_subset := utl_raw.copies( '00', l_offset );
    if l_tags >= 8
    then
      l_header := '00010000' || to_char( l_tags, 'fm0XXX' ) || '00800003' || to_char( ( l_tags - 8 ) * 16, 'fm0XXX' );
    else
      l_header := '00010000' || to_char( l_tags, 'fm0XXX' ) || '00400002' || to_char( ( l_tags - 4 ) * 16, 'fm0XXX' );
    end if;
    --
    for i in 0 .. l_cnt - 1
    loop
      l_mod := mod( l_offset, 4 );
      if l_mod > 0
      then
        dbms_lob.writeappend( l_subset, 4 - l_mod, '000000' );
        l_offset := l_offset + 4 - l_mod;
      end if;
      l_len := to_number( substr( l_buf, 49 + i * 32, 8 ), 'XXXXXXXX' );
      if substr( l_buf, 25 + i * 32, 8 ) in ( c_cvt, c_fpgm, c_prep, c_head, c_hhea, c_hmtx, c_maxp )
      then
        l_header := l_header
                  || substr( l_buf, 25 + i * 32, 8 )   -- tag
                  || substr( l_buf, 33 + i * 32, 8 )   -- checksum
                  || to_char( l_offset, 'FM0XXXXXXX' ) -- offset
                  || substr( l_buf, 49 + i * 32, 8 );  -- length
        if l_len <= 32767
        then
          dbms_lob.writeappend( l_subset
                              , l_len
                              , dbms_lob.substr( g_pdf.font_files( p_index )
                                               , l_len
                                               , to_number( substr( l_buf, 41 + i * 32, 8 ), 'XXXXXXXX' ) + 1
                                               )
                              );
        else
          dbms_lob.copy( l_subset
                       , g_pdf.font_files( p_index )
                       , l_len
                       , l_offset + 1
                       , to_number( substr( l_buf, 41 + i * 32, 8 ), 'XXXXXXXX' ) + 1
                       );
        end if;
        l_offset := l_offset + l_len;
      elsif substr( l_buf, 25 + i * 32, 8 ) in ( c_CFF, c_CFF2 )
      then
        cff( g_pdf.font_files( p_index ), to_number( substr( l_buf, 41 + i * 32, 8 ), 'XXXXXXXX' ) + 1 );
        return l_subset;
      elsif substr( l_buf, 25 + i * 32, 8 ) = c_loca
      then
        l_fmt := rpad( 'fm0', 2 + 2 * l_font.indexToLocFormat, 'X' );
        l_pos := 0;
        l_tmp := null;
        for j in 0 .. l_font.numGlyphs - 1
        loop
          l_tmp := l_tmp || to_char( l_pos, l_fmt );
          if length( l_tmp ) > 20000
          then
            dbms_lob.writeappend( l_subset, length( l_tmp ) / 2, l_tmp );
            l_tmp := null;
          end if;
          if g_pdf.font_glyph_cache( p_index ).exists( j )
          then
            l_pos := l_pos + l_loca( j + 1 ) - l_loca( j );
          end if;
        end loop;
        l_tmp := l_tmp || to_char( l_pos, l_fmt );
        dbms_lob.writeappend( l_subset, length( l_tmp ) / 2, l_tmp );
        l_header := l_header
                  || substr( l_buf, 25 + i * 32, 8 )   -- tag
                  || '00000000'                        -- checksum
                  || to_char( l_offset, 'FM0XXXXXXX' ) -- offset
                  || to_char( l_len, 'FM0XXXXXXX' );   -- length
        l_offset := l_offset + l_len;
      elsif substr( l_buf, 25 + i * 32, 8 ) = c_glyf
      then
        l_len := 0;
        l_tmp := null;
        l_idx := g_pdf.font_glyph_cache( p_index ).first;
        l_pos := to_number( substr( l_buf, 41 + i * 32, 8 ), 'XXXXXXXX' ) + 1;
        while l_idx is not null
        loop
          l_loca_s := l_sz * l_loca( l_idx );
          l_loca_e := l_sz * l_loca( l_idx + 1 );
          if l_loca_e > l_loca_s
          then
            l_len := l_len + l_loca_e - l_loca_s;
            l_tmp := l_tmp || dbms_lob.substr( g_pdf.font_files( p_index ), l_loca_e - l_loca_s, l_pos + l_loca_s );
            if length( l_tmp ) > 20000
            then
              dbms_lob.writeappend( l_subset, length( l_tmp ) / 2, l_tmp );
              l_tmp := null;
            end if;
          end if;
          l_idx := g_pdf.font_glyph_cache( p_index ).next( l_idx );
        end loop;
        if l_tmp is not null
        then
          dbms_lob.writeappend( l_subset, length( l_tmp ) / 2, l_tmp );
        end if;
        l_header := l_header
                  || substr( l_buf, 25 + i * 32, 8 )   -- tag
                  || '00000000'                        -- checksum
                  || to_char( l_offset, 'FM0XXXXXXX' ) -- offset
                  || to_char( l_len, 'FM0XXXXXXX' );   -- length
        l_offset := l_offset + l_len;
      end if;
    end loop;
    dbms_lob.copy( l_subset
                 , hextoraw( l_header )
                 , length( l_header) / 2
                 , 1
                 , 1
                 );
    --
    return l_subset;
    --
  end subset_font;
  --
  procedure handle_composite_glyphs( p_index pls_integer )
  is
    l_buf             varchar2(32767);
    l_tmp             varchar2(32767);
    l_sz              pls_integer;
    l_idx             pls_integer;
    l_used            pls_integer;
    l_offset          integer;
    l_glyf_offset     integer;
    l_font            tp_font;
    l_loca            tp_pls_tab;
    l_used_glyphs     tp_pls_tab;
    l_used_composites tp_pls_tab;
    --
    procedure check_composite( p_glyf pls_integer )
    is
      l_pos   pls_integer;
      l_flags pls_integer;
      l_comp  pls_integer;
    begin
      if     bitand( g_hex( dbms_lob.substr( g_pdf.font_files( p_index ), 1, l_glyf_offset + l_sz * l_loca( p_glyf ) ) ), 128 ) > 0
         and l_loca( p_glyf + 1 ) > l_loca( p_glyf )
      then
        l_buf := dbms_lob.substr( g_pdf.font_files( p_index ), l_sz * ( l_loca( p_glyf + 1 ) - l_loca( p_glyf ) ), l_glyf_offset + l_sz * l_loca( p_glyf ) );
        l_pos := 23;
        loop
          if substr( l_buf, l_pos, 2 ) is null
          then
             raise_application_error( -20060, 'Unexpected value in font file ' || l_font.fontname );
          end if;
          l_flags := g_hex( substr( l_buf, l_pos, 2 ) );
          l_comp := to_number( substr( l_buf, l_pos + 2, 4 ), 'XXXX' );
          if l_comp is null
          then
             raise_application_error( -20061, 'Unexpected value in font file ' || l_font.fontname );
          end if;
          if not l_used_composites.exists( l_comp )
          then
            l_used_composites( l_comp ) := l_font.notdef;  -- notdef??? glyph2code????
            check_composite( l_comp );
          end if;
          exit when bitand( l_flags, 32 ) = 0;
          l_pos := l_pos + 12
            + case when bitand( l_flags, 1   ) = 0 then 0 else 4 end   -- ARG_1_AND_2_ARE_WORDS
            + case when bitand( l_flags, 8   ) = 0 then 0 else 4 end   -- WE_HAVE_A_SCALE
            + case when bitand( l_flags, 64  ) = 0 then 0 else 8 end   -- WE_HAVE_AN_X_AND_Y_SCALE
            + case when bitand( l_flags, 128 ) = 0 then 0 else 16 end; -- WE_HAVE_A_TWO_BY_TWO
        end loop;
      end if;
    end check_composite;
  begin
    l_font := g_pdf.fonts( p_index );
    l_buf := dbms_lob.substr( g_pdf.font_files( p_index ), 4096, l_font.ttf_offset );
    for i in 0 .. to_number( substr( l_buf, 9, 4 ), 'XXXX' ) - 1
    loop
      if substr( l_buf, 25 + i * 32, 8 ) = c_loca
      then
        l_sz := 4000;
        l_offset := to_number( substr( l_buf, 41 + i * 32, 8 ), 'XXXXXXXX' ) + 1;
        for j in 0 .. l_font.numGlyphs
        loop
          if mod( j, l_sz ) = 0
          then
            l_idx := 0;
            l_tmp := dbms_lob.substr( g_pdf.font_files( p_index )
                                    , l_sz * l_font.indexToLocFormat
                                    , l_offset
                                    );
            l_offset := l_offset + l_sz * l_font.indexToLocFormat;
          end if;
          l_loca( j ) := to_number( substr( l_tmp, 1 + l_idx, 2 * l_font.indexToLocFormat ), 'XXXXXXXX' );
          l_idx := l_idx + 2 * l_font.indexToLocFormat;
        end loop;
      elsif substr( l_buf, 25 + i * 32, 8 ) = c_glyf
      then
        l_glyf_offset := to_number( substr( l_buf, 41 + i * 32, 8 ), 'XXXXXXXX' ) + 1;
      end if;
    end loop;
    if l_loca.count = 0
    then
      return;
    end if;
    --
    l_sz := case when l_font.indexToLocFormat = 2 then 2 else 1 end;
    l_used_glyphs := g_pdf.font_glyph_cache( p_index );
    l_used := l_used_glyphs.first;
    while l_used is not null
    loop
      l_used_composites( l_used ) := l_used_glyphs( l_used );
      check_composite( l_used );
      l_used := l_used_glyphs.next( l_used );
    end loop;
    g_pdf.font_glyph_cache( p_index ) := l_used_composites;
  end handle_composite_glyphs;
  --
  function add_font( p_index pls_integer )
  return number
  is
    l_self        number(10);
    l_fontfile    number(10);
    l_font_subset blob;
    l_used        pls_integer;
    l_unicode     pls_integer;
    l_font        tp_font;
  begin
    if g_pdf.fonts( p_index ).standard
    then
      if g_pdf.pdf_a3_conformance is not null
      then
        raise_application_error( -20025, 'core PDF standard fonts can not be used in a PDF/A file.' );
      end if;
      return add_object( '/Type/Font'
                       || '/Subtype/Type1'
                       || '/BaseFont/' || g_pdf.fonts( p_index ).name
                       || '/Encoding/WinAnsiEncoding' -- code page 1252
                       );
    end if;
    --
    l_font := g_pdf.fonts( p_index );
    l_self := add_object;
    txt2pdfdoc( '<<'                         || c_eol ||
                '/Type /Font'                || c_eol ||
                '/Subtype /Type0'            || c_eol ||
                '/BaseFont /' || l_font.name || c_eol ||
                '/Encoding /Identity-H'      || c_eol ||
                '/ToUnicode ' || to_char( l_self + 4 ) || ' 0 R' || c_eol ||
                '/DescendantFonts [' || to_char( l_self + 1 ) || ' 0 R ]' || c_eol ||
                '>>' || c_eol || 'endobj'
              ); -- self
    add_object( '/Type /Font' || c_eol       ||
                '/Subtype ' || case when l_font.cff and l_font.subset then '/CIDFontType0' else '/CIDFontType2' end || c_eol ||
                '/BaseFont /' || l_font.name || c_eol ||
                case when l_font.cff and l_font.subset then '' else '/CIDToGIDMap /Identity' end || c_eol ||
--                '/DW 1000'                   || c_eol ||
                '/CIDSystemInfo <</Ordering (Identity) /Registry (Adobe) /Supplement 0>>' || c_eol ||
                '/FontDescriptor ' || to_char( l_self + 2 ) || ' 0 R' || c_eol ||
                '/W ' || to_char( l_self + 3 ) || ' 0 R' );  -- self + 1
    add_object( '/Type /FontDescriptor'  || c_eol ||
                '/FontName /' || l_font.name || c_eol ||
                '/FontFamily (' || replace(
                                   replace(
                                   replace( l_font.family
                                          , '\', '\\' )
                                          , '(', '\(' )
                                          , ')', '\)' ) || ')' || c_eol ||
                '/Flags ' || l_font.flags  || c_eol ||
                '/FontBBox [' || l_font.bb_xmin || ' ' || l_font.bb_ymin ||
                          ' ' || l_font.bb_xmax || ' ' || l_font.bb_ymax ||
                          ']' || c_eol ||
                '/ItalicAngle ' || to_char_round( l_font.italic_angle ) || c_eol ||
                '/Ascent '      || l_font.ascent    || c_eol ||
                '/Descent '     || l_font.descent   || c_eol ||
                '/CapHeight '   || l_font.capheight || c_eol ||
                '/StemV '       || l_font.stemv     || c_eol ||
                case when g_pdf.font_files( p_index ) is not null then case when l_font.cff and l_font.subset then '/FontFile3 ' else '/FontFile2 ' end || to_char( l_self + 5 ) || ' 0 R' end
              );  -- self + 2
    --
    declare
      l_lw    pls_integer;
      l_w1    pls_integer;
      l_w2    pls_integer;
      l_last  pls_integer;
      l_prior pls_integer;
      l_w     varchar2(32767);
      --
      function get_width( p_glyph pls_integer )
      return number
      is
        l_tmp   number;
      begin
        if g_pdf.font_width_cache( p_index ).exists( p_glyph )
        then
          l_tmp := g_pdf.font_width_cache( p_index )( p_glyph );
        else
          l_tmp := l_lw;
        end if;
        return trunc( l_tmp * l_font.unit_norm );
      end;
    begin
      l_lw := g_pdf.font_width_cache( p_index )( g_pdf.font_width_cache( p_index ).last );
      g_pdf.font_old_new( p_index )( 0 ) := 0;
      l_used := 0;
      l_w2 := get_width( 0 );
      while l_used is not null
      loop
        l_w1 := l_w2;
        l_prior := g_pdf.font_old_new( p_index ).prior( l_used );
        if l_prior is null
        then
          l_w := l_w || ' ' || ( - l_used ) || ' [' || l_w1 || ']';
          exit;
        end if;
        l_w2 := get_width( g_pdf.font_old_new( p_index )( l_prior ) );
        if l_w1 = l_w2
        then
          while l_w1 = l_w2
          loop
            l_last := - l_prior;
            l_prior := g_pdf.font_old_new( p_index ).prior( l_prior );
            exit when l_prior is null;
            l_w2 := get_width( g_pdf.font_old_new( p_index )( l_prior ) );
          end loop;
          l_w := l_w || ' ' || ( - l_used ) || ' ' || l_last || ' ' || l_w1;
        elsif l_used = l_prior + 1
        then
          l_w := l_w || ' ' || ( - l_used ) || ' [' || l_w1;
          while l_used = l_prior + 1
          loop
            l_w := l_w || ' ' || l_w2;
            l_used := l_prior;
            l_prior := g_pdf.font_old_new( p_index ).prior( l_prior );
            exit when l_prior is null;
            l_w2 := get_width( g_pdf.font_old_new( p_index )( l_prior ) );
          end loop;
          l_w := l_w || ']';
        else
          l_w := l_w || ' ' || ( - l_used ) || ' [' || l_w1 || ']';
        end if;
        l_used := l_prior;
      end loop;
      l_w := '[' || trim( l_w ) || ']';
      add_object;   -- self + 3
      txt2pdfdoc( l_w || c_eol || 'endobj' );
    end;
    --
    declare
      l_cnt          pls_integer;
      l_map          varchar2(32767);
      l_cmap         varchar2(32767);
    begin
      l_cnt := 0;
      l_used := g_pdf.font_glyph_cache( p_index ).first;
      while l_used is not null
      loop
        l_map := l_map || '<' || to_char( g_pdf.font_old_new( p_index )( l_used ), 'FM0XXX' )
               || '> <' || to_char( g_pdf.font_glyph_cache( p_index )( l_used ), 'FM0XXX' )
               || '>' || chr( 10 );
        if l_cnt = 99
        then
          l_cnt := 0;
          l_cmap := l_cmap || chr( 10 ) || '100 beginbfchar' || chr( 10 ) || l_map || 'endbfchar';
          l_map := '';
        else
          l_cnt := l_cnt + 1;
        end if;
        l_used := g_pdf.font_glyph_cache(p_index ).next( l_used );
      end loop;
      if l_cnt > 0
      then
        l_cmap := l_cmap || chr( 10 ) || l_cnt || ' beginbfchar' || chr( 10 ) || l_map || 'endbfchar';
      end if;
/*
/CIDInit /ProcSet findresource begin 12 dict begin begincmap
/CIDSystemInfo <</Registry (F0+0) /Ordering (F0) /Supplement 0>> def
/CMapName /F0+0 def
/CMapType 2 def
*/
      l_fontfile := add_stream( utl_raw.cast_to_raw(
'/CIDInit /ProcSet findresource begin 12 dict begin
begincmap
/CIDSystemInfo
<< /Registry (Adobe) /Ordering (UCS) /Supplement 0 >> def
/CMapName /Adobe-Identity-UCS def /CMapType 2 def
1 begincodespacerange
<0000> <FFFF>
endcodespacerange
' || l_cmap || '
endcmap
CMapName currentdict /CMap defineresource pop
end
end' ) );   -- self + 4
    end;
    --
    if g_pdf.font_files( p_index ) is not null
    then
      handle_composite_glyphs( p_index );
      l_font_subset := subset_font( p_index );
      l_fontfile := add_stream( l_font_subset
                              , '/Length1 ' || dbms_lob.getlength( l_font_subset ) || case when l_font.cff and l_font.subset then ' /Subtype/CIDFontType0C' end
                              );  -- self + 5
      if dbms_lob.istemporary( l_font_subset ) = 1
      then
        dbms_lob.freetemporary( l_font_subset );
      end if;
    end if;
    --
    return l_self;
  end add_font;
  --
  function add_extgstate( p_idx pls_integer )
  return number
  is
  begin
    return add_object( '/Type/ExtGState'
                     || '/CA ' || to_char_round( g_pdf.egs_dir( p_idx ).stroking_alpha )
                     || '/ca ' || to_char_round( g_pdf.egs_dir( p_idx ).non_stroking_alpha )
                     || '/BM ' || coalesce( g_pdf.egs_dir( p_idx ).blend_mode, '/Normal' )
                     );
  end add_extgstate;
  --
  function add_resources
  return number
  is
    l_ind   pls_integer;
    l_self  number(10);
    l_fonts tp_objects;
    l_egs   varchar2(32767);
  begin
    l_ind := g_pdf.fonts.first;
    while l_ind is not null
    loop
      if g_pdf.fonts( l_ind ).used
      then
        l_fonts( l_ind ) := add_font( l_ind );
      end if;
      l_ind := g_pdf.fonts.next( l_ind );
    end loop;
    --
    if g_pdf.images.count > 0
    then
      for i in g_pdf.images.first .. g_pdf.images.last
      loop
        g_pdf.images( i ).object := add_image( g_pdf.images( i ) );
      end loop;
    end if;
    --
    if g_pdf.egs_dir.count > 0
    then
      l_egs := chr(10) || '/ExtGState <<';
      for i in g_pdf.egs_dir.first .. g_pdf.egs_dir.last
      loop
        l_egs := l_egs || chr(10) || '/GS' || i || ' ' || add_extgstate( i ) || ' 0 R';
      end loop;
      l_egs := l_egs || chr(10) || '>>' || chr(10);
    end if;
    --
    l_self := add_object;
    txt2pdfdoc( '<<' );
    --
    if g_pdf.fonts_used
    then
      txt2pdfdoc( '/Font <<' );
      l_ind := g_pdf.fonts.first;
      while l_ind is not null
      loop
        if g_pdf.fonts( l_ind ).used
        then
          txt2pdfdoc( '/F'|| to_char( l_ind ) || ' '
                    || to_char( l_fonts( l_ind ) ) || ' 0 R'
                    );
        end if;
        l_ind := g_pdf.fonts.next( l_ind );
      end loop;
      txt2pdfdoc( '>>' );
    end if;
    --
    if g_pdf.images.count( ) > 0
    then
      txt2pdfdoc( '/XObject <<' );
      for i in g_pdf.images.first .. g_pdf.images.last
      loop
        txt2pdfdoc( '/I' || to_char( i ) || ' ' || g_pdf.images( i ).object || ' 0 R' );
      end loop;
      txt2pdfdoc( '>>' );
    end if;
    --
    if l_egs is not null
    then
      txt2pdfdoc( l_egs );
    end if;
    --
    txt2pdfdoc( '>>' || c_eol || 'endobj' );
    return l_self;
  end add_resources;
  --
  procedure add_annots( p_annots in out tp_annots )
  is
    l_x     number;
    l_y     number;
    l_self  integer;
    l_annot tp_annot;
  begin
    for i in 1 .. p_annots.count
    loop
      l_annot := p_annots( i );
      if l_annot.subtype != 'Link'
      then
        l_self := add_object;
        l_x := l_annot.rb_x - l_annot.lt_x + 0.4;
        txt2pdfdoc( '<</BBox [ 0 0 ' || to_char_round( l_x ) || ' ' || to_char_round( l_annot.lt_y - l_annot.rb_y + 0.4) || ']' );
        txt2pdfdoc( '/Matrix [ 1 0 0 1 0 0 ] /Resources << >> /Subtype /Form' );
        l_y := l_annot.extra;
        put_stream( utl_raw.cast_to_raw(
             rgb( p_color => l_annot.color ) || ' RG ' ||
             to_char_round( l_annot.width ) || ' w ' ||
             '0.1 ' || to_char_round( l_y ) || ' m ' ||
             to_char_round( l_x - 0.2 ) || '  ' || to_char_round( l_y ) || ' l S' ), l_self, p_tag => false );
        txt2pdfdoc( 'endobj' );
      end if;
      p_annots( i ).object_nr := add_object;
      txt2pdfdoc( '<<' );
      if l_annot.subtype != 'Link'
      then
        txt2pdfdoc( '/AP <</N ' || l_self || ' 0 R >>' );
      else
        txt2pdfdoc( '/A<</S/URI/URI (' || l_annot.url || ') >>' );
      end if;
      txt2pdfdoc( '/Type /Annot /Subtype /' || l_annot.subtype );
      txt2pdfdoc( '/C [' || rgb( p_color => l_annot.color ) || ']' );
      txt2pdfdoc( '/Rect [ ' ||
          to_char_round( l_annot.lt_x - 0.2 ) || ' ' || to_char_round( l_annot.lt_y + 0.2 ) || ' ' ||
          to_char_round( l_annot.rb_x + 0.2 ) || ' ' || to_char_round( l_annot.rb_y - 0.2) || ']' );
      txt2pdfdoc( '/QuadPoints [ ' ||
          to_char_round( l_annot.lt_x ) || ' ' || to_char_round( l_annot.lt_y ) || ' ' ||
          to_char_round( l_annot.rb_x ) || ' ' || to_char_round( l_annot.lt_y ) || ' ' ||
          to_char_round( l_annot.lt_x ) || ' ' || to_char_round( l_annot.rb_y ) || ' ' ||
          to_char_round( l_annot.rb_x ) || ' ' || to_char_round( l_annot.rb_y ) || ']' );
      txt2pdfdoc( '>>' || c_eol || 'endobj' );
    end loop;
  end add_annots;
  --
  procedure add_page
    ( p_page_ind pls_integer
    , p_parent number
    , p_resources number
    )
  is
    l_content number(10);
    l_page tp_page;
    l_annots  varchar2(32767);
    l_page_annots tp_annots;
  begin
    l_page := g_pdf.pages( p_page_ind );
    l_page_annots := l_page.annots;
    l_content := add_stream( g_pdf.pages( p_page_ind ).content, p_compress => true );
    if l_page_annots.count > 0
    then
      for i in 1 .. l_page_annots.count
      loop
        l_annots := l_annots || ' ' || l_page_annots( i ).object_nr || ' 0 R';
      end loop;
      l_annots := ' /Annots [' || ltrim( l_annots ) || '] ';
    end if;
    add_object;
    txt2pdfdoc( '<</Type/Page'
              || '/Parent ' || to_char( p_parent ) || ' 0 R'
              || '/Contents ' || to_char( l_content ) || ' 0 R'
              || '/Resources ' || to_char( p_resources ) || ' 0 R'
              || '/Group<</Type/Group/S/Transparency/CS/DeviceRGB>>'
              || '/MediaBox [0 0 '
              || to_char_round( g_pdf.pages( p_page_ind ).settings.page_width
                              , 0
                              )
              || ' '
              || to_char_round( g_pdf.pages( p_page_ind ).settings.page_height
                              , 0
                              )
              || '] ' || l_annots
              || '>>' || c_eol || 'endobj'
              );
  end add_page;
  --
  function add_pages
  return number
  is
    l_self      number(10);
    l_resources number(10);
    l_page_cnt  pls_integer := g_pdf.pages.count;
  begin
    for i in 0 .. l_page_cnt - 1
    loop
      add_annots( g_pdf.pages( i ).annots );
    end loop;
    l_resources := add_resources;
    l_self := add_object;
    txt2pdfdoc( '<</Type/Pages/Kids [' );
    for i in 1 .. l_page_cnt
    loop
      txt2pdfdoc( to_char( l_self + i * 2 ) || ' 0 R' );
    end loop;
    txt2pdfdoc( '] /Count ' || l_page_cnt || '>>' || c_eol || 'endobj' );
    for i in 0 .. l_page_cnt - 1
    loop
      add_page( i, l_self, l_resources );
    end loop;
    return l_self;
  end add_pages;
  --
  function add_dest_output_profile
  return number
  is
    l_self number(10);
    l_icc varchar2(32767) :=
      'AAAL0AAAAAACAAAAbW50clJHQiBYWVogB98AAgAPAAAAAAAAYWNzcAAAAAAAAAAA' ||
      'AAAAAAAAAAAAAAABAAAAAAAAAAAAAPbWAAEAAAAA0y0AAAAAPQ6y3q6Tl76bZybO' ||
      'jApDzgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQZGVzYwAAAUQAAABj' ||
      'YlhZWgAAAagAAAAUYlRSQwAAAbwAAAgMZ1RSQwAAAbwAAAgMclRSQwAAAbwAAAgM' ||
      'ZG1kZAAACcgAAACIZ1hZWgAAClAAAAAUbHVtaQAACmQAAAAUbWVhcwAACngAAAAk' ||
      'YmtwdAAACpwAAAAUclhZWgAACrAAAAAUdGVjaAAACsQAAAAMdnVlZAAACtAAAACH' ||
      'd3RwdAAAC1gAAAAUY3BydAAAC2wAAAA3Y2hhZAAAC6QAAAAsZGVzYwAAAAAAAAAJ' ||
      'c1JHQjIwMTQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' ||
      'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFhZWiAAAAAA' ||
      'AAAkoAAAD4QAALbPY3VydgAAAAAAAAQAAAAABQAKAA8AFAAZAB4AIwAoAC0AMgA3' ||
      'ADsAQABFAEoATwBUAFkAXgBjAGgAbQByAHcAfACBAIYAiwCQAJUAmgCfAKQAqQCu' ||
      'ALIAtwC8AMEAxgDLANAA1QDbAOAA5QDrAPAA9gD7AQEBBwENARMBGQEfASUBKwEy' ||
      'ATgBPgFFAUwBUgFZAWABZwFuAXUBfAGDAYsBkgGaAaEBqQGxAbkBwQHJAdEB2QHh' ||
      'AekB8gH6AgMCDAIUAh0CJgIvAjgCQQJLAlQCXQJnAnECegKEAo4CmAKiAqwCtgLB' ||
      'AssC1QLgAusC9QMAAwsDFgMhAy0DOANDA08DWgNmA3IDfgOKA5YDogOuA7oDxwPT' ||
      'A+AD7AP5BAYEEwQgBC0EOwRIBFUEYwRxBH4EjASaBKgEtgTEBNME4QTwBP4FDQUc' ||
      'BSsFOgVJBVgFZwV3BYYFlgWmBbUFxQXVBeUF9gYGBhYGJwY3BkgGWQZqBnsGjAad' ||
      'Bq8GwAbRBuMG9QcHBxkHKwc9B08HYQd0B4YHmQesB78H0gflB/gICwgfCDIIRgha' ||
      'CG4IggiWCKoIvgjSCOcI+wkQCSUJOglPCWQJeQmPCaQJugnPCeUJ+woRCicKPQpU' ||
      'CmoKgQqYCq4KxQrcCvMLCwsiCzkLUQtpC4ALmAuwC8gL4Qv5DBIMKgxDDFwMdQyO' ||
      'DKcMwAzZDPMNDQ0mDUANWg10DY4NqQ3DDd4N+A4TDi4OSQ5kDn8Omw62DtIO7g8J' ||
      'DyUPQQ9eD3oPlg+zD88P7BAJECYQQxBhEH4QmxC5ENcQ9RETETERTxFtEYwRqhHJ' ||
      'EegSBxImEkUSZBKEEqMSwxLjEwMTIxNDE2MTgxOkE8UT5RQGFCcUSRRqFIsUrRTO' ||
      'FPAVEhU0FVYVeBWbFb0V4BYDFiYWSRZsFo8WshbWFvoXHRdBF2UXiReuF9IX9xgb' ||
      'GEAYZRiKGK8Y1Rj6GSAZRRlrGZEZtxndGgQaKhpRGncanhrFGuwbFBs7G2Mbihuy' ||
      'G9ocAhwqHFIcexyjHMwc9R0eHUcdcB2ZHcMd7B4WHkAeah6UHr4e6R8THz4faR+U' ||
      'H78f6iAVIEEgbCCYIMQg8CEcIUghdSGhIc4h+yInIlUigiKvIt0jCiM4I2YjlCPC' ||
      'I/AkHyRNJHwkqyTaJQklOCVoJZclxyX3JicmVyaHJrcm6CcYJ0kneierJ9woDSg/' ||
      'KHEooijUKQYpOClrKZ0p0CoCKjUqaCqbKs8rAis2K2krnSvRLAUsOSxuLKIs1y0M' ||
      'LUEtdi2rLeEuFi5MLoIuty7uLyQvWi+RL8cv/jA1MGwwpDDbMRIxSjGCMbox8jIq' ||
      'MmMymzLUMw0zRjN/M7gz8TQrNGU0njTYNRM1TTWHNcI1/TY3NnI2rjbpNyQ3YDec' ||
      'N9c4FDhQOIw4yDkFOUI5fzm8Ofk6Njp0OrI67zstO2s7qjvoPCc8ZTykPOM9Ij1h' ||
      'PaE94D4gPmA+oD7gPyE/YT+iP+JAI0BkQKZA50EpQWpBrEHuQjBCckK1QvdDOkN9' ||
      'Q8BEA0RHRIpEzkUSRVVFmkXeRiJGZ0arRvBHNUd7R8BIBUhLSJFI10kdSWNJqUnw' ||
      'SjdKfUrESwxLU0uaS+JMKkxyTLpNAk1KTZNN3E4lTm5Ot08AT0lPk0/dUCdQcVC7' ||
      'UQZRUFGbUeZSMVJ8UsdTE1NfU6pT9lRCVI9U21UoVXVVwlYPVlxWqVb3V0RXklfg' ||
      'WC9YfVjLWRpZaVm4WgdaVlqmWvVbRVuVW+VcNVyGXNZdJ114XcleGl5sXr1fD19h' ||
      'X7NgBWBXYKpg/GFPYaJh9WJJYpxi8GNDY5dj62RAZJRk6WU9ZZJl52Y9ZpJm6Gc9' ||
      'Z5Nn6Wg/aJZo7GlDaZpp8WpIap9q92tPa6dr/2xXbK9tCG1gbbluEm5rbsRvHm94' ||
      'b9FwK3CGcOBxOnGVcfByS3KmcwFzXXO4dBR0cHTMdSh1hXXhdj52m3b4d1Z3s3gR' ||
      'eG54zHkqeYl553pGeqV7BHtje8J8IXyBfOF9QX2hfgF+Yn7CfyN/hH/lgEeAqIEK' ||
      'gWuBzYIwgpKC9INXg7qEHYSAhOOFR4Wrhg6GcobXhzuHn4gEiGmIzokziZmJ/opk' ||
      'isqLMIuWi/yMY4zKjTGNmI3/jmaOzo82j56QBpBukNaRP5GokhGSepLjk02TtpQg' ||
      'lIqU9JVflcmWNJaflwqXdZfgmEyYuJkkmZCZ/JpomtWbQpuvnByciZz3nWSd0p5A' ||
      'nq6fHZ+Ln/qgaaDYoUehtqImopajBqN2o+akVqTHpTilqaYapoum/adup+CoUqjE' ||
      'qTepqaocqo+rAqt1q+msXKzQrUStuK4trqGvFq+LsACwdbDqsWCx1rJLssKzOLOu' ||
      'tCW0nLUTtYq2AbZ5tvC3aLfguFm40blKucK6O7q1uy67p7whvJu9Fb2Pvgq+hL7/' ||
      'v3q/9cBwwOzBZ8Hjwl/C28NYw9TEUcTOxUvFyMZGxsPHQce/yD3IvMk6ybnKOMq3' ||
      'yzbLtsw1zLXNNc21zjbOts83z7jQOdC60TzRvtI/0sHTRNPG1EnUy9VO1dHWVdbY' ||
      '11zX4Nhk2OjZbNnx2nba+9uA3AXcit0Q3ZbeHN6i3ynfr+A24L3hROHM4lPi2+Nj' ||
      '4+vkc+T85YTmDeaW5x/nqegy6LzpRunQ6lvq5etw6/vshu0R7ZzuKO6070DvzPBY' ||
      '8OXxcvH/8ozzGfOn9DT0wvVQ9d72bfb794r4Gfio+Tj5x/pX+uf7d/wH/Jj9Kf26' ||
      '/kv+3P9t//9kZXNjAAAAAAAAAC5JRUMgNjE5NjYtMi0xIERlZmF1bHQgUkdCIENv' ||
      'bG91ciBTcGFjZSAtIHNSR0IAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' ||
      'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' ||
      'WFlaIAAAAAAAAGKZAAC3hQAAGNpYWVogAAAAAAAAAAAAUAAAAAAAAG1lYXMAAAAA' ||
      'AAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAlhZWiAAAAAAAAAAngAAAKQAAACH' ||
      'WFlaIAAAAAAAAG+iAAA49QAAA5BzaWcgAAAAAENSVCBkZXNjAAAAAAAAAC1SZWZl' ||
      'cmVuY2UgVmlld2luZyBDb25kaXRpb24gaW4gSUVDIDYxOTY2LTItMQAAAAAAAAAA' ||
      'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' ||
      'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWFlaIAAAAAAAAPbWAAEAAAAA0y10ZXh0' ||
      'AAAAAENvcHlyaWdodCBJbnRlcm5hdGlvbmFsIENvbG9yIENvbnNvcnRpdW0sIDIw' ||
      'MTUAAHNmMzIAAAAAAAEMRAAABd////MmAAAHlAAA/Y////uh///9ogAAA9sAAMB1';
  begin
    l_self := add_object;
    put_stream( utl_encode.base64_decode( utl_raw.cast_to_raw( l_icc ) )
              , l_self
              , p_extra => '/N 3/Alternate /DeviceRGB'
              );
    txt2pdfdoc( 'endobj' );
    return l_self;
  end add_dest_output_profile;
  --
  function add_meta_data( p_extra varchar2 )
  return number
  is
    l_self number(10);
    l_xml  varchar2(32767);
  begin
    l_xml := '<?xpacket begin="" id="W5M0MpCehiHzreSzNTczkc9d"?>
<x:xmpmeta xmlns:x="adobe:ns:meta/">
  <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
    <rdf:Description rdf:about="" xmlns:pdfaid="http://www.aiim.org/pdfa/ns/id/">
      <pdfaid:part>3</pdfaid:part>
      <pdfaid:conformance>' || g_pdf.pdf_a3_conformance || '</pdfaid:conformance>
    </rdf:Description>
    <rdf:Description rdf:about="" xmlns:pdf="http://ns.adobe.com/pdf/1.3/">
      <pdf:Producer>' || c_producer || '</pdf:Producer>
    </rdf:Description>';
    if g_pdf.title is not null or g_pdf.creator is not null or g_pdf.subject is not null
    then
      l_xml := l_xml || '<rdf:Description rdf:about="" xmlns:dc="http://purl.org/dc/elements/1.1/">';
      if g_pdf.title is not null
      then
        l_xml := l_xml ||
          '<dc:title><rdf:Alt><rdf:li xml:lang="x-default">' ||
            dbms_xmlgen.convert( g_pdf.title ) ||
          '</rdf:li></rdf:Alt></dc:title>';
      end if;
      if g_pdf.creator is not null
      then
        l_xml := l_xml ||
          '<dc:creator><rdf:Seq><rdf:li>' ||
            dbms_xmlgen.convert( g_pdf.creator ) ||
          '</rdf:li></rdf:Seq></dc:creator>';
      end if;
      if g_pdf.subject is not null
      then
        l_xml := l_xml ||
          '<dc:description><rdf:Alt><rdf:li xml:lang="x-default">' ||
            dbms_xmlgen.convert( g_pdf.subject ) ||
          '</rdf:li></rdf:Alt></dc:description>';
      end if;
      l_xml := l_xml || '</rdf:Description>';
    end if;
    --
    l_xml := l_xml || p_extra;
    l_xml := l_xml || '
  </rdf:RDF>
</x:xmpmeta>
<?xpacket end="w"?>';
    l_self := add_object;
    put_stream( utl_raw.cast_to_raw( l_xml )
              , l_self
              , p_extra => '/Subtype/XML/Type/Metadata'
              , p_compress => false
              );
    txt2pdfdoc( 'endobj' );
    return l_self;
  end add_meta_data;
  --
  function add_file_spec( p_idx pls_integer )
  return number
  is
    l_file  number(10);
    l_self  number(10);
    l_extra varchar2(32767);
    l_ef    tp_embedded_file;
  begin
    l_ef := g_pdf.embedded_files( p_idx );
    l_extra := '/Type /EmbeddedFile/Params << /Size ' ||
        dbms_lob.getlength( l_ef.content ) ||
        to_char( sysdate, '"/ModDate (D:"YYYYMMDDhh24miss")"' ) || ' >> ';
    if l_ef.mime is not null
    then
      l_extra := l_extra || '/Subtype /' ||
          replace( l_ef.mime, '/', '#2F' ) || ' ';
    end if;
    l_file := add_object;
    put_stream( l_ef.content
              , l_file
              , p_extra => l_extra
              );
    txt2pdfdoc( 'endobj' );
    l_self := add_object;
    txt2pdfdoc( '<< /AFRelationship/' ||
        coalesce( initcap( l_ef.af_key ), 'Alternative' ) ||
        case when l_ef.descr is not null
          then '/Desc' || encode_utf16_be( l_ef.descr )
        end ||
        ' /Type /Filespec /F' ||
        encode_utf16_be( l_ef.name ) ||
        '/EF << /F ' || to_char( l_file ) || ' 0 R ' ||
        '/UF ' || to_char( l_file ) || ' 0 R ' ||
        '>> /UF ' || encode_utf16_be( l_ef.name ) || ' >>' || c_eol || 'endobj' );
    return l_self;
  end add_file_spec;
  --
  function add_outlines( p_pages number )
  return varchar2
  is
    l_self       number(10);
    l_lvl        pls_integer;
    l_tmp        pls_integer;
    l_outl_cnt   pls_integer;
    l_cur_parent pls_integer;
    l_cnt        tp_pls_tab;
    l_first      tp_pls_tab;
    l_last       tp_pls_tab;
    l_prev       tp_pls_tab;
    l_next       tp_pls_tab;
    l_parent     tp_pls_tab;
  begin
    l_outl_cnt := g_pdf.outlines.count;
    if l_outl_cnt = 0
    then
      return '';
    end if;
    l_cur_parent := -1;
    l_lvl := 0;
    for i in 0 .. l_outl_cnt - 1
    loop
      if g_pdf.outlines(i).lvl = l_lvl
      then
        if l_cnt( l_cur_parent ) > 0
        then
          l_tmp := l_last( l_cur_parent );
          l_next( l_tmp ) := i;
          l_prev( i ) := l_tmp;
        end if;
      elsif g_pdf.outlines(i).lvl > l_lvl
      then
        l_lvl := g_pdf.outlines(i).lvl;
        l_cur_parent := i - 1;
        l_cnt( l_cur_parent ) := 0;
        l_first( l_cur_parent ) := i;
      else
        l_lvl := g_pdf.outlines(i).lvl;
        for j in reverse 0 .. i - 1
        loop
          if l_lvl = g_pdf.outlines(j).lvl
          then
            l_cur_parent := l_parent( j );
            l_next( j ) := i;
            l_prev( i ) := j;
            exit;
          end if;
        end loop;
      end if;
      l_parent( i ) := l_cur_parent;
      l_last( l_cur_parent ) := i;
      l_cnt( l_cur_parent ) := l_cnt( l_cur_parent ) + 1;
    end loop;
    for i in reverse 0 .. l_outl_cnt - 1
    loop
      if l_cnt.exists( i )
      then
        l_cur_parent := l_parent( i );
         l_cnt( l_cur_parent ) := l_cnt( l_cur_parent ) + l_cnt( i );
      end if;
    end loop;
    l_self := add_object;
    txt2pdfdoc( '<</Type /Outlines'
      || ' /First ' || ( l_self + l_first( -1 ) + 1 ) || ' 0 R'
      || ' /Last '  || ( l_self + l_last( -1 ) + 1 )  || ' 0 R'
      || ' /Count ' || l_cnt( -1 ) || ' >>' || c_eol || 'endobj' );
    for i in 0 .. l_outl_cnt - 1
    loop
      add_object( '/Title ' || encode_utf16_be( g_pdf.outlines( i ).title )
        || ' /Dest [' || ( p_pages + 2 * g_pdf.outlines( i ).page ) || ' 0 R'
        || ' /XYZ 0 ' || to_char_round( g_pdf.outlines( i ).y, 2 ) || ' null]'
        || case when l_prev.exists( i )   then ' /Prev '   || ( l_self + l_prev( i ) + 1 )   || ' 0 R' end
        || case when l_next.exists( i )   then ' /Next '   || ( l_self + l_next( i ) + 1 )   || ' 0 R' end
        || case when l_first.exists( i )  then ' /First '  || ( l_self + l_first( i ) + 1 )  || ' 0 R' end
        || case when l_last.exists( i )   then ' /Last '   || ( l_self + l_last( i ) + 1 )   || ' 0 R' end
        || case when l_cnt.exists( i )    then ' /Count '  || l_cnt( i ) end
        );
    end loop;
    return ' /Outlines ' || l_self || ' 0 R /PageMode /UseOutlines ';
  end add_outlines;
  --
  function add_catalogue
  return number
  is
    l_af               number;
    l_pages            number;
    l_file_spec        number;
    l_names            varchar2(32767);
    l_metadata         varchar2(32767);
    l_openaction       varchar2(32767);
    l_outputintents    varchar2(32767);
    l_associated_files varchar2(32767);
  begin
    if g_pdf.pdf_a3_conformance is not null
    then
      if g_pdf.pdf_version < 1.6
      then
        g_pdf.pdf_version := 1.6;
      end if;
      l_outputintents :=
          '/OutputIntents [ <</Type /OutputIntent/S /GTS_PDFA1'       ||
          '/OutputConditionIdentifier (sRGB\040IEC61966\0552\0561)'   ||
          '/DestOutputProfile ' || to_char( add_dest_output_profile ) || ' 0 R' ||
           ' >> ] ';
      l_metadata := '/Metadata ' || to_char( add_meta_data( g_pdf.meta_rdf_descr ) ) || ' 0 R';
    end if;
    if g_pdf.embedded_files.count > 0
    then
      l_names := c_eol || '/Names << /EmbeddedFiles << /Names [';
      l_associated_files := '[ ';
      for i in 0 .. g_pdf.embedded_files.count - 1
      loop
        l_file_spec := add_file_spec( i );
        l_names := l_names || ' ' ||
                   encode_utf16_be( g_pdf.embedded_files( i ).name ) || ' ' ||
                   to_char( l_file_spec ) || ' 0 R';
        l_associated_files := l_associated_files || to_char( l_file_spec ) || ' 0 R ';
      end loop;
      l_names := l_names || ' ] >> >> ';
      l_associated_files := l_associated_files || ']';
      if g_pdf.pdf_a3_conformance is null
      then
        l_associated_files := null;
      else
        l_af := add_object;
        txt2pdfdoc( l_associated_files || c_eol || 'endobj' );
        l_associated_files := '/AF ' || to_char( l_af ) || ' 0 R ';
      end if;
    end if;
    l_pages := add_pages;
    if g_pdf.zoom is not null
    then
      l_openaction := '/OpenAction [' || ( l_pages + 2 ) || ' 0 R ' ||
                      '/XYZ null null ' || to_char_round( g_pdf.zoom, 5 ) || ']';
    end if;
    return add_object( '/Type/Catalog'
                     || l_outputintents || l_metadata
                     || l_names || l_associated_files
                     || '/Pages ' || to_char( l_pages ) || ' 0 R'
                     || add_outlines( l_pages )
                     || l_openaction
                     );
  end add_catalogue;
  --
  function add_info
  return number
  is
    l_self number(10);
    --
    function add_tag( p_tag varchar2, p_val varchar2 )
    return varchar2
    is
      l_tmp varchar2(32767);
    begin
      if p_val is null
      then
        return null;
      end if;
      l_tmp := rtrim( ltrim( encode_utf16_be( p_val ), ' <' ), '>' );
      if g_pdf.key is not null
      then
        l_tmp := rawtohex( encrypt_rc4( hextoraw( l_tmp ), hash_md5( utl_raw.concat( g_pdf.key, utl_raw.reverse( substr( to_char( l_self, 'fm0XXXXXXX' ), -6 ) ), '0000' ) ) ) );
      end if;
      return '/' || p_tag || ' <' || l_tmp || '>';
    end;
  begin
    l_self := add_object;
    txt2pdfdoc( '<<'
              || add_tag( 'CreationDate', to_char( sysdate, '"D:"YYYYMMDDhh24miss' ) )
              || add_tag( 'Producer',     g_pdf.producer )
              || add_tag( 'Title',        g_pdf.title )
              || add_tag( 'Author',       g_pdf.author )
              || add_tag( 'Subject',      g_pdf.subject )
              || add_tag( 'Creator',      g_pdf.creator )
              || add_tag( 'Keywords',     g_pdf.keywords )
              || '>>' || c_eol || 'endobj'
              );
    return l_self;
  end add_info;
  --
  function add_encrypt( p_pw varchar2, p_id raw )
  return number
  is
    l_o       raw(128);
    l_u       raw(128);
    l_pw      raw(128);
    l_key     raw(128);
    l_tmp     raw(3999);
    l_p       pls_integer;
    l_key_len pls_integer;
    c_pad     constant raw(32) := '28BF4E5E4E758A4164004E56FFFA01082E2E00B6D0683E802F0CA9FE6453697A';
  begin
    l_p := -4;
    l_key_len := 128 / 8; -- /Length
    l_pw := utl_i18n.string_to_raw( p_pw, 'WE8MSWIN1252' );
    l_tmp := utl_raw.substr( utl_raw.concat( l_pw, c_pad ), 1, 32 );
    for i in 1 .. 51
    loop
      l_tmp := hash_md5( l_tmp );
    end loop;
    l_key:= utl_raw.substr( l_tmp, 1, l_key_len );
    l_tmp := utl_raw.substr( utl_raw.concat( l_pw, c_pad ), 1, 32 );
    l_o := encrypt_rc4( l_tmp, l_key );
    for i in 1 .. 19
    loop
      l_o := encrypt_rc4( l_o, utl_raw.bit_xor( l_key, utl_raw.copies( to_char( i, 'fm0X' ), l_key_len ) ) );
    end loop;
    --
    l_key := hash_md5( utl_raw.concat( l_tmp
                                     , l_o
                                     , utl_raw.cast_from_binary_integer( l_p, utl_raw.little_endian )  -- waarde van /P
                                     , p_id -- waarde van /ID
--                                           , 'FFFFFFFF'  -- alleen bij /R 4
                                     )
                     );
    for i in 1 .. 50
    loop
      l_key:= utl_raw.substr( l_key, 1, l_key_len );
      l_key := hash_md5( l_key );
    end loop;
    l_key:= utl_raw.substr( l_key, 1, l_key_len );
    g_pdf.key := l_key;
    l_u := hash_md5( utl_raw.concat( c_pad, p_id ) );
    for i in 0 .. 19
    loop
      l_u := encrypt_rc4( l_u, utl_raw.bit_xor( l_key, utl_raw.copies( to_char( i, 'fm0X' ), l_key_len ) ) );
    end loop;
    l_u := utl_raw.concat( l_u, sys_guid );
    return add_object( '/Filter /Standard /V 2 /R 3'
                     || '/Length ' || ( l_key_len * 8 )
                     || '/P ' || l_p
                     || c_eol || '/O <' || l_o || '>'
                     || c_eol || '/U <' || l_u || '>'
                     );
  end add_encrypt;
  --
  procedure init_pdf( p_page_size        varchar2 := null
                    , p_page_orientation varchar2 := null
                    , p_page_width       number := null
                    , p_page_height      number := null
                    , p_margin_left      number := null
                    , p_margin_right     number := null
                    , p_margin_top       number := null
                    , p_margin_bottom    number := null
                    , p_unit             varchar2 := null
                    , p_text_direction   varchar2 := null
                    )
  is
  begin
    set_settings( p_page_size
                , p_page_orientation
                , p_page_width
                , p_page_height
                , p_margin_left
                , p_margin_right
                , p_margin_top
                , p_margin_bottom
                , p_unit
                , p_text_direction
                , g_pdf.page_settings
                );
    set_pdf_version;
    set_line_spacing_factor;
  end init_pdf;
  --
  procedure finish_pdf( p_password varchar2 := null )
  is
    l_id        raw(24);
    l_xref      number;
    l_info      number(10);
    l_encrypt   number(10);
    l_catalogue number(10);
    l_page_proc tp_page_proc;
    --
    procedure get_producer
    is
    begin
      select c_producer || ', running on ' || substr( banner, 1, 900 )
      into g_pdf.producer
      from v$version
      where instr( upper( banner )
                 , 'DATABASE'
                 ) > 0;
    exception
      when others
      then
        null;
    end;
  begin
    if g_pdf.current_page is null
    then
      new_page;
    end if;
    for i in 0 .. g_pdf.page_procs.count - 1
    loop
      l_page_proc := g_pdf.page_procs( i );
      for j in 1 .. g_pdf.pages.count
      loop
        set_current_page( j - 1 );
        if l_page_proc.page_nr >= 0 and j >= l_page_proc.page_nr
        then
          case l_page_proc.proc
            when 1
            then
              line( l_page_proc.nums( 1 )
                  , l_page_proc.nums( 2 )
                  , l_page_proc.nums( 3 )
                  , l_page_proc.nums( 4 )
                  , l_page_proc.chars( 1 )
                  , l_page_proc.nums( 5 )
                  );
            when 2
            then
              rect( l_page_proc.nums( 1 )
                  , l_page_proc.nums( 2 )
                  , l_page_proc.nums( 3 )
                  , l_page_proc.nums( 4 )
                  , l_page_proc.chars( 1 )
                  , l_page_proc.chars( 2 )
                  , l_page_proc.nums( 5 )
                  , l_page_proc.nums( 6 )
                  , l_page_proc.nums( 7 ) = 1
                  , l_page_proc.nums( 8 )
                  );
            when 3
            then
              declare
                l_steps tp_numbers;
              begin
                l_steps := tp_numbers();
                l_steps.extend( l_page_proc.nums.count - 2 );
                for i in 1 .. l_page_proc.nums.count - 2
                loop
                  l_steps( i ) := l_page_proc.nums( i + 2 );
                end loop;
                path( l_steps
                    , l_page_proc.nums( 1 )
                    , l_page_proc.chars( 1 )
                    , l_page_proc.nums( 2 )
                    );
              end;
            when 4
            then
              bezier( l_page_proc.nums( 1 )
                    , l_page_proc.nums( 2 )
                    , l_page_proc.nums( 3 )
                    , l_page_proc.nums( 4 )
                    , l_page_proc.nums( 5 )
                    , l_page_proc.nums( 6 )
                    , l_page_proc.nums( 7 )
                    , l_page_proc.nums( 8 )
                    , l_page_proc.nums( 9 )
                    , l_page_proc.chars( 1 )
                    , l_page_proc.nums( 10 )
                    );
            when 5
            then
              bezier_v( l_page_proc.nums( 1 )
                      , l_page_proc.nums( 2 )
                      , l_page_proc.nums( 3 )
                      , l_page_proc.nums( 4 )
                      , l_page_proc.nums( 5 )
                      , l_page_proc.nums( 6 )
                      , l_page_proc.nums( 7 )
                      , l_page_proc.chars( 1 )
                      , l_page_proc.nums( 8 )
                      );
            when 6
            then
              bezier_y( l_page_proc.nums( 1 )
                      , l_page_proc.nums( 2 )
                      , l_page_proc.nums( 3 )
                      , l_page_proc.nums( 4 )
                      , l_page_proc.nums( 5 )
                      , l_page_proc.nums( 6 )
                      , l_page_proc.nums( 7 )
                      , l_page_proc.chars( 1 )
                      , l_page_proc.nums( 8 )
                      );
            when 8
            then
              ellips( l_page_proc.nums( 1 )
                    , l_page_proc.nums( 2 )
                    , l_page_proc.nums( 3 )
                    , l_page_proc.nums( 4 )
                    , l_page_proc.chars( 1 )
                    , l_page_proc.chars( 2 )
                    , l_page_proc.nums( 5 )
                    , l_page_proc.nums( 6 )
                    , l_page_proc.nums( 7 ) = 1
                    , l_page_proc.nums( 8 )
                    );
            when 9
            then
              put_image( l_page_proc.nums( 1 )
                       , l_page_proc.nums( 2 )
                       , l_page_proc.nums( 3 )
                       , l_page_proc.nums( 4 )
                       , l_page_proc.nums( 5 )
                       , l_page_proc.chars( 1 )
                       , l_page_proc.chars( 2 )
                       , l_page_proc.nums( 6 )
                       );
            when 10
            then
              put_txt( l_page_proc.nums( 1 )
                     , l_page_proc.nums( 2 )
                     , replace(
                       replace( case when l_page_proc.nchar is not null
                                  then l_page_proc.nchar
                                  else l_page_proc.chars( 2 )
                                end
                              , '#PAGE_NR#', j )
                              , '#PAGE_COUNT#', g_pdf.pages.count )
                     , l_page_proc.nums( 3 )
                     , l_page_proc.nums( 4 )
                     , l_page_proc.nums( 5 )
                     , l_page_proc.chars( 1 )
                     , p_options     => l_page_proc.chars( 3 )
                     , p_alpha       => l_page_proc.nums( 6 )
                     , p_outline_lvl => l_page_proc.nums( 7 )
                     );
            when 11
            then
              multi_cell( replace(
                          replace( case when l_page_proc.nchar is not null
                                     then l_page_proc.nchar
                                     else l_page_proc.chars( 5 )
                                   end
                                 , '#PAGE_NR#', j )
                                 , '"PAGE_COUNT#', g_pdf.pages.count )
                        , l_page_proc.nums( 1 )
                        , l_page_proc.nums( 2 )
                        , l_page_proc.nums( 3 )
                        , l_page_proc.nums( 4 )
                        , l_page_proc.nums( 5 )
                        , l_page_proc.nums( 6 )
                        , l_page_proc.chars( 1 )
                        , l_page_proc.chars( 2 )
                        , l_page_proc.chars( 3 )
                        , l_page_proc.chars( 4 )
                        , l_page_proc.nums( 7 )
                        , l_page_proc.chars( 6 )
                        , l_page_proc.chars( 7 )
                        );
            when 12
            then
              annot( p_subtype    => l_page_proc.chars( 1 )
                   , p_txt        => replace(
                                     replace( case when l_page_proc.nchar is not null
                                                then l_page_proc.nchar
                                                else l_page_proc.chars( 2 )
                                              end
                                            , '#PAGE_NR#', j )
                                            , '"PAGE_COUNT#', g_pdf.pages.count )
                   , p_x          => l_page_proc.nums( 1 )
                   , p_y          => l_page_proc.nums( 2 )
                   , p_font_index => l_page_proc.nums( 3 )
                   , p_fontsize   => l_page_proc.nums( 4 )
                   , p_line_width => l_page_proc.nums( 5 )
                   , p_color      => l_page_proc.chars( 3 )
                   , p_txt_color  => l_page_proc.chars( 4 )
                   , p_url        => l_page_proc.chars( 5 )
                   );
          end case;
        end if;
      end loop;
    end loop;
    g_pdf.objects( 0 ) := 0;
    dbms_lob.createtemporary( g_pdf.pdf_blob, true );
    txt2pdfdoc( '%PDF-' || to_char( g_pdf.pdf_version, 'fm9.9' ) );
    raw2pdfdoc( hextoraw( '25E2E3CFD30D0A' ) ); -- add a hex comment
    l_id := sys_guid;
    if p_password is not null
    then
      l_encrypt := add_encrypt( p_password, l_id );
    end if;
    get_producer;
    l_info := add_info;
    l_catalogue := add_catalogue;
    l_xref := dbms_lob.getlength( g_pdf.pdf_blob );
    txt2pdfdoc( 'xref' );
    txt2pdfdoc( '0 ' || to_char( g_pdf.objects.count ) );
    txt2pdfdoc( '0000000000 65535 f' );
    for i in 1 .. g_pdf.objects.count - 1
    loop
      txt2pdfdoc( to_char( g_pdf.objects( i ), 'fm0000000000' ) || ' 00000 n' );
    end loop;
    txt2pdfdoc( 'trailer' );
    txt2pdfdoc( '<</Root ' || to_char( l_catalogue ) || ' 0 R'
              || '/Info ' || to_char( l_info ) || ' 0 R'
              || case when l_encrypt is not null then '/Encrypt ' || l_encrypt || ' 0 R' end
              || '/Size ' || to_char( g_pdf.objects.count )
              || '/ID [<' || l_id || '><' || sys_guid || '>]'
              || '>>' );
    txt2pdfdoc( 'startxref' || c_eol || to_char( l_xref ) || c_eol ||  '%%EOF' );
    --
    cleanup;
    --
    if     p_password is not null
       and g_pdf.pdf_a3_conformance is not null
    then
      dbms_lob.freetemporary( g_pdf.pdf_blob );
      raise_application_error( -20027, 'A PDF/A file can not be encrypted.' );
    end if;
  end finish_pdf;
  --
  procedure add_page_proc
    ( p_proc    pls_integer
    , p_page_nr pls_integer
    , p_nums    tp_numbers   := null
    , p_chars   tp_varchar2s := null
    , p_nchar   nvarchar2    := null
    )
  is
  begin
$IF dbms_db_version.ver_le_11
$THEN
    declare
      l_pp tp_page_proc;
    begin
      l_pp.page_nr := p_page_nr;
      l_pp.proc := p_proc;
      l_pp.nums := p_nums;
      l_pp.chars := p_chars;
      l_pp.nchar := p_nchar;
      g_pdf.page_procs( g_pdf.page_procs.count ) := l_pp;
    end;
$ELSIF dbms_db_version.ver_le_12
$THEN
    declare
      l_pp tp_page_proc;
    begin
      l_pp.page_nr := p_page_nr;
      l_pp.proc := p_proc;
      l_pp.nums := p_nums;
      l_pp.chars := p_chars;
      l_pp.nchar := p_nchar;
      g_pdf.page_procs( g_pdf.page_procs.count ) := l_pp;
    end;
$ELSE
    g_pdf.page_procs( g_pdf.page_procs.count ) :=
      tp_page_proc( p_page_nr, p_proc, p_nums, p_chars, p_nchar );
$END
  end add_page_proc;
  --
  procedure graphics_init_and_set_line
    ( p_line_width number
    , p_line_color varchar2
    )
  is
  begin
    txt2page( 'q ' || to_char_round( coalesce( case when p_line_width != 0 then p_line_width end, c_default_line_width ), 5 ) || ' w' );
    if p_line_color is not null
    then
      txt2page( rgb( p_color => p_line_color ) || 'RG' );
    elsif g_pdf.bk_color is null
    then
      txt2page( '0 G' );
    end if;
  end graphics_init_and_set_line;
  --
  procedure graphics_init_and_fill
    ( p_line_width number
    , p_fill_color varchar2
    , p_line_color varchar2
    )
  is
  begin
    txt2page( 'q ' || to_char_round( coalesce( case when p_line_width != 0 then p_line_width end, c_default_line_width ), 5 ) || ' w' );
    if p_line_color is not null
    then
      txt2page( rgb( p_color => p_line_color ) || 'RG' );
    elsif g_pdf.bk_color is null
    then
      txt2page( ' 0 G' );
    end if;
    if p_fill_color is not null
    then
      txt2page( rgb( p_color => p_fill_color ) || 'rg' );
    elsif g_pdf.color is null
    then
      txt2page( ' 1 g' );
    end if;
  end graphics_init_and_fill;
  --
  procedure graphics_close( p_transparant boolean )
  is
  begin
    if p_transparant
    then
      txt2page( ' s Q' );
    else
      txt2page( ' b Q' );
    end if;
  end graphics_close;
  --
  procedure add_alpha( p_alpha number, p_blend_mode varchar2 := null )
  is
    l_idx pls_integer;
    l_egs tp_extgstate;
  begin
    if p_alpha is null or p_alpha not between 0 and 1
    then
      return;
    end if;
    l_idx := g_pdf.egs_dir.first;
    loop
      exit when l_idx is null;
      l_egs := g_pdf.egs_dir( l_idx );
      exit when l_egs.stroking_alpha = p_alpha
            and l_egs.non_stroking_alpha = p_alpha
            and (  ( p_blend_mode is null and l_egs.blend_mode is null )
                or p_blend_mode = l_egs.blend_mode
                );
      l_idx := g_pdf.egs_dir.next( l_idx );
    end loop;
    if l_idx is null
    then
      l_idx := g_pdf.egs_dir.count + 1;
      l_egs.blend_mode := p_blend_mode;
      l_egs.stroking_alpha := p_alpha;
      l_egs.non_stroking_alpha := p_alpha;
      g_pdf.egs_dir( l_idx ) := l_egs;
    end if;
    txt2page( ' /GS' || l_idx || ' gs ' );
  end add_alpha;
  --
  procedure line
    ( p_x1         number
    , p_y1         number
    , p_x2         number
    , p_y2         number
    , p_line_width number      := null
    , p_line_color varchar2    := null
    , p_alpha      number      := null
    , p_page_proc  pls_integer := null
    )
  is
  begin
    if p_page_proc is null
    then
      graphics_init_and_set_line( p_line_width, p_line_color );
      add_alpha( p_alpha );
      txt2page(  to_char_round( p_x1, 5 ) || ' '
              || to_char_round( p_y1, 5 ) || ' m '
              || to_char_round( p_x2, 5 ) || ' '
              || to_char_round( p_y2, 5 ) || ' l b'
              || ' Q'
              );
    else
      add_page_proc( 1, p_page_proc
                   , p_nums  => tp_numbers( p_x1, p_y1, p_x2, p_y2, p_line_width, p_alpha )
                   , p_chars => tp_varchar2s( p_line_color )
                   );
    end if;
  end line;
  --
  procedure horizontal_line
    ( p_x          number
    , p_y          number
    , p_width      number
    , p_line_width number      := null
    , p_line_color varchar2    := null
    , p_alpha      number      := null
    , p_page_proc  pls_integer := null
    )
  is
  begin
    line( p_x, p_y, p_x + p_width, p_y, p_line_width, p_line_color, p_page_proc );
  end horizontal_line;
  --
  procedure vertical_line
    ( p_x          number
    , p_y          number
    , p_height     number
    , p_line_width number      := null
    , p_line_color varchar2    := null
    , p_alpha      number      := null
    , p_page_proc  pls_integer := null
    )
  is
  begin
    line( p_x, p_y, p_x, p_y + p_height, p_line_width, p_line_color, p_page_proc );
  end vertical_line;
  --
  procedure rect
    ( p_x           number
    , p_y           number
    , p_width       number
    , p_height      number
    , p_line_color  varchar2    := null
    , p_fill_color  varchar2    := null
    , p_line_width  number      := null
    , p_radius      number      := null
    , p_transparant boolean     := null
    , p_alpha       number      := null
    , p_page_proc   pls_integer := null
    )
  is
    l_a      number;
    l_b      number;
    l_radius number;
  begin
    if p_page_proc is null
    then
      graphics_init_and_fill( p_line_width, p_fill_color, p_line_color );
      add_alpha( p_alpha );
      if p_radius > 0
      then
        l_radius := least( p_radius, p_width / 2, p_height / 2);
        l_a := l_radius;
        l_b := .55228474983 * l_radius;
      txt2page(  ' 1 0 0 1 '
              || to_char_round( p_x, 5 ) || ' ' || to_char_round( p_y, 5 ) || ' cm '
              || to_char_round( l_radius, 5 ) || ' ' || to_char_round( 0, 5 ) || ' m '
              || to_char_round( - l_b + l_radius, 5 ) || ' ' || to_char_round( - l_a + l_radius, 5 ) || ' '
              || to_char_round( - l_a + l_radius, 5 ) || ' ' || to_char_round( - l_b + l_radius, 5 ) || ' '
              || to_char_round( 0, 5 ) || ' ' || to_char_round( l_radius, 5 ) || ' c '
              || to_char_round( 0, 5 ) || ' ' || to_char_round( p_height - l_radius, 5 ) || ' l '
              || to_char_round( - l_a + l_radius, 5 ) || ' ' || to_char_round( l_b - l_radius + p_height, 5 ) || ' '
              || to_char_round( - l_b + l_radius, 5 ) || ' ' || to_char_round( l_a - l_radius + p_height, 5 ) || ' '
              || to_char_round( l_radius, 5 ) || ' ' || to_char_round( p_height, 5 ) || ' c '
              || to_char_round( p_width - l_radius, 5 ) || ' ' || to_char_round( p_height, 5 ) || ' l '
              || to_char_round( l_b - l_radius + p_width, 5 ) || ' ' || to_char_round( l_a - l_radius + p_height, 5 ) || ' '
              || to_char_round( l_a - l_radius+ p_width, 5 ) || ' ' || to_char_round( l_b - l_radius + p_height, 5 ) || ' '
              || to_char_round( p_width, 5 ) || ' ' || to_char_round( p_height - l_radius, 5 ) || ' c '
              || to_char_round( p_width, 5 ) || ' ' || to_char_round( l_radius, 5 ) || ' l '
              || to_char_round( l_a + p_width - l_radius, 5 ) || ' ' || to_char_round( l_radius - l_b, 5 ) || ' '
              || to_char_round( l_b + p_width - l_radius, 5 ) || ' ' || to_char_round( l_radius - l_a, 5 ) || ' '
              || to_char_round( p_width - l_radius, 5 ) || ' ' || to_char_round( 0, 5 ) || ' c '
              );
      else
        txt2page(  to_char_round( p_x, 5 ) || ' ' || to_char_round( p_y, 5 ) || ' '
                || to_char_round( p_width, 5 ) || ' ' || to_char_round( p_height, 5 ) || ' re '
                );
      end if;
      graphics_close( p_transparant );
    else
      add_page_proc( 2, p_page_proc
                   , p_nums  => tp_numbers( p_x, p_y, p_width, p_height, p_line_width, p_radius, case when p_transparant then 1 else 0 end, p_alpha )
                   , p_chars => tp_varchar2s( p_fill_color, p_line_color )
                   );
    end if;
  end rect;
  --
  procedure path
    ( p_steps      tp_numbers
    , p_line_width number      := null
    , p_line_color varchar2    := null
    , p_alpha      number      := null
    , p_page_proc  pls_integer := null
    )
  is
    l_path  varchar2(32767);
    l_first pls_integer;
    l_nums  tp_numbers;
  begin
    if    p_steps.count < 4
       or mod( p_steps.count, 2 ) != 0
       or p_steps.last != p_steps.first + p_steps.count - 1
    then
      return;
    end if;
    if p_page_proc is null
    then
      graphics_init_and_set_line( p_line_width, p_line_color );
      add_alpha( p_alpha );
      l_first := p_steps.first;
      l_path :=   to_char_round( p_steps( l_first ), 5 )     || ' '
               || to_char_round( p_steps( l_first + 1 ), 5 ) || ' m ';
      for i in 1 .. p_steps.count / 2 - 1
      loop
        l_path := l_path || to_char_round( p_steps( l_first + 2 * i ), 5 ) || ' '
                  || to_char_round( p_steps( l_first + 2 * i + 1), 5 ) || ' l ';
      end loop;
      txt2page( l_path || 'S Q' );
    else
      l_nums := tp_numbers();
      l_nums.extend( p_steps.count + 2 );
      l_nums( 1 ) := p_line_width;
      l_nums( 2 ) := p_alpha;
      for i in 1 .. p_steps.count
      loop
        l_nums( i + 2 ) := p_steps( i );
      end loop;
      add_page_proc( 3, p_page_proc
                   , p_nums  => l_nums
                   , p_chars => tp_varchar2s( p_line_color )
                   );
    end if;
  end path;
  --
  procedure bezier
    ( p_x1         number
    , p_y1         number
    , p_x2         number
    , p_y2         number
    , p_x3         number
    , p_y3         number
    , p_x4         number
    , p_y4         number
    , p_line_width number      := null
    , p_line_color varchar2    := null
    , p_alpha      number      := null
    , p_page_proc  pls_integer := null
    )
  is
  begin
    if p_page_proc is null
    then
      graphics_init_and_set_line( p_line_width, p_line_color );
      add_alpha( p_alpha );
      txt2page( to_char_round( p_x1, 5 ) || ' ' || to_char_round( p_y1, 5 )
              || ' m '
              || to_char_round( p_x2, 5 ) || ' ' || to_char_round( p_y2, 5 ) || ' '
              || to_char_round( p_x3, 5 ) || ' ' || to_char_round( p_y3, 5 ) || ' '
              || to_char_round( p_x4, 5 ) || ' ' || to_char_round( p_y4, 5 )
              || ' c S Q'
              );
    else
      add_page_proc( 4, p_page_proc
                   , p_nums  => tp_numbers( p_x1, p_y1, p_x2, p_y2, p_x3, p_y3, p_x4, p_y4, p_line_width, p_alpha )
                   , p_chars => tp_varchar2s( p_line_color )
                   );
    end if;
  end bezier;
  --
  procedure bezier_v
    ( p_x1         number
    , p_y1         number
    , p_x2         number
    , p_y2         number
    , p_x3         number
    , p_y3         number
    , p_line_width number      := null
    , p_line_color varchar2    := null
    , p_alpha      number      := null
    , p_page_proc  pls_integer := null
    )
  is
  begin
    if p_page_proc is null
    then
      graphics_init_and_set_line( p_line_width, p_line_color );
      add_alpha( p_alpha );
      txt2page( to_char_round( p_x1, 5 ) || ' ' || to_char_round( p_y1, 5 )
              || ' m '
              || to_char_round( p_x2, 5 ) || ' ' || to_char_round( p_y2, 5 ) || ' '
              || to_char_round( p_x3, 5 ) || ' ' || to_char_round( p_y3, 5 ) || ' '
              || ' v S Q'
              );
    else
      add_page_proc( 5, p_page_proc
                   , p_nums  => tp_numbers( p_x1, p_y1, p_x2, p_y2, p_x3, p_y3, p_line_width, p_alpha )
                   , p_chars => tp_varchar2s( p_line_color )
                   );
    end if;
  end bezier_v;
  --
  procedure bezier_y
    ( p_x1         number
    , p_y1         number
    , p_x2         number
    , p_y2         number
    , p_x3         number
    , p_y3         number
    , p_line_width number      := null
    , p_line_color varchar2    := null
    , p_alpha      number      := null
    , p_page_proc  pls_integer := null
    )
  is
  begin
    if p_page_proc is null
    then
      graphics_init_and_set_line( p_line_width, p_line_color );
      add_alpha( p_alpha );
      txt2page( to_char_round( p_x1, 5 ) || ' ' || to_char_round( p_y1, 5 )
              || ' m '
              || to_char_round( p_x2, 5 ) || ' ' || to_char_round( p_y2, 5 ) || ' '
              || to_char_round( p_x3, 5 ) || ' ' || to_char_round( p_y3, 5 ) || ' '
              || ' y S Q'
              );
    else
      add_page_proc( 6, p_page_proc
                   , p_nums  => tp_numbers( p_x1, p_y1, p_x2, p_y2, p_x3, p_y3, p_line_width, p_alpha )
                   , p_chars => tp_varchar2s( p_line_color )
                   );
    end if;
  end bezier_y;
  --
  procedure circle
    ( p_x           number
    , p_y           number
    , p_radius      number
    , p_line_color  varchar2 := null
    , p_fill_color  varchar2 := null
    , p_line_width  number   := null
    , p_transparant boolean     := false
    , p_alpha       number      := null
    , p_page_proc   pls_integer := null
    )
  is
  begin
    ellips( p_x            => p_x
          , p_y            => p_y
          , p_major_radius => p_radius
          , p_minor_radius => p_radius
          , p_line_color   => p_line_color
          , p_fill_color   => p_fill_color
          , p_line_width   => p_line_width
          , p_transparant  => p_transparant
          , p_alpha        => p_alpha
          , p_page_proc    => p_page_proc
          );
  end circle;
  --
  procedure ellips
    ( p_x                number -- central point
    , p_y                number -- central point
    , p_major_radius     number
    , p_minor_radius     number
    , p_line_color       varchar2    := null
    , p_fill_color       varchar2    := null
    , p_line_width       number      := null
    , p_degrees_rotation number      := null
    , p_transparant      boolean     := false
    , p_alpha            number      := null
    , p_page_proc        pls_integer := null
    )
  is
    l_a constant number := p_minor_radius;
    l_b constant number := .55228474983 * p_minor_radius;
    l_c constant number := p_major_radius;
    l_d constant number := .55228474983 * p_major_radius;
    l_sin number;
    l_cos number;
    l_rad number;
    l_tmp varchar2(1000);
  begin
    if p_page_proc is null
    then
      graphics_init_and_fill( p_line_width, p_fill_color, p_line_color );
      add_alpha( p_alpha );
      if coalesce( p_degrees_rotation, 0 ) != 0
      then
        l_rad := p_degrees_rotation / 180 * 3.14159265358979323846264338327950288419716939937510;
        l_sin := sin( l_rad );
        l_cos := cos( l_rad );
        l_tmp := to_char_round( l_cos, 5 )   || ' ' || to_char_round( - l_sin, 5 )
              || ' ' || to_char_round( l_sin, 5 )   || ' ' || to_char_round( l_cos, 5 )
              || ' 0 0 cm ';
      end if;
      txt2page(  ' 1 0 0 1 '
              || to_char_round( p_x, 5 ) || ' ' || to_char_round( p_y, 5 ) || ' cm '
              || l_tmp
              || to_char_round( 0, 5 ) || ' ' || to_char_round( l_a, 5 ) || ' m '
              || to_char_round( l_d, 5 ) || ' ' || to_char_round( l_a, 5 ) || ' '
              || to_char_round( l_c, 5 ) || ' ' || to_char_round( l_b, 5 ) || ' '
              || to_char_round( l_c, 5 ) || ' ' || to_char_round( 0, 5 ) || ' c '
              || to_char_round( l_c, 5 ) || ' ' || to_char_round( - l_b, 5 ) || ' '
              || to_char_round( l_d, 5 ) || ' ' || to_char_round( - l_a, 5 ) || ' '
              || to_char_round( 0, 5 ) || ' ' || to_char_round( - l_a, 5 ) || ' c '
              || to_char_round( - l_d, 5 ) || ' ' || to_char_round( - l_a, 5 ) || ' '
              || to_char_round( - l_c, 5 ) || ' ' || to_char_round( - l_b, 5 ) || ' '
              || to_char_round( - l_c, 5 ) || ' ' || to_char_round( 0, 5 ) || ' c '
              || to_char_round( - l_c, 5 ) || ' ' || to_char_round( l_b, 5 ) || ' '
              || to_char_round( - l_d, 5 ) || ' ' || to_char_round( l_a, 5 ) || ' '
              || to_char_round( 0, 5 ) || ' ' || to_char_round( l_a, 5 ) || ' c '
              );
      graphics_close( p_transparant );
    else
      add_page_proc( 8, p_page_proc
                   , p_nums  => tp_numbers( p_x, p_y, p_major_radius, p_minor_radius, p_line_width, p_degrees_rotation, case when p_transparant then 1 else 0 end, p_alpha )
                   , p_chars => tp_varchar2s( p_line_color, p_fill_color )
                   );
    end if;
  end ellips;
  --
  procedure annot
    ( p_subtype    varchar2
    , p_txt        varchar2 character set any_cs
    , p_x          number
    , p_y          number
    , p_font_index pls_integer := null
    , p_fontsize   number      := null
    , p_line_width number      := null
    , p_txt_color  varchar2    := null
    , p_color      varchar2    := null
    , p_url        varchar2    := null
    , p_put_txt    boolean     := true
    , p_page_proc  pls_integer := null
    )
  is
    l_annot      tp_annot;
    l_font       tp_font;
    l_top        number;
    l_fontsize   number;
    l_font_index pls_integer;
  begin
    if p_txt is null
    then
      return;
    end if;
    if p_page_proc is null
    then
      l_font_index := gfi( p_font_index );
      l_font := g_pdf.fonts( l_font_index );
      l_fontsize := coalesce( p_fontsize, l_font.fontsize, c_default_fontsize );
      if p_put_txt
      then
        put_txt( p_x, p_y, p_txt, null, l_font_index, l_fontsize, p_txt_color );
      end if;
      l_annot.subtype := p_subtype;
      l_annot.url := p_url;
      l_annot.color := p_color;
      l_annot.extra := case p_subtype
                         when 'Underline' then ( abs( l_font.descent ) + coalesce( l_font.underline_pos, -100 ) ) * l_fontsize / 1000
                         when 'StrikeOut' then ( abs( l_font.descent ) + coalesce( l_font.strikeout_pos, 0.5 * l_font.ascent ) ) * l_fontsize / 1000
                         else 0
                       end;
      l_annot.width := 0;
      l_annot.lt_x := p_x;
      l_annot.lt_y := p_y + l_font.ascent * l_fontsize / 1000;
      l_annot.rb_x := p_x + str_len( p_txt, l_font_index, l_fontsize );
      l_annot.rb_y := p_y + l_font.descent * l_fontsize / 1000;
      g_pdf.pages( g_pdf.current_page ).annots( g_pdf.pages( g_pdf.current_page ).annots.count + 1 ) := l_annot;
    else
      add_page_proc( 12, p_page_proc
                   , p_nums  => tp_numbers( p_x, p_y, p_font_index, p_fontsize, p_line_width )
                   , p_chars => tp_varchar2s( p_subtype, p_txt, p_txt_color, p_color, p_url )
                   , p_nchar => case when isnchar( p_txt ) then p_txt end
                   );
    end if;
  end annot;
  --
  procedure underline
    ( p_txt        varchar2 character set any_cs
    , p_x          number
    , p_y          number
    , p_font_index pls_integer := null
    , p_fontsize   number      := null
    , p_line_width number      := null
    , p_color      varchar2    := null
    , p_txt_color  varchar2    := null
    , p_page_proc  pls_integer := null
    )
  is
  begin
    annot( p_subtype    => 'Underline'
         , p_txt        => p_txt
         , p_x          => p_x
         , p_y          => p_y
         , p_font_index => p_font_index
         , p_fontsize   => p_fontsize
         , p_line_width => p_line_width
         , p_color      => p_color
         , p_txt_color  => p_txt_color
         , p_page_proc  => p_page_proc
         );
  end underline;
  --
  procedure strikeout
    ( p_txt        varchar2 character set any_cs
    , p_x          number
    , p_y          number
    , p_font_index pls_integer := null
    , p_fontsize   number      := null
    , p_line_width number      := null
    , p_color      varchar2    := null
    , p_txt_color  varchar2    := null
    , p_page_proc  pls_integer := null
    )
  is
  begin
    annot( p_subtype    => 'StrikeOut'
         , p_txt        => p_txt
         , p_x          => p_x
         , p_y          => p_y
         , p_font_index => p_font_index
         , p_fontsize   => p_fontsize
         , p_line_width => p_line_width
         , p_color      => p_color
         , p_txt_color  => p_txt_color
         , p_page_proc  => p_page_proc
         );
  end strikeout;
  --
  procedure link
    ( p_txt        varchar2 character set any_cs
    , p_url        varchar2
    , p_x          number
    , p_y          number
    , p_font_index pls_integer := null
    , p_fontsize   number      := null
    , p_color      varchar2    := null
    , p_page_proc  pls_integer := null
    )
  is
  begin
    if p_txt is null or p_url is null
    then
      return;
    end if;
    annot( p_subtype    => 'Link'
         , p_txt        => p_txt
         , p_x          => p_x
         , p_y          => p_y
         , p_font_index => p_font_index
         , p_fontsize   => p_fontsize
         , p_url        => p_url
         , p_txt_color  => p_color
         , p_page_proc  => p_page_proc
         );
  end link;
  --
  function get( p_what pls_integer
              , p_idx  pls_integer := null
              )
  return number
  is
  begin
    return
      case p_what
        when c_get_cp_page_width     then g_pdf.pages( g_pdf.current_page ).settings.page_width
        when c_get_cp_page_height    then g_pdf.pages( g_pdf.current_page ).settings.page_height
        when c_get_cp_margin_top     then g_pdf.pages( g_pdf.current_page ).settings.margin_top
        when c_get_cp_margin_right   then g_pdf.pages( g_pdf.current_page ).settings.margin_right
        when c_get_cp_margin_bottom  then g_pdf.pages( g_pdf.current_page ).settings.margin_bottom
        when c_get_cp_margin_left    then g_pdf.pages( g_pdf.current_page ).settings.margin_left
        when c_get_pdf_page_width    then g_pdf.page_settings.page_width
        when c_get_pdf_page_height   then g_pdf.page_settings.page_height
        when c_get_pdf_margin_top    then g_pdf.page_settings.margin_top
        when c_get_pdf_margin_right  then g_pdf.page_settings.margin_right
        when c_get_pdf_margin_bottom then g_pdf.page_settings.margin_bottom
        when c_get_pdf_margin_left   then g_pdf.page_settings.margin_left
        when c_get_x                 then g_pdf.x
        when c_get_y                 then g_pdf.y
        when c_get_fontsize          then g_pdf.fonts( g_pdf.current_font ).fontsize
        when c_get_current_font      then g_pdf.current_font
        when c_get_total_fonts       then g_pdf.fonts.count
        when c_get_total_pages       then g_pdf.pages.count
        when c_get_current_page      then g_pdf.current_page
        when c_get_font_win_ascent   then g_pdf.fonts( coalesce( p_idx, g_pdf.current_font ) ).win_ascent
        when c_get_font_win_descent  then g_pdf.fonts( coalesce( p_idx, g_pdf.current_font ) ).win_descent
      end;
  end get;
  --
  function get_string
    ( p_what pls_integer
    , p_idx  pls_integer := null
    )
  return varchar2
  is
  begin
    return
      case p_what
        when c_get_font_name   then g_pdf.fonts( coalesce( p_idx, g_pdf.current_font ) ).fontname
        when c_get_font_style  then g_pdf.fonts( coalesce( p_idx, g_pdf.current_font ) ).style
        when c_get_font_family then g_pdf.fonts( coalesce( p_idx, g_pdf.current_font ) ).family
      end;
  end get_string;
  --
  function get_font_index
    ( p_fontname varchar2 := null
    , p_family   varchar2 := null
    , p_style    varchar2 := null
    )
  return pls_integer
  is
    l_index    pls_integer;
    l_style    varchar2(100);
    l_family   varchar2(100);
    l_fontname varchar2(100);
  begin
    l_fontname := lower( p_fontname );
    l_family   := lower( p_family );
    l_style := upper( substr( p_style, 1, 1 ) );
    l_style := case l_style
                 when 'N' then 'N' -- Normal
                 when 'R' then 'N' -- Regular
                 when 'B' then 'B' -- Bold
                 when 'I' then 'I' -- Italic
                 when 'O' then 'I' -- Oblique
                 else null
               end;
    l_index := g_pdf.fonts.first;
    loop
      exit when l_index is null
             or lower( g_pdf.fonts( l_index ).fontname ) = l_fontname
             or (   g_pdf.fonts( l_index ).family = l_family
                and (  p_style is null
                    or g_pdf.fonts( l_index ).style = l_style
                    )
                );
      l_index := g_pdf.fonts.next( l_index );
    end loop;
    return l_index;
  end get_font_index;
  --
  procedure set_font
    ( p_index       pls_integer
    , p_fontsize_pt number := null
    )
  is
    l_index    pls_integer;
    l_fontsize number;
  begin
    if     p_index is not null
       and not g_pdf.fonts.exists( p_index )
    then
      return;
    end if;
    l_index := coalesce( p_index, g_pdf.current_font, g_pdf.fonts.first );
    if l_index is not null
    then
      g_pdf.fonts_used := true;
      if g_pdf.current_page is null
      then
        new_page;
      end if;
      if l_index != coalesce( g_pdf.current_font, - l_index )
      then
        g_pdf.current_font := l_index;
        l_fontsize := coalesce( p_fontsize_pt, g_pdf.fonts( p_index ).fontsize, c_default_fontsize );
        g_pdf.fonts( l_index ).fontsize := l_fontsize;
        font2page( l_index, l_fontsize );
      elsif    g_pdf.fonts( l_index ).fontsize is null
            or g_pdf.fonts( l_index ).fontsize != p_fontsize_pt
      then
        l_fontsize := coalesce( p_fontsize_pt, c_default_fontsize );
        g_pdf.fonts( l_index ).fontsize := l_fontsize;
        font2page( l_index, l_fontsize );
      end if;
    end if;
  end set_font;
  --
  procedure set_font
    ( p_fontname    varchar2
    , p_fontsize_pt number := null
    )
  is
  begin
    set_font( p_index       => get_font_index( p_fontname => p_fontname )
            , p_fontsize_pt => p_fontsize_pt
            );
  end set_font;
  --
  procedure set_font
    ( p_family      varchar2
    , p_style       varchar2 := 'N'
    , p_fontsize_pt number   := null
    )
  is
  begin
    set_font( p_index       => get_font_index( p_family => coalesce( p_family
                                                                   , case when g_pdf.current_font is not null then g_pdf.fonts( g_pdf.current_font ).family end
                                                                   )
                                             , p_style  => p_style
                                             )
            , p_fontsize_pt => p_fontsize_pt
            );
  end set_font;
  --
  function parse_png( p_img_blob blob )
  return tp_img
  is
    l_img        tp_img;
    l_pix        blob;
    l_pix2       blob;
    l_len        integer;
    l_ind        integer;
    l_ihdr       raw(3999);
    l_trns       raw(3999);
    l_tmp        raw(32767);
    l_line       raw(32767);
    l_alpha      pls_integer;
    l_alpha_len  pls_integer;
    l_pixel_len  number;
    l_hdl        pls_integer;
    l_color_type pls_integer;
    l_interlace  pls_integer;
    l_smask_len  pls_integer;
    l_mod        pls_integer;
    l_byte       pls_integer;
    l_bytes_line pls_integer;
    l_blob_smask boolean;
    l_prior      tp_pls_tab;
    l_current    tp_pls_tab;
    l_bytes      tp_pls_tab;
    l_fmt        varchar2(100);
    l_trn        varchar2(32767);
    l_buf        varchar2(32767);
    type tp_bit_calc is table of pls_integer;
    l_bit_ands tp_bit_calc;
    l_bit_divs tp_bit_calc;
    --
    procedure method0_decompress
    is
    begin
      l_pix := hextoraw( '1F8B0800000000000003' );
      l_len := dbms_lob.getlength( l_img.pixels );
      if  l_len < 32757
      then
        l_pix := utl_raw.concat( l_pix, dbms_lob.substr( l_img.pixels, l_len - 6, 3 ) );
      else
        dbms_lob.copy( l_pix, l_img.pixels, l_len - 6, 11, 3 );
      end if;
      dbms_lob.createtemporary( l_pix2, true );
      l_hdl := utl_compress.lz_uncompress_open( l_pix );
      loop
        begin
          utl_compress.lz_uncompress_extract( l_hdl, l_tmp );
          dbms_lob.writeappend( l_pix2, utl_raw.length( l_tmp ), l_tmp );
        exception
          when no_data_found then exit;
        end;
      end loop;
      utl_compress.lz_uncompress_close( l_hdl );
      dbms_lob.freetemporary( l_pix );
    end method0_decompress;
    --
    procedure method0_compress
    is
    begin
      l_img.pixels :=  hextoraw( '789C' );
      dbms_lob.copy( l_img.pixels, utl_compress.lz_compress( l_pix ), dbms_lob.lobmaxsize, 3, 11  );
      dbms_lob.trim( l_img.pixels, dbms_lob.getlength( l_img.pixels ) - 8 );
      dbms_lob.writeappend( l_img.pixels, 4, adler32( l_pix ) );
      dbms_lob.freetemporary( l_pix );
    end method0_compress;
    --
    function PaethPredictor( a pls_integer, b pls_integer, c pls_integer )
    return pls_integer
    is
      l_p pls_integer := a + b - c;
    begin
      return
         case
           when     abs( l_p - a ) <= abs( l_p - b )
                and abs( l_p - a ) <= abs( l_p - c )
           then a
           when abs( l_p - b ) <= abs( l_p - c )
           then b
           else c
         end;
    end PaethPredictor;
    --
    procedure method0_filter
       ( p_sub_filter varchar2
       , p_start_idx pls_integer
       , p_end_idx   pls_integer
       , p_sub       pls_integer
       )
    is
    begin
      if p_sub_filter = '01'    -- Sub
      then
        for j in p_start_idx .. p_end_idx
        loop
          l_current( j ) := bitand( l_current( j ) + l_current( j - p_sub ), 255 );
        end loop;
      elsif p_sub_filter = '02' -- Up
      then
        for j in p_start_idx .. p_end_idx
        loop
          l_current( j ) := bitand( l_current( j ) + l_prior( j ), 255 );
        end loop;
      elsif p_sub_filter = '03' -- Average
      then
        for j in p_start_idx .. p_end_idx
        loop
          l_current( j ) := bitand( l_current( j ) + trunc( ( l_prior( j ) + l_current( j - p_sub ) ) / 2 ), 255 );
        end loop;
      elsif p_sub_filter = '04' -- Paeth
      then
        for j in p_start_idx .. p_end_idx
        loop
            l_current( j ) := bitand( l_current( j ) + PaethPredictor( l_current( j - p_sub ), l_prior( j ), l_prior( j - p_sub ) ), 255 );
        end loop;
      end if;
    end method0_filter;
    --
    procedure adam7_pass( p_x pls_integer, p_y pls_integer, p_dx pls_integer, p_dy pls_integer )
    is
      l_sub         pls_integer;
      l_line_bytes  pls_integer;
      l_line_pixels pls_integer;
      l_x           number;
      l_y           pls_integer;
    begin
      if    l_ind > dbms_lob.getlength( l_pix2 )
         or p_x >= l_img.width
         or p_y >= l_img.height
      then
        return;
      end if;
      l_sub := ceil( l_pixel_len + l_alpha_len );
      l_line_pixels := floor( ( l_img.width - 1 - p_x ) / p_dx ) + 1;
      l_line_bytes := ceil( l_line_pixels * ( l_pixel_len + l_alpha_len ) );
      if l_img.color_res = 1
      then
        l_mod := 8;
        l_bit_ands := tp_bit_calc( 128, 64, 32, 16, 8, 4, 2, 1 );
        l_bit_divs := tp_bit_calc( 128, 64, 32, 16, 8, 4, 2, 1 );
      elsif l_img.color_res = 2
      then
        l_mod := 4;
        l_bit_ands := tp_bit_calc( 192, 48, 12, 3 );
        l_bit_divs := tp_bit_calc( 64, 16, 4, 1 );
      elsif l_img.color_res = 4
      then
        l_mod := 2;
        l_bit_ands := tp_bit_calc( 240, 15 );
        l_bit_divs := tp_bit_calc( 16, 1 );
      end if;
      for j in - 8 .. l_line_bytes - 1
      loop
        l_prior( j ) := 0;
        l_current( j )  := 0;
      end loop;
      for i in 0 .. floor( ( l_img.height - 1 - p_y ) / p_dy )
      loop
        l_line := dbms_lob.substr( l_pix2, 1 + l_line_bytes, l_ind );
        l_ind := l_ind + 1 + l_line_bytes;
        continue when l_line is null or utl_raw.length( l_line ) = 1;
        for j in 0 .. l_line_bytes - 1
        loop
          l_current( j ) := raw2num( l_line, 2 + j, 1 );
        end loop;
        method0_filter( utl_raw.substr( l_line, 1, 1 ), 0, l_line_bytes - 1, l_sub );
        --
        if l_img.color_res < 8
        then
          l_y :=  ( p_y + i * p_dy ) * ceil( l_img.width * l_pixel_len );
          for j in 0 .. floor( ( l_img.width - 1 - p_x ) / p_dx )
          loop
            l_byte := bitand( l_current( trunc( j * l_pixel_len ) ), l_bit_ands( mod( j, l_mod ) + 1 ) );
            l_byte := l_byte / l_bit_divs( mod( j, l_mod ) + 1 );
            l_x := ( p_x + j * p_dx ) * l_pixel_len;
            l_bytes( trunc( l_x + l_y ) ) := l_bytes( trunc( l_x ) + l_y ) + l_byte * l_bit_divs( mod( p_x + j * p_dx, l_mod ) + 1 );
          end loop;
        else
          l_y :=  ( p_y + i * p_dy ) * ceil( l_img.width * ( l_pixel_len + l_alpha_len ) );
          for j in 0 .. floor( ( l_img.width - 1 - p_x ) / p_dx )
          loop
            l_x := ( p_x + j * p_dx ) * ( l_pixel_len + l_alpha_len );
            for b in 0 .. l_pixel_len + l_alpha_len - 1
            loop
              l_bytes( b + l_x + l_y ) := l_current( b + j * ( l_pixel_len + l_alpha_len ) );
            end loop;
          end loop;
        end if;
        --
        l_prior := l_current;
      end loop;
    end adam7_pass;
    --
    procedure add2_smask( p_val raw )
    is
    begin
      if l_blob_smask
      then
        dbms_lob.writeappend( l_img.smask, 1, p_val );
      else
        l_img.smask := utl_raw.concat( l_img.smask, p_val );
        if not coalesce( l_blob_smask, false )
        then
          l_smask_len := coalesce( l_smask_len, 0 ) + 1;
          l_blob_smask := l_smask_len > 32765;
        end if;
      end if;
    end add2_smask;
  begin
    if rawtohex( dbms_lob.substr( p_img_blob, 8, 1 ) ) != '89504E470D0A1A0A'  -- not the right signature
    then
      return null;
    end if;
    l_ind := 9;
    loop
      l_len := blob2num( p_img_blob, 4, l_ind );  -- length
      exit when l_len is null or l_ind > dbms_lob.getlength( p_img_blob );
      case utl_raw.cast_to_varchar2( dbms_lob.substr( p_img_blob, 4, l_ind + 4 ) )  -- Chunk type
        when 'IHDR'
        then
          l_ihdr := dbms_lob.substr( p_img_blob, l_len, l_ind + 8 );
          l_img.width     := raw2num( l_ihdr, 1, 4 );
          l_img.height    := raw2num( l_ihdr, 5, 4 );
          l_img.color_res := raw2num( l_ihdr, 9, 1 );
          l_color_type    := raw2num( l_ihdr, 10, 1 );
          l_interlace     := raw2num( l_ihdr, 13, 1 );
          l_img.greyscale := l_color_type in ( 0, 4 );
          if    l_color_type not in ( 0, 2, 3, 4, 6 )
             or l_img.color_res not in ( 1, 2, 4, 8, 16 )
             or l_interlace not in ( 0, 1 )
             or utl_raw.substr( l_ihdr, 11, 2 ) != '0000' -- compression and filter
             or l_img.width  = 0
             or l_img.height = 0
          then
            return null;
          end if;
          dbms_lob.createtemporary( l_img.pixels, true );
        when 'PLTE'
        then
          l_img.color_tab := dbms_lob.substr( p_img_blob, l_len, l_ind + 8 );
        when 'IDAT'
        then
          -- IDAT may be using several chunks
          dbms_lob.copy( l_img.pixels, p_img_blob, l_len, dbms_lob.getlength( l_img.pixels ) + 1, l_ind + 8 );
        when 'tRNS'
        then
          l_trns := dbms_lob.substr( p_img_blob, l_len, l_ind + 8 );
        when 'IEND'
        then
          exit;
        else
          null;
      end case;
      l_ind := l_ind + 4 + 4 + l_len + 4;  -- Length + Chunk type + Chunk data + CRC
    end loop;
    if l_color_type is null
    then
      return null;
    end if;
    --
    if l_interlace = 1
    then  -- Adam7
      method0_decompress;
      --
      if l_color_type in ( 4, 6 ) -- with alpha-channel
      then
        l_alpha_len := l_img.color_res / 8;
      else
        l_alpha_len := 0;
      end if;
      if l_color_type in ( 0, 3, 4 ) -- Greyscale or Indexed-color
      then
        l_pixel_len := l_img.color_res / 8;
      else
        l_pixel_len := 3 * l_img.color_res / 8;
      end if;
      --
      if l_img.color_res < 8
      then
        for i in 0 .. l_img.height * ceil( l_img.width * l_img.color_res / 8 ) - 1
        loop
          l_bytes( i ) := 0;
        end loop;
      end if;
      --
      l_ind := 1;
      adam7_pass( 0, 0, 8, 8 );
      adam7_pass( 4, 0, 8, 8 );
      adam7_pass( 0, 4, 4, 8 );
      adam7_pass( 2, 0, 4, 4 );
      adam7_pass( 0, 2, 2, 4 );
      adam7_pass( 1, 0, 2, 2 );
      adam7_pass( 0, 1, 1, 2 );
      dbms_lob.freetemporary( l_pix2 );
      --
      l_bytes_line := l_bytes.count / l_img.height;
      dbms_lob.createtemporary( l_pix, true );
      for i in 0 .. l_img.height - 1
      loop
        l_len := 2;
        l_buf := '00';
        for j in 0 .. l_bytes_line - 1
        loop
          l_len := l_len + 2;
          l_buf := l_buf || to_char( l_bytes( j + i * l_bytes_line ), 'FM0X' );
          if l_len > 32760
          then
            dbms_lob.writeappend( l_pix, l_len / 2, hextoraw( l_buf ) );
            l_len := 0;
            l_buf := null;
          end if;
        end loop;
        if l_len > 0
        then
          dbms_lob.writeappend( l_pix, l_len / 2, hextoraw( l_buf ) );
        end if;
      end loop;
      --
      method0_compress;
    end if;
    if l_color_type in ( 4, 6 ) -- with alpha-channel
    then
      method0_decompress;
      --
      l_alpha_len := l_img.color_res / 8;
      l_pixel_len := l_img.color_res / case when l_img.greyscale then 4 else 2 end;
      l_len := l_img.width * l_pixel_len + 1;
      l_current( -1 ) := 0;
      l_current( 0 )  := 0;
      for j in -1 .. l_img.width * l_alpha_len
      loop
        l_prior( j ) := 0;
      end loop;
      dbms_lob.createtemporary( l_pix, true );
      for i in 0 .. l_img.height - 1
      loop
        l_line := dbms_lob.substr( l_pix2, l_len, 1 + i * l_len );
        l_tmp := utl_raw.substr( l_line, 1, 1 ); -- filter
        for j in 0 .. l_img.width - 1
        loop
          l_tmp := utl_raw.concat( l_tmp, utl_raw.substr( l_line, 2 + j * l_pixel_len, l_pixel_len - l_alpha_len ) );
          for k in 1 .. l_alpha_len
          loop
            l_current( k + j * l_alpha_len ) := raw2num( l_line, 1 + ( j + 1 ) * l_pixel_len - l_alpha_len + k, 1 );
          end loop;
        end loop;
        dbms_lob.writeappend( l_pix, utl_raw.length( l_tmp ), l_tmp );
        --
        method0_filter( utl_raw.substr( l_line, 1, 1 ), 1, l_img.width * l_alpha_len, l_alpha_len );
        if l_alpha_len = 1
        then
          for j in 1 .. l_img.width
          loop
            add2_smask( to_char( l_current( j ), 'fm0X' ) );
          end loop;
        else
          for j in 1 .. l_img.width
          loop
            add2_smask( to_char( ( l_current( 2 * j - 1 ) * 256 + l_current( 2 * j ) ) / 256, 'fm0X' ) );
          end loop;
        end if;
        l_prior := l_current;
      end loop;
      method0_compress;
      dbms_lob.freetemporary( l_pix2 );
    end if;
    --
    if l_color_type = 3 and l_trns is not null
    then
      if l_trns = hextoraw( '00')
      then
        l_img.transparancy := 0;
      else
        method0_decompress;
        l_buf := l_trns || rpad( 'F', 512, 'F' );
        l_pixel_len := l_img.color_res / 8;
        l_len := ceil( l_img.width * l_pixel_len ) + 1;
        if l_img.color_res = 1
        then
          l_bit_ands := tp_bit_calc( 128, 64, 32, 16, 8, 4, 2, 1 );
          l_bit_divs := tp_bit_calc( 128, 64, 32, 16, 8, 4, 2, 1 );
        elsif l_img.color_res = 2
        then
          l_bit_ands := tp_bit_calc( 192, 48, 12, 3 );
          l_bit_divs := tp_bit_calc( 64, 16, 4, 1 );
        elsif l_img.color_res = 4
        then
          l_bit_ands := tp_bit_calc( 240, 15 );
          l_bit_divs := tp_bit_calc( 16, 1 );
        elsif l_img.color_res = 8
        then
          l_bit_ands := tp_bit_calc( 255 );
          l_bit_divs := tp_bit_calc( 1 );
        end if;
        for j in - 1 .. l_len - 1
        loop
          l_prior( j ) := 0;
          l_current( j )  := 0;
        end loop;
        for i in 0 .. l_img.height - 1
        loop
          l_line := dbms_lob.substr( l_pix2, l_len, 1 + i * l_len );
          for j in 0 .. l_len - 2
          loop
            l_current( j ) := raw2num( l_line, 2 + j, 1 );
          end loop;
          method0_filter( utl_raw.substr( l_line, 1, 1 ), 0, l_len - 1, 1 );
          for j in 0 .. l_len - 2
          loop
            for b in 1 .. 8 / l_img.color_res
            loop
              l_byte := bitand( l_current( j ), l_bit_ands( b ) );
              l_byte := l_byte / l_bit_divs( b );
              add2_smask( substr( l_buf, 1 + l_byte * 2, 2 ) );
            end loop;
          end loop;
        end loop;
        dbms_lob.freetemporary( l_pix2 );
      end if;
    elsif l_color_type in ( 0, 2 ) and l_trns is not null
    then
      method0_decompress;
      if l_img.color_res = 16
      then
        l_fmt := 'FM0X';
      else
        l_fmt := 'FM000X';
      end if;
      l_pixel_len := l_img.color_res / 8;
      if l_color_type = 2
      then
        l_pixel_len := 3 * l_pixel_len;
      end if;
      l_len := ceil( l_img.width * l_pixel_len ) + 1;
      l_trn := l_trns;
      if l_img.color_res = 1
      then
        l_bit_ands := tp_bit_calc( 128, 64, 32, 16, 8, 4, 2, 1 );
        l_bit_divs := tp_bit_calc( 128, 64, 32, 16, 8, 4, 2, 1 );
      elsif l_img.color_res = 2
      then
        l_bit_ands := tp_bit_calc( 192, 48, 12, 3 );
        l_bit_divs := tp_bit_calc( 64, 16, 4, 1 );
      elsif l_img.color_res = 4
      then
        l_bit_ands := tp_bit_calc( 240, 15 );
        l_bit_divs := tp_bit_calc( 16, 1 );
      end if;
      for j in - 1 .. l_len - 1
      loop
        l_prior( j ) := 0;
        l_current( j )  := 0;
      end loop;
      for i in 0 .. l_img.height - 1
      loop
        l_line := dbms_lob.substr( l_pix2, l_len, 1 + i * l_len );
        for j in 0 .. l_len - 2
        loop
          l_current( j ) := raw2num( l_line, 2 + j, 1 );
        end loop;
        method0_filter( utl_raw.substr( l_line, 1, 1 ), 0, l_len - 1, 1 );
        if l_img.color_res < 8
        then
          for j in 0 .. l_len - 2
          loop
            for b in 1 .. 8 / l_img.color_res
            loop
              l_byte := bitand( l_current( j ), l_bit_ands( b ) );
              l_byte := l_byte / l_bit_divs( b );
              add2_smask( case when l_trn = to_char( l_byte, l_fmt ) then '00' else 'FF' end );
            end loop;
          end loop;
        else
          for j in 0 .. l_img.width - 1
          loop
            l_buf := null;
            for b in 0 .. l_pixel_len - 1
            loop
              l_buf := l_buf || to_char( l_current( j * l_pixel_len+ b ), l_fmt );
            end loop;
            add2_smask( case when l_trn = l_buf then '00' else 'FF' end );
          end loop;
        end if;
      end loop;
      dbms_lob.freetemporary( l_pix2 );
    end if;
    --
    l_img.type := 'png';
    l_img.nr_colors := case l_color_type
                         when 0 then 1
                         when 2 then 3
                         when 3 then 1
                         when 4 then 1
                         else 3
                       end;
    --
    return l_img;
  end parse_png;
  --
  function lzw_decompress
    ( p_blob blob
    , p_bits pls_integer
    )
  return blob
  is
    powers tp_pls_tab;
    --
    g_lzw_ind pls_integer;
    g_lzw_bits pls_integer;
    g_lzw_buffer pls_integer;
    g_lzw_bits_used pls_integer;
    --
    type tp_lzw_dict is table of raw(1000) index by pls_integer;
    t_lzw_dict tp_lzw_dict;
    t_clr_code pls_integer;
    t_nxt_code pls_integer;
    t_new_code pls_integer;
    t_old_code pls_integer;
    l_blob blob;
    --
    function get_lzw_code
    return pls_integer
    is
      l_rv pls_integer;
    begin
      while g_lzw_bits_used < g_lzw_bits
      loop
        g_lzw_ind := g_lzw_ind + 1;
        g_lzw_buffer := blob2num( p_blob, 1, g_lzw_ind ) * powers( g_lzw_bits_used ) + g_lzw_buffer;
        g_lzw_bits_used := g_lzw_bits_used + 8;
      end loop;
      l_rv := bitand( g_lzw_buffer, powers( g_lzw_bits ) - 1 );
      g_lzw_bits_used := g_lzw_bits_used - g_lzw_bits;
      g_lzw_buffer := trunc( g_lzw_buffer / powers( g_lzw_bits ) );
      return l_rv;
    end;
    --
  begin
    for i in 0 .. 30
    loop
      powers( i ) := power( 2, i );
    end loop;
    --
    t_clr_code := powers( p_bits - 1 );
    t_nxt_code := t_clr_code + 2;
    for i in 0 .. least( t_clr_code - 1, 255 )
    loop
      t_lzw_dict( i ) := hextoraw( to_char( i, 'fm0X' ) );
    end loop;
    dbms_lob.createtemporary( l_blob, true );
    g_lzw_ind := 0;
    g_lzw_bits := p_bits;
    g_lzw_buffer := 0;
    g_lzw_bits_used := 0;
    --
    t_old_code := null;
    t_new_code := get_lzw_code( );
    loop
      case nvl( t_new_code, t_clr_code + 1 )
        when t_clr_code + 1
        then
          exit;
        when t_clr_code
        then
          t_new_code := null;
          g_lzw_bits := p_bits;
          t_nxt_code := t_clr_code + 2;
        else
          if t_new_code = t_nxt_code
          then
            t_lzw_dict( t_nxt_code ) :=
              utl_raw.concat( t_lzw_dict( t_old_code )
                            , utl_raw.substr( t_lzw_dict( t_old_code ), 1, 1 )
                            );
            dbms_lob.append( l_blob, t_lzw_dict( t_nxt_code ) );
            t_nxt_code := t_nxt_code + 1;
          elsif t_new_code > t_nxt_code
          then
            exit;
          else
            dbms_lob.append( l_blob, t_lzw_dict( t_new_code ) );
            if t_old_code is not null
            then
              t_lzw_dict( t_nxt_code ) := utl_raw.concat( t_lzw_dict( t_old_code )
                                                        , utl_raw.substr( t_lzw_dict( t_new_code ), 1, 1 )
                                                        );
              t_nxt_code := t_nxt_code + 1;
            end if;
          end if;
          if     bitand( t_nxt_code, powers( g_lzw_bits ) - 1 ) = 0
             and g_lzw_bits < 12
          then
            g_lzw_bits := g_lzw_bits + 1;
          end if;
      end case;
      t_old_code := t_new_code;
      t_new_code := get_lzw_code( );
    end loop;
    t_lzw_dict.delete;
    --
    return l_blob;
  end lzw_decompress;
  --
  function parse_gif( p_img_blob blob )
  return tp_img
  is
    l_img tp_img;
    l_buf raw(4000);
    l_ind integer;
    l_len pls_integer;
  begin
    if dbms_lob.substr( p_img_blob, 3, 1 ) != utl_raw.cast_to_raw( 'GIF' )
    then
      return null;
    end if;
    l_ind := 7;
    l_buf := dbms_lob.substr( p_img_blob, 7, 7 );  --  Logical Screen Descriptor
    l_ind := l_ind + 7;
    l_img.color_res := raw2num( utl_raw.bit_and( utl_raw.substr( l_buf, 5, 1 ), hextoraw( '70' ) ) ) / 16 + 1;
    l_img.color_res := 8;
    if raw2num( l_buf, 5, 1 ) > 127
    then
      l_len := 3 * power( 2, raw2num( utl_raw.bit_and( utl_raw.substr( l_buf, 5, 1 ), hextoraw( '07' ) ) ) + 1 );
      l_img.color_tab := dbms_lob.substr( p_img_blob, l_len, l_ind  ); -- Global Color Table
      l_ind := l_ind + l_len;
    end if;
    --
    loop
      case dbms_lob.substr( p_img_blob, 1, l_ind )
        when hextoraw( '3B' ) -- trailer
        then
          exit;
        when hextoraw( '21' ) -- extension
        then
          if dbms_lob.substr( p_img_blob, 1, l_ind + 1 ) = hextoraw( 'F9' )
          then -- Graphic Control Extension
            if utl_raw.bit_and( dbms_lob.substr( p_img_blob, 1, l_ind + 3 ), hextoraw( '01' ) ) = hextoraw( '01' )
            then -- Transparent Color Flag set
              l_img.transparancy := blob2num( p_img_blob, 1, l_ind + 6 );
            end if;
          end if;
          l_ind := l_ind + 2; -- skip sentinel + label
          loop
            l_len := blob2num( p_img_blob, 1, l_ind ); -- Block Size
            exit when l_len = 0;
            l_ind := l_ind + 1 + l_len; -- skip Block Size + Data Sub-block
          end loop;
          l_ind := l_ind + 1;       -- skip last Block Size
        when hextoraw( '2C' )       -- image
        then
          declare
            l_img_blob      blob;
            l_min_code_size pls_integer;
            l_code_size     pls_integer;
            l_flags         raw(1);
          begin
            l_img.width := utl_raw.cast_to_binary_integer( dbms_lob.substr( p_img_blob, 2, l_ind + 5 )
                                                         , utl_raw.little_endian
                                                         );
            l_img.height := utl_raw.cast_to_binary_integer( dbms_lob.substr( p_img_blob, 2, l_ind + 7 )
                                                          , utl_raw.little_endian
                                                          );
            l_img.greyscale := false;
            l_ind := l_ind + 1 + 8;                   -- skip sentinel + img sizes
            l_flags := dbms_lob.substr( p_img_blob, 1, l_ind );
            if utl_raw.bit_and( l_flags, hextoraw( '80' ) ) = hextoraw( '80' )
            then
              l_len := 3 * power( 2, raw2num( utl_raw.bit_and( l_flags, hextoraw( '07' ) ) ) + 1 );
              l_img.color_tab := dbms_lob.substr( p_img_blob, l_len, l_ind + 1 ); -- Local Color Table
            end if;
            l_ind := l_ind + 1;                                -- skip image Flags
            l_min_code_size := blob2num( p_img_blob, 1, l_ind );
            l_ind := l_ind + 1;                      -- skip LZW Minimum Code Size
            dbms_lob.createtemporary( l_img_blob, true );
            loop
              l_len := blob2num( p_img_blob, 1, l_ind ); -- Block Size
              exit when l_len = 0;
              dbms_lob.append( l_img_blob, dbms_lob.substr( p_img_blob, l_len, l_ind + 1 ) ); -- Data Sub-block
              l_ind := l_ind + 1 + l_len;      -- skip Block Size + Data Sub-block
            end loop;
            l_ind := l_ind + 1;                            -- skip last Block Size
            l_img.pixels := lzw_decompress( l_img_blob, l_min_code_size + 1 );
            --
            if utl_raw.bit_and( l_flags, hextoraw( '40' ) ) = hextoraw( '40' )
            then                                          --  interlaced
              declare
                l_pass     pls_integer;
                l_pass_ind tp_pls_tab;
              begin
                dbms_lob.createtemporary( l_img_blob, true );
                l_pass_ind( 1 ) := 1;
                l_pass_ind( 2 ) := trunc( ( l_img.height - 1 ) / 8 ) + 1;
                l_pass_ind( 3 ) := l_pass_ind( 2 ) + trunc( ( l_img.height + 3 ) / 8 );
                l_pass_ind( 4 ) := l_pass_ind( 3 ) + trunc( ( l_img.height + 1 ) / 4 );
                l_pass_ind( 2 ) := l_pass_ind( 2 ) * l_img.width + 1;
                l_pass_ind( 3 ) := l_pass_ind( 3 ) * l_img.width + 1;
                l_pass_ind( 4 ) := l_pass_ind( 4 ) * l_img.width + 1;
                for i in 0 .. l_img.height - 1
                loop
                  l_pass := case mod( i, 8 )
                              when 0 then 1
                              when 4 then 2
                              when 2 then 3
                              when 6 then 3
                              else 4
                            end;
                  dbms_lob.append( l_img_blob, dbms_lob.substr( l_img.pixels, l_img.width, l_pass_ind( l_pass ) ) );
                  l_pass_ind( l_pass ) := l_pass_ind( l_pass ) + l_img.width;
                end loop;
                l_img.pixels := l_img_blob;
              end;
            end if;
            --
            dbms_lob.freetemporary( l_img_blob );
          end;
        else
          exit;
      end case;
    end loop;
    --
    l_img.type := 'gif';
    return l_img;
  end parse_gif;
  --
  function parse_jpg( p_img blob )
  return tp_img
  is
    l_img tp_img;
    l_buf raw(100);
    l_hex varchar2(10);
    l_ind integer;
    l_len pls_integer;
  begin
    if (  dbms_lob.substr( p_img, 2, 1 ) != hextoraw( 'FFD8' )                                -- SOI Start of Image
       or dbms_lob.substr( p_img, 2, dbms_lob.getlength( p_img ) - 1 ) != hextoraw( 'FFD9' )  -- EOI End of Image
       or dbms_lob.substr( p_img, 2, 3 ) not in ( hextoraw( 'FFE0' )  -- a APP0 jpg
                                                , hextoraw( 'FFE1' )  -- a APP1 jpg
                                                )
       )
    then  -- this is not a jpg I can handle
      return null;
    end if;
    --
    dbms_lob.createtemporary( l_img.pixels, true );
    dbms_lob.copy( l_img.pixels, p_img, dbms_lob.lobmaxsize );
    l_ind := 5 + to_number( dbms_lob.substr( p_img, 2, 5 ), 'XXXX' );
    loop
      l_buf := dbms_lob.substr( p_img, 4, l_ind );
      l_hex := substr( rawtohex( l_buf ), 1, 4 );
      exit when l_hex in ( 'FFDA' -- SOS Start of Scan
                         , 'FFD9' -- EOI End Of Image
                         )
             or substr( l_hex, 1, 2 ) != 'FF';
      if l_hex in ( 'FFD0', 'FFD1', 'FFD2', 'FFD3', 'FFD4', 'FFD5', 'FFD6', 'FFD7' -- RSTn
                  , 'FF01'  -- TEM
                  )
      then
        l_ind := l_ind + 2;
      else
        if l_hex in ( 'FFC0' -- SOF0 (Start Of Frame 0) Baseline DCT
                    , 'FFC1' -- SOF1 (Start Of Frame 1) Extended Sequential DCT
                    , 'FFC2' -- SOF2 (Start Of Frame 2) Progressive DCT
                    )
        then
          l_hex := rawtohex( dbms_lob.substr( p_img, 5, l_ind + 4 ) );
          l_img.color_res := g_hex( substr( l_hex, 1, 2 ) );
          l_img.width  := to_number( substr( l_hex, 7 ), 'xxxx' );
          l_img.height := to_number( substr( l_hex, 3, 4 ), 'xxxx' );
          exit;
        end if;
        l_ind := l_ind + 2 + to_number( utl_raw.substr( l_buf, 3, 2 ), 'xxxx' );
      end if;
    end loop;
    l_img.type := 'jpg';
    return l_img;
  end parse_jpg;
  --
  function parse_bmp( p_img blob )
  return tp_img
  is
    l_img         tp_img;
    l_pixs        blob;
    l_ind         integer;
    l_idx         integer;
    l_offset      integer;
    l_blob        boolean;
    l_blob_smask  boolean;
    l_buf         raw(32767);
    l_line        raw(32767);
    l_smask       raw(32767);
    l_n           pls_integer;
    l_len         pls_integer;
    l_line_sz     pls_integer;
    l_info_len    pls_integer;
    l_num_colors  pls_integer;
    l_compression pls_integer;
  begin
    l_buf := dbms_lob.substr( p_img, 38, 1 );
    if utl_raw.substr( l_buf, 1, 2 ) != '424D' -- BM
    then
       return null;
    end if;
    l_info_len      := to_number( utl_raw.reverse( utl_raw.substr( l_buf, 15, 4 ) ), 'XXXXXXXX' );
    l_img.width     := to_number( utl_raw.reverse( utl_raw.substr( l_buf, 19, 4 ) ), 'XXXXXXXX' );
    l_img.height    := to_number( utl_raw.reverse( utl_raw.substr( l_buf, 23, 4 ) ), 'XXXXXXXX' );
    l_offset        := to_number( utl_raw.reverse( utl_raw.substr( l_buf, 11, 4 ) ), 'XXXXXXXX' );
    l_img.color_res := to_number( utl_raw.reverse( utl_raw.substr( l_buf, 29, 2 ) ), 'XXXXXXXX' );
    l_compression   := g_hex( utl_raw.substr( l_buf, 31, 1 ) );
    l_line_sz := ceil( ceil( l_img.width * l_img.color_res / 8 ) / 4 ) * 4;
    if l_img.color_res <= 8
    then
      l_num_colors := power( 2, l_img.color_res );
      l_buf := dbms_lob.substr( p_img, 4 * l_num_colors, 15 + l_info_len );
      for i in 0 .. l_num_colors - 1
      loop
        l_img.color_tab := utl_raw.concat( l_img.color_tab
                                         , utl_raw.reverse( utl_raw.substr( l_buf, 1 + 4 * i, 3 ) )
                                         );
      end loop;
    end if;
    dbms_lob.createtemporary( l_pixs, true );
    if l_compression = 1
    then -- BI_RLE8
      l_len := 0;
      l_idx := 1;
      l_ind := l_offset + 1;
      loop
        if l_idx > l_len
        then
          l_buf := dbms_lob.substr( p_img, 32766, l_ind );
          exit when l_buf is null;
          l_len := utl_raw.length( l_buf );
          l_ind := l_ind + l_len;
          l_idx := 1;
        end if;
        l_n := to_number( utl_raw.substr( l_buf, l_idx, 1 ), '0X' );
        if l_n = 0
        then
          case utl_raw.substr( l_buf, l_idx + 1, 1 )
            when '00' then
              dbms_lob.writeappend( l_pixs, utl_raw.length( l_line ), l_line );
              l_line := null;
            when '01' then
              if utl_raw.length( l_line ) > 0
              then
                dbms_lob.writeappend( l_pixs, utl_raw.length( l_line ), l_line );
              end if;
              exit;
          end case;
        else
          l_line := utl_raw.concat( l_line, utl_raw.copies( utl_raw.substr( l_buf, l_idx + 1, 1 ), l_n ) );
        end if;
        l_idx := l_idx + 2;
      end loop;
    else
      dbms_lob.copy( l_pixs, p_img, dbms_lob.lobmaxsize, 1, l_offset + 1 );
    end if;
    dbms_lob.createtemporary( l_img.pixels, true );
    for i in reverse 0 .. l_img.height - 1
    loop
      l_buf   := null;
      l_smask := null;
      l_line := dbms_lob.substr( l_pixs, l_line_sz, 1 + i * l_line_sz );
      if l_img.color_res = 32
      then
        for j in 0 .. l_img.width - 1
        loop
          l_buf := utl_raw.concat( l_buf, utl_raw.reverse( utl_raw.substr( l_line, 1 + 4 * j, 3 ) ) );
          l_smask := utl_raw.concat( l_smask, utl_raw.substr( l_line, 4 + 4 * j, 1 ) );
        end loop;
      elsif l_img.color_res < 8
      then
        l_buf := utl_raw.substr( l_line, 1, ceil( l_img.width * l_img.color_res / 8 ) );
      else
        l_buf := l_line;
      end if;
      if l_blob
      then
        dbms_lob.writeappend( l_img.pixels, utl_raw.length( l_buf ), l_buf );
      else
        l_img.pixels := utl_raw.concat( l_img.pixels, l_buf );
        l_blob := utl_raw.length( l_img.pixels ) > 32760 - l_line_sz;
      end if;
      if l_blob_smask
      then
        dbms_lob.writeappend( l_img.smask, utl_raw.length( l_smask ), l_smask );
      else
        l_img.smask := utl_raw.concat( l_img.smask, l_smask );
        l_blob_smask := utl_raw.length( l_img.smask ) > 32760 - l_img.width;
      end if;
    end loop;
    if l_img.color_res in ( 24, 32 )
    then
      l_img.color_res := 8;
    end if;
    dbms_lob.freetemporary( l_pixs );
    l_img.type := 'bmp';
    return l_img;
  end parse_bmp;
  --
  function calc_crc32( p_data blob )
  return varchar2
  is
    l_tmp blob;
    l_crc32 varchar2(16);
  begin
    l_tmp := utl_compress.lz_compress( p_data );
    l_crc32 := dbms_lob.substr( l_tmp, 8, dbms_lob.getlength( l_tmp ) - 7 );
    dbms_lob.freetemporary( l_tmp );
    return substr( l_crc32, 1, 8 );
  end calc_crc32;
  --
  function parse_img
    ( p_blob  blob
    , p_crc32 varchar2 := null
    , p_type  varchar2 := null
    )
  return tp_img
  is
    l_img tp_img;
    l_buf raw(32);
  begin
    l_img.type := p_type;
    if l_img.type is null
    then
      l_buf := dbms_lob.substr( p_blob, 8, 1 );
      if utl_raw.substr( l_buf, 1, 8 ) = hextoraw( '89504E470D0A1A0A' )
      then
        l_img.type := 'png';
      elsif utl_raw.substr( l_buf, 1, 3 ) = hextoraw( '474946' ) -- GIF
      then
        l_img.type := 'gif';
      elsif utl_raw.substr( l_buf, 1, 2 ) = hextoraw( 'FFD8' ) -- SOI Start of Image
        and rawtohex( utl_raw.substr( l_buf, 3, 2 ) ) in ( 'FFE0' -- a APP0 jpg
                                                         , 'FFE1' -- a APP1 jpg
                                                         )
      then
        l_img.type := 'jpg';
      elsif utl_raw.substr( l_buf, 1, 2 ) = '424D' -- BM
      then
        l_img.type := 'bmp';
      end if;
    end if;
    --
    l_img := case lower( l_img.type )
               when 'gif' then parse_gif( p_blob )
               when 'png' then parse_png( p_blob )
               when 'jpg' then parse_jpg( p_blob )
               when 'bmp' then parse_bmp( p_blob )
               else null
             end;
    --
    if l_img.type is not null
    then
      l_img.crc32 := coalesce( p_crc32, calc_crc32( p_blob ) );
    end if;
    return l_img;
  end parse_img;
  --
  function load_image( p_img blob )
  return pls_integer
  is
    l_img   tp_img;
    l_idx   pls_integer;
    l_crc32 varchar2(8);
  begin
    if p_img is null or dbms_lob.getlength( p_img ) = 0
    then
      return null;
    end if;
    l_crc32 := calc_crc32( p_img );
    l_idx := g_pdf.images.first;
    while l_idx is not null
    loop
      exit when g_pdf.images( l_idx ).crc32 = l_crc32;
      l_idx := g_pdf.images.next( l_idx );
    end loop;
    --
    if l_idx is null
    then
      l_img := parse_img( p_img, l_crc32 );
      if l_img.crc32 is null
      then
        return null;
      end if;
      l_idx := g_pdf.images.count + 1;
      g_pdf.images( l_idx ) := l_img;
    end if;
    --
    return l_idx;
  end load_image;
  --
  function load_image
    ( p_dir       varchar2
    , p_file_name varchar2
    )
  return pls_integer
  is
    l_idx  pls_integer;
    l_blob blob;
  begin
    l_blob := file2blob( p_dir
                       , p_file_name
                       );
    l_idx := load_image( l_blob );
    dbms_lob.freetemporary( l_blob );
    return l_idx;
  end load_image;
  --
  function load_image( p_url varchar2 )
  return pls_integer
  is
    l_pos pls_integer;
  begin
    if p_url is null
    then
      return null;
    end if;
    if substr( p_url, 1, 11 ) = 'data:image/'
    then
      l_pos := instr( p_url, ';base64,' );
      if l_pos = 0
      then
        raise_application_error( -20040, 'No supported data URL image.' );
      end if;
      return load_image( p_img => utl_encode.base64_decode( utl_raw.cast_to_raw( substr( p_url, l_pos + 8 ) ) ) );
    end if;
    if p_url not like 'http%'
    then
      raise_application_error( -20041, 'No supported (data) URL image.' );
    end if;
$IF as_pdf.use_apex
$THEN
    return load_image( p_img => apex_web_service.make_rest_request_b
                                  ( p_url            => p_url
                                  , p_http_method    => 'GET'
                                  , p_proxy_override => g_proxy
                                  , p_wallet_path    => g_wallet_path
                                  , p_wallet_pwd     => g_wallet_password
                                  )
                     );
$ELSIF as_pdf.use_utl_http
$THEN
    declare
      l_img      blob;
      l_buf      raw(32767);
      l_proxy    varchar2(32767);
      l_no_proxy varchar2(32767);
      l_rck      utl_http.request_context_key;
      l_req      utl_http.req;
      l_resp     utl_http.resp;
      e_no_img   exception;
    begin
      utl_http.get_proxy( l_proxy, l_no_proxy );
      utl_http.set_proxy( g_proxy, g_no_proxy );
      utl_http.set_detailed_excp_support( true );
      l_rck := utl_http.create_request_context( wallet_path => g_wallet_path, wallet_password => g_wallet_password );
      l_req := utl_http.begin_request( url => p_url, request_context => l_rck );
      l_resp := utl_http.get_response( l_req );
      if l_resp.status_code != 200
      then
        raise e_no_img;
      end if;
      dbms_lob.createtemporary( l_img, true );
      begin
        loop
          utl_http.read_raw( l_resp, l_buf, 32767 );
          dbms_lob.writeappend( l_img, utl_raw.length( l_buf ), l_buf );
        end loop;
      exception
        when utl_http.end_of_body then
          utl_http.end_response( l_resp );
      end;
      utl_http.destroy_request_context( l_rck );
      utl_http.set_proxy( l_proxy, l_no_proxy );
      return load_image( p_img => l_img );
    exception
      when e_no_img then
        utl_http.set_proxy( l_proxy, l_no_proxy );
        utl_http.end_response( l_resp );
        raise_application_error( -20042, 'No image found at ' || p_url );
      when others then
        utl_http.set_proxy( l_proxy, l_no_proxy );
        utl_http.end_request( l_req );
        utl_http.destroy_request_context( l_rck );
        raise;
    end;
$ELSE
      raise_application_error( -20043, 'Image download not supported.' );
$END
  end load_image;
  --
  procedure put_image
    ( p_img_idx   pls_integer
    , p_x         number               -- left
    , p_y         number               -- bottom
    , p_width     number      := null
    , p_height    number      := null
    , p_align     varchar2    := null
    , p_valign    varchar2    := null
    , p_alpha     number      := null
    , p_page_proc pls_integer := null
    )
  is
    l_x      number;
    l_y      number;
    l_width  number;
    l_height number;
    l_hpad   number;
    l_img    tp_img;
  begin
    if p_img_idx is null or not g_pdf.images.exists( p_img_idx )
    then
      return;
    end if;
    --
    if p_page_proc is null
    then
      l_img := g_pdf.images( p_img_idx );
      --
      if    l_img.width > p_width
         or (   p_width is not null
            and substr( upper( p_align ), 1, 1 ) = 'F' -- fill
            )
      then
        l_width := p_width;
        l_height := l_img.height * p_width / l_img.width;
      elsif (   p_height is not null
            and substr( upper( p_valign ), 1, 1 ) = 'F' -- fill
            )
      then
        l_width := l_img.width * p_height / l_img.height;
        l_height := p_height;
        if l_width > p_width
        then
          l_width := p_width;
          l_height := l_height * p_width / l_width;
        end if;
      else
        l_width := l_img.width;
        l_height := l_img.height;
      end if;
      if l_height > p_height
      then
        l_width := l_width * p_height / l_height;
        l_height := p_height;
      end if;
      --
      l_x := coalesce( p_x, 0 );
      l_x := case substr( upper( p_align ), 1, 1 )
               when 'R' then l_x + coalesce( p_width - l_width, 0 )     -- right
               when 'E' then l_x + coalesce( p_width - l_width, 0 )     -- end
               when 'C' then l_x + coalesce( p_width - l_width, 0 ) / 2 -- center
               when 'F' then l_x + coalesce( p_width - l_width, 0 ) / 2 -- fill
               else l_x                                                 -- left, start
             end;
      l_y := coalesce( p_y, 0 );
      l_y := case substr( upper( p_valign ), 1, 1 )
               when 'C' then l_y + coalesce( p_height - l_height, 0 ) / 2 -- center
               when 'F' then l_y + coalesce( p_height - l_height, 0 ) / 2 -- fill
               when 'T' then l_y + coalesce( p_height - l_height, 0 )     -- top
               else l_y                                                   -- bottom
             end;
      --
      txt2page(  'q ' );
      add_alpha( p_alpha );
      txt2page(  '1 0 0 1 ' || to_char_round( l_x ) || ' ' || to_char_round( l_y ) || ' cm '
              || to_char_round( l_width ) || ' 0 0 ' || to_char_round( l_height ) || ' 0 0 cm '
              || ' /I' || to_char( p_img_idx ) || ' Do Q'
              );
    else
      add_page_proc( 9, p_page_proc
                   , p_nums  => tp_numbers( p_img_idx, p_x, p_y, p_width, p_height, p_alpha )
                   , p_chars => tp_varchar2s( p_align, p_valign )
                   );
    end if;
  end put_image;
  --
  procedure put_image
    ( p_img       blob
    , p_x         number               -- left
    , p_y         number               -- bottom
    , p_width     number      := null
    , p_height    number      := null
    , p_align     varchar2    := null
    , p_valign    varchar2    := null
    , p_alpha     number      := null
    , p_page_proc pls_integer := null
    )
  is
  begin
    if p_img is null
    then
      return;
    end if;
    put_image( p_img_idx   => load_image( p_img )
             , p_x         => p_x
             , p_y         => p_y
             , p_width     => p_width
             , p_height    => p_height
             , p_align     => p_align
             , p_valign    => p_valign
             , p_alpha     => p_alpha
             , p_page_proc => p_page_proc
             );
  end;
  --
  procedure put_image
    ( p_dir       varchar2
    , p_file_name varchar2
    , p_x         number               -- left
    , p_y         number               -- bottom
    , p_width     number      := null
    , p_height    number      := null
    , p_align     varchar2    := null
    , p_valign    varchar2    := null
    , p_alpha     number      := null
    , p_page_proc pls_integer := null
    )
  is
  begin
    put_image( p_img_idx   => load_image( p_dir, p_file_name )
             , p_x         => p_x
             , p_y         => p_y
             , p_width     => p_width
             , p_height    => p_height
             , p_align     => p_align
             , p_valign    => p_valign
             , p_alpha     => p_alpha
             , p_page_proc => p_page_proc
             );
  end put_image;
  --
  procedure put_image
    ( p_url       varchar2
    , p_x         number               -- left
    , p_y         number               -- bottom
    , p_width     number      := null
    , p_height    number      := null
    , p_align     varchar2    := null
    , p_valign    varchar2    := null
    , p_alpha     number      := null
    , p_page_proc pls_integer := null
    )
  is
  begin
    if p_url is null
    then
      return;
    end if;
    put_image( p_img_idx   => load_image( p_url )
             , p_x         => p_x
             , p_y         => p_y
             , p_width     => p_width
             , p_height    => p_height
             , p_align     => p_align
             , p_valign    => p_valign
             , p_alpha     => p_alpha
             , p_page_proc => p_page_proc
             );
  end;
  --
  procedure add_embedded_file
    ( p_name    varchar2
    , p_content blob
    , p_descr   varchar2 := null
    , p_mime    varchar2 := null
    , p_af_key  varchar2 := null
    )
  is
    l_embedded_file tp_embedded_file;
  begin
    l_embedded_file.name   := p_name;
    l_embedded_file.descr  := p_descr;
    l_embedded_file.mime   := p_mime;
    l_embedded_file.af_key := p_af_key;
    dbms_lob.createtemporary( l_embedded_file.content, true );
    dbms_lob.copy( l_embedded_file.content, p_content, dbms_lob.lobmaxsize );
    g_pdf.embedded_files( g_pdf.embedded_files.count ) := l_embedded_file;
  end add_embedded_file;
  --
  function finish_pdf( p_password varchar2 := null )
  return blob
  is
  begin
    finish_pdf( p_password );
    return g_pdf.pdf_blob;
  end finish_pdf;
  --
  function get_pdf( p_password varchar2 := null )
  return blob
  is
  begin
    return finish_pdf( p_password );
  end get_pdf;
  --
$IF as_pdf.use_utl_file
$THEN
  procedure save_pdf
    ( p_dir      varchar2
    , p_filename varchar2
    , p_password varchar2 := null
    )
  is
    l_fh utl_file.file_type;
    l_len pls_integer := 32767;
  begin
    finish_pdf( p_password );
    --
    l_fh := utl_file.fopen( p_dir, p_filename, 'wb' );
    for i in 0 .. trunc( ( dbms_lob.getlength( g_pdf.pdf_blob ) - 1 ) / l_len )
    loop
      utl_file.put_raw( l_fh
                      , dbms_lob.substr( g_pdf.pdf_blob
                                       , l_len
                                       , i * l_len + 1
                                       )
                      );
    end loop;
    utl_file.fflush( l_fh );
    utl_file.fclose( l_fh );
    --
    dbms_lob.freetemporary( g_pdf.pdf_blob );
    g_pdf.pdf_blob := null;
  end save_pdf;
$ELSE
  procedure save_pdf
    ( p_dir      varchar2
    , p_filename varchar2
    , p_password varchar2 := null
    )
  is
  begin
    raise_application_error( -20026, 'utl_file not available. Change the package header, set use_utl_file := true; when you have access to utl_file.' );
  end save_pdf;
$END
  --
  function to_short( p_val raw, p_factor number := 1 )
  return number
  is
    t_rv number;
  begin
    t_rv := to_number( rawtohex( p_val ), 'XXXXXXXXXX' );
    if t_rv > 32767
    then
      t_rv := t_rv - 65536;
    end if;
    return t_rv * p_factor;
  end;
  --
  function get_encoding( p_encoding varchar2 := null )
  return varchar2
  is
    l_encoding varchar2(32767);
  begin
    if p_encoding is not null
    then
      if nls_charset_id( p_encoding ) is null
      then
        l_encoding := utl_i18n.map_charset( p_encoding, utl_i18n.GENERIC_CONTEXT, utl_i18n.IANA_TO_ORACLE );
      else
        l_encoding := p_encoding;
      end if;
    end if;
    return coalesce( l_encoding, 'US8PC437' ); -- IBM codepage 437
  end;
  --
  function char2raw( p_txt varchar2 character set any_cs, p_encoding varchar2 := null )
  return raw
  is
  begin
    if isnchar( p_txt )
    then -- on my 12.1 database, which is not AL32UTF8,
         -- utl_i18n.string_to_raw( p_txt, get_encoding( p_encoding ) does not work
      return utl_raw.convert( utl_i18n.string_to_raw( p_txt )
                            , get_encoding( p_encoding )
                            , nls_charset_name( nls_charset_id( 'NCHAR_CS' ) )
                            );
    end if;
    return utl_i18n.string_to_raw( p_txt, get_encoding( p_encoding ) );
  end;
  --
  function little_endian( p_num raw, p_pos pls_integer := 1, p_bytes pls_integer := null )
  return integer
  is
  begin
    return to_number( utl_raw.reverse( utl_raw.substr( p_num, p_pos, p_bytes ) ), 'XXXXXXXXXXXXXXXX' );
  end;
  --
  procedure get_zip_info( p_zip blob, p_info out tp_zip_info )
  is
    l_ind integer;
    l_buf_sz pls_integer := 2024;
    l_start_buf integer;
    l_buf raw(32767);
  begin
    p_info.len := nvl( dbms_lob.getlength( p_zip ), 0 );
    if p_info.len < 22
    then -- no (zip) file or empty zip file
      return;
    end if;
    l_start_buf := greatest( p_info.len - l_buf_sz + 1, 1 );
    l_buf := dbms_lob.substr( p_zip, l_buf_sz, l_start_buf );
    l_ind := utl_raw.length( l_buf ) - 21;
    loop
      exit when l_ind < 1 or utl_raw.substr( l_buf, l_ind, 4 ) = c_END_OF_CENTRAL_DIRECTORY;
      l_ind := l_ind - 1;
    end loop;
    if l_ind > 0
    then
      l_ind := l_ind + l_start_buf - 1;
    else
      l_ind := p_info.len - 21;
      loop
        exit when l_ind < 1 or dbms_lob.substr( p_zip, 4, l_ind ) = c_END_OF_CENTRAL_DIRECTORY;
        l_ind := l_ind - 1;
      end loop;
    end if;
    if l_ind <= 0
    then
      raise_application_error( -20001, 'Error parsing the zipfile' );
    end if;
    l_buf := dbms_lob.substr( p_zip, 22, l_ind );
    if    utl_raw.substr( l_buf, 5, 2 ) != utl_raw.substr( l_buf, 7, 2 )  -- this disk = disk with start of Central Dir
       or utl_raw.substr( l_buf, 9, 2 ) != utl_raw.substr( l_buf, 11, 2 ) -- complete CD on this disk
    then
      raise_application_error( -20003, 'Error parsing the zipfile' );
    end if;
    p_info.idx_eocd := l_ind;
    p_info.idx_cd := little_endian( l_buf, 17, 4 ) + 1;
    p_info.cnt := little_endian( l_buf, 9, 2 );
    p_info.len_cd := p_info.idx_eocd - p_info.idx_cd;
  end;
  --
  function parse_central_file_header( p_zip blob, p_ind integer, p_cfh out tp_cfh )
  return boolean
  is
    l_tmp pls_integer;
    l_len pls_integer;
    l_buf raw(32767);
  begin
    l_buf := dbms_lob.substr( p_zip, 46, p_ind );
    if utl_raw.substr( l_buf, 1, 4 ) != c_CENTRAL_FILE_HEADER
    then
      return false;
    end if;
    p_cfh.crc32 := utl_raw.substr( l_buf, 17, 4 );
    p_cfh.n := little_endian( l_buf, 29, 2 );
    p_cfh.m := little_endian( l_buf, 31, 2 );
    p_cfh.k := little_endian( l_buf, 33, 2 );
    p_cfh.len := 46 + p_cfh.n + p_cfh.m + p_cfh.k;
    --
    p_cfh.utf8 := bitand( g_hex( utl_raw.substr( l_buf, 10, 1 ) ), 8 ) > 0;
    if p_cfh.n > 0
    then
      p_cfh.name1 := dbms_lob.substr( p_zip, least( p_cfh.n, 32767 ), p_ind + 46 );
    end if;
    --
    p_cfh.compressed_len := little_endian( l_buf, 21, 4 );
    p_cfh.original_len := little_endian( l_buf, 25, 4 );
    p_cfh.offset := little_endian( l_buf, 43, 4 );
    --
    return true;
  end;
  --
  function get_central_file_header
    ( p_zip      blob
    , p_name     varchar2 character set any_cs
    , p_idx      number
    , p_encoding varchar2
    , p_cfh      out tp_cfh
    )
  return boolean
  is
    l_rv        boolean;
    l_ind       integer;
    l_idx       integer;
    l_info      tp_zip_info;
    l_name      raw(32767);
    l_utf8_name raw(32767);
  begin
    if p_name is null and p_idx is null
    then
      return false;
    end if;
    get_zip_info( p_zip, l_info );
    if nvl( l_info.cnt, 0 ) < 1
    then -- no (zip) file or empty zip file
      return false;
    end if;
    --
    if p_name is not null
    then
      l_name := char2raw( p_name, p_encoding );
      l_utf8_name := char2raw( p_name, 'AL32UTF8' );
    end if;
    --
    l_rv := false;
    l_ind := l_info.idx_cd;
    l_idx := 1;
    loop
      exit when not parse_central_file_header( p_zip, l_ind, p_cfh );
      if l_idx = p_idx
         or p_cfh.name1 = case when p_cfh.utf8 then l_utf8_name else l_name end
      then
        l_rv := true;
        exit;
      end if;
      l_ind := l_ind + p_cfh.len;
      l_idx := l_idx + 1;
    end loop;
    --
    p_cfh.idx := l_idx;
    p_cfh.encoding := get_encoding( p_encoding );
    return l_rv;
  end;
  --
  function parse_file( p_zipped_blob blob, p_fh in out tp_cfh )
  return blob
  is
    l_rv blob;
    l_buf raw(3999);
    l_compression_method varchar2(4);
    l_n integer;
    l_m integer;
    l_crc raw(4);
  begin
    if p_fh.original_len is null
    then
      raise_application_error( -20006, 'File not found' );
    end if;
    if nvl( p_fh.original_len, 0 ) = 0
    then
      return empty_blob();
    end if;
    l_buf := dbms_lob.substr( p_zipped_blob, 30, p_fh.offset + 1 );
    if utl_raw.substr( l_buf, 1, 4 ) != c_LOCAL_FILE_HEADER
    then
      raise_application_error( -20007, 'Error parsing the zipfile' );
    end if;
    l_compression_method := utl_raw.substr( l_buf, 9, 2 );
    l_n := little_endian( l_buf, 27, 2 );
    l_m := little_endian( l_buf, 29, 2 );
    if l_compression_method = '0800'
    then
      if p_fh.original_len < 32767 and p_fh.compressed_len < 32748
      then
        return utl_compress.lz_uncompress( utl_raw.concat
                 ( hextoraw( '1F8B0800000000000003' )
                 , dbms_lob.substr( p_zipped_blob, p_fh.compressed_len, p_fh.offset + 31 + l_n + l_m )
                 , p_fh.crc32
                 , utl_raw.substr( utl_raw.reverse( to_char( p_fh.original_len, 'fm0XXXXXXXXXXXXXXX' ) ), 1, 4 )
                 ) );
      end if;
      l_rv := hextoraw( '1F8B0800000000000003' ); -- gzip header
      dbms_lob.copy( l_rv
                   , p_zipped_blob
                   , p_fh.compressed_len
                   , 11
                   , p_fh.offset + 31 + l_n + l_m
                   );
      dbms_lob.append( l_rv
                     , utl_raw.concat( p_fh.crc32
                                     , utl_raw.substr( utl_raw.reverse( to_char( p_fh.original_len, 'fm0XXXXXXXXXXXXXXX' ) ), 1, 4 )
                                     )
                     );
      return utl_compress.lz_uncompress( l_rv );
    elsif l_compression_method = '0000'
    then
      if p_fh.original_len < 32767 and p_fh.compressed_len < 32767
      then
        return dbms_lob.substr( p_zipped_blob
                              , p_fh.compressed_len
                              , p_fh.offset + 31 + l_n + l_m
                              );
      end if;
      dbms_lob.createtemporary( l_rv, true );
      dbms_lob.copy( l_rv
                   , p_zipped_blob
                   , p_fh.compressed_len
                   , 1
                   , p_fh.offset + 31 + l_n + l_m
                   );
      return l_rv;
    end if;
    raise_application_error( -20008, 'Unhandled compression method ' || l_compression_method );
  end parse_file;
  --
  function get_count( p_zipped_blob blob )
  return integer
  is
    l_info tp_zip_info;
  begin
    get_zip_info( p_zipped_blob, l_info );
    return nvl( l_info.cnt, 0 );
  end;
  --
  function load_font
    ( p_font              blob
    , p_embed             boolean
    , p_subset            boolean
    , p_offset            number
    , p_opentype_features boolean
    )
  return pls_integer
  is
    l_cfh  tp_cfh;
    l_font tp_font;
    type tp_font_table is record
      ( offset pls_integer
      , length pls_integer
      );
    type tp_tables is table of tp_font_table index by varchar2(4);
    l_tables tp_tables;
    l_tag   varchar2(4);
    l_buf   varchar2(32767);
    l_sz    pls_integer;
    l_cnt   pls_integer;
    l_idx   pls_integer;
    l_len   pls_integer;
    l_width pls_integer;
    l_glyph pls_integer;
    l_end   integer;
    l_max   integer;
    l_tmp   integer;
    l_offs  integer;
    l_start integer;
    --
    function substr2num( p_idx pls_integer )
    return integer
    is
    begin
      return uint16( substr( l_buf, p_idx, 4 ) );
    end;
    --
    function substr2snum( p_idx pls_integer )
    return integer
    is
      l_tmp integer := substr2num( p_idx );
    begin
      return case when l_tmp > 32767 then l_tmp - 65536 else l_tmp end;
    end;
    --
    function parse_script_list( p_offs integer )
    return tp_script_list
    is
      l_sz     pls_integer;
      l_done   pls_integer;
      l_to_do  pls_integer;
      l_b_cnt  pls_integer;
      l_script tp_script;
      l_list   tp_script_list;
      --
      function parse_lang_sys_table( p_offs integer )
      return tp_pls_tab
      is
        l_sz      pls_integer;
        l_done    pls_integer;
        l_to_do   pls_integer;
        l_b_cnt   pls_integer;
        l_buf     varchar2(32767);
        l_indices tp_pls_tab;
      begin
        l_buf := dbms_lob.substr( p_font, 6, p_offs );
        if substr( l_buf, 5, 4 ) != 'FFFF'
        then
          l_indices( 0 ) := uint16( substr( l_buf, 5, 4 ) );  -- requiredFeatureIndex
        else
          l_indices( 0 ) := null;
        end if;
        l_sz := 8100;
        l_done := l_sz;
        l_b_cnt := 0;
        l_to_do := uint16( substr( l_buf, 9, 4 ) );
        for i in 1 .. l_to_do
        loop
          if l_done = l_sz
          then
            l_buf := dbms_lob.substr( p_font, 2 * least( l_sz, l_to_do ), p_offs + 6 + l_b_cnt * 2 * l_sz );
            l_done := 0;
            l_b_cnt := l_b_cnt + 1;
            l_to_do := l_to_do - l_sz;
          end if;
          l_indices( i ) := uint16( substr( l_buf, 1 + 4 * l_done, 4 ) );
          l_done := l_done + 1;
        end loop;
        return l_indices;
      end parse_lang_sys_table;
      --
      function parse_script_table( p_offs integer )
      return tp_script_table
      is
        l_sz           pls_integer;
        l_done         pls_integer;
        l_to_do        pls_integer;
        l_b_cnt        pls_integer;
        l_buf          varchar2(32767);
        l_lang_sys     tp_lang_sys;
        l_script_table tp_script_table;
      begin
        l_buf := dbms_lob.substr( p_font, 4, p_offs );
        if substr( l_buf, 1, 4 ) != '0000'
        then
          l_lang_sys.feature_indices := parse_lang_sys_table( p_offs + uint16( substr( l_buf, 1, 4 ) ) );
        end if;
        l_script_table( 0 ) := l_lang_sys;  -- defaultLangSys
        l_lang_sys.feature_indices.delete;
        --
        l_sz := 2700;
        l_done := l_sz;
        l_b_cnt := 0;
        l_to_do := uint16( substr( l_buf, 5, 4 ) );
        for i in 1 .. l_to_do
        loop
          if l_done = l_sz
          then
            l_buf := dbms_lob.substr( p_font, 6 * least( l_sz, l_to_do ), p_offs + 4 + l_b_cnt * 6 * l_sz );
            l_done := 0;
            l_b_cnt := l_b_cnt + 1;
            l_to_do := l_to_do - l_sz;
          end if;
          l_lang_sys.feature_indices := parse_lang_sys_table( p_offs + uint16( substr( l_buf, 9 + 12 * l_done, 4 ) ) );
          l_lang_sys.tag := utl_raw.cast_to_varchar2( substr( l_buf, 1 + 12 * l_done, 8 ) );
          l_done := l_done + 1;
          l_script_table( i ) := l_lang_sys;
          l_lang_sys.feature_indices.delete;
        end loop;
        return l_script_table;
      end parse_script_table;
      --
    begin
      l_sz := 2700;
      l_done := l_sz;
      l_b_cnt := 0;
      l_to_do := uint16( rawtohex( dbms_lob.substr( p_font, 2, p_offs ) ) );
      for i in 1 .. l_to_do
      loop
        if l_done = l_sz
        then
          l_buf := dbms_lob.substr( p_font, 6 * least( l_sz, l_to_do ), p_offs + 2 + l_b_cnt * 6 * l_sz );
          l_done := 0;
          l_b_cnt := l_b_cnt + 1;
          l_to_do := l_to_do - l_sz;
        end if;
        l_script.script_table := parse_script_table( p_offs + substr2num( 9 + 12 * l_done ) );
        l_script.tag := utl_raw.cast_to_varchar2( substr( l_buf, 1 + 12 * l_done, 8 ) );
        l_list( i ) := l_script;
        l_done := l_done + 1;
      end loop;
      return l_list;
    end parse_script_list;
    --
    function parse_coverage( p_offs integer )
    return tp_pls_tab
    is
      l_sz    pls_integer;
      l_done  pls_integer;
      l_to_do pls_integer;
      l_b_cnt pls_integer;
      l_cnt   pls_integer;
      l_glyph pls_integer;
      l_buf   varchar2(32767);
      l_rv    tp_pls_tab;
      l_tmp   tp_pls_tab;
    begin
-- https://learn.microsoft.com/en-us/typography/opentype/spec/chapter2#coverage-table
      l_buf := dbms_lob.substr( p_font, 4, p_offs );
      l_to_do := uint16( substr( l_buf, 5, 4 ) );
      if substr( l_buf, 1, 4 ) = '0001'
      then
        l_sz := 8100;
        l_done := l_sz;
        l_b_cnt := 0;
        for i in 0 .. l_to_do - 1  -- zero-based
        loop
          if l_done = l_sz
          then
            l_buf := dbms_lob.substr( p_font, 2 * least( l_sz, l_to_do ), p_offs + 4 + l_b_cnt * 2 * l_sz );
            l_done := 0;
            l_b_cnt := l_b_cnt + 1;
            l_to_do := l_to_do - l_sz;
          end if;
          l_tmp( uint16( substr( l_buf, 1 + 4 * l_done, 4 ) ) ) := i;
          l_done := l_done + 1;
        end loop;
      elsif substr( l_buf, 1, 4 ) = '0002'
      then
        l_cnt := 0;
        l_sz := 2700;
        l_done := l_sz;
        l_b_cnt := 0;
        for i in 1 .. l_to_do
        loop
          if l_done = l_sz
          then
            l_buf := dbms_lob.substr( p_font, 6 * least( l_sz, l_to_do ), p_offs + 4 + l_b_cnt * 6 * l_sz );
            l_done := 0;
            l_b_cnt := l_b_cnt + 1;
            l_to_do := l_to_do - l_sz;
          end if;
          for j in uint16( substr( l_buf, 1 + 12 * l_done, 4 ) ) .. uint16( substr( l_buf, 5 + 12 * l_done, 4 ) )
          loop
             l_tmp( j ) := l_cnt;
             l_cnt := l_cnt + 1;
          end loop;
          l_done := l_done + 1;
        end loop;
      end if;
      l_glyph := l_tmp.first;
      while l_glyph is not null
      loop
        l_rv( l_tmp( l_glyph ) ) := l_glyph;
        l_glyph := l_tmp.next( l_glyph );
      end loop;
      return l_rv;
    end parse_coverage;
    --
    function parse_feature_list( p_offs integer )
    return tp_feature_list
    is
      l_sz      pls_integer;
      l_done    pls_integer;
      l_to_do   pls_integer;
      l_b_cnt   pls_integer;
      l_feature tp_feature;
      l_list    tp_feature_list;
      --
      function parse_feature_table( p_offs integer )
      return tp_pls_tab
      is
        l_sz      pls_integer;
        l_done    pls_integer;
        l_to_do   pls_integer;
        l_b_cnt   pls_integer;
        l_buf     varchar2(32767);
        l_lookups tp_pls_tab;
      begin
        l_buf := dbms_lob.substr( p_font, 4, p_offs );
        -- don't handle featureParams
        l_sz := 8100;
        l_done := l_sz;
        l_b_cnt := 0;
        l_to_do := uint16( substr( l_buf, 5, 4 ) );
        for i in 1 .. l_to_do
        loop
          if l_done = l_sz
          then
            l_buf := dbms_lob.substr( p_font, 2 * least( l_sz, l_to_do ), p_offs + 4 + l_b_cnt * 2 * l_sz );
            l_done := 0;
            l_b_cnt := l_b_cnt + 1;
            l_to_do := l_to_do - l_sz;
          end if;
          l_lookups( i ) := uint16( substr( l_buf, 1 + 4 * l_done, 4 ) );
          l_done := l_done + 1;
        end loop;
        return l_lookups;
      end parse_feature_table;
      --
    begin
      l_sz := 2700;
      l_done := l_sz;
      l_b_cnt := 0;
      l_to_do := uint16( rawtohex( dbms_lob.substr( p_font, 2, p_offs ) ) );
      for i in 0 .. l_to_do - 1  -- zero-based
      loop
        if l_done = l_sz
        then
          l_buf := dbms_lob.substr( p_font, 6 * least( l_sz, l_to_do ), p_offs + 2 + l_b_cnt * 6 * l_sz );
          l_done := 0;
          l_b_cnt := l_b_cnt + 1;
          l_to_do := l_to_do - l_sz;
        end if;
        l_feature.lookups := parse_feature_table( p_offs + substr2num( 9 + 12 * l_done ) );
        l_feature.tag := utl_raw.cast_to_varchar2( substr( l_buf, 1 + 12 * l_done, 8 ) );
        l_list( i ) := l_feature;
        l_done := l_done + 1;
      end loop;
      return l_list;
    end parse_feature_list;
    --
    function parse_class_def( p_offs integer )
    return tp_pls_tab
    is
      l_class  pls_integer;
      l_start  pls_integer;
      l_sz     pls_integer;
      l_done   pls_integer;
      l_to_do  pls_integer;
      l_b_cnt  pls_integer;
      l_buf    varchar2(32767);
      l_rv     tp_pls_tab;
    begin
      -- https://learn.microsoft.com/en-us/typography/opentype/spec/chapter2#classDefTbl
      l_buf := dbms_lob.substr( p_font, 6, p_offs );
      if substr( l_buf, 1, 4 ) = '0001'
      then
        l_start := uint16( substr( l_buf, 5, 4 ) );
        l_sz := 8100;
        l_done := l_sz;
        l_b_cnt := 0;
        l_to_do := uint16( substr( l_buf, 9, 4 ) );
        for i in 0 .. l_to_do - 1
        loop
          if l_done = l_sz
          then
            l_buf := dbms_lob.substr( p_font, 2 * least( l_sz, l_to_do ), p_offs + 6 + l_b_cnt * 2 * l_sz );
            l_done := 0;
            l_b_cnt := l_b_cnt + 1;
            l_to_do := l_to_do - l_sz;
          end if;
          l_rv( l_start + i ) := uint16( substr( l_buf, 1 + 4 * l_done, 4 ) );
          l_done := l_done + 1;
        end loop;
      elsif substr( l_buf, 1, 4 ) = '0002'
      then
        l_sz := 2700;
        l_done := l_sz;
        l_b_cnt := 0;
        l_to_do := uint16( substr( l_buf, 5, 4 ) );
        for i in 1 .. l_to_do
        loop
          if l_done = l_sz
          then
            l_buf := dbms_lob.substr( p_font, 6 * least( l_sz, l_to_do ), p_offs + 4 + l_b_cnt * 6 * l_sz );
            l_done := 0;
            l_b_cnt := l_b_cnt + 1;
            l_to_do := l_to_do - l_sz;
          end if;
          l_class := uint16( substr( l_buf, 9 + 12 * l_done, 4 ) );
          for j in uint16( substr( l_buf, 1 + 12 * l_done, 4 ) ) .. uint16( substr( l_buf, 5 + 12 * l_done, 4 ) )
          loop
            l_rv( j ) := l_class;
          end loop;
          l_done := l_done + 1;
        end loop;
      end if;
      return l_rv;
    end parse_class_def;
    --
    procedure parse_gsub( p_font_idx pls_integer, p_offset integer )
    is
      l_header varchar2(32);
      l_gsub   tp_gsub_gpos;
      --
      procedure parse_lookup_list( p_offs integer )
      is
        l_sz          pls_integer;
        l_done        pls_integer;
        l_to_do       pls_integer;
        l_b_cnt       pls_integer;
        l_lookup      tp_lookup;
        l_null_lookup tp_lookup;
        --
        procedure parse_lookup_type1( p_idx pls_integer, p_offs integer )
        is
          l_buf      varchar2(32767);
          l_diff     pls_integer;
          l_glyph    pls_integer;
          l_sz       pls_integer;
          l_done     pls_integer;
          l_to_do    pls_integer;
          l_b_cnt    pls_integer;
          l_coverage tp_pls_tab;
          l_subtable tp_subtable;
        begin
-- https://learn.microsoft.com/en-us/typography/opentype/spec/gsub#lookup-type-1-subtable-single-substitution
          l_buf := dbms_lob.substr( p_font, 6, p_offs );
          l_coverage := parse_coverage( p_offs + uint16( substr( l_buf, 5, 4 ) ) );
          if substr( l_buf, 1, 4 ) = '0001'
          then
            l_diff := int16( substr( l_buf, 9, 4 ) );
            for i in 0 .. l_coverage.count - 1
            loop
              l_glyph := l_coverage( i );
              l_subtable.coverage( l_glyph ) := l_glyph + l_diff;
              l_lookup.coverage( l_glyph )( p_idx ) := null;
            end loop;
          else
            l_sz := 8100;
            l_done := l_sz;
            l_b_cnt := 0;
            l_to_do := uint16( substr( l_buf, 9, 4 ) );
            for i in 0 .. l_to_do - 1
            loop
              if l_done = l_sz
              then
                l_buf := dbms_lob.substr( p_font, 2 * least( l_sz, l_to_do ), p_offs + 6 + l_b_cnt * 2 * l_sz );
                l_done := 0;
                l_b_cnt := l_b_cnt + 1;
                l_to_do := l_to_do - l_sz;
              end if;
              l_glyph := l_coverage( i );
              l_subtable.coverage( l_glyph ) := uint16( substr( l_buf, 1 + 4 * l_done, 4 ) );
              l_lookup.coverage( l_glyph )( p_idx ) := null;
              l_done := l_done + 1;
            end loop;
          end if;
          l_lookup.subtables( p_idx ) := l_subtable;
        end parse_lookup_type1;
        --
        procedure parse_lookup_type2( p_idx pls_integer, p_offs integer )
        is
          l_buf      varchar2(32767);
          l_glyph    pls_integer;
          l_sz       pls_integer;
          l_done     pls_integer;
          l_to_do    pls_integer;
          l_b_cnt    pls_integer;
          l_coverage tp_pls_tab;
          l_subtable tp_subtable;
          --
          procedure parse_sequence_table( p_offs integer )
          is
            l_buf varchar2(32767);
            l_cnt pls_integer;
          begin
            l_buf := dbms_lob.substr( p_font, 2, p_offs );
            l_cnt := uint16( substr( l_buf, 1, 4 ) );
            l_buf := dbms_lob.substr( p_font, 2 * l_cnt, p_offs + 2 );
            for i in 1 .. l_cnt
            loop
              l_subtable.matrix( l_glyph )( i ) := uint16( substr( l_buf, -3 + i * 4, 4 ) );
            end loop;
          end parse_sequence_table;
          --
        begin
-- https://learn.microsoft.com/en-us/typography/opentype/spec/gsub#lookup-type-2-subtable-multiple-substitution
          l_buf := dbms_lob.substr( p_font, 6, p_offs );
          l_coverage := parse_coverage( p_offs + uint16( substr( l_buf, 5, 4 ) ) );
          l_sz := 8100;
          l_done := l_sz;
          l_b_cnt := 0;
          l_to_do := uint16( substr( l_buf, 9, 4 ) );
          for i in 0 .. l_to_do - 1
          loop
            if l_done = l_sz
            then
              l_buf := dbms_lob.substr( p_font, 2 * least( l_sz, l_to_do ), p_offs + 6 + l_b_cnt * 2 * l_sz );
              l_done := 0;
              l_b_cnt := l_b_cnt + 1;
              l_to_do := l_to_do - l_sz;
            end if;
            l_glyph := l_coverage( i );
            l_subtable.coverage( l_glyph ) := null;
            l_lookup.coverage( l_glyph )( p_idx ) := null;
            parse_sequence_table( p_offs + uint16( substr( l_buf, 1 + 4 * l_done, 4 ) ) );
            l_done := l_done + 1;
          end loop;
          l_lookup.subtables( p_idx ) := l_subtable;
        end parse_lookup_type2;
        --
        procedure parse_lookup_type4( p_idx pls_integer, p_offs integer )
        is
          l_buf      varchar2(32767);
          l_diff     pls_integer;
          l_glyph    pls_integer;
          l_sz       pls_integer;
          l_done     pls_integer;
          l_to_do    pls_integer;
          l_b_cnt    pls_integer;
          l_coverage tp_pls_tab;
          l_subtable tp_subtable;
          --
          procedure parse_ligature( p_offs integer, p_idx pls_integer )
          is
            l_buf  varchar2(32767);
            l_cnt  pls_integer;
            l_liga pls_integer;
          begin
            l_buf := dbms_lob.substr( p_font, 4, p_offs );
            l_cnt := uint16( substr( l_buf, 5, 4 ) ) - 1;
            l_liga := uint16( substr( l_buf, 1, 4 ) );
            l_subtable.matrix( l_glyph )( p_idx * 20 ) := l_cnt;
            l_subtable.matrix( l_glyph )( p_idx * 20 + 1 ) := l_liga;
            l_buf := dbms_lob.substr( p_font, 2 * l_cnt, p_offs + 4 );
            for i in 0 .. l_cnt - 1
            loop
              l_subtable.matrix( l_glyph )( p_idx * 20 + 2 + i ) := uint16( substr( l_buf, 1 + i * 4, 4 ) );
            end loop;
          end parse_ligature;
          --
          procedure parse_ligature_set_table( p_offs integer )
          is
            l_buf varchar2(32767);
            l_cnt pls_integer;
          begin
            l_cnt := uint16( dbms_lob.substr( p_font, 2, p_offs ) );
            l_subtable.matrix( l_glyph )( 0 ) := l_cnt;
            l_buf := dbms_lob.substr( p_font, 2 * l_cnt, p_offs + 2 );
            for i in 0 .. l_cnt - 1
            loop
              parse_ligature( p_offs + uint16( substr( l_buf, 1 + i * 4, 4 ) ), i + 1);
            end loop;
          end parse_ligature_set_table;
          --
        begin
-- https://learn.microsoft.com/en-us/typography/opentype/spec/gsub#lookup-type-4-subtable-ligature-substitution
          l_buf := dbms_lob.substr( p_font, 6, p_offs );
          l_coverage := parse_coverage( p_offs + uint16( substr( l_buf, 5, 4 ) ) );
          l_sz := 8100;
          l_done := l_sz;
          l_b_cnt := 0;
          l_to_do := uint16( substr( l_buf, 9, 4 ) );
          for i in 0 .. l_to_do - 1
          loop
            if l_done = l_sz
            then
              l_buf := dbms_lob.substr( p_font, 2 * least( l_sz, l_to_do ), p_offs + 6 + l_b_cnt * 2 * l_sz );
              l_done := 0;
              l_b_cnt := l_b_cnt + 1;
              l_to_do := l_to_do - l_sz;
            end if;
            l_glyph := l_coverage( i );
            l_subtable.coverage( l_glyph ) := null;
            l_lookup.coverage( l_glyph )( p_idx ) := null;
            parse_ligature_set_table( p_offs + uint16( substr( l_buf, 1 + 4 * l_done, 4 ) ) );
            l_done := l_done + 1;
          end loop;
          l_lookup.subtables( p_idx ) := l_subtable;
        end parse_lookup_type4;
        --
        procedure parse_lookup_type5( p_idx pls_integer, p_offs integer )
        is
          l_buf        varchar2(32767);
          l_offs       pls_integer;
          l_to_do      pls_integer;
          l_glyph      pls_integer;
          l_seq_lu_cnt pls_integer;
          l_class      tp_pls_tab;
          l_coverage   tp_pls_tab;
          l_subtable   tp_subtable;
          --
          procedure parse_seq_lookup( p_buf   varchar2
                                    , p_bias  pls_integer
                                    , p_to_do pls_integer
                                    )
          is
          begin
            l_subtable.matrix( l_glyph )( p_bias ) := p_to_do;
            for i in 0 .. p_to_do - 1
            loop
              l_subtable.matrix( l_glyph )( p_bias + 1 + 2 * i ) := uint16( substr( p_buf, 1 + i * 8, 4 ) );
              l_subtable.matrix( l_glyph )( p_bias + 2 + 2 * i ) := uint16( substr( p_buf, 5 + i * 8, 4 ) );
            end loop;
          end parse_seq_lookup;
          --
          procedure parse_seq_rule( p_idx pls_integer, p_offs integer )
          is
            l_buf        varchar2(32767);
            l_sz         pls_integer;
            l_seq_lu_cnt pls_integer;
            l_to_do      pls_integer;
            l_bias       constant pls_integer := 100 * p_idx;
          begin
            l_sz := 15;
            l_buf := dbms_lob.substr( p_font, 2 * l_sz, p_offs );
            l_seq_lu_cnt := uint16( substr( l_buf, 5, 4 ) );
            l_to_do := uint16( substr( l_buf, 1, 4 ) ) - 1;
            l_buf := substr( l_buf, 9 );
            if 2 + l_to_do + 2 * l_tmp > l_sz
            then
              l_buf := l_buf || dbms_lob.substr( p_font, 2 * ( 2 + l_to_do + 2 * l_tmp - l_sz ), p_offs + 2 * l_sz );
            end if;
            l_subtable.matrix( l_glyph )( l_bias + 20 ) := l_to_do;
            for i in 0 .. l_to_do - 1
            loop
              l_subtable.matrix( l_glyph )( l_bias + 21 + i ) := uint16( substr( l_buf, 1 + i * 4, 4 ) );
            end loop;
            parse_seq_lookup( substr( l_buf, 1 + 4 * l_to_do ), l_bias + 80, l_seq_lu_cnt );
          end parse_seq_rule;
          --
          procedure parse_seq_rule_set( p_offs integer )
          is
            l_buf   varchar2(32767);
            l_to_do pls_integer;
          begin
            l_to_do := uint16( dbms_lob.substr( p_font, 2, p_offs ) );
            l_subtable.matrix( l_glyph )( 0 ) := l_to_do;
            l_buf := dbms_lob.substr( p_font, 2 * l_to_do, p_offs + 2 );
            for i in 0 .. l_to_do - 1
            loop
              parse_seq_rule( i + 1, p_offs + uint16( substr( l_buf, 1 + 4 * i, 4 ) ) );
            end loop;
          end parse_seq_rule_set;
          --
        begin
-- https://learn.microsoft.com/en-us/typography/opentype/spec/gsub#lookup-type-5-subtable-contextual-substitution
          l_buf := dbms_lob.substr( p_font, 8, p_offs );
          l_subtable.data_list( 0 ) := substr( l_buf, 4, 1 );
          if substr( l_buf, 4, 1 ) = '1'
          then
-- https://learn.microsoft.com/en-us/typography/opentype/spec/chapter2#sequence-context-format-1-simple-glyph-contexts
            l_coverage := parse_coverage( p_offs + uint16( substr( l_buf, 5, 4 ) ) );
            l_to_do := least( uint16( substr( l_buf, 9, 4 ) ), l_coverage.count );
            l_buf := dbms_lob.substr( p_font, 2 * l_to_do, p_offs + 6 );
            for i in 0 .. l_to_do - 1
            loop
              l_glyph := l_coverage( i );
              l_subtable.coverage( l_glyph ) := null;
              l_lookup.coverage( l_glyph )( p_idx ) := null;
              l_offs := uint16( substr( l_buf, 1 + 4 * i, 4 ) );
              if l_offs > 0
              then
                parse_seq_rule_set( p_offs + l_offs );
              else
                l_subtable.matrix( l_glyph )( 0 ) := 0;
              end if;
            end loop;
          elsif substr( l_buf, 4, 1 ) = '2'
          then
-- https://learn.microsoft.com/en-us/typography/opentype/spec/chapter2#sequence-context-format-2-class-based-glyph-contexts
            l_coverage := parse_coverage( p_offs + uint16( substr( l_buf, 5, 4 ) ) );
            l_class := parse_class_def( p_offs + uint16( substr( l_buf, 9, 4 ) ) );
            l_to_do := uint16( substr( l_buf, 13, 4 ) );
            for i in 0 .. l_coverage.count - 1
            loop
              l_glyph := l_coverage( i );
              l_subtable.coverage( l_glyph ) := l_class( l_glyph );
              l_lookup.coverage( l_glyph )( p_idx ) := null;
            end loop;
            l_glyph := l_class.first;
            while l_glyph is not null
            loop
              l_subtable.matrix( - l_glyph )( 1 ) := l_class( l_glyph );
              l_glyph := l_class.next( l_glyph );
            end loop;
            l_buf := dbms_lob.substr( p_font, 2 * l_to_do, p_offs + 8 );
            for i in 0 .. l_to_do - 1
            loop
              l_glyph := i + 1; -- = class
              l_offs := uint16( substr( l_buf, 1 + 4 * i, 4 ) );
              if l_offs > 0
              then
                parse_seq_rule_set( p_offs + l_offs );
              else
                l_subtable.matrix( l_glyph )( 0 ) := 0;
              end if;
            end loop;
          else
-- https://learn.microsoft.com/en-us/typography/opentype/spec/chapter2#sequence-context-format-3-coverage-based-glyph-contexts
            l_to_do := uint16( substr( l_buf, 5, 4 ) );
            l_seq_lu_cnt := uint16( substr( l_buf, 9, 4 ) );
            l_subtable.data_list( 1 ) := l_to_do;
            l_buf := dbms_lob.substr( p_font, 2 * l_to_do + 4 * l_seq_lu_cnt, p_offs + 6 );
            for j in 0 .. l_to_do - 1
            loop
              l_coverage := parse_coverage( p_offs + uint16( substr( l_buf, 1 + j * 4, 4 ) ) );
              for i in 0 .. l_coverage.count - 1
              loop
                l_glyph := l_coverage( i );
                if j = 0
                then
                  l_subtable.coverage( l_glyph ) := null;
                  l_lookup.coverage( l_glyph )( p_idx ) := null;
                else
                  l_subtable.matrix( - j )( l_glyph ) := null;
                end if;
              end loop;
            end loop;
            l_glyph := 1;
            parse_seq_lookup( substr( l_buf, 1 + 4 * l_to_do ), 0, l_seq_lu_cnt );
          end if;
          l_lookup.subtables( p_idx ) := l_subtable;
        end parse_lookup_type5;
        --
        procedure parse_lookup_type6( p_idx pls_integer, p_offs integer )
        is
          l_buf       varchar2(32767);
          l_offs      pls_integer;
          l_sz        pls_integer;
          l_done      pls_integer;
          l_to_do     pls_integer;
          l_b_cnt     pls_integer;
          l_glyph     pls_integer;
          l_cnt       pls_integer;
          l_ind       pls_integer;
          l_coverage  tp_pls_tab;
          l_bt_class  tp_pls_tab;
          l_inp_class tp_pls_tab;
          l_lah_class tp_pls_tab;
          l_subtable  tp_subtable;
          --
          procedure parse_seq_lookup( p_offs  integer
                                    , p_glyph pls_integer
                                    , p_bias  pls_integer
                                    , p_to_do pls_integer
                                    )
          is
            l_buf   varchar2(32767);
            l_sz    pls_integer;
            l_done  pls_integer;
            l_to_do pls_integer;
            l_b_cnt pls_integer;
          begin
            l_subtable.matrix( p_glyph )( p_bias ) := p_to_do;
            l_sz := 10;
            l_done := l_sz;
            l_b_cnt := 0;
            l_to_do := p_to_do;
            for i in 0 .. p_to_do - 1
            loop
              if l_done = l_sz
              then
                l_buf := dbms_lob.substr( p_font, 4 * least( l_sz, l_to_do ), p_offs + l_b_cnt * 4 * l_sz );
                l_done := 0;
                l_b_cnt := l_b_cnt + 1;
                l_to_do := l_to_do - l_sz;
              end if;
              l_subtable.matrix( p_glyph )( p_bias + 1 + 2 * i ) := uint16( substr( l_buf, 1 + 8 * l_done, 4 ) );
              l_subtable.matrix( p_glyph )( p_bias + 2 + 2 * i ) := uint16( substr( l_buf, 5 + 8 * l_done, 4 ) );
              l_done := l_done + 1;
            end loop;
          end parse_seq_lookup;
          --
          procedure parse_chained_seq_rule( p_idx pls_integer, p_offs integer )
          is
            l_buf   varchar2(32767);
            l_sz    pls_integer;
            l_done  pls_integer;
            l_to_do pls_integer;
            l_tmp   pls_integer;
            l_what  pls_integer;
            l_cnt   pls_integer;
            l_pos   pls_integer;
            l_bias  constant pls_integer := 100 * p_idx;
          begin
            l_sz := 40;
            l_done := l_sz;
            l_what := 0;
            l_to_do := 0;
            l_pos := 1;
            loop
              if l_done = l_sz
              then
                l_buf := dbms_lob.substr( p_font, 2 * l_sz, p_offs );
                l_done := 0;
              end if;
              if l_to_do <= 0
              then
                exit when l_what = 4;
                l_what := l_what + 1;
                l_to_do := uint16( substr( l_buf, 1 + 4 * l_done, 4 ) );
                if l_what = 2
                then
                  l_to_do := l_to_do - 1;
                elsif l_what = 4
                then
                  parse_seq_lookup( p_offs + 2 * l_pos, l_glyph, l_bias + 80, l_to_do );
                  exit;
                  l_to_do := 2 * l_to_do;
                end if;
                l_tmp := l_to_do;
                l_subtable.matrix( l_glyph )( l_bias + 20 * l_what ) := l_tmp;
              else
                l_to_do := l_to_do - 1;
                l_subtable.matrix( l_glyph )( l_bias + 20 * l_what + l_tmp - l_to_do ) := uint16( substr( l_buf, 1 + 4 * l_done, 4 ) );
              end if;
              l_pos := l_pos + 1;
              l_done := l_done + 1;
            end loop;
          end parse_chained_seq_rule;
          --
          procedure parse_chained_seq_rule_set( p_offs integer )
          is
            l_buf   varchar2(32767);
            l_to_do pls_integer;
          begin
            l_to_do := uint16( dbms_lob.substr( p_font, 2, p_offs ) );
            l_subtable.matrix( l_glyph )( 0 ) := l_to_do;
            l_buf := dbms_lob.substr( p_font, 2 * l_to_do, p_offs + 2 );
            for i in 0 .. l_to_do - 1
            loop
              parse_chained_seq_rule( i + 1, p_offs + uint16( substr( l_buf, 1 + 4 * i, 4 ) ) );
            end loop;
          end parse_chained_seq_rule_set;
        begin
-- https://learn.microsoft.com/en-us/typography/opentype/spec/gsub#lookup-type-6-subtable-chained-contexts-substitution
          l_buf := dbms_lob.substr( p_font, 6, p_offs );
          l_subtable.data_list( 0 ) := substr( l_buf, 4, 1 );
          if substr( l_buf, 1, 4 ) = '0001'
          then
-- https://learn.microsoft.com/en-us/typography/opentype/spec/chapter2#chseqctxt1
            l_coverage := parse_coverage( p_offs + uint16( substr( l_buf, 5, 4 ) ) );
            l_sz := 8100;
            l_done := l_sz;
            l_b_cnt := 0;
            l_to_do := least( uint16( substr( l_buf, 9, 4 ) ), l_coverage.count );
            for i in 0 .. l_to_do - 1
            loop
              if l_done = l_sz
              then
                l_buf := dbms_lob.substr( p_font, 2 * least( l_sz, l_to_do ), p_offs + 6 + l_b_cnt * 2 * l_sz );
                l_done := 0;
                l_b_cnt := l_b_cnt + 1;
                l_to_do := l_to_do - l_sz;
              end if;
              l_glyph := l_coverage( i );
              l_subtable.coverage( l_glyph ) := null;
              l_lookup.coverage( l_glyph )( p_idx ) := null;
              l_offs := uint16( substr( l_buf, 1 + 4 * l_done, 4 ) );
              if l_offs > 0
              then
                parse_chained_seq_rule_set( p_offs + l_offs );
              else
                l_subtable.matrix( l_glyph )( 0 ) := 0;
              end if;
              l_done := l_done + 1;
            end loop;
          elsif substr( l_buf, 1, 4 ) = '0003'
          then
-- -- https://learn.microsoft.com/en-us/typography/opentype/spec/chapter2#chseqctxt3
            l_offs := 2;
            l_sz := 8100;
            l_done := l_sz;
            l_b_cnt := 0;
            l_to_do := uint16( dbms_lob.substr( p_font, 2, p_offs + l_offs ) );
            l_subtable.data_list( 1 ) := l_to_do;
            l_offs := l_offs + 2;
            for i in 0 .. l_to_do - 1
            loop
              if l_done = l_sz
              then
                l_buf := dbms_lob.substr( p_font, 2 * least( l_sz, l_to_do ), p_offs + l_offs );
                l_offs := l_offs + 2 * least( l_sz, l_to_do );
                l_done := 0;
                l_b_cnt := l_b_cnt + 1;
                l_to_do := l_to_do - l_sz;
              end if;
              l_coverage := parse_coverage( p_offs + uint16( substr( l_buf, 1 + 4 * l_done, 4 ) ) );
              for j in 0 .. l_coverage.count - 1
              loop
                l_subtable.matrix( i + 1 )( l_coverage( j ) ) := null;
              end loop;
              l_done := l_done + 1;
            end loop;
            --
            l_done := l_sz;
            l_b_cnt := 0;
            l_to_do := uint16( dbms_lob.substr( p_font, 2, p_offs + l_offs ) );
            l_subtable.data_list( 2 ) := l_to_do;
            l_offs := l_offs + 2;
            for i in 0 .. l_to_do - 1
            loop
              if l_done = l_sz
              then
                l_buf := dbms_lob.substr( p_font, 2 * least( l_sz, l_to_do ), p_offs + l_offs );
                l_offs := l_offs + 2 * least( l_sz, l_to_do );
                l_done := 0;
                l_b_cnt := l_b_cnt + 1;
                l_to_do := l_to_do - l_sz;
              end if;
              l_coverage := parse_coverage( p_offs + uint16( substr( l_buf, 1 + 4 * l_done, 4 ) ) );
              for j in 0 .. l_coverage.count - 1
              loop
                l_glyph := l_coverage( j );
                if i = 0
                then
                  l_subtable.coverage( l_glyph ) := null;
                  l_lookup.coverage( l_glyph )( p_idx ) := null;
                else
                  l_subtable.matrix( 100 + i )( l_coverage( j ) ) := null;
                end if;
              end loop;
              l_done := l_done + 1;
            end loop;
            --
            l_done := l_sz;
            l_b_cnt := 0;
            l_to_do := uint16( dbms_lob.substr( p_font, 2, p_offs + l_offs ) );
            l_subtable.data_list( 3 ) := l_to_do;
            l_offs := l_offs + 2;
            for i in 0 .. l_to_do - 1
            loop
              if l_done = l_sz
              then
                l_buf := dbms_lob.substr( p_font, 2 * least( l_sz, l_to_do ), p_offs + l_offs );
                l_offs := l_offs + 2 * least( l_sz, l_to_do );
                l_done := 0;
                l_b_cnt := l_b_cnt + 1;
                l_to_do := l_to_do - l_sz;
              end if;
              l_coverage := parse_coverage( p_offs + uint16( substr( l_buf, 1 + 4 * l_done, 4 ) ) );
              for j in 0 .. l_coverage.count - 1
              loop
                l_subtable.matrix( - i - 1 )( l_coverage( j ) ) := null;
              end loop;
              l_done := l_done + 1;
            end loop;
            --
            l_done := l_sz;
            l_b_cnt := 0;
            l_to_do := uint16( dbms_lob.substr( p_font, 2, p_offs + l_offs ) );
            l_offs := l_offs + 2;
            parse_seq_lookup( p_offs + l_offs, 0, 0, l_to_do );
          else
-- https://learn.microsoft.com/en-us/typography/opentype/spec/chapter2#chseqctxt2
            l_coverage := parse_coverage( p_offs + uint16( substr( l_buf, 5, 4 ) ) );
            l_buf := dbms_lob.substr( p_font, 8, p_offs + 4 );
            l_bt_class := parse_class_def( p_offs + uint16( substr( l_buf, 1, 4 ) ) );
            l_subtable.data_list( 1 ) := l_bt_class.count;
            l_inp_class := parse_class_def( p_offs + uint16( substr( l_buf, 5, 4 ) ) );
            l_subtable.data_list( 2 ) := l_inp_class.count;
            l_lah_class := parse_class_def( p_offs + uint16( substr( l_buf, 9, 4 ) ) );
            l_subtable.data_list( 3 ) := l_lah_class.count;
            l_to_do := uint16( substr( l_buf, 13, 4 ) );
            l_subtable.data_list( 4 ) := l_to_do;
            l_glyph := l_bt_class.first;
            while l_glyph is not null
            loop
              l_subtable.matrix( - l_glyph )( 1 ) := l_bt_class( l_glyph );
              l_glyph := l_bt_class.next( l_glyph );
            end loop;
            l_glyph := l_lah_class.first;
            while l_glyph is not null
            loop
              l_subtable.matrix( - l_glyph )( 3 ) := l_lah_class( l_glyph );
              l_glyph := l_lah_class.next( l_glyph );
            end loop;
            l_glyph := l_inp_class.first;
            while l_glyph is not null
            loop
              l_subtable.matrix( - l_glyph )( 2 ) := l_inp_class( l_glyph );
              l_glyph := l_inp_class.next( l_glyph );
            end loop;
            for i in 0 .. l_coverage.count - 1
            loop
              l_glyph := l_coverage( i );
              l_subtable.coverage( l_glyph ) := l_inp_class( l_glyph );
              l_lookup.coverage( l_glyph )( p_idx ) := null;
            end loop;
            --
            l_buf := dbms_lob.substr( p_font, 2 * l_to_do, p_offs + 12 );
            for i in 0 .. l_to_do - 1
            loop
              l_glyph := i; -- = class
              l_offs := uint16( substr( l_buf, 1 + i * 4, 4 ) );
              if l_offs > 0
              then
                parse_chained_seq_rule_set( p_offs + l_offs );
              else
                l_subtable.matrix( l_glyph )( 0 ) := 0;
              end if;
            end loop;
          end if;
          l_lookup.subtables( p_idx ) := l_subtable;
        end parse_lookup_type6;
        --
        procedure parse_lookup_type7( p_idx pls_integer, p_offs integer )
        is
          l_buf varchar2(16);
        begin
-- https://learn.microsoft.com/en-us/typography/opentype/spec/gsub#lookup-type-7-subtable-substitution-subtable-extension
          l_buf := dbms_lob.substr( p_font, 8, p_offs );
          case substr( l_buf, 5, 4 )
            when '0001' then parse_lookup_type1( p_idx, p_offs + to_number( substr( l_buf, 9, 8 ), 'XXXXXXXX' ) );
            when '0002' then parse_lookup_type2( p_idx, p_offs + to_number( substr( l_buf, 9, 8 ), 'XXXXXXXX' ) );
            when '0004' then parse_lookup_type4( p_idx, p_offs + to_number( substr( l_buf, 9, 8 ), 'XXXXXXXX' ) );
            when '0005' then parse_lookup_type5( p_idx, p_offs + to_number( substr( l_buf, 9, 8 ), 'XXXXXXXX' ) );
            when '0006' then parse_lookup_type6( p_idx, p_offs + to_number( substr( l_buf, 9, 8 ), 'XXXXXXXX' ) );
            else null;
          end case;
        end parse_lookup_type7;
        --
        function parse_lookup_table( p_offs integer )
        return tp_lookup
        is
          l_sz    pls_integer;
          l_done  pls_integer;
          l_to_do pls_integer;
          l_b_cnt pls_integer;
          l_buf   varchar2(32767);
        begin
-- https://learn.microsoft.com/en-us/typography/opentype/spec/chapter2#lookup-table
          l_lookup := l_null_lookup;
          l_buf := dbms_lob.substr( p_font, 6, p_offs );
          l_lookup.lookup_type := uint16( substr( l_buf, 1, 4 ) );
          l_lookup.lookup_flags := uint16( substr( l_buf, 5, 4 ) );
          l_sz := 8100;
          l_done := l_sz;
          l_b_cnt := 0;
          l_to_do := uint16( substr( l_buf, 9, 4 ) );
          if bitand( l_lookup.lookup_flags, 16 ) > 0
          then
            l_lookup.mark_filtering_set := uint16( rawtohex( dbms_lob.substr( p_font, 2, p_offs + 6 + 2 * l_to_do ) ) );
          end if;
          for i in 1 .. l_to_do
          loop
            if l_done = l_sz
            then
              l_buf := dbms_lob.substr( p_font, 2 * least( l_sz, l_to_do ), p_offs + 6 + l_b_cnt * 2 * l_sz );
              l_done := 0;
              l_b_cnt := l_b_cnt + 1;
              l_to_do := l_to_do - l_sz;
            end if;
            case l_lookup.lookup_type
              when 1 then parse_lookup_type1( i, p_offs + uint16( substr( l_buf, 1 + 4 * l_done, 4 ) ) );
              when 2 then parse_lookup_type2( i, p_offs + uint16( substr( l_buf, 1 + 4 * l_done, 4 ) ) );
              when 4 then parse_lookup_type4( i, p_offs + uint16( substr( l_buf, 1 + 4 * l_done, 4 ) ) );
              when 5 then parse_lookup_type5( i, p_offs + uint16( substr( l_buf, 1 + 4 * l_done, 4 ) ) );
              when 6 then parse_lookup_type6( i, p_offs + uint16( substr( l_buf, 1 + 4 * l_done, 4 ) ) );
              when 7 then parse_lookup_type7( i, p_offs + uint16( substr( l_buf, 1 + 4 * l_done, 4 ) ) );
else null;
            end case;
            l_done := l_done + 1;
          end loop;
          return l_lookup;
        end parse_lookup_table;
      begin
-- https://learn.microsoft.com/en-us/typography/opentype/spec/chapter2#lookuplist-table
        l_sz := 8100;
        l_done := l_sz;
        l_b_cnt := 0;
        l_to_do := uint16( rawtohex( dbms_lob.substr( p_font, 2, p_offs ) ) );
        for i in 0 .. l_to_do - 1  -- zero-based
        loop
          if l_done = l_sz
          then
            l_buf := dbms_lob.substr( p_font, 2 * least( l_sz, l_to_do ), p_offs + 2 + l_b_cnt * 2 * l_sz );
            l_done := 0;
            l_b_cnt := l_b_cnt + 1;
            l_to_do := l_to_do - l_sz;
          end if;
          l_gsub.lookup_list( i ) := parse_lookup_table( p_offs + substr2num( 1 + 4 * l_done ) );
          l_done := l_done + 1;
        end loop;
      end parse_lookup_list;
    begin
      l_header := dbms_lob.substr( p_font, 14, p_offset );
      l_gsub.table_type := 'GSUB';
      -- ScriptList table
      l_gsub.script_list := parse_script_list( p_offset + uint16( substr( l_header, 9, 4 ) ) );
      -- FeatureList table
      l_gsub.feature_list := parse_feature_list( p_offset + to_number( substr( l_header, 13, 4 ), 'XXXX' ) );
      -- LookupList table
      parse_lookup_list( p_offset + uint16( substr( l_header, 17, 4 ) ) );
      g_pdf.gsub_gpos( p_font_idx ) := l_gsub;
    end parse_gsub;
    --
    function parse_anchor( p_offs integer )
    return tp_anchor
    is
      l_buf    varchar2(32767);
      l_anchor tp_anchor;
    begin
-- https://learn.microsoft.com/en-us/typography/opentype/spec/gpos#anchor-table
      l_buf := dbms_lob.substr( p_font, 6, p_offs );
      l_anchor.xCoordinate := int16( substr( l_buf, 5, 4 ) );
      l_anchor.yCoordinate := int16( substr( l_buf, 9, 4 ) );
      return l_anchor;
    end parse_anchor;
    --
    procedure parse_gpos( p_font_idx pls_integer, p_offset integer )
    is
      l_header varchar2(32);
      l_gpos   tp_gsub_gpos;
      --
      procedure parse_lookup_list( p_offs integer )
      is
        l_sz          pls_integer;
        l_done        pls_integer;
        l_to_do       pls_integer;
        l_b_cnt       pls_integer;
        l_lookup      tp_lookup;
        l_null_lookup tp_lookup;
        --
        procedure parse_lookup_type1( p_idx pls_integer, p_offs integer )
        is
          l_buf      varchar2(32767);
          l_pv_buf   varchar2(32767);
          l_pv_offs  integer;
          l_pv_sz    pls_integer;
          l_pv_done  pls_integer;
          l_glyph    pls_integer;
          l_format   pls_integer;
          l_coverage tp_pls_tab;
          l_subt     tp_subtable;
          --
          function parse_value_record
          return tp_value_record
          is
            l_flag pls_integer := 1;
            l_vr tp_value_record;
          begin
            if l_format > 0
            then
              for i in 1 .. 8
              loop
                if bitand( l_format, l_flag ) > 0
                then
                  if l_pv_done = l_pv_sz
                  then
                    l_pv_buf := dbms_lob.substr( p_font, 2 * l_pv_sz, l_pv_offs );
                    l_pv_done := 0;
                    l_pv_offs := l_pv_offs + 2 * l_pv_sz;
                  end if;
                  case i
                    when 1 then l_vr.xPlacement := int16( substr( l_pv_buf, 1 + 4 * l_pv_done, 4 ) );
                    when 2 then l_vr.yPlacement := int16( substr( l_pv_buf, 1 + 4 * l_pv_done, 4 ) );
                    when 3 then l_vr.xAdvance := int16( substr( l_pv_buf, 1 + 4 * l_pv_done, 4 ) );
                    when 4 then l_vr.yAdvance := int16( substr( l_pv_buf, 1 + 4 * l_pv_done, 4 ) );
                    else null;
                  end case;
                  l_pv_done := l_pv_done + 1;
                end if;
                l_flag := l_flag * 2;
              end loop;
            end if;
            return l_vr;
          end parse_value_record;
        begin
-- https://learn.microsoft.com/en-us/typography/opentype/spec/gpos#lookup-type-1-subtable-single-adjustment-positioning
          l_buf := dbms_lob.substr( p_font, 16, p_offs );
          l_coverage := parse_coverage( p_offs + uint16( substr( l_buf, 5, 4 ) ) );
          l_format := uint16( substr( l_buf, 9, 4 ) );
          if substr( l_buf, 1, 4 ) = '0001'
          then
            l_pv_offs := p_offs + 6;
            l_pv_sz := 4;
            l_pv_done := l_pv_sz;
            l_subt.value_records_list( 0 )( 0 ) := parse_value_record;
            for i in 0 .. l_coverage.count - 1
            loop
              l_glyph := l_coverage( i );
              l_subt.coverage( l_glyph ) := null;
              l_lookup.coverage( l_glyph )( p_idx ) := null;
            end loop;
          else
            l_pv_offs := p_offs + 8;
            l_pv_sz := 400;
            l_pv_done := l_pv_sz;
            for i in 0 .. l_coverage.count - 1
            loop
              l_glyph := l_coverage( i );
              l_subt.coverage( l_glyph ) := i;
              l_lookup.coverage( l_glyph )( p_idx ) := null;
              l_subt.value_records_list( i )( 0 ) := parse_value_record;
            end loop;
          end if;
          l_lookup.subtables( p_idx ) := l_subt;
        end parse_lookup_type1;
        --
        procedure parse_lookup_type2( p_idx pls_integer, p_offs integer )
        is
          l_offs     integer;
          l_pv_offs  integer;
          l_sz       pls_integer;
          l_done     pls_integer;
          l_to_do    pls_integer;
          l_pv_sz    pls_integer;
          l_pv_done  pls_integer;
          l_pv_to_do pls_integer;
          l_glyph    pls_integer;
          l_format1  pls_integer;
          l_format2  pls_integer;
          l_cl_cnt1  pls_integer;
          l_cl_cnt2  pls_integer;
          l_buf      varchar2(32767);
          l_pv_recs  varchar2(32767);
          l_coverage tp_pls_tab;
          l_class1   tp_pls_tab;
          l_vr       tp_value_record;
          l_vrs      tp_value_records;
          --
          procedure read_buf_when_needed
          is
          begin
            if l_pv_done = l_pv_sz
            then
              l_pv_recs := dbms_lob.substr( p_font, 2 * l_pv_sz, l_pv_offs );
              l_pv_done := 0;
              l_pv_offs := l_pv_offs + 2 * l_pv_sz;
            end if;
          end read_buf_when_needed;
          --
          function parse_value_record( p_format pls_integer )
          return tp_value_record
          is
            l_flag pls_integer := 1;
            l_vr tp_value_record;
          begin
            if p_format > 0
            then
              for i in 1 .. 8
              loop
                if bitand( p_format, l_flag ) > 0
                then
                  read_buf_when_needed;
                  case i
                    when 1 then l_vr.xPlacement := int16( substr( l_pv_recs, 1 + 4 * l_pv_done, 4 ) );
                    when 2 then l_vr.yPlacement := int16( substr( l_pv_recs, 1 + 4 * l_pv_done, 4 ) );
                    when 3 then l_vr.xAdvance := int16( substr( l_pv_recs, 1 + 4 * l_pv_done, 4 ) );
                    when 4 then l_vr.yAdvance := int16( substr( l_pv_recs, 1 + 4 * l_pv_done, 4 ) );
                    else null;
                  end case;
                  l_pv_done := l_pv_done + 1;
                end if;
                l_flag := l_flag * 2;
              end loop;
            end if;
            return l_vr;
          end parse_value_record;
        begin
-- https://learn.microsoft.com/en-us/typography/opentype/spec/gpos#lookup-type-2-subtable-pair-adjustment-positioning
-- https://learn.microsoft.com/en-us/typography/opentype/spec/gpos#value-record
          l_buf := dbms_lob.substr( p_font, 16, p_offs );
          l_coverage := parse_coverage( p_offs + uint16( substr( l_buf, 5, 4 ) ) );
          l_format1 := uint16( substr( l_buf, 9, 4 ) );
          l_format2 := uint16( substr( l_buf, 13, 4 ) );
          if substr( l_buf, 1, 4 ) = '0001'
          then
            l_sz := 8190;
            l_done := l_sz;
            l_to_do := uint16( substr( l_buf, 17, 4 ) );
            l_offs := p_offs + 10;
            for i in 0 .. l_to_do - 1
            loop
              if l_done = l_sz
              then
                l_buf := dbms_lob.substr( p_font, 2 * least( l_sz, l_to_do ), l_offs );
                l_done := 0;
                l_offs := l_offs + 2 * l_sz;
              end if;
              l_pv_offs := p_offs + uint16( substr( l_buf, 1 + 4 * l_done, 4 ) );
              l_pv_to_do := uint16( rawtohex( dbms_lob.substr( p_font, 2, l_pv_offs ) ) );
              l_pv_offs := l_pv_offs + 2;
              l_pv_sz := least( 4 * l_pv_to_do, 8190 );   -- 1 second glyph  + (mostly) 1 value record with 1 value
              l_pv_done := l_pv_sz;
              for j in 1 .. l_pv_to_do
              loop
                read_buf_when_needed;
                l_glyph := uint16( substr( l_pv_recs, 1 + 4 * l_pv_done, 4 ) );
                l_pv_done := l_pv_done + 1;
                l_vr := parse_value_record( l_format1 );
                if   l_vr.xAdvance != 0   or l_vr.yAdvance != 0
                  or l_vr.xPlacement != 0 or l_vr.yPlacement != 0
                then
                  l_vrs( l_glyph ) := l_vr;
                end if;
                l_vr := parse_value_record( l_format2 );
                if   l_vr.xAdvance != 0   or l_vr.yAdvance != 0
                  or l_vr.xPlacement != 0 or l_vr.yPlacement != 0
                then
                  l_vrs( - l_glyph ) := l_vr;
                end if;
              end loop;
              l_glyph := l_coverage( i );
              l_lookup.subtables( p_idx ).coverage( l_glyph ) := null;
              l_lookup.coverage( l_glyph )( p_idx ) := null;
              l_lookup.subtables( p_idx ).value_records_list( l_glyph ) := l_vrs;
              l_done := l_done + 1;
              l_vrs.delete;
            end loop;
          elsif substr( l_buf, 1, 4 ) = '0002'
          then
            l_class1 := parse_class_def( p_offs + uint16( substr( l_buf, 17, 4 ) ) );
            l_lookup.subtables( p_idx ).data_list := parse_class_def( p_offs + uint16( substr( l_buf, 21, 4 ) ) );
            l_cl_cnt1 := uint16( substr( l_buf, 25, 4 ) );
            l_cl_cnt2 := uint16( substr( l_buf, 29, 4 ) );
            l_pv_offs := p_offs + 16;
            l_pv_sz := least( l_cl_cnt1 * l_cl_cnt2, 8190 );
            l_pv_done := l_pv_sz;
            for i in 0 .. l_cl_cnt1 - 1
            loop
              for j in 1 .. l_cl_cnt2  -- + 1 because class 0 has no negative
              loop
                l_vr := parse_value_record( l_format1 );
                if   l_vr.xAdvance != 0   or l_vr.yAdvance != 0
                  or l_vr.xPlacement != 0 or l_vr.yPlacement != 0
                then
                  l_vrs( j ) := l_vr;
                end if;
                l_vr := parse_value_record( l_format2 );
                if   l_vr.xAdvance != 0   or l_vr.yAdvance != 0
                  or l_vr.xPlacement != 0 or l_vr.yPlacement != 0
                then
                  l_vrs( - j ) := l_vr;
                end if;
              end loop;
              l_lookup.subtables( p_idx ).value_records_list( i ) := l_vrs;
              l_vrs.delete;
            end loop;
            --
            for i in 0 .. l_coverage.count - 1
            loop
              l_glyph := l_coverage( i );
              l_lookup.subtables( p_idx ).coverage( l_glyph ) := case when l_class1.exists( l_glyph ) then l_class1( l_glyph ) else 0 end;
              l_lookup.coverage( l_glyph )( p_idx ) := null;
            end loop;
          end if;
        end parse_lookup_type2;
        --
        procedure parse_lookup_type3( p_idx pls_integer, p_offs integer )
        is
          l_buf      varchar2(32767);
          l_offs     integer;
          l_sz       pls_integer;
          l_done     pls_integer;
          l_glyph    pls_integer;
          l_anchor   tp_anchor;
          l_subt     tp_subtable;
          l_coverage tp_pls_tab;
        begin
-- https://learn.microsoft.com/en-us/typography/opentype/spec/gpos#lookup-type-3-subtable-cursive-attachment-positioning
          l_buf := dbms_lob.substr( p_font, 6, p_offs );
          l_coverage := parse_coverage( p_offs + uint16( substr( l_buf, 5, 4 ) ) );
          l_offs := p_offs + 6;
          l_sz := 4050;
          l_done := l_sz;
          for i in 0 .. l_coverage.count - 1
          loop
            l_glyph := l_coverage( i );
            l_subt.coverage( l_glyph ) := null;
            l_lookup.coverage( l_glyph )( p_idx ) := null;
            if l_done = l_sz
            then
              l_buf := dbms_lob.substr( p_font, 4 * l_sz, l_offs );
              l_offs := l_offs + 4 * l_sz;
              l_done := 0;
            end if;
            if substr( l_buf, 1 + 8 * l_done, 4 ) != '0000'
            then
              l_anchor := parse_anchor( p_offs + uint16( substr( l_buf, 1 + 8 * l_done, 4 ) ) );
              l_subt.matrix( l_glyph )( 0 ) := l_anchor.xCoordinate;
              l_subt.matrix( l_glyph )( 1 ) := l_anchor.yCoordinate;
            end if;
            if substr( l_buf, 5 + 8 * l_done, 4 ) != '0000'
            then
              l_anchor := parse_anchor( p_offs + uint16( substr( l_buf, 5 + 8 * l_done, 4 ) ) );
              l_subt.matrix( l_glyph )( 2 ) := l_anchor.xCoordinate;
              l_subt.matrix( l_glyph )( 3 ) := l_anchor.yCoordinate;
            end if;
            l_done := l_done + 1;
          end loop;
          l_lookup.subtables( p_idx ) := l_subt;
        end parse_lookup_type3;
        --
        procedure parse_lookup_mark_to( p_idx pls_integer, p_offs integer )
        is
          l_offs     integer;
          l_sz       pls_integer;
          l_done     pls_integer;
          l_to_do    pls_integer;
          l_b_cnt    pls_integer;
          l_cnt      pls_integer;
          l_tmp      pls_integer;
          l_glyph    pls_integer;
          l_buf      varchar2(32767);
          l_cmp_buf  varchar2(32767);
          l_header   varchar2(24);
          l_anchor   tp_anchor;
          l_coverage tp_pls_tab;
          l_subtable tp_subtable;
        begin
-- https://learn.microsoft.com/en-us/typography/opentype/spec/gpos#lookup-type-4-subtable-mark-to-base-attachment-positioning
-- https://learn.microsoft.com/en-us/typography/opentype/spec/gpos#lookup-type-6-subtable-mark-to-mark-attachment-positioning
          l_header := dbms_lob.substr( p_font, 12, p_offs );
          l_coverage := parse_coverage( p_offs + uint16( substr( l_header, 5, 4 ) ) );
          l_to_do := l_coverage.count;
          l_offs := p_offs + uint16( substr( l_header, 17, 4 ) );
          l_sz := 4050;
          l_done := l_sz;
          l_b_cnt := 0;
          for i in 0 .. l_to_do - 1
          loop
            if l_done = l_sz
            then
              l_buf := dbms_lob.substr( p_font, 4 * least( l_sz, l_to_do ), l_offs + 2 + l_b_cnt * 4 * l_sz );
              l_done := 0;
              l_b_cnt := l_b_cnt + 1;
              l_to_do := l_to_do - l_sz;
            end if;
            l_glyph := l_coverage( i );
            l_anchor := parse_anchor( l_offs + uint16( substr( l_buf, 5 + 8 * l_done, 4 ) ) );
            l_subtable.data_list( l_glyph ) := l_anchor.xCoordinate;
            l_subtable.data_list( - l_glyph ) := l_anchor.yCoordinate;
            l_subtable.coverage( l_glyph ) := uint16( substr( l_buf, 1 + 8 * l_done, 4 ) );
            l_lookup.coverage( l_glyph )( p_idx ) := null;
            l_done := l_done + 1;
          end loop;
          l_cnt := uint16( substr( l_header, 13, 4 ) );
          l_coverage := parse_coverage( p_offs + uint16( substr( l_header, 9, 4 ) ) );
          l_offs := p_offs + uint16( substr( l_header, 21, 4 ) );
          l_to_do := l_coverage.count;
          l_sz := 8100 / l_cnt;
          l_done := l_sz;
          l_b_cnt := 0;
          for i in 0 .. l_to_do - 1
          loop
            if l_done = l_sz
            then
              l_buf := dbms_lob.substr( p_font, 2 * l_cnt * least( l_sz, l_to_do ), l_offs + 2 + l_b_cnt * 2 * l_cnt * l_sz );
              l_done := 0;
              l_b_cnt := l_b_cnt + 1;
              l_to_do := l_to_do - l_sz;
            end if;
            l_glyph := l_coverage( i );
            for j in 0 .. l_cnt - 1
            loop
              l_anchor := parse_anchor( l_offs + uint16( substr( l_buf, 1 + 4 * l_done, 4 ) ) );
              l_subtable.matrix( l_glyph )( j ) := l_anchor.xCoordinate;
              l_subtable.matrix( - l_glyph )( j ) := l_anchor.yCoordinate;
              l_done := l_done + 1;
            end loop;
          end loop;
          l_lookup.subtables( p_idx ) := l_subtable;
        end parse_lookup_mark_to;
        --
        procedure parse_lookup_type5( p_idx pls_integer, p_offs integer )
        is
          l_offs     integer;
          l_sz       pls_integer;
          l_done     pls_integer;
          l_to_do    pls_integer;
          l_b_cnt    pls_integer;
          l_cnt      pls_integer;
          l_tmp      pls_integer;
          l_glyph    pls_integer;
          l_buf      varchar2(32767);
          l_cmp_buf  varchar2(32767);
          l_header   varchar2(24);
          l_anchor   tp_anchor;
          l_coverage tp_pls_tab;
          l_subtable tp_subtable;
        begin
-- https://learn.microsoft.com/en-us/typography/opentype/spec/gpos#lookup-type-5-subtable-mark-to-ligature-attachment-positioning
          l_header := dbms_lob.substr( p_font, 12, p_offs );
          l_coverage := parse_coverage( p_offs + uint16( substr( l_header, 5, 4 ) ) );
          l_to_do := l_coverage.count;
          l_offs := p_offs + uint16( substr( l_header, 17, 4 ) );
          l_sz := 4050;
          l_done := l_sz;
          l_b_cnt := 0;
          for i in 0 .. l_to_do - 1
          loop
            if l_done = l_sz
            then
              l_buf := dbms_lob.substr( p_font, 4 * least( l_sz, l_to_do ), l_offs + 2 + l_b_cnt * 4 * l_sz );
              l_done := 0;
              l_b_cnt := l_b_cnt + 1;
              l_to_do := l_to_do - l_sz;
            end if;
            l_glyph := l_coverage( i );
            l_anchor := parse_anchor( l_offs + uint16( substr( l_buf, 5 + 8 * l_done, 4 ) ) );
            l_subtable.data_list( l_glyph ) := l_anchor.xCoordinate;
            l_subtable.data_list( - l_glyph ) := l_anchor.yCoordinate;
            l_subtable.coverage( l_glyph ) := uint16( substr( l_buf, 1 + 8 * l_done, 4 ) );
            l_lookup.coverage( l_glyph )( p_idx ) := null;
            l_done := l_done + 1;
          end loop;
          l_cnt := uint16( substr( l_header, 13, 4 ) );
          l_coverage := parse_coverage( p_offs + uint16( substr( l_header, 9, 4 ) ) );
          l_to_do := l_coverage.count;
          l_offs := p_offs + uint16( substr( l_header, 21, 4 ) );
          l_sz := 8100;
          l_done := l_sz;
          l_b_cnt := 0;
          for i in 0 .. l_to_do - 1
          loop
            if l_done = l_sz
            then
              l_buf := dbms_lob.substr( p_font, 2 * least( l_sz, l_to_do ), l_offs + 2 + l_b_cnt * 2 * l_sz );
              l_done := 0;
              l_b_cnt := l_b_cnt + 1;
              l_to_do := l_to_do - l_sz;
            end if;
            l_glyph := l_coverage( i );
            l_subtable.coverage( l_glyph ) := null;
            l_cmp_buf := dbms_lob.substr( p_font, 132, l_offs + uint16( substr( l_buf, 1 + 4 * l_done, 4 ) ) );
            for j in 0 .. uint16( substr( l_cmp_buf, 1, 4 ) ) - 1
            loop
              for c in 0 .. l_cnt - 1
              loop
                l_tmp := uint16( substr( l_cmp_buf, 5 + 4 * c + 4 * l_cnt * j, 4 ) );
                if l_tmp > 0
                then
                  l_anchor := parse_anchor( l_offs + uint16( substr( l_buf, 1 + 4 * l_done, 4 ) ) + l_tmp );
                else
                  l_anchor := null;
                end if;
                -- only store last component
                l_subtable.matrix( l_glyph )( c ) := l_anchor.xCoordinate;
                l_subtable.matrix( - l_glyph )( c ) := l_anchor.yCoordinate;
              end loop;
            end loop;
            l_done := l_done + 1;
          end loop;
          l_lookup.subtables( p_idx ) := l_subtable;
        end parse_lookup_type5;
        --
        procedure parse_lookup_type8( p_idx pls_integer, p_offs integer )
        is
          l_buf   varchar2(32767);
        begin
-- https://learn.microsoft.com/en-us/typography/opentype/spec/gpos#lookup-type-8-subtable-chained-contexts-positioning
-- https://learn.microsoft.com/en-us/typography/opentype/spec/chapter2#chseqctxt1
-- https://learn.microsoft.com/en-us/typography/opentype/spec/chapter2#chseqctxt2
-- https://learn.microsoft.com/en-us/typography/opentype/spec/chapter2#chseqctxt3
-- https://stackoverflow.com/questions/55388207/opentype-gpos-lookuptype-8-skipping-marks
          l_buf := dbms_lob.substr( p_font, 16, p_offs );
        end parse_lookup_type8;
        --
        procedure parse_lookup_type9( p_idx pls_integer, p_offs integer )
        is
          l_buf varchar2(16);
        begin
-- https://learn.microsoft.com/en-us/typography/opentype/spec/gpos#lookup-type-9-subtable-positioning-subtable-extension
          l_buf := dbms_lob.substr( p_font, 8, p_offs );
          case substr( l_buf, 5, 4 )
            when '0001' then parse_lookup_type1( p_idx, p_offs + to_number( substr( l_buf, 9, 8 ), 'XXXXXXXX' ) );
            when '0002' then parse_lookup_type2( p_idx, p_offs + to_number( substr( l_buf, 9, 8 ), 'XXXXXXXX' ) );
            when '0003' then parse_lookup_type3( p_idx, p_offs + to_number( substr( l_buf, 9, 8 ), 'XXXXXXXX' ) );
            when '0004' then parse_lookup_mark_to( p_idx, p_offs + to_number( substr( l_buf, 9, 8 ), 'XXXXXXXX' ) );
            when '0005' then parse_lookup_type5( p_idx, p_offs + to_number( substr( l_buf, 9, 8 ), 'XXXXXXXX' ) );
            when '0006' then parse_lookup_mark_to( p_idx, p_offs + to_number( substr( l_buf, 9, 8 ), 'XXXXXXXX' ) );
            when '0008' then parse_lookup_type8( p_idx, p_offs + to_number( substr( l_buf, 9, 8 ), 'XXXXXXXX' ) );
            else null;
          end case;
        end parse_lookup_type9;
        --
        function parse_lookup_table( p_offs integer )
        return tp_lookup
        is
          l_sz    pls_integer;
          l_done  pls_integer;
          l_to_do pls_integer;
          l_b_cnt pls_integer;
          l_buf   varchar2(32767);
        begin
-- https://learn.microsoft.com/en-us/typography/opentype/spec/chapter2#lookup-table
          l_lookup := l_null_lookup;
          l_buf := dbms_lob.substr( p_font, 6, p_offs );
          l_lookup.lookup_type := uint16( substr( l_buf, 1, 4 ) );
          l_lookup.lookup_flags := uint16( substr( l_buf, 5, 4 ) );
          l_sz := 8100;
          l_done := l_sz;
          l_b_cnt := 0;
          l_to_do := uint16( substr( l_buf, 9, 4 ) );
          if bitand( l_lookup.lookup_flags, 16 ) > 0
          then
            l_lookup.mark_filtering_set := uint16( rawtohex( dbms_lob.substr( p_font, 2, p_offs + 6 + 2 * l_to_do ) ) );
          end if;
          for i in 1 .. l_to_do
          loop
            if l_done = l_sz
            then
              l_buf := dbms_lob.substr( p_font, 2 * least( l_sz, l_to_do ), p_offs + 6 + l_b_cnt * 2 * l_sz );
              l_done := 0;
              l_b_cnt := l_b_cnt + 1;
              l_to_do := l_to_do - l_sz;
            end if;
            case l_lookup.lookup_type
              when 1 then parse_lookup_type1( i, p_offs + uint16( substr( l_buf, 1 + 4 * l_done, 4 ) ) );
              when 2 then parse_lookup_type2( i, p_offs + uint16( substr( l_buf, 1 + 4 * l_done, 4 ) ) );
              when 3 then parse_lookup_type3( i, p_offs + uint16( substr( l_buf, 1 + 4 * l_done, 4 ) ) );
              when 4 then parse_lookup_mark_to( i, p_offs + uint16( substr( l_buf, 1 + 4 * l_done, 4 ) ) );
              when 5 then parse_lookup_type5( i, p_offs + uint16( substr( l_buf, 1 + 4 * l_done, 4 ) ) );
              when 6 then parse_lookup_mark_to( i, p_offs + uint16( substr( l_buf, 1 + 4 * l_done, 4 ) ) );
              when 8 then parse_lookup_type8( i, p_offs + uint16( substr( l_buf, 1 + 4 * l_done, 4 ) ) );
              when 9 then parse_lookup_type9( i, p_offs + uint16( substr( l_buf, 1 + 4 * l_done, 4 ) ) );
else null;
            end case;
            l_done := l_done + 1;
          end loop;
          return l_lookup;
        end parse_lookup_table;
      begin
-- https://learn.microsoft.com/en-us/typography/opentype/spec/chapter2#lookuplist-table
        l_sz := 8100;
        l_done := l_sz;
        l_b_cnt := 0;
        l_to_do := uint16( rawtohex( dbms_lob.substr( p_font, 2, p_offs ) ) );
        for i in 0 .. l_to_do - 1  -- zero-based
        loop
          if l_done = l_sz
          then
            l_buf := dbms_lob.substr( p_font, 2 * least( l_sz, l_to_do ), p_offs + 2 + l_b_cnt * 2 * l_sz );
            l_done := 0;
            l_b_cnt := l_b_cnt + 1;
            l_to_do := l_to_do - l_sz;
          end if;
          l_gpos.lookup_list( i ) := parse_lookup_table( p_offs + substr2num( 1 + 4 * l_done ) );
          l_done := l_done + 1;
        end loop;
      end parse_lookup_list;
    begin
      l_header := dbms_lob.substr( p_font, 14, p_offset );
      l_gpos.table_type := 'GPOS';
      -- ScriptList table
      l_gpos.script_list := parse_script_list( p_offset + uint16( substr( l_header, 9, 4 ) ) );
      -- FeatureList table
      l_gpos.feature_list := parse_feature_list( p_offset + uint16( substr( l_header, 13, 4 ) ) );
      -- LookupList table
      parse_lookup_list( p_offset + uint16( substr( l_header, 17, 4 ) ) );
      g_pdf.gsub_gpos( - p_font_idx ) := l_gpos;
    end parse_gpos;
    --
    procedure parse_gdef( p_font_idx pls_integer, p_offset integer )
    is
      l_offs integer;
    begin
      l_buf := dbms_lob.substr( p_font, 6, p_offset );
      l_offs := substr2num( 9 );
      if l_offs > 0
      then
        g_pdf.gdef( p_font_idx ).class_def := parse_class_def( p_offset + l_offs );
      end if;
    end parse_gdef;
    --
  begin
    l_buf := dbms_lob.substr( p_font, 4096, p_offset );
    if substr( l_buf, 1, 8 ) = '74746366' -- ttcf
    then
      for i in 0 .. to_number( substr( l_buf, 17, 8 ), 'XXXXXXXX' ) - 1
      loop
        l_idx := load_font( p_font, p_embed, p_subset, to_number( dbms_lob.substr( p_font, 4, 13 + i * 4 ), 'XXXXXXXX' ) + 1, p_opentype_features );
      end loop;
      return l_idx;
    elsif substr( l_buf, 1, 8 ) = rawtohex( c_LOCAL_FILE_HEADER ) -- zip file
    then
      for i in 1 .. get_count( p_font )
      loop
        exit when not get_central_file_header( p_font, null, i, null, l_cfh );
        if lower( substr( utl_raw.cast_to_varchar2( l_cfh.name1 ), -4 ) )
              in ( '.otf', '.ttf', '.ttc', '.otc' )
        then
          l_idx := load_font( parse_file( p_font, l_cfh ), p_embed, p_subset, 1, p_opentype_features );
        end if;
      end loop;
      return l_idx;
    end if;
    --
    if substr( l_buf, 1, 8 ) not in ( '4F54544F'  -- OpenType Font
                                    , '00010000'  -- TrueType Font
                                    )
    then
      raise_application_error( -20020, 'No OpenType/TrueType header.' );
    end if;
    l_idx := g_pdf.fonts.count + 1;
    if substr( l_buf, 1, 8 ) = '00010000'
    then
      l_font.subtype := 'TrueType';
    else
      l_font.subtype := 'OpenType';
    end if;
    --
    for i in 1 .. substr2num( 9 )
    loop
      l_tag := utl_raw.cast_to_varchar2( substr( l_buf, i * 32 - 7, 8 ) );
      l_tables( l_tag ).offset := to_number( substr( l_buf, 9  + i * 32, 8 ), 'XXXXXXXX' ) + 1;
      l_tables( l_tag ).length := to_number( substr( l_buf, 17 + i * 32, 8 ), 'XXXXXXXX' );
    end loop;
    --
    if (  not l_tables.exists( 'cmap' )
       or not l_tables.exists( 'head' )
       or not l_tables.exists( 'hhea' )
       or not l_tables.exists( 'hmtx' )
       or not l_tables.exists( 'maxp' )
       or not l_tables.exists( 'name' )
       or not l_tables.exists( 'post' )
       )
    then
      raise_application_error( -20021, 'Missing OpenType table.' );
    end if;
    --
    l_font.cff := l_tables.exists( 'CFF ' );
    l_font.numGlyphs := blob2num( p_font, 2, 4 + l_tables( 'maxp' ).offset );
    --
    declare
      l_offs            pls_integer;
      l_code            pls_integer;
      l_glyph           pls_integer;
      l_remap_symbol    pls_integer;
      l_offset          integer;
      l_code2glyph      tp_pls_tab;
      l_end_code        tp_pls_tab;
      l_start_code      tp_pls_tab;
      l_id_delta        tp_pls_tab;
      l_id_range_offset tp_pls_tab;
      --
      procedure load_values( p_offs integer, p_tab in out tp_pls_tab )
      is
        l_i  pls_integer;
        l_j  pls_integer;
        l_sz pls_integer := 8000;
      begin
        l_i := 0;
        loop
          exit when l_i = l_cnt;
          if mod( l_i, l_sz ) = 0
          then
            l_j := 0;
            l_buf := dbms_lob.substr( p_font, l_sz * 2, l_offset + p_offs + l_i * 2 );
          end if;
          p_tab( l_i ) := substr2num( 1 + l_j * 4 );
          l_i := l_i + 1;
          l_j := l_j + 1;
        end loop;
      end;
    begin
      l_offset := l_tables( 'cmap' ).offset;
      l_buf := dbms_lob.substr( p_font, 16000, l_offset );
      for i in reverse 0 .. substr2num( 5 ) - 1
      loop
        continue when substr( l_buf, 9  + i * 16, 4 ) != '0003' -- Platform ID = Windows
                   or substr( l_buf, 13 + i * 16, 4 ) not in ( '0000' -- Symbol
                                                             , '0001' -- Unicode BMP (UCS-2)
                                                             , '000A' -- Unicode full repertoire
                                                             ); -- encodingID
        if substr( l_buf, 13 + i * 16, 4 ) = '0000'
        then
          l_font.flags := 4;  -- symbolic
        else
          l_font.flags := 32; -- non-symbolic
        end if;
        l_offset := l_offset + to_number( substr( l_buf, 17 + i * 16, 8 ), 'XXXXXXXX' );
        l_buf := dbms_lob.substr( p_font, 16, l_offset );
        if substr( l_buf, 1, 4 ) = '000C'
        then
          l_offset := l_offset + 16;
          for i in 0 .. to_number( substr( l_buf, 25, 8 ), 'XXXXXXXX' ) - 1
          loop
            if mod( i, 1360 ) = 0
            then
              l_offs := 1;
              l_buf := dbms_lob.substr( p_font, 1360 * 12, l_offset );
              l_offset := l_offset + 1360 * 12;
            end if;
            l_glyph := to_number( substr( l_buf, l_offs + 16, 8 ), 'XXXXXXXX' );
            for j in to_number( substr( l_buf, l_offs, 8 ), 'XXXXXXXX' ) .. to_number( substr( l_buf, l_offs + 8, 8 ), 'XXXXXXXX' )
            loop
              l_code2glyph( j ) := l_glyph;
              l_glyph := l_glyph + 1;
            end loop;
            l_offs := l_offs + 24;
          end loop;
        else
          if substr( l_buf, 1, 4 ) != '0004'
          then
            raise_application_error( -20022, 'Only character-to-glyph-index mapping 0004 is handled, this file has ' || substr( l_buf, 1, 4 ) );
          end if;
          l_cnt := substr2num( 13 ) / 2;
          load_values( 14, l_end_code );
          load_values( 16 + l_cnt * 2, l_start_code );
          load_values( 16 + l_cnt * 4, l_id_delta );
          load_values( 16 + l_cnt * 6, l_id_range_offset );
          for j in 0 .. l_cnt - 1
          loop
            l_tmp := l_id_range_offset( j );
            if l_tmp = 0
            then
              l_tmp := l_id_delta( j );
              for c in l_start_code( j ) .. l_end_code( j )
              loop
                l_code2glyph( c ) := bitand( c + l_tmp, 65535 );
              end loop;
            else
              l_sz := 8000;
              l_end   := l_end_code( j );
              l_start := l_start_code( j );
              l_tmp := l_tmp  + 2 * ( j - l_cnt );
              <<cmap_outer>>
              for s in 0 ..  10
              loop
                exit when l_start + s * l_sz > l_end;
                l_buf := dbms_lob.substr( p_font, 2 * least( 1 + l_end - l_start - s * l_sz, l_sz ), l_offset + 16 + l_cnt * 8 + l_tmp + s * 2 * l_sz );
                for p in 0 .. l_sz - 1
                loop
                  exit cmap_outer when l_start + p + s * l_sz > l_end;
                  l_code2glyph( l_start + p + s * l_sz ) := substr2num( 1 + p * 4 );
                end loop;
              end loop;
            end if;
          end loop;
        end if;
        exit;
      end loop;
      --
      l_code := l_code2glyph.first;
      if bitand( l_font.flags, 4 ) > 0 and l_font.numGlyphs < 256
      then
        -- for a symbolic font, assume code 32, space maps to the first code from the font
        l_remap_symbol := l_code - 32;
      else
        l_remap_symbol := 0;
      end if;
      while l_code is not null
      loop
        l_glyph := l_code2glyph( l_code );
        if l_glyph = 0
        then
          l_font.notdef := l_code;
        end if;
        g_pdf.font_code_cache( l_idx )( l_code + l_remap_symbol ) := l_glyph;
        g_pdf.font_code_cache( l_idx )( - l_glyph ) := l_code + l_remap_symbol;
        l_code := l_code2glyph.next( l_code );
      end loop;
      l_font.notdef := coalesce( l_font.notdef, 65535 );
    end;
    --
    l_buf := dbms_lob.substr( p_font, 52, l_tables( 'head' ).offset );
    if substr( l_buf, 25, 8 ) = '5F0F3CF5'  -- magicNumber
    then
      l_tmp := substr2num( 89 );
      if bitand( l_tmp, 1 ) = 1
      then
        l_font.style := 'B';
      end if;
      if bitand( l_tmp, 2 ) = 2
      then
        l_font.style := l_font.style || 'I';
        l_font.flags := l_font.flags + 64;
      elsif l_font.italic_angle != 0
      then
        l_font.flags := l_font.flags + 64;
      end if;
      l_font.style := nvl( l_font.style, 'N' );
      l_font.unit_norm := 1000 / substr2num( 37 ); -- unitsPerEm
      l_font.bb_xmin := substr2snum( 73 ) * l_font.unit_norm;
      l_font.bb_ymin := substr2snum( 77 ) * l_font.unit_norm;
      l_font.bb_xmax := substr2snum( 81 ) * l_font.unit_norm;
      l_font.bb_ymax := substr2snum( 85 ) * l_font.unit_norm;
      l_font.indexToLocFormat := 2 * ( substr2num( 101 ) + 1 ); -- 0 for short offsets, 1 for long => size in bytes
    end if;
    --
    l_buf := dbms_lob.substr( p_font, 34, l_tables( 'post' ).offset );
    l_font.italic_angle := substr2snum( 9 ) + substr2snum( 13 ) / 16384;
    l_font.underline_pos := substr2snum( 17 ) * l_font.unit_norm;
    if substr( l_buf, 25, 8 ) != '00000000'
    then
      l_font.flags := l_font.flags + 1; -- fixed pitch
    end if;
    --
    l_buf := dbms_lob.substr( p_font, 36, l_tables( 'hhea' ).offset );
    if substr( l_buf, 1, 8 ) = '00010000'  -- version 1.0
    then
      l_font.ascent    := substr2snum( 9 )  * l_font.unit_norm;
      l_font.descent   := substr2snum( 13 ) * l_font.unit_norm;
      l_font.linegap   := substr2snum( 17 ) * l_font.unit_norm;
      l_font.capheight := l_font.ascent;
      l_tmp := substr2num( 69 ); -- Number of hMetric entries in 'hmtx' table
    end if;
    --
    <<hmetric_loop>>
    for i in 0 .. 10
    loop
      l_buf := dbms_lob.substr( p_font, 4 * 4000, l_tables( 'hmtx' ).offset + 16000 * i );
      for j in 0 .. 4000 - 1 -- Number of hMetric entries
      loop
        l_glyph := j + 4000 * i;
        exit hmetric_loop when l_glyph >= l_tmp;
        l_width := substr2num( 1 + 8 * j ); -- only Advance width, skip Left side bearing
        g_pdf.font_width_cache( l_idx )( l_glyph ) := l_width;
        if g_pdf.font_code_cache( l_idx ).exists( - l_glyph )
        then
          g_pdf.font_width_cache( l_idx )( - g_pdf.font_code_cache( l_idx )( - l_glyph ) ) := l_width;
        end if;
      end loop;
    end loop;
    --
    l_offs := l_tables( 'name' ).offset;
    l_buf := dbms_lob.substr( p_font, least( l_tables( 'name' ).length, 16380 ), l_offs );
    if substr( l_buf, 1, 4 ) = '0000' -- format 0
    then
      l_start := substr2num( 9 );
      for i in 0 .. substr2num( 5 ) - 1
      loop
        if (   substr( l_buf, 13 + i * 24, 4 ) = '0003' -- Windows
           and substr( l_buf, 21 + i * 24, 4 ) = '0409' -- English United States
           and substr( l_buf, 25 + i * 24, 4 ) in ( '0001', '0006' )
           )
        then
          if substr( l_buf, 25 + i * 24, 4 ) = '0001'
          then
            l_font.family := utl_i18n.raw_to_char( dbms_lob.substr( p_font, substr2num( 29 + i * 24 ), l_offs + l_start + substr2num( 33 + i * 24 ) ), 'AL16UTF16' );
            exit when l_font.name is not null;
          else
            l_font.name := utl_i18n.raw_to_char( dbms_lob.substr( p_font, substr2num( 29 + i * 24 ), l_offs + l_start + substr2num( 33 + i * 24 ) ), 'AL16UTF16' );
            exit when l_font.family is not null;
          end if;
        end if;
      end loop;
    end if;
    l_font.name   := coalesce( l_font.name,   'unknown, name type 1' );
    l_font.family := coalesce( l_font.family, 'unknown, name type 1' );
    --
    l_font.stemv := 50;
    l_font.family := lower( l_font.family );
    l_font.fontname := l_font.name;
    --
    if l_tables.exists( 'OS/2' )
    then
      l_buf := dbms_lob.substr( p_font, 90, l_tables( 'OS/2' ).offset );
      l_font.strikeout_pos := substr2snum( 57 ) * l_font.unit_norm; -- yStrikeoutPosition
      l_font.ascent  := substr2snum( 137 ) * l_font.unit_norm;
      l_font.descent := substr2snum( 141 ) * l_font.unit_norm;
      l_font.linegap := substr2snum( 145 ) * l_font.unit_norm;
-- ascent - descent = 1000
-- 1000 + linegap => next line
      if substr2num( 1 ) > 1  -- OS/2 version 2 or higher
      then
        l_font.capheight := substr2snum( 177 );
      else
        l_font.capheight := l_font.ascent;
      end if;
      l_font.win_ascent := substr2snum( 149 ) * l_font.unit_norm;
      l_font.win_descent := - abs( substr2snum( 153 ) * l_font.unit_norm );
-- https://stackoverflow.com/questions/35485179/stemv-value-of-the-truetype-font
      l_font.stemv := substr2snum( 9 ) / 65;
      l_font.stemv := round( l_font.stemv * l_font.stemv ) + 50;
      --
      if     p_embed
         and substr( l_buf, 19, 2 ) != '02' -- Restricted License embedding
      then
        g_pdf.font_files( l_idx ) := p_font;
        l_font.ttf_offset := p_offset;
        l_font.subset := dbms_lob.substr( p_font, 1, l_tables( 'OS/2' ).offset + 8 ) = hextoraw( '00' );
        l_font.name := dbms_random.string( 'u', 6 ) || '+' || l_font.name;
      end if;
    end if;
    --
    -- https://fontdrop.info/
    -- https://twardoch.github.io/test-fonts/otetest/
    -- https://itextpdf.com/sites/default/files/attachments/PP_Advanced_typography_in_PDF.pdf
    -- https://github.com/SixLabors/Fonts/tree/main/tests/Fonts
    -- https://www.christophdusenbery.com/urdu-fonts/
    -- https://learn.microsoft.com/en-us/dotnet/desktop/wpf/advanced/opentype-font-features
    if p_opentype_features and l_tables.exists( 'GSUB' )
    then
      parse_gsub( l_idx, l_tables( 'GSUB' ).offset );
    end if;
    if p_opentype_features and l_tables.exists( 'GPOS' )
    then
      parse_gpos( l_idx, l_tables( 'GPOS' ).offset );
    end if;
    if p_opentype_features and l_tables.exists( 'GDEF' )
    then
      parse_gdef( l_idx, l_tables( 'GDEF' ).offset );
    end if;
/*
g_pdf.font_code_cache.delete;
g_pdf.font_glyph_cache.delete;
g_pdf.font_width_cache.delete;
g_pdf.gdef.delete;
g_pdf.gsub_gpos.delete;
return 100;
*/
    --
    if not p_subset
    then
      l_font.subset := false;
    end if;
    l_font.delete_in_gsub_type6 := true;
    g_pdf.fonts( l_idx ) := l_font;
    g_pdf.font_old_new( l_idx ) := tp_pls_tab();
    return l_idx;
  end load_font;
  --
  function load_font
    ( p_font              blob
    , p_embed             boolean := true
    , p_subset            boolean := true
    , p_opentype_features boolean := true
    )
  return pls_integer
  is
  begin
    return load_font( p_font              => p_font
                    , p_embed             => p_embed
                    , p_subset            => p_subset
                    , p_offset            => 1
                    , p_opentype_features => p_opentype_features
                    );
  end load_font;
  --
  function load_font
    ( p_dir               varchar2
    , p_filename          varchar2
    , p_embed             boolean := true
    , p_subset            boolean := true
    , p_opentype_features boolean := true
    )
  return pls_integer
  is
  begin
    return load_font( p_font              => file2blob( p_dir, p_filename )
                    , p_embed             => p_embed
                    , p_subset            => p_subset
                    , p_offset            => 1
                    , p_opentype_features => p_opentype_features
                    );
  end load_font;
  --
  function load_google_font
    ( p_family            varchar2
    , p_variant           varchar2 := 'normal'
    , p_subset            varchar2 := null
    , p_embed             boolean  := true
    , p_opentype_features boolean  := true
    )
  return pls_integer
  is
    l_font     blob;
    l_fonts    clob;
    l_idx      pls_integer;
    l_pos1     pls_integer;
    l_pos2     pls_integer;
    l_pos3     pls_integer;
    l_pos4     pls_integer;
    l_url      varchar2(32767);
    --
$IF as_pdf.use_utl_http
$THEN
    l_buf        raw(32767);
    l_txt        varchar2(32767);
    l_proxy      varchar2(32767);
    l_no_proxy   varchar2(32767);
    l_rck        utl_http.request_context_key;
    l_req        utl_http.req;
    l_resp       utl_http.resp;
    e_font_error exception;
    e_no_font1   exception;
    e_no_font2   exception;
$END
  begin
$IF as_pdf.use_utl_http OR as_pdf.use_apex
$THEN
    l_url := 'https://fonts.googleapis.com/css?family=';
    l_url := l_url || utl_url.escape( p_family );
    if p_variant is not null
    then
      l_url := l_url || ':' || p_variant;
    end if;
    if p_subset is not null
    then
      l_url := l_url || '&' || 'subset=' || lower( p_subset );
    end if;
$IF as_pdf.use_apex
$THEN
    l_fonts := apex_web_service.make_rest_request
                 ( p_url            => l_url
                 , p_http_method    => 'GET'
                 , p_proxy_override => g_proxy
                 , p_wallet_path    => g_wallet_path
                 , p_wallet_pwd     => g_wallet_password
                 );
    if apex_web_service.g_status_code != 200
    then
      raise_application_error( -20050, 'No Google font found.' );
    end if;
$ELSE
    utl_http.get_proxy( l_proxy, l_no_proxy );
    utl_http.set_proxy( g_proxy, g_no_proxy );
    utl_http.set_detailed_excp_support( true );
    l_rck := utl_http.create_request_context( wallet_path => g_wallet_path, wallet_password => g_wallet_password );
    l_req := utl_http.begin_request( url => l_url, request_context => l_rck );
    l_resp := utl_http.get_response( l_req );
    if l_resp.status_code != 200
    then
      raise e_no_font1;
    end if;
    begin
      loop
        utl_http.read_text( l_resp, l_txt, 32767 );
        l_fonts := l_fonts || l_txt;
      end loop;
    exception
      when utl_http.end_of_body then
        utl_http.end_response( l_resp );
    end;
$END
    l_pos1 := 1;
    loop
      l_pos1 := instr( l_fonts, '@font-face', l_pos1 );
      exit when l_pos1 = 0;
      l_pos2 := instr( l_fonts, '}', l_pos1 );
      exit when l_pos2 = 0;
      l_pos3 := instr( l_fonts, 'src: url(', l_pos1 ) + 9;
      exit when l_pos3 = 0;
      l_pos4 := instr( l_fonts, ')', l_pos3 );
      exit when l_pos4 = 0;
      --
      l_url := substr( l_fonts, l_pos3, l_pos4 - l_pos3 );
$IF as_pdf.use_apex
$THEN
      l_font := apex_web_service.make_rest_request_b
                  ( p_url            => l_url
                  , p_http_method    => 'GET'
                  , p_proxy_override => g_proxy
                  , p_wallet_path    => g_wallet_path
                  , p_wallet_pwd     => g_wallet_password
                  );
      if apex_web_service.g_status_code != 200
      then
        raise_application_error( -20052, 'No Google font found.' );
      end if;
$ELSE
      l_req := utl_http.begin_request( url => l_url, request_context => l_rck );
      l_resp := utl_http.get_response( l_req );
      if l_resp.status_code != 200
      then
        raise e_no_font2;
      end if;
      dbms_lob.createtemporary( l_font, true );
      begin
        loop
          utl_http.read_raw( l_resp, l_buf, 32767 );
          dbms_lob.writeappend( l_font, utl_raw.length( l_buf ), l_buf );
        end loop;
      exception
        when utl_http.end_of_body then
          utl_http.end_response( l_resp );
      end;
$END
      begin
        l_idx := load_font( p_font              => l_font
                          , p_embed             => p_embed
                          , p_opentype_features => p_opentype_features
                          );
      exception
        when others then
          raise e_font_error;
      end;
      dbms_lob.freetemporary( l_font );
      --
      l_pos1 := l_pos2;
    end loop;
$IF as_pdf.use_utl_http and not as_pdf.use_apex
$THEN
    utl_http.destroy_request_context( l_rck );
    utl_http.set_proxy( l_proxy, l_no_proxy );
    return l_idx;
  exception
    when e_font_error then
      utl_http.destroy_request_context( l_rck );
      utl_http.set_proxy( l_proxy, l_no_proxy );
      raise_application_error( -20054, sqlerrm );
    when e_no_font1 then
      utl_http.set_proxy( l_proxy, l_no_proxy );
      utl_http.end_response( l_resp );
      utl_http.end_request( l_req );
      utl_http.destroy_request_context( l_rck );
      raise_application_error( -20051, 'No Google font found.' );
    when e_no_font2 then
      utl_http.set_proxy( l_proxy, l_no_proxy );
      utl_http.end_response( l_resp );
      utl_http.end_request( l_req );
      utl_http.destroy_request_context( l_rck );
      raise_application_error( -20053, 'No Google font found.' );
    when others then
      utl_http.set_proxy( l_proxy, l_no_proxy );
      utl_http.end_request( l_req );
      utl_http.destroy_request_context( l_rck );
      raise;
$ELSE
    return l_idx;
$END
$ELSE
    raise_application_error( -20029, 'apex_web_service and utl_http not available. Change the package header, set either use_apex := true; or use_utl_http := true;' );
$END
  end load_google_font;
  --
  procedure load_font
    ( p_font              blob
    , p_embed             boolean := true
    , p_subset            boolean := true
    , p_opentype_features boolean := true
    )
  is
    l_idx pls_integer;
  begin
    l_idx := load_font( p_font              => p_font
                      , p_embed             => p_embed
                      , p_subset            => p_subset
                      , p_opentype_features => p_opentype_features
                      );
  end load_font;
  --
  procedure load_font
    ( p_dir               varchar2
    , p_filename          varchar2
    , p_embed             boolean := true
    , p_subset            boolean := true
    , p_opentype_features boolean := true
    )
  is
  begin
    load_font( p_font              => file2blob( p_dir, p_filename )
             , p_embed             => p_embed
             , p_subset            => p_subset
             , p_opentype_features => p_opentype_features
             );
  end load_font;
  --
  procedure load_google_font
    ( p_family            varchar2
    , p_variant           varchar2 := 'normal'
    , p_subset            varchar2 := null
    , p_embed             boolean  := true
    , p_opentype_features boolean  := true
    )
  is
    l_idx pls_integer;
  begin
    l_idx := load_google_font( p_family            => p_family
                             , p_variant           => p_variant
                             , p_subset            => p_subset
                             , p_embed             => p_embed
                             , p_opentype_features => p_opentype_features
                             );
  end load_google_font;
  --
  function string2raw( p_txt    varchar2 character set any_cs
                     , p_target varchar2
                     )
  return raw
  is
  begin
    if isnchar( p_txt )
    then
      if c_db_ncharset = p_target
      then
        return utl_raw.cast_to_raw( p_txt );
      end if;
      return utl_raw.convert( utl_raw.cast_to_raw( p_txt ), p_target, c_db_ncharset );
    elsif c_db_charset = p_target
    then
      return utl_raw.cast_to_raw( p_txt );
    else
      return utl_raw.convert( utl_raw.cast_to_raw( p_txt ), p_target, c_db_charset );
    end if;
  exception
    when value_error then
      return utl_i18n.string_to_raw( p_txt, p_target );
  end string2raw;
  --
  function str_len
    ( p_txt        varchar2 character set any_cs
    , p_font_index pls_integer := null
    , p_fontsize   number      := null
    )
  return number
  is
    l_len         pls_integer;
    l_code        pls_integer;
    l_font_index  pls_integer;
    l_tmp         raw(32767);
    l_buf         varchar2(32767);
    l_last        number;
    l_width       number;
    l_font        tp_font;
  begin
    l_font_index := coalesce( p_font_index, g_pdf.current_font );
    if    p_txt is null
       or l_font_index is null
       or not g_pdf.fonts.exists( l_font_index )
    then
      return 0;
    end if;
    l_width := 0;
    l_font := g_pdf.fonts( l_font_index );
    if l_font.standard
    then
      l_tmp := string2raw( p_txt, 'WE8MSWIN1252' );
      l_len := utl_raw.length( l_tmp );
      if l_len < 16384
      then
        l_buf := rawtohex( l_tmp );
      end if;
      for i in 1 .. l_len
      loop
        if l_len < 16384
        then
          l_code := g_hex( substr( l_tmp, 2 * i - 1, 2 ) );
        else
          l_code := g_hex( rawtohex( utl_raw.substr( l_tmp, i, 1 ) ) );
        end if;
        if l_code between 0 and 255
        then
          l_width := l_width + g_pdf.font_width_cache( - l_font_index )( l_code );
        end if;
      end loop;
    else
      l_last := g_pdf.font_width_cache( l_font_index )( g_pdf.font_width_cache( l_font_index ).last );
      l_tmp := string2raw( p_txt, 'AL16UTF16' );
      for i in 1 .. length( p_txt )
      loop
        l_code := to_number( utl_raw.substr( l_tmp, i * 2 - 1,  2 ), '0XXX' );
        if g_pdf.font_width_cache( l_font_index ).exists( - l_code )
        then
          l_width := l_width + g_pdf.font_width_cache( l_font_index )( - l_code );
        else
          l_width := l_width + l_last;
          g_pdf.font_width_cache( l_font_index )( - l_code ) := l_last;
        end if;
      end loop;
      l_width := l_width * l_font.unit_norm;
    end if;
    return l_width * coalesce( p_fontsize, l_font.fontsize, c_default_fontsize ) / 1000;
  end str_len;
  --
  function ordered_features
    ( p_gsub_gpos tp_gsub_gpos
    , p_script    varchar2
    , p_lang_sys  varchar2
    , p_features  tp_features
    , p_options   varchar2
    )
  return tp_pls_tab
  is
    l_idx     pls_integer;
    l_script  tp_script;
    l_lookup  tp_lookup;
    l_feature tp_feature;
    l_rv      tp_pls_tab;
    l_tmp     tp_pls_tab;
  begin
    --
    if p_gsub_gpos.script_list is null or p_gsub_gpos.script_list.count = 0
    then
      for i in 0 .. p_gsub_gpos.feature_list.count - 1
      loop
        l_tmp( i ) := i;
      end loop;
    else
      for i in 1 .. p_gsub_gpos.script_list.count
      loop
        l_script := p_gsub_gpos.script_list( i );
        if l_script.tag = coalesce( p_script, 'DFLT' )
        then
          if p_lang_sys is null and l_script.script_table.exists( 0 )
          then
            l_tmp := l_script.script_table( 0 ).feature_indices; -- defaultLangSys
          elsif p_lang_sys is not null
          then
            for j in 1 .. l_script.script_table.count - case when l_script.script_table.exists( 0 ) then 1 else 0 end
            loop
              if p_lang_sys = l_script.script_table( i ).tag
              then
                l_tmp := l_script.script_table( j ).feature_indices;
                exit;
              end if;
            end loop;
          end if;
          exit;
        end if;
      end loop;
    end if;
    --
    l_idx := 0;
    for f in 0 .. l_tmp.count - 1
    loop
      if l_tmp( f ) is null
         or p_gsub_gpos.feature_list( l_tmp( f ) ).tag not member of p_features
      then
        continue;
      end if;
      l_rv( l_idx ) := l_tmp( f );
      l_idx := l_idx + 1;
    end loop;
    --
    return l_rv;
  end ordered_features;
  --
  function apply_gsub
    ( p_font_index pls_integer
    , p_glyphs     tp_pls_tab
    , p_script     varchar2
    , p_lang_sys   varchar2
    , p_features   tp_features
    , p_options    varchar2
    , p_apply      boolean
    )
  return tp_pls_tab
  is
    l_cnt             pls_integer;
    l_idx             pls_integer;
    l_tmp_idx         pls_integer;
    l_current         pls_integer;
    l_applied         boolean;
    l_delete_in_type6 boolean;
    l_font            tp_font;
    l_features        tp_pls_tab;
    l_tmp_glyphs      tp_pls_tab;
    l_gsub_glyphs     tp_pls_tab;
    l_lookup          tp_lookup;
    l_subt            tp_subtable;
    l_feature         tp_feature;
    --
    procedure apply_lookup( p_delete_in_type6 boolean );
    --
    procedure apply_lookup_type1
    is
    begin
      l_tmp_glyphs( l_tmp_idx ) := l_subt.coverage( l_current );
      l_tmp_idx := l_tmp_idx + 1;
      l_applied := true;
    end apply_lookup_type1;
    --
    procedure apply_lookup_type2
    is
      l_tmp tp_pls_tab;
    begin
      l_tmp := l_subt.matrix( l_current );
      for i in 1 .. l_tmp.count
      loop
        l_tmp_glyphs( l_tmp_idx ) := l_tmp( i );
        l_tmp_idx := l_tmp_idx + 1;
      end loop;
      l_applied := true;
    end apply_lookup_type2;
    --
    procedure apply_lookup_type4
    is
      l_cnt  pls_integer;
      l_liga pls_integer;
    begin
      if not l_gsub_glyphs.exists( l_idx + 1 )
      then
        return;
      end if;
      <<ligatures_loop>>
      for i in 1 .. l_subt.matrix( l_current )( 0 )
      loop
        l_cnt := l_subt.matrix( l_current )( 20 * i );
        for j in 1 .. l_subt.matrix( l_current )( 20 * i )
        loop
          continue ligatures_loop when
                not l_gsub_glyphs.exists( l_idx + j )
             or l_gsub_glyphs( l_idx + j ) != l_subt.matrix( l_current )( 20 * i + 1 + j );
        end loop;
        l_tmp_glyphs( l_tmp_idx ) := l_subt.matrix( l_current )( 20 * i + 1 );
        l_tmp_idx := l_tmp_idx + 1;
        l_idx := l_idx + l_cnt;
        l_applied := true;
        exit;
      end loop;
    end apply_lookup_type4;
    --
      --
    procedure apply56( p_bias pls_integer, p_current pls_integer, p_extra_len pls_integer, p_delete_in_type56 boolean )
    is
      l_tmp         pls_integer;
      l_cur_idx     pls_integer;
      l_cur_current pls_integer;
      l_cur_tmp_idx pls_integer;
      l_pos_applied tp_pls_tab;
      l_cur_lookup  tp_lookup;
      l_cur_subt    tp_subtable;
    begin
      for j in 0 .. p_extra_len
      loop
        l_tmp_glyphs( l_tmp_idx + j ) := l_gsub_glyphs( l_idx + j );
      end loop;
      l_cur_idx := l_idx;
      l_cur_tmp_idx := l_tmp_idx;
      for j in 1 .. l_subt.matrix( p_current )( p_bias )
      loop
        l_tmp := l_subt.matrix( p_current )( p_bias - 1 + 2 * j );
        l_idx := l_cur_idx + l_tmp;
        l_current := l_gsub_glyphs( l_idx );
        l_tmp_idx := l_cur_tmp_idx + l_subt.matrix( p_current )( p_bias - 1 + 2 * j );
        l_cur_subt := l_subt;
        l_cur_lookup := l_lookup;
        l_lookup := g_pdf.gsub_gpos( p_font_index ).lookup_list( l_subt.matrix( p_current )( p_bias + 2 * j ) );
        apply_lookup( p_delete_in_type56 );
        if l_applied
        then
          l_pos_applied( l_tmp ) := null;
        end if;
        l_subt := l_cur_subt;
        l_lookup := l_cur_lookup;
      end loop;
      l_idx := l_cur_idx + p_extra_len;
      if p_delete_in_type56 and l_subt.matrix( p_current )( p_bias ) > 0
      then
        l_tmp_idx := l_cur_tmp_idx;
        for j in 0 .. p_extra_len
        loop
          if l_pos_applied.exists( j )
          then
            l_tmp_glyphs( l_tmp_idx ) := l_tmp_glyphs( l_cur_tmp_idx + j );
            l_tmp_idx := l_tmp_idx + 1;
          end if;
        end loop;
        l_tmp_glyphs.delete( l_tmp_idx,  l_tmp_idx + p_extra_len );
      else
        l_tmp_idx := l_cur_tmp_idx + p_extra_len + 1;
      end if;
      l_applied := true;
    end apply56;
    --
    procedure apply_lookup_type5
    is
      l_bias      pls_integer;
      l_class     pls_integer;
      l_glyph     pls_integer;
      l_extra_len pls_integer;
    begin
      if l_subt.data_list( 0 ) = 1
      then
        <<rule_set01>>
        for i in 1 .. l_subt.matrix( l_current )( 0 )
        loop
          l_bias := i * 100;
          l_extra_len := l_subt.matrix( l_current )( l_bias + 20 );
          for j in 1 .. l_extra_len
          loop
            continue rule_set01 when not l_gsub_glyphs.exists( l_idx + j )
                                      or l_gsub_glyphs( l_idx + j ) != l_subt.matrix( l_current )( l_bias + 20 + j );
          end loop;
          apply56( l_bias + 80, l_current, l_extra_len, false );
          exit;
        end loop;
      elsif l_subt.data_list( 0 ) = 2
      then
        l_class := l_subt.coverage( l_current );
        <<rule_set02>>
        for i in 1 .. l_subt.matrix( l_class )( 0 )
        loop
          l_bias := i * 100;
          l_extra_len := l_subt.matrix( l_class )( l_bias + 20 );
          for j in 1 .. l_extra_len
          loop
            continue rule_set02 when not l_gsub_glyphs.exists( l_idx + j );
            l_glyph := l_gsub_glyphs( l_idx + j );
            continue rule_set02 when not l_subt.matrix.exists( - l_glyph )
                                  or not l_subt.matrix( - l_glyph ).exists( 1 )
                                  or l_subt.matrix( - l_glyph )( 1 ) != l_subt.matrix( l_class )( l_bias + 20 + j );
          end loop;
          apply56( l_bias + 80, l_class, l_extra_len, false );
          exit;
        end loop;
      else
        l_extra_len := l_subt.data_list( 1 ) - 1;
        for j in 1 .. l_extra_len
        loop
          if not l_gsub_glyphs.exists( l_idx + j )
          then
            return;
          end if;
          l_glyph := l_gsub_glyphs( l_idx + j );
          if    not l_subt.matrix.exists( - j )
             or not l_subt.matrix( - j ).exists( l_glyph )
             or l_subt.matrix( - j )( l_glyph ) != l_gsub_glyphs( l_idx + j )
          then
            return;
          end if;
        end loop;
        apply56( 0, 1, l_extra_len, false );
      end if;
    end apply_lookup_type5;
    --
    procedure apply_lookup_type6( p_delete_in_type6 boolean )
    is
      l_bias      pls_integer;
      l_class     pls_integer;
      l_glyph     pls_integer;
      l_extra_len pls_integer;
    begin
      if l_subt.data_list( 0 ) = 1
      then
        <<rule_set01>>
        for i in 1 .. l_subt.matrix( l_current )( 0 )
        loop
          l_bias := i * 100;
          for j in 1 .. l_subt.matrix( l_current )( l_bias + 20 )
          loop
            continue rule_set01 when l_tmp_idx - j < 1
                                  or l_tmp_glyphs( l_tmp_idx - j ) != l_subt.matrix( l_current )( l_bias + 20 + j );
          end loop;
          l_extra_len := l_subt.matrix( l_current )( l_bias + 40 );
          for j in 1 .. l_extra_len
          loop
            continue rule_set01 when not l_gsub_glyphs.exists( l_idx + j )
                                      or l_gsub_glyphs( l_idx + j ) != l_subt.matrix( l_current )( l_bias + 40 + j );
          end loop;
          for j in 1 .. l_subt.matrix( l_current )( l_bias + 60 )
          loop
            continue rule_set01 when not l_gsub_glyphs.exists( l_idx + l_extra_len + j )
                                      or l_gsub_glyphs( l_idx + l_extra_len + j ) != l_subt.matrix( l_current )( l_bias + 60 + j );
          end loop;
          apply56( l_bias + 80, l_current, l_extra_len, p_delete_in_type6 );
          exit;
        end loop;
      elsif l_subt.data_list( 0 ) = 3
      then
        for i in 1 .. l_subt.data_list( 1 )
        loop
          if    not l_tmp_glyphs.exists( l_tmp_idx - i )
             or not l_subt.matrix( i ).exists( l_tmp_glyphs( l_tmp_idx - i ) )
          then
            return;
          end if;
        end loop;
        l_extra_len := l_subt.data_list( 2 ) - 1;
        for i in 1 .. l_extra_len
        loop
          if    not l_gsub_glyphs.exists( l_idx + i )
             or not l_subt.matrix( 100 + i ).exists( l_gsub_glyphs( l_idx + i ) )
          then
            return;
          end if;
        end loop;
        for i in 1 .. l_subt.data_list( 3 )
        loop
          if    not l_gsub_glyphs.exists( l_idx + i + l_extra_len )
             or not l_subt.matrix( - i ).exists( l_gsub_glyphs( l_idx + i + l_extra_len ) )
          then
            return;
          end if;
        end loop;
        apply56( 0, 0, l_extra_len, p_delete_in_type6 );
      elsif l_subt.data_list( 0 ) = 2
      then
        l_class := l_subt.coverage( l_current );
        <<rule_set02>>
        for i in 1 .. l_subt.matrix( l_class )( 0 )
        loop
          l_bias := i * 100;
          for j in 1 .. l_subt.matrix( l_class )( l_bias + 20 )
          loop
            continue rule_set02 when l_tmp_idx - j < 1;
            l_glyph := l_tmp_glyphs( l_tmp_idx - j );
            continue rule_set02 when not l_subt.matrix.exists( - l_glyph )
                                  or not l_subt.matrix( - l_glyph ).exists( 1 )
                                  or l_subt.matrix( - l_glyph )( 1 ) != l_subt.matrix( l_class )( l_bias + 20 + j );
          end loop;
          l_extra_len := l_subt.matrix( l_class )( l_bias + 40 );
          for j in 1 .. l_extra_len
          loop
            continue rule_set02 when not l_gsub_glyphs.exists( l_idx + j );
            l_glyph := l_gsub_glyphs( l_idx + j );
            continue rule_set02 when not l_subt.matrix.exists( - l_glyph )
                                  or not l_subt.matrix( - l_glyph ).exists( 2 )
                                  or l_subt.matrix( - l_glyph )( 2 ) != l_subt.matrix( l_class )( l_bias + 20 + j );
          end loop;
          for j in 1 .. l_subt.matrix( l_class )( l_bias + 60 )
          loop
            continue rule_set02 when not l_gsub_glyphs.exists( l_idx + l_extra_len + j );
            l_glyph := l_gsub_glyphs( l_idx + l_extra_len + j );
            continue rule_set02 when not l_subt.matrix.exists( - l_glyph )
                                  or not l_subt.matrix( - l_glyph ).exists( 3 )
                                  or l_subt.matrix( - l_glyph )( 3 ) != l_subt.matrix( l_class )( l_bias + 60 + j );
          end loop;
          apply56( l_bias + 80, l_class, l_extra_len, p_delete_in_type6 );
          exit;
        end loop;
      end if;
    end apply_lookup_type6;
    --
    procedure apply_lookup( p_delete_in_type6 boolean )
    is
    begin
      l_applied := false;
      for s in 1 .. l_lookup.subtables.count
      loop
        if not l_lookup.subtables( s ).coverage.exists( l_current )
        then
          continue;
        end if;
        l_subt := l_lookup.subtables( s );
        --
        case l_lookup.lookup_type
          when 1 then apply_lookup_type1;
          when 2 then apply_lookup_type2;
          when 4 then apply_lookup_type4;
          when 5 then apply_lookup_type5;
          when 6 then apply_lookup_type6( p_delete_in_type6 );
          else null;
        end case;
        --
        exit when l_applied;
      end loop;
      --
      if not l_applied
      then
        l_tmp_glyphs( l_tmp_idx ) := l_current;
        l_tmp_idx := l_tmp_idx + 1;
      end if;
    end apply_lookup;
    --
  begin
    if not p_apply or not g_pdf.gsub_gpos.exists( p_font_index )
    then
      return p_glyphs;
    end if;
    l_gsub_glyphs := p_glyphs;
    l_font := g_pdf.fonts( p_font_index );
    l_delete_in_type6 := l_font.delete_in_gsub_type6;
    l_features := ordered_features( g_pdf.gsub_gpos( p_font_index ), p_script, p_lang_sys, p_features, p_options );
    for f in 0 .. l_features.count - 1
    loop
      l_feature := g_pdf.gsub_gpos( p_font_index ).feature_list( l_features( f ) );
      for l in 1 .. l_feature.lookups.count
      loop
        l_lookup := g_pdf.gsub_gpos( p_font_index ).lookup_list( l_feature.lookups( l ) );
        l_cnt := l_gsub_glyphs.count;
        l_idx := 1;
        l_tmp_idx := 1;
        loop
          exit when l_idx > l_cnt;
          l_current := l_gsub_glyphs( l_idx );
          if l_lookup.coverage.exists( l_current )
          then
            apply_lookup( l_delete_in_type6 );
          else
            l_tmp_glyphs( l_tmp_idx ) := l_current;
            l_tmp_idx := l_tmp_idx + 1;
          end if;
          l_idx := l_idx + 1;
        end loop;
        l_gsub_glyphs := l_tmp_glyphs;
        l_tmp_glyphs.delete;
      end loop;
    end loop;
    return l_gsub_glyphs;
  end apply_gsub;
  --
  function apply_gpos
    ( p_font_index pls_integer
    , p_glyphs     tp_pls_tab
    , p_x          number
    , p_y          number
    , p_scaled_sz  number
    , p_script     varchar2
    , p_lang_sys   varchar2
    , p_features   tp_features
    , p_apply      boolean
    , p_rtl        boolean
    )
  return raw
  is
    l_x            number;
    l_y            number;
    l_tmp_x        number;
    l_last         number;
    l_applied      boolean;
    l_font         tp_font;
    l_script       tp_script;
    l_lookup       tp_lookup;
    l_feature      tp_feature;
    l_features     tp_pls_tab;
    l_cnt          pls_integer;
    l_idx          pls_integer;
    l_mark         pls_integer;
    l_anchor       pls_integer;
    l_glyph        pls_integer;
    l_current      pls_integer;
    l_rv           varchar2(32767);
    l_subt         tp_subtable;
    l_value_record tp_value_record;
    l_null_val_rec tp_value_record;
    type tp_shape is record
      ( glyph   pls_integer
      , width   pls_integer
      , applied boolean
      , val_rec tp_value_record
      );
    type tp_shape_run is table of tp_shape index by pls_integer;
    l_shape      tp_shape;
    l_null_shape tp_shape;
    l_shape_run  tp_shape_run;
    --
    procedure apply_lookup_type1( p_idx pls_integer )
    is
    begin
      l_value_record := l_subt.value_records_list( coalesce( l_subt.coverage( l_current ), 0 ) )( 0 );
      l_applied := true;
    end apply_lookup_type1;
    --
    procedure apply_lookup_type2( p_idx pls_integer )
    is
      l_class pls_integer;
      l_glyph pls_integer;
    begin
      if not p_glyphs.exists( p_idx + 1 )
      then
        return;
      end if;
      l_glyph := p_glyphs( p_idx + 1 );
      l_class := l_subt.coverage( l_current );
      if l_class is null
      then
        if not l_subt.value_records_list( l_current ).exists( l_glyph )
        then
          return;
        end if;
        l_value_record := l_subt.value_records_list( l_current )( l_glyph );
        l_applied := true;
      elsif l_subt.data_list.exists( l_glyph )
      then
        l_value_record := l_subt.value_records_list( l_class )( l_subt.data_list( l_glyph ) + 1 );
        l_applied := true;
      else
        return;
      end if;
    end apply_lookup_type2;
    --
    procedure apply_lookup_type3( p_idx pls_integer )
    is
    begin
 null;
    end apply_lookup_type3;
    --
    procedure apply_lookup_type4( p_idx pls_integer )
    is
      l_class pls_integer;
      l_width pls_integer;
    begin
      if p_idx = 1
      then
        return;
      end if;
      -- l_current should be a class 3 Mark glyph, but we don't check for it
      for i in reverse 1 .. p_idx - 1
      loop
        l_glyph := p_glyphs( i );
        --
        if     g_pdf.gdef.exists( p_font_index )
           and g_pdf.gdef( p_font_index ).class_def.exists( l_glyph )
           and g_pdf.gdef( p_font_index ).class_def( l_glyph ) != 1 -- base
        then
          continue;
        end if;
/*
        if     bitand( l_lookup.lookup_flags, 12 ) > 0
           and g_pdf.gdef.exists( p_font_index )
           and g_pdf.gdef( p_font_index ).class_def.exists( l_glyph )
           and (  (   bitand( l_lookup.lookup_flags, 4 ) > 0
                  and g_pdf.gdef( p_font_index ).class_def( l_glyph ) = 2 -- ligature
                  )
               or (   bitand( l_lookup.lookup_flags, 8 ) > 0  -- ???????
                  and g_pdf.gdef( p_font_index ).class_def( l_glyph ) = 3 -- mark
                  )
               )
        then
           and g_pdf.gdef( p_font_index ).class_def.exists( l_glyph ) then ' = class ' || g_pdf.gdef( p_font_index ).class_def( l_glyph ) end );
          continue;
        end if;
*/
        --
        if not l_subt.matrix.exists( l_glyph )
        then
          return;
        end if;
        l_class := l_subt.coverage( l_current );
        if not l_subt.matrix( l_glyph ).exists( l_class )
        then
          return;
        end if;
        l_width := l_shape_run( i ).width;
        l_value_record.xPlacement := l_subt.matrix( l_glyph )( l_class ) - l_subt.data_list( l_current ) - l_width;
        l_value_record.yPlacement := l_subt.matrix( - l_glyph )( l_class ) - l_subt.data_list( - l_current );
        l_applied := true;
        exit;
      end loop;
    end apply_lookup_type4;
    --
    procedure apply_lookup_type5( p_idx pls_integer )
    is
      l_class pls_integer;
      l_width pls_integer;
    begin
      if p_idx = 1
      then
        return;
      end if;
      -- l_current should be a class 3 Mark glyph, but we don't check for it
      l_class := l_subt.coverage( l_current );
      for i in reverse 1 .. p_idx - 1
      loop
        l_glyph := p_glyphs( i );
        --
        if     bitand( l_lookup.lookup_flags, 10 ) > 0
           and g_pdf.gdef.exists( p_font_index )
           and g_pdf.gdef( p_font_index ).class_def.exists( l_glyph )
           and (  (   bitand( l_lookup.lookup_flags, 2 ) > 0
                  and g_pdf.gdef( p_font_index ).class_def( l_glyph ) = 1 -- base
                  )
               or (   bitand( l_lookup.lookup_flags, 8 ) > 0
                  and g_pdf.gdef( p_font_index ).class_def( l_glyph ) = 3 -- mark
                  )
               )
        then
          continue;
        end if;
        --
        if    not l_subt.matrix.exists( l_glyph )
           or not l_subt.matrix( l_glyph ).exists( l_class )
        then
          return;
        end if;
        l_width := l_shape_run( i ).width;
        l_value_record.xPlacement := coalesce( l_subt.matrix( l_glyph )( l_class ), 0 ) - coalesce( l_subt.data_list( l_current ), 0 ) - l_width;
        l_value_record.yPlacement := coalesce( l_subt.matrix( - l_glyph )( l_class ), 0 ) - coalesce( l_subt.data_list( - l_current ), 0 );
        l_applied := true;
        exit;
      end loop;
    end apply_lookup_type5;
    --
    procedure apply_lookup_type6( p_idx pls_integer )
    is
      l_class pls_integer;
    begin
      if p_idx = 1
      then
        return;
      end if;
      -- l_current should be a class 3 Mark glyph, but we don't check for it
      for i in reverse 1 .. p_idx - 1
      loop
        l_glyph := p_glyphs( i );
        --
        if     bitand( l_lookup.lookup_flags, 6 ) > 0
           and g_pdf.gdef.exists( p_font_index )
           and g_pdf.gdef( p_font_index ).class_def.exists( l_glyph )
           and (  (   bitand( l_lookup.lookup_flags, 4 ) > 0
                  and g_pdf.gdef( p_font_index ).class_def( l_glyph ) = 2 -- ligature
                  )
               or (   bitand( l_lookup.lookup_flags, 2 ) > 0
                  and g_pdf.gdef( p_font_index ).class_def( l_glyph ) = 1 -- base
                  )
               )
        then
          continue;
        end if;
        --
        if not l_subt.matrix.exists( l_glyph )
        then
          return;
        end if;
        l_class := l_subt.coverage( l_current );
        if not l_subt.matrix( l_glyph ).exists( l_class )
        then
          return;
        end if;
        l_value_record.xPlacement := l_subt.matrix( l_glyph )( l_class ) - l_subt.data_list( l_current );
        l_value_record.xPlacement := l_value_record.xPlacement + l_shape_run( i ).val_rec.xPlacement;
        l_value_record.yPlacement := l_subt.matrix( - l_glyph )( l_class ) - l_subt.data_list( - l_current );
        l_value_record.yPlacement := l_value_record.yPlacement + l_shape_run( i ).val_rec.yPlacement;
        l_applied := true;
        exit;
      end loop;
    end apply_lookup_type6;
    --
    procedure apply_lookups( p_idx pls_integer )
    is
    begin
      l_applied := false;
      for s in 1 .. l_lookup.subtables.count
      loop
        if not l_lookup.subtables( s ).coverage.exists( l_current )
        then
          continue;
        end if;
        l_subt := l_lookup.subtables( s );
        --
        case l_lookup.lookup_type
          when 1 then apply_lookup_type1( p_idx );
          when 2 then apply_lookup_type2( p_idx );
          when 3 then apply_lookup_type3( p_idx );
          when 4 then apply_lookup_type4( p_idx );
          when 5 then apply_lookup_type5( p_idx );
          when 6 then apply_lookup_type6( p_idx );
          else null;
        end case;
        --
        exit when l_applied;
      end loop;
      --
    end apply_lookups;
  begin
    l_cnt := p_glyphs.count;
    l_font := g_pdf.fonts( p_font_index );
    l_last := g_pdf.font_width_cache( p_font_index )( g_pdf.font_width_cache( p_font_index ).last );
    --
    for i in 1 .. l_cnt
    loop
      l_current := p_glyphs( i );
      l_shape.glyph := l_current;
      l_shape.width := case when g_pdf.font_width_cache( p_font_index ).exists( l_current ) then g_pdf.font_width_cache( p_font_index )( l_current ) else l_last end;
      l_shape_run( i ) := l_shape;
    end loop;
    --
    if p_apply and g_pdf.gsub_gpos.exists( - p_font_index )
    then
      l_features := ordered_features( g_pdf.gsub_gpos( - p_font_index ), p_script, p_lang_sys, p_features, null );
      for f in 0 .. l_features.count - 1
      loop
        l_feature := g_pdf.gsub_gpos( - p_font_index ).feature_list( l_features( f ) );
        for l in 1 .. l_feature.lookups.count
        loop
          l_lookup := g_pdf.gsub_gpos( - p_font_index ).lookup_list( l_feature.lookups( l ) );
          for i in 1 .. l_cnt
          loop
            l_current := p_glyphs( i );
            if    false -- l_shape_run( i ).applied
               or not l_lookup.coverage.exists( l_current )
            then
              continue;
            end if;
            l_value_record := l_null_val_rec;
            apply_lookups( i );
            if l_applied
            then
              l_shape_run( i ).applied := true;
              l_shape_run( i ).val_rec := l_value_record;
            end if;
          end loop;
        end loop;
      end loop;
    end if;
    --
    l_x := p_x;
    l_y := p_y;
    --
    for i in 1 .. l_cnt
    loop
      l_shape := l_shape_run( case when p_rtl then l_cnt + 1 - i else i end );
      l_glyph := g_pdf.font_old_new( p_font_index )( l_shape.glyph );
      --
      l_tmp_x := l_x;
      if l_shape.val_rec.xPlacement != 0 or l_shape.val_rec.yPlacement != 0
      then
        l_tmp_x := l_x;
        l_x := l_x + p_scaled_sz * ( l_shape.width + coalesce( l_shape.val_rec.xAdvance, 0 ) );
        l_rv := l_rv || '> Tj 1 0 0 1 '
          || to_char_round( l_tmp_x + coalesce( p_scaled_sz * l_shape.val_rec.xPlacement, 0 ) ) || ' '
          || to_char_round( l_y + coalesce( p_scaled_sz * l_shape.val_rec.yPlacement, 0 ) ) || ' Tm '
          || '<' || to_char( l_glyph, 'FM0XXX' ) || '> Tj 1 0 0 1 '
          || to_char_round( l_x ) || ' '
          || to_char_round( l_y ) || ' Tm <';
      elsif l_shape.val_rec.xAdvance != 0 or l_shape.val_rec.yAdvance != 0
      then
        l_x := l_x + p_scaled_sz * ( l_shape.width + coalesce( l_shape.val_rec.xAdvance, 0 ) );
        l_rv := l_rv || to_char( l_glyph, 'FM0XXX' ) || '> Tj 1 0 0 1 '
          || to_char_round( l_x ) || ' '
          || to_char_round( l_y + coalesce( p_scaled_sz * l_shape.val_rec.yAdvance, 0 ) ) || ' Tm <';
      else
        l_rv := l_rv || to_char( l_glyph, 'FM0XXX' );
        l_x := l_x + p_scaled_sz * l_shape.width;
      end if;
    end loop;
    --
    return utl_raw.cast_to_raw( '<' || l_rv || '>' );
  end apply_gpos;
  --
  function txt2raw
    ( p_txt         varchar2 character set any_cs
    , p_font_index  pls_integer
    , p_fontsize    number
    , p_x           number
    , p_y           number
    , p_script      varchar2
    , p_lang_sys    varchar2
    , p_features    tp_features
    , p_apply_gsub  boolean
    , p_apply_gpos  boolean
    , p_rtl         boolean
    )
  return raw
  is
    l_notdef      raw(4);
    l_len         pls_integer;
    l_new         pls_integer;
    l_glyph       pls_integer;
    l_unicode     pls_integer;
    l_font_index  pls_integer;
    l_hex         varchar2(16);
    l_font        tp_font;
    l_glyphs      tp_pls_tab;
    l_gsub_glyphs tp_pls_tab;
    l_glyph2code  tp_pls_tab;
    c_bs     constant varchar2(10) character set p_txt%charset := '\';
    c_bs_to  constant varchar2(10) character set p_txt%charset := '\\';
    c_lp     constant varchar2(10) character set p_txt%charset := '(';
    c_lp_to  constant varchar2(10) character set p_txt%charset := '\(';
    c_rp     constant varchar2(10) character set p_txt%charset := ')';
    c_rp_to  constant varchar2(10) character set p_txt%charset := '\)';
    c_lf     constant varchar2(10) character set p_txt%charset := chr(10);
    c_lf_to  constant varchar2(10) character set p_txt%charset := null;  -- \n
    c_ht     constant varchar2(10) character set p_txt%charset := chr(9);
    c_ht_to  constant varchar2(10) character set p_txt%charset := c_tab_spaces;
    c_cr     constant varchar2(10) character set p_txt%charset := chr(13);
    c_cr_to  constant varchar2(10) character set p_txt%charset := null;  -- \r
  begin
    if p_txt is null
    then
      return null;
    end if;
    l_font_index := gfi( p_font_index );
    g_pdf.fonts( l_font_index ).used := true;
    l_font := g_pdf.fonts( l_font_index );
    --
    if l_font.standard
    then
-- https://sourceforge.net/p/pljrxml2pdf/discussion/general/thread/03abc63d13/#b621
      return string2raw( '(' || replace(
                                replace(
                                replace(
                                replace(
                                replace(
                                replace( p_txt
                                       , c_bs, c_bs_to )
                                       , c_lp, c_lp_to )
                                       , c_rp, c_rp_to )
                                       , c_ht, c_ht_to )
                                       , c_lf, c_lf_to )
                                       , c_cr, c_cr_to ) || ')'
                       , 'WE8MSWIN1252'
                       );
    end if;
    --
    l_notdef := utl_raw.cast_to_raw( coalesce( to_char( l_font.notdef, 'fm0XXX' ), 'FFFF' ) );
    l_len := length( p_txt );
    for i in 1 .. l_len
    loop
      l_hex := string2raw( substr( p_txt, i, 1 ), 'AL16UTF16' );
      if length( l_hex ) = 4
      then
        l_unicode := to_number( l_hex, '0XXX' );
      else
        l_unicode := 1024 * to_number( substr( l_hex, 1,  4 ), '0XXX' ) + to_number( substr( l_hex, 5 ), '0XXX' ) - 56613888;
      end if;
      if g_pdf.font_code_cache( l_font_index ).exists( l_unicode )
      then
        l_glyph := g_pdf.font_code_cache( l_font_index )( l_unicode );
        l_glyph2code( l_glyph ) := l_unicode;
        l_glyphs( i ) := l_glyph;
      else
        l_glyphs( i ) := 0;
      end if;
    end loop;
    --
    l_gsub_glyphs := apply_gsub( l_font_index, l_glyphs, p_script, p_lang_sys, p_features, case when 'logs' member of p_features then '{"log":true}' else '{}' end, p_apply_gsub );
    --
    for i in 1 .. l_gsub_glyphs.count
    loop
      l_glyph := l_gsub_glyphs( i );
      g_pdf.font_glyph_cache( l_font_index )( l_glyph ) := case when l_glyph2code.exists( l_glyph ) then l_glyph2code( l_glyph ) end;
      if not g_pdf.font_old_new( l_font_index ).exists( l_glyph )
      then
        if l_font.cff and l_font.subset
        then
            l_new := g_pdf.font_glyph_cache( l_font_index ).count;
            g_pdf.font_old_new( l_font_index )( l_glyph ) := l_new;
            g_pdf.font_old_new( l_font_index )( - l_new ) := l_glyph;
        else
          g_pdf.font_old_new( l_font_index )( l_glyph ) := l_glyph;
          g_pdf.font_old_new( l_font_index )( - l_glyph ) := l_glyph;
        end if;
      end if;
    end loop;
    --
    return apply_gpos( l_font_index, l_gsub_glyphs, p_x, p_y, p_fontsize * l_font.unit_norm / 1000, p_script, p_lang_sys, p_features, p_apply_gpos, p_rtl );
  end txt2raw;
  --
  procedure put_raw
    ( p_x                number
    , p_y                number
    , p_txt              raw
    , p_degrees_rotation number
    , p_font_index       pls_integer
    , p_fontsize         number
    , p_color            varchar2
    )
  is
    l_sin number;
    l_cos number;
    l_rad number;
    l_tmp varchar2(1000);
  begin
    if p_color is not null
    then
      txt2page( rgb( p_color => p_color ) || 'rg' );
    end if;
    --
    l_tmp := to_char_round( p_x ) || ' ' || to_char_round( p_y );
    if coalesce( p_degrees_rotation, 0 ) = 0
    then
      l_tmp := l_tmp || ' Td ';
    else
      l_rad := p_degrees_rotation / 180 * 3.14159265358979323846264338327950288419716939937510;
      l_sin := sin( l_rad );
      l_cos := cos( l_rad );
      l_tmp := to_char_round( l_cos, 5 )   || ' ' || l_tmp;
      l_tmp := to_char_round( - l_sin, 5 ) || ' ' || l_tmp;
      l_tmp := to_char_round( l_sin, 5 )   || ' ' || l_tmp;
      l_tmp := to_char_round( l_cos, 5 )   || ' ' || l_tmp;
      l_tmp := l_tmp || ' Tm ';
    end if;
    raw2page( utl_raw.concat( utl_raw.cast_to_raw( 'BT ' || l_tmp )
                            , p_txt
                            , utl_raw.cast_to_raw( ' Tj ET' )
                            )
              );
    --
    if p_color is not null
    then
      if g_pdf.color is null
      then
        txt2page( '0 g' );
      else
        txt2page( g_pdf.color );
      end if;
    end if;
  end put_raw;
  --
  procedure put_txt_i
    ( p_x           number
    , p_y           number
    , p_txt         varchar2 character set any_cs
    , p_degrees_rot number
    , p_font_index  pls_integer
    , p_fontsize    number
    , p_color       varchar2
    , p_script      varchar2
    , p_lang_sys    varchar2
    , p_features    tp_features
    , p_apply_gsub  boolean
    , p_apply_gpos  boolean
    , p_rtl         boolean
    )
  is
  begin
    if p_txt is null
    then
      return;
    end if;
    g_pdf.fonts_used := true;
    put_raw( p_x, p_y
           , txt2raw( p_txt, p_font_index, p_fontsize, p_x, p_y, p_script, p_lang_sys, p_features, p_apply_gsub, p_apply_gpos, p_rtl )
           , p_degrees_rot
           , p_font_index
           , p_fontsize
           , p_color
           );
  end put_txt_i;
  --
  function get_features( p_options varchar2 )
  return tp_features
  is
    l_cnt      pls_integer;
    l_tmp      varchar2(32767);
    l_features tp_features;
  begin
    l_cnt := xjv( p_options, 'features.length()' );
    if l_cnt > 0
    then
      l_features := tp_features();
      l_features.extend( l_cnt );
      l_tmp := xjv( p_options, 'features' );
      for i in 0 .. l_cnt - 1
      loop
        l_features( i + 1 ) := substr( l_tmp, instr( l_tmp, '"', 1, 1 + 2 * i ) + 1, 4 );
      end loop;
      return l_features;
    else
      return tp_features( 'kern', 'mark', 'mkmk', 'ccmp', 'liga', 'rlig', 'clig', 'calt', 'dist' );
    end if;
  end get_features;
  --
  procedure outline
    ( p_title varchar2
    , p_level pls_integer
    , p_page  pls_integer
    , p_y     number
    )
  is
    l_outline tp_outline;
  begin
    if   p_title is null
       or coalesce( p_level, 0 ) < 1
       or (   g_pdf.outlines.last is not null
          and g_pdf.outlines( g_pdf.outlines.last ).lvl < p_level - 1
          )
       or (   g_pdf.outlines.last is null
          and p_level != 1
          )
    then
      return;
    end if;
    l_outline.title := substr( p_title, 1, 512 );
    l_outline.lvl   := p_level;
    l_outline.page  := p_page;
    l_outline.y     := p_y;
    g_pdf.outlines( g_pdf.outlines.count ) := l_outline;
  end outline;
  --
  procedure put_txt
    ( p_x                number
    , p_y                number
    , p_txt              varchar2 character set any_cs
    , p_degrees_rotation number      := null
    , p_font_index       pls_integer := null
    , p_fontsize         number      := null
    , p_color            varchar2    := null
    , p_page_proc        pls_integer := null
    , p_options          varchar2 character set any_cs := null
    , p_alpha            number      := null
    , p_outline_lvl      pls_integer := null
    )
  is
    l_chg        boolean;
    l_alpha      number;
    l_fontsize   number;
    l_font_index pls_integer;
    l_page       tp_page;
  begin
    if p_txt is not null
    then
      if p_page_proc is null
      then
        if g_pdf.current_page is null
        then
          new_page;
        end if;
        l_page := g_pdf.pages( g_pdf.current_page );
        if p_font_index is null
        then
          l_font_index := coalesce( g_pdf.current_font, l_page.font_index, g_pdf.fonts.first );
        else
          if not g_pdf.fonts.exists( p_font_index )
          then
            return;
          end if;
          l_font_index := p_font_index;
        end if;
        l_fontsize := coalesce( p_fontsize, l_page.fontsize, g_pdf.fonts( l_font_index ).fontsize, c_default_fontsize );
        if    l_font_index != coalesce( l_page.font_index, - l_font_index )
           or l_fontsize != coalesce( l_page.fontsize, - l_fontsize )
        then
          l_chg := true;
          font2page( l_font_index, l_fontsize );
        end if;
        l_alpha := coalesce( p_alpha, jvs2n( p_options, 'alpha' ) );
        if l_alpha between 0 and 1
        then
          txt2page(  'q ' );
          add_alpha( l_alpha );
        end if;
        put_txt_i( p_x, p_y, p_txt, p_degrees_rotation, l_font_index, l_fontsize, p_color
                 , xjv( p_options, 'script' ), xjv( p_options, 'langSys' )
                 , get_features( p_options )
                 , jvs2b( p_options, 'applyGSUB' ), jvs2b( p_options, 'applyGPOS' )
                 , jvs2b( p_options, 'RTL' )
                 );
        if l_alpha between 0 and 1
        then
          txt2page(  'Q ' );
        end if;
        if l_chg
        then
          font2page;
        end if;
        if p_outline_lvl > 0
        then
          outline( p_txt, p_outline_lvl, g_pdf.current_page + 1, p_y + l_fontsize );
        end if;
      else
        add_page_proc( 10, p_page_proc
                     , p_nums  => tp_numbers( p_x, p_y, p_degrees_rotation, p_font_index, p_fontsize, p_alpha, p_outline_lvl )
                     , p_chars => tp_varchar2s( p_color, p_txt, p_options )
                     , p_nchar => case when isnchar( p_txt ) then p_txt end
                     );
      end if;
    end if;
  end put_txt;
  --
  procedure new_or_next_page
  is
    l_settings tp_settings;
  begin
    if g_pdf.current_page + 1 = g_pdf.pages.count
    then
      l_settings := g_pdf.pages( g_pdf.current_page ).settings;
      new_page;
      g_pdf.pages( g_pdf.current_page ).settings := l_settings;
    else
      set_current_page( g_pdf.current_page + 1 );
    end if;
  end new_or_next_page;
  --
  procedure wti
    ( p_txt               varchar2 character set any_cs
    , p_x                 number
    , p_y                 number
    , p_xmin              number
    , p_xmax              number
    , p_ymin              number
    , p_ymax              number
    , p_font_index        pls_integer
    , p_fontsize          number
    , p_line_spacing      number
    , p_color             varchar2
    , p_align             varchar2
    , p_dry_run           boolean
    , p_new_x      in out number
    , p_new_y      in out number
    , p_lines      in out pls_integer
    , p_page_break in out boolean
    , p_options varchar2 := null
    , p_script      varchar2    := null
    , p_lang_sys    varchar2    := null
    , p_features    tp_features := null
    , p_apply_gsub  boolean     := false
    , p_apply_gpos  boolean     := false
    , p_rtl         boolean     := false

    )
  is
    l_len    number;
    l_pos    pls_integer;
    --
    procedure wt
      ( p_txt varchar2 character set any_cs
      , p_x   number
      , p_y   number
      )
    is
    begin
      wti( p_txt, p_x, p_y, p_xmin, p_xmax, p_ymin, p_ymax, p_font_index, p_fontsize, p_line_spacing, p_color, p_align, p_dry_run, p_new_x, p_new_y, p_lines, p_page_break
         , p_options, p_script, p_lang_sys, p_features, p_apply_gsub, p_apply_gpos, p_rtl
         );
    end;
    --
    procedure line_break( p_p2 varchar2 character set any_cs )
    is
    begin
      p_new_y := p_new_y - p_line_spacing;
      p_lines := coalesce( p_lines, 1 ) + 1;
      if p_new_y < p_ymin
      then
        p_page_break := true;
        if not p_dry_run
        then
          new_or_next_page;
        end if;
        wt( ltrim( p_p2 ), p_xmin, p_ymax );
      else
        wt( ltrim( p_p2 ), p_xmin, p_new_y );
      end if;
    end;
    --
    function split( p_by varchar2 )
    return boolean
    is
      l_p1  pls_integer;
      l_p2  pls_integer;
    begin
      if p_by is null
      then
        l_p1 := instr( p_txt, chr( 10 ) );
        l_p2 := instr( p_txt, chr( 13 ) );
        if l_p1 > 0
        then
          if    l_p2 = l_p1 + 1
             or ( l_p2 > 0 and l_p2 < l_p1 - 1 )
          then
            l_pos := l_p2;
          else
            l_pos := l_p1;
          end if;
        elsif l_p2 > 0
        then
          l_pos := l_p2;
        end if;
      else
        l_pos := instr( p_txt, p_by );
      end if;
      if l_pos > 0
      then
        wt( rtrim( substr( p_txt, 1, l_pos - 1 ), chr( 10 ) || chr( 13 ) || ' ' ), p_x, p_y );
        line_break( substr( p_txt, l_pos + 1 ) );
        return true;
      end if;
      return false;
    end;
  begin
    if p_txt is null
    then
      return;
    end if;
    p_new_y := p_y;
    if split( null )
    then
      return;
    end if;
    l_len := str_len( p_txt, p_font_index, p_fontsize );
    if p_x + l_len <= p_xmax
    then
      if not p_dry_run
      then
        case lower( substr( p_align, 1, 1 ) )
          when 'r' then
            put_txt_i( p_xmax - l_len, p_y, p_txt, null, p_font_index, p_fontsize, p_color
                     , p_script, p_lang_sys, p_features, p_apply_gsub, p_apply_gpos, p_rtl
                     );
          when 'c' then
            put_txt_i( ( p_x + p_xmax - l_len ) / 2, p_y, p_txt, null, p_font_index, p_fontsize, p_color
                     , p_script, p_lang_sys, p_features, p_apply_gsub, p_apply_gpos, p_rtl
                     );
          else
            put_txt_i( p_x, p_y, p_txt, null, p_font_index, p_fontsize, p_color
                     , p_script, p_lang_sys, p_features, p_apply_gsub, p_apply_gpos, p_rtl
                     );
        end case;
      end if;
      p_new_x := p_x + l_len;
      p_new_y := p_y;
    else
      for i in 1 .. 100
      loop
        l_pos := instr( p_txt, ' ', -1, i );
        exit when l_pos = 0;
        l_len := str_len( substr( p_txt, 1, l_pos - 1 ), p_font_index, p_fontsize );
        if p_x + l_len <= p_xmax
        then
          wt( rtrim( substr( p_txt, 1, l_pos - 1 ) ), p_x, p_y );
          line_break( substr( p_txt, l_pos + 1 ) );
          return;
        end if;
      end loop;
      if p_x > p_xmin
      then
        line_break( p_txt );
      else
        if length( p_txt ) <= 1
        then
          raise e_no_fit;
        end if;
        l_pos := ceil( length( p_txt ) / 2 );
        wt( substr( p_txt, 1, l_pos ), p_x, p_y );
        line_break( substr( p_txt, l_pos + 1 ) );
      end if;
    end if;
  end wti;
  --
  procedure write_txt
    ( p_txt        varchar2 character set any_cs
    , p_x          number      := null
    , p_y          number      := null
    , p_font_index pls_integer := null
    , p_fontsize   number      := null
    , p_color      varchar2    := null
    , p_options    varchar2 character set any_cs := null
    )
  is
    l_fontsize   number;
    l_page_break boolean;
    l_lines      pls_integer;
    l_font_index pls_integer;
    l_settings   tp_settings;
  begin
    if g_pdf.current_page is null
    then
      new_page;
    end if;
    l_font_index := gfi( p_font_index );
    l_fontsize := coalesce( p_fontsize, g_pdf.fonts( l_font_index ).fontsize );
    l_settings := g_pdf.pages( g_pdf.current_page ).settings;
    if p_txt is null
    then
      g_pdf.x := coalesce( p_x, g_pdf.x, l_settings.margin_left );
      g_pdf.y := coalesce( p_y, g_pdf.y, l_settings.page_height - l_settings.margin_top - l_fontsize );
    else
      font2page_i( l_font_index, l_fontsize );
      wti( replace( p_txt, chr(9), c_tab_spaces )
         , coalesce( p_x, g_pdf.x, l_settings.margin_left )
         , coalesce( p_y, g_pdf.y, l_settings.page_height - l_settings.margin_top - l_fontsize )
         , l_settings.margin_left, l_settings.page_width - l_settings.margin_left
         , l_settings.margin_bottom, l_settings.page_height - l_settings.margin_top - l_fontsize
         , l_font_index, l_fontsize, g_pdf.line_spacing_factor * l_fontsize, p_color, null
         , false, g_pdf.x, g_pdf.y, l_lines, l_page_break
         , null, xjv( p_options, 'script' ), xjv( p_options, 'langSys' ), get_features( p_options ), jvs2b( p_options, 'applyGSUB' ), jvs2b( p_options, 'applyGPOS' ), jvs2b( p_options, 'RTL' )
         );
    end if;
  exception
    when e_no_fit then
      raise_application_error( -20023, 'Text "'|| p_txt || '" does not fit in allowed space (' || to_char_round( l_settings.page_width - l_settings.margin_left, 0 ) || ').' );
  end write_txt;
  --
  procedure fill_with_borders
    ( p_x1 number
    , p_y1 number
    , p_x2 number
    , p_y2 number
    , p_widths tp_num_tab
    , p_fill_color varchar2
    , p_line_color varchar2
    , p_line_width number
    )
  is
    l_tmp_x number;
  begin
    if p_fill_color is not null
    then
      rect( p_x1, p_y1, p_x2 - p_x1, p_y2 - p_y1
          , case when p_line_width = 0 then p_fill_color else p_line_color end
          , p_fill_color, p_line_width
          );
    end if;
    if coalesce( p_line_width, 1 ) > 0
    then
      path( tp_numbers( p_x1, p_y1, p_x2, p_y1, p_x2, p_y2, p_x1, p_y2, p_x1, p_y1, p_x2, p_y1 )
          , p_line_width, p_line_color
          );
      l_tmp_x := p_x1;
      for i in 1 .. p_widths.count - 1
      loop
        l_tmp_x := l_tmp_x + p_widths( i );
        vertical_line( l_tmp_x, p_y1, p_y2 - p_y1, p_line_width, p_line_color );
      end loop;
    end if;
  end fill_with_borders;
  --
  function get_font_top( p_font tp_font, p_size number )
  return number
  is
  begin
    return  ( 0.5 * p_font.linegap + p_font.ascent ) * p_size / 1000;
  end get_font_top;
  --
  function get_font_bottom( p_font tp_font, p_size number )
  return number
  is
  begin
    return ( 0.5 * p_font.linegap + abs( p_font.descent ) ) * p_size / 1000;
  end get_font_bottom;
  --
  procedure handle_widths
    ( p_widths   tp_numbers
    , p_cnt      pls_integer
    , p_x        number
    , p_settings tp_settings
    , p_options  varchar2 character set any_cs
    , p_out      in out tp_num_tab
    )
  is
    l_width   number;
    l_cnt     pls_integer;
    l_widths  varchar2(32767) character set p_options%charset;
    l_columns varchar2(32767) character set p_options%charset;
  begin
    p_out.delete;
    l_widths  := xjv( p_options, 'widths' );
    l_columns := xjv( p_options, 'columns' );
    l_cnt := 0;
    l_width := 0;
    for i in 1 .. p_cnt
    loop
      p_out( i ) := coalesce( case when p_widths.exists( i ) then p_widths( i ) end
                            , case when l_widths is not null then jvs2n( l_widths, '[' || ( i - 1 ) || ']' ) end
                            , case when l_columns is not null then jvs2n( l_columns, '[' || ( i - 1 ) || '].width' ) end
                            );
      if p_out( i ) is null
      then
        l_cnt := l_cnt + 1;
      else
        l_width := l_width + p_out( i );
      end if;
    end loop;
    if l_cnt > 0
    then
      l_width := coalesce( jvs2n( p_options, 'width' )
                         , p_settings.page_width - p_settings.margin_right - coalesce( p_x, p_settings.margin_left )
                         ) - l_width;
      l_width := greatest( l_width / l_cnt, 0 );
      for i in 1 .. p_cnt
      loop
        if p_out( i ) is null
        then
          p_out( i ) := l_width;
        end if;
      end loop;
    end if;
  end handle_widths;
  --
  procedure get_padding
    ( p_options varchar2 character set any_cs
    , p_top     out number
    , p_bottom  out number
    , p_left    out number
    , p_right   out number
    , p_array   varchar2 := null
    , p_pre     varchar2 := null
    , p_padding number   := null
    )
  is
    l_tmp number;
    function pre( p_initial varchar2 )
    return varchar2
    is
    begin
      return p_array || case when p_pre is null
                          then p_initial
                          else p_pre || upper( p_initial )
                        end;
    end;
  begin
    l_tmp := coalesce( p_padding, jvs2n( p_options, pre( 'p' ) || 'adding' ) );
    if l_tmp is not null
    then
      p_top    := l_tmp;
      p_bottom := l_tmp;
      p_left   := l_tmp;
      p_right  := l_tmp;
    end if;
    l_tmp := jvs2n( p_options, pre( 'h' ) || 'orizontalPadding' );
    if l_tmp is not null
    then
      p_left  := l_tmp;
      p_right := l_tmp;
    end if;
    l_tmp := jvs2n( p_options, pre( 'v' ) || 'erticalPadding' );
    if l_tmp is not null
    then
      p_top    := l_tmp;
      p_bottom := l_tmp;
    end if;
    l_tmp := jvs2n( p_options, pre( 't' ) || 'opPadding' );
    if l_tmp is not null
    then
      p_top := l_tmp;
    end if;
    l_tmp := jvs2n( p_options, pre( 'b' ) || 'ottomPadding' );
    if l_tmp is not null
    then
      p_bottom := l_tmp;
    end if;
    l_tmp := jvs2n( p_options, pre( 'l' ) || 'eftPadding' );
    if l_tmp is not null
    then
      p_left := l_tmp;
    end if;
    l_tmp := jvs2n( p_options, pre( 'r' ) || 'ightPadding' );
    if l_tmp is not null
    then
      p_right := l_tmp;
    end if;
  end get_padding;
  --
  procedure multi_cell
    ( p_txt        varchar2 character set any_cs
    , p_x          number
    , p_y          number
    , p_width      number      := null
    , p_height     number      := null
    , p_padding    number      := null
    , p_font_index pls_integer := null
    , p_fontsize   number      := null
    , p_txt_color  varchar2    := null
    , p_fill_color varchar2    := null
    , p_line_color varchar2    := null
    , p_align      varchar2    := null
    , p_line_width number      := null
    , p_url        varchar2    := null
    , p_options    varchar2 character set any_cs := null
    , p_page_proc  pls_integer := null
    )
  is
    l_x          number;
  --  l_y          number;
    l_lw         number;
    l_bp         number;
    l_lp         number;
    l_rp         number;
    l_tp         number;
    l_mt         number;
    l_mh         number;
    l_width      number;
    l_tmp_x      number;
    l_tmp_y      number;
    l_fontsize   number;
    l_line_sp    number;
    l_lines      pls_integer;
    l_font_index pls_integer;
    l_text_color varchar2(32767);
    l_fill_color varchar2(32767);
    l_line_color varchar2(32767);
    l_font       tp_font;
    l_widths     tp_num_tab;
    l_settings   tp_settings;
    --
    procedure wt( p_dry_run boolean )
    is
      l_pb boolean;
    begin
      if not p_dry_run
      then
        font2page_i( l_font_index, l_fontsize );
      end if;
      wti( replace( p_txt, chr(9), c_tab_spaces )
         , l_x + l_lp + 0.5 * l_lw, p_y - l_mt - 0.5 * l_lw - l_tp
         , l_x + l_lp + 0.5 * l_lw, l_x + l_width - l_rp - 0.5 * l_lw
         , null, null
         , l_font_index, l_fontsize, l_line_sp
         , l_text_color, null
         , p_dry_run, l_tmp_x, l_tmp_y, l_lines, l_pb
         , null, xjv( p_options, 'script' ), xjv( p_options, 'langSys' ), get_features( p_options ), jvs2b( p_options, 'applyGSUB' ), jvs2b( p_options, 'applyGPOS' ), jvs2b( p_options, 'RTL' )
         );
      exception
        when e_no_fit then
          raise_application_error( -20023, 'Text "'|| p_txt  || '" does not fit in allowed space (' || to_char_round( l_width, 0 ) || ').' );
      end wt;
  begin
    if p_page_proc is null
    then
      if g_pdf.current_page is null
      then
        new_page;
      end if;
      l_settings := g_pdf.pages( g_pdf.current_page ).settings;
      --
      l_lw := coalesce( p_line_width
                      , jvs2n( p_options, 'lineWidth' )
                      , c_default_line_width
                      );
      l_font_index := gfi( coalesce( p_font_index, jvs2n( p_options, 'fontIndex' ) ) );
      l_font := g_pdf.fonts( l_font_index );
      l_fontsize := coalesce( p_fontsize, jvs2n( p_options, 'fontSize' ), l_font.fontsize );
      l_fill_color := coalesce( p_fill_color, xjv( p_options, 'fillColor' ) );
      l_text_color := coalesce( p_txt_color, xjv( p_options, 'textColor' ) );
      l_line_color := coalesce( p_line_color, xjv( p_options, 'lineColor' ) );
      get_padding( p_options, l_tp, l_bp, l_lp, l_rp, p_padding => p_padding );
      l_tp := coalesce( l_tp, 0 );
      l_bp := coalesce( l_bp, 0 );
      l_lp := coalesce( l_lp, 2 );
      l_rp := coalesce( l_rp, 2 );
      l_mt := get_font_top( l_font, l_fontsize );
      l_mh := coalesce( jvs2n( p_options, 'minimalHeight' ), 0 );
      l_mh := greatest( l_mh, get_font_bottom( l_font, l_fontsize ) + l_mt );
      l_line_sp := coalesce( jvs2n( p_options, 'lineSpacing' )
                           , l_fontsize * coalesce( jvs2n( p_options, 'lineSpacingFactor' ), g_pdf.line_spacing_factor )
                           );
      --
      l_x := coalesce( p_x, l_settings.margin_left );
      l_width := coalesce( p_width, jvs2n( p_options, 'width' ), l_settings.page_width - l_settings.margin_right - l_x );
      l_widths( 1 ) := l_width;
      --
      wt( true );
      l_mh := greatest( coalesce( p_height, jvs2n( p_options, 'height' ), 0 ), l_mh + l_line_sp * ( coalesce( l_lines, 1 ) - 1 ) );
      fill_with_borders
        ( l_x, p_y
        , l_x + l_width, p_y - l_mh - l_lw - l_bp - l_tp
        , l_widths, l_fill_color, l_line_color, l_lw
        );
      wt( false );
      if p_url is not null
      then
        annot( p_subtype    => 'Link'
             , p_txt        => null
             , p_x          => l_x
             , p_y          => p_y - l_mt - 0.5 * l_lw - l_tp
             , p_font_index => l_font_index
             , p_fontsize   => l_fontsize
             , p_url        => p_url
             , p_put_txt    => false
             );
      end if;
    else
      add_page_proc( 11, p_page_proc
                   , p_nums  => tp_numbers( p_x, p_y, p_width, p_padding, p_font_index, p_fontsize, p_line_width )
                   , p_chars => tp_varchar2s( p_txt_color, p_fill_color, p_line_color, p_align, p_txt, p_url, p_options )
                   , p_nchar => case when isnchar( p_txt ) then p_txt end
                   );
    end if;
  exception
    when e_no_fit then
      raise_application_error( -20023, 'Text "'|| p_txt || '" does not fit in allowed space (' || to_char_round( l_width, 0 ) || ').' );
  end multi_cell;
  --
  procedure table_row
    ( p_txt        tp_varchar2s
    , p_x          number
    , p_y          number
    , p_widths     tp_numbers  := null
    , p_padding    number      := null
    , p_font_index pls_integer := null
    , p_fontsize   number      := null
    , p_min_height number      := null
    , p_align      varchar2    := null
    , p_txt_color  varchar2    := null
    , p_fill_color varchar2    := null
    , p_line_color varchar2    := null
    , p_line_width number      := null
    , p_options    varchar2 character set any_cs := null
    )
  is
    l_x          number;
    l_lw         number;
    l_bp         number;
    l_lp         number;
    l_rp         number;
    l_tp         number;
    l_mt         number;
    l_mh         number;
    l_tmp        number;
    l_tmp_x      number;
    l_tmp_y      number;
    l_min_height number;
    l_fontsize   number;
    l_col_fs     number;
    l_line_sp    number;
    l_line_spf   number;
    l_row_width  number;
    l_y_offset   number;
    l_cnt        pls_integer;
    l_lines      pls_integer;
    l_col_fi     pls_integer;
    l_font_index pls_integer;
    l_pb         boolean;
    l_col_path   varchar2(100);
    l_text_color varchar2(32767);
    l_fill_color varchar2(32767);
    l_line_color varchar2(32767);
    l_font       tp_font;
    l_col_font   tp_font;
    l_fi         tp_pls_tab;
    l_fs         tp_num_tab;
    l_cls        tp_num_tab;
    l_cbp        tp_num_tab;
    l_clp        tp_num_tab;
    l_crp        tp_num_tab;
    l_ctp        tp_num_tab;
    l_widths     tp_num_tab;
    l_settings   tp_settings;
    --
    procedure wt( p_idx pls_integer, p_dry_run boolean )
    is
    begin
      if not p_dry_run
      then
        font2page_i( l_fi( p_idx ), l_fs( p_idx ) );
      end if;
      wti( replace( p_txt( p_idx ), chr(9), c_tab_spaces )
         , l_x + l_clp( p_idx ) + 0.5 * l_lw, p_y - l_y_offset
         , l_x + l_clp( p_idx ) + 0.5 * l_lw, l_x + l_widths( p_idx ) - l_crp( p_idx ) - 0.5 * l_lw
         , null, null
         , l_fi( p_idx ), l_fs( p_idx ), l_cls( p_idx )
         , case when not p_dry_run then coalesce( xjv( p_options, 'columns[' || ( p_idx - 1 ) || '].textColor' ), l_text_color ) end, null
         , p_dry_run, l_tmp_x, l_tmp_y, l_lines, l_pb
         , null, xjv( p_options, 'script' ), xjv( p_options, 'langSys' ), get_features( p_options ), jvs2b( p_options, 'applyGSUB' ), jvs2b( p_options, 'applyGPOS' ), jvs2b( p_options, 'RTL' )
         );
      exception
        when e_no_fit then
          raise_application_error( -20023, 'Text "'|| p_txt( p_idx ) || '" does not fit in allowed space (' || to_char_round( l_widths( p_idx ), 0 ) || ').' );
      end wt;
  begin
    l_cnt := p_txt.count;
    if g_pdf.current_page is null
    then
      new_page;
    end if;
    l_settings := g_pdf.pages( g_pdf.current_page ).settings;
    --
    l_lw := coalesce( p_line_width
                    , jvs2n( p_options, 'lineWidth' )
                    , c_default_line_width
                    );
    l_font_index := gfi( coalesce( p_font_index, jvs2n( p_options, 'fontIndex' ) ) );
    l_font := g_pdf.fonts( l_font_index );
    l_fontsize := coalesce( p_fontsize, jvs2n( p_options, 'fontSize' ), l_font.fontsize );
    l_fill_color := xjv( p_options, 'fillColor' );
    l_text_color := coalesce( p_txt_color, xjv( p_options, 'textColor' ) );
    l_line_color := coalesce( p_line_color, xjv( p_options, 'lineColor' ) );
    get_padding( p_options, l_tp, l_bp, l_lp, l_rp, p_padding => p_padding );
    l_tp := coalesce( l_tp, 0 );
    l_bp := coalesce( l_bp, 0 );
    l_lp := coalesce( l_lp, 2 );
    l_rp := coalesce( l_rp, 2 );
    l_min_height := coalesce( jvs2n( p_options, 'minimalHeight' ), 0 );
    l_min_height := greatest( l_min_height, l_bp + get_font_bottom( l_font, l_fontsize ) + get_font_top( l_font, l_fontsize ) + l_tp );
    l_line_sp := jvs2n( p_options, 'lineSpacing' );
    l_line_spf := coalesce( jvs2n( p_options, 'lineSpacingFactor' ), g_pdf.line_spacing_factor );
    --
    l_x := coalesce( p_x, l_settings.margin_left );
    handle_widths( p_widths, l_cnt, l_x, l_settings, p_options, l_widths );
    l_row_width := 0;
    for i in 1 .. l_cnt
    loop
      l_row_width := l_row_width + l_widths( i );
    end loop;
    --
    l_mt := 0;
    l_mh := l_min_height;
    l_y_offset := 0;
    for c in 1 .. l_cnt
    loop
      l_col_path := 'columns[' || to_char( c - 1 ) || '].';
      l_col_fs := jvs2n( p_options, l_col_path || 'fontSize' );
      l_col_fi := jvs2n( p_options, l_col_path || 'fontIndex' );
      if l_col_fi is null or ( l_col_fi != l_font_index and not g_pdf.fonts.exists( l_col_fi ) )
      then
        l_col_fi := l_font_index;
      end if;
      l_fi( c ) := l_col_fi;
      if l_col_fs is null
      then
        l_col_fs := l_fontsize;
      end if;
      l_fs( c ) := l_col_fs;
      get_padding( p_options, l_ctp( c ), l_cbp( c ), l_clp( c ), l_crp( c ), l_col_path );
      l_ctp( c ) := coalesce( l_ctp( c ), l_tp );
      l_cbp( c ) := coalesce( l_cbp( c ), l_bp );
      l_clp( c ) := coalesce( l_clp( c ), l_lp );
      l_crp( c ) := coalesce( l_crp( c ), l_rp );
      l_cls( c ) := coalesce( jvs2n( p_options, l_col_path || 'lineSpacing' )
                            , l_col_fs * jvs2n( p_options, l_col_path || 'lineSpacingFactor' )
                            , l_line_sp
                            , l_col_fs * l_line_spf
                            );
      --
      l_col_font := g_pdf.fonts( l_col_fi );
      l_tmp := get_font_top( l_col_font, l_col_fs ) + l_ctp( c );
      l_mt := greatest( l_mt, l_tmp );
      l_tmp := l_tmp + get_font_bottom( l_col_font, l_col_fs ) + l_cbp( c );
      wt( c, true );
      l_mh := greatest( l_mh, l_tmp + l_cls( c ) * ( coalesce( l_lines, 1 ) - 1 ) );
    end loop;
    --
    if lower( xjv( p_options, 'yOffset' ) ) = 'true'
    then
      l_y_offset := l_mt + 0.5 * l_lw;
    end if;
    --
    fill_with_borders
      ( l_x, p_y + l_mt + 0.5 * l_lw - l_y_offset
      , l_x + l_row_width, p_y + l_mt - l_mh - 0.5 * l_lw - l_y_offset
      , l_widths, l_fill_color, l_line_color, l_lw
      );
    --
    for c in 1 .. l_cnt
    loop
      wt( c, false );
      l_x := l_x + l_widths( c );
    end loop;
  end table_row;
  --
  procedure c2t
    ( p_cursor in out integer
    , p_x             number
    , p_y             number
    , p_headers       tp_varchar2s
    , p_widths        tp_numbers
    , p_font_index    pls_integer
    , p_fontsize      number
    , p_options       varchar2 character set any_cs
    , p_txt_color     varchar2
    , p_odd_color     varchar2
    , p_even_color    varchar2
    , p_line_color    varchar2
    , p_line_width    number
    , p_min_height    number
    )
  is
    l_y             number;
    l_lw            number;
    l_bp            number;
    l_lp            number;
    l_rp            number;
    l_tp            number;
    l_ft            number;
    l_fb            number;
    l_tmp           number;
    l_tmp_x         number;
    l_tmp_y         number;
    l_start_x       number;
    l_max_top       number;
    l_max_height    number;
    l_min_height    number;
    l_line_spacing  number;
    l_line_width    number;
    l_fontsize      number;
    l_col_fs        number;
    l_line_sp       number;
    l_line_spf      number;
    l_page_break    boolean;
    l_header        boolean;
    l_header_repeat boolean;
    l_idx           pls_integer;
    l_lines         pls_integer;
    l_col_fi        pls_integer;
    l_row_nr        pls_integer;
    l_font_index    pls_integer;
    l_part          pls_integer := 1;
    l_outl_part_lvl pls_integer;
    l_col_path      varchar2(100);
    l_align         varchar2(256);
    l_num_fmt       varchar2(256);
    l_date_fmt      varchar2(256);
    l_text_color    varchar2(32767);
    l_fill_color    varchar2(32767);
    l_line_color    varchar2(32767);
    l_odd_color     varchar2(32767);
    l_even_color    varchar2(32767);
    l_options       varchar2(32767);
    l_outline       varchar2(32767);
    l_outline_part  varchar2(32767);
    l_script        varchar2(10);
    l_lang_sys      varchar2(10);
    l_apply_gsub    boolean;
    l_apply_gpos    boolean;
    l_rtl           boolean;
    l_features      tp_features;
    l_font          tp_font;
    l_col_font      tp_font;
    l_settings      tp_settings;
    l_col_cnt       integer;
    l_desc_tab      dbms_sql.desc_tab2;
    l_b             blob;
    l_d             date;
    l_n             number;
    l_ts            timestamp;
    l_tsz           timestamp with time zone;
    l_tslz          timestamp with local time zone;
    l_r             raw(32767);
    l_v             varchar2(32767);
    l_nv            nvarchar2(32767);
    l_ign_gsub      boolean;
    l_ign_gpos      boolean;
    l_fi            tp_pls_tab;
    l_fs            tp_num_tab;
    l_mh            tp_num_tab;
    l_cls           tp_num_tab;
    l_cbp           tp_num_tab;
    l_clp           tp_num_tab;
    l_crp           tp_num_tab;
    l_ctp           tp_num_tab;
    l_widths        tp_num_tab;
    type tp_header_col is record
      ( font_size      number
      , top_padding    number
      , bottom_padding number
      , left_padding   number
      , right_padding  number
      , line_spacing   number
      , line_spacing_f number
      , font_index     pls_integer
      , fill_color     varchar2(100)
      , text_color     varchar2(100)
      );
    type tp_header_cols is table of tp_header_col index by pls_integer;
    l_header_col  tp_header_col;
    l_header_cols tp_header_cols;
    type tp_fmts is table of varchar2(256) index by pls_integer;
    l_fmts tp_fmts;
    l_ca   tp_fmts;
    --
    procedure print_header
    is
      l_fi     pls_integer;
      l_fs     number;
      l_mt     number := 0;
      l_height number := 0;
      l_x      number := l_start_x;
      l_ph     constant boolean := case when p_headers is not null then p_headers.count >= l_col_cnt else false end;
      l_oh     constant boolean := coalesce( jvs2n( p_options, 'headers.length()' ) > 0, false );
      l_txt    varchar2(32767) character set p_options%charset;
      --
      procedure wt( p_idx pls_integer, p_dry_run boolean )
      is
      begin
        if l_ph
        then
          l_txt := p_headers( p_idx );
        elsif l_oh
        then
          l_txt := coalesce( xjv( p_options, 'headers[' || to_char( p_idx - 1 ) || '].header' )
                           , xjv( p_options, 'headers[' || to_char( p_idx - 1 ) || ']' )
                           );
        else
          l_txt := l_desc_tab( p_idx ).col_name;
        end if;
        if not p_dry_run
        then
          font2page_i( l_header_cols( p_idx ).font_index, l_header_cols( p_idx ).font_size );
        end if;
        wti( replace( l_txt, chr(9), c_tab_spaces )
           , l_x + l_header_cols( p_idx ).left_padding + 0.5 * l_lw, l_y
           , l_x + l_header_cols( p_idx ).left_padding + 0.5 * l_lw, l_x + l_widths( p_idx ) - l_header_cols( p_idx ).right_padding - 0.5 * l_lw
           , null, null
           , l_header_cols( p_idx ).font_index, l_header_cols( p_idx ).font_size, l_header_cols( p_idx ).line_spacing
           , l_header_cols( p_idx ).text_color, null
           , p_dry_run, l_tmp_x, l_tmp_y, l_lines, l_page_break
           , l_options, l_script, l_lang_sys, l_features, l_apply_gsub, l_apply_gpos, l_rtl
           );
      exception
        when e_no_fit then
          raise_application_error( -20023, 'Text "'|| l_txt || '" does not fit in allowed space (' || to_char_round( l_widths( p_idx ), 0 ) || ').' );
      end wt;
    begin
      if not ( l_ph or l_oh or l_header )
      then
        return;
      end if;
      --
      for i in 1 .. l_col_cnt
      loop
        l_fs := l_header_cols( i ).font_size;
        l_fi := l_header_cols( i ).font_index;
        l_col_font := g_pdf.fonts( l_fi );
        l_tmp := get_font_top( l_col_font, l_fs ) + l_header_cols( i ).top_padding;
        l_mt := greatest( l_mt, l_tmp );
        l_tmp := l_tmp + get_font_bottom( l_col_font, l_fs ) + l_header_cols( i ).bottom_padding;
        wt( i, true );
        l_height := greatest( l_height, l_tmp + l_header_cols( i ).line_spacing * ( coalesce( l_lines, 1 ) - 1 ) );
      end loop;
      --
      fill_with_borders
        ( l_start_x, l_y + l_mt + 0.5 * l_lw
        , l_start_x + l_line_width, l_y + l_mt - l_height - 0.5 * l_lw
        , l_widths, l_header_col.fill_color, l_line_color, l_lw
        );
      --
      for i in 1 .. l_col_cnt
      loop
        wt( i,  false );
        l_x := l_x + l_widths( i );
      end loop;
      l_y := l_y - l_height - l_lw - l_max_top + l_mt;
    end print_header;
    --
    procedure row_height_page_break
      ( p_txt varchar2 character set any_cs
      , p_idx pls_integer
      )
    is
      l_lh number;
    begin
      wti( replace( p_txt, chr(9), c_tab_spaces )
         , l_clp( p_idx ) + 0.5 * l_lw, l_y
         , l_clp( p_idx ) + 0.5 * l_lw, l_widths( p_idx ) - l_crp( p_idx ) - 0.5 * l_lw
         , null, null
         , l_fi( p_idx ), l_fs( p_idx ), l_cls( p_idx ), null, null
         , true, l_tmp_x, l_tmp_y, l_lines, l_page_break
         );
      l_lh := l_mh( p_idx ) + l_cls( p_idx ) * ( coalesce( l_lines, 1 ) - 1 );
      if l_y + l_max_top - l_lh < l_settings.margin_bottom
      then
        new_or_next_page;
        l_part := l_part + 1;
        l_y := l_settings.page_height - l_settings.margin_top - l_max_top;
        if l_outline_part is not null
        then
          outline( replace( l_outline_part, '#n#', l_part )
                 , l_outl_part_lvl
                 , g_pdf.current_page + 1
                 , l_y + l_fontsize
                 );
        end if;
        if l_header_repeat
        then
          print_header;
        end if;
      end if;
      l_max_height := greatest( l_max_height, l_lh );
    exception
      when e_no_fit then
        raise_application_error( -20023, 'Text "'|| p_txt || '" does not fit in allowed space (' || to_char_round( l_widths( p_idx ), 0 ) || ').' );
    end row_height_page_break;
    --
    procedure handle_columns( p_how pls_integer )
    is
      l_x       number := l_start_x;
      l_img_pad number;
      --
      procedure hc( p_txt varchar2 character set any_cs, p_idx pls_integer )
      is
      begin
        l_lines := null;
        if p_how = 2
        then
          row_height_page_break( p_txt, p_idx );
        else
          font2page_i( l_fi( p_idx ), l_fs( p_idx ) );
          wti( replace( p_txt, chr(9), c_tab_spaces )
             , l_x + l_clp( p_idx ) + 0.5 * l_lw, l_y
             , l_x + l_clp( p_idx ) + 0.5 * l_lw, l_x + l_widths( p_idx ) - l_crp( p_idx ) - 0.5 * l_lw
             , null, null
             , l_fi( p_idx ), l_fs( p_idx ), l_cls( p_idx ), l_text_color
             , l_ca( p_idx )
             , false, l_tmp_x, l_tmp_y, l_lines, l_page_break
             , l_options, l_script, l_lang_sys, l_features, l_apply_gsub, l_apply_gpos, l_rtl
             );
          l_x := l_x + l_widths( p_idx );
        end if;
      end hc;
    begin
      for c in 1 .. l_col_cnt
      loop
        case
          when     l_desc_tab( c ).col_type in ( 1   -- varchar
                                               , 9   -- varchar2
                                               , 96  -- char
                                               , 112 -- clob
                                               , 8   -- long
                                               )
               and l_desc_tab( c ).col_charsetform = 1
          then
            if p_how = 1
            then
              dbms_sql.define_column( p_cursor, c, l_v, 32767 );
            else
              dbms_sql.column_value( p_cursor, c, l_v );
              if p_how = 3 and upper( l_fmts( c ) ) in ( 'LINK', 'URL' )
              then
                link( l_v, l_v
                    , l_x + l_clp( c ), l_y
                    , l_fi( c ), l_fs( c ), l_text_color
                    );
                l_x := l_x + l_widths( c );
              else
                hc( l_v, c );
              end if;
            end if;
          when l_desc_tab( c ).col_type in ( 2   -- number
                                           , 100 -- bfloat
                                           , 101 -- bdouble
                                           )
          then
            if p_how = 1
            then
              dbms_sql.define_column( p_cursor, c, l_n );
            else
              dbms_sql.column_value( p_cursor, c, l_n );
              hc( to_char( l_n, coalesce( l_fmts( c ), l_num_fmt, 'TM' ) ), c );
            end if;
          when l_desc_tab( c ).col_type = 12  -- date
          then
            if p_how = 1
            then
              dbms_sql.define_column( p_cursor, c, l_d );
            else
              dbms_sql.column_value( p_cursor, c, l_d );
              if coalesce( l_fmts( c ), l_date_fmt ) is null
              then
                hc( to_char( l_d ), c );
              else
                hc( to_char( l_d, coalesce( l_fmts( c ), l_date_fmt ) ), c );
              end if;
            end if;
          when l_desc_tab( c ).col_type = 180  -- timestamp
          then
            if p_how = 1
            then
              dbms_sql.define_column( p_cursor, c, l_ts );
            else
              dbms_sql.column_value( p_cursor, c, l_ts );
              if l_fmts( c ) is null
              then
                hc( to_char( l_ts ), c );
              else
                hc( to_char( l_ts, l_fmts( c ) ), c );
              end if;
            end if;
          when l_desc_tab( c ).col_type = 181  -- timestamp with time zone
          then
            if p_how = 1
            then
              dbms_sql.define_column( p_cursor, c, l_tsz );
            else
              dbms_sql.column_value( p_cursor, c, l_tsz );
              if l_fmts( c ) is null
              then
                hc( to_char( l_tsz ), c );
              else
                hc( to_char( l_tsz, l_fmts( c ) ), c );
              end if;
            end if;
          when l_desc_tab( c ).col_type = 231  -- timestamp with local time zone
          then
            if p_how = 1
            then
              dbms_sql.define_column( p_cursor, c, l_tslz );
            else
              dbms_sql.column_value( p_cursor, c, l_tslz );
              if l_fmts( c ) is null
              then
                hc( to_char( l_tslz ), c );
              else
                hc( to_char( l_tslz, l_fmts( c ) ), c );
              end if;
            end if;
          when l_desc_tab( c ).col_type = 23  -- raw
          then
            if p_how = 1
            then
              dbms_sql.define_column( p_cursor, c, l_r, 32767 );
            elsif upper( l_fmts( c ) ) = 'HEX'
            then
              dbms_sql.column_value( p_cursor, c, l_r );
              hc( rawtohex( l_r ), c );
            elsif p_how = 3
            then
              dbms_sql.column_value( p_cursor, c, l_r );
              put_image( to_blob( l_r )
                       , l_x + l_clp( c ), l_y + l_max_top - l_min_height + l_cbp( c )
                       , l_widths( c ) - l_clp( c ) - l_crp( c )
                       , l_min_height - l_ctp( c ) - l_cbp( c ) - l_lw
                       , 'F', 'F'
                       );
              l_x := l_x + l_widths( c );
            end if;
          when l_desc_tab( c ).col_type = 113  -- blob
          then
            if p_how = 1
            then
              dbms_sql.define_column( p_cursor, c, l_b );
            elsif p_how = 3
            then
              dbms_lob.createtemporary( l_b, true );
              dbms_sql.column_value( p_cursor, c, l_b );
              put_image( l_b
                       , l_x + l_clp( c ), l_y + l_max_top - l_min_height + l_cbp( c )
                       , l_widths( c ) - l_clp( c ) - l_crp( c )
                       , l_min_height - l_ctp( c ) - l_cbp( c ) - l_lw
                       , 'F', 'F'
                       );
              l_x := l_x + l_widths( c );
              if dbms_lob.istemporary( l_b ) = 1
              then
                dbms_lob.freetemporary( l_b );
              end if;
            end if;
          when l_desc_tab( c ).col_type in ( 1   -- varchar
                                           , 9   -- varchar2
                                           , 96  -- char
                                           , 112 -- clob
                                           , 8   -- long
                                           )
          then
            if p_how = 1
            then
              dbms_sql.define_column( p_cursor, c, l_nv, 32767 );
            else
              dbms_sql.column_value( p_cursor, c, l_nv );
              hc( l_nv, c );
            end if;
          else
            raise_application_error( -20030, 'column ' || l_desc_tab( c ).col_name || ' is not supported, type ' || l_desc_tab( c ).col_type );
        end case;
      end loop;
      if p_how = 3
      then
        l_y := l_y - l_max_height - l_lw;
        g_pdf.y := l_y;
      end if;
    end handle_columns;
    --
  begin
    l_script     := xjv( p_options, 'script' );
    l_lang_sys   := xjv( p_options, 'langSys' );
    l_features   := get_features( p_options );
    l_rtl        := jvs2b( p_options, 'RTL' );
    l_apply_gsub := jvs2b( p_options, 'applyGSUB' );
    l_apply_gpos := jvs2b( p_options, 'applyGPOS' );
    l_options := null;
    dbms_sql.describe_columns2( p_cursor, l_col_cnt, l_desc_tab );
    --
    if g_pdf.current_page is null
    then
      new_page;
    end if;
    l_lw := coalesce( p_line_width
                    , jvs2n( p_options, 'lineWidth' )
                    , c_default_line_width
                    );
    l_font_index := gfi( coalesce( p_font_index, jvs2n( p_options, 'fontIndex' ) ) );
    l_font := g_pdf.fonts( l_font_index );
    l_fontsize := coalesce( p_fontsize, jvs2n( p_options, 'fontSize' ), l_font.fontsize );
    l_header := coalesce( upper( xjv( p_options, 'header' ) ) = 'TRUE', false );
    l_header_repeat := coalesce( upper( xjv( p_options, 'headerRepeat' ) ) = 'TRUE', true );
    l_fill_color := xjv( p_options, 'fillColor' );
    l_text_color := coalesce( p_txt_color, xjv( p_options, 'textColor' ) );
    l_line_color := coalesce( p_line_color, xjv( p_options, 'lineColor' ) );
    l_odd_color  := coalesce( p_odd_color, xjv( p_options, 'oddColor' ) );
    l_even_color := coalesce( p_even_color, xjv( p_options, 'evenColor' ) );
    get_padding( p_options, l_tp, l_bp, l_lp, l_rp );
    l_tp := coalesce( l_tp, 0 );
    l_bp := coalesce( l_bp, 0 );
    l_lp := coalesce( l_lp, 2 );
    l_rp := coalesce( l_rp, 2 );
    l_max_top := get_font_top( l_font, l_fontsize ) + l_tp;
    l_min_height := coalesce( p_min_height, jvs2n( p_options, 'minimalHeight' ), 0 );
    l_min_height := greatest( l_min_height, l_bp + get_font_bottom( l_font, l_fontsize ) + l_max_top );
    l_line_sp := jvs2n( p_options, 'lineSpacing' );
    l_line_spf := coalesce( jvs2n( p_options, 'lineSpacingFactor' ), g_pdf.line_spacing_factor );
    l_align := coalesce( xjv( p_options, 'align' ), xjv( p_options, 'alignment' ) );
    l_num_fmt := xjv( p_options, 'numberFormat' );
    l_date_fmt := xjv( p_options, 'dateFormat' );
    --
    for c in 1 .. l_col_cnt
    loop
      l_col_path := 'columns[' || to_char( c - 1 ) || '].';
      l_ca( c ) := coalesce( xjv( p_options, l_col_path || 'align' ), xjv( p_options, l_col_path || 'alignment' ), l_align );
      l_col_fs := jvs2n( p_options, l_col_path || 'fontSize' );
      l_col_fi := jvs2n( p_options, l_col_path || 'fontIndex' );
      if l_col_fi is null or ( l_col_fi != l_font_index and not g_pdf.fonts.exists( l_col_fi ) )
      then
        l_col_fi := l_font_index;
      end if;
      l_fi( c ) := l_col_fi;
      if l_col_fs is null
      then
        l_col_fs := l_fontsize;
      end if;
      l_fs( c ) := l_col_fs;
      get_padding( p_options, l_ctp( c ), l_cbp( c ), l_clp( c ), l_crp( c ), l_col_path );
      l_ctp( c ) := coalesce( l_ctp( c ), l_tp );
      l_cbp( c ) := coalesce( l_cbp( c ), l_bp );
      l_clp( c ) := coalesce( l_clp( c ), l_lp );
      l_crp( c ) := coalesce( l_crp( c ), l_rp );
      if l_col_fi = l_font_index
      then
        l_ft := get_font_top( l_font, l_col_fs );
        l_fb := get_font_bottom( l_font, l_col_fs );
      else
        l_col_font := g_pdf.fonts( l_col_fi );
        l_ft := get_font_top( l_col_font, l_col_fs );
        l_fb := get_font_bottom( l_col_font, l_col_fs );
      end if;
      l_max_top := greatest( l_max_top, l_ft + l_ctp( c ) );
      l_tmp := l_cbp( c ) + l_fb + l_ctp( c ) + l_ft;
      l_mh( c ) := l_tmp;
      l_min_height := greatest( l_min_height, l_tmp );
      l_cls( c ) := coalesce( jvs2n( p_options, l_col_path || 'lineSpacing' )
                            , l_col_fs * jvs2n( p_options, l_col_path || 'lineSpacingFactor' )
                            , l_line_sp
                            , l_col_fs * l_line_spf
                            );
      l_fmts( c ) := coalesce( xjv( p_options, l_col_path || 'format' ), xjv( p_options, l_col_path || 'fmt' ) );
    end loop;
    --
    l_header_col.font_index := jvs2n( p_options, 'headerFontIndex' );
    if l_header_col.font_index is null or not g_pdf.fonts.exists( l_header_col.font_index )
    then
      l_header_col.font_index := l_font_index;
    end if;
    l_header_col.font_size := coalesce( jvs2n( p_options, 'headerFontSize' ), l_fontsize );
    l_header_col.text_color := coalesce( substr( xjv( p_options, 'headerTextColor' ), 1, 100 ), l_text_color );
    l_header_col.fill_color := coalesce( substr( xjv( p_options, 'headerFillColor' ), 1, 100 ), l_fill_color );
    l_header_col.line_spacing := jvs2n( p_options,  'headerLineSpacing' );
    l_header_col.line_spacing_f := jvs2n( p_options,  'headerLineSpacingFactor' );
    get_padding( p_options, l_header_col.top_padding, l_header_col.bottom_padding, l_header_col.left_padding, l_header_col.right_padding, null, 'header' );
    l_header_col.top_padding    := coalesce( l_header_col.top_padding, l_tp );
    l_header_col.bottom_padding := coalesce( l_header_col.bottom_padding, l_bp );
    l_header_col.left_padding   := coalesce( l_header_col.left_padding, l_lp );
    l_header_col.right_padding  := coalesce( l_header_col.right_padding, l_rp );
    for c in 1 .. l_col_cnt
    loop
      l_col_path := 'headers[' || to_char( c - 1 ) || '].';
      l_col_fs := jvs2n( p_options, l_col_path || 'fontSize' );
      l_col_fi := jvs2n( p_options, l_col_path || 'fontIndex' );
      if l_col_fi is null or ( l_col_fi != l_header_col.font_index and not g_pdf.fonts.exists( l_col_fi ) )
      then
        l_col_fi := l_header_col.font_index;
      end if;
      l_header_cols( c ).font_index := l_col_fi;
      if l_col_fs is null
      then
        l_col_fs := l_header_col.font_size;
      end if;
      l_header_cols( c ).font_size := l_col_fs;
      get_padding( p_options, l_header_cols( c ).top_padding, l_header_cols( c ).bottom_padding, l_header_cols( c ).left_padding, l_header_cols( c ).right_padding, l_col_path );
      l_header_cols( c ).top_padding    := coalesce( l_header_cols( c ).top_padding   , l_header_col.top_padding );
      l_header_cols( c ).bottom_padding := coalesce( l_header_cols( c ).bottom_padding, l_header_col.bottom_padding );
      l_header_cols( c ).left_padding   := coalesce( l_header_cols( c ).left_padding  , l_header_col.left_padding );
      l_header_cols( c ).right_padding  := coalesce( l_header_cols( c ).right_padding , l_header_col.right_padding );
      l_header_cols( c ).line_spacing := coalesce( jvs2n( p_options, l_col_path || 'lineSpacing' )
                                                 , l_col_fs * jvs2n( p_options, l_col_path || 'lineSpacingFactor' )
                                                 , l_header_col.line_spacing
                                                 , l_col_fs * l_header_col.line_spacing_f
                                                 , l_line_sp
                                                 , l_col_fs * l_line_spf
                                                 );
      l_header_cols( c ).text_color := coalesce( substr( xjv( p_options, l_col_path || 'textColor' ), 1, 100 ), l_header_col.text_color );
    end loop;
    --
    if g_pdf.current_page is null
    then
      new_page;
    end if;
    l_settings := g_pdf.pages( g_pdf.current_page ).settings;
    if p_x is null
    then
      l_start_x := l_settings.margin_left;
    else
      l_start_x := p_x;
    end if;
    l_y := coalesce( p_y, g_pdf.y, l_settings.page_height - l_settings.margin_top - l_max_top );
    handle_widths( p_widths, l_col_cnt, l_start_x, l_settings, p_options, l_widths );
    l_line_width := 0;
    for i in 1 .. l_col_cnt
    loop
      l_line_width := l_line_width + l_widths( i );
    end loop;
    --
    l_outline := ltrim( rtrim( xjv( p_options, 'outline' ) ) );
    if l_outline is not null
    then
      if l_outline like '{%}'
      then
        outline( xjv( l_outline, 'title' )
               , coalesce( jvs2n( l_outline, 'level' ), 1 )
               , g_pdf.current_page + 1
               , l_y + l_fontsize
               );
        l_outline_part := ltrim( rtrim( xjv( l_outline, 'part' ) ) );
        if l_outline_part is not null
        then
          if l_outline_part like '{%}'
          then
            l_outl_part_lvl := jvs2n( l_outline_part, 'level' );
            l_outline_part := xjv( l_outline_part, 'title' );
          end if;
          l_outl_part_lvl := coalesce( l_outl_part_lvl, 2 );
        end if;
      else
        outline( l_outline, 1, g_pdf.current_page + 1, l_y + l_fontsize );
      end if;
    end if;
    print_header;
    handle_columns( 1 );  -- define column variables
    l_row_nr := 0;
    loop
      exit when dbms_sql.fetch_rows( p_cursor ) = 0;
      l_max_height := l_min_height;
      l_row_nr := l_row_nr + 1;
      handle_columns( 2 ); -- calc row height and goes to next pages when required
      --
      fill_with_borders
        ( l_start_x, l_y + l_max_top + 0.5 * l_lw
        , l_start_x + l_line_width, l_y + l_max_top - l_max_height - 0.5 * l_lw
        , l_widths
        , coalesce( case when bitand( l_row_nr, 1 ) > 0 then l_odd_color else l_even_color end, l_fill_color )
        , l_line_color, l_lw
        );
      handle_columns( 3 ); -- write to pdf
    end loop;
    --
    dbms_sql.close_cursor( p_cursor );
    --
    g_pdf.x := l_start_x;
    g_pdf.y := g_pdf.y - l_fontsize;
    --
  end c2t;
  --
  procedure cursor2table
    ( p_rc         sys_refcursor
    , p_x          number
    , p_y          number
    , p_headers    tp_varchar2s := null
    , p_widths     tp_numbers   := null
    , p_font_index pls_integer  := null
    , p_fontsize   number       := null
    , p_txt_color  varchar2     := null
    , p_odd_color  varchar2     := null
    , p_even_color varchar2     := null
    , p_line_color varchar2     := null
    , p_line_width number       := null
    , p_min_height number       := null
    , p_options    varchar2 character set any_cs := null
    )
  is
    l_cx integer;
    l_rc sys_refcursor;
  begin
    l_rc := p_rc;
    l_cx := dbms_sql.to_cursor_number( l_rc );
    c2t( p_cursor     => l_cx
       , p_x          => p_x
       , p_y          => p_y
       , p_headers    => p_headers
       , p_widths     => p_widths
       , p_font_index => p_font_index
       , p_fontsize   => p_fontsize
       , p_txt_color  => p_txt_color
       , p_odd_color  => p_odd_color
       , p_even_color => p_even_color
       , p_line_color => p_line_color
       , p_line_width => p_line_width
       , p_min_height => p_min_height
       , p_options    => p_options
       );
  end cursor2table;
  --
  procedure query2table
    ( p_query      varchar2
    , p_x          number
    , p_y          number
    , p_headers    tp_varchar2s := null
    , p_widths     tp_numbers   := null
    , p_font_index pls_integer  := null
    , p_fontsize   number       := null
    , p_txt_color  varchar2     := null
    , p_odd_color  varchar2     := null
    , p_even_color varchar2     := null
    , p_line_color varchar2     := null
    , p_line_width number       := null
    , p_min_height number       := null
    , p_options    varchar2 character set any_cs := null
    )
  is
    l_num   number;
    l_cx    integer;
    l_dummy integer;
    l_cnt   pls_integer;
    l_bind  varchar2(32767);
    l_name  varchar2(32767);
    l_value varchar2(32767);
    l_type  varchar2(32767);
    l_fmt   varchar2(32767);
  begin
    l_cx := dbms_sql.open_cursor;
    dbms_sql.parse( l_cx, p_query, dbms_sql.native );
    l_cnt := xjv( p_options, 'binds.length()' );
    if l_cnt > 0
    then
      for i in 0 .. l_cnt - 1
      loop
        l_bind := xjv( p_options, 'binds[' || i || ']' );
        l_value := rtrim( ltrim( xjv( l_bind, 'value' ) ) );
        l_name := ltrim( xjv( l_bind, 'name' ) );
        if l_name is null and l_value is null
        then
          l_name := ':' || to_char( i + 1 );
          l_value := l_bind;
          begin
            l_num := to_number( l_value );
            l_type := 'N';
          exception
            when value_error then null;
          end;
        else
          l_name := ':' || ltrim( l_name, ' :' );
          l_type := upper( substr( ltrim( xjv( l_bind, 'type' ) ), 1, 1 ) );
        end if;
        if l_type = 'N'
        then
          l_fmt := coalesce( xjv( l_bind, 'fmt' ), xjv( l_bind, 'format' ) );
          if l_fmt is null
          then
            dbms_sql.bind_variable( l_cx, l_name, to_number( l_value ) );
          else
            dbms_sql.bind_variable( l_cx, l_name, to_number( l_value, l_fmt ) );
          end if;
        elsif l_type = 'D'
        then
          l_fmt := coalesce( xjv( l_bind, 'fmt' ), xjv( l_bind, 'format' ) );
          if l_fmt is null
          then
            dbms_sql.bind_variable( l_cx, l_name, to_date( l_value ) );
          else
            dbms_sql.bind_variable( l_cx, l_name, to_date( l_value, l_fmt ) );
          end if;
        elsif l_type = 'T'
        then
          l_fmt := coalesce( xjv( l_bind, 'fmt' ), xjv( l_bind, 'format' ) );
          if l_fmt is null
          then
            dbms_sql.bind_variable( l_cx, l_name, to_timestamp( l_value ) );
          else
            dbms_sql.bind_variable( l_cx, l_name, to_timestamp( l_value, l_fmt ) );
          end if;
        elsif l_type = 'Z'
        then
          l_fmt := coalesce( xjv( l_bind, 'fmt' ), xjv( l_bind, 'format' ) );
          if l_fmt is null
          then
            dbms_sql.bind_variable( l_cx, l_name, to_timestamp_tz( l_value ) );
          else
            dbms_sql.bind_variable( l_cx, l_name, to_timestamp_tz( l_value, l_fmt ) );
          end if;
        else
          dbms_sql.bind_variable( l_cx, l_name, l_value );
        end if;
      end loop;
    end if;
    l_dummy := dbms_sql.execute( l_cx );
    c2t( p_cursor     => l_cx
       , p_x          => p_x
       , p_y          => p_y
       , p_headers    => p_headers
       , p_widths     => p_widths
       , p_font_index => p_font_index
       , p_fontsize   => p_fontsize
       , p_txt_color  => p_txt_color
       , p_odd_color  => p_odd_color
       , p_even_color => p_even_color
       , p_line_color => p_line_color
       , p_line_width => p_line_width
       , p_min_height => p_min_height
       , p_options    => p_options
       );
  end query2table;
end as_pdf;
/
