// Autor: Ruiz Barcenas Martin Adolfo
// Fecha: 09-11-2024
// Descripción: Calcular la longitud de una cadena
// Asciinema: 


.data
    msg_ingreso: .asciz "Ingrese una cadena: "
    msg_resultado: .asciz "La longitud de la cadena es: %d\n"
    buffer: .skip 100                    // Buffer para almacenar la cadena
    formato_str: .asciz "%99s"          // Cambiado a %s para mejor manejo

.text
.global main
.align 2

main:
    // Prólogo
    stp x29, x30, [sp, -16]!           // Guardar frame pointer y link register
    mov x29, sp

    // Mostrar mensaje de ingreso
    adrp x0, msg_ingreso               // Cargar dirección base
    add x0, x0, :lo12:msg_ingreso      // Añadir offset
    bl printf

    // Leer cadena ingresada por el usuario
    adrp x0, formato_str
    add x0, x0, :lo12:formato_str
    adrp x1, buffer
    add x1, x1, :lo12:buffer
    bl scanf

    // Calcular la longitud de la cadena
    adrp x0, buffer
    add x0, x0, :lo12:buffer
    mov x1, #0                         // Inicializar contador en 0

contar_loop:
    ldrb w2, [x0, x1]                 // Cargar byte actual
    cbz w2, fin_conteo                // Si es 0, terminar
    add x1, x1, #1                    // Incrementar contador
    b contar_loop                     // Siguiente iteración

fin_conteo:
    // Mostrar el resultado
    adrp x0, msg_resultado
    add x0, x0, :lo12:msg_resultado
    mov x2, x1                        // Mover longitud a x2
    mov x1, x2                        // Copiar longitud a x1 para printf
    bl printf

    // Epílogo y retorno
    mov w0, #0                        // Retornar 0
    ldp x29, x30, [sp], 16           // Restaurar frame pointer y link register
    ret
