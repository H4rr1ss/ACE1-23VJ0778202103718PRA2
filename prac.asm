; MACROS
include macros.asm

.model small
.stack
.radix 16

; PILA
.data

;; ------------------------------------- VARIABLES -------------------------------------
;       CREDENCIALES     ------>
clave_capturada             db  09  dup (0)
usuario_capturado           db  06  dup (0)
;
espacio_leido          db     00
estado                 db     00
buffer_linea           db     0ff dup (0)
tam_liena_leida        db     00
handle_conf            dw     0000
nombre_conf            db     "PRA2.CNF", 00
;
usuario                     db  "hgomez", "$"
clave                       db  "202103718", "$"
;; tokens
tk_creds                    db  0e, "[credenciales]"
tk_nombre                   db  07, "usuario"
tk_clave                    db  05, "clave"
tk_igual                    db  01, "="
tk_comillas                 db  01, '"'
;
;   MENSAJES INICIALES  ------>
MensajeInicial              db  " Universidad de San Carlos de Guatemala", 0dh, 0ah," Facultad de Ingenieria", 0dh, 0ah," Escuela de Vacaciones ", 0dh, 0ah," Arquitectura de Compiladores y ensabladores 1", 0dh, 0ah," Seccion N", 0a, 0dh, 0ah," Harry Aaron Gomez Sanic", 0dh, 0ah," 202103718", 0a, "$"
;
; SERPARADOR
separador                   db  "----------------------------------------------", 0a, "$"
separador_sub               db  "     ==============", 0a, "$"
separador_comun             db  "----------------->", 0a, "$"
nueva_lin                   db  0a, "$" 
;
;           MENU        ------>
; PRODUCTOS
productos                   db  "(P)roductoss",0a,"$"
    mostrar_produ           db  "(M)ostrar productos",0a,"$"
        prompt_continuar    db  "Presione tecla ENTER para continuar o letra Q para salir...",0a,"$"
    ingresar_produ          db  "(I)ngresar producto",0a,"$"
        prompt_codigo       db  "Codigo: ", "$"
        prompt_descri       db  "Descripcion: ", "$"
        prompt_precio       db  "Precio: ", "$"
        prompt_unidades     db  "Unidades: ", "$"
    editar_produ            db  "(E)ditar producto",0a,"$"
    borrar_produ            db  "(B)orrar producto",0a,"$"
;
; VENTAS
ventas                      db  "(V)entas",0a,"$"
    prompt_venta_codi       db  "Codigo de producto: ", "$"
    prompt_venta_unid       db  "Unidades que desea: ", "$"
    venta_continuar         db  "(D)esea continuar", 0a, "$"
    venta_cancelar          db  "(C)ancelar venta", 0a, "$"
    ;
    diaVenta                db  01 dup (0)
    mesVenta                db  01 dup (0)
    anioVenta               dw  00
    horaVenta               db  01 dup (0)
    minutoVenta             db  01 dup (0)
    ;
    codigoVenta             db  05 dup (0)
    unidadesVenta           db  05 dup (0)
    ;
    numeroUnidadesVenta     dw  0000
    ;
    precioTotalVenta        dw  0000
    contadorItemsVenta      db  0
    llave_fin               db  "fin", "$"
;
; HERRAMIENTAS
herramientas                db  "(H)erramientas",0a,"$"
;
prompt                      db  "Elija una opcion:",0a,"$"
temp                        db  00, "$"; Cadena temporal
;
; IDENTIFICADORES DE CADA MENÚ(encabezado)
titulo_producto             db  "     | PRODUCTOS  |",0a,"$"
titulo_ventas               db  "     |   VENTAS   |",0a,"$"
titulo_herras               db  "     |HERRAMIENTAS|",0a,"$"
;
; ETIQUETA DE INGRESO DE DATOS
buffer_entrada              db  20, 00
                            db  20 dup (0)  ; dup = 5 copias del byte 0 -> 0,0,0,0,0 
