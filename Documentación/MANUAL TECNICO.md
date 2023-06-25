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