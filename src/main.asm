; MODELO
.MODEL SMALL 
; SISTEMA HEXADECIMAL
.RADIX 16
; PILA
.STACK
; DATOS
.DATA

; INICIALIZACION DEL PROGRAMA
;; TOKENS
tkCredenciales               db     0e, "[credenciales]"
tkNombre              db     07, "usuario"
tkClave               db     05, "clave"
tkIgual             db     01, "="
tkComillas           db     01, '"'
;; CONFIGURACION INICIAL
claveCapturada        db     09  dup (0)
usuarioCapturado      db     0a  dup (0)
;
espacioLeido          db     00
estado                 db     00
bufferLinea           db     0ff dup (0)
tamLineaLeida       db     00
;
handleConfig           dw     0000
nombreConfig            db     "PRA2.CNF", 00
;; CREDECIALES
usuario                     db  "hgomez", "$"
clave                       db  "202103718", "$"

; PARA EL USO DE DISTINTAS FUNCIONES
;; BUFFER
bufferEntrada   db  20, 00
                 db  20 dup (0)
;; LIMPIAR BUFFER
ceros          db     2b  dup (0)
;; NUMERO PARA CONVERTIR A CADENA
numero           db   05 dup (30)
;; LLAVE FIN 
cadenaFin db "fin","$"

; IMPRESIONES
;; PARA USO GENERAL
;;; NUEVA LINEA
nuevaLinea  db    0a,"$"
;;; PROMPT
prompt     db    "Elija una opcion:",0a,"$"
separadorPrompt db    "=================",0a,"$"
;;; OPCIÓN REGRESAR
regresar     db    "(R)egresar",0a,"$"

;; ENCABEZADO
MensajeInicial              db  " Universidad de San Carlos de Guatemala", 0dh, 0ah," Facultad de Ingenieria", 0dh, 0ah," Escuela de Vacaciones ", 0dh, 0ah," Arquitectura de Compiladores y ensabladores 1", 0dh, 0ah," Seccion N", 0a, 0dh, 0ah," Harry Aaron Gomez Sanic", 0dh, 0ah," 202103718", 0a, "$"
;; MENU PRINCIPAL
tituloMenu db   "MENU PRINCIPAL",0a,"$"
separadorMenu     db  "==============",0a,"$"
productos  db    "(P)roductos",0a,"$"
ventas     db    "(V)entas",0a,"$"
herramientas db  "(H)erramientas",0a,"$"
salir     db     "(S)alir",0a,"$"

;; MENU PRODUCTOS
tituloProducto db  "PRODUCTOS",0a,"$"
separadorProducto        db  "=========",0a,"$"
opcionProductoMostrar     db  "(M)ostrar productos",0a,"$"
opcionProductoIngresar    db  "(I)ngresar producto",0a,"$"
opcionProductoBorrar      db  "(B)orrar producto",0a,"$"
productono_encontrado    db  "El producto a borrar no existe.", 0a, "$"
producto_eliminado		db "El producto fue eliminado.", 0a, "$"
producto_existe		db "Ya existe un producto con ese Codigo.", 0a, "$"

;;; PROMPT PRODUCTOS
promptCodigo      db    "Codigo: ","$"
promptNombre      db    "Nombre: ","$"
promptPrecio     db    "Precio: ","$"
promptUnidades     db    "Unidades: ","$"
;; SUB MENU MOSTRAR PRODUCTOS
tituloProductoMostrar db  "MOSTRAR PRODUCTOS",0a,"$"
preguntaEnter db "Presione ENTER para continuar, q para Salir.",0a,"$"
separadorProductoMostrar        db  "=================",0a,"$"
;; SUB MENU INGRESAR PRODUCTOS
tituloProductoIngresar db  "INGRESAR PRODUCTO",0a,"$"
separadorProductoIngresar        db  "=================",0a,"$"
;; SUB MENU BORRAR PRODUCTOS
tituloProductoBorrar db  "BORRAR PRODUCTO",0a,"$"
separadorProductoBorrar        db  "===============",0a,"$"
;; MENSAJES
noEncontrado db "PRODUCTO NO ENCONTRADO",0a,"$"

;; MENU VENTAS
tituloVentas   db  "VENTAS",0a,"$"
separadorVentas      db  "======",0a,"$"
opcionVentasIngresar     db  "(I)ngresar venta",0a,"$"
;;; PROMPT VENTAS
promptCantidad    db       "Cantidad: ","$"
promptMonto    db          "Monto: ","$"
promptMontoTotal    db    "Monto total: ","$"
;; SUB MENU INGRESAR VENTAS
tituloVentasIngresar db  "INGRESAR VENTA",0a,"$"
separadorVentasIngresar     db  "==============",0a,"$"
;; MENSAJES
sinExistencias db "PRODUCTO SIN EXISTENCIAS",0a,"$"
separadorSinExistencias      db "========================",0a,"$"


;; MENU HERRAMIENTAS
tituloHerramientas   db  "HERRAMIENTAS",0a,"$"
separadorHerramientas        db  "============",0a,"$"
catalogoCompleto     db     "(C)atalogo completo",0a,"$"
alfabeticoProductos    db   "(A)lfabetico de productos",0a,"$"
reporteVentas     db        "(V)entas",0a,"$"
productosSinExistencias db  "(P)roductos sin existencias",0a,"$"
;; SUB MENU CATALOGO COMPLETO
tituloCatalogoCompleto db  "CATALOGO COMPLETO",0a,"$"
separadorHerramientasCatalogo        db  "=================",0a,"$"
;; SUB MENU ALFABETICO DE PRODUCTOS
tituloAlfabeticoProductos db  "ALFABETICO DE PRODUCTOS",0a,"$"
separadorHerramientasAlfabetico        db   "=======================",0a,"$"
;; SUB MENU REPORTE DE VENTAS
tituloReporteVentas db  "REPORTE DE VENTAS",0a,"$"
separadorHerramientasVentas        db  "=================",0a,"$"
;; SUB MENU PRODUCTOS SIN EXISTENCIAS
tituloSinExistencias          db  "PRODUCTOS SIN EXISTENCIAS",0a,"$"
separadorHerramientasSinExistencias      db  "=========================",0a,"$"
;; MENSAJE DE REPORTE GENERADO
reporteGenerado db "REPORTE GENERADO CORRECTAMENTE",0a,"$"

; VARIABLES TEMPORALES
;; TEMPORAL
temp       db    00,"$"
cont_temp	db 	00
prod_temp	db 2a dup (0)

; ESTRUCTURAS PARA PRODUCTOS
;; TEMPORAL PARA PRODUCTOS
productoCodigoTemporal    db    05 dup (0)
punteroTemporal     dw    0000
;; ESTRUCTURA PRODUCTO
productoCodigo    db    05 dup (0)
productoNombre    db    21 dup (0)
productoPrecio   db    05 dup (0)
productoUnidades   db    05 dup (0)
;; NUMERICOS PRODUCTO
productoPrecioNumero   dw    0000
productoUnidadesNumero   dw    0000

; ESTRUCTURAS PARA VENTAS
;; PUNTERO DE ITEMS
punteroItems    dw 0000h
;; ESTRUCTURA VENTAS
;; FECHA
diaVenta        db 01 dup (0)
mesVenta        db 01 dup (0)
anioVenta       dw 00
horaVenta       db 01 dup (0)
minutoVenta     db 01 dup (0)
;; TEMPORALES PARA VENTAS
ventaCodigoTemporal     db 05 dup (0)
ventaCantidadTemporal    	db 05 dup (0)
;; ESTRUCTURA VENTAS
ventaCodigo     	db 05 dup (0)
ventaDescripcion 	db 21 dup (0)
;; NUMERICO VENTAS
ventaPrecioNumero dw 0000
ventaUnidadesNumero dw 0000
;
ventaCantidadNumero   	dw 0000
ventaMontoNumero   	dw 0000
ventaMontoTotalNumero dw 0000
;; CONTADOR DE ITEMS VENTAS
contadorItemsVenta  db 0
;; CALCULO PARA EL GUARDA DE VENTAS
bytesItems db 46 dup (0)
direccionItem dw 0000h

; MANEJO DE ARCHIVOS (BASE DE DATOS)
;; ARCHIVOS PRODUCTOS
archivoProductos    db   "PROD.BIN", 00
handleProductos     dw   0000
;; ARCHIVOS VENTAS
archivoVentas    db   "VENT.BIN", 00
handleVentas     dw   0000

; ARCHIVOS HERRAMIENTAS
;; REPORTE CATALOGO
archivoCatalogo      db   "CATALG.HTM", 00
handleCatalogo      dw   0000

;; REPORTE ALFABETICO
archivoAlfabetico      db   "ABC.HTM", 00
handleAlfabetico      dw   0000
;;; VARIABLES ABC
dia        db 01 dup (0)
mes       db 01 dup (0)
anio       dw 00
hora      db 01 dup (0)
minutos     db 01 dup (0)
;
dosPuntos db ":",0a,"$"
diagonal db "/",0a,"$"
;
contador db 00
letraActual db 41 
primeraLetra db 00

;; REPORTE DE EXISTENCIAS
archivoSinExistencias     db   "FALTA.HTM", 00
handleSinExistencias      dw   0000

;; REPORTE DE VENTAS
archivoReporteVentas         db "REP.TXT", 00
handleReporteVentas      dw   0000
offsetReporteVentas   dw 0000
;;; CANTIDAD DE VENTAS
cantidadVentas       dw 0000
;;; ESPACIO EN BLANCO
espacioBlanco   db  " "
;;; FECHA Y HORA
horaActual       db "00:00:00"
horaActualSize   equ $-horaActual
diaActual        db 01 dup (0)
mesActual        db 01 dup (0)
anioActual       dw 00
separadorFecha   db "/", 00
separadorHora    db ":", 00 
;;; VVARIABLES
txtFecha db "Fecha: "
txtFechaSize equ $-txtFecha
;
txtMonto db "Monto: "
txtMontoSize equ $-txtMonto
;
txtUltimasVentas     db  "Ultimas ventas: ", 0ah
txtUltimasVentasSize equ $-txtUltimasVentas
;
txtMayorMonto db "Venta con mayor monto: ", 0ah
txtMayorMontoSize equ $-txtMayorMonto
;
txtMenorMonto db "Venta con menor monto: ", 0ah
txtMenorMontoSize equ $-txtMenorMonto
;
fechaMayorVenta      db 06h dup (0)
fechaMenorVenta      db 06h dup (0)
;
montoMayorVenta      dw 0000
montoMenorVenta      dw 0000
;; SEPARADORES
separador       db  "|=================================================|", 0dh, 0ah, "$"
separadorSize   equ $-separador
;
separadorSimple     db  "|-------------------------------------------------|", 0dh, 0ah, "$"
separadorSimpleSize equ $-separadorSimple

;;; VARIABLES DE TAMAÑO HTML 
tam_encabezado_html		db 	1b ;; 27
tam_tit_Catalogo_html	db	16 ;; 23
tam_style_Table_html	db	38 ;; 56
tam_style_Th_html		db	41 ;; 65
tam_cierre_style		db	8  ;; 8
tam_cierre_head			db	7  ;; 7
tam_body_Cataologo_html	db  24 ;;45
tam_body_Rep_exist_html	db  33 ;;45
tam_fecha_html			db	0a  ;; 10
tam_hora_html			db	8  ;; 8
tam_cierre_p			db  4  ;; 4
tam_apertura_table		db  7  ;; 7
tam_cierre_table		db 	8  ;; 8
tam_apertura_tr			db  4  ;; 4
tam_titulos_html		db  3e  ;; 62
tam_titulos_exis_html		db  2d  ;; 62
tam_cierre_tr			db	5	;; 5
tam_apertura_td			db	4  ;; 4
tam_cierre_td			db	5	;; 5
tam_cierre_body			db	7  ;; 7
tam_cierre_html			db	7  ;; 7
tam_titulos_alfa_html	db  27 ;;39
tam_body_Rep_alfa_html  db  26 ;; 38
tam_tit_css	    		db	3e ;; 62
;;; VARIABLES DE ESTRUCTURA HTML
tit_css					db	"<link rel = 'stylesheet' type = 'text/css' href = 'style.css'>"
style_Table_html		    db	"<style>table { width: 100%; border-collapse: collapse; }" 
style_Th_html			    db  "th, td {border: 1px solid black; padding: 8px; text-align: left;}"
cierre_style           	    db  "</style>"
encabezado_html        	db	"<!DOCTYPE html><html><head>" 
tit_Catalogo_html 		db	"<title>Reporte</title>"	
cierre_head            	db  "</head>"
body_Cataologo_html     db  "<body><h1>Catalogo de Productos</h1>"
body_Rep_alfa_html		db	"<body><h1>Alfabetico de Productos</h1>"
body_Rep_exis_html		db	"<body><h1>Reporte de Productos sin Existencias</h1>"
fecha_html				db	"<p>Fecha: "
hora_html 				db	"<p>Hora:"
cierre_p				db	"</p>"
apertura_table			db 	"<table>"
cierre_table			db	"</table>"
apertura_tr				db	"<tr>"
titulos_alfa_html		db	"<th>Letra</th><th>Cantidad de Productos"
titulos_html			db	"<th>Código</th><th>Descripción</th><th>Precio</th><th>Unidades"
titulos_existencias_html db	"<th>Código</th><th>Descripción</th><th>Precio"
cierre_tr				db	"</tr>"
apertura_td				db	"<td>"
cierre_td				db	"</td>"
cierre_body				db	"</body>"
cierre_html				db	"</html>"
cierre_th				db  "</th>"

; CODIGO
.CODE
.STARTUP
;; INICIO
inicio:
	;;; SEPARACION
	mov DX, offset nuevaLinea
	mov AH, 09
	int 21
	;;; ENCABEZADO
	mov DX, offset MensajeInicial
	mov AH, 09
	int 21
	mov DX, offset nuevaLinea
	mov AH, 09
	int 21
	
	;;; VALIDACIONES PARA LAS CREDENCIALES DEL USUARIO
    call validar_acceso

	; VERIIFCA SI EL NOMBRE DE USUARIO ES CORRECTO
    mov si, offset usuario
    mov di, offset usuarioCapturado
    inc di
    mov cx, 06
    call cadenas_iguales
    cmp dl, 0ff             
    je validar_clave_usuario
    ; SI ES INCORRECTO IMPRIME MENSAJE Y FINALIZA EL PROGRAMA
	
	
    jmp credenciales_incorrectas_fin

	validar_clave_usuario:
		; VERIFICA SI LA CLAVE DE USUARIO ES CORRECTA
		mov si, offset clave
		mov di, offset claveCapturada
		inc di
		mov cx, 09
		call cadenas_iguales
		cmp dl, 0ff

		call tecla_enter

		je menu_principal
		; SI ES INCORRECTO IMPRIME MENSAJE Y FINALIZA EL PROGRAMA
		mov DX, offset txtMonto
	mov AH, 09
	int 21
		jmp credenciales_incorrectas_fin

	credenciales_incorrectas_fin:
		jmp fin

