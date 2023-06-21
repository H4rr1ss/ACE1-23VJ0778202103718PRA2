; MACROS
include macros.asm

.model small
.stack
.radix 16

; PILA
.data

;; ------------------------------------- VARIABLES -------------------------------------
; MENSAJES INICIALES
MensajeInicial      db  " Universidad de San Carlos de Guatemala", 0dh, 0ah," Facultad de Ingenieria", 0dh, 0ah," Escuela de Vacaciones ", 0dh, 0ah," Arquitectura de Compiladores y ensabladores 1", 0dh, 0ah," Seccion N", 0a, 0dh, 0ah," Harry Aaron Gomez Sanic", 0dh, 0ah," 202103718", 0a, "$"

; SERPARADOR
separador           db  "----------------------------------------------", 0a, "$"
separador_sub       db  "     ==============", 0a, "$"
nueva_lin           db  0a, "$" 

; MENU
productos           db  "(P)roductoss",0a,"$"
prompt_codigo       db  "Codigo: ", "$"
prompt_descri       db  "Descripcion: ", "$"
prompt_precio       db  "Precio: ", "$"
prompt_unidades     db  "Unidades: ", "$"

ventas              db  "(V)entas",0a,"$"

herramientas        db  "(H)erramientas",0a,"$"

prompt              db  "Elija una opcion:",0a,"$"
temp                db  00, "$"; Cadena temporal

; IDENTIFICADORES DE CADA MENÚ(encabezado)
titulo_producto     db  "     | PRODUCTOS  |",0a,"$"
titulo_ventas       db  "     |   VENTAS   |",0a,"$"
titulo_herras       db  "     |HERRAMIENTAS|",0a,"$"

; ETIQUETAS DE INGRESO DE DATOS
buffer_entrada      db  20, 00
                    db  20 dup (0)  ; dup = 5 copias del byte 0 -> 0,0,0,0,0 

; "ESTRUCTURA PRODUCTO"
cod_prod            db  05 dup (0)
cod_desc            db  21 dup (0)
cod_prec            db  03 dup (0)
cod_unid            db  03 dup (0)
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

    ; MENÚ DE OPCIONES
    mPrint productos                    
    mPrint ventas
    mPrint herramientas
    mPrint nueva_lin

    ; OPCION A ELEGIR POR EL USUARIO[leer 1 caracter]
    mPrint prompt
    mov ah, 08              ; SE TIENE EN AL EL CARACTER QUE SE INGRESE
    int 21                  ; AL = CARACTER LEIDO

    ; COMPARACION USUARIO-OPCIONES_MENÚ
    cmp al, 70              ; p MINUS
    je menu_productos
    cmp al, 76              ; v MINU
    je menu_ventas
    cmp al, 68              ; h MINUS
    je menu_herramientas
    