;
; "ESTRUCTURA PRODUCTO"
cod_prod                    db  05 dup (0)
cod_desc                    db  21 dup (0)
cod_prec                    db  03 dup (0)
cod_unid                    db  03 dup (0)
; NUMEROS
numero                      db  05 dup (30)
; NUMERICOS
num_precio                  dw  0000
num_unidades                dw  0000
;
; ARCHIVOS----->
; PRODUCTOS
arch_productos              db  "PROD.BIN",00   ; CADENA ASCIZ
handle_productos            dw  0000 
; VENTAS
arch_ventas                 db  "VENT.BIN",00   ; CADENA ASCIZ
handle_ventas               dw  0000
;
ceros          db     2b  dup (0)
;TEMPORALES
cod_prod_temp               db  05 dup (0)
puntero_temp                dw  0000
cl_temp                     db  00
; TEXTO FINALIZAR EJECUCIÓN
fin_ejecucion_programa      db  "    Credenciales incorrectas.", "$"
credenciales_true           db  "    CREDECIALES CORRECTAS, presione enter", 0a, "$"
;---------------------------------------------------------------------------------------

.code
.startup

; CODIGO 
inicio:
    ; PRINT MENSAJE INICIAL
    mPrint nueva_lin
    mPrint separador 
    mPrint MensajeInicial     
    mPrint separador          
    mPrint nueva_lin

    ; VALIDACIONES PARA LAS CREDENCIALES DEL USUARIO
    call validar_acceso
    ; VERIIFCA SI EL NOMBRE DE USUARIO ES CORRECTO
    mov si, offset usuario
    mov di, offset usuario_capturado
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
    mov di, offset clave_capturada
    inc di
    mov cx, 09
    call cadenas_iguales
    cmp dl, 0ff
    mPrint nueva_lin
    mPrint credenciales_true
    call tecla_enter
    mPrint nueva_lin
    mPrint nueva_lin
    je menu_principal
    ; SI ES INCORRECTO IMPRIME MENSAJE Y FINALIZA EL PROGRAMA
    jmp credenciales_incorrectas_fin

credenciales_incorrectas_fin:
    mPrint nueva_lin
    mPrint fin_ejecucion_programa
    call acabar_ejecucion

menu_principal:
    ; MENÚ DE OPCIONES
    mPrint productos                    
    mPrint ventas
    mPrint herramientas
    mPrint nueva_lin
    ;
    ; OPCION A ELEGIR POR EL USUARIO[leer 1 caracter]
    mPrint prompt
    mov ah, 08              ; SE TIENE EN AL EL CARACTER QUE SE INGRESE
    int 21                  ; AL = CARACTER LEIDO
    mPrint separador_comun
    ;
    ; COMPARACION USUARIO-OPCIONES_MENÚ
    cmp al, 70              ; p MINUS
    je menu_productos
    cmp al, 76              ; v MINU
    je menu_ventas
    cmp al, 68              ; h MINUS
    je menu_herramientas
    jmp menu_principal

; MENÚS DE CADA OPCIÓN
;--------------------------------------------------------------------------
menu_productos:
    mPrint nueva_lin
    mPrint ingresar_produ
    mPrint editar_produ
    mPrint mostrar_produ
    mPrint borrar_produ
    mPrint nueva_lin
    ;
    mPrint prompt
    mov ah, 08              ; SE TIENE EN AL EL CARACTER QUE SE INGRESE
    int 21                  ; AL = CARACTER LEIDO
    mPrint separador_comun
    ;
    ; COMPARACION USUARIO-OPCIONES_MENÚ
    cmp al, 69              ; i MINUS -> insertar
    je ingresar_producto_archivo
    cmp al, 65              ; e MINU  -> editar
    je menu_productos
    cmp al, 6d              ; m MINUS -> mostrar
    je mostrar_productos_archivo
    cmp al, 62              ; b MINUS -> borrar
    je eliminar_producto_archivo
    jmp menu_productos