;; MENU PRINCIPAL		
menu_principal:
	;;; SEPARACION
	mov DX, offset nuevaLinea
	mov AH, 09
	int 21
	;; IMPRIMIR MENÚ
	mov DX, offset tituloMenu
	mov AH, 09
	int 21
	mov DX, offset separadorMenu
	mov AH, 09
	int 21
	;;
	mov DX, offset productos
	mov AH, 09
	int 21
	mov DX, offset ventas
	mov AH, 09
	int 21
	mov DX, offset herramientas
	mov AH, 09
	int 21
	mov DX, offset salir
	mov AH, 09
	int 21
	;; SEPARACION
	mov DX, offset separadorPrompt
	mov AH, 09
	int 21
	;; IMPRIMIR PROMPT
	mov DX, offset prompt
	mov AH, 09
	int 21
	;; LEER 1 CARACTER
	mov AH, 08
	int 21 ;; AL = CARACTER LEIDO. COMPARAR PARA HACER EL JUMP
	;; SI ES IGUAL A P -> MENU PRODUCTOS
	cmp AL, 70 ;; p minúscula ascii
	je menu_productos
	;; SI ES IGUAL A V -> MENU VENTAS
	cmp AL, 76 ;; v minúscula ascii
	je menu_ventas 
	;; SI ES IGUAL A H -> MENU HERRAMIENTAS
	cmp AL, 68 ;; h minúscula ascii 
	je 	menu_herramientas 
	;; SI ES IGUAL A S -> SALIR
	cmp AL, 73 ;; s minúscula ascii
	je 	fin ;;generar_catalogo
	;; SI  NO ES NINGUNO DE LOS ANTERIORES, VOLVER A IMPRIMIR EL MENU 
	jmp menu_principal
	;;
	;; MENU DE PRODUCTOS		
	menu_productos:
		;; SEPARACION
		mov DX, offset nuevaLinea
		mov AH, 09
		int 21
		;; MOSTRAR MENU PRODUCTOS
		mov DX, offset tituloProducto
		mov AH, 09
		int 21
		mov DX, offset separadorProducto
		mov AH, 09
		int 21
		;; OPCIONES
		mov DX, offset opcionProductoMostrar
		mov AH, 09
		int 21
		mov DX, offset opcionProductoIngresar
		mov AH, 09
		int 21
		mov DX, offset opcionProductoBorrar
		mov AH, 09
		int 21		
		mov DX, offset regresar
		mov AH, 09
		int 21		
		;; SEPARACION
		mov DX, offset separadorPrompt
		mov AH, 09
		int 21
		;; IMPRIMIR PROMPT
		mov DX, offset prompt
		mov AH, 09
		int 21
		;; LEER 1 CARACTER
		mov AH, 08
		int 21
		;; AL = CARACTER LEIDO
		cmp AL, 6d ;; mostrar
		je mostrar_productos_archivo
		cmp AL, 69 ;; insertar
		je ingresar_producto_archivo
		cmp AL, 62 ;; borrar
		je eliminar_producto_archivo	
		cmp AL, 72 ;; menu principañl
		je menu_principal					
		jmp menu_productos
		
		;; MOSTRAR PRODUCTOS
		mostrar_productos_archivo:
			;; SEPARACION
			mov DX, offset nuevaLinea
			mov AH, 09
			int 21
			;; IMPRIMIR SUB MENU
			mov DX, offset tituloProductoMostrar
			mov AH, 09
			int 21
			mov DX, offset separadorProductoMostrar
			mov AH, 09
			int 21
			;;
			mov AL, 02
			mov AH, 3d
			mov DX, offset archivoProductos
			int 21
			;error
			jc fin_mostrar
			;;
			mov [handleProductos], AX
			mov [cont_temp], 00
				;; leemos
			;; CICLO PARA LEER ARCHIVO		
			ciclo_mostrar:
				;; puntero cierta posición
				mov BX, [handleProductos]
				mov CX, 0026     ;; leer 26h bytes
				mov DX, offset productoCodigo
				;;
				mov AH, 3f
				int 21
				;; puntero avanzó
				mov BX, [handleProductos]
				mov CX, 0004
				mov DX, offset productoPrecioNumero
				mov AH, 3f
				int 21
				;; ¿cuántos bytes leímos?
				;; si se leyeron 0 bytes entonces se terminó el archivo...
				cmp AX, 0000
				je fin_mostrar
				;; ver si es producto válido
				mov AL, 00
				cmp [productoCodigo], AL
				je ciclo_mostrar
				cmp [cont_temp], 05
				jb imprimir_producto
				;; preguntar enter para imprimir otros 5 o q para salir
				mov DX, offset preguntaEnter
				mov AH, 09
				int 21
				;; LEER 1 CARACTER
				mov AH, 08
				int 21
				;; AL = CARACTER LEIDO
				cmp AL, 71 ;; q
				je fin_mostrar
				;; imprimir otros 5
				cmp AL, 0d ;; enter
				mov [cont_temp], 00
				je ciclo_mostrar
			imprimir_producto:
				;; producto en estructura
				call imprimir_estructura
				jmp ciclo_mostrar
				;;
			;; FINALIZAR MOSTRAR PRODUCTOS
			fin_mostrar:
				;; limpiar los primeros dos
				mov DI, offset productoCodigo
				mov CX, 26
				call memset

				jmp menu_productos				
				;;
			;; IMPRIMIR ESTRUCTURA
			imprimir_estructura:
				;; aumentar 1 a cont_temp
				add [cont_temp], 01
				mov DI, offset productoCodigo
				;;
			;; CICLO PARA PONER $		
			ciclo_poner_dolar_1:
				mov AL, [DI]
				cmp AL, 00
				je poner_dolar_1
				inc DI
				jmp ciclo_poner_dolar_1
				;;
			;; PONER $ 		
			poner_dolar_1:
				mov AL, 24  ;; dólar
				mov [DI], AL
				;; imprimir normal
				mov DX, offset productoCodigo
				mov AH, 09
				int 21
				mov DX, offset nuevaLinea
				mov AH, 09
				int 21	
				
				mov DI, offset productoNombre
				;;
			;; CICLO PARA PONER $		
			ciclo_poner_dolar_2:
				mov AL, [DI]
				cmp AL, 00
				je poner_dolar_2
				inc DI
				jmp ciclo_poner_dolar_2
				;;
			;; PONER $ 		
			poner_dolar_2:
				mov AL, 24  ;; dólar
				mov [DI], AL
				;; imprimir normal
				mov DX, offset productoNombre
				mov AH, 09
				int 21	
				mov DX, offset nuevaLinea
				mov AH, 09
				int 21		
				;; SEPARACION
				mov DX, offset separadorProducto
				mov AH, 09
				int 21		
				ret
				;;		
		;; MENÚ INGRESAR PRODUCTO		
		ingresar_producto_archivo:
			;; SEPARACION
			mov DX, offset nuevaLinea
			mov AH, 09
			int 21
			;; IMPRIMIR SUB MENU
			mov DX, offset tituloProductoIngresar
			mov AH, 09
			int 21
			mov DX, offset separadorProductoIngresar
			mov AH, 09
			int 21
			;;
			;; PEDIR CODIGO
			pedir_de_nuevo_codigo:
				;; SEPARACION
				mov DX, offset nuevaLinea
				mov AH, 09
				int 21	
				; LIMPIAR CODIGO
				mov DI, offset productoCodigo
				mov CX, 5
				call memset
				;; IMPRIMIR PROMPT
				mov DX, offset promptCodigo
				mov AH, 09
				int 21
				;; LEER CODIGO CON BUFFER
				mov DX, offset bufferEntrada
				mov AH, 0a
				int 21
				;; VERIFICAR QUE EL TAMAÑO DEL CODIGO NO SEA MAYOR A 5
				mov DI, offset bufferEntrada
				inc DI
				mov AL, [DI]
				cmp AL, 00
				je  pedir_de_nuevo_codigo ;; je --> jump if equal (si es igual a 0)				
				;; SEPARACION
				mov DX, offset nuevaLinea
				mov AH, 09
				int 21
				cmp AL, 05
				jb  aceptar_tam_cod  ;; jb --> jump if below (si es menor a 5)
				jmp pedir_de_nuevo_codigo	;; jmp --> jump (salto incondicional)
				;;
			;; ACEPTAR TAMAÑO DEL CODIGO		
			aceptar_tam_cod:
				mov SI, offset productoCodigo
				mov DI, offset bufferEntrada
				inc DI
				mov CH, 00
				mov CL, [DI]
				inc DI  ;; me posiciono en el contenido del buffer
				;;
			;; IMPRIMIR EL CÓDIGO		
			copiar_codigo:
				;; SEPARACION
				mov DX, offset nuevaLinea
				mov AH, 09
				int 21	
				mov AL, [DI]
				; VERIFICAR QUE CUMPLA CON LA REGEX [A-Z0-9] en hexadecimal 30-39 y 41-5A
				cmp al, 5ah
				ja  pedir_de_nuevo_codigo
				cmp al, 30
				jb  pedir_de_nuevo_codigo
				cmp al, 3ah
				jb continuar_copiando_codigo
				cmp al, 41
        		jb  pedir_de_nuevo_codigo
			continuar_copiando_codigo:
				mov [SI], AL
				inc SI
				inc DI
				loop copiar_codigo  ;; restarle 1 a CX, verificar que CX no sea 0, si no es 0 va a la etiqueta, 
									;; la cadena ingresada en la estructura
				;; SEPARACION
				mov DX, offset nuevaLinea
				mov AH, 09
				int 21
				;;


    ; LA CADENA YA FUE INGRESADA EN LA ESTRUCTURA	
	mov AL, 00              ;;;<<<<<  lectura
	mov DX, offset archivoProductos
	mov AH, 3d
	int 21
	jc  pedir_de_nuevo_nombre ; si no existe el archivo
	mov [handleProductos], AX
	; VERIFICAR SI EL PRODUCTO YA EXISTE	
	buscar_producto:
		mov DI, offset prod_temp
		mov CX, 2a
		call memset
		mov bx, [handleProductos]
		mov cx, 2a
		mov dx, offset prod_temp
		moV AH, 3f
		int 21		
		cmp AX, 0000   ;; no encontró si el archivo se termina
		je finalizar_buscar_producto		
		;;; Si está vacío o fragmentado
		mov AL, 00
		cmp [prod_temp], AL
		je buscar_producto
		;;; verificar el código
		mov SI, offset prod_temp
		mov DI, offset productoCodigo
		mov CX, 0005
		call cadenas_iguales
		;;;; <<
		cmp DL, 0ff
		je producto_encontrado
		jmp buscar_producto
	producto_encontrado:
		mov dl, 0ff
	finalizar_buscar_producto:
		mov bx, [handleProductos]
		mov ah, 3e ; cerrar archivo
		int 21
	cmp DL, 0ff
	; si ya existe el producto
	je producto_ya_existe
	jmp pedir_de_nuevo_nombre
	producto_ya_existe:
	; imprimir que ya existe
		mov DX, offset producto_existe
		mov AH, 09
		int 21
		mov DX, offset nuevaLinea
		mov AH, 09
		int 21				
		jmp menu_productos
    ; PEDIR DESCRIPCION 

			;; PEDIR NOMBRE
			pedir_de_nuevo_nombre:
				;; SEPARACION
				mov DX, offset nuevaLinea
				mov AH, 09
				int 21	
				; LIMPIAR NOMBRE
				mov DI, offset productoNombre
				mov CX, 21
				call memset
				;; IMPRIMIR PROMPT
				mov DX, offset promptNombre
				mov AH, 09
				int 21
				;; LEER NOMBRE CON BUFFER
				mov DX, offset bufferEntrada
				mov AH, 0a
				int 21
				;; VERIFICAR QUE EL TAMAÑO DEL CODIGO NO SEA MAYOR A 5
				mov DI, offset bufferEntrada
				inc DI
				mov AL, [DI]
				cmp AL, 00
				je  pedir_de_nuevo_nombre ;; je --> jump if equal (si es igual a 0)	
				cmp AL, 21
				jb  aceptar_tam_nom ;; jb --> jump if below (si es menor a 32)			
				;; SEPARACION
				mov DX, offset nuevaLinea
				mov AH, 09
				int 21				
				jmp pedir_de_nuevo_nombre ;; jmp --> jump (salto incondicional)
				;;
			;; ACEPTAR TAMAÑO DEL NOMBRE		
			aceptar_tam_nom:
				mov SI, offset productoNombre
				mov DI, offset bufferEntrada
				inc DI
				mov CH, 00
				mov CL, [DI]
				inc DI  ;; me posiciono en el contenido del buffer
				;;
			;; IMPRIMIR EL NOMBRE		
			copiar_nombre:
				mov AL, [DI]
				; Si es , . ! continuar copiando
				cmp al, 2ch ; ,
				je continuar_copiando_nombre
				cmp al, 2eh ; .
				je continuar_copiando_nombre
				cmp al, 21h ; !
				je continuar_copiando_nombre
				; VERIFICAR REGEX [A-Z a-z 0-9] en hexadecimal 30-39 y 41-5A y 61-7A
				cmp al, 7ah
				ja pedir_de_nuevo_nombre
				cmp al, 30
				jb pedir_de_nuevo_nombre
				cmp al, 3ah
				jb continuar_copiando_nombre
				cmp al, 41
				jb pedir_de_nuevo_nombre
				cmp al, 5bh 
				jb continuar_copiando_nombre
				cmp al, 61
				jb pedir_de_nuevo_nombre  
			continuar_copiando_nombre:
				mov [SI], AL
				inc SI
				inc DI
				loop copiar_nombre  ;; restarle 1 a CX, verificar que CX no sea 0, si no es 0 va a la etiqueta, 
									;; la cadena ingresada en la estructura
				mov DX, offset nuevaLinea
				mov AH, 09
				int 21
				;;
			;; PEDIR PRECIO		
			pedir_de_nuevo_precio:
				mov DX, offset nuevaLinea
				mov AH, 09
				int 21
				mov DI, offset productoPrecio
				mov CX, 0005
				call memset
				mov DX, offset promptPrecio
				mov AH, 09
				int 21
				mov DX, offset bufferEntrada
				mov AH, 0a
				int 21
				;;; verificar que el tamaño del codigo no sea mayor a 5
				mov DI, offset bufferEntrada
				inc DI
				mov AL, [DI]
				cmp AL, 00
				je  pedir_de_nuevo_precio
				cmp AL, 03  ;; tamaño máximo del campo
				jb  aceptar_tam_precio ;; jb --> jump if below
				mov DX, offset nuevaLinea
				mov AH, 09
				int 21
				jmp pedir_de_nuevo_precio
				;;; mover al campo codigo en la estructura producto
			;; ACEPTAR TAMAÑO DEL PRECIO		
			aceptar_tam_precio:
				mov SI, offset productoPrecio
				mov DI, offset bufferEntrada
				inc DI
				mov CH, 00
				mov CL, [DI]
				inc DI  ;; me posiciono en el contenido del buffer
				;;
			;; IMPRIMIR EL PRECIO
			copiar_precio:
				mov AL, [DI]
				; verificar que es número
				cmp AL, 30
				jb pedir_de_nuevo_precio
				cmp AL, 39
				ja pedir_de_nuevo_precio
			seguir_copiando_precio:
				mov [SI], AL
				inc SI
				inc DI
				loop copiar_precio  ;; restarle 1 a CX, verificar que CX no sea 0, si no es 0 va a la etiqueta, 
				;;
				mov DX, offset nuevaLinea
				mov AH, 09
				int 21
				;;
				mov DI, offset productoPrecio
				call cadenaAnum
				;; AX -> numero convertido
				mov [productoPrecioNumero], AX
				;;
				mov DI, offset productoPrecio
				mov CX, 0005
				call memset
				;;
			;; PEDIR UNIDADES		
			pedir_de_nuevo_unidades:
				mov DX, offset nuevaLinea
				mov AH, 09
				int 21
				mov DI, offset productoUnidades
				mov CX, 0005
				call memset
				mov DX, offset promptUnidades
				mov AH, 09
				int 21
				mov DX, offset bufferEntrada
				mov AH, 0a
				int 21
				;;; verificar que el tamaño del codigo no sea mayor a 5
				mov DI, offset bufferEntrada
				inc DI
				mov AL, [DI]
				cmp AL, 00
				je  pedir_de_nuevo_unidades
				cmp AL, 03  ;; tamaño máximo del campo
				jb  aceptar_tam_unidades ;; jb --> jump if below
				mov DX, offset nuevaLinea
				mov AH, 09
				int 21
				jmp pedir_de_nuevo_unidades
				;;; mover al campo codigo en la estructura producto
			;; ACEPTAR TAMAÑO DE UNIDADES		
			aceptar_tam_unidades:
				mov SI, offset productoUnidades
				mov DI, offset bufferEntrada
				inc DI
				mov CH, 00
				mov CL, [DI]
				inc DI  ;; me posiciono en el contenido del buffer
				;;
			;; IMPRIMIR LAS UNIDADES		
			copiar_unidades:
				mov AL, [DI]
			; verificar que es número
				cmp AL, 30
				jb pedir_de_nuevo_unidades
				cmp AL, 39
				ja pedir_de_nuevo_unidades
			seguir_copiando_unidades:
				mov [SI], AL
				inc SI
				inc DI
				loop copiar_unidades  ;; restarle 1 a CX, verificar que CX no sea 0, si no es 0 va a la etiqueta, 
				;;
				mov DI, offset productoUnidades
				call cadenaAnum
				;; AX -> numero convertido
				mov [productoUnidadesNumero], AX
				;;
				mov DI, offset productoUnidades
				mov CX, 0005
				call memset
				;; finalizó pedir datos de producto
			;; GUARDAR EN ARCHIVO
				;; probar abrirlo normal
				mov AL, 02
				mov AH, 3d
				mov DX, offset archivoProductos
				int 21
				;; si no lo cremos
				jc  crear_archivo_prod
				;; si abre escribimos
				jmp guardar_handle_prod
			;; CREAR ARCHIVO BIN		
			crear_archivo_prod:
				mov CX, 0000
				mov DX, offset archivoProductos
				mov AH, 3c
				int 21
				;; archivo abierto+
				mov [handleProductos], AX
				; OBTENER HANDLE
				mov BX, [handleProductos]
				; VAMOS AL FINAL DEL ARCHIVO
				mov CX, 00
				mov DX, 00
				mov AL, 02
				mov AH, 42
				int 21
				jmp escribir_producto

			;; GUARDAR HANDLE		
			guardar_handle_prod:

				; GUARDAMOS HANDLE
			mov [handleProductos], AX
			; OBTENER HANDLE
			mov BX, [handleProductos]
			mov DX, 0000
			mov [punteroTemporal], DX
		
			ciclo_encontrar_productoVacio:
				int 03
				mov bx, [handleProductos]
				mov cx, 2a
				mov dx, offset prod_temp
				moV AH, 3f
				int 21
				cmp AX, 0000   ;; se acaba cuando el archivo se termina
				je avanzar_punteroAlFinal
				mov DX, [punteroTemporal]
				add DX, 2a
				mov [punteroTemporal], DX
				;;; verificar si es producto no válido
				mov AL, 00
				cmp [prod_temp], AL
				je avanzar_puntero
				jmp ciclo_encontrar_productoVacio
			avanzar_puntero:
				mov DX, [punteroTemporal]
				sub DX, 2a
				mov CX, 0000
				mov BX, [handleProductos]
				mov AL, 00
				mov AH, 42
				int 21
				jmp escribir_producto
				;;; puntero posicionado
			avanzar_punteroAlFinal:
				mov DX, [punteroTemporal]
				mov CX, 0000
				mov BX, [handleProductos]
				mov AL, 00
				mov AH, 42
				int 21            
			escribir_producto: ; ESCRIBIR EL PRODUCTO EN EL ARCHIVO
				;; escribir el producto en el archivo
				;; escribí los dos primeros campos
				mov CX, 26
				mov DX, offset productoCodigo
				mov AH, 40
				int 21
				;; escribo los otros dos
				mov CX, 0004
				mov DX, offset productoPrecioNumero
				mov AH, 40
				int 21

				;; limpiar los primeros dos
				mov DI, offset productoCodigo
				mov CX, 26
				call memset

				;; cerrar archivo
				mov AH, 3e
				int 21		
				;; SEPARACION
				mov DX, offset nuevaLinea
				mov AH, 09
				int 21
				;;
				jmp menu_productos
				;;
		;; 	ELIMINAR PRODUCTO		
		eliminar_producto_archivo:
			mov DX, 0000
			mov [punteroTemporal], DX
			;; SEPARACION
			mov DX, offset nuevaLinea
			mov AH, 09
			int 21
			;;
			mov DX, offset tituloProductoBorrar
			mov AH, 09
			int 21
			mov DX, offset separadorProductoBorrar
			mov AH, 09
			int 21
			;; PEDIR CODIGO PARA ELIMINAR			
			pedir_de_nuevo_codigo2:
				;; IMPRIMIR PROMPT
				mov DX, offset promptCodigo
				mov AH, 09
				int 21
				;; LEER CODIGO CON BUFFER
				mov DX, offset bufferEntrada
				mov AH, 0a
				int 21
				;; VERIFICAR QUE EL TAMAÑO DEL CODIGO NO SEA MAYOR A 5
				mov DI, offset bufferEntrada
				inc DI
				mov AL, [DI]
				cmp AL, 00
				;; Si es igual a 0
				je  pedir_de_nuevo_codigo2
				cmp AL, 05
				jb  aceptar_tam_cod2  ;; jb --> jump if below
				mov DX, offset nuevaLinea
				mov AH, 09
				int 21
				jmp pedir_de_nuevo_codigo2
				;;; mover al campo codigo en la estructura producto
			;; ACEPTAR TAMAÑO DEL CODIGO		
			aceptar_tam_cod2:
				mov SI, offset productoCodigoTemporal
				mov DI, offset bufferEntrada
				inc DI
				mov CH, 00
				mov CL, [DI]
				inc DI  ;; me posiciono en el contenido del buffer
			;; 	IMPRIMIR EL CODIGO		
			copiar_codigo2:	mov AL, [DI]
				mov [SI], AL
				inc SI
				inc DI
				loop copiar_codigo2  ;; restarle 1 a CX, verificar que CX no sea 0, si no es 0 va a la etiqueta, 
				;;; la cadena ingresada en la estructura
				;;;
				mov DX, offset nuevaLinea
				mov AH, 09
				int 21
				;;
				mov AL, 02              ;;;<<<<<  lectura/escritura
				mov DX, offset archivoProductos
				mov AH, 3d
				int 21
				mov [handleProductos], AX
				;; revisar si existe ->
			;; CICLO PARA ENCONTRAR EL PRODUCTO		
			ciclo_encontrar:
				mov BX, [handleProductos]
				mov CX, 26
				mov DX, offset productoCodigo
				moV AH, 3f
				int 21
				mov BX, [handleProductos]
				mov CX, 4
				mov DX, offset productoPrecioNumero
				moV AH, 3f
				int 21
				cmp AX, 0000   ;; se acaba cuando el archivo se termina
				je producto_no_encontrado
				mov DX, [punteroTemporal]
				add DX, 2a
				mov [punteroTemporal], DX
				;;; verificar si es producto válido
				mov AL, 00
				cmp [productoCodigo], AL
				je ciclo_encontrar
				;;; verificar el código
				mov SI, offset productoCodigoTemporal
				mov DI, offset productoCodigo
				mov CX, 0005
				call cadenas_iguales
				;;;; <<
				cmp DL, 0ff
				je borrar_encontrado							

				jmp ciclo_encontrar
				;;
			producto_no_encontrado:
				mov DX, offset nuevaLinea
				mov AH, 09
				int 21
				mov DX, offset nuevaLinea
				mov AH, 09
				int 21
				mov DX, offset productono_encontrado
				mov AH, 09
				int 21
				jmp finalizar_borrar
			;; BORRAR EL ENCONTRADO		
			borrar_encontrado:
				mov DX, [punteroTemporal]
				sub DX, 2a
				mov CX, 0000
				mov BX, [handleProductos]
				mov AL, 00
				mov AH, 42
				int 21
				;;; puntero posicionado
				mov CX, 2a
				mov DX, offset ceros
				mov AH, 40
				int 21
				mov DX, offset nuevaLinea
				mov AH, 09
				int 21
				mov DX, offset nuevaLinea
				mov AH, 09
				int 21
				;; notificar que se borró
				mov DX, offset producto_eliminado
				mov AH, 09
				int 21				
				;;
			;; FINALIZAR LA ACCIÓN DE BORRAR		
			finalizar_borrar:
				mov BX, [handleProductos]
				mov AH, 3e
				int 21
				mov DX, offset nuevaLinea
				mov AH, 09
				int 21
				mov DX, offset nuevaLinea
				mov AH, 09
				int 21
				;; limpiar los primeros dos
				mov DI, offset productoCodigo
				mov CX, 26
				call memset

				jmp menu_productos
				
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; MENU DE VENTAS
	menu_ventas:
		; SEPARACION
		mov DX, offset nuevaLinea
		mov AH, 09
		int 21

		; MOSTRAR MENU ventas
		mov DX, offset tituloVentas
		mov AH, 09
		int 21
		mov DX, offset separadorVentas
		mov AH, 09
		int 21

		; OPCIONES
		mov DX, offset opcionVentasIngresar
		mov AH, 09
		int 21
		mov DX, offset regresar
		mov AH, 09
		int 21	

		; IMPRIMIR PROMPT
		mov DX, offset separadorPrompt
		mov AH, 09
		int 21
		mov DX, offset prompt
		mov AH, 09
		int 21

		; LEER 1 CARACTER
		mov AH, 08
		int 21	;; AL = CARACTER LEIDO

		; IR A LA REGISTRAR VENTA
		cmp AL, 69 
		je registrar_venta	

		; REGRESAR AL MENU PRINCIPAL
		cmp AL, 72 
		je menu_principal	

		; SEGUIR CON EL MENU DE VENTAS				
		jmp menu_ventas
		
		; REGISTRAR VENTA
		registrar_venta:
			; Reestablecer monto total 
			mov dx, 0000
			mov [ventaMontoTotalNumero], dx

			; Reestablecer el contador de items en 1.
			mov dl, 0001
			mov [contadorItemsVenta], dl

			; Reestablecer el puntero de items
			mov dx, 0000
			mov [punteroItems], dx
			
			;; OBTENER FECHA Y HORA
			obtener_fecha:
				; Obtener la fecha actual
				mov ah, 2ah
				int 21h
				; Guardar la fecha
				mov [diaVenta], dl
				mov [mesVenta], dh
				mov [anioVenta], cx

			obtener_hora:
				; Obtener la hora actual
				mov ah, 2ch
				int 21h

				; Guardar la hora actual
				mov [horaVenta], ch
				mov [minutoVenta], cl

			;; ABRIR ARCHIVO DE VENTAS
			abrir_archivo_ventas:
				; Intentar abrir el archivo de productos
				mov al, 02
				mov ah, 3d
				mov dx, offset archivoVentas
				int 21

				; Si no existe, crearlo
				jc  crear_archivo_ventas

				; Si existe, guardar el handle
				jmp guardar_handle_ventas
			
			;; CREAR ARCHIVO DE VENTAS
			crear_archivo_ventas:
				; Crear el archivo de ventas
				mov cx, 0000
				mov dx, offset archivoVentas
				mov ah, 3ch
				int 21h
			
			;; GUARDAR HANDLE DEL ARCHIVO DE VENTAS
			guardar_handle_ventas:
				; Guardar el handle del archivo
				mov [handleVentas], ax
				mov bx, [handleVentas]

				; Mover el puntero del archivo al final
				mov cx, 0000
				mov dx, 0000
				mov al, 02h
				mov ah, 42h
				int 21h

			;; AÑADIR ITEM A LA VENTA
			agregar_item:
				; PUNTERO TEMPORAL
				mov DX, 0000
				mov [punteroTemporal], DX
	
				; SEPARACION
				mov DX, offset nuevaLinea
				mov AH, 09
				int 21

				; MOSTRAR ENCABEZADO
				mov DX, offset tituloVentasIngresar
				mov AH, 09
				int 21
				mov DX, offset separadorVentasIngresar
				mov AH, 09
				int 21
				
				; PEDIR CODIGO
				pedir_codigo_ventas:
					; IMPRIMIR PROMPT PARA CODIGO
					mov DX, offset promptCodigo
					mov AH, 09
					int 21

					; LEER CODIGO CON BUFFER
					mov DX, offset bufferEntrada
					mov AH, 0a
					int 21

					; VERIFICAR QUE EL TAMAÑO DEL CODIGO NO SEA MAYOR A 5
					mov DI, offset bufferEntrada
					inc DI
					mov AL, [DI]

					; Si es igual a 0 pedir de nuevo
					cmp AL, 00					
					je  pedir_codigo_ventas ;; je --> jump if equal (si es igual a 0)

					; Si es menor a 5 pasar a verificar 
					cmp AL, 05
					jb  aceptar_codigo_ventas  ;; jb --> jump if below (si es menor a 5)

					; SEPARACION
					mov DX, offset nuevaLinea
					mov AH, 09
					int 21

					; Pedir de nuevo
					jmp pedir_codigo_ventas	;; jmp --> jump (salto incondicional)
					
				;; ACEPTAR TAMAÑO DEL CODIGO		
				aceptar_codigo_ventas:
					; Copiar el código a la estructura 
					mov SI, offset ventaCodigoTemporal
					mov DI, offset bufferEntrada
					inc DI
					mov CH, 00
					mov CL, [DI]
					inc DI  ;; me posiciono en el contenido del buffer

				;; IMPRIMIR EL CÓDIGO		
				imprimir_codigo_ventas:
					; Mostrar el código
					mov AL, [DI]
					mov [SI], AL
					inc SI
					inc DI
					loop imprimir_codigo_ventas  ;; restarle 1 a CX, verificar que CX no sea 0, si no es 0 va a la etiqueta, 
													;; la cadena ingresada en la estructura
					; SEPARACION
					mov DX, offset nuevaLinea
					mov AH, 09
					int 21

					; Verificar si es fin
					mov SI, offset ventaCodigoTemporal
					mov DI, offset cadenaFin
					mov CX, 0005
					call cadenas_iguales
					cmp DL, 0ff

					; Si es finalizar venta
					je finalizar_ventas

					; Si no es abrir archivo de productos					
					mov AL, 02              ;;;<<<<<  lectura/escritura
					mov DX, offset archivoProductos
					mov AH, 3d
					int 21
					
					jc registrar_venta

					mov [handleProductos], AX

				;; CICLO PARA ENCONTRAR EL PRODUCTO		
				ciclo_encontrar_producto_ventas:
					; Puntero en el código del producto
					mov BX, [handleProductos]
					mov CX, 26
					mov DX, offset ventaCodigo
					moV AH, 3f
					int 21

					; Puntero en el precio del producto
					mov BX, [handleProductos]
					mov CX, 4
					mov DX, offset ventaPrecioNumero
					moV AH, 3f
					int 21

					; Comparar si se termino el archivo para finalizar venta 
					; (o lanzar mensaje de que no encontró)
					cmp AX, 0000   
					je finalizar_ventas

					; verificar si es producto válido
					mov AL, 00
					cmp [ventaCodigo], AL
					je ciclo_encontrar_producto_ventas

					; verificar el código con el código ingresado
					mov SI, offset ventaCodigoTemporal
					mov DI, offset ventaCodigo
					mov CX, 0005

					;; Verificar las cadenas
					call cadenas_iguales
					cmp DL, 0ff

					; Mostrar en pantalla el producto
					;je imprimir_encontrado
					je verificar_stock

					; Seguir buscando
					jmp ciclo_encontrar_producto_ventas
					
				verificar_stock:
					mov ax, [ventaUnidadesNumero]
					cmp ax, 0000
					jne imprimir_encontrado


					jmp agregar_item

				;; IMPRIMIR ESTRUCTURA
				imprimir_encontrado:
					; Posicionar en descipcion		
					mov DI, offset ventaDescripcion
					
				;; CICLO PARA PONER $		
				ciclo_poner_dolar_3:
					mov AL, [DI]
					cmp AL, 00
					je poner_dolar_3
					inc DI
					jmp ciclo_poner_dolar_3
					
				;; PONER $ 		
				poner_dolar_3:
					; Poner dolar
					mov AL, 24  ;; dólar
					mov [DI], AL

					; Imprimir la descripción
					mov DX, offset separadorMenu
					mov AH, 09
					int 21
					mov DX, offset promptNombre
					mov AH, 09
					int 21
					mov DX, offset ventaDescripcion
					mov AH, 09
					int 21
					mov DX, offset nuevaLinea
					mov AH, 09
					int 21	
					
					; Impresión del precio 
					mov DX, offset promptPrecio
					mov AH, 09
					int 21	

					mov AX, [ventaPrecioNumero]
					call numAcadena

					mov BX, 0001
					mov CX, 0005
					mov DX, offset numero
					mov AH, 40
					int 21

					mov DX, offset nuevaLinea
					mov AH, 09
					int 21

					; Impresión de unidades
					mov DX, offset promptUnidades
					mov AH, 09
					int 21

					mov AX, [ventaUnidadesNumero]
					call numAcadena
					
					mov BX, 0001
					mov CX, 0005
					mov DX, offset numero
					mov AH, 40
					int 21

					mov DX, offset nuevaLinea
					mov AH, 09
					int 21
					
					; Separación
					mov DX, offset separadorMenu
					mov AH, 09
					int 21		
					
				;; PEDIR UNIDADES		
				pedir_de_nuevo_cantidades:		
					; Pedir cantidad a requerir 		
					mov DX, offset promptCantidad
					mov AH, 09
					int 21	
					mov DX, offset bufferEntrada
					mov AH, 0a
					int 21

					; verificar que el tamaño del codigo no sea mayor a 5
					mov DI, offset bufferEntrada
					inc DI
					mov AL, [DI]

					; Si es igual a 0 pedir de nuevo
					cmp AL, 00
					je  pedir_de_nuevo_cantidades

					; Si es menor a 5 pasar a verificar
					cmp AL, 06  ;; tamaño máximo del campo
					jb  aceptar_tam_cantidades ;; jb --> jump if below

					mov DX, offset nuevaLinea
					mov AH, 09
					int 21

					; Pedir de nuevo
					jmp pedir_de_nuevo_cantidades

				;; ACEPTAR TAMAÑO DE UNIDADES		
				aceptar_tam_cantidades:
					;; Copiar la cantidad a la estructura
					mov SI, offset ventaCantidadTemporal
					mov DI, offset bufferEntrada
					inc DI
					mov CH, 00
					mov CL, [DI]
					inc DI  ;; me posiciono en el contenido del buffer

				;; IMPRIMIR LAS UNIDADES		
				copiar_cantidades:
					; Impresión de unidades
					mov AL, [DI]
					mov [SI], AL
					inc SI
					inc DI
					loop copiar_cantidades  ;; restarle 1 a CX, verificar que CX no sea 0, si no es 0 va a la etiqueta, 
					
					; Conversion de cadena a numero
					mov DI, offset ventaCantidadTemporal
					call cadenaAnum ;; AX -> numero convertido				
					mov [ventaCantidadNumero], AX
					
					; Limpieza de variable cantidad
					mov DI, offset ventaCantidadTemporal
					mov CX, 0005
					call memset

					jmp modificar_producto

				;;verificar_existencias_disponibles:
				;;	mov ax, [ventaCantidadNumero]
				;;	cmp ax, [ventaUnidadesNumero]
				;;	jl sin_existencias_disponibles
				;;	jmp modificar_producto	
