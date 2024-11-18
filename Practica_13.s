// Autor: Ruiz Barcenas Martin Adolfo
// Fecha: 09-11-2024
// Descripción: Encontrar el valor minimo en un arreglo
// Asciinema: 

.section .data
arreglo: .word 10, 25, 3, 48, 5, 30      // Arreglo de números enteros
tamano: .word 6                          // Tamaño del arreglo
msg_resultado: .asciz "El valor mínimo es: %d\n"

    .section .text
    .global _start

_start:
    // Cargar el tamaño del arreglo
    ldr x1, =tamano            // Dirección del tamaño
    ldr w1, [x1]               // Cargar el tamaño en w1 (número de elementos)
    
    // Cargar la dirección del arreglo
    ldr x2, =arreglo           // x2 apunta al inicio del arreglo

    // Inicializar el valor mínimo con el primer elemento
    ldr w0, [x2]               // Cargar el primer elemento en w0 (valor mínimo actual)
    add x3, x2, #4             // x3 apunta al segundo elemento (4 bytes por elemento, tamaño de `int`)
    sub w1, w1, #1             // Decrementar el tamaño para contar ya el primer elemento

min_loop:
    // Verificar si hemos terminado de recorrer el arreglo
    cbz w1, print_resultado    // Si w1 es 0, terminamos el bucle

    // Cargar el siguiente elemento en el arreglo
    ldr w4, [x3]               // Cargar el valor actual en w4

    // Comparar el valor actual con el mínimo
    cmp w4, w0                 // Comparar w4 (elemento actual) con w0 (mínimo actual)
    bge skip_update            // Si w4 >= w0, saltar la actualización

    // Actualizar el valor mínimo
    mov w0, w4                 // w0 toma el nuevo valor mínimo

skip_update:
    // Avanzar al siguiente elemento
    add x3, x3, #4             // Avanzar al siguiente elemento (4 bytes)
    sub w1, w1, #1             // Decrementar el contador de elementos
    b min_loop                 // Repetir el bucle

print_resultado:
    // Preparación para imprimir el resultado
    ldr x1, =msg_resultado     // Cargar el mensaje
    mov x2, w0                 // Valor mínimo en x2 para imprimir
    mov x0, x1                 // Mensaje en x0

    // Llamada a printf
    bl printf                  // Llamamos a printf

    // Salir del programa
    mov x8, #93                // Código de salida para syscall exit en ARM64
    mov x0, #0                 // Código de retorno 0
    svc #0                     // Llamada al sistema
