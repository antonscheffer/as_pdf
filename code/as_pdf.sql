create or replace package as_pdf
is
  --
  use_utl_file    constant boolean := true;
  use_dbms_crypto constant boolean := false;
  --
-- declare
-- to do
-- signature
-- CFF font subsetting
-- tables
-- patterns, achtergrond kleur voor text? in table?
--
--https://github.com/lka/excel2zugferd
--https://forums.oracle.com/ords/apexds/post/generating-password-protected-pdf-document-usuing-as-pdf-mi-3107
--https://forums.oracle.com/ords/apexds/post/does-anyone-uses-pl-fpdf-1781
--https://github.com/py-pdf/fpdf2/tree/master/test
--https://github.com/typst/svg2pdf/tree/main/tests
--https://www.adobe.com/uk/acrobat/online/password-protect-pdf.html
--https://github.com/Valerio-Rossetti/Oracle/tree/main
--https://github.com/jtsoya539/as_pdf
--https://github.com/grlicaa/GEN_PDF
--https://www.pdf-online.com/osa/validate.aspx
--https://xodo.com/validate-pdfa
--https://demo.verapdf.org/
--select * from V$TEMPORARY_LOBS
--https://github.com/itext/itext-publications-examples-java/blob/develop/src/main/resources/pdfs/links2.pdf
--https://github.com/uswds/public-sans/tree/develop/fonts
--https://learn.microsoft.com/en-us/typography/opentype/spec/post
--https://github.com/xiayukun/font/blob/master/BAUHS93.TTF
--https://www.w3.org/WAI/WCAG21/Techniques/pdf/PDF6
--https://apex-de.blogspot.com/2024/10/zugferd-xrechnung-development-status.html
--https://www.pdflib.com/pdf-knowledge-base/zugferd-and-factur-x/
--https://publisher.bfo.com/live/help/#_factur_x
--https://www.ilovepdf.com/protect-pdf
--https://www.pdflib.com/pdf-knowledge-base/pdf-password-security/encryption/
--https://pomax.github.io/CFF-glyphlet-fonts/
--https://github.com/Pomax/the-cff-table
--https://github.com/Pomax/fontmetrics.js
--https://pdfa.org/resources/
--https://opentype.js.org/
--https://github.com/itext/itext-publications-examples-java/tree/develop/cmpfiles/sandbox/signatures/validation
--https://simonbengtsson.github.io/jsPDF-AutoTable/#minimal
--https://community.adobe.com/t5/acrobat-discussions/tagging-repeating-table-header/m-p/12094073
--https://github.com/foliojs/pdfkit/blob/master/lib/font/data/Courier.afm
--https://github.com/jboss/uel/blob/master/fonts/Times-Roman.pfb
--https://ctan.org/tex-archive/fonts/psfonts/bitstrea/courier
--  l_zip blob;
--  l_file_names as_zip.file_names;
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
  --
  type tp_numbers   is table of number;
  type tp_varchar2s is table of varchar2(32767);
  type tp_num_tab   is table of number index by pls_integer;
  type tp_pls_tab   is table of pls_integer index by pls_integer;
  type tp_txt_tab   is table of varchar2(100) index by pls_integer;
  --
$IF dbms_db_version.ver_le_11
$THEN
  c_null_num_tab tp_num_tab;
  c_null_pls_tab tp_pls_tab;
  c_null_txt_tab tp_txt_tab;
$ELSIF dbms_db_version.ver_le_12
$THEN
  c_null_num_tab tp_num_tab;
  c_null_pls_tab tp_pls_tab;
  c_null_txt_tab tp_txt_tab;