;;
				;;sin_existencias_disponibles:
				;;	jmp agregar_item		
				
			modificar_producto:
				mov al, 02
				mov dx, offset archivoProductos
				mov ah, 3dh
				int 21h
				mov [handleProductos], ax


				ciclo_modificar_producto:
					mov bx, [handleProductos]
					mov cx, 26h
					mov dx, offset ventaCodigo
					mov ah, 3f
					int 21h

					; Puntero en el precio del producto
					mov bx, [handleProductos]
					mov cx, 04h
					mov dx, offset ventaPrecioNumero
					mov ah, 3f
					int 21h

					; Comparar si se termino el archivo para finalizar venta 
					; (o lanzar mensaje de que no encontró)
					cmp AX, 0000   
					je finalizar_ventas

					; Operaciones de puntero
					mov dx, [punteroTemporal]
					add dx, 2ah
					mov [punteroTemporal], dx

					; verificar si es producto válido
					mov AL, 00
					cmp [ventaCodigo], AL
					je ciclo_encontrar_producto_ventas

					; verificar el código con el código ingresado
					mov SI, offset ventaCodigoTemporal
					mov DI, offset ventaCodigo
					mov CX, 0005

					;; Verificar las cadenas
					call cadenas_iguales
					cmp DL, 0ff

					je restar_existencias_producto
            		jmp ciclo_modificar_producto

				restar_existencias_producto:
					; Posicionar puntero para el offset de la interrupcion
					mov dx, [punteroTemporal]
					sub dx, 2ah
					mov cx, 0000
					
					; Mover el puntero
					mov bx, [handleProductos]
					mov al, 00
					mov ah, 42h
					int 21h

					; Restar las unidades vendidas
					mov ax, [ventaUnidadesNumero]
					sub ax, [ventaCantidadNumero]
					mov [ventaUnidadesNumero], ax

					; Escribir el nuevo contenido con las unidades restadas
					mov cx, 2ah
					mov dx, offset ventaCodigo
					mov ah, 40h
					int 21h

					; Cerrar el archivo para guardar cambios
					mov bx, [handleProductos]
					mov ah, 3eh
					int 21h

				;; CALCULAR MONTO
					; IMPRIMIR MONTO
					mov DX, offset nuevaLinea
					mov AH, 09
					int 21	

					mov DX, offset promptMonto
					mov AH, 09
					int 21		

					; MULTIPLICACION
					mov AX,  [ventaPrecioNumero]
					mul ventaCantidadNumero ; resultado en AX
					mov [ventaMontoNumero], AX ; guardo el monto

					mov AX, [ventaMontoNumero]
					call numAcadena ;; [numero] tengo la cadena convertida
					mov BX, 0001
					mov CX, 0005

					mov DX, offset numero
					mov AH, 40
					int 21

					; IMPRIMIR MONTO TOTAL
					mov DX, offset nuevaLinea
					mov AH, 09
					int 21

					mov DX, offset promptMontoTotal
					mov AH, 09
					int 21	

					; SUMA DEL MONTO TOTAL
					mov DI, [ventaMontoNumero]
					add [ventaMontoTotalNumero], DI	
					
					mov AX, [ventaMontoTotalNumero]
					call numAcadena ;; [numero] tengo la cadena convertida

					mov BX, 0001
					mov CX, 0005
					mov DX, offset numero
					mov AH, 40
					int 21
					
					; Separación
					mov DX, offset nuevaLinea
					mov AH, 09
					int 21

					; Escribir en el archivo
					jmp escribir_nuevo_item					

				;; ESCRIBIR NUEVO ITEM EN EL ARCHIVO
				escribir_nuevo_item:
					mov ah, 0000h
					mov al, 7h
					mov bh, 0000h
					mov bl, [contadorItemsVenta]
					mul bx
					mov [punteroItems], ax	

					mov cx, offset bytesItems
					mov bx, [punteroItems]
					add cx, bx
					mov [direccionItem], cx

					mov si, [direccionItem]
					mov di, offset ventaCodigo
					mov ch, 00
					mov cl, 0005

					copiar_codigo_item:
						mov al, [di]
						mov [si], al
						inc si
						inc di
						loop copiar_codigo_item

					mov di, offset ventaCantidadNumero
					mov ch, 00
					mov cl, 0004

					copiar_unidades_item:
						mov al, [di]
						mov [si], al
						inc si
						inc di
						loop copiar_unidades_item	

					; Limpiar la variable ventaCodigo y ventaDescripcion
					mov di, offset ventaCodigo
					mov cx, 26
					call memset

					; Limpiar la variable ventaCodigo y ventaDescripcion
					mov di, offset ventaCantidadTemporal
					mov cx, 26
					call memset

					; Limpiar la variable ventaCantidadNumero
					mov dx, 0000
					mov [ventaCantidadNumero], dx

					; Limpiar la variable del monto 
					mov dx, 0000
					mov [ventaMontoNumero], dx
					
					; Verificar el contador de items
					mov dl, contadorItemsVenta
					cmp dl, 000ah
					je finalizar_ventas

					; Incrementar contador para agregar otro item
					inc dl
					mov [contadorItemsVenta], dl
					jmp agregar_item

				;; FINALIZAR LA ACCIÓN DE BORRAR		
				finalizar_ventas:
					; CEERRAR ARCHIVO PRODS
					mov BX, [handleProductos]
					mov AH, 3e
					int 21

					; Escribir la fecha y hora en el archivo de ventas
					mov bx, [handleVentas]
					mov cx, 06h
					mov dx, offset diaVenta
					mov ah, 40
					int 21h

					; Escribir los items de la venta
					mov bx, [handleVentas]
					mov cx, 46h
					mov dx, offset bytesItems
					mov ah, 40h
					int 21h

					; Escribir el monto total de la venta
					mov bx, [handleVentas]
					mov cx, 0002
					mov dx, offset ventaMontoTotalNumero
					mov ah, 40h
					int 21h

					; Limpiar la variable direccionItem
					mov dx, 0000
					mov [direccionItem], dx

					; Limpiar la variable bytesItems
					mov di, offset bytesItems
					mov cx, 0046h
					call memset

					; Cerrar el archivo
					mov bx, [handleVentas]
					mov ah, 3eh
					int 21h

					; Regresar al menu de ventas
					jmp menu_ventas

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	menu_herramientas:
		; SEPARACION
		mov DX, offset nuevaLinea
		mov AH, 09
		int 21
		; MOSTRAR MENU herramientas
		mov DX, offset tituloHerramientas
		mov AH, 09
		int 21
		mov DX, offset separadorHerramientas
		mov AH, 09
		int 21
		; OPCIONES
		mov DX, offset catalogoCompleto
		mov AH, 09
		int 21
		mov DX, offset alfabeticoProductos
		mov AH, 09
		int 21
		mov DX, offset reporteVentas
		mov AH, 09
		int 21
		mov DX, offset productosSinExistencias
		mov AH, 09
		int 21
		mov DX, offset regresar
		mov AH, 09
		int 21
		;; SEPARACION
		mov DX, offset separadorPrompt
		mov AH, 09
		int 21
		;; IMPRIMIR PROMPT
		mov DX, offset prompt
		mov AH, 09
		int 21
		;; LEER 1 CARACTER
		mov AH, 08
		int 21 ;; AL = CARACTER LEIDO

		;; MUESTRA EL CATALOGO COMPLETO
		cmp AL, 63 ;; entrada -> c
		je generar_catalogoCompleto
		;; MUESTRA LOS PRODUCTOS EN ORDEN ALFABETICO
		cmp AL, 61 ;; entrada -> a
		je generar_rep_alfabetico
		;; MUESTRA EL REPORTE DE VENTAS
		cmp AL, 76 ;; entrada -> v
		je reporte_ventas
		;; MUESTRA LOS PRODUCTOS SIN EXISTENCIAS
		cmp AL, 70 ;; entrada -> p
		je generar_reporte_existencias	
		;; MUESTRA EL MENU PRINCIPAL						
		cmp AL, 72 ;; entrada -> r
		je menu_principal		
		;; SEGUIR CON EL MENU DE HERRAMIENTAS
		jmp menu_herramientas

		generar_catalogoCompleto:
			; SEPARACION
			mov DX, offset nuevaLinea
			mov AH, 09
			int 21

			; MOSTRAR ENCABEZADO
			mov DX, offset tituloCatalogoCompleto
			mov AH, 09
			int 21
			mov DX, offset separadorHerramientasCatalogo
			mov AH, 09
			int 21

			; MENSAJE DE GENERANDO CATALOGO
			mov DX, offset reporteGenerado
			mov AH, 09
			int 21

			;;interrumpcion create a file with a handle 
			mov AH, 3c
			mov CX, 0000
			mov DX, offset archivoCatalogo
			int 21
			;; el file handle se almacena en Ax 
			mov [handleCatalogo], AX

			;;interrumpcion WRITE TO FILE WITH HANDLE para escribir el encabezado del html 
			;;<!DOCTYPE html><html><head>" 
			mov BX, AX  ;; bx es el handle 
			mov AH, 40
			mov CH, 00 ;; limpio CH 
			mov CL, [tam_encabezado_html]
			mov DX, offset encabezado_html
			int 21

			;; <title>Catalogo</title>"
			mov BX, [handleCatalogo]
			mov AH, 40
			mov CH, 00
			mov CL, [tam_tit_Catalogo_html]
			mov DX, offset tit_Catalogo_html
			int 21
			
			;;"</head>"
			mov BX, [handleCatalogo]
			mov AH, 40
			mov CH, 00
			mov CL, [tam_style_Table_html]
			mov DX, offset style_Table_html
			int 21

			;; "<body><h1>Catalogo Completo de Productos</h1>"
			mov BX, [handleCatalogo]
			mov AH, 40
			mov CH, 00
			mov CL, [tam_style_Th_html]
			mov DX, offset style_Th_html
			int 21

			;;abriendo <table>
			mov BX, [handleCatalogo]
			mov AH, 40
			mov CH, 00
			mov CL, [tam_cierre_style]
			mov DX, offset cierre_style
			int 21

			;; <tr> 
			mov BX, [handleCatalogo]
			mov AH, 40
			mov CH, 00
			mov CL, [tam_cierre_head]
			mov DX, offset cierre_head
			int 21

			;; <tr> 
			mov BX, [handleCatalogo]
			mov AH, 40
			mov CH, 00
			mov CL, [tam_body_Cataologo_html]
			mov DX, offset body_Cataologo_html
			int 21

			;; "<th>Descripción</th> <th>Código</th> <th>Precio</th> <th>Unidades"
			mov BX, [handleCatalogo]
			mov AH, 40
			mov CH, 00
			mov CL, [tam_apertura_table]
			mov DX, offset apertura_table
			int 21

			mov BX, [handleCatalogo]
			mov AH, 40
			mov CH, 00
			mov CL, [tam_apertura_tr]
			mov DX, offset apertura_tr
			int 21

			mov BX, [handleCatalogo]
			mov AH, 40
			mov CH, 00
			mov CL, [tam_titulos_html]
			mov DX, offset titulos_html
			int 21

			;;</th>
			mov BX, [handleCatalogo]
			mov AH, 40
			mov CH, 00
			mov CL, 05
			mov DX, offset cierre_th
			int 21

			;; </tr> 
			mov BX, [handleCatalogo]
			mov AH, 40
			mov CH, 00
			mov CL, [tam_cierre_tr]
			mov DX, offset cierre_tr
			int 21
			
			;; OPEN DISK FILE WITH HANDLE 
			mov AH, 3d
			mov AL, 02
			mov DX, offset archivoProductos
			int 21

			mov [handleProductos], AX

		ciclo_mostrar_catologo:
			;; READ FROM FILE WITH HANDLE
			mov BX, [handleProductos]
			mov CX, 26     ;; leer 26h bytes
			mov DX, offset productoCodigo
			mov AH, 3f
			int 21
			;; puntero avanzó
			mov BX, [handleProductos]
			mov CX, 0004
			mov DX, offset productoPrecioNumero
			mov AH, 3f
			int 21

			;; verificar que no sea nulo, si es termina 
			cmp AX, 00
			je fin_mostrar_catologo

			;; ver si es producto válido
			mov AL, 00
			cmp [productoCodigo], AL
			je ciclo_mostrar_catologo

			;; llamar a la sub-rutina 
			call imprimir_estructura_html

			jmp ciclo_mostrar_catologo
			
		fin_mostrar_catologo:
			;; </table>
			mov BX, [handleCatalogo]
			mov AH, 40
			mov CH, 00
			mov CL, [tam_cierre_table]
			mov DX, offset cierre_table
			int 21
			;; OBTENER FECHA 
			mov ah, 2a
			int 21
			mov [dia], dl
			mov [mes], dh
			mov [anio], cx
			;;OBTENER HORA 
			mov ah, 2ch
			int 21h
			mov [hora], ch
			mov [minutos], cl

			;; <p>Fecha:
			mov BX, [handleCatalogo]
			mov AH, 40
			mov CH, 00
			mov CL, [tam_fecha_html]
			mov DX, offset fecha_html
			int 21
			;; ESCRIBIR DIA	
			mov AL, [dia]
			mov AH, 00 
			call numAcadena 
			mov BX, [handleCatalogo]
			mov CX, 02
			mov DX, offset numero
			inc dx
			inc dx 
			inc dx
			mov AH, 40
			int 21
			;; /
			mov BX, [handleCatalogo]
			mov AH, 40
			mov CH, 00
			mov CL, 01
			mov DX, offset diagonal
			int 21
			;; ESCRIBIR MES	
			mov AL, [mes]
			mov AH, 00 
			call numAcadena
			mov BX, [handleCatalogo]
			mov CX, 02
			mov DX, offset numero
			inc dx
			inc dx 
			inc dx
			mov AH, 40
			int 21
			;; /
			mov BX, [handleCatalogo]
			mov AH, 40
			mov CH, 00
			mov CL, 01
			mov DX, offset diagonal
			int 21
			;; ESCRIBIR ANIO	
			mov AX, [anio]
			call numAcadena
			mov BX, [handleCatalogo]
			mov CX, 04
			mov DX, offset numero
			inc dx
			mov AH, 40
			int 21
			;; </p>
			mov BX, [handleCatalogo]
			mov AH, 40
			mov CH, 00
			mov CL, [tam_cierre_p]
			mov DX, offset cierre_p
			int 21

			;; <p>Hora:
			mov BX, [handleCatalogo]
			mov AH, 40
			mov CH, 00
			mov CL, [tam_hora_html]
			mov DX, offset hora_html
			int 21
			;; ESCRIBIR HORA	
			mov AL, [hora]
			mov AH, 00 
			call numAcadena 
			mov BX, [handleCatalogo]
			mov CX, 02
			mov DX, offset numero
			inc dx
			inc dx 
			inc dx
			mov AH, 40
			int 21
			;; : 
			mov BX, [handleCatalogo]
			mov AH, 40
			mov CH, 00
			mov CL, 01
			mov DX, offset dosPuntos
			int 21
			;; ESCRIBIR MINUTOS 	
			mov AL, [minutos]
			mov AH, 00 
			call numAcadena 
			mov BX, [handleCatalogo]
			mov CX, 02
			mov DX, offset numero
			inc dx
			inc dx 
			inc dx
			mov AH, 40
			int 21

			;; </body>
			mov BX, [handleCatalogo]
			mov AH, 40
			mov CH, 00
			mov CL, [tam_cierre_body]
			mov DX, offset cierre_body
			int 21
			;; </html>
			mov BX, [handleCatalogo]
			mov AH, 40
			mov CH, 00
			mov CL, [tam_cierre_html]
			mov DX, offset cierre_html
			int 21

			;; CLOSE A FILE WITH HANDLE
			mov AH, 3e
			int 21

			jmp menu_herramientas

		imprimir_estructura_html:
			;; <tr> 
			mov BX, [handleCatalogo]
			mov AH, 40
			mov CH, 00
			mov CL, [tam_apertura_tr]
			mov DX, offset apertura_tr
			int 21

			;; <td> 
			mov BX, [handleCatalogo]
			mov AH, 40
			mov CH, 00
			mov CL, [tam_apertura_td]
			mov DX, offset apertura_td
			int 21

			;;dx toma el valor del codigo 
			mov DX, offset productoCodigo
			;;contador que inicia en 0 
			mov SI, 0000

		ciclo_escribir_codigo:
			mov DI, DX
			mov AL, [DI]
			;;valida si no es nulo, si lo es se va a 
			cmp AL, 00
			je escribir_descripcion
			;;valida que la cadena se encuentra llena 
			cmp SI, 0006
			je escribir_descripcion

			;;write to file with handle ---> escribir 
			mov CX, 0001
			mov BX, [handleCatalogo]
			mov AH, 40
			int 21

			inc DX  ;; <-- para que se vaya la siguiente byte 
			inc SI  ;; <-- si se escribe algo en el arcribo, aumenta el contador 

			jmp ciclo_escribir_codigo

		escribir_descripcion:
			;; </td>
			mov BX, [handleCatalogo]
			mov AH, 40
			mov CH, 00
			mov CL, [tam_cierre_td]
			mov DX, offset cierre_td
			int 21
			;; <td>
			mov BX, [handleCatalogo]
			mov AH, 40
			mov CH, 00
			mov CL, [tam_apertura_td]
			mov DX, offset apertura_td
			int 21

			;; dx toma el valor de la descripcion 
			mov DX, offset productoNombre
			mov SI, 0000

		ciclo_escribir_descripcion:
			mov DI, DX
			mov AL, [DI]
			;;valida si no es nulo, si lo es se va a 
			cmp AL, 00
			je escribir_precio
			;;valida que la cadena se encuentra llena 
			cmp SI, 0021
			je escribir_precio

			;;write to file with handle ---> esceribir 
			mov CX, 0001
			mov BX, [handleCatalogo]
			mov AH, 40
			int 21

			inc DX  ;; <-- para que se vaya la siguiente byte 
			inc SI  ;; <-- si se escribe algo en el arcribo, aumenta el contador 
			jmp ciclo_escribir_descripcion

		escribir_precio:
			;; </td>
			mov BX, [handleCatalogo]
			mov AH, 40
			mov CH, 00
			mov CL, [tam_cierre_td]
			mov DX, offset cierre_td
			int 21
			;; <td>
			mov BX, [handleCatalogo]
			mov AH, 40
			mov CH, 00
			mov CL, [tam_apertura_td]
			mov DX, offset apertura_td
			int 21
			;; dx toma el valor de precio
			mov AX, [productoPrecioNumero]
			call numAcadena

			mov DX, offset numero
			mov SI, 0000

		ciclo_escribir_precio: 
			mov DI, DX
			mov AL, [DI]
			;;valida si no es nulo, si lo es se va a 
			cmp AL, 00
			je escribir_unidades
			;;valida que la cadena se encuentra llena 
			cmp SI, 0006
			je escribir_unidades

			;;write to file with handle ---> esceribir 
			mov CX, 0001
			mov BX, [handleCatalogo]
			mov AH, 40
			int 21

			inc DX  ;; <-- para que se vaya la siguiente byte 
			inc SI  ;; <-- si se escribe algo en el arcribo, aumenta el contador 
			jmp ciclo_escribir_precio

		escribir_unidades:
			;; </td>
			mov BX, [handleCatalogo]
			mov AH, 40
			mov CH, 00
			mov CL, [tam_cierre_td]
			mov DX, offset cierre_td
			int 21
			;; <td>
			mov BX, [handleCatalogo]
			mov AH, 40
			mov CH, 00
			mov CL, [tam_apertura_td]
			mov DX, offset apertura_td
			int 21
			;; dx toma el valor de unidades
			mov AX, [productoUnidadesNumero]
			call numAcadena
			mov DX, offset numero
			mov SI, 0000

		ciclo_escribir_unidades:
			mov DI, DX
			mov AL, [DI]
			;;valida si no es nulo, si lo es se va a 
			cmp AL, 00
			je cerrar_table
			;;valida que la cadena se encuentra llena 
			cmp SI, 0006
			je cerrar_table

			;;write to file with handle ---> esceribir 
			mov CX, 0001
			mov BX, [handleCatalogo]
			mov AH, 40
			int 21

			inc DX  ;; <-- para que se vaya la siguiente byte 
			inc SI  ;; <-- si se escribe algo en el arcribo, aumenta el contador 
			jmp ciclo_escribir_unidades

		cerrar_table:
			;; </td>
			mov BX, [handleCatalogo]
			mov AH, 40
			mov CH, 00
			mov CL, [tam_cierre_td]
			mov DX, offset cierre_td
			int 21
			;; </tr>
			mov BX, [handleCatalogo]
			mov AH, 40
			mov CH, 00
			mov CL, [tam_cierre_tr]
			mov DX, offset cierre_tr
			int 21

			;;llamada de sub-rutina para hora 
			;;call retornar_fecha_hora

			;;mov dx, offset dia
			;;mov ah, 9
			;;int 21h

			ret
		;
		generar_rep_alfabetico:
			; SEPARACION
			mov DX, offset nuevaLinea
			mov AH, 09
			int 21

			; MOSTRAR ENCABEZADO
			mov DX, offset tituloAlfabeticoProductos
			mov AH, 09
			int 21
			mov DX, offset separadorHerramientasAlfabetico
			mov AH, 09
			int 21

			; MENSAJE DE GENERANDO CATALOGO
			mov DX, offset reporteGenerado
			mov AH, 09
			int 21

			; Crear el archivo
			mov AH, 3c
			mov CX, 0000
			mov DX, offset archivoAlfabetico
			int 21

			; Almacenar el file handle
			mov [handleAlfabetico], AX


			; ----------------- ESCRIBIR LA ESTRUCTURA HTML -----------------
			;;<!DOCTYPE html><html><head>" 
			mov BX, AX  ;; bx es el handle 
			mov AH, 40
			mov CH, 00 ;; limpio CH 
			mov CL, [tam_encabezado_html]
			mov DX, offset encabezado_html
			int 21
			;; <title>Reporte</title>"
			mov BX, [handleAlfabetico]
			mov AH, 40
			mov CH, 00
			mov CL, [tam_tit_Catalogo_html]
			mov DX, offset tit_Catalogo_html
			int 21

			;style
			mov BX, [handleAlfabetico]
			mov AH, 40
			mov CH, 00
			mov CL, [tam_style_Table_html]
			mov DX, offset style_Table_html
			int 21

			;th, td
			mov BX, [handleAlfabetico]
			mov AH, 40
			mov CH, 00
			mov CL, [tam_style_Th_html]
			mov DX, offset style_Th_html
			int 21

			;cierre style
			mov BX, [handleAlfabetico]
			mov AH, 40
			mov CH, 00
			mov CL, [tam_cierre_style]
			mov DX, offset cierre_style
			int 21

			;;"</head>"
			mov BX, [handleAlfabetico]
			mov AH, 40
			mov CH, 00
			mov CL, [tam_cierre_head]
			mov DX, offset cierre_head
			int 21
			;; <h1>Reporte Alfabetico de Productos</h1>
			mov BX, [handleAlfabetico]
			mov AH, 40
			mov CH, 00
			mov CL, [tam_body_Rep_alfa_html]
			mov DX, offset body_Rep_alfa_html
			int 21
			;;abriendo <table>
			mov BX, [handleAlfabetico]
			mov AH, 40
			mov CH, 00
			mov CL, [tam_apertura_table]
			mov DX, offset apertura_table
			int 21
			;; <tr> 
			mov BX, [handleAlfabetico]
			mov AH, 40
			mov CH, 00
			mov CL, [tam_apertura_tr]
			mov DX, offset apertura_tr
			int 21
			;; <th>Letra</th><th>Cantidad de Productos
			mov BX, [handleAlfabetico]
			mov AH, 40
			mov CH, 00
			mov CL, [tam_titulos_alfa_html]
			mov DX, offset titulos_alfa_html
			int 21
			;;</th>
			mov BX, [handleAlfabetico]
			mov AH, 40
			mov CH, 00
			mov CL, 05
			mov DX, offset cierre_th
			int 21
			;; </tr> 
			mov BX, [handleAlfabetico]
			mov AH, 40
			mov CH, 00
			mov CL, [tam_cierre_tr]
			mov DX, offset cierre_tr
			int 21

			;; Abrir el archivo de productos
			mov AH, 3d
			mov AL, 02
			mov DX, offset archivoProductos
			int 21

			; Almacenar el file handle
			mov [handleProductos], AX

			;; CICLO 1:
			ciclo_mostrar_rep_alfabetico:
				;; 1. Leer 26h bytes del archivo de productos
				mov BX, [handleProductos]
				mov CX, 26     ;; leer 26h bytes
				mov DX, offset productoCodigo
				mov AH, 3f
				int 21

				;; 2. Leer 4h bytes del archivo de productos
				mov BX, [handleProductos]
				mov CX, 0004
				mov DX, offset productoPrecioNumero
				mov AH, 3f
				int 21

				;; 3. Verificar que no sea nulo, si es termina
				cmp AX, 00
				je escribir_letra_cantidad

				;; 4. Ver si es producto válido
				mov AL, 00
				cmp [productoCodigo], AL
				je ciclo_mostrar_rep_alfabetico

				;; 5. Comparar el primer caracter del nombre con la letra actual
				;; MAYUS
				mov si, offset productoNombre
				mov di, offset letraActual
				mov cx, 01h
				call cadenas_iguales
				cmp dl, 0ffh
				je incrementar_contador
				;; MINUS
				mov si, offset productoNombre
				mov al, [letraActual]
				add al, 20h ; diferencia entre mayus y minus
				cmp [si], al
				je incrementar_contador
				; 5.1 Si no es igual, siguiente iteración
				jmp ciclo_mostrar_rep_alfabetico

				; 5.2 Si es igual, incrementar contador
				incrementar_contador:
					mov al, [contador]
					inc al
					mov [contador], al
					jmp ciclo_mostrar_rep_alfabetico

				jmp ciclo_mostrar_rep_alfabetico

			fin_rep_alfabetico:
				;; </table>
				mov BX, [handleAlfabetico]
				mov AH, 40
				mov CH, 00
				mov CL, [tam_cierre_table]
				mov DX, offset cierre_table
				int 21

				;; OBTENER FECHA 
				mov ah, 2a
				int 21
				mov [dia], dl
				mov [mes], dh
				mov [anio], cx
				;;OBTENER HORA 
				mov ah, 2ch
				int 21h
				mov [hora], ch
				mov [minutos], cl

				;; <p>Fecha:
				mov BX, [handleAlfabetico]
				mov AH, 40
				mov CH, 00
				mov CL, [tam_fecha_html]
				mov DX, offset fecha_html
				int 21
				;; ESCRIBIR DIA	
				mov AL, [dia]
				mov AH, 00 
				call numAcadena 
				mov BX, [handleAlfabetico]
				mov CX, 02
				mov DX, offset numero
				inc dx
				inc dx 
				inc dx
				mov AH, 40
				int 21
				;; /
				mov BX, [handleAlfabetico]
				mov AH, 40
				mov CH, 00
				mov CL, 01
				mov DX, offset diagonal
				int 21
				;; ESCRIBIR MES	
				mov AL, [mes]
				mov AH, 00 
				call numAcadena
				mov BX, [handleAlfabetico]
				mov CX, 02
				mov DX, offset numero
				inc dx
				inc dx 
				inc dx
				mov AH, 40
				int 21
				;; /
				mov BX, [handleAlfabetico]
				mov AH, 40
				mov CH, 00
				mov CL, 01
				mov DX, offset diagonal
				int 21
				;; ESCRIBIR ANIO	
				mov AX, [anio]
				call numAcadena
				mov BX, [handleAlfabetico]
				mov CX, 04
				mov DX, offset numero
				inc dx
				mov AH, 40
				int 21
				;; </p>
				mov BX, [handleAlfabetico]
				mov AH, 40
				mov CH, 00
				mov CL, [tam_cierre_p]
				mov DX, offset cierre_p
				int 21

				;; <p>Hora:
				mov BX, [handleAlfabetico]
				mov AH, 40
				mov CH, 00
				mov CL, [tam_hora_html]
				mov DX, offset hora_html
				int 21
				;; ESCRIBIR HORA	
				mov AL, [hora]
				mov AH, 00 
				call numAcadena 
				mov BX, [handleAlfabetico]
				mov CX, 02
				mov DX, offset numero
				inc dx
				inc dx 
				inc dx
				mov AH, 40
				int 21
				;; : 
				mov BX, [handleAlfabetico]
				mov AH, 40
				mov CH, 00
				mov CL, 01
				mov DX, offset dosPuntos
				int 21
				;; ESCRIBIR MINUTOS 	
				mov AL, [minutos]
				mov AH, 00 
				call numAcadena 
				mov BX, [handleAlfabetico]
				mov CX, 02
				mov DX, offset numero
				inc dx
				inc dx 
				inc dx
				mov AH, 40
				int 21
				;; </body>
				mov BX, [handleAlfabetico]
				mov AH, 40
				mov CH, 00
				mov CL, [tam_cierre_body]
				mov DX, offset cierre_body
				int 21
				;; </html>
				mov BX, [handleAlfabetico]
				mov AH, 40
				mov CH, 00
				mov CL, [tam_cierre_html]
				mov DX, offset cierre_html
				int 21

				;; CLOSE A FILE WITH HANDLE
				mov AH, 3e
				int 21

				jmp menu_herramientas

			escribir_letra_cantidad:
				;;<tr> 
				mov BX, [handleAlfabetico]
				mov AH, 40
				mov CH, 00
				mov CL, [tam_apertura_tr]
				mov DX, offset apertura_tr
				int 21
				
				;; <td> 
				mov BX, [handleAlfabetico]
				mov AH, 40
				mov CH, 00
				mov CL, [tam_apertura_td]
				mov DX, offset apertura_td
				int 21

				;;ESCRIBIR LETRA
				;;write to file with handle 
				mov DX, offset letraActual
				mov CX, 0001
				mov BX, [handleAlfabetico]
				mov AH, 40
				int 21

				;; </td>
				mov BX, [handleAlfabetico]
				mov AH, 40
				mov CH, 00
				mov CL, [tam_cierre_td]
				mov DX, offset cierre_td
				int 21

				;; <td> 
				mov BX, [handleAlfabetico]
				mov AH, 40
				mov CH, 00
				mov CL, [tam_apertura_td]
				mov DX, offset apertura_td
				int 21

				;;ESCRIBIR CANTIDAD 
				; Verificar si no es 0
				mov AL, [contador] ;; <-- Escribir el valor a verificar si es cero o no
				cmp AL, 0000
				je escribir_variable_cero
				jmp convertir_variable

				escribir_variable_cero:
					mov al, 30h
					mov [numero], al
					mov al, 30h
					mov [numero + 1], al
					mov al, 30h
					mov [numero + 2], al
					mov al, 30h
					mov [numero + 3], al
					mov al, 30h
					mov [numero + 4], al
					jmp escribir_variable

				convertir_variable:
					; Convertir el precio
					mov AL, [contador]
					mov AH, 00
					call numAcadena

				escribir_variable:
					; Escribir el precio
					mov bx, [handleAlfabetico]
					mov cx, 02
					mov dx, offset numero
					inc dx
					inc dx 
					inc dx
					mov ah, 40h
					int 21h

				;; </td>
				mov BX, [handleAlfabetico]
				mov AH, 40
				mov CH, 00
				mov CL, [tam_cierre_td]
				mov DX, offset cierre_td
				int 21

				;; </tr>
				mov BX, [handleAlfabetico]
				mov AH, 40
				mov CH, 00
				mov CL, [tam_cierre_tr]
				mov DX, offset cierre_tr
				int 21

				;comparamos que letra actual sea menor o igual a Z 
				cmp letraActual, 5A ;<- Z en ascii 
				jb menor_igual ;<- jump if less than or equal 

				jmp fin_rep_alfabetico

				menor_igual:
					inc letraActual ;<- incrementa letra actual, es decir A -> B 
					;;inicializamos el contador 
					mov contador, 00 
					; Reiniciar apuntador de productos
					mov al, 00h
					mov bx, [handleProductos]
					mov cx, 00h
					mov dx, 00h
					mov ah, 42h
					int 21h
					;;volvemos al ciclo para cambiar de letra 
					jmp ciclo_mostrar_rep_alfabetico

			generar_reporte_existencias:
				; SEPARACION
				mov DX, offset nuevaLinea
				mov AH, 09
				int 21

				; MOSTRAR ENCABEZADO
				mov DX, offset tituloSinExistencias
				mov AH, 09
				int 21
				mov DX, offset separadorHerramientasSinExistencias
				mov AH, 09
				int 21

				; MENSAJE DE GENERANDO CATALOGO
				mov DX, offset reporteGenerado
				mov AH, 09
				int 21

				;;interrumpcion create a file with a handle 
				mov AH, 3c
				mov CX, 0000
				mov DX, offset archivoSinExistencias
				int 21
				;; el file handle se almacena en Ax 
				mov [handleSinExistencias], AX

				;;interrumpcion WRITE TO FILE WITH HANDLE para escribir el encabezado del html 
				;;<!DOCTYPE html><html><head>" 
				mov BX, AX  ;; bx es el handle 
				mov AH, 40
				mov CH, 00 ;; limpio CH 
				mov CL, [tam_encabezado_html]
				mov DX, offset encabezado_html
				int 21

				;; <title>Catalogo</title>"
				mov BX, [handleSinExistencias]
				mov AH, 40
				mov CH, 00
				mov CL, [tam_tit_Catalogo_html]
				mov DX, offset tit_Catalogo_html
				int 21

				;; css
				mov BX, [handleSinExistencias]
				mov AH, 40
				mov CH, 00
				mov CL, [tam_tit_css]
				mov DX, offset tit_css
				int 21

				;;"</head>"
				mov BX, [handleSinExistencias]
				mov AH, 40
				mov CH, 00
				mov CL, [tam_cierre_head]
				mov DX, offset cierre_head
				int 21

				;; "<body><h1>Catalogo Completo de Productos</h1>"
				mov BX, [handleSinExistencias]
				mov AH, 40
				mov CH, 00
				mov CL, [tam_body_Rep_exist_html]
				mov DX, offset body_Rep_exis_html
				int 21

				;;abriendo <table>
				mov BX, [handleSinExistencias]
				mov AH, 40
				mov CH, 00
				mov CL, [tam_apertura_table]
				mov DX, offset apertura_table
				int 21

				;; <tr> 
				mov BX, [handleSinExistencias]
				mov AH, 40
				mov CH, 00
				mov CL, [tam_apertura_tr]
				mov DX, offset apertura_tr
				int 21

				;; "<th>Descripción</th> <th>Código</th> <th>Precio"
				mov BX, [handleSinExistencias]
				mov AH, 40
				mov CH, 00
				mov CL, [tam_titulos_html]
				dec CL
				mov DX, offset titulos_existencias_html
				int 21

				;;</th>
				mov BX, [handleSinExistencias]
				mov AH, 40
				mov CH, 00
				mov CL, 05
				mov DX, offset cierre_th
				int 21

				;; </tr> 
				mov BX, [handleSinExistencias]
				mov AH, 40
				mov CH, 00
				mov CL, [tam_cierre_tr]
				mov DX, offset cierre_tr
				int 21
				
				;; OPEN DISK FILE WITH HANDLE 
				mov AH, 3d
				mov AL, 02
				mov DX, offset archivoProductos
				int 21

				mov [handleProductos], AX

					ciclo_mostrar_existentes:
						;; READ FROM FILE WITH HANDLE
						mov BX, [handleProductos]
						mov CX, 26     ;; leer 26h bytes
						mov DX, offset productoCodigo
						mov AH, 3f
						int 21
						;; puntero avanzó
						mov BX, [handleProductos]
						mov CX, 0004
						mov DX, offset productoPrecioNumero
						mov AH, 3f
						int 21

						;; verificar que no sea nulo, si es termina 
						cmp AX, 0000
						je fin_mostrar_existentes

						;; ver si es producto válido
						mov AL, 00
						cmp [productoCodigo], AL
						je ciclo_mostrar_existentes						

						; Posicionar en descipcion		
						mov DI, offset productoNombre
						;; dx toma el valor de unidades
						mov ax, [productoUnidadesNumero]
						cmp ax, 0000
						je ir_a_imprimir_esctructura_html			

						jmp ciclo_mostrar_existentes

					ir_a_imprimir_esctructura_html:
						;; llamar a la sub-rutina 
						call imprimir_estructura_html_existencias
						
					fin_mostrar_existentes:
						;; </table>
						mov BX, [handleSinExistencias]
						mov AH, 40
						mov CH, 00
						mov CL, [tam_cierre_table]
						mov DX, offset cierre_table
						int 21

						;; OBTENER FECHA 
						mov ah, 2a
						int 21
						mov [dia], dl
						mov [mes], dh
						mov [anio], cx
						;;OBTENER HORA 
						mov ah, 2ch
						int 21h
						mov [hora], ch
						mov [minutos], cl

						;; <p>Fecha:
						mov BX, [handleSinExistencias]
						mov AH, 40
						mov CH, 00
						mov CL, [tam_fecha_html]
						mov DX, offset fecha_html
						int 21
						;; ESCRIBIR DIA	
						mov AL, [dia]
						mov AH, 00 
						call numAcadena 
						mov BX, [handleSinExistencias]
						mov CX, 02
						mov DX, offset numero
						inc dx
						inc dx 
						inc dx
						mov AH, 40
						int 21
						;; /
						mov BX, [handleSinExistencias]
						mov AH, 40
						mov CH, 00
						mov CL, 01
						mov DX, offset diagonal
						int 21
						;; ESCRIBIR MES	
						mov AL, [mes]
						mov AH, 00 
						call numAcadena
						mov BX, [handleSinExistencias]
						mov CX, 02
						mov DX, offset numero
						inc dx
						inc dx 
						inc dx
						mov AH, 40
						int 21
						;; /
						mov BX, [handleSinExistencias]
						mov AH, 40
						mov CH, 00
						mov CL, 01
						mov DX, offset diagonal
						int 21
						;; ESCRIBIR ANIO	
						mov AX, [anio]
						call numAcadena
						mov BX, [handleSinExistencias]
						mov CX, 04
						mov DX, offset numero
						inc dx
						mov AH, 40
						int 21
						;; </p>
						mov BX, [handleSinExistencias]
						mov AH, 40
						mov CH, 00
						mov CL, [tam_cierre_p]
						mov DX, offset cierre_p
						int 21

						;; <p>Hora:
						mov BX, [handleSinExistencias]
						mov AH, 40
						mov CH, 00
						mov CL, [tam_hora_html]
						mov DX, offset hora_html
						int 21
						;; ESCRIBIR HORA	
						mov AL, [hora]
						mov AH, 00 
						call numAcadena 
						mov BX, [handleSinExistencias]
						mov CX, 02
						mov DX, offset numero
						inc dx
						inc dx 
						inc dx
						mov AH, 40
						int 21
						;; : 
						mov BX, [handleSinExistencias]
						mov AH, 40
						mov CH, 00
						mov CL, 01
						mov DX, offset dosPuntos
						int 21
						;; ESCRIBIR MINUTOS 	
						mov AL, [minutos]
						mov AH, 00 
						call numAcadena 
						mov BX, [handleSinExistencias]
						mov CX, 02
						mov DX, offset numero
						inc dx
						inc dx 
						inc dx
						mov AH, 40
						int 21

						;; </body>
						mov BX, [handleSinExistencias]
						mov AH, 40
						mov CH, 00
						mov CL, [tam_cierre_body]
						mov DX, offset cierre_body
						int 21
						;; </html>
						mov BX, [handleSinExistencias]
						mov AH, 40
						mov CH, 00
						mov CL, [tam_cierre_html]
						mov DX, offset cierre_html
						int 21

						;; CLOSE A FILE WITH HANDLE
						mov AH, 3e
						int 21

						jmp menu_herramientas

					imprimir_estructura_html_existencias:
						;; <tr> 
						mov BX, [handleSinExistencias]
						mov AH, 40
						mov CH, 00
						mov CL, [tam_apertura_tr]
						mov DX, offset apertura_tr
						int 21

						;; <td> 
						mov BX, [handleSinExistencias]
						mov AH, 40
						mov CH, 00
						mov CL, [tam_apertura_td]
						mov DX, offset apertura_td
						int 21

						;;dx toma el valor del codigo 
						mov DX, offset productoCodigo
						;;contador que inicia en 0 
						mov SI, 0000

					ciclo_escribir_codigo_existencias:
						mov DI, DX
						mov AL, [DI]
						;;valida si no es nulo, si lo es se va a 
						cmp AL, 00
						je escribir_descripcion_existencias
						;;valida que la cadena se encuentra llena 
						cmp SI, 0006
						je escribir_descripcion_existencias

						;;write to file with handle ---> escribir 
						mov CX, 0001
						mov BX, [handleSinExistencias]
						mov AH, 40
						int 21

						inc DX  ;; <-- para que se vaya la siguiente byte 
						inc SI  ;; <-- si se escribe algo en el arcribo, aumenta el contador 

						jmp ciclo_escribir_codigo_existencias

					escribir_descripcion_existencias:
						;; </td>
						mov BX, [handleSinExistencias]
						mov AH, 40
						mov CH, 00
						mov CL, [tam_cierre_td]
						mov DX, offset cierre_td
						int 21
						;; <td>
						mov BX, [handleSinExistencias]
						mov AH, 40
						mov CH, 00
						mov CL, [tam_apertura_td]
						mov DX, offset apertura_td
						int 21

						;; dx toma el valor de la descripcion 
						mov DX, offset productoNombre
						mov SI, 0000

					ciclo_escribir_descripcion_existencias:
						mov DI, DX
						mov AL, [DI]
						;;valida si no es nulo, si lo es se va a 
						cmp AL, 00
						je escribir_precio_existencias
						;;valida que la cadena se encuentra llena 
						cmp SI, 0021
						je escribir_precio_existencias

						;;write to file with handle ---> esceribir 
						mov CX, 0001
						mov BX, [handleSinExistencias]
						mov AH, 40
						int 21

						inc DX  ;; <-- para que se vaya la siguiente byte 
						inc SI  ;; <-- si se escribe algo en el arcribo, aumenta el contador 
						jmp ciclo_escribir_descripcion_existencias

					escribir_precio_existencias:
						;; </td>
						mov BX, [handleSinExistencias]
						mov AH, 40
						mov CH, 00
						mov CL, [tam_cierre_td]
						mov DX, offset cierre_td
						int 21
						;; <td>
						mov BX, [handleSinExistencias]
						mov AH, 40
						mov CH, 00
						mov CL, [tam_apertura_td]
						mov DX, offset apertura_td
						int 21
						;; dx toma el valor de precio
						mov AX, [productoPrecioNumero]
						call numAcadena

						mov DX, offset numero
						mov SI, 0000

					ciclo_escribir_precio_existencias:: 
						mov DI, DX
						mov AL, [DI]
						;;valida si no es nulo, si lo es se va a 
						cmp AL, 00
						je cerrar_table_existencias
						;;valida que la cadena se encuentra llena 
						cmp SI, 0006
						je cerrar_table_existencias

						;;write to file with handle ---> esceribir 
						mov CX, 0001
						mov BX, [handleSinExistencias]
						mov AH, 40
						int 21

						inc DX  ;; <-- para que se vaya la siguiente byte 
						inc SI  ;; <-- si se escribe algo en el arcribo, aumenta el contador 
						jmp ciclo_escribir_precio_existencias
			
					cerrar_table_existencias:
						;; </td>
						mov BX, [handleSinExistencias]
						mov AH, 40
						mov CH, 00
						mov CL, [tam_cierre_td]
						mov DX, offset cierre_td
						int 21
						;; </tr>
						mov BX, [handleSinExistencias]
						mov AH, 40
						mov CH, 00
						mov CL, [tam_cierre_tr]
						mov DX, offset cierre_tr
						int 21
						ret
					;	

		reporte_ventas:
			; SEPARACION
			mov DX, offset nuevaLinea
			mov AH, 09
			int 21

			; MOSTRAR ENCABEZADO
			mov DX, offset tituloReporteVentas
			mov AH, 09
			int 21
			mov DX, offset separadorHerramientasVentas
			mov AH, 09
			int 21

			; MENSAJE DE GENERANDO CATALOGO
			mov DX, offset reporteGenerado
			mov AH, 09
			int 21

			; Crear el archivo de registro de ventas
			mov cx, 0000
			mov dx, offset archivoReporteVentas
			mov ah, 3ch
			int 21h

			; Guardar el handle del archivo
			mov [handleReporteVentas], ax
			mov bx, [handleReporteVentas]

			; Escribir la fecha y hora del reporte
			call escribir_fecha_hora_reporte_txt

			; Escribir el separador
			mov cx, separadorSize
			dec cx
			mov dx, offset separador
			mov ah, 40h
			int 21h

			; Escribir apartado de ultimas 5 ventas
			mov cx, txtUltimasVentasSize
			mov dx, offset txtUltimasVentas
			mov ah, 40h
			int 21h

			; Escribir nueva linea
			mov cx, 2h
			mov dx, offset nuevaLinea
			mov ah, 40h
			int 21h

			; Abrir el archivo de ventas
			mov cx, 0000
			mov dx, offset archivoVentas
			mov al, 02h
			mov ah, 3dh
			int 21h

			; Guardar el handle del archivo
			mov [handleVentas], ax
			mov bx, [handleVentas]

			; Reiniciar el contador de ventas
			mov ax, 0000
			mov [cantidadVentas], ax

			; Leer el archivo de ventas
			; 1. Contar la cantidad de ventas
			; 2. Guardar los datos de la venta mayor y menor
			ciclo_1_ventas:
				; Puntero en la fecha de la venta	
				mov bx, [handleVentas]
				mov cx, 6h
				mov dx, offset diaVenta
				mov ah, 3fh
				int 21h

				; Puntero en los items de la venta
				mov bx, [handleVentas]
				mov cx, 46h
				mov dx, offset bytesItems
				mov ah, 3fh
				int 21h

				; Puntero en el total de la venta
				mov bx, [handleVentas]
				mov cx, 2h
				mov dx, offset ventaMontoTotalNumero
				mov ah, 3fh
				int 21h

				; Determinar si se terminó el archivo
				cmp ax, 0000
				je ciclo_1_ventas_fin

				; Aumentar el contador de ventas
				mov ax, [cantidadVentas]
				inc ax
				mov [cantidadVentas], ax

				; Determinar si es la primera venta
				cmp ax, 0001
				je primera_venta_obtenida

				; Determinar si es la venta mayor
				comparacion_venta_mayor:
					mov ax, [ventaMontoTotalNumero]
					cmp ax, [montoMayorVenta]
					jg venta_mayor_obtenida

				; Determinar si es la venta menor
				comparacion_venta_menor:
					mov ax, [ventaMontoTotalNumero]
					cmp ax, [montoMenorVenta]
					jl venta_menor_obtenida
				
				; Continuar con el ciclo
				jmp ciclo_1_ventas_continuar

				primera_venta_obtenida:
					mov ax, [ventaMontoTotalNumero]
					mov [montoMayorVenta], ax
					
					mov si, offset fechaMayorVenta
					mov di, offset diaVenta
					mov cx, 6h
					call copiar_variable

					mov si, offset fechaMenorVenta
					mov di, offset diaVenta
					mov cx, 6h
					call copiar_variable

					mov ax, [ventaMontoTotalNumero]
					mov [montoMenorVenta], ax
					jmp ciclo_1_ventas_continuar
				
				; Si es la venta mayor, guardar los datos
				venta_mayor_obtenida:
					mov si, offset fechaMayorVenta
					mov di, offset diaVenta
					mov cx, 6h
					call copiar_variable

					mov ax, [ventaMontoTotalNumero]
					mov [montoMayorVenta], ax

					jmp comparacion_venta_menor

				; Si es la venta menor, guardar los datos
				venta_menor_obtenida:
					mov si, offset fechaMenorVenta
					mov di, offset diaVenta
					mov cx, 6h
					call copiar_variable

					mov ax, [ventaMontoTotalNumero]
					mov [montoMenorVenta], ax

					jmp ciclo_1_ventas_continuar
				
				; Leer el siguiente registro
				ciclo_1_ventas_continuar:
					jmp ciclo_1_ventas
				
			ciclo_1_ventas_fin:

			; Determinar la cantidad de ventas a mostrar
			; Se hace mediante el calculo del offset de las ventas
			
			; 1. Si hay 5 ventas o menos, mostrar todas
			mov ax, [cantidadVentas]
			cmp ax, 0005
			jle offset_todas_las_ventas

			; 2. Si hay mas de 5 ventas, mostrar las ultimas 5
			jmp offset_ultimas_ventas

			offset_todas_las_ventas:
				mov ax, 0000h
				mov [offsetReporteVentas], ax
				jmp mostrar_ventas

			offset_ultimas_ventas:
				; Calculo de offset para mostrar las ultimas 5 ventas
				; 1. CantidadDeVentas - 5
				mov ax, [cantidadVentas]
				sub ax, 0005
				mov [offsetReporteVentas], ax
				
				; 2. Multiplicar por 4Eh (tamaño de cada venta)
				mov ax, [offsetReporteVentas]
				mov bx, 4Eh
				mul bx
				mov [offsetReporteVentas], ax

				jmp mostrar_ventas

			mostrar_ventas:
				; Mover el puntero del archivo con el offset calculado
				mov al, 00h
				mov bx, [handleVentas]
				mov cx, [offsetReporteVentas]
				mov dx, 0000h
				mov ah, 42h
				int 21h

				ciclo_mostrar_ventas:
					; Puntero en la fecha de la venta	
					mov bx, [handleVentas]
					mov cx, 6h
					mov dx, offset diaVenta
					mov ah, 3fh
					int 21h

					; Puntero en los items de la venta
					mov bx, [handleVentas]
					mov cx, 46h
					mov dx, offset bytesItems
					mov ah, 3fh
					int 21h

					; Puntero en el total de la venta
					mov bx, [handleVentas]
					mov cx, 2h
					mov dx, offset ventaMontoTotalNumero
					mov ah, 3fh
					int 21h

					; Determinar si se terminó el archivo
					cmp ax, 0000
					je ciclo_mostrar_ventas_fin

					; ESCRIBIR VENTA

					; Escribir separador simple
					mov bx, [handleReporteVentas]
					mov cx, separadorSimpleSize
					mov dx, offset separadorSimple
					dec cx
					mov ah, 40h
					int 21h

					; 1. Escribir la fecha de la venta
					reporte_ventas_escribir_fecha:
						call escribir_fecha_txt
					
					; 2. Escribir el monto de la venta
					reporte_ventas_escribir_monto:
						; Escribir apartado de monto
						mov cx, txtMontoSize
						mov dx, offset txtMonto
						mov ah, 40h
						int 21h

						; Convertir el monto
						mov ah, 00h
						mov ax, [ventaMontoTotalNumero]
						call numAcadena

						; Escribir el monto
						mov bx, [handleReporteVentas]
						mov cx, 05h
						mov dx, offset numero
						mov ah, 40h
						int 21h

						; Escribir nueva linea
						mov cx, 2h
						mov dx, offset nuevaLinea
						mov ah, 40h
						int 21h
					
					; Continuar con la siguiente venta
					jmp ciclo_mostrar_ventas

				ciclo_mostrar_ventas_fin:
					; Escribir separador
					mov bx, [handleReporteVentas]
					mov cx, separadorSize
					mov dx, offset separador
					dec cx
					mov ah, 40h
					int 21h

			escribir_venta_mayor:
				; Escribir la venta mayor
				mov bx, [handleReporteVentas]
				mov cx, txtMayorMontoSize
				mov dx, offset txtMayorMonto
				mov ah, 40h
				int 21h

				; Escribir apartado de monto
				mov cx, txtMontoSize
				mov dx, offset txtMonto
				mov ah, 40h
				int 21h

				; Convertir el monto
				mov ah, 00h
				mov ax, [montoMayorVenta]
				call numAcadena

				; Escribir el monto
				mov bx, [handleReporteVentas]
				mov cx, 05h
				mov dx, offset numero
				mov ah, 40h
				int 21h

				; Escribir nueva linea
				mov cx, 2h
				mov dx, offset nuevaLinea
				mov ah, 40h
				int 21h

				mov si, offset diaVenta
				mov di, offset fechaMayorVenta
				mov cx, 06h
				call copiar_variable
				
				call escribir_fecha_txt
				
				; Escribir nueva linea
				mov cx, 2h
				mov dx, offset nuevaLinea
				mov ah, 40h
				int 21h

				; Escribir separador
				mov bx, [handleReporteVentas]
				mov cx, separadorSize
				mov dx, offset separador
				dec cx
				mov ah, 40h
				int 21h

			escribir_venta_menor:
				; Escribir la venta mayor
				mov bx, [handleReporteVentas]
				mov cx, txtMenorMontoSize
				mov dx, offset txtMenorMonto
				mov ah, 40h
				int 21h

				; Escribir apartado de monto
				mov cx, txtMontoSize
				mov dx, offset txtMonto
				mov ah, 40h
				int 21h

				; Convertir el monto
				mov ah, 00h
				mov ax, [montoMenorVenta]
				call numAcadena

				; Escribir el monto
				mov bx, [handleReporteVentas]
				mov cx, 05h
				mov dx, offset numero
				mov ah, 40h
				int 21h

				; Escribir nueva linea
				mov cx, 2h
				mov dx, offset nuevaLinea
				mov ah, 40h
				int 21h

				mov si, offset diaVenta
				mov di, offset fechaMenorVenta
				mov cx, 06h
				call copiar_variable
				
				call escribir_fecha_txt
				
				; Escribir nueva linea
				mov cx, 2h
				mov dx, offset nuevaLinea
				mov ah, 40h
				int 21h

				; Escribir separador
				mov bx, [handleReporteVentas]
				mov cx, separadorSize
				mov dx, offset separador
				dec cx
				mov ah, 40h
				int 21h

			call reiniciar_variables_ventas

			; Cerrar el archivo de reporte
			mov bx, [handleReporteVentas]
			mov ah, 3eh
			int 21h

			; Cerrar el archivo de ventas
			mov bx, [handleVentas]
			mov ah, 3eh
			int 21h

			jmp menu_herramientas

