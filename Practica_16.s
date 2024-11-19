// Autor: Ruiz Barcenas Martin Adolfo
// Fecha: 09-11-2024
// Descripción: Ordenamiento burbuja de un arreglo de numeros enteros
// Asciinema: 

.data
array:      .word 12, 45, 7, 23, 67, 89, 34, 56, 90, 14  // Arreglo a ordenar
arr_len:    .word 10                                      // Longitud del arreglo
msg_before: .asciz "Arreglo antes de ordenar:\n"
msg_after:  .asciz "Arreglo después de ordenar:\n"
msg_elem:   .asciz "%d "                                  // Para imprimir cada elemento
msg_nl:     .asciz "\n"                                   // Nueva línea

    .text
    .global main
main:
    // Guardar el puntero de marco y el enlace de retorno
    stp x29, x30, [sp, -16]!     // Reservar espacio en la pila
    mov x29, sp                   // Establecer el puntero de marco

    // Imprimir mensaje inicial
    adrp x0, msg_before
    add x0, x0, :lo12:msg_before
    bl printf

    // Imprimir arreglo original
    bl print_array

    // Preparar para ordenamiento burbuja
    adrp x0, arr_len
    add x0, x0, :lo12:arr_len
    ldr w0, [x0]                  // w0 = longitud del arreglo
    mov w1, w0                    // w1 = contador externo

outer_loop:
    cmp w1, #1                    // Comparar contador con 1
    ble done_sort                 // Si <= 1, terminamos
    
    mov w2, #0                    // w2 = índice para bucle interno
    sub w3, w1, #1               // w3 = límite del bucle interno

inner_loop:
    cmp w2, w3                    // Comparar índice con límite
    bge end_inner                 // Si >= límite, terminar bucle interno

    // Cargar elementos a comparar
    adrp x4, array
    add x4, x4, :lo12:array
    lsl w5, w2, #2               // w5 = índice * 4
    add x5, x4, w5, UXTW         // x5 = dirección del elemento actual
    ldr w6, [x5]                 // w6 = elemento actual
    ldr w7, [x5, #4]             // w7 = siguiente elemento

    // Comparar y intercambiar si es necesario
    cmp w6, w7                    // Comparar elementos
    ble no_swap                   // Si están en orden, no intercambiar
    
    // Intercambiar elementos
    str w7, [x5]                 // Guardar elemento menor primero
    str w6, [x5, #4]             // Guardar elemento mayor después

no_swap:
    add w2, w2, #1               // Incrementar índice interno
    b inner_loop                 // Continuar bucle interno

end_inner:
    sub w1, w1, #1               // Decrementar contador externo
    b outer_loop                 // Continuar bucle externo

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
    stp x29, x30, [sp, -16]!     // Guardar registros
    
    adrp x19, array              // Cargar dirección del arreglo
    add x19, x19, :lo12:array
    
    adrp x20, arr_len
    add x20, x20, :lo12:arr_len
    ldr w20, [x20]               // Cargar longitud
    
    mov w21, #0                  // Inicializar contador

print_loop:
    cmp w21, w20                 // Comparar contador con longitud
    bge print_end                // Si terminamos, salir
    
    // Imprimir elemento actual
    adrp x0, msg_elem
    add x0, x0, :lo12:msg_elem
    ldr w1, [x19, w21, UXTW #2]  // Cargar elemento actual
    bl printf
    
    add w21, w21, #1             // Incrementar contador
    b print_loop

print_end:
    // Imprimir nueva línea
    adrp x0, msg_nl
    add x0, x0, :lo12:msg_nl
    bl printf
    
    ldp x29, x30, [sp], 16       // Restaurar registros
    ret 
