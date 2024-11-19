// Autor: Ruiz Barcenas Martin Adolfo
// Fecha: 09-11-2024
// Descripción: Conversion de ASCII a un entero
// Asciinema: 

.data
ascii_char: .asciz "5"           // Carácter ASCII a convertir
msg_input:  .asciz "Carácter ASCII ingresado: %c\n"
msg_result: .asciz "Valor numérico: %d\n"

    .text
    .global main
main:
    // Guardar el puntero de marco y el enlace de retorno
    stp x29, x30, [sp, -16]!    // Reservar espacio en la pila
    mov x29, sp                  // Establecer el puntero de marco
    
    // Mostrar el carácter ASCII ingresado
    adrp x0, msg_input          // Cargar la página base del mensaje de entrada
    add x0, x0, :lo12:msg_input // Cargar el desplazamiento bajo del mensaje
    adrp x1, ascii_char         // Cargar la dirección del carácter ASCII
    add x1, x1, :lo12:ascii_char
    ldrb w1, [x1]              // Cargar el carácter en w1
    bl printf                   // Imprimir el carácter

    // Realizar la conversión de ASCII a entero
    adrp x0, ascii_char         // Cargar la dirección del carácter nuevamente
    add x0, x0, :lo12:ascii_char
    ldrb w1, [x0]              // Cargar el carácter en w1
    sub w1, w1, #48            // Restar 48 (ASCII '0') para obtener el valor numérico

    // Imprimir el resultado
    adrp x0, msg_result        // Cargar la dirección del mensaje de resultado
    add x0, x0, :lo12:msg_result
    bl printf                  // Imprimir el resultado

    // Restaurar y retornar
    mov w0, #0                 // Código de retorno 0
    ldp x29, x30, [sp], 16     // Restaurar registros
    ret  