cadenaAnum:
	mov AX, 0000    ; inicializar la salida
	mov CX, 0005    ; inicializar contador
	;;
seguir_convirtiendo:
	mov BL, [DI]
	cmp BL, 00
	je retorno_cadenaAnum
	sub BL, 30      ; BL es el valor numérico del caracter
	mov DX, 000a
	mul DX          ; AX * DX -> DX:AX
	mov BH, 00
	add AX, BX 
	inc DI          ; puntero en la cadena
	loop seguir_convirtiendo
	retorno_cadenaAnum:
		ret
;
numAcadena:
	mov CX, 0005
	mov DI, offset numero
	ciclo_poner30s:
		mov BL, 30
		mov [DI], BL
		inc DI
		loop ciclo_poner30s
		;; tenemos '0' en toda la cadena
		mov CX, AX    ; inicializar contador
		mov DI, offset numero
		add DI, 0004
		;;
	ciclo_convertirAcadena:
		mov BL, [DI]
		inc BL
		mov [DI], BL
		cmp BL, 3a
		je aumentar_siguiente_digito_primera_vez
		loop ciclo_convertirAcadena
		jmp retorno_convertirAcadena
	aumentar_siguiente_digito_primera_vez:
		push DI
	aumentar_siguiente_digito:
		mov BL, 30     ; poner en '0' el actual
		mov [DI], BL
		dec DI         ; puntero a la cadena
		mov BL, [DI]
		inc BL
		mov [DI], BL
		cmp BL, 3a
		je aumentar_siguiente_digito
		pop DI         ; se recupera DI
		loop ciclo_convertirAcadena
	retorno_convertirAcadena:
		ret

