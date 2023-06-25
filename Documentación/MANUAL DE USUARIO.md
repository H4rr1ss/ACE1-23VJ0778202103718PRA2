# MANUAL DE USUARIO 🕹️

## Introducción 📑
Con la finalidad de la implementación de las gramáticas, el curso arquitectura de computadores y ensambladores 1 se llevó a cabo un sistema para punto de venta, dicho programa control de ventas y clientes. Además, se tendrá un módulo de reportería que trabajará sobre los datos almacenados por el sistema y un módulo para carga masiva de datos.
___

<br>

## DESCRIPCION 📄

<br>

## *Acceso a aplicación*
Al iniciar el programa, será necesario verificar la presencia del archivo de configuración, en el directorio desde donde se ejecutó el programa, cuyo nombre debe ser "PRA2.CNF". Si no se llegara a encontrar tal archivo se denegará el acceso y se cerrará automáticamente el programa. Si el archivo es encontrado, se procederá a analizar su contenido. El archivo deberá tener el siguiente formato:

![Inicio](./images/credenciales.png)

<br>

## *Ejecución*
1. Abrir DOSBox
2. Compilar el archivo `main.asm` con el comando `ml main.asm`
3. Ejecutar el archivo `main.exe` con el comando `main.exe`

<br>

# *Inicio de la aplicación*
Si las credenciales fueron correctas se iniciará una pantalla con los datos del desarrollador y es posible acceder al menú principal presionando `Enter`.

![Inicio](./images/Inicio.png)

<br>

## *Menú Principal*
En el menú principal se puede seleccionar entre las siguientes opciones:
- Productos
- Ventas
- Herramientas

![Menú Principal](./images/MenuPrincipal.png)

<br>

___

<br>

## *Menú Productos*
Toda operación sobre productos deberá ser realizada sobre un archivo llamado “PROD.BIN”. Se deberá verificar su existencia, de lo contrario se creará automáticamente al momento de que se ingrese el primer producto.

![Menú Principal](./images/menu_prod.png)

Debe cumplir las siguientes condiciones:

| Descripción |           Validez        |
| ------  | ------ |
| Código      | caracteres válidos: [A-Z0-9] |
| Descripción | caracteres válidos: [A-Za-z0-9,.!] |  
| Precio      | número |
| Unidades    | número |  

<br>

* ## *Ingreso de productos*
Para esta sección simplemente se le solicitarán ingresar los datos requeridos, se validarán según corresponda y se añadirá el producto en el archivo indicado. 

![Menú Principal](./images/ingresar_prod.png)

<br>

* ## *Mostrar productos*
El sistema cuenta con una opción para mostrar los productos ingresados. Estos productos serán mostrados en grupos de cinco. Una vez mostrados los primeros cinco productos, presione ’ENTER’ si desea continuar o ’q’, letra ’q’ minúscula, si desea terminar esta operación.

![Menú Principal](./images/mostrar_prod.png)


<br>

* ## *Borrar productos*
Para esta parte ingrese el código de un producto, se validará, y si corresponde al código de un producto en el archivo, este, será eliminado.

![Menú Principal](./images/borrar_prod.png)


<br>

* ## *Opción regresar*
Esta opción hace regresar directamente hacia el menú principal por si se desea realizar otra operación

<br>

___

<br>

## *Menú Ventas*