ingresar_producto_archivo:
    mPrint nueva_lin
    mPrint separador_sub
    mPrint titulo_producto
    mPrint separador_sub
    mPrint nueva_lin
    ; PEDIR CODIGO
    pedir_de_nuevo_codigo:
        mPrint prompt_codigo
        getData buffer_entrada
        mPrint nueva_lin
        ;
        ; VERIFICAR QUE EL TAMAÑO DEL CODIGO NO SEA MAYOR A 4
        mov di, offset buffer_entrada
        inc di
        mov al, [di]
        ; SI AL ES 0 PEDIRA DE NUEVO
        cmp al, 00
        je  pedir_de_nuevo_codigo
        ; SI AL ES MENOR A 05 ACEPTA LA ENTRADA
        cmp al, 05
        jb aceptar_tam_codigo
        ; SI AL NO ERA MENOR A 05, pedira de nuevo 
        jmp pedir_de_nuevo_codigo
        ; MOVER AL CAMPO CODIGO EN LA ESTRUCTURA
    aceptar_tam_codigo:
        mov si, offset cod_prod
        ; OBTENER EL TAMAÑO DE VECES QUE SE MOVERA EL CICLO
        mov di, offset buffer_entrada
        inc di
        mov ch, 00
        mov cl, [di]
        inc di          ; ME POSICIONO EN EL CONTENIDO DEL BUFFER
    copiar_codigo:
        mov al, [di]
        mov [si], al
        inc si
        inc di
        loop copiar_codigo  ; RESTARLE 1 A CX, VERIFICAR QUE CX NO SEA 0, SI NO ES 0 VA A LA ETIQUETA
    ; LA CADENA YA FUE INGRESADA EN LA ESTRUCTURA

    ; PEDIR DESCRIPCION
    pedir_de_nuevo_descri:
        mPrint prompt_descri
        getData buffer_entrada
        mPrint nueva_lin
        ;
        ; VERIFICAR QUE EL TAMAÑO DEL CODIGO NO SEA MAYOR A 32
        mov di, offset buffer_entrada
        inc di
        mov al, [di]
        ; SI AL ES 0 PEDIRA DE NUEVO
        cmp al, 00
        je  pedir_de_nuevo_descri
        ; SI AL ES MENOR A 33 ACEPTA LA ENTRADA
        cmp al, 21
        jb aceptar_tam_descri
        ; SI AL NO ERA MENOR A 33, pedira de nuevo 
        jmp pedir_de_nuevo_descri
        ; MOVER AL CAMPO CODIGO EN LA ESTRUCTURA
    aceptar_tam_descri:
        mov si, offset cod_desc
        ; OBTENER EL TAMAÑO DE VECES QUE SE MOVERA EL CICLO
        mov di, offset buffer_entrada
        inc di
        mov ch, 00
        mov cl, [di]
        inc di          ; ME POSICIONO EN EL CONTENIDO DEL BUFFER
    copiar_descripcion:  
        mov al, [di]
        mov [si], al
        inc si
        inc di
        loop copiar_descripcion  ; RESTARLE 1 A CX, VERIFICAR QUE CX NO SEA 0, SI NO ES 0 VA A LA ETIQUETA
    ; LA CADENA YA FUE INGRESADA EN LA ESTRUCTURA

    ; PEDIR PRECIO
    pedir_de_nuevo_precio:
        mPrint prompt_precio
        getData buffer_entrada
        ;
        ; VERIFICAR QUE EL TAMAÑO DEL CODIGO NO SEA MAYOR A 4
        mov di, offset buffer_entrada
        inc di
        mov al, [di]
        ; SI AL ES 0 PEDIRA DE NUEVO
        cmp al, 00
        je  pedir_de_nuevo_precio
        ; SI AL ES MENOR A 03 ACEPTA LA ENTRADA
        cmp al, 03
        jb aceptar_tam_precio
        ; SI AL NO ERA MENOR A 03, pedira de nuevo 
        jmp pedir_de_nuevo_precio
        ; MOVER AL CAMPO CODIGO EN LA ESTRUCTURA
    aceptar_tam_precio:
        mov si, offset cod_prec
        ; OBTENER EL TAMAÑO DE VECES QUE SE MOVERA EL CICLO
        mov di, offset buffer_entrada
        inc di
        mov ch, 00
        mov cl, [di]
        inc di          ; ME POSICIONO EN EL CONTENIDO DEL BUFFER
    copiar_precio:  
        mov al, [di]
        mov [si], al
        inc si  
        inc di
        loop copiar_precio  ; RESTARLE 1 A CX, VERIFICAR QUE CX NO SEA 0, SI NO ES 0 VA A LA ETIQUETA
        ;
        mPrint nueva_lin
        mov DI, offset cod_prec
		call cadenaAnum
		;; AX -> numero convertido
		mov [num_precio], AX
		;;
		mov DI, offset cod_prec
		mov CX, 0005
		call memset

    ; LA CADENA YA FUE INGRESADA EN LA ESTRUCTURA

    ; PEDIR UNIDADES
    pedir_de_nuevo_unidades:
        mPrint prompt_unidades
        getData buffer_entrada
        mPrint nueva_lin
        ;
        ; VERIFICAR QUE EL TAMAÑO DEL CODIGO NO SEA MAYOR A 4
        mov di, offset buffer_entrada
        inc di
        mov al, [di]
        ; SI AL ES 0 PEDIRA DE NUEVO
        cmp al, 00
        je  pedir_de_nuevo_unidades
        ; SI AL ES MENOR A 03 ACEPTA LA ENTRADA
        cmp al, 03
        jb aceptar_tam_unidades
        ; SI AL NO ERA MENOR A 03, pedira de nuevo 
        jmp pedir_de_nuevo_unidades
        ; MOVER AL CAMPO CODIGO EN LA ESTRUCTURA
    aceptar_tam_unidades:
        mov si, offset cod_unid
        ; OBTENER EL TAMAÑO DE VECES QUE SE MOVERA EL CICLO
        mov di, offset buffer_entrada
        inc di
        mov ch, 00
        mov cl, [di]
        inc di          ; ME POSICIONO EN EL CONTENIDO DEL BUFFER
    copiar_unidades:  
        mov al, [di]
        mov [si], al
        inc si  
        inc di
        loop copiar_unidades  ; RESTARLE 1 A CX, VERIFICAR QUE CX NO SEA 0, SI NO ES 0 VA A LA ETIQUETA
    ; LA CADENA YA FUE INGRESADA EN LA ESTRUCTURA
        mov DI, offset cod_unid
		call cadenaAnum
		;; AX -> numero convertido
		mov [num_unidades], AX
		;;
		mov DI, offset cod_unid
		mov CX, 0005
		call memset     ; FINALIZÓ PEDIR DATOS DE PRODUCTO
        ;
        ;
    ; GUARDAR ARCHIVO
        ; PROBAR ABRIRLO NORMAL
        mov AL, 02
		mov AH, 3d
		mov DX, offset arch_productos
		int 21
        ; SI NO, LO CREAMOS
        jc  crear_archivo_productos
        ; SI ABRE ESCRIBIMOS
        jmp guardar_handle_productos
    crear_archivo_productos:
        mov cx, 0000
        mov dx, offset arch_productos
        mov ah, 3c
        int 21                  ; ARCHIVO ABIERTO
        ;
    guardar_handle_productos:
        ; GUARDAMOS HANDLE
		mov [handle_productos], AX
		; OBTENER HANDLE
		mov BX, [handle_productos]
		; VAMOS AL FINAL DEL ARCHIVO
		mov CX, 00
		mov DX, 00
		mov AL, 02
		mov AH, 42
		int 21
        ; ESCRIBIR EL PRODUCTO EN EL ARCHIVO
		mov CX, 2c
		mov DX, offset cod_prod
		mov AH, 40
		int 21
        ; ESCRIBO LOS OTROS DOS
        mov CX, 0004
		mov DX, offset num_precio
		mov AH, 40
		int 21
		; CERRAR EL ARCHIVO
		mov ah, 3e
		int 21
	jmp menu_productos

