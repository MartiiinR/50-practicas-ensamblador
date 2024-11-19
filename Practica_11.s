// Autor: Ruiz Barcenas Martin Adolfo
// Fecha: 09-11-2024
// Descripción: Verificar si una cadena de texto es un palindromo
// Asciinema: 

.data
msg_prompt: .asciz "Ingresa una cadena: "       // Mensaje para solicitar la cadena
msg_result_palindrome: .asciz "Es un palíndromo\n" // Mensaje si la cadena es palíndromo
msg_result_not_palindrome: .asciz "No es un palíndromo\n" // Mensaje si la cadena no es palíndromo
fmt_str: .asciz "%s"                            // Formato para leer cadenas

    .text
    .global main

main:
    // Guardar el puntero de marco y el enlace de retorno
    stp x29, x30, [sp, -32]!    // Reservar espacio en la pila
    mov x29, sp                 // Establecer el puntero de marco
    sub sp, sp, #256            // Reservar espacio para la cadena en la pila

    // Solicitar la cadena
    ldr x0, =msg_prompt          // Cargar el mensaje para la cadena
    bl printf                    // Imprimir el mensaje
    ldr x0, =fmt_str             // Cargar el formato para leer una cadena
    mov x1, sp                   // Dirección donde se guardará la cadena en la pila
    bl scanf                     // Leer la cadena desde el usuario

    // Cargar la cadena desde la pila
    mov x0, sp                   // Dirección de la cadena en x0
    bl is_palindrome             // Llamar a la función para verificar si es palíndromo

    // Comprobar el resultado
    cmp w0, #1                   // Comparar el resultado con 1 (palíndromo)
    beq print_palindrome         // Si es igual, ir a print_palindrome

print_not_palindrome:
    ldr x0, =msg_result_not_palindrome  // Cargar el mensaje "No es un palíndromo"
    bl printf                           // Imprimir el mensaje
    b end                               // Ir al final del programa

print_palindrome:
    ldr x0, =msg_result_palindrome       // Cargar el mensaje "Es un palíndromo"
    bl printf                            // Imprimir el mensaje

end:
    // Restaurar el puntero de pila y regresar
    add sp, sp, #256             // Restaurar el puntero de pila
    ldp x29, x30, [sp], 32       // Restaurar el puntero de marco y el enlace de retorno
    ret                          // Regresar del programa

// Función para verificar si una cadena es palíndromo
// Entrada: x0 - dirección de la cadena
// Salida: w0 - 1 si es palíndromo, 0 si no lo es
is_palindrome:
    // Guardar punteros
    mov x1, x0                   // Guardar el inicio de la cadena en x1
    mov x2, x0                   // Guardar el final de la cadena en x2

find_end:
    ldrb w3, [x2], #1            // Leer el siguiente carácter de la cadena
    cmp w3, #0                   // Comparar con el final de la cadena (NULL)
    bne find_end                 // Continuar hasta encontrar el NULL
    sub x2, x2, #2               // Retroceder un carácter

check_palindrome:
    cmp x1, x2                   // Comparar los punteros (inicio >= final)
    bge palindrome               // Si se cruzan, es un palíndromo

    ldrb w3, [x1], #1            // Leer el carácter de inicio
    ldrb w4, [x2], #-1           // Leer el carácter de final
    cmp w3, w4                   // Comparar los caracteres
    bne not_palindrome           // Si no coinciden, no es un palíndromo

    b check_palindrome           // Continuar con el siguiente par

palindrome:
    mov w0, #1                   // Retornar 1 (es palíndromo)
    ret

not_palindrome:
    mov w0, #0                   // Retornar 0 (no es palíndromo)
    ret