;
memset:
	ciclo_memset:
		mov AL, 00
		mov [DI], AL
		inc DI
		loop ciclo_memset
		ret
	;
cadenas_iguales:
	ciclo_cadenas_iguales:
		mov AL, [SI]
		cmp [DI], AL
		jne no_son_iguales
		inc DI
		inc SI
		loop ciclo_cadenas_iguales
		;;;;; <<<
		mov DL, 0ff
		ret
	no_son_iguales:	mov DL, 00
		ret

;
; Entrada -> [handleReporteVentas]: manejador del archivo de reporte
; Salida  -> escribe la fecha y hora actual en el archivo de reporte txt
escribir_fecha_hora_reporte_txt:
    ; Escribir la fecha actual
    escribir_fecha_reporte_txt:
        ; Escribir campo de fecha
        mov bx, [handleReporteVentas]
        mov cx, txtFechaSize
        mov dx, offset txtFecha
        mov ah, 40h
        int 21h

        ; Obtener la fecha
        mov ah, 2ah
        int 21h

        ; Guardar la fecha en memoria
        mov [diaActual], dl
        mov [mesActual], dh
        mov [anioActual], cx

        ; Convertir el dia
        mov ah, 00h
        mov al, [diaActual]
        call numAcadena
        
        ; Escribir el dia
        mov bx, [handleReporteVentas]
        mov cx, 02h
        mov dx, offset numero
        inc dx
        inc dx
        inc dx
        mov ah, 40h
        int 21h

        ; Escribir el separador
        mov bx, [handleReporteVentas]
        mov cx, 01h
        mov dx, offset separadorFecha
        mov ah, 40h
        int 21h

        ; Convertir el mes
        mov ah, 00h
        mov al, [mesActual]
        call numAcadena

        ; Escribir el mes
        mov bx, [handleReporteVentas]
        mov cx, 02h
        mov dx, offset numero
        inc dx
        inc dx
        inc dx
        mov ah, 40h
        int 21h

        ; Escribir el separador
        mov bx, [handleReporteVentas]
        mov cx, 01h
        mov dx, offset separadorFecha
        mov ah, 40h
        int 21h

        ; Convertir el año
        mov ah, 00h
        mov ax, [anioActual]
        call numAcadena

        ; Escribir el año
        mov bx, [handleReporteVentas]
        mov cx, 04h
        mov dx, offset numero
        inc dx
        mov ah, 40h
        int 21h

        ; Escribir espacio
        mov bx, [handleReporteVentas]
        mov cx, 01h
        mov dx, offset espacioBlanco
        mov ah, 40h
        int 21h

    ; Escribir la hora actual
    escribir_hora_reporte_txt:
        call convertir_hora_ascii
        
        ; Escribir la hora
        mov bx, [handleReporteVentas]
        mov cx, 8
        mov dx, offset horaActual
        mov ah, 40h
        int 21h

        ; Escribir nueva linea
        mov bx, [handleReporteVentas]
        mov cx, 02h
        mov dx, offset nuevaLinea
        mov ah, 40h
        int 21h

    ret


