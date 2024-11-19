// Autor: Ruiz Barcenas Martin Adolfo
// Fecha: 09-11-2024
// Descripción: Deteccion de desbordamiento en suma
// Asciinema: 

.data
    msg_input1: .asciz "Ingrese el primer número: "
    msg_input2: .asciz "Ingrese el segundo número: "
    msg_result: .asciz "Resultado de la suma: %ld\n"
    msg_overflow: .asciz "¡Se ha producido un desbordamiento!\n"
    msg_no_overflow: .asciz "No se ha producido desbordamiento.\n"
    formato_in: .asciz "%ld"

.text
.global main
.align 2

main:
    stp x29, x30, [sp, -32]!
    mov x29, sp

    // Pedir primer número
    adrp x0, msg_input1
    add x0, x0, :lo12:msg_input1
    bl printf

    // Leer primer número
    add x1, sp, 16
    adrp x0, formato_in
    add x0, x0, :lo12:formato_in
    bl scanf
    ldr x19, [sp, 16]  // x19 = primer número

    // Pedir segundo número
    adrp x0, msg_input2
    add x0, x0, :lo12:msg_input2
    bl printf

    // Leer segundo número
    add x1, sp, 24
    adrp x0, formato_in
    add x0, x0, :lo12:formato_in
    bl scanf
    ldr x20, [sp, 24]  // x20 = segundo número

    // Realizar la suma y detectar desbordamiento
    adds x21, x19, x20  // x21 = resultado de la suma

    // Imprimir resultado
    adrp x0, msg_result
    add x0, x0, :lo12:msg_result
    mov x1, x21
    bl printf

    // Verificar desbordamiento
    b.vs overflow  // Saltar si hay desbordamiento (V flag set)

    // No hay desbordamiento
    adrp x0, msg_no_overflow
    add x0, x0, :lo12:msg_no_overflow
    bl printf
    b end_program

overflow:
    // Hay desbordamiento
    adrp x0, msg_overflow
    add x0, x0, :lo12:msg_overflow
    bl printf

end_program:
    // Salir del programa
    mov x0, #0
    ldp x29, x30, [sp], 32
    ret

