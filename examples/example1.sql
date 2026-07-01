begin
  as_pdf.init;
  as_pdf.set_wallet( 'file:/apex' );
  as_pdf.set_proxy( null );
  as_pdf.set_font( as_pdf.load_google_font( 'Fragment Mono' ) );
  as_pdf.query2table
    ( p_query => 'select product_id, product_name, product_description, product_image from demo_product_info order by product_id'
    , p_x => 30
    , p_y => 700
    , p_min_height => 100
    );
  as_pdf.save_pdf( 'MY_DIRECTORY', 'example1.pdf' );
end;
/
