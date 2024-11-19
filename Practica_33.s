// Autor: Ruiz Barcenas Martin Adolfo
// Fecha: 09-11-2024
// Descripción: Suma de todos los elementos de un arreglo
// Asciinema: 

.data
    msg_size: .asciz "Ingrese el tamaño del arreglo: "
    msg_element: .asciz "Ingrese el elemento %d: "
    msg_suma: .asciz "La suma de los elementos es: %ld\n"
    formato_in: .asciz "%ld"

.text
.global main
.align 2

main:
    stp x29, x30, [sp, -16]!
    mov x29, sp

    // Pedir el tamaño del arreglo
    adrp x0, msg_size
    add x0, x0, :lo12:msg_size
    bl printf

    // Leer el tamaño
    sub sp, sp, #16
    mov x2, sp
    adrp x0, formato_in
    add x0, x0, :lo12:formato_in
    mov x1, x2
    bl scanf

    // Guardar el tamaño en x19
    ldr x19, [sp]
    add sp, sp, #16

    // Reservar espacio para el arreglo en el stack
    sub sp, sp, x19, lsl #3  // Multiplicar x19 por 8 (tamaño de cada elemento)
    mov x20, sp  // Guardar la dirección base del arreglo en x20

    // Leer los elementos del arreglo
    mov x21, #0  // Índice del elemento actual
leer_elementos:
    cmp x21, x19
    b.ge fin_lectura

    // Imprimir mensaje para ingresar elemento
    adrp x0, msg_element
    add x0, x0, :lo12:msg_element
    add x1, x21, #1  // Número de elemento (índice + 1)
    bl printf

    // Leer elemento
    add x2, x20, x21, lsl #3  // Calcular dirección del elemento actual
    adrp x0, formato_in
    add x0, x0, :lo12:formato_in
    mov x1, x2
    bl scanf

    add x21, x21, #1
    b leer_elementos

fin_lectura:
    // Sumar los elementos del arreglo
    mov x21, #0  // Índice
    mov x22, #0  // Suma

sumar_elementos:
    cmp x21, x19
    b.ge fin_suma

    ldr x23, [x20, x21, lsl #3]  // Cargar elemento actual
    add x22, x22, x23  // Sumar al total
    add x21, x21, #1
    b sumar_elementos

fin_suma:
    // Imprimir resultado
    adrp x0, msg_suma
    add x0, x0, :lo12:msg_suma
    mov x1, x22
    bl printf

    // Liberar espacio del arreglo
    add sp, sp, x19, lsl #3

    // Salir del programa
    mov x0, #0
    ldp x29, x30, [sp], #16
    ret