mostrar_productos_archivo:
        ; ABRIR EL ARCHIVO
        mPrint nueva_lin
        mov AL, 02
		mov AH, 3d
		mov DX, offset arch_productos
		int 21
        ; GUARDAMOS HANDLE
		mov [handle_productos], AX
        ; SE COMIENZA A LEERLO

        ; EL CICLO MOSTRAR SE DEBE DE MOSTRAR 5 ELEMENTOS A LA VEZ
        ; SI SE LLEGA AL FINAL DEL ARCHIVO, SE DEBE DE MOSTRAR EL MENU PRODUCTOS
        
        mov cl_temp, 0
    ciclo_mostrar:    
        mov bx, [handle_productos]
        mov cx, 2c          ; LEEMOS 45 BYTES    
        mov dx, offset cod_prod
        mov ah, 3f
        int 21      
        ;; PUNTERO AVANZÓ
		mov BX, [handle_productos]
		mov CX, 0004
		mov DX, offset num_precio
		mov AH, 3f
		int 21     
        ; ¿CUANTOS BYTES LEÍMOS?
        ; SI SE LEYERON 0 BYTES ENTONCES SE TERMINÓ EL ARCHIVO
        cmp ax, 00   
        je fin_mostrar      ; SI EL CARRY ESTA SETEADO SE VA AL MENU PRODUCTOS
        ; PRODUCTO EN ESTRUCTURA
        call imprimir_estructura
        inc cl_temp
        cmp cl_temp, 05
        jb ciclo_mostrar        
        ; SI SE LLEGA A 5, SE ESPERA A PRESIONAR ENTER PARA CONTINUAR O Q PARA SALIR AL MENU PRODUCTOS
        mPrint nueva_lin
        mPrint separador_sub
    solicitar_instruccion_continuarORegresar:
        mov cl_temp, 00 ; REINICIA EL CONTADOR DE ELEMENTOS MOSTRADOS
        mPrint prompt_continuar        
        ;; INTERRUPCION PARA LEER LETRA
        mov ah, 00
        int 16  ; ALMACENA LA TECLA PRESIONADA EN AL
        mPrint nueva_lin
        mPrint nueva_lin
        cmp al, 0Dh ; tecla enter en ascii hexadecimal es 
        je ciclo_mostrar
        cmp al, 71 ; tecla q minuscula
        je fin_mostrar
        jmp solicitar_instruccion_continuarORegresar        
    fin_mostrar:
        jmp menu_productos

