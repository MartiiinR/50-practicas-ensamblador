// Autor: Ruiz Barcenas Martin Adolfo
// Fecha: 09-11-2024
// Descripción: Calcular el Maximo Comun Divisor de dos numeros usando el algoritmo de Euclides
// Asciinema: 

.data
    msg_num1: .asciz "Ingrese el primer número: "
    msg_num2: .asciz "Ingrese el segundo número: "
    formato_in: .asciz "%ld"
    msg_resultado: .asciz "El MCD de %ld y %ld es: %ld\n"

.text
.global main
.align 2

main:
    stp x29, x30, [sp, -16]!
    mov x29, sp

    // Pedir primer número al usuario
    adrp x0, msg_num1
    add x0, x0, :lo12:msg_num1
    bl printf

    // Leer primer número
    sub sp, sp, #16
    mov x2, sp
    adrp x0, formato_in
    add x0, x0, :lo12:formato_in
    mov x1, x2
    bl scanf

    // Guardar primer número
    ldr x19, [sp]
    add sp, sp, #16

    // Pedir segundo número al usuario
    adrp x0, msg_num2
    add x0, x0, :lo12:msg_num2
    bl printf

    // Leer segundo número
    sub sp, sp, #16
    mov x2, sp
    adrp x0, formato_in
    add x0, x0, :lo12:formato_in
    mov x1, x2
    bl scanf

    // Guardar segundo número
    ldr x20, [sp]
    add sp, sp, #16

    // Calcular MCD
    mov x0, x19
    mov x1, x20
    bl mcd

    // Guardar resultado
    mov x21, x0

    // Imprimir resultado
    adrp x0, msg_resultado
    add x0, x0, :lo12:msg_resultado
    mov x1, x19
    mov x2, x20
    mov x3, x21
    bl printf

    // Salir del programa
    mov x0, #0
    ldp x29, x30, [sp], #16
    ret

// Función para calcular el MCD usando el algoritmo de Euclides
mcd:
    // x0: primer número (a)
    // x1: segundo número (b)
loop_mcd:
    cbz x1, end_mcd   // Si b == 0, terminar
    udiv x2, x0, x1   // x2 = a / b
    msub x2, x2, x1, x0  // x2 = a - (a / b) * b (es decir, a % b)
    mov x0, x1        // a = b
    mov x1, x2        // b = a % b
    b loop_mcd

end_mcd:
    // El MCD está en x0
    ret