; Entrada -> [diaVenta - minutoVenta]: info de fecha y hora (6 bytes)
; Salida  -> escribe ls caracteres de fecha con formato
escribir_fecha_txt:
    ; Escribir apartado de fecha
    mov bx, [handleReporteVentas]
    mov cx, txtFechaSize
    mov dx, offset txtFecha
    mov ah, 40h
    int 21h

    ; Convertir el dia
    mov ah, 00h
    mov al, [diaVenta]
    call numAcadena
    
    ; Escribir el dia
    mov bx, [handleReporteVentas]
    mov cx, 02h
    mov dx, offset numero
    inc dx
    inc dx
    inc dx
    mov ah, 40h
    int 21h

    ; Escribir el separador
    mov bx, [handleReporteVentas]
    mov cx, 01h
    mov dx, offset separadorFecha
    mov ah, 40h
    int 21h

    ; Convertir el mes
    mov ah, 00h
    mov al, [mesVenta]
    call numAcadena

    ; Escribir el mes
    mov bx, [handleReporteVentas]
    mov cx, 02h
    mov dx, offset numero
    inc dx
    inc dx
    inc dx
    mov ah, 40h
    int 21h

    ; Escribir el separador
    mov bx, [handleReporteVentas]
    mov cx, 01h
    mov dx, offset separadorFecha
    mov ah, 40h
    int 21h

    ; Convertir el año
    mov ah, 00h
    mov ax, [anioVenta]
    call numAcadena

    ; Escribir el año
    mov bx, [handleReporteVentas]
    mov cx, 04h
    mov dx, offset numero
    inc dx
    mov ah, 40h
    int 21h

    ; Escribir espacio
    mov bx, [handleReporteVentas]
    mov cx, 01h
    mov dx, offset espacioBlanco
    mov ah, 40h
    int 21h

    ; Convertir la hora
    mov ah, 00h
    mov al, [horaVenta]
    call numAcadena

    ; Escribir la hora
    mov bx, [handleReporteVentas]
    mov cx, 02h
    mov dx, offset numero
    inc dx
    inc dx
    inc dx
    mov ah, 40h
    int 21h

    ; Escribir el separador ':'
    mov bx, [handleReporteVentas]
    mov cx, 01h
    mov dx, offset separadorHora
    mov ah, 40h
    int 21h

    ; Convertir el minuto
    mov ah, 00h
    mov al, [minutoVenta]
    call numAcadena

    ; Escribir el minuto
    mov bx, [handleReporteVentas]
    mov cx, 02h
    mov dx, offset numero
    inc dx
    inc dx
    inc dx
    mov ah, 40h
    int 21h
    
    ; Escribir nueva linea
    mov cx, 2h
    mov dx, offset nuevaLinea
    mov ah, 40h
    int 21h

    ret


