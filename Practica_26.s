// Autor: Ruiz Barcenas Martin Adolfo
// Fecha: 09-11-2024
// Descripción: Realizar operaciones AND, OR, XOR a nivel de bits
// Asciinema: 

.data
    msg_num1: .asciz "Ingrese el primer número: "
    msg_num2: .asciz "Ingrese el segundo número: "
    formato_in: .asciz "%ld"
    
    msg_and: .asciz "\nOperación AND: %ld & %ld = %ld\n"
    msg_or:  .asciz "Operación OR:  %ld | %ld = %ld\n"
    msg_xor: .asciz "Operación XOR: %ld ^ %ld = %ld\n"
    
    msg_bits1: .asciz "\nPrimer número en bits:  "
    msg_bits2: .asciz "Segundo número en bits: "
    msg_and_bits: .asciz "Resultado AND en bits: "
    msg_or_bits:  .asciz "Resultado OR en bits:  "
    msg_xor_bits: .asciz "Resultado XOR en bits: "
    formato_bit: .asciz "%d"
    newline: .asciz "\n"

.text
.global main
.align 2

// Función corregida para imprimir binario
print_binary:
    stp x29, x30, [sp, -48]!
    mov x29, sp
    str x0, [sp, 16]                  // Guardar número a imprimir
    str x1, [sp, 24]                  // Guardar número de bits
    mov x19, x1                       // Contador de bits en x19
    
print_bit_loop:
    cmp x19, #0                       // Verificar si quedan bits por imprimir
    b.le print_binary_end             // Si no quedan bits, terminar
    
    sub x19, x19, #1                  // Decrementar contador
    ldr x0, [sp, 16]                  // Cargar número original
    mov x1, x19                       // Posición del bit actual
    lsr x2, x0, x1                    // Desplazar a la derecha
    and x2, x2, #1                    // Obtener bit menos significativo
    
    // Imprimir bit
    adrp x0, formato_bit
    add x0, x0, :lo12:formato_bit
    mov x1, x2
    bl printf
    
    b print_bit_loop                  // Continuar con siguiente bit

print_binary_end:
    // Imprimir nueva línea
    adrp x0, newline
    add x0, x0, :lo12:newline
    bl printf
    
    ldp x29, x30, [sp], 48
    ret

main:
    // Prólogo
    stp x29, x30, [sp, -48]!
    mov x29, sp

    // Pedir primer número
    adrp x0, msg_num1
    add x0, x0, :lo12:msg_num1
    bl printf
    
    // Leer primer número
    adrp x0, formato_in
    add x0, x0, :lo12:formato_in
    add x1, x29, 16
    bl scanf
    
    // Pedir segundo número
    adrp x0, msg_num2
    add x0, x0, :lo12:msg_num2
    bl printf
    
    // Leer segundo número
    adrp x0, formato_in
    add x0, x0, :lo12:formato_in
    add x1, x29, 24
    bl scanf
    
    // Cargar números
    ldr x19, [x29, 16]                // Primer número
    ldr x20, [x29, 24]                // Segundo número
    
    // Realizar operaciones
    and x21, x19, x20                 // AND
    orr x22, x19, x20                 // OR
    eor x23, x19, x20                 // XOR
    
    // Mostrar resultados en decimal
    adrp x0, msg_and
    add x0, x0, :lo12:msg_and
    mov x1, x19
    mov x2, x20
    mov x3, x21
    bl printf
    
    adrp x0, msg_or
    add x0, x0, :lo12:msg_or
    mov x1, x19
    mov x2, x20
    mov x3, x22
    bl printf
    
    adrp x0, msg_xor
    add x0, x0, :lo12:msg_xor
    mov x1, x19
    mov x2, x20
    mov x3, x23
    bl printf
    
    // Mostrar números en binario
    adrp x0, msg_bits1
    add x0, x0, :lo12:msg_bits1
    bl printf
    mov x0, x19
    mov x1, #8                        // Reducido a 8 bits para mejor visualización
    bl print_binary
    
    adrp x0, msg_bits2
    add x0, x0, :lo12:msg_bits2
    bl printf
    mov x0, x20
    mov x1, #8
    bl print_binary
    
    adrp x0, msg_and_bits
    add x0, x0, :lo12:msg_and_bits
    bl printf
    mov x0, x21
    mov x1, #8
    bl print_binary
    
    adrp x0, msg_or_bits
    add x0, x0, :lo12:msg_or_bits
    bl printf
    mov x0, x22
    mov x1, #8
    bl print_binary
    
    adrp x0, msg_xor_bits
    add x0, x0, :lo12:msg_xor_bits
    bl printf
    mov x0, x23
    mov x1, #8
    bl print_binary

    // Epílogo y retorno
    mov w0, #0
    ldp x29, x30, [sp], 48
    ret
