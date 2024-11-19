// Autor: Ruiz Barcenas Martin Adolfo
// Fecha: 09-11-2024
// Descripción: Conversion de entero a ASCII
// Asciinema: 

.data
numero:     .word   43            // Número entero a convertir
ascii_res:  .skip   2            // Espacio para el carácter ASCII (1 byte) + null terminator
msg_input:  .asciz "Número entero ingresado: %d\n"
msg_result: .asciz "Carácter ASCII resultante: %c\n"

    .text
    .global main
main:
    // Guardar el puntero de marco y el enlace de retorno
    stp x29, x30, [sp, -16]!    // Reservar espacio en la pila
    mov x29, sp                  // Establecer el puntero de marco
    
    // Mostrar el número entero original
    adrp x0, msg_input          // Cargar la página base del mensaje de entrada
    add x0, x0, :lo12:msg_input // Cargar el desplazamiento bajo del mensaje
    adrp x1, numero             // Cargar la dirección del número
    add x1, x1, :lo12:numero
    ldr w1, [x1]                // Cargar el número en w1
    bl printf                    // Imprimir el número

    // Realizar la conversión de entero a ASCII
    adrp x0, numero             // Cargar la dirección del número nuevamente
    add x0, x0, :lo12:numero
    ldr w1, [x0]                // Cargar el número en w1
    add w1, w1, #48             // Sumar 48 para obtener el código ASCII

    // Guardar el resultado ASCII
    adrp x0, ascii_res          // Cargar la dirección del buffer ASCII
    add x0, x0, :lo12:ascii_res
    strb w1, [x0]               // Guardar el carácter ASCII
    mov w1, #0                  // Null terminator
    strb w1, [x0, #1]           // Guardar el null terminator

    // Imprimir el resultado
    adrp x0, msg_result         // Cargar la dirección del mensaje de resultado
    add x0, x0, :lo12:msg_result
    adrp x1, ascii_res          // Cargar la dirección del carácter ASCII
    add x1, x1, :lo12:ascii_res
    ldrb w1, [x1]               // Cargar el carácter ASCII en w1
    bl printf                   // Imprimir el resultado

    // Restaurar y retornar
    mov w0, #0                  // Código de retorno 0
    ldp x29, x30, [sp], 16      // Restaurar registros
    ret