eliminar_producto_archivo:
        int 03
		mov DX, 0000
		mov [puntero_temp], DX
pedir_de_nuevo_codigo2:
		mov DX, offset prompt_codigo
		mov AH, 09
		int 21
		mov DX, offset buffer_entrada
		mov AH, 0a
		int 21
		;;
		mov DI, offset buffer_entrada
		inc DI
		mov AL, [DI]
		cmp AL, 00
		je  pedir_de_nuevo_codigo2
		cmp AL, 05
		jb  aceptar_tam_cod2  ;; jb --> jump if below
		mov DX, offset nueva_lin
		mov AH, 09
		int 21
		jmp pedir_de_nuevo_codigo2
		;;; mover al campo codigo en la estructura producto
aceptar_tam_cod2:
		mov SI, offset cod_prod_temp
		mov DI, offset buffer_entrada
		inc DI
		mov CH, 00
		mov CL, [DI]
		inc DI  ;; me posiciono en el contenido del buffer
copiar_codigo2:	mov AL, [DI]
		mov [SI], AL
		inc SI
		inc DI
		loop copiar_codigo2  ;; restarle 1 a CX, verificar que CX no sea 0, si no es 0 va a la etiqueta, 
		;;; la cadena ingresada en la estructura
		;;;
		mov DX, offset nueva_lin
		mov AH, 09
		int 21
		;;
		mov AL, 02              ;;;<<<<<  lectura/escritura
		mov DX, offset arch_productos
		mov AH, 3d
		int 21
		mov [handle_productos], AX
		;;; TODO: revisar si existe
