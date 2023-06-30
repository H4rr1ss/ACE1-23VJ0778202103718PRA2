# **MANUAL TÉCNICO** 💻

<br>

## **Descripción de la solución** ⚙️ 
Para esta practica se realizó un sitema de ventas realizado en lenguaje Ensamblador. El cual cuenta con dos secciones que son productos y ventas. En productos se puede ingresar, eliminar y visualizar con determinado tamaño de bytes que se especificaran más adelante. En ventas solo es podible realizar una venta con 10 items como máximo o si el usuario ingresa la palabra "fin" cuando se pida el código del producto, se realizarán sus determinados calculos a lo largo de cada una de las ventas. Por último existe la opción de herramientas que se realizan diferentes tipos de reportes del sistema de ventas, los cuales se muestran en formato html sin embargo solo el reporte de ventas se visualizará en un "txt".

<br>

___

## **Requerimientos del Entorno de Desarrollo** 🔧
* Lenguaje ensamblador a utilizar: MASM 6.11

* Presentación de la practica: DosBox

* IDE utilizada para realización: Visual Studio Code 1.56.0 u otro editor

* Memoria RAM: 512 MB o más.

* Espacio en disco: Al menos 2 GB de espacio libre.

* Sistema operativo: Windows 7 o posterior/cualquier distribución Linux.

* Procesador: Intel Core i3 o equivalente, con una velocidad de al menos 2 GHz.

___

<br>

## **Tecnologías utilizadas**💻

### *DosBox:*
Es un programa de emulación que permite ejecutar aplicaciones y juegos diseñados originalmente para MS-DOS (Sistema Operativo de Disco Magnético), un sistema operativo utilizado en las computadoras personales antes de la popularización de Windows.

La principal ventaja de DosBox es su capacidad para emular el hardware y el entorno de software de los equipos antiguos. Esto significa que puede simular la CPU, la memoria, los gráficos, el sonido y otros componentes que eran comunes en los sistemas de la época. Esto permite que las aplicaciones y juegos de DOS se ejecuten de manera fiel y sin problemas en sistemas modernos.

<br>

### *MASM:*
También conocido como Microsoft Macro Assembler 6.11, es un ensamblador de lenguaje de programación desarrollado por Microsoft. Se utiliza principalmente para escribir y ensamblar programas en lenguaje ensamblador para la arquitectura x86 de los procesadores de Intel.

MASM611 permite a los programadores escribir código en lenguaje ensamblador, un lenguaje de bajo nivel que se acerca más al lenguaje de máquina del procesador. Proporciona un conjunto de instrucciones específicas del procesador, permitiendo un control granular y directo sobre el hardware de la computadora.

<br>

___

## **Diccionario de módulos**🏛️

- ### Base necesaria para iniciar

```asm
.model small
.stack
.radix 16
.data
.code
.startup

inicio:


fin:

.exit
end
```

- ### Macros
son bloques de código reutilizables que se definen una vez y se pueden invocar múltiples veces en un programa. Son una forma de abstraer y simplificar secciones de código comunes y repetitivas.
```asm
; ETIQUETAS HTML
colocar_etiqueta_html macro handle, tam_eitquetaHTML, etiquetaHTML
    mov BX, [handle]
	mov AH, 40
	mov CH, 00
	mov CL, [tam_eitquetaHTML]
	mov DX, offset etiquetaHTML
	int 21
endm 
;
; IMPRIMIR
mPrint macro variable
    mov dx, offset variable
    mov ah, 09h
    int 21h
endm
;
; INGRESO DE DATOS
getData macro ingreso
    mov dx, offset ingreso
    mov ah, 0a
    int 21
endm
```


### Escribir Producto en Archivo

~~~
escribir_producto: ; ESCRIBIR EL PRODUCTO EN EL ARCHIVO
		mov CX, 26
		mov DX, offset cod_prod
		mov AH, 40
		int 21
        ; ESCRIBO LOS OTROS DOS
        mov CX, 0004
		mov DX, offset num_precio
		mov AH, 40
		int 21
		;; limpiar todos los campos
		mov DI, offset cod_prod
		mov CX, 2a
		call memset
		; CERRAR EL ARCHIVO
		mov ah, 3e
		int 21
		mPrint nueva_lin
		jmp menu_productos
~~~

