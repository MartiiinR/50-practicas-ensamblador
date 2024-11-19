// Autor: Ruiz Barcenas Martin Adolfo
// Fecha: 09-11-2024
// Descripción: Contar los bits activados en un numero
// Asciinema: 

.data
    msg_num: .asciz "Ingrese un número: "
    formato_in: .asciz "%ld"
    msg_resultado: .asciz "Número de bits activados: %d\n"
    msg_binario: .asciz "En binario: "
    formato_bit: .asciz "%d"
    newline: .asciz "\n"

.text
.global main
.align 2

main:
    stp x29, x30, [sp, -16]!
    mov x29, sp

    // Pedir número al usuario
    adrp x0, msg_num
    add x0, x0, :lo12:msg_num
    bl printf

    // Leer número
    sub sp, sp, #16
    mov x2, sp
    adrp x0, formato_in
    add x0, x0, :lo12:formato_in
    mov x1, x2
    bl scanf

    // Cargar número ingresado
    ldr x19, [sp]
    add sp, sp, #16

    // Imprimir representación binaria
    adrp x0, msg_binario
    add x0, x0, :lo12:msg_binario
    bl printf

    mov x0, x19
    mov x1, #64
    bl print_binary

    // Contar bits activados
    mov x20, xzr  // Contador de bits
    mov x21, #64  // Número de bits a revisar

contar_bits:
    cbz x21, fin_conteo
    and x22, x19, #1
    add x20, x20, x22
    lsr x19, x19, #1
    sub x21, x21, #1
    b contar_bits

fin_conteo:
    // Imprimir resultado
    adrp x0, msg_resultado
    add x0, x0, :lo12:msg_resultado
    mov x1, x20
    bl printf

    // Salir del programa
    mov x0, #0
    ldp x29, x30, [sp], #16
    ret

// Función para imprimir número en binario
print_binary:
    stp x29, x30, [sp, -48]!
    mov x29, sp
    str x0, [sp, 16]                  // Guardar número
    str x1, [sp, 24]                  // Guardar cantidad de bits
    mov x19, x1                       // Contador de bits
    
print_bit_loop:
    cmp x19, #0
    b.le print_binary_end
    
    sub x19, x19, #1
    ldr x0, [sp, 16]
    mov x1, x19
    lsr x2, x0, x1
    and x2, x2, #1
    
    adrp x0, formato_bit
    add x0, x0, :lo12:formato_bit
    mov x1, x2
    bl printf
    
    b print_bit_loop
    
print_binary_end:
    adrp x0, newline
    add x0, x0, :lo12:newline
    bl printf
    
    ldp x29, x30, [sp], #48
    ret
