// Autor: Ruiz Barcenas Martin Adolfo
// Fecha: 09-11-2024
// Descripción: Resta de dos numeros
// Asciinema: 

.section .data
result: .asciz "La resta es: %d\n"

    .section .text
    .global _start

_start:
    // Asignamos los valores para la operación de resta
    mov x0, #37             // Minuendo (ejemplo: 20)
    mov x1, #23             // Sustraendo (ejemplo: 5)

    // Realizamos la resta
    sub x2, x0, x1          // x2 = x0 - x1, almacena el resultado en x2

    // Preparación para imprimir el resultado
    mov x1, x2              // Guardamos el resultado en x1 para la llamada a printf
    ldr x0, =result         // Mensaje para imprimir (la cadena en .data)

    // Llamada a la función printf
    bl printf               // Llamamos a printf

    // Salir del programa
    mov x8, #93             // Código de salida para syscall exit en ARM64
    mov x0, #0              // Código de retorno 0
    svc #0                  // Llamada al sistema
