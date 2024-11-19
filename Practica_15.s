// Autor: Ruiz Barcenas Martin Adolfo
// Fecha: 09-11-2024
// Descripción: Busqueda binaria de un numero en un arreglo.
// Asciinema: 

.data
array:      .word 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21    // Arreglo ordenado para búsqueda binaria
arr_len:    .word 11                                   // Longitud del arreglo
target:     .word 7                                     // Valor a buscar
msg_found:  .asciz "El valor %d fue encontrado en la posición %d\n"
msg_not:    .asciz "El valor %d no fue encontrado en el arreglo\n"

    .text
    .global main
main:
    // Guardar el puntero de marco y el enlace de retorno
    stp x29, x30, [sp, -16]!     // Reservar espacio en la pila
    mov x29, sp                   // Establecer el puntero de marco
    
    // Inicializar registros para búsqueda binaria
    adrp x0, array               // Cargar la página base del array
    add x0, x0, :lo12:array      // Cargar el desplazamiento bajo del array
    
    mov x1, #0                   // left = 0
    adrp x2, arr_len            
    add x2, x2, :lo12:arr_len
    ldr w2, [x2]                 // Cargar longitud del array
    sub x2, x2, #1              // right = length - 1
    
    adrp x3, target
    add x3, x3, :lo12:target
    ldr w3, [x3]                // Cargar valor objetivo

binary_search:
    cmp x1, x2                   // Comparar left con right
    bgt not_found               // Si left > right, elemento no encontrado
    
    // Calcular mid = (left + right) / 2
    add x4, x1, x2              // x4 = left + right
    lsr x4, x4, #1              // x4 = (left + right) / 2
    
    // Cargar array[mid]
    lsl x5, x4, #2              // x5 = mid * 4 (tamaño de word)
    add x5, x0, x5              // x5 = dirección de array[mid]
    ldr w6, [x5]                // w6 = array[mid]
    
    // Comparar array[mid] con target
    cmp w6, w3
    beq found                   // Si son iguales, elemento encontrado
    blt greater                 // Si array[mid] < target, buscar en mitad superior
    
    // Buscar en mitad inferior
    sub x2, x4, #1              // right = mid - 1
    b binary_search
    
greater:
    add x1, x4, #1              // left = mid + 1
    b binary_search
    
found:
    // Imprimir mensaje de éxito
    adrp x0, msg_found
    add x0, x0, :lo12:msg_found
    mov w1, w3                  // Primer argumento: valor buscado
    mov w2, w4                  // Segundo argumento: posición encontrada
    bl printf
    b end

not_found:
    // Imprimir mensaje de no encontrado
    adrp x0, msg_not
    add x0, x0, :lo12:msg_not
    mov w1, w3                  // Primer argumento: valor buscado
    bl printf

end:
    // Restaurar y retornar
    ldp x29, x30, [sp], 16
    ret
