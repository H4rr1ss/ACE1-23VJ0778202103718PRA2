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
separador_sub       db  "============", 0a, "$"
nueva_lin           db  0a, "$" 

; MENU
productos           db  "(P)roductos",0a,"$"
prompt_codigo       db  "Codigo: ", "$"
prompt_nombre       db  "Nombre: ", "$"
prompt_precio       db  "Precio: ", "$"
prompt_unidades     db  "Unidades: ", "$"

ventas              db  "(V)entas",0a,"$"

herramientas        db  "(H)erramientas",0a,"$"

prompt              db  "Elija una opcion:",0a,"$"
temp                db  00, "$"; Cadena temporal

; IDENTIFICADORES DE CADA MENÚ(encabezado)
titulo_producto     db  "PRODUCTOS",0a,"$"
titulo_ventas       db  "VENTAS",0a,"$"
titulo_herras       db  "HERRAMIENTAS",0a,"$"

; ETIQUETAS DE INGRESO DE DATOS
buffer_entrada      db  20, 00
                    db  20 dup (0)  ; dup = 5 copias del byte 0 -> 0,0,0,0,0 

; "ESTRUCTURA PRODUCTO"
cod_prod            db  05 dup (0)
cod_nomb            db  21 dup (0)
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
        ; si al es menor a 06 acepta la entrada
        cmp al, 05
        jb aceptar_tam_codigo
        ; si al no era menor a 06, pedira de nuevo 
        jmp pedir_de_nuevo_codigo
        ; MOVER AL CAMPO CODIGO EN LA ESTRUCTURA
    aceptar_tam_codigo:
        mov si, offset cod_prod
        ; OBTENER EL TAMAÑO DE VECES QUE SE MOVERA EL CICLO
        mov di, offset buffer_entrada
        inc di
        mov cx, [di]
        inc di          ; ME POSICIONO EN EL CONTENIDO DEL BUFFER

    copiar_nombre:  mov al, [di]
        mov [si], al
        inc si
        inc di
        loop copiar_nombre  ; RESTARLE 1 A CX, VERIFICAR QUE CX NO SEA 0, SI NO ES 0 VA A LA ETIQUETA
    ; LA CADENA YA FUE INGRESADA EN LA ESTRUCTURA

    ; PEDIR NOMBRE
        mPrint prompt_nombre
        getData buffer_entrada
        mPrint nueva_lin
    ; LA CADENA YA FUE INGRESADA EN LA ESTRUCTURA

    ; PEDIR PRECIO
        mPrint prompt_precio
        getData buffer_entrada
        mPrint nueva_lin
    ; LA CADENA YA FUE INGRESADA EN LA ESTRUCTURA

    ; PEDIR UNIDADES
        mPrint prompt_unidades
        getData buffer_entrada
        mPrint nueva_lin
    ; LA CADENA YA FUE INGRESADA EN LA ESTRUCTURA

        ;; IMPRIMIR CADENA
        ;mov bx, 01
        ;mov di, offset buffer_entrada   ; LA DIRECCION HACIA EL PRIMER BYTE DEL BUFFER
        ;inc di                          ; SUMARLE 1 A LA DIRECCION DEL PRIMER BYTE, O SEA SE MUEVE A LA DIRECCION DE SIG. BYTE
        ;; CX = CH + CL, SE COLOCA CH PORQUE PUEDE QUE TENGA UN VALOR
        ;mov ch, 00
        ;mov cl, [di]                    ; ACCEDIO A MEMORIA DEL BYTE SIG.
        ;inc di                          ; SE VUELVE A INCREMENTAR PORQUE LOS DATOS SE ENCUENTRAN A PARTIR DEL 3ER BYTE[ya estamos en 3er byte]
        ;mov dx, di
        ;mov ah, 40
        ;int 21  
    jmp fin
; --------------------------------------------------------------------------
menu_ventas:
    mPrint nueva_lin
    mPrint separador_sub
    mPrint titulo_ventas
    mPrint separador_sub

; --------------------------------------------------------------------------
menu_herramientas:
    mPrint nueva_lin
    mPrint separador_sub
    mPrint titulo_herras
    mPrint separador_sub
; --------------------------------------------------------------------------
fin:

.exit
end