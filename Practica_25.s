// Autor: Ruiz Barcenas Martin Adolfo
// Fecha: 09-11-2024
// Descripción: Contar vocales y consonantes en una cadena en ARM64
// Asciinema: 

.data
    msg_ingreso: .asciz "Ingrese una cadena: "
    msg_vocales: .asciz "Número de vocales: %d\n"
    msg_consonantes: .asciz "Número de consonantes: %d\n"
    buffer: .skip 100
    formato_str: .asciz "%99s"

.text
.global main
.align 2

main:
    // Prólogo
    stp x29, x30, [sp, -32]!           // Aumentamos espacio para variables locales
    mov x29, sp
    
    // Inicializar contadores
    str xzr, [x29, 16]                 // Contador de vocales en [x29, 16]
    str xzr, [x29, 24]                 // Contador de consonantes en [x29, 24]

    // Mostrar mensaje de ingreso
    adrp x0, msg_ingreso
    add x0, x0, :lo12:msg_ingreso
    bl printf

    // Leer cadena
    adrp x0, formato_str
    add x0, x0, :lo12:formato_str
    adrp x1, buffer
    add x1, x1, :lo12:buffer
    bl scanf

    // Preparar para procesar la cadena
    adrp x0, buffer
    add x0, x0, :lo12:buffer
    mov x1, #0                         // Índice

contar_loop:
    ldrb w2, [x0, x1]                 // Cargar carácter actual
    cbz w2, fin_conteo                // Si es 0, terminar

    // Convertir a minúscula si es mayúscula
    cmp w2, #'A'
    b.lt no_es_letra
    cmp w2, #'Z'
    b.gt check_minuscula
    add w2, w2, #32                   // Convertir a minúscula

check_minuscula:
    cmp w2, #'a'
    b.lt no_es_letra
    cmp w2, #'z'
    b.gt no_es_letra

    // Verificar si es vocal
    cmp w2, #'a'
    b.eq es_vocal
    cmp w2, #'e'
    b.eq es_vocal
    cmp w2, #'i'
    b.eq es_vocal
    cmp w2, #'o'
    b.eq es_vocal
    cmp w2, #'u'
    b.eq es_vocal

    // Si llegamos aquí, es consonante
    ldr x3, [x29, 24]                 // Cargar contador de consonantes
    add x3, x3, #1                    // Incrementar
    str x3, [x29, 24]                 // Guardar contador
    b siguiente_char

es_vocal:
    ldr x3, [x29, 16]                 // Cargar contador de vocales
    add x3, x3, #1                    // Incrementar
    str x3, [x29, 16]                 // Guardar contador

siguiente_char:
no_es_letra:
    add x1, x1, #1                    // Siguiente carácter
    b contar_loop

fin_conteo:
    // Mostrar número de vocales
    adrp x0, msg_vocales
    add x0, x0, :lo12:msg_vocales
    ldr x1, [x29, 16]                 // Cargar contador de vocales
    bl printf

    // Mostrar número de consonantes
    adrp x0, msg_consonantes
    add x0, x0, :lo12:msg_consonantes
    ldr x1, [x29, 24]                 // Cargar contador de consonantes
    bl printf

    // Epílogo y retorno
    mov w0, #0
    ldp x29, x30, [sp], 32
    ret