ciclo_encontrar:
		int 03
		mov BX, [handle_productos]
		mov CX, 2c
		mov DX, offset cod_prod
		moV AH, 3f
		int 21
		mov BX, [handle_productos]
		mov CX, 4
		mov DX, offset num_precio
		moV AH, 3f
		int 21
		cmp AX, 0000   ;; se acaba cuando el archivo se termina
		je finalizar_borrar
		mov DX, [puntero_temp]
		add DX, 2a
		mov [puntero_temp], DX
		;;; verificar si es producto válido
		mov AL, 00
		cmp [cod_prod], AL
		je ciclo_encontrar
		;;; verificar el código
		mov SI, offset cod_prod_temp
		mov DI, offset cod_prod
		mov CX, 0005
		call cadenas_iguales
		;;;; <<
		cmp DL, 0ff
		je borrar_encontrado
		jmp ciclo_encontrar
borrar_encontrado:
		mov DX, [puntero_temp]
		sub DX, 2a
		mov CX, 0000
		mov BX, [handle_productos]
		mov AL, 00
		mov AH, 42
		int 21
		;;; puntero posicionado
		mov CX, 2a
		mov DX, offset ceros
		mov AH, 40
		int 21
finalizar_borrar:
		mov BX, [handle_productos]
		mov AH, 3e
		int 21
		jmp menu_productos

; --------------------------------------------------------------------------

menu_ventas:
    mPrint nueva_lin
    mPrint separador_sub        ; =================
    mPrint titulo_ventas        ;       VENTAS
    mPrint separador_sub        ; =================
    mPrint nueva_lin
    ;

    pedir_datos_ventas:
        mPrint prompt_venta_codi            ; Codigo:
        getData buffer_entrada              ; jalo datos
        mov si, offset llave_fin
        mov di, offset buffer_entrada
        inc di
        inc di
        mov cx, 03
        call cadenas_iguales
        cmp dl, 0ff
        je opciones_de_venta_fin            ; si finaliza, dirige a confirmar venta

        mPrint nueva_lin
        mPrint prompt_venta_unid            ; Unidades:
        getData buffer_entrada              ; jalo datos
        mPrint nueva_lin
        mPrint separador_comun
        mPrint nueva_lin
        jmp pedir_datos_ventas              ; vuelvo a pedir codigo y unidades
        ; AGREGAR VALIDACION DE SI SE LLEGAN A PEDIR 10 ITEMS
    ; CONFIRMACION VENTA
    confirmacion_de_venta:
        jmp menu_principal

    ; ETIQUETA PARA CONFIRMAR LA VENTA
    opciones_de_venta_fin:
        ;
        mPrint nueva_lin
        mPrint separador_comun
        mPrint nueva_lin
        mPrint venta_continuar   ; Desea continua
        mPrint venta_cancelar    ; Cancelar
        mPrint nueva_lin
        mPrint prompt
        ; LEER 1 caracter
		mov ah, 08
		int 21
        ; COMPARO MIS OPCIONES
        cmp al, 64      ; d en ascii
        mPrint nueva_lin
        mPrint separador_comun
        mPrint nueva_lin
        je confirmacion_de_venta
        ;
        cmp al, 63      ; c en ascii
        mPrint nueva_lin
        mPrint separador_comun
        mPrint nueva_lin
        je menu_principal
        ;
    jmp fin

; --------------------------------------------------------------------------

menu_herramientas:
    mPrint nueva_lin
    mPrint separador_sub
    mPrint titulo_herras
    mPrint separador_sub
    jmp fin

; --------------------------------------------------------------------------
                                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                            ;;;;;;;;; SUBRUTINAS ;;;;;;;;;
                                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ENTRADAS:
