; MACROS
include macros.asm

.model small
.stack
.radix 16

; PILA
.data
;; ------------------------------------- VARIABLES -------------------------------------
; MENSAJES INICIALES
MensajeInicial              db  " Universidad de San Carlos de Guatemala", 0dh, 0ah," Facultad de Ingenieria", 0dh, 0ah," Escuela de Vacaciones ", 0dh, 0ah," Arquitectura de Compiladores y ensabladores 1", 0dh, 0ah," Seccion N", 0a, 0dh, 0ah," Harry Aaron Gomez Sanic", 0dh, 0ah," 202103718", 0a, "$"

; SERPARADOR
separador                   db  "----------------------------------------------", 0a, "$"
separador_sub               db  "     ==============", 0a, "$"
separador_comun             db  "----------------->", 0a, "$"
nueva_lin                   db  0a, "$" 

; MENU
productos                   db  "(P)roductoss",0a,"$"
    mostrar_produ           db  "(M)ostrar productos",0a,"$"
    ingresar_produ          db  "(I)ngresar producto",0a,"$"
        prompt_codigo       db  "Codigo: ", "$"
        prompt_descri       db  "Descripcion: ", "$"
        prompt_precio       db  "Precio: ", "$"
        prompt_unidades     db  "Unidades: ", "$"
    editar_produ            db  "(E)ditar producto",0a,"$"
    borrar_produ            db  "(B)orrar producto",0a,"$"

ventas                      db  "(V)entas",0a,"$"

herramientas                db  "(H)erramientas",0a,"$"

prompt                      db  "Elija una opcion:",0a,"$"
temp                        db  00, "$"; Cadena temporal

; IDENTIFICADORES DE CADA MENÚ(encabezado)
titulo_producto             db  "     | PRODUCTOS  |",0a,"$"
titulo_ventas               db  "     |   VENTAS   |",0a,"$"
titulo_herras               db  "     |HERRAMIENTAS|",0a,"$"

; ETIQUETAS DE INGRESO DE DATOS
buffer_entrada              db  20, 00
                            db  20 dup (0)  ; dup = 5 copias del byte 0 -> 0,0,0,0,0 

; "ESTRUCTURA PRODUCTO"
cod_prod                    db  05 dup (0)
cod_desc                    db  21 dup (0)
cod_prec                    db  03 dup (0)
cod_unid                    db  03 dup (0)

; ARCHIVOS----->
; PRODUCTOS
arch_productos              db  "PROD.BIN",00   ; CADENA ASCIZ
handle_productos            dw  0000 
;---------------------------------------------------------------------------------------
.code
.startup
; CODIGO 
inicio:
    ; PRINT MENSAJE INICIAL
    mPrint separador 
    mPrint MensajeInicial     
    mPrint separador          
    mPrint nueva_lin

menu_principal:
    ; MENÚ DE OPCIONES
    mPrint productos                    
    mPrint ventas
    mPrint herramientas
    mPrint nueva_lin

    ; OPCION A ELEGIR POR EL USUARIO[leer 1 caracter]
    mPrint prompt
    mov ah, 08              ; SE TIENE EN AL EL CARACTER QUE SE INGRESE
    int 21                  ; AL = CARACTER LEIDO
    mPrint separador_comun

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

    mPrint prompt
    mov ah, 08              ; SE TIENE EN AL EL CARACTER QUE SE INGRESE
    int 21                  ; AL = CARACTER LEIDO
    mPrint separador_comun

    ; COMPARACION USUARIO-OPCIONES_MENÚ
    cmp al, 69              ; i MINUS
    je ingresar_producto_archivo
    cmp al, 65              ; e MINU
    je mostrar
    cmp al, 6d              ; m MINUS
    je mostrar_productos_archivo
    cmp al, 62              ; b MINUS
    je menu_productos
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
    copiar_codigo:  mov al, [di]
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
    copiar_descripcion:  mov al, [di]
        mov [si], al
        inc si
        inc di
        loop copiar_descripcion  ; RESTARLE 1 A CX, VERIFICAR QUE CX NO SEA 0, SI NO ES 0 VA A LA ETIQUETA
    ; LA CADENA YA FUE INGRESADA EN LA ESTRUCTURA

    ; PEDIR PRECIO
    pedir_de_nuevo_precio:
        mPrint prompt_precio
        getData buffer_entrada
        mPrint nueva_lin
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
    copiar_precio:  mov al, [di]
        mov [si], al
        inc si  
        inc di
        loop copiar_precio  ; RESTARLE 1 A CX, VERIFICAR QUE CX NO SEA 0, SI NO ES 0 VA A LA ETIQUETA
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
    copiar_unidades:  mov al, [di]
        mov [si], al
        inc si  
        inc di
        loop copiar_unidades  ; RESTARLE 1 A CX, VERIFICAR QUE CX NO SEA 0, SI NO ES 0 VA A LA ETIQUETA
    ; LA CADENA YA FUE INGRESADA EN LA ESTRUCTURA
    
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
        mov ah, 3C
        int 21                  ; ARCHIVO ABIERTO
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
		; CERRAR EL ARCHIVO
		mov AH, 3e
		int 21
		;
		jmp menu_productos

mostrar_productos_archivo:
        
        ;
        jmp menu_productos

    jmp fin

; --------------------------------------------------------------------------

menu_ventas:
    mPrint nueva_lin
    mPrint separador_sub
    mPrint titulo_ventas
    mPrint separador_sub
    jmp fin

; --------------------------------------------------------------------------

menu_herramientas:
    mPrint nueva_lin
    mPrint separador_sub
    mPrint titulo_herras
    mPrint separador_sub
    jmp fin

; --------------------------------------------------------------------------
fin:

.exit
end