reiniciar_variables_ventas:
    ; Limpiar las variables de fechas (Registro y Reporte)
    mov di, offset diaVenta
    mov cx, 0006
    call memset

    mov di, offset fechaMayorVenta
    mov cx, 0006
    call memset

    mov di, offset fechaMenorVenta
    mov cx, 0006
    call memset

    mov di, offset ventaCodigoTemporal
    mov cx, 0005h
    call memset

    
    ; Limpiar la variable ventaCodigo y ventaDescripcion
    mov di, offset ventaCodigo
    mov cx, 0026h
    call memset

    ; Limpiar la variable numeroUnidadesVenta
    mov dx, 0000
    mov [ventaCantidadNumero], dx

    ; Limpiar la variable ventaMontoNumero
    mov dx, 0000
    mov [ventaMontoNumero], dx

    ; Limpiar la variables de montos (Reporte)
    mov di, offset montoMayorVenta
    mov cx, 0002
    call memset

    mov di, offset montoMenorVenta
    mov cx, 0002
    call memset

    ; Limpiar la variable ventaCantidadTemporal
    mov di, offset ventaCantidadTemporal
    mov cx, 0002
    call memset

    ret


convertir_hora_ascii:
    mov ah, 2ch
    int 21h
    mov al, ch

    mov bh, 0
    mov bl, 0
    decenas:
        cmp al, 0ah
        jl unidades
        sub al, 0ah
        inc bh
        jmp decenas
    unidades:
        mov bl, al
    add bh, 30h
    add bl, 30h

    mov [horaActual], bh
    mov [horaActual + 1], bl

    mov [horaActual + 2], 3a ; Dos puntos

    ; Convertir los minutos
    mov al, cl
    mov bh, 0
    mov bl, 0
    decenas_1:
        cmp al, 0ah
        jl unidades_1
        sub al, 0ah
        inc bh
        jmp decenas_1
    unidades_1:
        mov bl, al
        
    add bh, 30h
    add bl, 30h
    mov [horaActual + 3], bh
    mov [horaActual + 4], bl

    mov [horaActual + 5], 3a ; Dos puntos

    ; Convertir los segundos
    mov al, dh
    mov bh, 0
    mov bl, 0
    decenas_2:
        cmp al, 0ah
        jl unidades_2
        sub al, 0ah
        inc bh
        jmp decenas_2
    unidades_2:
        mov bl, al        
    add bh, 30h
    add bl, 30h
    mov [horaActual + 6], bh
    mov [horaActual + 7], bl
    ret


