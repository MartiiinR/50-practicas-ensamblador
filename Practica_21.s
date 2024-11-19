// Autor: Ruiz Barcenas Martin Adolfo
// Fecha: 09-11-2024
// Descripción: Transposicion de una matriz 3x3
// Asciinema: 

.data
// Dimensiones de la matriz (3x3)
N: .word 3          // Filas
M: .word 3          // Columnas

// Matrices
matrix: .zero 36     // 3x3 matriz original (4 bytes por elemento)
result: .zero 36     // Matriz transpuesta resultado

// Mensajes y formatos
msg_matrix: .asciz "\nIngrese los elementos de la matriz 3x3:\n"
msg_element: .asciz "Ingrese elemento [%d][%d]: "
msg_original: .asciz "\nMatriz original:\n"
msg_result: .asciz "\nMatriz transpuesta:\n"
fmt_input: .asciz "%d"
fmt_output: .asciz "%4d "
new_line: .asciz "\n"

.text
.global main

main:
    // Prólogo
    stp x29, x30, [sp, -16]!
    mov x29, sp

    // Anunciar entrada de la matriz
    adrp x0, msg_matrix
    add x0, x0, :lo12:msg_matrix
    bl printf

    // Leer matriz
    adrp x20, matrix
    add x20, x20, :lo12:matrix
    mov x19, #0          // i = 0

loop_i:
    cmp x19, #3
    beq end_loop_i
    mov x21, #0          // j = 0

loop_j:
    cmp x21, #3
    beq end_loop_j

    // Mostrar prompt
    adrp x0, msg_element
    add x0, x0, :lo12:msg_element
    mov x1, x19
    mov x2, x21
    bl printf

    // Leer elemento
    sub sp, sp, #16
    mov x1, sp
    adrp x0, fmt_input
    add x0, x0, :lo12:fmt_input
    bl scanf

    // Calcular posición y guardar
    mov x22, #12         // 3 * 4
    mul x23, x19, x22    // i * (3 * 4)
    mov x24, #4
    mul x25, x21, x24    // j * 4
    add x23, x23, x25    // offset total
    ldr w24, [sp]
    str w24, [x20, x23]  // guardar en matrix[i][j]
    add sp, sp, #16

    add x21, x21, #1     // j++
    b loop_j

end_loop_j:
    add x19, x19, #1     // i++
    b loop_i

end_loop_i:
    // Mostrar matriz original
    adrp x0, msg_original
    add x0, x0, :lo12:msg_original
    bl printf

    // Imprimir matriz original
    mov x19, #0          // i = 0

print_orig_i:
    cmp x19, #3
    beq end_print_orig_i
    mov x21, #0          // j = 0

print_orig_j:
    cmp x21, #3
    beq end_print_orig_j

    // Calcular offset y cargar elemento
    mov x22, #12         // 3 * 4
    mul x23, x19, x22    // i * (3 * 4)
    mov x24, #4
    mul x25, x21, x24    // j * 4
    add x23, x23, x25    // offset total
    
    adrp x20, matrix
    add x20, x20, :lo12:matrix
    ldr w1, [x20, x23]   // cargar matrix[i][j]

    // Imprimir elemento
    adrp x0, fmt_output
    add x0, x0, :lo12:fmt_output
    bl printf

    add x21, x21, #1     // j++
    b print_orig_j

end_print_orig_j:
    // Nueva línea al final de cada fila
    adrp x0, new_line
    add x0, x0, :lo12:new_line
    bl printf

    add x19, x19, #1     // i++
    b print_orig_i

end_print_orig_i:
    // Realizar la transposición
    mov x19, #0          // i = 0

trans_loop_i:
    cmp x19, #3
    beq end_trans_loop_i
    mov x21, #0          // j = 0

trans_loop_j:
    cmp x21, #3
    beq end_trans_loop_j

    // Calcular offset para matriz original [i][j]
    mov x22, #12         // 3 * 4
    mul x23, x19, x22    // i * (3 * 4)
    mov x24, #4
    mul x25, x21, x24    // j * 4
    add x23, x23, x25    // offset total
    
    // Cargar elemento de la matriz original
    adrp x20, matrix
    add x20, x20, :lo12:matrix
    ldr w24, [x20, x23]

    // Calcular offset para matriz transpuesta [j][i]
    mov x22, #12         // 3 * 4
    mul x23, x21, x22    // j * (3 * 4)
    mov x24, #4
    mul x25, x19, x24    // i * 4
    add x23, x23, x25    // offset total

    // Guardar en matriz resultado (transpuesta)
    adrp x20, result
    add x20, x20, :lo12:result
    str w24, [x20, x23]

    add x21, x21, #1     // j++
    b trans_loop_j

end_trans_loop_j:
    add x19, x19, #1     // i++
    b trans_loop_i

end_trans_loop_i:
    // Mostrar resultado
    adrp x0, msg_result
    add x0, x0, :lo12:msg_result
    bl printf

    // Imprimir matriz transpuesta
    mov x19, #0          // i = 0

print_loop_i:
    cmp x19, #3
    beq end_print_loop_i
    mov x21, #0          // j = 0

print_loop_j:
    cmp x21, #3
    beq end_print_loop_j

    // Calcular offset y cargar elemento
    mov x22, #12         // 3 * 4
    mul x23, x19, x22    // i * (3 * 4)
    mov x24, #4
    mul x25, x21, x24    // j * 4
    add x23, x23, x25    // offset total
    
    adrp x20, result
    add x20, x20, :lo12:result
    ldr w1, [x20, x23]   // cargar result[i][j]

    // Imprimir elemento
    adrp x0, fmt_output
    add x0, x0, :lo12:fmt_output
    bl printf

    add x21, x21, #1     // j++
    b print_loop_j

end_print_loop_j:
    // Nueva línea al final de cada fila
    adrp x0, new_line
    add x0, x0, :lo12:new_line
    bl printf

    add x19, x19, #1     // i++
    b print_loop_i

end_print_loop_i:
    // Epílogo
    ldp x29, x30, [sp], 16
    ret
