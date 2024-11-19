// Autor: Ruiz Barcenas Martin Adolfo
// Fecha: 09-11-2024
// Descripción: Encontrar el prefijo comun mas largo entre dos cadenas
// Asciinema: 

.data
    msg_num_strings: .asciz "Ingrese el número de cadenas: "
    msg_input_string: .asciz "Ingrese la cadena %d: "
    msg_result: .asciz "El prefijo común más largo es: "
    msg_no_prefix: .asciz "No hay prefijo común.\n"
    formato_in_num: .asciz "%d"
    formato_in_str: .asciz "%s"
    newline: .asciz "\n"
    buffer: .skip 1000  // Buffer para almacenar todas las cadenas
    prefix: .skip 100   // Buffer para el prefijo común

.text
.global main
.align 2

main:
    stp x29, x30, [sp, -48]!
    mov x29, sp

    // Pedir número de cadenas
    adrp x0, msg_num_strings
    add x0, x0, :lo12:msg_num_strings
    bl printf

    // Leer número de cadenas
    add x1, sp, 16
    adrp x0, formato_in_num
    add x0, x0, :lo12:formato_in_num
    bl scanf
    ldr w19, [sp, 16]  // w19 = número de cadenas

    // Inicializar puntero al buffer
    adrp x20, buffer
    add x20, x20, :lo12:buffer

    // Leer cadenas
    mov w21, #0  // Contador de cadenas
read_loop:
    // Imprimir mensaje para ingresar cadena
    adrp x0, msg_input_string
    add x0, x0, :lo12:msg_input_string
    add w1, w21, #1
    bl printf

    // Leer cadena
    mov x1, x20
    adrp x0, formato_in_str
    add x0, x0, :lo12:formato_in_str
    bl scanf

    // Avanzar puntero al final de la cadena
advance_ptr:
    ldrb w0, [x20], #1
    cbnz w0, advance_ptr
    sub x20, x20, #1  // Retroceder al carácter nulo

    // Siguiente cadena
    add w21, w21, #1
    cmp w21, w19
    b.lt read_loop

    // Encontrar prefijo común
    adrp x0, buffer
    add x0, x0, :lo12:buffer
    mov w1, w19
    bl find_common_prefix

    // Verificar si hay prefijo común
    adrp x1, prefix
    add x1, x1, :lo12:prefix
    ldrb w0, [x1]
    cbz w0, no_prefix

    // Imprimir resultado
    adrp x0, msg_result
    add x0, x0, :lo12:msg_result
    bl printf

    adrp x0, prefix
    add x0, x0, :lo12:prefix
    bl printf

    adrp x0, newline
    add x0, x0, :lo12:newline
    bl printf
    b end_program

no_prefix:
    adrp x0, msg_no_prefix
    add x0, x0, :lo12:msg_no_prefix
    bl printf

end_program:
    // Salir del programa
    mov x0, #0
    ldp x29, x30, [sp], 48
    ret

// Función para encontrar el prefijo común más largo
// Parámetros: x0 = dirección del buffer de cadenas, w1 = número de cadenas
find_common_prefix:
    stp x29, x30, [sp, -32]!
    mov x29, sp

    str x19, [sp, 16]
    str x20, [sp, 24]

    mov x19, x0  // x19 = dirección del buffer de cadenas
    mov w20, w1  // w20 = número de cadenas

    // Inicializar puntero al prefijo
    adrp x2, prefix
    add x2, x2, :lo12:prefix

prefix_loop:
    ldrb w3, [x19]  // Cargar carácter de la primera cadena
    cbz w3, end_prefix  // Si es nulo, terminar

    mov x4, x19  // x4 = puntero a la cadena actual
    mov w5, w20  // w5 = contador de cadenas

compare_loop:
    ldrb w6, [x4]  // Cargar carácter de la cadena actual
    cmp w3, w6
    b.ne end_prefix  // Si no coincide, terminar

    // Avanzar al siguiente carácter en la cadena actual
advance_string:
    ldrb w6, [x4], #1
    cbnz w6, advance_string

    sub w5, w5, #1  // Decrementar contador de cadenas
    cbnz w5, compare_loop  // Si quedan cadenas, seguir comparando

    // Todos los caracteres coinciden, añadir al prefijo
    strb w3, [x2], #1
    add x19, x19, #1  // Avanzar al siguiente carácter en todas las cadenas
    b prefix_loop

end_prefix:
    // Añadir carácter nulo al final del prefijo
    strb wzr, [x2]

    ldr x19, [sp, 16]
    ldr x20, [sp, 24]
    ldp x29, x30, [sp], 32
    ret 
