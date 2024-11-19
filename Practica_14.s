// Autor: Ruiz Barcenas Martin Adolfo
// Fecha: 09-11-2024
// Descripción: Busqueda Lineal de un numero en un arreglo
// Asciinema: 

.data
array:      .word 12, 45, 7, 23, 67, 89, 34, 56, 90, 14 // Arreglo de ejemplo
arr_len:    .word 10                                    // Longitud del arreglo
target:     .word 23                                    // Valor a buscar
msg_found:  .asciz "El valor %d se encuentra en el arreglo.\n" // Mensaje cuando se encuentra el valor
msg_not_found: .asciz "El valor %d NO se encuentra en el arreglo.\n" // Mensaje cuando no se encuentra el valor

    .text
    .global main

main:
    // Guardar el puntero de marco y el enlace de retorno
    stp x29, x30, [sp, -16]!     // Reservar espacio en la pila
    mov x29, sp                  // Establecer el puntero de marco
    
    // Cargar la dirección y longitud del arreglo
    adrp x0, arr_len             // Cargar la página base de arr_len en x0
    add x0, x0, :lo12:arr_len    // Cargar el desplazamiento bajo de arr_len
    ldr w1, [x0]                 // Obtener la longitud del arreglo en w1
    adrp x2, array               // Cargar la página base de array en x2
    add x2, x2, :lo12:array      // Cargar el desplazamiento bajo de array
    adrp x3, target              // Cargar la página base de target en x3
    add x3, x3, :lo12:target     // Cargar el desplazamiento bajo de target
    ldr w5, [x3]                 // Cargar el valor objetivo en w5

    // Inicializar el índice
    mov x6, #0                   // Índice inicial (x6) = 0

loop:
    // Comparar el índice (x6) con la longitud del arreglo (w1)
    // Se usa `w6` como una extensión de 32 bits de `x6`
    cmp w6, w1                   // Comparar x6 (como w6) con w1
    bge end_loop                 // Si el índice es mayor o igual, salir del bucle
    ldr w4, [x2, x6, LSL #2]     // Cargar el valor del arreglo en w4 (multiplicamos x6 por 4)
    cmp w4, w5                   // Comparar el valor en el arreglo (w4) con el valor objetivo (w5)
    beq found                    // Si el valor es igual, saltar a la etiqueta found
    add x6, x6, #1               // Incrementar el índice
    b loop                       // Continuar con la siguiente iteración

found:
    // Imprimir el mensaje de valor encontrado
    adrp x0, msg_found           // Cargar la página base de msg_found en x0
    add x0, x0, :lo12:msg_found  // Cargar el desplazamiento bajo de msg_found
    mov w1, w5                   // Mover el valor encontrado (w5) a w1 para printf
    bl printf                    // Llamar a printf para imprimir el mensaje

    b end_program                // Ir al final del programa

end_loop:
    // Imprimir el mensaje de valor no encontrado
    adrp x0, msg_not_found       // Cargar la página base de msg_not_found en x0
    add x0, x0, :lo12:msg_not_found // Cargar el desplazamiento bajo de msg_not_found
    mov w1, w5                   // Mover el valor objetivo (w5) a w1 para printf
    bl printf                    // Llamar a printf para imprimir el mensaje

end_program:
    // Restaurar el puntero de pila y regresar
    ldp x29, x30, [sp], 16       // Restaurar el puntero de marco y el enlace de retorno
    ret                          // Regresar del programa