validar_acceso:
	;; abrir archivo de configuración
	mov AH, 3d
	mov AL, 00
	mov DX, offset nombreConfig
	int 21
	;; Si no existe el archivo cierra el programa
	jc fin
	;; Guardar el handle del archivo
	;jc credenciales_incorrectas_fin
	mov [handleConfig], AX
	;; analizarlo
ciclo_lineaXlinea:
	mov DI, offset bufferLinea
	mov AL, 00
	mov [tamLineaLeida], AL
ciclo_obtener_linea:
	mov AH, 3f
	mov BX, [handleConfig]
	mov CX, 0001
	mov DX, DI
	int 21
	cmp CX, 0000
	je fin_leer_linea
	mov AL, [DI]
	cmp AL, 0a
	je fin_leer_linea
	mov AL, [tamLineaLeida]
	inc AL
	mov [tamLineaLeida], AL
	inc DI
	jmp ciclo_obtener_linea
fin_leer_linea:
	mov AL, [tamLineaLeida]
	mov AL, 00
	cmp [estado], AL   ;; verificar la cadena credenciales
	je verificar_cadena_credenciales
	mov AL, 01
	cmp [estado], AL   ;; obtener campo
	je obtener_campo_conf
	mov AL, 02
	cmp [estado], AL   ;; obtener campo
	je obtener_campo_conf
	jmp retorno_exitoso
verificar_cadena_credenciales:
	cmp CX, 0000
	je retorno_fallido
	mov CH, 00
	mov CL, [tkCredenciales]
	mov SI, offset tkCredenciales
	inc SI
	mov DI, offset bufferLinea
	call cadenas_iguales
	cmp DL, 0ff
	je si_hay_creds
	jmp retorno_fallido
si_hay_creds:
	mov AL, [estado]
	inc AL
	mov [estado], AL
	jmp ciclo_lineaXlinea
	;;
obtener_campo_conf:
	cmp CX, 0000
	je retorno_fallido
	mov CH, 00
	mov CL, [tkNombre]
	mov SI, offset tkNombre
	inc SI
	mov DI, offset bufferLinea
	call cadenas_iguales
	cmp DL, 0ff
	je obtener_valor_usuario
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov CH, 00
	mov CL, [tkClave]
	mov SI, offset tkClave
	inc SI
	mov DI, offset bufferLinea
	call cadenas_iguales
	cmp DL, 0ff
	je obtener_valor_clave
	jmp retorno_fallido
obtener_valor_usuario:
ciclo_espacios1:
	inc DI
	mov AL, [DI]
	cmp AL, 20    ;; ver si es espacio
	jne ver_si_es_igual
	inc DI
	jmp ciclo_espacios1
ver_si_es_igual:
	mov CH, 00
	mov CL, [tkIgual]
	mov SI, offset tkIgual
	inc SI
	call cadenas_iguales
	cmp DL, 0ff
	je obtener_valor_cadena_usuario
	jmp retorno_fallido
obtener_valor_cadena_usuario:
ciclo_espacios2:
	inc DI
	mov AL, [DI]
	cmp AL, 20    ;; ver si es espacio
	jne capturar_usuario
	inc DI
	jmp ciclo_espacios2
capturar_usuario:
	mov CX, 0006    ;; TAMAÑO DEL USUARIO: 10 caracteres
	mov SI, offset usuarioCapturado
ciclo_cap_usuario:
	inc DI
	inc SI
	mov AL, [DI]
	mov [SI], AL
	loop ciclo_cap_usuario
	mov AL, [estado]
	inc AL
	mov [estado], AL
	jmp ciclo_lineaXlinea
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;,
obtener_valor_clave:
	ciclo_espacios3:
		inc DI
		mov AL, [DI]
		cmp AL, 20    ;; ver si es espacio
		jne ver_si_es_igual2
		inc DI
		jmp ciclo_espacios3
	ver_si_es_igual2:
		mov CH, 00
		mov CL, [tkIgual]
		mov SI, offset tkIgual
		inc SI
		call cadenas_iguales
		cmp DL, 0ff
		je obtener_valor_cadena_clave
		jmp retorno_fallido
	obtener_valor_cadena_clave:
		ciclo_espacios4:
			inc DI
			mov AL, [DI]
			cmp AL, 20    ;; ver si es espacio
			jne capturar_clave
			inc DI
			jmp ciclo_espacios4
		capturar_clave:
			mov CX, 0009    ;; TAMAÑO DE LA CLAVE: 9 caracteres
			mov SI, offset claveCapturada
		ciclo_cap_clave:
			inc DI
			inc SI
			mov AL, [DI]
			mov [SI], AL
			loop ciclo_cap_clave
			mov AL, [estado]
			inc AL
			mov [estado], AL
			jmp ciclo_lineaXlinea
			;; ver si el nombre de campo es "usuario"
			;;      trabajo con la línea
			;; comparar nombre
			;; comparar clave
			;; si son correctos devolver en DL = 0ff
			;; si no son correctos devolver en DL = 00
		retorno_fallido:
			mov DL, 00
			ret
		retorno_exitoso:
			mov DL, 0ff
			ret

	acabar_ejecucion:
		mov al, 0                           ; Terminar el programa
		mov ah, 4ch                         
		int 21h

	tecla_enter:
		mov AH, 08h                         ; Leer un caracter
		int 21h
		cmp AL, 0dh
		jne tecla_enter
		ret

copiar_variable:
	mov AL, [DI]
	mov [SI], AL
	inc SI
	inc DI
	loop copiar_variable
	ret

fin:
.EXIT

END