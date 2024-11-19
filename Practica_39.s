// Autor: Ruiz Barcenas Martin Adolfo
// Fecha: 09-11-2024
// Descripción: Convertir un numero decimal a binario
// Asciinema: 

.data
    msg_input: .asciz "Ingrese un número decimal positivo: "
    msg_output: .asciz "El número en binario es: "
    formato_in: .asciz "%ld"
    formato_out: .asciz "%c"
    newline: .asciz "\n"

.text
.global main
.align 2

main:
    stp x29, x30, [sp, -16]!
    mov x29, sp

    // Pedir número decimal
    adrp x0, msg_input
    add x0, x0, :lo12:msg_input
    bl printf

    // Leer número decimal
    sub sp, sp, #16
    mov x2, sp
    adrp x0, formato_in
    add x0, x0, :lo12:formato_in
    mov x1, x2
    bl scanf
    ldr x19, [sp]  // x19 = número decimal ingresado
    add sp, sp, #16

    // Reservar espacio para el resultado binario (64 bits máximo)
    sub sp, sp, #64
    mov x20, sp  // x20 = dirección base del resultado binario

    // Convertir a binario
    mov x21, #63  // x21 = índice del bit actual (empezamos desde el final)
    mov x22, #0   // x22 = contador de bits significativos

convert_loop:
    and x23, x19, #1  // x23 = bit menos significativo
    add x23, x23, #48 // Convertir a carácter ASCII ('0' o '1')
    strb w23, [x20, x21]  // Guardar el bit en el resultado
    lsr x19, x19, #1  // Desplazar el número a la derecha
    sub x21, x21, #1  // Mover al siguiente bit (de derecha a izquierda)
    add x22, x22, #1  // Incrementar contador de bits
    cbnz x19, convert_loop  // Continuar si el número no es cero

    // Ajustar el puntero al inicio del resultado binario
    add x20, x20, x21
    add x20, x20, #1

    // Imprimir mensaje de salida
    adrp x0, msg_output
    add x0, x0, :lo12:msg_output
    bl printf

    // Imprimir resultado binario
print_loop:
    ldrb w1, [x20], #1  // Cargar siguiente carácter y avanzar puntero
    adrp x0, formato_out
    add x0, x0, :lo12:formato_out
    bl printf
    subs x22, x22, #1  // Decrementar contador de bits
    b.ne print_loop  // Continuar si quedan bits por imprimir

    // Imprimir nueva línea
    adrp x0, newline
    add x0, x0, :lo12:newline
    bl printf

    // Liberar espacio del resultado binario
    add sp, sp, #64

    // Salir del programa
    mov x0, #0
    ldp x29, x30, [sp], #16
    ret
