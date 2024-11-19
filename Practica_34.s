// Autor: Ruiz Barcenas Martin Adolfo
// Fecha: 09-11-2024
// Descripción: Invierte los elemenos de un arreglo in-place
// Asciinema: 

.data
    msg_size: .asciz "Ingrese el tamaño del arreglo: "
    msg_element: .asciz "Ingrese el elemento %d: "
    msg_original: .asciz "\nArreglo original:\n"
    msg_invertido: .asciz "\nArreglo invertido:\n"
    formato_in: .asciz "%ld"
    formato_out: .asciz "%ld "
    newline: .asciz "\n"

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
    // Imprimir arreglo original
    adrp x0, msg_original
    add x0, x0, :lo12:msg_original
    bl printf

    mov x21, #0  // Índice
imprimir_original:
    cmp x21, x19
    b.ge fin_imprimir_original

    ldr x1, [x20, x21, lsl #3]  // Cargar elemento actual
    adrp x0, formato_out
    add x0, x0, :lo12:formato_out
    bl printf

    add x21, x21, #1
    b imprimir_original

fin_imprimir_original:
    adrp x0, newline
    add x0, x0, :lo12:newline
    bl printf

    // Invertir el arreglo
    mov x21, #0  // Índice inicial
    sub x22, x19, #1  // Índice final
invertir_arreglo:
    cmp x21, x22
    b.ge fin_inversion

    // Intercambiar elementos
    ldr x23, [x20, x21, lsl #3]  // Cargar elemento del inicio
    ldr x24, [x20, x22, lsl #3]  // Cargar elemento del final
    str x24, [x20, x21, lsl #3]  // Guardar elemento del final en el inicio
    str x23, [x20, x22, lsl #3]  // Guardar elemento del inicio en el final

    add x21, x21, #1
    sub x22, x22, #1
    b invertir_arreglo

fin_inversion:
    // Imprimir arreglo invertido
    adrp x0, msg_invertido
    add x0, x0, :lo12:msg_invertido
    bl printf

    mov x21, #0  // Índice
imprimir_invertido:
    cmp x21, x19
    b.ge fin_imprimir_invertido

    ldr x1, [x20, x21, lsl #3]  // Cargar elemento actual
    adrp x0, formato_out
    add x0, x0, :lo12:formato_out
    bl printf

    add x21, x21, #1
    b imprimir_invertido

fin_imprimir_invertido:
    adrp x0, newline
    add x0, x0, :lo12:newline
    bl printf

    // Liberar espacio del arreglo
    add sp, sp, x19, lsl #3

    // Salir del programa
    mov x0, #0
    ldp x29, x30, [sp], #16
    ret
