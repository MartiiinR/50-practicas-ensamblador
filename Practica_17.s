// Autor: Ruiz Barcenas Martin Adolfo
// Fecha: 09-11-2024
// Descripción: Ordenamiento por seleccion de un arreglo de enteros 
// Asciinema: 

.data
array: .word 12, 45, 7, 23, 67, 89, 34, 56, 90, 14    // Arreglo a ordenar
arr_len: .word 10                                      // Longitud del arreglo
msg_before: .asciz "Arreglo antes de ordenar:\n"
msg_after: .asciz "Arreglo después de ordenar:\n"
msg_elem: .asciz "%d "                                 // Para imprimir cada elemento
msg_nl: .asciz "\n"                                    // Nueva línea

.text
.global main

main:
    // Guardar registros
    stp x29, x30, [sp, -16]!
    mov x29, sp

    // Imprimir mensaje inicial
    adrp x0, msg_before
    add x0, x0, :lo12:msg_before
    bl printf

    // Imprimir arreglo original
    bl print_array

    // Preparar para ordenamiento por selección
    adrp x0, arr_len
    add x0, x0, :lo12:arr_len
    ldr w0, [x0]        // w0 = longitud del arreglo
    sub w1, w0, #1      // w1 = n-1 para el bucle externo

outer_loop:
    cmp w1, #0          // Verificar si hemos terminado
    blt done_sort       // Si w1 < 0, terminamos
    
    mov w2, w1          // w2 = índice del máximo actual
    mov w3, w1          // w3 = contador para bucle interno
    
inner_loop:
    cmp w3, #0          // Verificar si llegamos al inicio
    blt end_inner       // Si w3 < 0, terminar bucle interno
    
    // Cargar elementos a comparar
    adrp x4, array
    add x4, x4, :lo12:array
    
    lsl w5, w3, #2      // w5 = índice * 4
    add x5, x4, w5, UXTW    // x5 = dirección del elemento actual
    lsl w6, w2, #2      // w6 = índice_max * 4
    add x6, x4, w6, UXTW    // x6 = dirección del máximo actual
    
    ldr w7, [x5]        // w7 = elemento actual
    ldr w8, [x6]        // w8 = elemento máximo actual
    
    // Comparar elementos
    cmp w7, w8
    ble no_update       // Si actual <= máximo, no actualizar
    mov w2, w3          // Actualizar índice del máximo

no_update:
    sub w3, w3, #1      // Decrementar contador interno
    b inner_loop

end_inner:
    // Intercambiar elementos si es necesario
    cmp w2, w1          // Verificar si el máximo está en su posición
    beq no_swap         // Si está en posición, no intercambiar
    
    // Realizar intercambio
    adrp x4, array
    add x4, x4, :lo12:array
    lsl w5, w1, #2      // Calcular offset para posición actual
    add x5, x4, w5, UXTW
    lsl w6, w2, #2      // Calcular offset para posición del máximo
    add x6, x4, w6, UXTW
    
    ldr w7, [x5]        // Cargar elemento en posición actual
    ldr w8, [x6]        // Cargar elemento máximo
    str w8, [x5]        // Guardar máximo en posición actual
    str w7, [x6]        // Guardar elemento actual en posición del máximo

no_swap:
    sub w1, w1, #1      // Decrementar contador externo
    b outer_loop

done_sort:
    // Imprimir mensaje final
    adrp x0, msg_after
    add x0, x0, :lo12:msg_after
    bl printf

    // Imprimir arreglo ordenado
    bl print_array

    // Restaurar y retornar
    ldp x29, x30, [sp], 16
    ret

// Subrutina para imprimir el arreglo
print_array:
    stp x29, x30, [sp, -16]!    // Guardar registros
    
    adrp x19, array             // Cargar dirección del arreglo
    add x19, x19, :lo12:array
    adrp x20, arr_len
    add x20, x20, :lo12:arr_len
    ldr w20, [x20]              // Cargar longitud
    mov w21, #0                 // Inicializar contador

print_loop:
    cmp w21, w20                // Comparar contador con longitud
    bge print_end               // Si terminamos, salir
    
    // Imprimir elemento actual
    adrp x0, msg_elem
    add x0, x0, :lo12:msg_elem
    ldr w1, [x19, w21, UXTW #2] // Cargar elemento actual
    bl printf
    
    add w21, w21, #1            // Incrementar contador
    b print_loop

print_end:
    // Imprimir nueva línea
    adrp x0, msg_nl
    add x0, x0, :lo12:msg_nl
    bl printf
    
    ldp x29, x30, [sp], 16      // Restaurar registros
    ret   