### Sobreescribir Producto en Archivo
~~~
; GUARDAMOS HANDLE
mov [handle_productos], AX
; OBTENER HANDLE
mov BX, [handle_productos]
mov DX, 0000
mov [puntero_temp], DX

ciclo_encontrar_productoVacio:
    int 03
    mov bx, [handle_productos]
    mov cx, 2a
    mov dx, offset prod_temp
    moV AH, 3f
    int 21
    cmp AX, 0000   ;; se acaba cuando el archivo se termina
    je avanzar_punteroAlFinal
    mov DX, [puntero_temp]
    add DX, 2a
    mov [puntero_temp], DX
    ;;; verificar si es producto no válido
    mov AL, 00
    cmp [prod_temp], AL
    je avanzar_puntero
    jmp ciclo_encontrar_productoVacio
avanzar_puntero:
    mov DX, [puntero_temp]
    sub DX, 2a
    mov CX, 0000
    mov BX, [handle_productos]
    mov AL, 00
    mov AH, 42
    int 21
    jmp escribir_producto
;;; puntero posicionado
;;; Escribir Producto en Archivo (escribir_producto)
~~~

### Buscar Producto

~~~
buscar_producto:
    mov DI, offset prod_temp
    mov CX, 2a
    call memset
    mov bx, [handle_productos]
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
    mov DI, offset cod_prod
    mov CX, 0005
    call cadenas_iguales
    ;;;; <<
    cmp DL, 0ff
    je producto_encontrado
    jmp buscar_producto
producto_encontrado:
    mov dl, 0ff
finalizar_buscar_producto:
    mov bx, [handle_productos]
    mov ah, 3e ; cerrar archivo
    int 21
cmp DL, 0ff
; si ya existe el producto
je producto_ya_existe
~~~

### Eliminar Producto

~~~
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
    mPrint separador_comun
    mPrint producto_eliminado
    mPrint nueva_lin
    mPrint nueva_lin
    jmp finalizar_borrar
~~~

### Modificar Producto

~~~
modificar_producto:
    mov al, 02
    mov dx, offset arch_productos
    mov ah, 3dh
    int 21h
    mov [handle_productos], ax
    ;
    ciclo_modificar_producto:
        mov bx, [handle_productos]
        mov cx, 26h
        mov dx, offset codigoVenta
        mov ah, 3f
        int 21h
        ;
        ; Puntero en el precio del producto
        mov bx, [handle_productos]
        mov cx, 04h
        mov dx, offset num_precioVenta
        mov ah, 3f
        int 21h
        ;
        ; Comparar si se termino el archivo para finalizar venta 
        ; (o lanzar mensaje de que no encontró)
        cmp AX, 0000   
        je finalizar_ventas
        ;
        ; Operaciones de puntero
        mov dx, [puntero_temp]
        add dx, 2ah
        mov [puntero_temp], dx
        ; verificar si es producto válido
        mov AL, 00
        cmp [codigoVenta], AL
        je ciclo_encontrar_producto_ventas
        ; verificar el código con el código ingresado
        mov SI, offset codigoVentaTemporal
        mov DI, offset codigoVenta
        mov CX, 0005
        ;; Verificar las cadenas
        call cadenas_iguales
        cmp DL, 0ff
        je restar_existencias_producto
        jmp ciclo_modificar_producto

        restar_existencias_producto:
        ; Posicionar puntero para el offset de la interrupcion
        mov dx, [puntero_temp]
        sub dx, 2ah
        mov cx, 0000
        ; Mover el puntero
        mov bx, [handle_productos]
        mov al, 00
        mov ah, 42h
        int 21h
        ; Restar las unidades vendidas
        mov ax, [num_unidadesVenta]
        sub ax, [num_cantidad]
        mov [num_unidadesVenta], ax
        ; Escribir el nuevo contenido con las unidades restadas
        mov cx, 2ah
        mov dx, offset codigoVenta
        mov ah, 40h
        int 21h
        ; Cerrar el archivo para guardar cambios
        mov bx, [handle_productos]
        mov ah, 3eh
        int 21h
        ;; CALCULAR MONTO
        ; IMPRIMIR MONTO
        mPrint nueva_lin
        mPrint prompt_monto	
        ;
        ; MULTIPLICACION
        mov AX,  [num_precioVenta]
        mul num_cantidad ; resultado en AX
        mov [num_monto], AX ; guardo el monto
        ;
        mov AX, [num_monto]
        call numAcadena ;; [numero] tengo la cadena convertida
        mov BX, 0001
        mov CX, 0005
        ;
        mov DX, offset numero
        mov AH, 40
        int 21
        ;
        ; IMPRIMIR MONTO TOTAL
        mPrint nueva_lin
        mPrint prompt_monto_total
        ; SUMA DEL MONTO TOTAL
        mov DI, [num_monto]
        add [num_monto_total], DI	
        ;
        mov AX, [num_monto_total]
        call numAcadena ;; [numero] tengo la cadena convertida
        ;
        mov BX, 0001
        mov CX, 0005
        mov DX, offset numero
        mov AH, 40
        int 21
        mPrint nueva_lin
        ; Escribir en el archivo
        jmp escribir_nuevo_item
