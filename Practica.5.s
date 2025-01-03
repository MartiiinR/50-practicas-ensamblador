// Autor: Ruiz Barcenas Martin Adolfo
// Fecha: 09-11-2024
// Descripción: Division de dos numeros
// Asciinema: 

.section .data
result: .asciz "El cociente es: %d\n"

    .section .text
    .global _start

_start:
    // Asignamos los valores para la división
    mov x0, #36             // Dividendo (ejemplo: 20)
    mov x1, #6             // Divisor (ejemplo: 4)

    // Realizamos la división
    udiv x2, x0, x1         // x2 = x0 / x1, almacena el cociente en x2

    // Preparación para imprimir el resultado
    mov x1, x2              // Guardamos el resultado en x1 para la llamada a printf
    ldr x0, =result         // Mensaje para imprimir (la cadena en .data)

    // Llamada a la función printf
    bl printf               // Llamamos a printf

    // Salir del programa
    mov x8, #93             // Código de salida para syscall exit en ARM64
    mov x0, #0              // Código de retorno 0
    svc #0                  // Llamada al sistema
