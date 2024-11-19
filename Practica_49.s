// Autor: Ruiz Barcenas Martin Adolfo
// Fecha: 09-11-2024
// Descripción: Leer entrada desde el teclado
// Asciinema: 

.data
    prompt: .asciz "Ingrese una cadena de texto (máximo 100 caracteres): "
    output: .asciz "Usted ingresó: %s\n"
    input_buffer: .skip 101  // 100 caracteres + 1 para el carácter nulo

.text
.global main
.align 2

main:
    stp x29, x30, [sp, -16]!
    mov x29, sp

    // Imprimir el prompt
    adrp x0, prompt
    add x0, x0, :lo12:prompt
    bl printf

    // Leer la entrada del usuario
    mov x0, #0          // Stdin
    adrp x1, input_buffer
    add x1, x1, :lo12:input_buffer
    mov x2, #100        // Tamaño máximo a leer
    mov x8, #63         // syscall number para read
    svc #0

    // Verificar si la lectura fue exitosa
    cmp x0, #0
    b.le end_program    // Si x0 <= 0, terminar el programa

    // Asegurar que la cadena termine con un carácter nulo
    adrp x1, input_buffer
    add x1, x1, :lo12:input_buffer
    add x1, x1, x0      // x1 ahora apunta al final de la entrada
    strb wzr, [x1]      // Almacenar carácter nulo al final

    // Imprimir la cadena ingresada
    adrp x0, output
    add x0, x0, :lo12:output
    adrp x1, input_buffer
    add x1, x1, :lo12:input_buffer
    bl printf

end_program:
    // Salir del programa
    mov x0, #0
    ldp x29, x30, [sp], 16
    ret