; SALIDAS:
imprimir_estructura:
    mPrint prompt_codigo
    mov di, offset cod_prod
   ;
    ciclo_poner_dolar_1:
        mov al, [di]
        cmp al, 00
        je poner_dolar_1
        inc di
        jmp ciclo_poner_dolar_1
    mPrint prompt_descri
    poner_dolar_1:
        mov al, 24      ; $
        mov [di], al
        mPrint cod_prod
        mPrint nueva_lin
        mPrint prompt_descri
        mov di, offset cod_desc
    ciclo_poner_dolar_2:
        mov al, [di]
        cmp al, 00
        je poner_dolar_2
        inc di
        jmp ciclo_poner_dolar_2
    poner_dolar_2:
        mov al, 24      ; $
        mov [di], al        
        mPrint cod_desc
        mPrint nueva_lin
        mPrint prompt_precio
        mov AX, [num_precio]
		call numAcadena
		;; [numero] tengo la cadena convertida
		mov BX, 0001
		mov CX, 0005
		mov DX, offset numero
		mov AH, 40
		int 21
		mPrint nueva_lin
		mPrint nueva_lin
		ret

    ;; cadenaAnum
    ;; ENTRADA:
    ;;    DI -> dirección a una cadena numérica
    ;; SALIDA:
    ;;    AX -> número convertido
    ;
    ;
    ;
    ;;[31][32][33][00][00]
    ;;     ^
    ;;     |
    ;;     ----- DI
    ;;;;
    ;;AX = 0
    ;;10 * AX + *1*  = 1
    ;;;;
    ;;AX = 1
    ;;10 * AX + 2  = 12
    ;;;;
    ;;AX = 12
    ;;10 * AX + 3  = 123
    ;;;;
cadenaAnum:
	mov AX, 0000    ; inicializar la salida
	mov CX, 0005    ; inicializar contador
	;
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

;; numAcadena
;; ENTRADA:
;;     AX -> número a convertir    
;; SALIDA:
;;    [numero] -> numero convertido en cadena
;;AX = 1500
;;CX = AX  <<<<<<<<<<<
;;[31][30][30][30][30]
;;                  ^
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

;; memset
;; ENTRADA:
;;    DI -> dirección de la cadena
;;    CX -> tamaño de la cadena
memset:
ciclo_memset:
	mov AL, 00
	mov [DI], AL
	inc DI
	loop ciclo_memset
	ret


;; cadenas_iguales -
;; ENTRADA:
;;    SI -> dirección a cadena 1
;;    DI -> dirección a cadena 2
;;    CX -> tamaño máximo
;; SALIDA:
;;    DL -> 00 si no son iguales

;;         0ff si si lo son
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
        ;
    no_son_iguales:	
        mov DL, 00
		ret

; VALIDACION DE ACCESO AL PROGRAMA
validar_acceso:
	;; abrir archivo de configuración
	mov AH, 3d
	mov AL, 00
	mov DX, offset nombre_conf
	int 21
	mov [handle_conf], AX
	;; analizarlo
    ciclo_lineaXlinea:
		mov DI, offset buffer_linea
		mov AL, 00
		mov [tam_liena_leida], AL
    ciclo_obtener_linea:
		mov AH, 3f
		mov BX, [handle_conf]
		mov CX, 0001
		mov DX, DI
		int 21
		cmp CX, 0000
		je fin_leer_linea
		mov AL, [DI]
		cmp AL, 0a
		je fin_leer_linea
		mov AL, [tam_liena_leida]
		inc AL
		mov [tam_liena_leida], AL
		inc DI
		jmp ciclo_obtener_linea
    fin_leer_linea:
		mov AL, [tam_liena_leida]
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
		mov CL, [tk_creds]
		mov SI, offset tk_creds
		inc SI
		mov DI, offset buffer_linea
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
		mov CL, [tk_nombre]
		mov SI, offset tk_nombre
		inc SI
		mov DI, offset buffer_linea
		call cadenas_iguales
		cmp DL, 0ff
		je obtener_valor_usuario
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		mov CH, 00
		mov CL, [tk_clave]
		mov SI, offset tk_clave
		inc SI
		mov DI, offset buffer_linea
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
		mov CL, [tk_igual]
		mov SI, offset tk_igual
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
		mov CX, 0006    ;; TAMAÑO DEL USUARIO: 6 caracteres
		mov SI, offset usuario_capturado
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
		mov CL, [tk_igual]
		mov SI, offset tk_igual
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
		mov SI, offset clave_capturada
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

fin:
;
.exit
end