; MENÚS DE CADA OPCIÓN
;--------------------------------------------------------------------------
menu_productos:
    mPrint nueva_lin
    mPrint separador_sub
    mPrint titulo_producto
    mPrint separador_sub

    ; PEDIR CODIGO
    pedir_de_nuevo_codigo:
        mPrint prompt_codigo
        getData buffer_entrada
        mPrint nueva_lin

        ; VERIFICAR QUE EL TAMAÑO DEL CODIGO NO SEA MAYOR A 4
        mov di, offset buffer_entrada
        inc di
        mov al, [di]
        ; si al es 0 pedirá de nuevo
        cmp al, 00
        je  pedir_de_nuevo_codigo
        ; si al es menor a 05 acepta la entrada
        cmp al, 05
        jb aceptar_tam_codigo
        ; si al no era menor a 05, pedira de nuevo 
        jmp pedir_de_nuevo_codigo
        ; MOVER AL CAMPO CODIGO EN LA ESTRUCTURA
    aceptar_tam_codigo:
        mov si, offset cod_prod
        ; OBTENER EL TAMAÑO DE VECES QUE SE MOVERA EL CICLO
        mov di, offset buffer_entrada
        inc di
        mov cx, [di]
        inc di          ; ME POSICIONO EN EL CONTENIDO DEL BUFFER
    copiar_nombre_codi:  mov al, [di]
        mov [si], al
        inc si
        inc di
        loop copiar_nombre_codi  ; RESTARLE 1 A CX, VERIFICAR QUE CX NO SEA 0, SI NO ES 0 VA A LA ETIQUETA
    ; LA CADENA YA FUE INGRESADA EN LA ESTRUCTURA

    ; PEDIR DESCRIPCION
    pedir_de_nuevo_descri:
        mPrint prompt_descri
        getData buffer_entrada
        mPrint nueva_lin

        ; VERIFICAR QUE EL TAMAÑO DEL CODIGO NO SEA MAYOR A 32
        mov di, offset buffer_entrada
        inc di
        mov al, [di]
        ; si al es 0 pedirá de nuevo
        cmp al, 00
        je  pedir_de_nuevo_descri
        ; si al es menor a 33 acepta la entrada
        cmp al, 21
        jb aceptar_tam_descri
        ; si al no era menor a 33, pedira de nuevo 
        jmp pedir_de_nuevo_descri
        ; MOVER AL CAMPO CODIGO EN LA ESTRUCTURA
    aceptar_tam_descri:
        mov si, offset cod_desc
        ; OBTENER EL TAMAÑO DE VECES QUE SE MOVERA EL CICLO
        mov di, offset buffer_entrada
        inc di
        mov cx, [di]
        inc di          ; ME POSICIONO EN EL CONTENIDO DEL BUFFER
    copiar_nombre_desc:  mov al, [di]
        mov [si], al
        inc si
        inc di
        loop copiar_nombre_desc  ; RESTARLE 1 A CX, VERIFICAR QUE CX NO SEA 0, SI NO ES 0 VA A LA ETIQUETA
    ; LA CADENA YA FUE INGRESADA EN LA ESTRUCTURA

    ; PEDIR PRECIO
    pedir_de_nuevo_precio:
        mPrint prompt_precio
        getData buffer_entrada
        mPrint nueva_lin

        ; VERIFICAR QUE EL TAMAÑO DEL CODIGO NO SEA MAYOR A 2
        mov di, offset buffer_entrada
        inc di
        mov al, [di]
        ; si al es 0 pedirá de nuevo
        cmp al, 00
        je  pedir_de_nuevo_precio
        ; si al es menor a 3 acepta la entrada
        cmp al, 03
        jb aceptar_tam_precio
        ; si al no era menor a 3, pedira de nuevo 
        jmp pedir_de_nuevo_precio
        ; MOVER AL CAMPO CODIGO EN LA ESTRUCTURA
    aceptar_tam_precio:
        mov si, offset cod_prec
        ; OBTENER EL TAMAÑO DE VECES QUE SE MOVERA EL CICLO
        mov di, offset buffer_entrada
        inc di
        mov cx, [di]
        inc di          ; ME POSICIONO EN EL CONTENIDO DEL BUFFER
    copiar_nombre_prec:  mov al, [di]
        mov [si], al
        inc si
        inc di
        loop copiar_nombre_prec  ; RESTARLE 1 A CX, VERIFICAR QUE CX NO SEA 0, SI NO ES 0 VA A LA ETIQUETA
    ; LA CADENA YA FUE INGRESADA EN LA ESTRUCTURA

    ; PEDIR UNIDADES
    pedir_de_nuevo_unidades:
        mPrint prompt_unidades
        getData buffer_entrada
        mPrint nueva_lin

        ; VERIFICAR QUE EL TAMAÑO DEL CODIGO NO SEA MAYOR A 2
        mov di, offset buffer_entrada
        inc di
        mov al, [di]
        ; si al es 0 pedirá de nuevo
        cmp al, 00
        je  pedir_de_nuevo_unidades
        ; si al es menor a 3 acepta la entrada
        cmp al, 03
        jb aceptar_tam_unidades
        ; si al no era menor a 3, pedira de nuevo 
        jmp pedir_de_nuevo_unidades
        ; MOVER AL CAMPO CODIGO EN LA ESTRUCTURA
    aceptar_tam_unidades:
        mov si, offset cod_unid
        ; OBTENER EL TAMAÑO DE VECES QUE SE MOVERA EL CICLO
        mov di, offset buffer_entrada
        inc di
        mov cx, [di]
        inc di          ; ME POSICIONO EN EL CONTENIDO DEL BUFFER
    copiar_nombre_unid:  mov al, [di]
        mov [si], al
        inc si
        inc di
        loop copiar_nombre_unid  ; RESTARLE 1 A CX, VERIFICAR QUE CX NO SEA 0, SI NO ES 0 VA A LA ETIQUETA
    ; LA CADENA YA FUE INGRESADA EN LA ESTRUCTURA
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