$END
  --
  function get( p_what pls_integer )
  return number;
  --
  function get_string
    ( p_what pls_integer
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
    );
  --
  procedure write_txt
    ( p_txt        varchar2 character set any_cs
    , p_x          number      := null
    , p_y          number      := null
    , p_font_index pls_integer := null
    , p_fontsize   number      := null
    , p_color      varchar2    := null
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
  procedure multi_cell
    ( p_txt        varchar2 character set any_cs
    , p_x          number
    , p_y          number
    , p_width      number      := null
    , p_padding    number      := null
    , p_font_index pls_integer := null
    , p_fontsize   number      := null
    , p_txt_color  varchar2    := null
    , p_fill_color varchar2    := null
    , p_line_color varchar2    := null
    , p_align      varchar2    := null
    , p_line_width number      := null
    , p_url        varchar2    := null
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
    , p_align      varchar2    := null
    , p_txt_color  varchar2    := null
    , p_fill_color varchar2    := null
    , p_line_color varchar2    := null
    , p_line_width number      := null
$IF dbms_db_version.ver_le_11
$THEN
    , p_fi         tp_pls_tab  := c_null_pls_tab
    , p_fs         tp_num_tab  := c_null_num_tab
    , p_al         tp_txt_tab  := c_null_txt_tab
    , p_tc         tp_txt_tab  := c_null_txt_tab
$ELSIF dbms_db_version.ver_le_12
$THEN
    , p_fi         tp_pls_tab  := c_null_pls_tab
    , p_fs         tp_num_tab  := c_null_num_tab
    , p_al         tp_txt_tab  := c_null_txt_tab
    , p_tc         tp_txt_tab  := c_null_txt_tab
$ELSE
    , p_fi         tp_pls_tab  := tp_pls_tab()
    , p_fs         tp_num_tab  := tp_num_tab()
    , p_al         tp_txt_tab  := tp_txt_tab()
    , p_tc         tp_txt_tab  := tp_txt_tab()
$END
    );
  --
  procedure cursor2table
    ( p_rc            sys_refcursor
    , p_x             number
    , p_y             number
    , p_headers       tp_varchar2s := null
    , p_widths        tp_numbers   := null
    , p_font_index    pls_integer  := null
    , p_fontsize      number       := null
    , p_txt_color     varchar2     := null
    , p_odd_color     varchar2     := null
    , p_even_color    varchar2     := null
    , p_line_color    varchar2     := null
    , p_line_width    number       := null
    , p_header_fi     pls_integer  := null
    , p_header_fs     number       := null
    , p_header_txt_c  varchar2     := null
    , p_header_color  varchar2     := null
    , p_header_repeat boolean      := true
$IF dbms_db_version.ver_le_11
$THEN
    , p_fi            tp_pls_tab  := c_null_pls_tab
    , p_fs            tp_num_tab  := c_null_num_tab
    , p_al            tp_txt_tab  := c_null_txt_tab
    , p_fmt           tp_txt_tab  := c_null_txt_tab
$ELSIF dbms_db_version.ver_le_12
$THEN
    , p_fi            tp_pls_tab  := c_null_pls_tab
    , p_fs            tp_num_tab  := c_null_num_tab
    , p_al            tp_txt_tab  := c_null_txt_tab
    , p_fmt           tp_txt_tab  := c_null_txt_tab
$ELSE
    , p_fi            tp_pls_tab   := tp_pls_tab()
    , p_fs            tp_num_tab   := tp_num_tab()
    , p_al            tp_txt_tab   := tp_txt_tab()
    , p_fmt           tp_txt_tab   := tp_txt_tab()
$END
    );
  --
  procedure query2table
    ( p_query        varchar2
    , p_x             number
    , p_y             number
    , p_headers       tp_varchar2s := null
    , p_widths        tp_numbers   := null
    , p_font_index    pls_integer  := null
    , p_fontsize      number       := null
    , p_txt_color     varchar2     := null
    , p_odd_color     varchar2     := null
    , p_even_color    varchar2     := null
    , p_line_color    varchar2     := null
    , p_line_width    number       := null
    , p_header_fi     pls_integer  := null
    , p_header_fs     number       := null
    , p_header_txt_c  varchar2     := null
    , p_header_color  varchar2     := null
    , p_header_repeat boolean      := true
$IF dbms_db_version.ver_le_11
$THEN
    , p_fi            tp_pls_tab  := c_null_pls_tab
    , p_fs            tp_num_tab  := c_null_num_tab
    , p_al            tp_txt_tab  := c_null_txt_tab
    , p_fmt           tp_txt_tab  := c_null_txt_tab
$ELSIF dbms_db_version.ver_le_12
$THEN
    , p_fi            tp_pls_tab  := c_null_pls_tab
    , p_fs            tp_num_tab  := c_null_num_tab
    , p_al            tp_txt_tab  := c_null_txt_tab
    , p_fmt           tp_txt_tab  := c_null_txt_tab
$ELSE
    , p_fi            tp_pls_tab   := tp_pls_tab()
    , p_fs            tp_num_tab   := tp_num_tab()
    , p_al            tp_txt_tab   := tp_txt_tab()
    , p_fmt           tp_txt_tab   := tp_txt_tab()
$END
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
  procedure put_image
    ( p_img_idx   pls_integer
    , p_x         number               -- left
    , p_y         number               -- bottom
    , p_width     number      := null
    , p_height    number      := null
    , p_align     varchar2    := null
    , p_valign    varchar2    := null
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
  procedure set_initial_zoom( p_zoom_factor number := null );
  --
  procedure set_line_height_factor( p_factor number := 1 );
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
    , p_page_proc  pls_integer := null
    );
  --
  procedure horizontal_line
    ( p_x          number
    , p_y          number
    , p_width      number
    , p_line_width number      := null
    , p_line_color varchar2    := null
    , p_page_proc  pls_integer := null
    );
  --
  procedure vertical_line
    ( p_x          number
    , p_y          number
    , p_height     number
    , p_line_width number      := null
    , p_line_color varchar2    := null
    , p_page_proc  pls_integer := null
    );
  --
  procedure rect
    ( p_x          number
    , p_y          number
    , p_width      number
    , p_height     number
    , p_line_color varchar2    := null
    , p_fill_color varchar2    := null
    , p_line_width number      := null
    , p_page_proc  pls_integer := null
    );
  --
  procedure path
    ( p_steps      tp_numbers
    , p_line_width number      := null
    , p_line_color varchar2    := null
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
    , p_page_proc  pls_integer := null
    );
  --
  procedure circle
    ( p_x          number
    , p_y          number
    , p_radius     number
    , p_line_color varchar2    := null
    , p_fill_color varchar2    := null
    , p_line_width number      := null
    , p_page_proc  pls_integer := null
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
    , p_page_proc        pls_integer := null
    );
  --
  function load_font
    ( p_font  blob
    , p_embed boolean := true
    )
  return pls_integer;
  --
  function load_font
    ( p_dir      varchar2
    , p_filename varchar2
    , p_embed    boolean := true
    )
  return pls_integer;
  --
  procedure load_font
    ( p_font  blob
    , p_embed boolean := true
    );
  --
  procedure load_font
    ( p_dir      varchar2
    , p_filename varchar2
    , p_embed    boolean := true
    );
  --
  function conv2uu( p_value number, p_unit varchar2 )
  return number;
  --
  procedure set_page_format( p_format varchar2 := 'A4' );
  --
  procedure set_page_orientation( p_orientation varchar2 := 'PORTRAIT' );
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
                    , p_unit             varchar2 := 'cm'
                    );
  --
  procedure set_margins
    ( p_top number    := null
    , p_left number   := null
    , p_bottom number := null
    , p_right number  := null
    , p_unit varchar2 := 'cm'
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
                    , p_unit             varchar2 := 'cm'
                    );
  --
  procedure init;
  --
  function finish_pdf( p_password varchar2 := null )
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
  c_version          constant varchar2(10) := '0.4.0';
  c_db_charset       constant varchar2(100) := nls_charset_name( nls_charset_id( 'C' ) );
  c_db_ncharset      constant varchar2(100) := nls_charset_name( nls_charset_id( 'N' ) );
  c_producer         constant varchar2(100) := 'AS-PDF ' || c_version || ' by Anton Scheffer';
  c_eol              constant varchar2(4) := chr( 13 ) || chr( 10 );
  c_default_fontsize constant number := 12;
  c_tab_spaces       constant pls_integer := 4;
  e_no_fit           exception;
  --
  c_LOCAL_FILE_HEADER        constant raw(4) := hextoraw( '504B0304' ); -- Local file header signature
  c_CENTRAL_FILE_HEADER      constant raw(4) := hextoraw( '504B0102' ); -- Central directory file header signature
  c_END_OF_CENTRAL_DIRECTORY constant raw(4) := hextoraw( '504B0506' ); -- End of central directory signature
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
    ( page_width    number
    , page_height   number
    , margin_left   number
    , margin_right  number
    , margin_top    number
    , margin_bottom number
    );
  type tp_page is record
    ( settings   tp_settings
    , font_index pls_integer
    , fontsize   number
    , color      varchar2(100)
    , bk_color   varchar2(100)
    , links      tp_pls_tab
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
    , subset           boolean
    , fontfile2        blob
    , ttf_offset       pls_integer
    , numGlyphs        pls_integer
    , indexToLocFormat pls_integer
    , hmetrics         tp_pls_tab  -- indexed by glyph id
    , code2glyph       tp_pls_tab  -- glyph ids index by char code
    , used_glyphs      tp_pls_tab  -- char codes indexed by glyph id
    , char_width_tab   tp_pls_tab  -- indexed by char code (WE8MSWIN1252)
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
  type tp_link is record
    ( url       varchar2(1024)
    , lt_x      number
    , lt_y      number
    , rb_x      number
    , rb_y      number
    , object_nr number(10)
    );
  type tp_links is table of tp_link index by pls_integer;
  type tp_pdf is record
    ( pdf_blob           blob
    , pdf_version        number
    , pdf_a3_conformance varchar2(1)
    , zoom               number
    , fonts_used         boolean
    , current_font       pls_integer
    , current_page       pls_integer
    , x                  number
    , y                  number
    , line_height_factor number
    , title              varchar2(1024)
    , author             varchar2(1024)
    , subject            varchar2(1024)
    , creator            varchar2(1024)
    , producer           varchar2(1024)
    , keywords           varchar2(8096)
    , color              varchar2(100)
    , bk_color           varchar2(100)
    , meta_rdf_descr     varchar2(32767)
    , key                raw(128)
    , fonts              tp_fonts
    , links              tp_links
    , pages              tp_pages
    , images             tp_images
    , objects            tp_objects
    , page_procs         tp_page_procs
    , page_settings      tp_settings
    , embedded_files     tp_embedded_files
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
    type tp_sbox is table of pls_integer index by pls_integer;
    l_i    pls_integer;
    l_j    pls_integer;
    l_sz   pls_integer;
    l_len  pls_integer;
    l_tmp  pls_integer;
    l_arcfour tp_sbox;
    l_init raw(256);
    l_src  raw(32767);
    l_encr raw(32767);
    l_rv blob;
  begin
    for i in 0 .. 255
    loop
      l_arcfour(i) := i;
    end  loop;
    l_len := utl_raw.length( p_key );
    l_init := utl_raw.substr( utl_raw.copies( p_key, ceil( 256 / l_len ) * l_len ), 1, 256 );
    l_j := 0;
    for i in 0 .. 255
    loop
      l_j := bitand( l_j + l_arcfour( i ) + to_number( utl_raw.substr( l_init, i + 1, 1 ), 'XX' ), 255 );
      l_tmp := l_arcfour( i ) ;
      l_arcfour( i ) := l_arcfour( l_j );
      l_arcfour( l_j ) := l_tmp;
    end  loop;
    l_i := 0;
    l_j := 0;
    --
    l_sz := 32767;
    dbms_lob.createtemporary( l_rv, true );
    for i in 0 .. trunc( ( dbms_lob.getlength( p_src ) - 1 ) / l_sz )
    loop
      l_encr := null;
      l_src := dbms_lob.substr( p_src, l_sz, 1 + i * l_sz );
      l_len := utl_raw.length( l_src );
      for j in 1 .. l_len
      loop
        l_i := bitand( l_i + 1, 255 );
        l_j := bitand( l_j + l_arcfour( l_i ), 255 );
        l_tmp := l_arcfour( l_i  );
        l_arcfour( l_i ) := l_arcfour( l_j );
        l_arcfour( l_j ) := l_tmp;
        l_encr := utl_raw.concat( l_encr, to_char( l_arcfour( bitand( l_arcfour( l_i ) + l_tmp, 255 ) ), 'fm0x' ) );
      end loop;
      dbms_lob.writeappend( l_rv, l_len, utl_raw.bit_xor( l_src, l_encr ) );
    end  loop;
    return l_rv;
  end encrypt_rc4;
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
    g_pdf.pdf_version := coalesce( p_version, 1.4 );
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
  procedure set_initial_zoom( p_zoom_factor number := null )
  is
  begin
    g_pdf.zoom := p_zoom_factor;
  end set_initial_zoom;
  --
  procedure set_line_height_factor( p_factor number := 1 )
  is
  begin
    g_pdf.line_height_factor := coalesce( p_factor, 1 );
  end set_line_height_factor;
  --
  function conv2uu( p_value number, p_unit varchar2 )
  return number
  is
    c_inch constant number := 25.40025;
  begin
    return round( case lower( p_unit )
                    when 'mm'    then p_value * 72 / c_inch
                    when 'cm'    then p_value * 720 / c_inch
                    when 'point' then p_value
                    when 'pt'    then p_value       -- also point
                    when 'inch'  then p_value * 72
                    when 'in'    then p_value * 72  -- also inch
                    when 'pica'  then p_value * 12
                    when 'p'     then p_value * 12  -- also pica
                    when 'pc'    then p_value * 12  -- also pica
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
    , p_unit varchar2 := 'cm'
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
      l_font.char_width_tab := uncompress_withs( p_compressed_tab );
      l_font.unit_norm := 1;
      l_font.ascent  := p_ascent;
      l_font.descent := p_descent;
      l_font.linegap := p_linegap;
      g_pdf.fonts( p_ind ) := l_font;
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
      g_pdf.fonts( 9 ).char_width_tab( i ) := 600;
    end loop;
    --
    init_core_font( 10, 'courier', 'I', 'Courier-Oblique', 97, 800, -200, 90, null );
    g_pdf.fonts( 10 ).char_width_tab := g_pdf.fonts( 9 ).char_width_tab;
    --
    init_core_font( 11, 'courier', 'B', 'Courier-Bold', 33, 800, -200, 90, null );
    g_pdf.fonts( 11 ).char_width_tab := g_pdf.fonts( 9 ).char_width_tab;
    --
    init_core_font( 12, 'courier', 'BI', 'Courier-BoldOblique', 97, 800, -200, 90, null );
    g_pdf.fonts( 12 ).char_width_tab := g_pdf.fonts( 9 ).char_width_tab;
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
  procedure cleanup
  is
  begin
    for i in 1 .. g_pdf.fonts.count
    loop
      g_pdf.fonts( i ).hmetrics.delete;
      g_pdf.fonts( i ).code2glyph.delete;
      g_pdf.fonts( i ).used_glyphs.delete;
      g_pdf.fonts( i ).char_width_tab.delete;
      if dbms_lob.istemporary( g_pdf.fonts( i ).fontfile2 ) = 1
      then
        dbms_lob.freetemporary( g_pdf.fonts( i ).fontfile2 );
      end if;
    end loop;
    for i in 0 .. g_pdf.pages.count - 1
    loop
      g_pdf.pages( i ).links.delete;
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
    g_pdf.fonts.delete;
    g_pdf.links.delete;
    g_pdf.pages.delete;
    g_pdf.images.delete;
    g_pdf.objects.delete;
    g_pdf.page_procs.delete;
    g_pdf.embedded_files.delete;
    g_color_names.delete;
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
  end;
  --
  procedure txt2page( p_txt varchar2, p_page pls_integer := null  )
  is
  begin
    raw2page( utl_raw.cast_to_raw( p_txt ), p_page );
  end;
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
      l_fontsize := coalesce( p_fontsize, g_pdf.fonts( l_font_index ).fontsize, c_default_fontsize );
      g_pdf.pages( g_pdf.current_page ).fontsize := l_fontsize;
      g_pdf.pages( g_pdf.current_page ).font_index := l_font_index;
      txt2page( 'BT /F' || l_font_index || ' '
              || to_char_round( l_fontsize ) || ' Tf ET'
              );
    end if;
  end font2page;
  --
  procedure new_page( p_page_size        varchar2 := null
                    , p_page_orientation varchar2 := null
                    , p_page_width       number := null
                    , p_page_height      number := null
                    , p_margin_left      number := null
                    , p_margin_right     number := null
                    , p_margin_top       number := null
                    , p_margin_bottom    number := null
                    , p_unit             varchar2 := 'cm'
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
    l_val varchar2(32766);
    l_pos number := 1;
    l_len number := dbms_lob.getlength( p_val );
  begin
    loop
      exit when l_pos > l_len;
      l_val := rawtohex( dbms_lob.substr( p_val, 16383, l_pos ) );
      for i in 1 .. length( l_val ) / 2
      loop
        begin
          s1 := s1 + to_number( substr( l_val, i * 2 - 1, 2 ), 'XX' );
        exception
          when others then
            s1 := mod( s1, 65521 ) + to_number( substr( l_val, i * 2 - 1, 2 ), 'XX' );
        end;
        begin
          s2 := s2 + s1;
        exception
          when others then
            s2 := mod( s2, 65521 ) + s1;
        end;
      end loop;
      l_pos := l_pos + 16383;
    end loop;
    s1 := mod( s1, 65521 );
    s2 := mod( s2, 65521 );
    return to_char( s2, 'fm0XXX' ) || to_char( s1, 'fm0XXX' );
  end adler32;
  --
  function flate_encode( p_val blob )
  return blob
  is
    l_blob blob;
  begin
    l_blob := hextoraw( '789C' );
    dbms_lob.copy( l_blob
                 , utl_compress.lz_compress( p_val )
                 , dbms_lob.lobmaxsize
                 , 3
                 , 11
                 );
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
  function subset_font( p_index pls_integer )
  return blob
  is
    l_subset blob;
    l_tmp    varchar2(32767);
    l_buf    varchar2(32767);
    l_loca   tp_pls_tab;
    l_header varchar2(32767);
    l_sz     pls_integer;
    l_cnt    pls_integer;
    l_idx    pls_integer;
    l_len    pls_integer;
    l_mod    pls_integer;
    l_font   tp_font;
    l_pos    integer;
    l_offset integer;
--
procedure cff( p_font blob, p_offset integer, p_len pls_integer )
is
  l_cff       blob;
  l_pos       pls_integer;
  l_off_sz    pls_integer;
  l_operator  pls_integer;
  l_operand   number;
  l_offs      integer;
  l_data_offs integer;
  l_encoding_offs     integer;
  l_char_set_offs     integer;
  l_char_strings_offs integer;
  l_private_dict_offs integer;
  l_private_dict_cnt  pls_integer;
  l_real      varchar2(100);
  l_cff_buf   varchar2(32767);
  type tp_operands is table of number index by pls_integer;
  l_operands tp_operands;
begin
  l_offs := p_offset;
  l_tmp := dbms_lob.substr( p_font, 3, l_offs );
dbms_output.put_line( 'CFF header: ' || l_tmp );
  -- Name INDEX
  l_offs := l_offs + to_number( substr( l_tmp, 5, 2 ), 'XX' );
dbms_output.put_line( 'offs Name INDEX: ' || l_offs );
  l_tmp := dbms_lob.substr( p_font, 3, l_offs );
  l_cnt := to_number( substr( l_tmp, 1, 4 ), 'XXXX' );
  l_off_sz := to_number( substr( l_tmp, 5, 2 ), 'XX' );
  l_offs := l_offs + 3;
  l_data_offs := l_offs + l_off_sz * ( l_cnt + 1 ); -- start data
  for i in 0 .. l_cnt - 1
  loop
    if mod( i, 10 ) = 0
    then
      l_idx := 1;
      l_tmp := dbms_lob.substr( p_font, 11 * l_off_sz, l_offs );
--dbms_output.put_line( substr( l_tmp, 1, 100 ) );
    end if;
dbms_output.put_line( utl_raw.cast_to_varchar2( dbms_lob.substr( p_font
, to_number( substr( l_tmp, l_idx + 2 * l_off_sz, 2 * l_off_sz ), 'XXXXXXXX' )
- to_number( substr( l_tmp, l_idx, 2 * l_off_sz ), 'XXXXXXXX' )
, l_data_offs
) ) );
    l_offs := l_offs + l_off_sz;
    l_data_offs := l_data_offs
            + to_number( substr( l_tmp, l_idx + 2 * l_off_sz, 2 * l_off_sz ), 'XXXXXXXX' )
            - to_number( substr( l_tmp, l_idx, 2 * l_off_sz ), 'XXXXXXXX' );
    l_idx := l_idx + 2 * l_off_sz;
  end loop;
  -- Top DICT INDEX
  l_offs := l_data_offs;
dbms_output.put_line( 'offs Top DICT INDEX: ' || l_offs );
  l_tmp := dbms_lob.substr( p_font, 3, l_offs );
  l_cnt := to_number( substr( l_tmp, 1, 4 ), 'XXXX' );
  l_off_sz := to_number( substr( l_tmp, 5, 2 ), 'XX' );
  l_offs := l_offs + 3;
  l_data_offs := l_offs + l_off_sz * ( l_cnt + 1 ); -- start data
  for i in 0 .. l_cnt - 1
  loop
    if mod( i, 10 ) = 0
    then
      l_idx := 1;
      l_tmp := dbms_lob.substr( p_font, 11 * l_off_sz, l_offs );
    end if;
dbms_output.put_line( to_char( i, '999' ) || ' ' ||
to_number( substr( l_tmp, l_idx, 2 * l_off_sz ), 'XXXXXXXX' ) || ' ' ||
to_number( substr( l_tmp, l_idx + 2 * l_off_sz, 2 * l_off_sz ), 'XXXXXXXX' ) );
    l_cff_buf := dbms_lob.substr( p_font
                                , to_number( substr( l_tmp, l_idx + 2 * l_off_sz, 2 * l_off_sz ), 'XXXXXXXX' )
                                - to_number( substr( l_tmp, l_idx, 2 * l_off_sz ), 'XXXXXXXX' )
                                , l_data_offs
                                );
dbms_output.put_line( l_cff_buf );
    l_pos := 1;
    loop
      exit when l_pos > length( l_cff_buf );
      l_operand := to_number( substr( l_cff_buf, l_pos, 2 ), 'XX' );
      if l_operand between 32 and 246
      then
        l_operand := l_operand - 139;
      elsif l_operand between 247 and 250
      then
        l_operand := ( l_operand - 247 ) * 256 + 108
                  + to_number( substr( l_cff_buf, l_pos + 2, 2 ), 'XX' );
        l_pos := l_pos + 2;
      elsif l_operand between 251 and 254
      then
        l_operand := - ( l_operand - 251 ) * 256 - 108
                  - to_number( substr( l_cff_buf, l_pos + 2, 2 ), 'XX' );
        l_pos := l_pos + 2;
      elsif l_operand = 28
      then
        l_operand := to_number( substr( l_cff_buf, l_pos + 2, 4 ), 'XXXX' );
        if l_operand > 32767
        then
          l_operand := l_operand - 65536;
        end if;
        l_pos := l_pos + 4;
      elsif l_operand = 29
      then
        l_operand := to_number( substr( l_cff_buf, l_pos + 2, 8 ), 'XXXXXXXX' );
        if l_operand > 2147483647
        then
          l_operand := l_operand - 4294967296;
        end if;
        l_pos := l_pos + 8;
      elsif l_operand = 30
      then
        loop
          case substr( l_cff_buf, l_pos + 2, 1 )
            when 'F' then exit;
            when 'A' then l_real := l_real || '.';
            when 'B' then l_real := l_real || 'E';
            when 'C' then l_real := l_real || 'E-';
            when 'E' then l_real := '-' || l_real;
            when 'D' then null;
            else l_real := l_real || substr( l_cff_buf, l_pos + 2, 1 );
          end case;
          l_pos := l_pos + 1;
          exit when l_pos > length( l_cff_buf );
        end loop;
        if bitand( l_pos, 1 ) = 0
        then
          l_pos := l_pos + 1;
        end if;
      elsif l_operand = 12
      then
dbms_output.put_line( 'operator: ' || substr( l_cff_buf, l_pos, 4 ) || ' ' || l_operands.count || ': ' || l_operands( 0 ) || case when l_operands.count > 1 then ' ' || l_operands( 1 ) end );
        l_pos := l_pos + 2;
        l_operands.delete;
        l_operand := null;
      else
dbms_output.put_line( 'operator: ' || substr( l_cff_buf, l_pos, 2 ) || ' ' || l_operands.count || ': ' || l_operands( 0 ) || case when l_operands.count > 1 then ' ' || l_operands( 1 ) end );
        case substr( l_cff_buf, l_pos, 2 )
          when '0F' then l_char_set_offs := l_operands( 0 );
          when '10' then l_encoding_offs := l_operands( 0 );
          when '11' then l_char_strings_offs := l_operands( 0 );
          when '12' then
                      l_private_dict_cnt  := l_operands( 0 );
                      l_private_dict_offs := l_operands( 1 );
          else null;
        end case;
        l_operands.delete;
        l_operand := null;
      end if;
      l_pos := l_pos + 2;
      if l_operand is not null
      then
        l_operands( l_operands.count ) := l_operand;
      end if;
    end loop;
dbms_output.put_line( 'DICT offsets: ' || l_encoding_offs || ':' || l_char_set_offs || ':' || l_char_strings_offs || ':' || l_private_dict_offs );
    l_offs := l_offs + l_off_sz;
    l_data_offs := l_data_offs
            + to_number( substr( l_tmp, l_idx + 2 * l_off_sz, 2 * l_off_sz ), 'XXXXXXXX' )
            - to_number( substr( l_tmp, l_idx, 2 * l_off_sz ), 'XXXXXXXX' );
    l_idx := l_idx + 2 * l_off_sz;
  end loop;
dbms_output.put_line( dbms_lob.substr( p_font, 6, l_data_offs - 3 ) );
  -- String INDEX
  l_offs := l_data_offs;
dbms_output.put_line( 'offs String INDEX: ' || l_offs );
  l_tmp := dbms_lob.substr( p_font, 3, l_offs );
dbms_output.put_line( substr( l_tmp, 1, 100 ) );
  l_cnt := to_number( substr( l_tmp, 1, 4 ), 'XXXX' );
  l_off_sz := to_number( substr( l_tmp, 5, 2 ), 'XX' );
  l_offs := l_offs + 3;
  l_data_offs := l_offs + l_off_sz * ( l_cnt + 1 ); -- start data
l_tmp := dbms_lob.substr( p_font, 11 * l_off_sz, l_offs );
dbms_output.put_line( substr( l_tmp, 1, 100 ) );
  for i in 0 .. l_cnt - 1
  loop
    if mod( i, 10 ) = 0
    then
      l_idx := 1;
      l_tmp := dbms_lob.substr( p_font, 11 * l_off_sz, l_offs );
--dbms_output.put_line( substr( l_tmp, 1, 100 ) );
    end if;
/*
dbms_output.put_line( to_char( i, '999' ) || ' ' ||
to_number( substr( l_tmp, l_idx, 2 * l_off_sz ), 'XXXXXXXX' ) || ' ' ||
to_number( substr( l_tmp, l_idx + 2 * l_off_sz, 2 * l_off_sz ), 'XXXXXXXX' ) || ' ' ||
utl_raw.cast_to_varchar2( dbms_lob.substr( p_font
, to_number( substr( l_tmp, l_idx + 2 * l_off_sz, 2 * l_off_sz ), 'XXXXXXXX' )
- to_number( substr( l_tmp, l_idx, 2 * l_off_sz ), 'XXXXXXXX' )
, l_data_offs
) ) );
*/
    l_offs := l_offs + l_off_sz;
    l_data_offs := l_data_offs
            + to_number( substr( l_tmp, l_idx + 2 * l_off_sz, 2 * l_off_sz ), 'XXXXXXXX' )
            - to_number( substr( l_tmp, l_idx, 2 * l_off_sz ), 'XXXXXXXX' );
    l_idx := l_idx + 2 * l_off_sz;
  end loop;
  l_offs := l_data_offs;
dbms_output.put_line( 'offs Global Subr INDEX: ' || l_offs );
  l_tmp := dbms_lob.substr( p_font, 3, l_offs );
dbms_output.put_line( substr( l_tmp, 1, 100 ) );
  l_cnt := to_number( substr( l_tmp, 1, 4 ), 'XXXX' );
  l_off_sz := to_number( substr( l_tmp, 5, 2 ), 'XX' );
  l_offs := l_offs + 3;
  l_data_offs := l_offs + l_off_sz * ( l_cnt + 1 ); -- start data
dbms_output.put_line( 'data: ' || l_data_offs );
  for i in 0 .. l_cnt - 1
  loop
    if mod( i, 10 ) = 0
    then
      l_idx := 1;
      l_tmp := dbms_lob.substr( p_font, 11 * l_off_sz, l_offs );
    end if;
--dbms_output.put_line( '  ' || i || ' ' || to_number( substr( l_tmp, l_idx, 2 * l_off_sz ), 'XXXXXXXX' ) );
    l_offs := l_offs + l_off_sz;
    l_data_offs := l_data_offs
            + to_number( substr( l_tmp, l_idx + 2 * l_off_sz, 2 * l_off_sz ), 'XXXXXXXX' )
            - to_number( substr( l_tmp, l_idx, 2 * l_off_sz ), 'XXXXXXXX' );
    l_idx := l_idx + 2 * l_off_sz;
  end loop;
--dbms_output.put_line( ' => ' || to_number( substr( l_tmp, l_idx, 2 * l_off_sz ), 'XXXXXXXX' ) );
  -- Encoding
  l_offs := l_data_offs;
dbms_output.put_line( 'offs Encodings: ' || l_offs );
  l_tmp := dbms_lob.substr( p_font, 60, l_offs );
dbms_output.put_line( substr( l_tmp, 1, 100 ) );
  l_tmp := dbms_lob.substr( p_font, 30, l_char_set_offs );
dbms_output.put_line( substr( l_tmp, 1, 100 ) );
  l_tmp := dbms_lob.substr( p_font, 30, l_char_strings_offs );
dbms_output.put_line( substr( l_tmp, 1, 100 ) );
  l_tmp := dbms_lob.substr( p_font, 30, l_private_dict_offs );
dbms_output.put_line( substr( l_tmp, 1, 100 ) );
  dbms_lob.createtemporary( l_cff, true );
            dbms_lob.copy( l_cff
                         , p_font
                         , p_len
                         , 1
                         , p_offset
                         );
  l_len := dbms_lob.getlength( l_cff );
dbms_output.put_line( l_len ||  ' : ' || p_len );
          l_header := l_header
                    || '43464620'                         -- tag
                    || '00000000'                         -- checksum
                    || to_char( l_offset, 'FM0XXXXXXX' )  -- offset
                    || to_char( l_len   , 'FM0XXXXXXX' ); -- length
            dbms_lob.copy( l_subset
                         , l_cff
                         , dbms_lob.getlength( l_cff )
                         , l_offset + 1
                         , 1
                         );
  dbms_lob.freetemporary( l_cff );
end cff; -- 'CFF
  begin
    l_font := g_pdf.fonts( p_index );
    if not l_font.subset or l_font.subtype = 'OpenType'
    then
      return l_font.fontfile2;
    end if;
    -- xxaa
    l_font.used_glyphs( 0 ) := coalesce( l_font.notdef, 65535 );
    l_buf := dbms_lob.substr( l_font.fontfile2, 4096, l_font.ttf_offset );
    l_cnt := to_number( substr( l_buf, 9, 4 ), 'XXXX' );
    --
    for i in 0 .. l_cnt - 1
    loop
      if utl_raw.cast_to_varchar2( substr( l_buf, 25 + i * 32, 8 ) ) = 'loca'
      then
        l_sz := 4000;
        l_offset := to_number( substr( l_buf, 41 + i * 32, 8 ), 'XXXXXXXX' ) + 1;
        for j in 0 .. l_font.numGlyphs
        loop
          if mod( j, l_sz ) = 0
          then
            l_idx := 0;
            l_tmp := dbms_lob.substr( l_font.fontfile2
                                    , l_sz * l_font.indexToLocFormat
                                    , l_offset
                                    );
            l_offset := l_offset + l_sz * l_font.indexToLocFormat;
          end if;
          l_loca( j ) := to_number( substr( l_tmp, 1 + l_idx, 2 * l_font.indexToLocFormat ), 'XXXXXXXX' );
          l_idx := l_idx + 2 * l_font.indexToLocFormat;
        end loop;
        exit;
      end if;
    end loop;
    --
    l_offset := 12 + 16 * l_cnt;
    l_subset := utl_raw.copies( '00', l_offset );
    l_header := substr( l_buf, 1, 24 );
    for i in 0 .. l_cnt - 1
    loop
      l_mod := mod( l_offset, 4 );
      if l_mod > 0
      then
        dbms_lob.writeappend( l_subset, 4 - l_mod, '000000' );
        l_offset := l_offset + 4 - l_mod;
      end if;
      case utl_raw.cast_to_varchar2( substr( l_buf, 25 + i * 32, 8 ) )
        when 'locax'
        then
          l_len := to_number( substr( l_buf, 49 + i * 32, 8 ), 'XXXXXXXX' );
          l_header := l_header
                    || substr( l_buf, 25 + i * 32, 8 )   -- tag
                    || '00000000'                        -- checksum
                    || to_char( l_offset, 'FM0XXXXXXX' ) -- offset
                    || substr( l_buf, 49 + i * 32, 8 );  -- length
          dbms_lob.writeappend( l_subset
                              , l_len
                              , dbms_lob.substr( l_font.fontfile2
                                               , l_len
                                               , to_number( substr( l_buf, 41 + i * 32, 8 ), 'XXXXXXXX' ) + 1
                                               )
                              );
dbms_output.put_line( l_len );
dbms_output.put_line( dbms_lob.substr( l_font.fontfile2
                                               , l_len
                                               , to_number( substr( l_buf, 41 + i * 32, 8 ), 'XXXXXXXX' ) + 1
                                               ) );
        when 'xCFF '
        then
/*
          l_len := to_number( substr( l_buf, 49 + i * 32, 8 ), 'XXXXXXXX' );
          l_header := l_header
                    || substr( l_buf, 25 + i * 32, 8 )   -- tag
                    || substr( l_buf, 33 + i * 32, 8 )   -- checksum
                    || to_char( l_offset, 'FM0XXXXXXX' ) -- offset
                    || substr( l_buf, 49 + i * 32, 8 );  -- length
            dbms_lob.copy( l_subset
                         , l_font.fontfile2
                         , l_len
                         , l_offset + 1
                         , to_number( substr( l_buf, 41 + i * 32, 8 ), 'XXXXXXXX' ) + 1
                         );
*/
          cff( l_font.fontfile2
             , to_number( substr( l_buf, 41 + i * 32, 8 ), 'XXXXXXXX' ) + 1
             , to_number( substr( l_buf, 49 + i * 32, 8 ), 'XXXXXXXX' ) );
        when 'post'
        then
          l_len := 32;
          l_header := l_header
                    || substr( l_buf, 25 + i * 32, 8 )   -- tag
                    || '00000000'                        -- checksum
                    || to_char( l_offset, 'FM0XXXXXXX' ) -- offset
                    || to_char( l_len, 'FM0XXXXXXX' );   -- length
          dbms_lob.writeappend( l_subset
                              , 32
                              , utl_raw.concat( hextoraw( '00030000' )
                                              , dbms_lob.substr( l_font.fontfile2
                                                               , 28
                                                               , to_number( substr( l_buf, 41 + i * 32, 8 ), 'XXXXXXXX' ) + 5
                                                               )
                                              )
                              );
        when 'loca'
        then
          l_len := to_number( substr( l_buf, 49 + i * 32, 8 ), 'XXXXXXXX' );
          l_pos := 0;
          l_tmp := null;
          for j in 0 .. l_font.numGlyphs - 1
          loop
            l_tmp := l_tmp || to_char( l_pos
                                     , rpad( 'fm0'
                                           , 2 + 2 * l_font.indexToLocFormat
                                           , 'X'
                                           )
                                     );
            if length( l_tmp ) > 20000
            then
              dbms_lob.writeappend( l_subset
                                  , length( l_tmp ) / 2
                                  , hextoraw( l_tmp )
                                  );
              l_tmp := null;
            end if;
            if l_font.used_glyphs.exists( j )
            then
              l_pos := l_pos + l_loca( j + 1 ) - l_loca( j );
            end if;
          end loop;
          l_tmp := l_tmp || to_char( l_pos
                                   , rpad( 'fm0'
                                         , 2 + 2 * l_font.indexToLocFormat
                                         , 'X'
                                         )
                                   );
          l_header := l_header
                    || substr( l_buf, 25 + i * 32, 8 )   -- tag
                    || '00000000'                        -- checksum
                    || to_char( l_offset, 'FM0XXXXXXX' ) -- offset
                    || to_char( l_len, 'FM0XXXXXXX' );   -- length
          dbms_lob.writeappend( l_subset
                              , length( l_tmp ) / 2
                              , hextoraw( l_tmp )
                              );
        when 'glyf'
        then
          if l_font.indexToLocFormat = 2
          then
            l_sz := 2;
          else
            l_sz := 1;
          end if;
          l_len := 0;
          l_tmp := null;
          l_pos := to_number( substr( l_buf, 41 + i * 32, 8 ), 'XXXXXXXX' ) + 1;
          for j in 0 .. l_font.numGlyphs - 1
          loop
            if     l_font.used_glyphs.exists( j )
               and l_loca( j + 1 ) > l_loca( j )
            then
              l_len := l_len + l_sz * ( l_loca( j + 1 ) - l_loca( j ) );
              l_tmp := l_tmp
                    || dbms_lob.substr( l_font.fontfile2
                                      , l_sz * ( l_loca( j + 1 ) - l_loca( j ) )
                                      , l_pos
                                      );
              if length( l_tmp ) > 20000
              then
                dbms_lob.writeappend( l_subset
                                    , length( l_tmp ) / 2
                                    , hextoraw( l_tmp )
                                    );
                l_tmp := null;
              end if;
            end if;
            l_pos := l_pos + l_sz * ( l_loca( j + 1 ) - l_loca( j ) );
          end loop;
          l_header := l_header
                    || substr( l_buf, 25 + i * 32, 8 )   -- tag
                    || '00000000'                        -- checksum
                    || to_char( l_offset, 'FM0XXXXXXX' ) -- offset
                    || to_char( l_len, 'FM0XXXXXXX' );   -- length
          if l_tmp is not null
          then
            dbms_lob.writeappend( l_subset
                                , length( l_tmp ) / 2
                                , hextoraw( l_tmp )
                                );
          end if;
        else
          l_len := to_number( substr( l_buf, 49 + i * 32, 8 ), 'XXXXXXXX' );
          l_header := l_header
                    || substr( l_buf, 25 + i * 32, 8 )   -- tag
                    || substr( l_buf, 33 + i * 32, 8 )   -- checksum
                    || to_char( l_offset, 'FM0XXXXXXX' ) -- offset
                    || substr( l_buf, 49 + i * 32, 8 );  -- length
          if l_len <= 32767
          then
            dbms_lob.writeappend( l_subset
                                , l_len
                                , dbms_lob.substr( l_font.fontfile2
                                                 , l_len
                                                 , to_number( substr( l_buf, 41 + i * 32, 8 ), 'XXXXXXXX' ) + 1
                                                 )
                                );
          else
            dbms_lob.copy( l_subset
                         , l_font.fontfile2
                         , l_len
                         , l_offset + 1
                         , to_number( substr( l_buf, 41 + i * 32, 8 ), 'XXXXXXXX' ) + 1
                         );
          end if;
      end case;
      l_offset := l_offset + l_len;
    end loop;
    dbms_lob.copy( l_subset
                 , hextoraw( l_header )
                 , length( l_header) / 2
                 , 1
                 , 1
                 );
--dbms_output.put_line( l_font.fontname || ': ' || dbms_lob.getlength( l_font.fontfile2 ) || ' ' || dbms_lob.getlength( l_subset ) );
    --
--load_font( l_subset, false );
    return l_subset;
  end subset_font;
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
    l_used_glyphs tp_pls_tab;
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
                '/ToUnicode ' || to_char( l_self + 5 ) || ' 0 R' || c_eol ||
                '/DescendantFonts [' || to_char( l_self + 1 ) || ' 0 R ]' || c_eol ||
                '>>' || c_eol || 'endobj'
              ); -- self
    add_object( '/Type /Font' || c_eol       ||
                '/Subtype /CIDFontType2'     || c_eol ||
                '/BaseFont /' || l_font.name || c_eol ||
                '/CIDToGIDMap /Identity'     || c_eol ||
                '/DW 1000'                   || c_eol ||
                '/CIDSystemInfo '  || to_char( l_self + 2 ) || ' 0 R' || c_eol ||
                '/FontDescriptor ' || to_char( l_self + 3 ) || ' 0 R' || c_eol ||
                '/W ' || to_char( l_self + 4 ) || ' 0 R' );               -- self + 1
    add_object( '/Ordering (Identity) /Registry (Adobe) /Supplement 0' ); -- self + 2
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
                case when l_font.fontfile2 is not null then '/FontFile2 ' || to_char( l_self + 6 ) || ' 0 R' end
              );  -- self + 3
    --
    l_used_glyphs := l_font.used_glyphs;
    l_used_glyphs( 0 ) := coalesce( l_font.notdef, 65535 );
  declare
    l_next       pls_integer;
    l_last       pls_integer;
    l_prev       pls_integer;
    l_width      number;
    l_last_width number;
    l_w varchar2(32767);
    --
    function get_width( p_idx pls_integer )
    return number
    is
      l_tmp number;
    begin
      if l_font.hmetrics.exists( p_idx )
      then
        l_tmp := l_font.hmetrics( p_idx );
      else
        l_tmp := l_font.hmetrics( l_font.hmetrics.last );
      end if;
      return trunc( l_tmp * l_font.unit_norm );
    end;
  begin
      l_used_glyphs( 0 ) := coalesce( l_font.notdef, 65535 );
      l_used := l_used_glyphs.first;
      while l_used is not null
      loop
        l_width := get_width( l_used );
        l_next := l_used_glyphs.next( l_used );
        l_last := l_next;
        while     l_next is not null
              and l_width = get_width( l_next )
        loop
          l_last := l_next;
          l_next := l_used_glyphs.next( l_next );
        end loop;
        if l_last = l_next or l_last is null
        then
          if l_prev is null
          then
            l_w := l_w || ' ' || l_used || ' [' || l_width;
          elsif l_prev = l_used - 1
          then
            l_w := l_w || ' ' || l_width;
          else
            l_w := l_w || '] ' || l_used || ' [' || l_width;
          end if;
          if l_last is null
          then
            l_w := l_w || ']';
          end if;
          l_prev := l_used;
        else
          if l_prev is not null
          then
            l_w := l_w || ']';
          end if;
          l_w := l_w || ' ' || l_used || ' ' || l_last || ' ' || l_width;
          if l_next is null
          then
            exit;
          else
            l_prev := null;
            l_used := l_last;
          end if;
        end if;
        l_used := l_used_glyphs.next( l_used );
      end loop;
      l_w := '[' || trim( l_w ) || ']';
      add_object;   -- self + 4
      txt2pdfdoc( l_w || c_eol || 'endobj' );
    end;
    --
    declare
      l_cnt          pls_integer;
      l_remap_symbol pls_integer;
      l_map          varchar2(32767);
      l_cmap         varchar2(32767);
    begin
      if bitand( l_font.flags, 4 ) > 0 and l_font.numGlyphs < 256
      then
        -- assume code 32, space maps to the first code from the font
        l_remap_symbol := l_font.code2glyph.first - 32;
      else
        l_remap_symbol := 0;
      end if;
      l_cnt := 0;
      l_used_glyphs := l_font.used_glyphs;
      l_used := l_used_glyphs.first;
      while l_used is not null
      loop
        l_map := l_map || '<' || to_char( l_used, 'FM0XXX' )
               || '> <' || to_char( l_used_glyphs( l_used ) - l_remap_symbol, 'FM0XXX' )
               || '>' || chr( 10 );
        if l_cnt = 99
        then
          l_cnt := 0;
          l_cmap := l_cmap || chr( 10 ) || '100 beginbfchar' || chr( 10 ) || l_map || 'endbfchar';
          l_map := '';
        else
          l_cnt := l_cnt + 1;
        end if;
        l_used := l_used_glyphs.next( l_used );
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
end' ) );   -- self + 5
    end;
    --
    if l_font.fontfile2 is not null
    then
      l_font_subset := subset_font( p_index );
      l_fontfile := add_stream( l_font_subset
                              , '/Length1 ' || dbms_lob.getlength( l_font_subset )
                              );  -- self + 6
      dbms_lob.freetemporary( l_font_subset );
    end if;
    --
    return l_self;
  end add_font;
  --
  function add_resources
  return number
  is
    l_ind   pls_integer;
    l_self  number(10);
    l_fonts tp_objects;
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
    txt2pdfdoc( '>>' || c_eol || 'endobj' );
    return l_self;
  end add_resources;
  --
  procedure add_page
    ( p_page_ind pls_integer
    , p_parent number
    , p_resources number
    )
  is
    l_content number(10);
    l_tmp     tp_links;
    l_links   tp_pls_tab;
    l_annots  varchar2(32767);
  begin
    l_content := add_stream( g_pdf.pages( p_page_ind ).content, p_compress => true );
    l_links := g_pdf.pages( p_page_ind ).links;
    if l_links.count > 0
    then
      l_tmp := g_pdf.links;
      for i in 1 .. l_links.count
      loop
        l_annots := l_annots || ' ' || l_tmp( l_links( i ) ).object_nr || ' 0 R';
      end loop;
      l_annots := ' /Annots [' || l_annots || '] ';
    end if;
    add_object;
    txt2pdfdoc( '<</Type/Page'
              || '/Parent ' || to_char( p_parent ) || ' 0 R'
              ||  '/Contents ' || to_char( l_content ) || ' 0 R'
              ||  '/Resources ' || to_char( p_resources ) || ' 0 R'
              ||  '/Group<</Type/Group/S/Transparency/CS/DeviceRGB>>'
              ||  '/MediaBox [0 0 '
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
  end;
  --
  function add_pages
  return number
  is
    l_self      number(10);
    l_resources number(10);
    l_page_cnt  pls_integer := g_pdf.pages.count;
  begin
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
  procedure add_links
  is
    l_link tp_link;
  begin
    for i in 1 .. g_pdf.links.count
    loop
      l_link := g_pdf.links( i );
      g_pdf.links( i ).object_nr := add_object
        ( '/Type/Annot /Subtype/Link /Border[0 0  0] /Rect [ ' ||
          to_char_round( l_link.lt_x ) || ' ' ||  to_char_round( l_link.lt_y ) || ' ' ||
          to_char_round( l_link.rb_x ) || ' ' ||  to_char_round( l_link.rb_y ) ||
          ' ] /A<</S/URI/URI (' || l_link.url || ') >>' || c_eol
        );
    end loop;
  end add_links;
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
                    , p_unit             varchar2 := 'cm'
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
                , g_pdf.page_settings
                );
    g_pdf.pdf_version := 1.4;
    g_pdf.line_height_factor := 1;
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
        g_pdf.current_page := j - 1;
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
                  );
            when 3
            then
              declare
                l_steps tp_numbers;
              begin
                l_steps := tp_numbers();
                l_steps.extend( l_page_proc.nums.count - 1 );
                for i in 1 .. l_page_proc.nums.count - 1
                loop
                  l_steps( i ) := l_page_proc.nums( i + 1 );
                end loop;
                path( l_steps
                    , l_page_proc.nums( 1 )
                    , l_page_proc.chars( 1 )
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
                        );
            when 12
            then
              link( replace(
                    replace( case when l_page_proc.nchar is not null
                               then l_page_proc.nchar
                               else l_page_proc.chars( 3 )
                             end
                           , '#PAGE_NR#', j )
                           , '"PAGE_COUNT#', g_pdf.pages.count )
                  , l_page_proc.chars( 1 )
                  , l_page_proc.nums( 1 )
                  , l_page_proc.nums( 2 )
                  , l_page_proc.nums( 3 )
                  , l_page_proc.nums( 4 )
                  , l_page_proc.chars( 2 )
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
    add_links;
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
  function rgb( p_hex varchar2 )
  return varchar2
  is
  begin
    return to_char_round( nvl( to_number( substr( p_hex, 1, 2 ), 'xx' ) / 255
                             , 0 ), 5 ) || ' '
        || to_char_round( nvl( to_number( substr( p_hex, 3, 2 ), 'xx' ) / 255
                             , 0 ), 5 ) || ' '
        || to_char_round( nvl( to_number( substr( p_hex, 5, 2 ), 'xx' ) / 255
                             , 0 ), 5 ) || ' ';
  end rgb;
  --
  function rgb( p_color varchar2 )
  return varchar2
  is
  begin
    if g_color_names.exists( lower( p_color ) )
    then
      return rgb( p_hex => g_color_names( lower( p_color ) ) );
    else
      return rgb( p_hex => ltrim( p_color, '#' ) );
    end if;
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
    txt2page( 'q ' || to_char_round( coalesce( p_line_width, 0.5 ), 5 ) || ' w' );
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
    txt2page( 'q ' || to_char_round( coalesce( p_line_width, 0.5 ), 5 ) || ' w' );
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
  procedure line
    ( p_x1         number
    , p_y1         number
    , p_x2         number
    , p_y2         number
    , p_line_width number      := null
    , p_line_color varchar2    := null
    , p_page_proc  pls_integer := null
    )
  is
  begin
    if p_page_proc is null
    then
      graphics_init_and_set_line( p_line_width, p_line_color );
      txt2page(  to_char_round( p_x1, 5 ) || ' '
              || to_char_round( p_y1, 5 ) || ' m '
              || to_char_round( p_x2, 5 ) || ' '
              || to_char_round( p_y2, 5 ) || ' l b'
              || ' Q'
              );
    else
      add_page_proc( 1, p_page_proc
                   , p_nums  => tp_numbers( p_x1, p_y1, p_x2, p_y2, p_line_width )
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
    , p_page_proc  pls_integer := null
    )
  is
  begin
    line( p_x, p_y, p_x, p_y + p_height, p_line_width, p_line_color, p_page_proc );
  end vertical_line;
  --
  procedure rect
    ( p_x          number
    , p_y          number
    , p_width      number
    , p_height     number
    , p_line_color varchar2    := null
    , p_fill_color varchar2    := null
    , p_line_width number      := null
    , p_page_proc  pls_integer := null
    )
  is
  begin
    if p_page_proc is null
    then
      graphics_init_and_fill( p_line_width, p_fill_color, p_line_color );
      txt2page(  to_char_round( p_x, 5 ) || ' ' || to_char_round( p_y, 5 ) || ' '
              || to_char_round( p_width, 5 ) || ' ' || to_char_round( p_height, 5 ) || ' re '
              || 'b Q'
              );
    else
      add_page_proc( 2, p_page_proc
                   , p_nums  => tp_numbers( p_x, p_y, p_width, p_height, p_line_width )
                   , p_chars => tp_varchar2s( p_fill_color, p_line_color )
                   );
    end if;
  end rect;
  --
  procedure path
    ( p_steps      tp_numbers
    , p_line_width number      := null
    , p_line_color varchar2    := null
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
      l_nums.extend( p_steps.count + 1 );
      l_nums( 1 ) := p_line_width;
      for i in 1 .. p_steps.count
      loop
        l_nums( i + 1 ) := p_steps( i );
      end loop;
      add_page_proc( 3, p_page_proc
                   , p_nums  => l_nums
                   , p_chars => tp_varchar2s( p_line_color )
                   );
    end if;
  end path;
  --
  procedure bezier
    ( p_x1         in number
    , p_y1         in number
    , p_x2         in number
    , p_y2         in number
    , p_x3         in number
    , p_y3         in number
    , p_x4         in number
    , p_y4         in number
    , p_line_width in number   := null
    , p_line_color in varchar2 := null
    , p_page_proc  pls_integer := null
    )
  is
  begin
    if p_page_proc is null
    then
      graphics_init_and_set_line( p_line_width, p_line_color );
      txt2page( to_char_round( p_x1, 5 ) || ' ' || to_char_round( p_y1, 5 )
              || ' m '
              || to_char_round( p_x2, 5 ) || ' ' || to_char_round( p_y2, 5 ) || ' '
              || to_char_round( p_x3, 5 ) || ' ' || to_char_round( p_y3, 5 ) || ' '
              || to_char_round( p_x4, 5 ) || ' ' || to_char_round( p_y4, 5 )
              || ' c S Q'
              );
    else
      add_page_proc( 4, p_page_proc
                   , p_nums  => tp_numbers( p_x1, p_y1, p_x2, p_y2, p_x3, p_y3, p_x4, p_y4, p_line_width )
                   , p_chars => tp_varchar2s( p_line_color )
                   );
    end if;
  end bezier;
  --
  procedure bezier_v
    ( p_x1         in number
    , p_y1         in number
    , p_x2         in number
    , p_y2         in number
    , p_x3         in number
    , p_y3         in number
    , p_line_width in number   := null
    , p_line_color in varchar2 := null
    , p_page_proc  pls_integer := null
    )
  is
  begin
    if p_page_proc is null
    then
      graphics_init_and_set_line( p_line_width, p_line_color );
      txt2page( to_char_round( p_x1, 5 ) || ' ' || to_char_round( p_y1, 5 )
              || ' m '
              || to_char_round( p_x2, 5 ) || ' ' || to_char_round( p_y2, 5 ) || ' '
              || to_char_round( p_x3, 5 ) || ' ' || to_char_round( p_y3, 5 ) || ' '
              || ' v S Q'
              );
    else
      add_page_proc( 5, p_page_proc
                   , p_nums  => tp_numbers( p_x1, p_y1, p_x2, p_y2, p_x3, p_y3, p_line_width )
                   , p_chars => tp_varchar2s( p_line_color )
                   );
    end if;
  end bezier_v;
  --
  procedure bezier_y
    ( p_x1         in number
    , p_y1         in number
    , p_x2         in number
    , p_y2         in number
    , p_x3         in number
    , p_y3         in number
    , p_line_width in number   := null
    , p_line_color in varchar2 := null
    , p_page_proc  pls_integer := null
    )
  is
  begin
    if p_page_proc is null
    then
      graphics_init_and_set_line( p_line_width, p_line_color );
      txt2page( to_char_round( p_x1, 5 ) || ' ' || to_char_round( p_y1, 5 )
              || ' m '
              || to_char_round( p_x2, 5 ) || ' ' || to_char_round( p_y2, 5 ) || ' '
              || to_char_round( p_x3, 5 ) || ' ' || to_char_round( p_y3, 5 ) || ' '
              || ' y S Q'
              );
    else
      add_page_proc( 6, p_page_proc
                   , p_nums  => tp_numbers( p_x1, p_y1, p_x2, p_y2, p_x3, p_y3, p_line_width )
                   , p_chars => tp_varchar2s( p_line_color )
                   );
    end if;
  end bezier_y;
  --
  procedure circle
    ( p_x          in number
    , p_y          in number
    , p_radius     in number
    , p_line_color in varchar2 := null
    , p_fill_color in varchar2 := null
    , p_line_width in number   := null
    , p_page_proc  pls_integer := null
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
              || 'b Q'
              );
    else
      add_page_proc( 8, p_page_proc
                   , p_nums  => tp_numbers( p_x, p_y, p_major_radius, p_minor_radius, p_line_width, p_degrees_rotation )
                   , p_chars => tp_varchar2s( p_line_color, p_fill_color )
                   );
    end if;
  end ellips;
  --
  function get( p_what pls_integer )
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
        if l_hex = 'FFC0' -- SOF0 (Start Of Frame 0) marker
        then
          l_hex := rawtohex( dbms_lob.substr( p_img, 5, l_ind + 4 ) );
          l_img.color_res := to_number( substr( l_hex, 1, 2 ), 'xx' );
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
    l_compression   := to_number( utl_raw.substr( l_buf, 31, 1 ), 'XX' );
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
  function parse_img
    ( p_blob  in blob
    , p_crc32 in varchar2 := null
    , p_type  in varchar2 := null
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
      l_img.crc32 := coalesce( p_crc32, utl_raw.substr( utl_compress.lz_compress( p_blob ), -8, 4 ) );
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
    if p_img is null
    then
      return null;
    end if;
    l_crc32 := utl_raw.substr( utl_compress.lz_compress( p_img ), -8, 4 );
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
  procedure put_image
    ( p_img_idx   pls_integer
    , p_x         number               -- left
    , p_y         number               -- bottom
    , p_width     number      := null
    , p_height    number      := null
    , p_align     varchar2    := null
    , p_valign    varchar2    := null
    , p_page_proc pls_integer := null
    )
  is
    l_x      number;
    l_y      number;
    l_width  number;
    l_height number;
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
      if l_img.width > p_width
      then
        l_width := p_width;
        l_height := l_img.height * p_width / l_img.width;
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
      l_x := case substr( upper( p_align ), 1, 1 )
               when 'L' then p_x -- left
               when 'S' then p_x -- start
               when 'R' then p_x + nvl( p_width, 0 ) - l_width -- right
               when 'E' then p_x + nvl( p_width, 0 ) - l_width -- end
               else p_x + ( nvl( p_width, 0 ) - l_width ) / 2  -- center
             end;
      l_y := case substr( upper( p_valign ), 1, 1 )
               when 'C' then p_y - nvl( p_height, l_height ) + l_height / 2 -- center
               when 'T' then p_y  - l_height                             -- top
               else p_y                                                  -- bottom
             end;
      --
      txt2page(  'q '
              || to_char_round( 1 ) || ' 0 0 ' || to_char_round( 1 ) || ' ' || to_char_round( l_x ) || ' ' || to_char_round( l_y ) || ' cm '
              || to_char_round( l_width ) || ' 0 0 ' || to_char_round( l_height ) || ' 0 0 cm '
              || ' /I' || to_char( p_img_idx ) || ' Do Q'
              );
    else
      add_page_proc( 9, p_page_proc
                   , p_nums  => tp_numbers( p_img_idx, p_x, p_y, p_width, p_height )
                   , p_chars => tp_varchar2s( p_align, p_valign )
                   );
    end if;
  end put_image;
  --
  procedure put_image
    ( p_img    blob
    , p_x         number               -- left
    , p_y         number               -- bottom
    , p_width     number      := null
    , p_height    number      := null
    , p_align     varchar2    := null
    , p_valign    varchar2    := null
  )
  is
  begin
    if p_img is null
    then
      return;
    end if;
    put_image( load_image( p_img )
             , p_x
             , p_y
             , p_width
             , p_height
             , p_align
             , p_valign
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
  )
  is
    l_blob blob;
  begin
    l_blob := file2blob( p_dir
                       , p_file_name
                       );
    put_image( l_blob
             , p_x
             , p_y
             , p_width
             , p_height
             , p_align
             , p_valign
             );
    dbms_lob.freetemporary( l_blob );
  end put_image;
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
    raise_application_error( -20026, 'utl_file not available. Change the package header, set as_pdf.use_utl_file := true; when you have access to utl_file.' );
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
    p_cfh.utf8 := bitand( to_number( utl_raw.substr( l_buf, 10, 1 ), 'XX' ), 8 ) > 0;
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
    ( p_font   blob
    , p_embed  boolean
    , p_offset number
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
    l_max   integer;
    l_tmp   integer;
    l_start integer;
    --
    function substr2num( p_idx pls_integer )
    return integer
    is
    begin
      return to_number( substr( l_buf, p_idx, 4 ), 'XXXX' );
    end;
    --
    function substr2snum( p_idx pls_integer )
    return integer
    is
      l_tmp integer := substr2num( p_idx );
    begin
      return case when l_tmp > 32767 then l_tmp - 65536 else l_tmp end;
    end;
  begin
    l_buf := dbms_lob.substr( p_font, 4096, p_offset );
    if substr( l_buf, 1, 8 ) = '74746366' -- ttcf
    then
      for i in 0 .. to_number( substr( l_buf, 17, 8 ), 'XXXXXXXX' ) - 1
      loop
        l_idx := load_font( p_font, p_embed, to_number( dbms_lob.substr( p_font, 4, 13 + i * 4 ), 'XXXXXXXX' ) + 1 );
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
          l_idx := load_font( parse_file( p_font, l_cfh ), p_embed, 1 );
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
    l_font.numGlyphs := blob2num( p_font, 2, 4 + l_tables( 'maxp' ).offset );
    --
    declare
      l_glyph           pls_integer;
      l_offset          integer;
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
      l_buf := dbms_lob.substr( p_font, 16000, l_tables( 'cmap' ).offset );
      for i in 0 .. substr2num( 5 ) - 1
      loop
        continue when substr( l_buf, 9  + i * 16, 4 ) != '0003' -- Platform ID = Windows
                   or substr( l_buf, 13 + i * 16, 4 ) not in ( '0000' -- Symbol
                                                             , '0001' -- Unicode BMP (UCS-2)
                                                             ); -- encodingID
        if substr( l_buf, 13 + i * 16, 4 ) = '0000'
        then
          l_font.flags := 4;  -- symbolic
        else
          l_font.flags := 32; -- non-symbolic
        end if;
        l_offset := l_tables( 'cmap' ).offset
                  + to_number( substr( l_buf, 17 + i * 16, 8 ), 'XXXXXXXX' );
        l_buf := dbms_lob.substr( p_font, 16, l_offset );
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
              l_font.code2glyph( c ) := bitand( c + l_tmp, 65535 );
            end loop;
          else
            l_start := l_start_code( j );
            l_tmp := l_tmp  + 2 * ( j - l_cnt );
            l_buf := dbms_lob.substr( p_font, 2 + 2 * ( l_end_code( j ) - l_start ), l_offset + 16 + l_cnt * 8 + l_tmp );
            for c in l_start .. l_end_code( j )
            loop
              l_font.code2glyph( c ) := substr2num( 1 + ( c - l_start ) * 4 );
            end loop;
          end if;
        end loop;
        exit;
      end loop;
      --
      l_glyph := l_font.code2glyph.first;
      while l_glyph is not null
      loop
--dbms_output.put_line( l_glyph || ' ' || to_char( l_glyph, 'fm0XXX' ) || ' ' || l_font.code2glyph( l_glyph ) );
         if l_font.code2glyph( l_glyph ) = 0
         then
           l_font.notdef := l_glyph;
           exit;
         end if;
         l_glyph := l_font.code2glyph.next( l_glyph );
      end loop;
    end;
    --
    l_buf := dbms_lob.substr( p_font, 34, l_tables( 'post' ).offset );
    l_font.italic_angle := substr2snum( 9 ) + substr2snum( 13 ) / 16384;
    if substr( l_buf, 25, 8 ) != '00000000'
    then
      l_font.flags := l_font.flags + 1; -- fixed pitch
    end if;
    --
    l_buf := dbms_lob.substr( p_font, 52, l_tables( 'head' ).offset );
    if substr( l_buf, 25, 8 ) = '5F0F3CF5'  -- magic
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
      l_font.unit_norm := 1000 / substr2num( 37 );
      l_font.bb_xmin := substr2snum( 73 ) * l_font.unit_norm;
      l_font.bb_ymin := substr2snum( 77 ) * l_font.unit_norm;
      l_font.bb_xmax := substr2snum( 81 ) * l_font.unit_norm;
      l_font.bb_ymax := substr2snum( 85 ) * l_font.unit_norm;
      l_font.indexToLocFormat := 2 * ( substr2num( 101 ) + 1 ); -- 0 for short offsets, 1 for long => size in bytes
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
        exit hmetric_loop when j + 4000 * i >= l_tmp;
        l_font.hmetrics( j + 4000 * i ) := substr2num( 1 + 8 * j ); -- only advance width, skip
      end loop;
    end loop;
    --
    l_buf := dbms_lob.substr( p_font, l_tables( 'name' ).length, l_tables( 'name' ).offset );
    if substr( l_buf, 1, 4 ) = '0000' -- format 0
    then
      l_start := 1 + 2 * substr2num( 9 );
      for i in 0 .. substr2num( 5 ) - 1
      loop
        if (   substr( l_buf, 13 + i * 24, 4 ) = '0003' -- Windows
           and substr( l_buf, 21 + i * 24, 4 ) = '0409' -- English United States
           )
        then
          case substr( l_buf, 25 + i * 24, 4 )
            when '0001'
            then
              l_font.family := utl_i18n.raw_to_char( substr( l_buf, l_start + 2 * substr2num( 33 + i * 24 ), 2 * substr2num( 29 + i * 24 ) ), 'AL16UTF16' );
            when '0006'
            then
              l_font.name := utl_i18n.raw_to_char( substr( l_buf, l_start + 2 * substr2num( 33 + i * 24 ), 2 * substr2num( 29 + i * 24 ) ), 'AL16UTF16' );
            else
              null;
          end case;
        end if;
      end loop;
else
dbms_output.put_line( '********************* name *********** ' || substr( l_buf, 1, 4 ) );
    end if;
    l_font.name   := coalesce( l_font.name,   'unknown' );
    l_font.family := coalesce( l_font.family, 'unknown' );
    --
    l_font.stemv := 50;
    l_font.family := lower( l_font.family );
    l_font.fontname := l_font.name;
    --
    if l_tables.exists( 'OS/2' )
    then
      l_buf := dbms_lob.substr( p_font, 90, l_tables( 'OS/2' ).offset );
      l_font.ascent  := substr2snum( 137 ) * l_font.unit_norm;
      l_font.descent := substr2snum( 141 ) * l_font.unit_norm;
      l_font.linegap := substr2snum( 145 ) * l_font.unit_norm;
-- ascent - descent = 1000
-- 1000 + linegap => next line
      if substr2num( 11 ) > 1
      then
        l_font.capheight := substr2snum( 177 );
      else
        l_font.capheight := l_font.ascent;
      end if;
      --
      if     p_embed
         and substr( l_buf, 19, 2 ) != '02' -- Restricted License embedding
      then
        l_font.fontfile2 := p_font;
        l_font.ttf_offset := p_offset;
        l_font.subset := dbms_lob.substr( p_font, 1, l_tables( 'OS/2' ).offset + 8 ) = hextoraw( '00' );
        l_font.name := dbms_random.string( 'u', 6 ) || '+' || l_font.name;
      end if;
    end if;
    --
--dbms_output.put_line( l_font.fontname
-- || ' numGlyphs: ' || l_font.numGlyphs
-- || ', post ' || dbms_lob.substr( p_font, 4, l_tables( 'post' ).offset )
-- || case when bitand( l_font.flags, 4 ) > 0 then ', symbolic' end
-- || case when l_font.fontfile2 is null then ', not embedded' end );
--dbms_output.put_line( dbms_lob.substr( p_font, 200, l_tables( 'CFF ' ).offset ) );
    g_pdf.fonts( g_pdf.fonts.count + 1 ) := l_font;
    return g_pdf.fonts.count;
  end load_font;
  --
  function load_font
    ( p_font  blob
    , p_embed boolean := true
    )
  return pls_integer
  is
  begin
    return load_font( p_font     => p_font
                    , p_embed    => p_embed
                    , p_offset   => 1
                    );
  end load_font;
  --
  function load_font
    ( p_dir      varchar2
    , p_filename varchar2
    , p_embed    boolean := true
    )
  return pls_integer
  is
  begin
    return load_font( p_font     => file2blob( p_dir, p_filename )
                    , p_embed    => p_embed
                    , p_offset   => 1
                    );
  end load_font;
  --
  procedure load_font
    ( p_font     blob
    , p_embed    boolean := true
    )
  is
    l_idx pls_integer;
  begin
    l_idx := load_font( p_font     => p_font
                      , p_embed    => p_embed
                      );
  end load_font;
  --
  procedure load_font
    ( p_dir      varchar2
    , p_filename varchar2
    , p_embed    boolean := true
    )
  is
  begin
    load_font( p_font     => file2blob( p_dir, p_filename )
             , p_embed    => p_embed
             );
  end load_font;
  --
  function pdf_string( p_txt in blob )
  return blob
  is
    l_rv  blob := p_txt;
    l_ind integer;
    c_back_slash        constant raw(1) := hextoraw( '5C' ); -- \
    c_left_parenthesis  constant raw(1) := hextoraw( '29' ); -- (
    c_right_parenthesis constant raw(1) := hextoraw( '28' ); -- )
    c_line_feed         constant raw(1) := hextoraw( '0A' ); -- \n
    c_horizontal_tab    constant raw(1) := hextoraw( '09' ); -- \t
    c_carriage_return   constant raw(1) := hextoraw( '0D' ); -- \r
    c_n                 constant raw(1) := hextoraw( '6E' ); -- n
    c_r                 constant raw(1) := hextoraw( '72' ); -- t
    c_t                 constant raw(1) := hextoraw( '74' ); -- r
    --
    procedure pdf_esc( p_what raw, p_to raw )
    is
    begin
      l_ind := -1;
      loop
        l_ind := dbms_lob.instr( l_rv, p_what, l_ind + 2 );
        exit when l_ind <= 0;
        dbms_lob.copy( l_rv
                     , l_rv
                     , dbms_lob.lobmaxsize
                     , l_ind + 2
                     , l_ind + 1
                     );
        dbms_lob.copy( l_rv
                     , utl_raw.concat( c_back_slash, p_to )
                     , 2
                     , l_ind
                     , 1
                     );
      end loop;
    end pdf_esc;
  begin
    pdf_esc( c_back_slash,        c_back_slash );
    pdf_esc( c_left_parenthesis,  c_left_parenthesis );
    pdf_esc( c_right_parenthesis, c_right_parenthesis );
    pdf_esc( c_carriage_return,   c_r );
    pdf_esc( c_line_feed,         c_n );
    pdf_esc( c_horizontal_tab,    c_t );
    return l_rv;
  end pdf_string;
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
    else
      return utl_raw.convert( utl_raw.cast_to_raw( p_txt ), p_target, c_db_charset );
    end if;
  exception
    when value_error then
      return utl_i18n.string_to_raw( p_txt, p_target );
  end string2raw;
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
  function str_len
    ( p_txt        varchar2 character set any_cs
    , p_font_index pls_integer := null
    , p_fontsize   number      := null
    )
  return number
  is
    l_len          pls_integer;
    l_code         pls_integer;
    l_remap_symbol pls_integer;
    l_tmp          raw(32767);
    l_buf          varchar2(32767);
    l_last         number;
    l_width        number;
    l_font         tp_font;
  begin
    if    p_txt is null
       or not g_pdf.fonts.exists( coalesce( p_font_index, g_pdf.current_font ) )
    then
      return 0;
    end if;
    l_width := 0;
    l_font := g_pdf.fonts( coalesce( p_font_index, g_pdf.current_font ) );
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
          l_code := to_number( substr( l_tmp, 2 * i - 1, 2 ), 'XX' );
        else
          l_code := to_number( utl_raw.substr( l_tmp, i, 1 ), 'XX' );
        end if;
        if l_font.char_width_tab.exists( l_code )
        then
          l_width := l_width + l_font.char_width_tab( l_code );
        end if;
      end loop;
    else
      if bitand( l_font.flags, 4 ) > 0 and l_font.numGlyphs < 256
      then
        -- assume code 32, space maps to the first code from the font
        l_remap_symbol := l_font.code2glyph.first - 32;
      else
        l_remap_symbol := 0;
      end if;
      l_last := l_font.hmetrics( l_font.hmetrics.last );
      l_tmp := string2raw( p_txt, 'AL16UTF16' );
      for i in 1 .. length( p_txt )
      loop
        l_code := to_number( utl_raw.substr( l_tmp, i * 2 - 1,  2 ), '0XXX' ) + l_remap_symbol;
        if     l_font.code2glyph.exists( l_code )
           and l_font.hmetrics.exists( l_font.code2glyph( l_code ) )
        then
          l_width := l_width + l_font.hmetrics( l_font.code2glyph( l_code ) );
        else
          l_width := l_width + l_last;
        end if;
      end loop;
      l_width := l_width * l_font.unit_norm;
    end if;
    return l_width * coalesce( p_fontsize, l_font.fontsize, c_default_fontsize ) / 1000;
  end str_len;
  --
  function txt2raw
    ( p_txt        varchar2 character set any_cs
    , p_font_index pls_integer := null
    )
  return raw
  is
    l_rv           raw(32767);
    l_tmp          raw(32767);
    l_notdef       raw(4);
    l_glyph        pls_integer;
    l_unicode      pls_integer;
    l_font_index   pls_integer;
    l_remap_symbol pls_integer;
    l_font         tp_font;
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
      return utl_raw.concat( utl_raw.cast_to_raw( '(' )
                           , pdf_string( string2raw( replace(
                                                     replace(
                                                     replace( p_txt
                                                            , chr(9), rpad( ' ', c_tab_spaces ) )
                                                            , chr(10) )
                                                            , chr(13) )
                                                   , 'WE8MSWIN1252'
                                                   )
                                       )
                           , utl_raw.cast_to_raw( ')' )
                           );
    end if;
    --
    l_notdef := utl_raw.cast_to_raw( coalesce( to_char( l_font.notdef, 'fm0XXX' ), 'FFFF' ) );
    if bitand( l_font.flags, 4 ) > 0 and l_font.numGlyphs < 256
    then
      -- assume code 32, space maps to the first code from the font
      l_remap_symbol := l_font.code2glyph.first - 32;
    else
      l_remap_symbol := 0;
    end if;
    l_tmp := string2raw( p_txt, 'AL16UTF16' );
    for i in 1 .. length( p_txt )
    loop
      l_unicode := to_number( utl_raw.substr( l_tmp, i * 2 - 1,  2 ), '0XXX' ) + l_remap_symbol;
      if l_font.code2glyph.exists( l_unicode )
      then
        l_glyph := l_font.code2glyph( l_unicode );
        g_pdf.fonts( l_font_index ).used_glyphs( l_glyph ) := l_unicode;
        l_rv := utl_raw.concat( l_rv
                              , utl_raw.cast_to_raw( to_char( l_glyph, 'FM0XXX' ) )
                              );
      else
        l_rv := utl_raw.concat( l_rv, l_notdef );
      end if;
    end loop;
    return utl_raw.concat( utl_raw.cast_to_raw( '<' )
                         , l_rv
                         , utl_raw.cast_to_raw( '>' )
                         );
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
    l_chg boolean;
    l_tmp varchar2(1000);
  begin
    if (   p_font_index is not null
       and p_font_index != coalesce( g_pdf.pages( g_pdf.current_page ).font_index, p_font_index )
       and g_pdf.fonts.exists( p_font_index )
       )
       or
       (   p_fontsize is not null
       and p_fontsize != g_pdf.pages( g_pdf.current_page ).fontsize
       )
    then
      l_chg := true;
      font2page( p_font_index, p_fontsize );
    end if;
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
    if l_chg
    then
      font2page;
    end if;
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
  procedure put_txt
    ( p_x                number
    , p_y                number
    , p_txt              varchar2 character set any_cs
    , p_degrees_rotation number      := null
    , p_font_index       pls_integer := null
    , p_fontsize         number      := null
    , p_color            varchar2    := null
    , p_page_proc        pls_integer := null
    )
  is
  begin
    if p_txt is not null
    then
      if p_page_proc is null
      then
        g_pdf.fonts_used := true;
        put_raw( p_x, p_y
               , txt2raw( p_txt, p_font_index )
               , p_degrees_rotation
               , p_font_index
               , p_fontsize
               , p_color
               );
      else
        add_page_proc( 10, p_page_proc
                     , p_nums  => tp_numbers( p_x, p_y, p_degrees_rotation, p_font_index, p_fontsize )
                     , p_chars => tp_varchar2s( p_color, p_txt )
                     , p_nchar => case when isnchar( p_txt ) then p_txt end
                     );
      end if;
    end if;
  end put_txt;
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
    , p_color             varchar2
    , p_align             varchar2
    , p_dry_run           boolean
    , p_new_x      in out number
    , p_new_y      in out number
    , p_lines      in out pls_integer
    , p_page_break in out boolean
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
      wti( p_txt, p_x, p_y, p_xmin, p_xmax, p_ymin, p_ymax, p_font_index, p_fontsize, p_color, p_align, p_dry_run, p_new_x, p_new_y, p_lines, p_page_break );
    end;
    --
    procedure line_break( p_p2 varchar2 character set any_cs )
    is
      l_settings tp_settings;
    begin
      p_new_y := p_new_y - p_fontsize;
      p_lines := coalesce( p_lines, 1 ) + 1;
      if p_new_y < p_ymin
      then
        p_page_break := true;
        if not p_dry_run
        then
          l_settings := g_pdf.pages( g_pdf.current_page ).settings;
          new_page;
          g_pdf.pages( g_pdf.current_page ).settings := l_settings;
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
            put_txt( p_xmax - l_len, p_y, p_txt, null, p_font_index, p_fontsize, p_color );
          when 'c' then
            put_txt( ( p_x + p_xmax - l_len ) / 2, p_y, p_txt, null, p_font_index, p_fontsize, p_color );
          else
            put_txt( p_x, p_y, p_txt, null, p_font_index, p_fontsize, p_color );
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
    )
  is
    l_fontsize   number;
    l_page_break boolean;
    l_lines      pls_integer;
    l_font_index pls_integer;
    l_settings   tp_settings;
  begin
    l_font_index := gfi( p_font_index );
    l_fontsize := coalesce( p_fontsize, g_pdf.fonts( l_font_index ).fontsize );
    if g_pdf.current_page is null
    then
      new_page;
    end if;
    l_settings := g_pdf.pages( g_pdf.current_page ).settings;
    if p_txt is null
    then
      g_pdf.x := coalesce( p_x, g_pdf.x, l_settings.margin_left );
      g_pdf.y := coalesce( p_y, g_pdf.y, l_settings.page_height - l_settings.margin_top - l_fontsize );
    else
      wti( replace( p_txt, chr(9), rpad( ' ', c_tab_spaces ) )
         , coalesce( p_x, g_pdf.x, l_settings.margin_left )
         , coalesce( p_y, g_pdf.y, l_settings.page_height - l_settings.margin_top - l_fontsize )
         , l_settings.margin_left, l_settings.page_width - l_settings.margin_left
         , l_settings.margin_bottom, l_settings.page_height - l_settings.margin_top - l_fontsize
         , l_font_index, l_fontsize, p_color, null
         , false, g_pdf.x, g_pdf.y, l_lines, l_page_break
         );
    end if;
  exception
    when e_no_fit then
      raise_application_error( -20023, 'Text "'|| p_txt || '" does not fit in allowed space (' || to_char_round( l_settings.page_width - l_settings.margin_left, 0 ) || ').' );
  end write_txt;
  --
  procedure link_int
    ( p_url varchar2
    , p_x1  number
    , p_y1  number
    , p_x2  number
    , p_y2  number
    )
  is
    l_link tp_link;
    l_idx  pls_integer;
  begin
    l_idx := g_pdf.links.count + 1;
    l_link.url  := p_url;
    l_link.lt_x := p_x1;
    l_link.lt_y := p_y1;
    l_link.rb_x := p_x2;
    l_link.rb_y := p_y2;
    g_pdf.links( l_idx ) := l_link;
    g_pdf.pages( g_pdf.current_page ).links( g_pdf.pages( g_pdf.current_page ).links.count + 1 ) := l_idx;
  end link_int;
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
    l_font       tp_font;
    l_top        number;
    l_fontsize   number;
    l_font_index pls_integer;
  begin
    if p_txt is null or p_url is null
    then
      return;
    end if;
    if p_page_proc is null
    then
      l_font_index := gfi( p_font_index );
      l_font := g_pdf.fonts( l_font_index );
      l_fontsize := coalesce( p_fontsize, l_font.fontsize, c_default_fontsize );
      l_top := ( 0.5 * l_font.linegap + l_font.ascent ) * l_fontsize / 1000;
      put_txt( p_x, p_y, p_txt, null, l_font_index, p_fontsize, p_color );
      link_int( p_url, p_x, p_y + l_top
              , p_x + str_len( p_txt || '  ', l_font_index, l_fontsize )
              , p_y + l_top - l_fontsize
              );
    else
      add_page_proc( 12, p_page_proc
                   , p_nums  => tp_numbers( p_x, p_y, p_font_index, p_fontsize )
                   , p_chars => tp_varchar2s( p_url, p_color, p_txt )
                   , p_nchar => case when isnchar( p_txt ) then p_txt end
                   );
    end if;
  end link;
  --
  procedure fill_with_borders
    ( p_x1 number
    , p_y1 number
    , p_x2 number
    , p_y2 number
    , p_widths tp_num_tab
    , p_odd_color  varchar2
    , p_even_color varchar2
    , p_line_color varchar2
    , p_line_width number
    )
  is
    l_tmp_x number;
  begin
    if p_odd_color is not null
    then
      rect( p_x1, p_y1, p_x2 - p_x1, p_y2 - p_y1
          , case when p_line_width = 0 then p_odd_color else p_line_color end
          , p_odd_color, p_line_width
          );
    end if;
    if p_even_color is not null
    then
      rect( p_x1, p_y1, p_x2 - p_x1, p_y2 - p_y1
          , case when p_line_width = 0 then p_even_color else p_line_color end
          , p_even_color, p_line_width
          );
    end if;
    if coalesce( p_line_width, 1 ) > 0
    then
      path( tp_numbers( p_x1, p_y1, p_x2, p_y1, p_x2, p_y2, p_x1, p_y2, p_x1, p_y1 )
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
  procedure multi_cell
    ( p_txt        varchar2 character set any_cs
    , p_x          number
    , p_y          number
    , p_width      number      := null
    , p_padding    number      := null
    , p_font_index pls_integer := null
    , p_fontsize   number      := null
    , p_txt_color  varchar2    := null
    , p_fill_color varchar2    := null
    , p_line_color varchar2    := null
    , p_align      varchar2    := null
    , p_line_width number      := null
    , p_url        varchar2    := null
    , p_page_proc  pls_integer := null
    )
  is
    l_x          number;
    l_y          number;
    l_top        number;
    l_width      number;
    l_new_x      number;
    l_new_y      number;
    l_lpadding   number;
    l_rpadding   number;
    l_fontsize   number;
    l_page_break boolean;
    l_lines      pls_integer;
    l_font_index pls_integer;
    l_font       tp_font;
    l_widths tp_num_tab;
    l_settings   tp_settings;
  begin
    if p_page_proc is null
    then
      l_font_index := gfi( p_font_index );
      l_font := g_pdf.fonts( l_font_index );
      l_fontsize := coalesce( p_fontsize, l_font.fontsize );
      if g_pdf.current_page is null
      then
        new_page;
      end if;
      --
      if p_x is null
      then
        l_settings := g_pdf.pages( g_pdf.current_page ).settings;
        l_x := l_settings.margin_left;
      else
        l_x := p_x;
      end if;
      l_lpadding := coalesce( p_padding, str_len( ' ', l_font_index, l_fontsize ) );
      if p_width is null
      then
        if p_x is not null
        then
          l_settings := g_pdf.pages( g_pdf.current_page ).settings;
        end if;
        l_width := l_settings.page_width - l_settings.margin_right - l_x;
      else
        l_width := p_width;
      end if;
      l_rpadding := coalesce( p_padding, str_len( ' ', l_font_index, l_fontsize ) );
      wti( replace( p_txt, chr(9), rpad( ' ', c_tab_spaces ) )
         , l_x + l_lpadding
         , p_y
         , l_x + l_lpadding, l_x + l_width - l_rpadding
         , null, null
         , l_font_index, l_fontsize, p_txt_color, p_align
         , true, l_new_x, l_new_y, l_lines, l_page_break
         );
      l_top := ( 0.5 * l_font.linegap + l_font.ascent ) * l_fontsize / 1000;
      l_widths( 1 ) := l_width;
      fill_with_borders
        ( l_x, p_y + l_top
        , l_x + l_width, p_y + l_top - l_fontsize * coalesce( l_lines, 1 )
        , l_widths, p_fill_color, null, p_line_color, p_line_width
        );
      wti( replace( p_txt, chr(9), rpad( ' ', c_tab_spaces ) )
         , l_x + l_lpadding
         , p_y
         , l_x + l_lpadding, l_x + l_width - l_rpadding
         , null, null
         , l_font_index, l_fontsize, p_txt_color, p_align
         , false, l_new_x, l_new_y, l_lines, l_page_break
         );
      if p_url is not null
      then
        link_int( p_url, l_x, p_y + l_top, l_x + l_width, p_y + l_top - coalesce( l_lines, 1 ) * l_fontsize );
      end if;
    else
      add_page_proc( 11, p_page_proc
                   , p_nums  => tp_numbers( p_x, p_y, p_width, p_padding, p_font_index, p_fontsize, p_line_width )
                   , p_chars => tp_varchar2s( p_txt_color, p_fill_color, p_line_color, p_align, p_txt, p_url )
                   , p_nchar => case when isnchar( p_txt ) then p_txt end
                   );
    end if;
  exception
    when e_no_fit then
      raise_application_error( -20023, 'Text "'|| p_txt || '" does not fit in allowed space (' || to_char_round( l_width, 0 ) || ').' );
  end multi_cell;
  --
  procedure handle_widths
    ( p_widths   tp_numbers
    , p_cnt      pls_integer
    , p_x        number
    , p_settings tp_settings
    , p_out      in out tp_num_tab
    )
  is
    l_cnt   pls_integer;
    l_width number;
  begin
    p_out.delete;
    if p_widths is null or p_widths.count < p_cnt
    then
      l_width := p_settings.page_width - p_settings.margin_right - p_x;
      if p_widths is null
      then
        l_cnt := 0;
      else
        l_cnt := p_widths.count;
        for i in 1 .. l_cnt
        loop
          l_width := l_width - p_widths( i );
          p_out( i ) := p_widths( i );
        end loop;
      end if;
      l_width := l_width / ( p_cnt - l_cnt );
      for i in l_cnt + 1 .. p_cnt
      loop
        p_out( i ) := l_width;
      end loop;
    else
      for i in 1 .. p_cnt
      loop
        p_out( i ) := p_widths( i );
      end loop;
    end if;
  end handle_widths;
  --
  procedure table_row
    ( p_txt        tp_varchar2s
    , p_x          number
    , p_y          number
    , p_widths     tp_numbers  := null
    , p_padding    number      := null
    , p_font_index pls_integer := null
    , p_fontsize   number      := null
    , p_align      varchar2    := null
    , p_txt_color  varchar2    := null
    , p_fill_color varchar2    := null
    , p_line_color varchar2    := null
    , p_line_width number      := null
$IF dbms_db_version.ver_le_11
$THEN
    , p_fi         tp_pls_tab  := c_null_pls_tab
    , p_fs         tp_num_tab  := c_null_num_tab
    , p_al         tp_txt_tab  := c_null_txt_tab
    , p_tc         tp_txt_tab  := c_null_txt_tab
$ELSIF dbms_db_version.ver_le_12
$THEN
    , p_fi         tp_pls_tab  := c_null_pls_tab
    , p_fs         tp_num_tab  := c_null_num_tab
    , p_al         tp_txt_tab  := c_null_txt_tab
    , p_tc         tp_txt_tab  := c_null_txt_tab
$ELSE
    , p_fi         tp_pls_tab  := tp_pls_tab()
    , p_fs         tp_num_tab  := tp_num_tab()
    , p_al         tp_txt_tab  := tp_txt_tab()
    , p_tc         tp_txt_tab  := tp_txt_tab()
$END
    )
  is
    l_x          number;
    l_y          number;
    l_new_x      number;
    l_new_y      number;
    l_tmp_x      number;
    l_max_top    number;
    l_max_height number;
    l_padding    number;
    l_fontsize   number;
    l_page_break boolean;
    l_cnt        pls_integer;
    l_lines      pls_integer;
    l_font_index pls_integer;
    l_font       tp_font;
    l_fi         tp_pls_tab;
    l_fs         tp_num_tab;
    l_widths     tp_num_tab;
    l_settings   tp_settings;
  begin
    l_cnt := p_txt.count;
    l_font_index := gfi( p_font_index );
    l_font := g_pdf.fonts( l_font_index );
    l_fontsize := coalesce( p_fontsize, l_font.fontsize );
    l_padding := coalesce( p_padding, str_len( ' ', l_font_index, l_fontsize ) );
    if g_pdf.current_page is null
    then
      new_page;
    end if;
    --
    l_settings := g_pdf.pages( g_pdf.current_page ).settings;
    l_x := coalesce( p_x, l_settings.margin_left );
    handle_widths( p_widths, l_cnt, l_x, l_settings, l_widths );
    --
    l_new_x := l_x;
    l_max_top := ( 0.5 * l_font.linegap + l_font.ascent ) * l_fontsize / 1000;
    l_max_height := 0;
    for i in 1 .. l_cnt
    loop
      if p_fi.exists( i )
      then
        l_fi( i ) := p_fi( i );
      else
        l_fi( i ) := l_font_index;
      end if;
      if p_fs.exists( i )
      then
        l_fs( i ) := p_fs( i );
      else
        l_fs( i ) := l_fontsize;
      end if;
      if p_fi.exists( i ) or p_fs.exists( i )
      then
        l_max_top := greatest( l_max_top, ( 0.5 * l_font.linegap + l_font.ascent ) * l_fs( i ) / 1000 );
      end if;
      begin
        wti( replace( p_txt( i ), chr(9), rpad( ' ', c_tab_spaces ) )
           , l_new_x + l_padding
           , p_y
           , l_new_x + l_padding, l_new_x + l_widths( i ) - l_padding
           , null, null
           , l_fi( i ), l_fs( i ), null, null
           , true, l_tmp_x, l_new_y, l_lines, l_page_break
           );
      exception
        when e_no_fit then
          raise_application_error( -20023, 'Text "'|| p_txt( i ) || '" does not fit in allowed space (' || to_char_round( l_widths( i ), 0 ) || ').' );
      end;
      l_new_x := l_new_x + l_widths( i );
      l_max_height := greatest( l_max_height, l_fs( i ) * coalesce( l_lines, 1 ) );
    end loop;
    --
    fill_with_borders
      ( l_x, p_y + l_max_top
      , l_new_x, p_y + l_max_top - l_max_height
      , l_widths, p_fill_color, null, p_line_color, p_line_width
      );
    --
    l_new_x := l_x;
    for i in 1 .. l_cnt
    loop
      wti( replace( p_txt( i ), chr(9), rpad( ' ', c_tab_spaces ) )
         , l_new_x + l_padding
         , p_y
         , l_new_x + l_padding, l_new_x + l_widths( i ) - l_padding
         , null, null
         , l_fi( i ), l_fs( i )
         , case when p_tc.exists( i ) then p_tc( i ) else p_txt_color end
         , case when p_al.exists( i ) then p_al( i ) else p_align end
         , false, l_tmp_x, l_new_y, l_lines, l_page_break
         );
      l_new_x := l_new_x + l_widths( i );
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
    , p_header_fi     pls_integer
    , p_header_fs     number
    , p_header_txt_c  varchar2
    , p_header_color  varchar2
    , p_header_repeat boolean
    , p_txt_color     varchar2
    , p_odd_color     varchar2
    , p_even_color    varchar2
    , p_line_color    varchar2
    , p_line_width    number
    , p_fi            tp_pls_tab
    , p_fs            tp_num_tab
    , p_al            tp_txt_tab
    , p_fmt           tp_txt_tab
    )
  is
    l_y          number;
    l_tmp_x      number;
    l_tmp_y      number;
    l_start_x    number;
    l_padding    number;
    l_max_top    number;
    l_max_height number;
    l_line_width number;
    l_fontsize   number;
    l_page_break boolean;
    l_lines      pls_integer;
    l_idx        pls_integer;
    l_row_nr     pls_integer;
    l_font_index pls_integer;
    l_font       tp_font;
    l_settings   tp_settings;
    l_col_cnt    integer;
    l_desc_tab   dbms_sql.desc_tab2;
    l_b          blob;
    l_d          date;
    l_n          number;
    l_ts         timestamp;
    l_tsz        timestamp with time zone;
    l_tslz       timestamp with local time zone;
    l_r          raw(32767);
    l_v          varchar2(32767);
    l_nv         nvarchar2(32767);
    l_fi         tp_pls_tab;
    l_fs         tp_num_tab;
    l_widths     tp_num_tab;
    --
    procedure print_header
    is
      l_fi     pls_integer;
      l_fs     number;
      l_top    number;
      l_height number := 0;
      l_x      number := l_start_x;
    begin
      if p_headers is null or p_headers.count != l_col_cnt
      then
        return;
      end if;
      if p_header_fi is not null and g_pdf.fonts.exists( p_header_fi )
      then
        l_fi := p_header_fi;
      else
        l_fi := l_font_index;
      end if;
      l_fs := coalesce( p_header_fs, l_fontsize );
      l_font := g_pdf.fonts( l_fi );
      l_top := ( 0.5 * l_font.linegap + l_font.ascent ) * l_fs / 1000;
      --
      for i in 1 .. l_col_cnt
      loop
        wti( replace( p_headers( i ), chr(9), rpad( ' ', c_tab_spaces ) )
           , l_padding, l_y
           , l_padding, l_widths( i ) - l_padding
           , null, null
           , l_fi, l_fs, null, null
           , true, l_tmp_x, l_tmp_y, l_lines, l_page_break
           );
        l_height := greatest( l_height, l_fs * coalesce( l_lines, 1 ) );
      end loop;
      --
      fill_with_borders
        ( l_start_x, l_y + l_top
        , l_start_x + l_line_width, l_y + l_top - l_height
        , l_widths, p_header_color, null, p_line_color, p_line_width
        );
      --
      for i in 1 .. l_col_cnt
      loop
        begin
          wti( replace( p_headers( i ), chr(9), rpad( ' ', c_tab_spaces ) )
             , l_x + l_padding, l_y
             , l_x + l_padding, l_x + l_widths( i ) - l_padding
             , null, null
             , l_fi, l_fs
             , p_header_txt_c, null
             , false, l_tmp_x, l_tmp_y, l_lines, l_page_break
             );
        exception
          when e_no_fit then
            raise_application_error( -20023, 'Text "'|| p_headers( i ) || '" does not fit in allowed space (' || to_char_round( l_widths( i ), 0 ) || ').' );
        end;
        l_x := l_x + l_widths( i );
      end loop;
      l_y := l_y - l_height;
    end print_header;
    --
    procedure row_height_page_break
      ( p_txt varchar2 character set any_cs
      , p_idx pls_integer
      )
    is
    begin
      wti( replace( p_txt, chr(9), rpad( ' ', c_tab_spaces ) )
         , l_padding, l_y
         , l_padding, l_widths( p_idx ) - l_padding
         , null, null
         , l_fi( p_idx ), l_fs( p_idx ), null, null
         , true, l_tmp_x, l_tmp_y, l_lines, l_page_break
         );
      if l_y + l_max_top - l_fs( p_idx ) * coalesce( l_lines, 1 ) < l_settings.margin_bottom
      then
        new_page;
        l_y := l_settings.page_height - l_settings.margin_top - l_max_top;
        if p_header_repeat
        then
          print_header;
        end if;
      end if;
      l_max_height := greatest( l_max_height, l_fs( p_idx ) * coalesce( l_lines, 1 ) );
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
          wti( replace( p_txt, chr(9), rpad( ' ', c_tab_spaces ) )
             , l_x + l_padding, l_y
             , l_x + l_padding, l_x + l_widths( p_idx ) - l_padding
             , null, null
             , l_fi( p_idx ), l_fs( p_idx ), p_txt_color
             , case when p_al.exists( p_idx ) then p_al( p_idx ) end
             , false, l_tmp_x, l_tmp_y, l_lines, l_page_break
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
              hc( l_v, c );
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
              if p_fmt.exists( c )
              then
                hc( to_char( l_n, p_fmt( c ) ), c );
              else
                hc( to_char( l_n ), c );
              end if;
            end if;
          when l_desc_tab( c ).col_type = 12  -- date
          then
            if p_how = 1
            then
              dbms_sql.define_column( p_cursor, c, l_d );
            else
              dbms_sql.column_value( p_cursor, c, l_d );
              if p_fmt.exists( c )
              then
                hc( to_char( l_d, p_fmt( c ) ), c );
              else
                hc( to_char( l_d ), c );
              end if;
            end if;
          when l_desc_tab( c ).col_type = 180  -- timestamp
          then
            if p_how = 1
            then
              dbms_sql.define_column( p_cursor, c, l_ts );
            else
              dbms_sql.column_value( p_cursor, c, l_ts );
              if p_fmt.exists( c )
              then
                hc( to_char( l_ts, p_fmt( c ) ), c );
              else
                hc( to_char( l_ts ), c );
              end if;
            end if;
          when l_desc_tab( c ).col_type = 181  -- timestamp with time zone
          then
            if p_how = 1
            then
              dbms_sql.define_column( p_cursor, c, l_tsz );
            else
              dbms_sql.column_value( p_cursor, c, l_tsz );
              if p_fmt.exists( c )
              then
                hc( to_char( l_tsz, p_fmt( c ) ), c );
              else
                hc( to_char( l_tsz ), c );
              end if;
            end if;
          when l_desc_tab( c ).col_type = 231  -- timestamp with local time zone
          then
            if p_how = 1
            then
              dbms_sql.define_column( p_cursor, c, l_tslz );
            else
              dbms_sql.column_value( p_cursor, c, l_tslz );
              if p_fmt.exists( c )
              then
                hc( to_char( l_tslz, p_fmt( c ) ), c );
              else
                hc( to_char( l_tslz ), c );
              end if;
            end if;
          when l_desc_tab( c ).col_type = 23  -- raw
          then
            if p_how = 1
            then
              dbms_sql.define_column( p_cursor, c, l_r, 32767 );
            elsif p_how = 3
            then
              dbms_sql.column_value( p_cursor, c, l_r );
              if l_padding > 0
              then
                l_img_pad := l_padding;
              else
                l_img_pad := coalesce( l_line_width, 0.5 );
              end if;
              put_image( to_blob( l_r )
                       , l_x + l_img_pad, l_y + l_max_top - l_max_height + l_img_pad
                       , l_widths( c ) - 2 * l_img_pad
                       , l_max_height - 2 * l_img_pad
                       , 'C', 'C'
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
              if l_padding > 0
              then
                l_img_pad := l_padding;
              else
                l_img_pad := coalesce( l_line_width, 0.5 );
              end if;
              dbms_lob.createtemporary( l_b, true );
              dbms_sql.column_value( p_cursor, c, l_b );
              put_image( l_b
                       , l_x + l_img_pad, l_y + l_max_top - l_max_height + l_img_pad
                       , l_widths( c ) - 2 * l_img_pad
                       , l_max_height - 2 * l_img_pad
                       , 'C', 'C'
                       );
              l_x := l_x + l_widths( c );
              dbms_lob.freetemporary( l_b );
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
        l_y := l_y - l_max_height;
        g_pdf.y := l_y; 
      end if;
    end handle_columns;
  begin
    dbms_sql.describe_columns2( p_cursor, l_col_cnt, l_desc_tab );
    --
    l_font_index := gfi( p_font_index );
    l_font := g_pdf.fonts( l_font_index );
    l_fontsize := coalesce( p_fontsize, l_font.fontsize );
    l_max_top := ( 0.5 * l_font.linegap + l_font.ascent ) * l_fontsize / 1000;
    l_idx := p_fi.first;
    loop
      exit when l_idx is null;
      l_font := g_pdf.fonts( p_fi( l_idx ) );
      if p_fs.exists( l_idx )
      then
        l_max_top := greatest( l_max_top, ( 0.5 * l_font.linegap + l_font.ascent ) * p_fs( l_idx ) / 1000 );
      else
        l_max_top := greatest( l_max_top, ( 0.5 * l_font.linegap + l_font.ascent ) * l_fontsize / 1000 );
      end if;
      l_idx := p_fi.next( l_idx );
    end loop;
    l_font := g_pdf.fonts( l_font_index );
    l_idx := p_fs.first;
    loop
      exit when l_idx is null;
      l_idx := p_fs.next( l_idx );
      if not p_fi.exists( l_idx )
      then
        l_max_top := greatest( l_max_top, ( 0.5 * l_font.linegap + l_font.ascent ) * p_fs( l_idx ) / 1000 );
      end if;
    end loop;
    --
    for c in 1 .. l_col_cnt
    loop
      if p_fi.exists( c )
      then
        l_fi( c ) := p_fi( c );
      else
        l_fi( c ) := l_font_index;
      end if;
      if p_fs.exists( c )
      then
        l_fs( c ) := p_fs( c );
      else
        l_fs( c ) := l_fontsize;
      end if;
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
    l_padding := str_len( ' ', l_font_index, l_fontsize );
    handle_widths( p_widths, l_col_cnt, l_start_x, l_settings, l_widths );
    l_line_width := 0;
    for i in 1 .. l_col_cnt
    loop
      l_line_width := l_line_width + l_widths( i );
    end loop;
    --
    print_header;
    handle_columns( 1 );  -- define column variables
    l_row_nr := 0;
    loop
      exit when dbms_sql.fetch_rows( p_cursor ) = 0;
      l_max_height := 0;
      l_row_nr := l_row_nr + 1;
      handle_columns( 2 ); -- calc row height
      --
      fill_with_borders
        ( l_start_x, l_y + l_max_top
        , l_start_x + l_line_width, l_y + l_max_top - l_max_height
        , l_widths
        , case when bitand( l_row_nr, 1 ) > 0 then p_odd_color end
        , case when bitand( l_row_nr, 1 ) = 0 then p_even_color end
        , p_line_color, p_line_width
        );
      --
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
    ( p_rc            sys_refcursor
    , p_x             number
    , p_y             number
    , p_headers       tp_varchar2s := null
    , p_widths        tp_numbers   := null
    , p_font_index    pls_integer  := null
    , p_fontsize      number       := null
    , p_txt_color     varchar2     := null
    , p_odd_color     varchar2     := null
    , p_even_color    varchar2     := null
    , p_line_color    varchar2     := null
    , p_line_width    number       := null
    , p_header_fi     pls_integer  := null
    , p_header_fs     number       := null
    , p_header_txt_c  varchar2     := null
    , p_header_color  varchar2     := null
    , p_header_repeat boolean      := true
$IF dbms_db_version.ver_le_11
$THEN
    , p_fi            tp_pls_tab  := c_null_pls_tab
    , p_fs            tp_num_tab  := c_null_num_tab
    , p_al            tp_txt_tab  := c_null_txt_tab
    , p_fmt           tp_txt_tab  := c_null_txt_tab
$ELSIF dbms_db_version.ver_le_12
$THEN
    , p_fi            tp_pls_tab  := c_null_pls_tab
    , p_fs            tp_num_tab  := c_null_num_tab
    , p_al            tp_txt_tab  := c_null_txt_tab
    , p_fmt           tp_txt_tab  := c_null_txt_tab
$ELSE
    , p_fi            tp_pls_tab   := tp_pls_tab()
    , p_fs            tp_num_tab   := tp_num_tab()
    , p_al            tp_txt_tab   := tp_txt_tab()
    , p_fmt           tp_txt_tab   := tp_txt_tab()
$END
    )
  is
    l_cx integer;
    l_rc sys_refcursor;
  begin
    l_rc := p_rc;
    l_cx := dbms_sql.to_cursor_number( l_rc );
    c2t( p_cursor        => l_cx
       , p_x             => p_x
       , p_y             => p_y
       , p_headers       => p_headers
       , p_widths        => p_widths
       , p_font_index    => p_font_index
       , p_fontsize      => p_fontsize
       , p_txt_color     => p_txt_color
       , p_odd_color     => p_odd_color
       , p_even_color    => p_even_color
       , p_line_color    => p_line_color
       , p_line_width    => p_line_width
       , p_header_fi     => p_header_fi
       , p_header_fs     => p_header_fs
       , p_header_txt_c  => p_header_txt_c
       , p_header_color  => p_header_color
       , p_header_repeat => p_header_repeat
       , p_fi            => p_fi
       , p_fs            => p_fs
       , p_al            => p_al
       , p_fmt           => p_fmt
       );
  end cursor2table;
  --
  procedure query2table
    ( p_query        varchar2
    , p_x             number
    , p_y             number
    , p_headers       tp_varchar2s := null
    , p_widths        tp_numbers   := null
    , p_font_index    pls_integer  := null
    , p_fontsize      number       := null
    , p_txt_color     varchar2     := null
    , p_odd_color     varchar2     := null
    , p_even_color    varchar2     := null
    , p_line_color    varchar2     := null
    , p_line_width    number       := null
    , p_header_fi     pls_integer  := null
    , p_header_fs     number       := null
    , p_header_txt_c  varchar2     := null
    , p_header_color  varchar2     := null
    , p_header_repeat boolean      := true
$IF dbms_db_version.ver_le_11
$THEN
    , p_fi            tp_pls_tab  := c_null_pls_tab
    , p_fs            tp_num_tab  := c_null_num_tab
    , p_al            tp_txt_tab  := c_null_txt_tab
    , p_fmt           tp_txt_tab  := c_null_txt_tab
$ELSIF dbms_db_version.ver_le_12
$THEN
    , p_fi            tp_pls_tab  := c_null_pls_tab
    , p_fs            tp_num_tab  := c_null_num_tab
    , p_al            tp_txt_tab  := c_null_txt_tab
    , p_fmt           tp_txt_tab  := c_null_txt_tab
$ELSE
    , p_fi            tp_pls_tab   := tp_pls_tab()
    , p_fs            tp_num_tab   := tp_num_tab()
    , p_al            tp_txt_tab   := tp_txt_tab()
    , p_fmt           tp_txt_tab   := tp_txt_tab()
$END
    )
  is
    l_cx    integer;
    l_dummy integer;
  begin
    l_cx := dbms_sql.open_cursor;
    dbms_sql.parse( l_cx, p_query, dbms_sql.native );
    l_dummy := dbms_sql.execute( l_cx );
    c2t( p_cursor        => l_cx
       , p_x             => p_x
       , p_y             => p_y
       , p_headers       => p_headers
       , p_widths        => p_widths
       , p_font_index    => p_font_index
       , p_fontsize      => p_fontsize
       , p_txt_color     => p_txt_color
       , p_odd_color     => p_odd_color
       , p_even_color    => p_even_color
       , p_line_color    => p_line_color
       , p_line_width    => p_line_width
       , p_header_fi     => p_header_fi
       , p_header_fs     => p_header_fs
       , p_header_txt_c  => p_header_txt_c
       , p_header_color  => p_header_color
       , p_header_repeat => p_header_repeat
       , p_fi            => p_fi
       , p_fs            => p_fs
       , p_al            => p_al
       , p_fmt           => p_fmt
       );
  end query2table;
end as_pdf;
/
