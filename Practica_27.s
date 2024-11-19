// Autor: Ruiz Barcenas Martin Adolfo
// Fecha: 09-11-2024
// Descripción: Realizr desplazamientos a la izquierda y derecha
// Asciinema: 

.data
    msg_num: .asciz "Ingrese un número: "
    msg_shift: .asciz "Ingrese cantidad de posiciones a desplazar (1-8): "
    formato_in: .asciz "%ld"
    
    msg_original: .asciz "\nNúmero original:        %ld\n"
    msg_binario: .asciz "En binario:             "
    
    msg_lsl: .asciz "\nDesplazamiento izquierda (LSL) por %ld:\n"
    msg_lsl_result: .asciz "Resultado LSL:          %ld\n"
    msg_lsl_bin: .asciz "LSL en binario:         "
    
    msg_lsr: .asciz "\nDesplazamiento lógico derecha (LSR) por %ld:\n"
    msg_lsr_result: .asciz "Resultado LSR:          %ld\n"
    msg_lsr_bin: .asciz "LSR en binario:         "
    
    msg_asr: .asciz "\nDesplazamiento aritmético derecha (ASR) por %ld:\n"
    msg_asr_result: .asciz "Resultado ASR:          %ld\n"
    msg_asr_bin: .asciz "ASR en binario:         "
    
    formato_bit: .asciz "%d"
    newline: .asciz "\n"

.text
.global main
.align 2

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
    
    ldp x29, x30, [sp], 48
    ret

main:
    // Prólogo
    stp x29, x30, [sp, -64]!
    mov x29, sp

    // Pedir número
    adrp x0, msg_num
    add x0, x0, :lo12:msg_num
    bl printf
    
    // Leer número
    adrp x0, formato_in
    add x0, x0, :lo12:formato_in
    add x1, x29, 16
    bl scanf
    
    // Pedir cantidad de posiciones
    adrp x0, msg_shift
    add x0, x0, :lo12:msg_shift
    bl printf
    
    // Leer posiciones
    adrp x0, formato_in
    add x0, x0, :lo12:formato_in
    add x1, x29, 24
    bl scanf
    
    // Cargar valores en registros
    ldr x19, [x29, 16]                // Número original
    ldr x20, [x29, 24]                // Cantidad de desplazamiento
    
    // Mostrar número original
    adrp x0, msg_original
    add x0, x0, :lo12:msg_original
    mov x1, x19
    bl printf
    
    adrp x0, msg_binario
    add x0, x0, :lo12:msg_binario
    bl printf
    mov x0, x19
    mov x1, #16                       // Mostrar 16 bits
    bl print_binary
    
    // Realizar LSL (Desplazamiento a la izquierda)
    mov x21, x19                      // Copiar número original
    lsl x21, x21, x20                 // LSL
    
    adrp x0, msg_lsl
    add x0, x0, :lo12:msg_lsl
    mov x1, x20
    bl printf
    
    adrp x0, msg_lsl_result
    add x0, x0, :lo12:msg_lsl_result
    mov x1, x21
    bl printf
    
    adrp x0, msg_lsl_bin
    add x0, x0, :lo12:msg_lsl_bin
    bl printf
    mov x0, x21
    mov x1, #16
    bl print_binary
    
    // Realizar LSR (Desplazamiento lógico a la derecha)
    mov x22, x19                      // Copiar número original
    lsr x22, x22, x20                 // LSR
    
    adrp x0, msg_lsr
    add x0, x0, :lo12:msg_lsr
    mov x1, x20
    bl printf
    
    adrp x0, msg_lsr_result
    add x0, x0, :lo12:msg_lsr_result
    mov x1, x22
    bl printf
    
    adrp x0, msg_lsr_bin
    add x0, x0, :lo12:msg_lsr_bin
    bl printf
    mov x0, x22
    mov x1, #16
    bl print_binary
    
    // Realizar ASR (Desplazamiento aritmético a la derecha)
    mov x23, x19                      // Copiar número original
    asr x23, x23, x20                 // ASR
    
    adrp x0, msg_asr
    add x0, x0, :lo12:msg_asr
    mov x1, x20
    bl printf
    
    adrp x0, msg_asr_result
    add x0, x0, :lo12:msg_asr_result
    mov x1, x23
    bl printf
    
    adrp x0, msg_asr_bin
    add x0, x0, :lo12:msg_asr_bin
    bl printf
    mov x0, x23
    mov x1, #16
    bl print_binary

    // Epílogo y retorno
    mov w0, #0
    ldp x29, x30, [sp], 64
    ret