~~~
### Agregar Item a Compra
~~~
restar_existencias_producto:
    ; Posicionar puntero para el offset de la interrupcion
    mov dx, [puntero_temp]
    sub dx, 2ah
    mov cx, 0000
    ; Mover el puntero
    mov bx, [handle_productos]
    mov al, 00
    mov ah, 42h
    int 21h
    ; Restar las unidades vendidas
    mov ax, [num_unidadesVenta]
    sub ax, [num_cantidad]
    mov [num_unidadesVenta], ax
    ; Escribir el nuevo contenido con las unidades restadas
    mov cx, 2ah
    mov dx, offset codigoVenta
    mov ah, 40h
    int 21h
    ; Cerrar el archivo para guardar cambios
    mov bx, [handle_productos]
    mov ah, 3eh
    int 21h
    ;; CALCULAR MONTO
    ; IMPRIMIR MONTO
    mPrint nueva_lin
    mPrint prompt_monto	
    ;
    ; MULTIPLICACION
        mov AX,  [num_precioVenta]
        mul num_cantidad ; resultado en AX
        mov [num_monto], AX ; guardo el monto
        ;
        mov AX, [num_monto]
        call numAcadena ;; [numero] tengo la cadena convertida
        mov BX, 0001
        mov CX, 0005
        ;
        mov DX, offset numero
        mov AH, 40
        int 21
        ;
        ; IMPRIMIR MONTO TOTAL
        mPrint nueva_lin
        mPrint prompt_monto_total
        ; SUMA DEL MONTO TOTAL
        mov DI, [num_monto]
        add [num_monto_total], DI	
        ;
        mov AX, [num_monto_total]
        call numAcadena ;; [numero] tengo la cadena convertida
        ;
        mov BX, 0001
        mov CX, 0005
        mov DX, offset numero
        mov AH, 40
        int 21
        mPrint nueva_lin
        ; Escribir en el archivo
        jmp escribir_nuevo_item

~~~

### Verificar Existencias

~~~
ciclo_encontrar_producto_ventas:
    ; Puntero en el código del producto
    mov BX, [handle_productos]
    mov CX, 26
    mov DX, offset codigoVenta
    moV AH, 3f
    int 21
    ;
    ; Puntero en el precio del producto
    mov BX, [handle_productos]
    mov CX, 4
    mov DX, offset num_precioVenta
    moV AH, 3f
    int 21
    ; Comparar si se termino el archivo para finalizar venta 
    ;;(o lanzar mensaje de que no encontró)
    cmp AX, 0000   
    je finalizar_ventas
    ; Avanzar el puntero
    ;mov DX, [puntero_temp]
    ;add DX, 2a
    ;mov [puntero_temp], DX
    ;
    ; verificar si es producto válido
    mov AL, 00
    cmp [codigoVenta], AL
    je ciclo_encontrar_producto_ventas
    ;
    ; verificar el código con el código ingresado
    mov SI, offset codigoVentaTemporal
    mov DI, offset codigoVenta
    mov CX, 0005
    ;
    ;; Verificar las cadenas
    call cadenas_iguales
    cmp DL, 0ff
    ; Mostrar en pantalla el producto
    je verificar_stock
    ;
    ; Seguir buscando
    jmp ciclo_encontrar_producto_ventas
    ;
verificar_stock:
    mov ax, [num_unidadesVenta]
    cmp ax, 0000
    jne imprimir_encontrado
    jmp agregar_item
