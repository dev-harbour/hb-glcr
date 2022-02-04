/*
 *
 */

STATIC row := 1

FUNCTION Main()

   LOCAL win
   LOCAL width
   LOCAL height
   LOCAL xdpy
   LOCAL xwin
   LOCAL surface
   LOCAL cr
   LOCAL te

   LOCAL w := 0, h := 0
   LOCAL TEXT := "Vertical Menu"
   LOCAL xc
   LOCAL i

   LOCAL menuItem := { "C/C++", "Python", "Kotlin", "JavaScript", "Harbour" }

   IF( glfwInit() < 0 )
      OutStd( e"Unable to initialize Init: \n" )
      glfwTerminate()
      RETURN -1
   ENDIF

   glfwWindowHint( GLFW_CLIENT_API, GLFW_NO_API )

   win := glfwCreateWindow( 720, 450, "GLFW .AND. Cairo", NIL, NIL )
   IF( win == NIL )
      OutStd( e"Unable to initialize Window: \n" )
      glfwTerminate()
      RETURN -1
   ENDIF

   glfwSwapInterval( 1 )

   glfwGetFramebufferSize( win, @width, @height )

   xdpy := glfwGetX11Display()
   IF( xdpy == NIL )
      OutStd( e"Unable to initialize Xdisplay: \n" )
      glfwTerminate()
      RETURN -1
   ENDIF

   xwin    := glfwGetX11Window( win )
   surface := hb_cairo_xlib_surface_create( xdpy, xwin, width, height )

   cr      := cairo_create( surface )

   glfwSetKeyCallback( win, @key_callback() )

   DO WHILE( glfwWindowShouldClose( win ) == 0 )

      glfwGetFramebufferSize( win, @width, @height )
      cairo_xlib_surface_set_size( surface, width, height )

      cairo_push_group( cr )

      IF( w != width .OR. h != height )

         cairo_set_source_rgb( cr, 1.0, 1.0, 1.0 )
         cairo_set_operator( cr, CAIRO_OPERATOR_SOURCE )
         cairo_paint( cr )
         // ---
         cairo_select_font_face( cr, "FreeSans", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_BOLD )
         cairo_set_font_size( cr, 72 )
         cairo_set_source_rgb( cr, 0.1961, 0.1961, 0.1961 )

         te := cairo_text_extents( cr, TEXT )

         xc := ( width - te[ TEXT_WIDTH ] ) / 2

         cairo_move_to( cr, xc, 67 )
         cairo_show_text( cr, TEXT )

         w := width
         h := height
      ENDIF

      FOR i := 1 TO Len( menuItem )

         IF( row == i )
            cairo_set_source_rgb( cr, 1.0, 0.3921, 0.0 )
            cairo_rectangle( cr, 0, 72 + 40 * i, width, 40 )
            cairo_fill( cr )
         ELSE
            cairo_set_source_rgb( cr, 1.0, 1.0, 1.0 )
            cairo_rectangle( cr, 0, 72 + 40 * i, width, 40 )
            cairo_fill( cr )
         ENDIF
         cairo_set_source_rgb( cr, 0.9529, 0.9529, 0.9529 )
         cairo_set_line_width( cr, 0.5 )
         cairo_rectangle( cr, 0, 72 + 40 * i, width, 40 )
         cairo_stroke( cr )
         // --
         cairo_select_font_face( cr, "FreeSans", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL )
         cairo_set_font_size( cr, 20 )
         cairo_set_source_rgb( cr, 0.1961, 0.1961, 0.1961 )

         te := cairo_text_extents( cr, menuItem[ i ] )

         xc = ( width - te[ TEXT_WIDTH ] ) / 2

         cairo_move_to( cr, xc, 100 + 40 * i )
         cairo_show_text( cr, menuItem[ i ] )

      NEXT
      // ---
      cairo_pop_group_to_source( cr )
      cairo_paint( cr )
      cairo_surface_flush( surface )

      glfwSwapBuffers( win )
      glfwPollEvents()
   ENDDO
   cairo_destroy( cr )
   cairo_surface_finish( surface )
   cairo_surface_destroy( surface )
   glfwDestroyWindow( win )

   glfwTerminate()

   RETURN 0

STATIC PROCEDURE key_callback( window, KEY, scancode, action, mods )

   UNUSED( scancode )
   UNUSED( mods )

   IF( action == GLFW_PRESS )
      RETURN
   ENDIF

   SWITCH( KEY )

   CASE GLFW_KEY_ESCAPE

      glfwSetWindowShouldClose( window, GLFW_TRUE )
      EXIT

   CASE GLFW_KEY_UP

      IF( row > 1 )
         row--
      ENDIF
      EXIT

   CASE GLFW_KEY_DOWN

      IF( row < 5 )
         row++
      ENDIF
      EXIT

   ENDSWITCH

   RETURN