~~~

### Agregar Item a Compra
~~~
restar_existencias_producto:
    ; Posicionar puntero para el offset de la interrupcion
    mov dx, [puntero_temp]
    sub dx, 2ah
    mov cx, 0000
    ; Mover el puntero
    mov bx, [handle_productos]
    mov al, 00
    mov ah, 42h
    int 21h
    ; Restar las unidades vendidas
    mov ax, [num_unidadesVenta]
    sub ax, [num_cantidad]
    mov [num_unidadesVenta], ax
    ; Escribir el nuevo contenido con las unidades restadas
    mov cx, 2ah
    mov dx, offset codigoVenta
    mov ah, 40h
    int 21h
    ; Cerrar el archivo para guardar cambios
    mov bx, [handle_productos]
    mov ah, 3eh
    int 21h
    ;; CALCULAR MONTO
    ; IMPRIMIR MONTO
    mPrint nueva_lin
    mPrint prompt_monto	
    ;
    ; MULTIPLICACION
        mov AX,  [num_precioVenta]
        mul num_cantidad ; resultado en AX
        mov [num_monto], AX ; guardo el monto
        ;
        mov AX, [num_monto]
        call numAcadena ;; [numero] tengo la cadena convertida
        mov BX, 0001
        mov CX, 0005
        ;
        mov DX, offset numero
        mov AH, 40
        int 21
        ;
        ; IMPRIMIR MONTO TOTAL
        mPrint nueva_lin
        mPrint prompt_monto_total
        ; SUMA DEL MONTO TOTAL
        mov DI, [num_monto]
        add [num_monto_total], DI	
        ;
        mov AX, [num_monto_total]
        call numAcadena ;; [numero] tengo la cadena convertida
        ;
        mov BX, 0001
        mov CX, 0005
        mov DX, offset numero
        mov AH, 40
        int 21
        mPrint nueva_lin
        ; Escribir en el archivo
        jmp escribir_nuevo_item

~~~

### Verificar Existencias

~~~
ciclo_encontrar_producto_ventas:
    ; Puntero en el código del producto
    mov BX, [handle_productos]
    mov CX, 26
    mov DX, offset codigoVenta
    moV AH, 3f
    int 21
    ;
    ; Puntero en el precio del producto
    mov BX, [handle_productos]
    mov CX, 4
    mov DX, offset num_precioVenta
    moV AH, 3f
    int 21
    ; Comparar si se termino el archivo para finalizar venta 
    ;;(o lanzar mensaje de que no encontró)
    cmp AX, 0000   
    je finalizar_ventas
    ; Avanzar el puntero
    ;mov DX, [puntero_temp]
    ;add DX, 2a
    ;mov [puntero_temp], DX
    ;
    ; verificar si es producto válido
    mov AL, 00
    cmp [codigoVenta], AL
    je ciclo_encontrar_producto_ventas
    ;
    ; verificar el código con el código ingresado
    mov SI, offset codigoVentaTemporal
    mov DI, offset codigoVenta
    mov CX, 0005
    ;
    ;; Verificar las cadenas
    call cadenas_iguales
    cmp DL, 0ff
    ; Mostrar en pantalla el producto
    je verificar_stock
    ;
    ; Seguir buscando
    jmp ciclo_encontrar_producto_ventas
    ;
verificar_stock:
    mov ax, [num_unidadesVenta]
    cmp ax, 0000
    jne imprimir_encontrado
    jmp agregar_item
~~~


___

<br>


## **Compilación y ejecución**🔮
Dentro del sistema para el ingreso del mismo es necesario tener un archivo llamado `PRA2.CNF` el cual se utiliza para tener las credenciales de ingreso, dentro del archivo `main.asm` linea 24 y 25 se puede configurar el usuario y clave que se desea tener en el sistema.

<br>

Se deben seguir lo siguientes pasos para la compilación y ejecución del sistema de ventas:

1. Abrir DosBox y dirigirse al directorio donde se encuentra el archivo .asm
2. Colocar en consola de DosBox `ml main.asm` para realizar su compilación
3. Para su ejecución colocar en consola de DosBox `main.exe`


<br>

___

<br>

~~~
Universidad San Carlos de Guatemala 2023
Programador: Harry Aaron Gómez Sanic
Carné: 202103718
~~~

<br>

___