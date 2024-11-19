// Autor: Ruiz Barcenas Martin Adolfo
// Fecha: 09-11-2024
// Descripción: Establecer, borrar y alternar bits en un numero
// Asciinema: 

.data
    msg_num: .asciz "Ingrese un número: "
    msg_bit: .asciz "Ingrese la posición del bit (0-7): "
    formato_in: .asciz "%ld"
    
    msg_original: .asciz "\nNúmero original:        %ld\n"
    msg_binario: .asciz "En binario:             "
    
    msg_menu: .asciz "\nOperaciones disponibles:\n"
    msg_menu1: .asciz "1. Establecer bit (SET)\n"
    msg_menu2: .asciz "2. Borrar bit (CLEAR)\n"
    msg_menu3: .asciz "3. Alternar bit (TOGGLE)\n"
    msg_menu4: .asciz "4. Salir\n"
    msg_opcion: .asciz "Seleccione una opción: "
    
    msg_set: .asciz "\nResultado SET bit %ld:   %ld\n"
    msg_set_bin: .asciz "SET en binario:         "
    
    msg_clear: .asciz "\nResultado CLEAR bit %ld: %ld\n"
    msg_clear_bin: .asciz "CLEAR en binario:       "
    
    msg_toggle: .asciz "\nResultado TOGGLE bit %ld: %ld\n"
    msg_toggle_bin: .asciz "TOGGLE en binario:      "
    
    formato_bit: .asciz "%d"
    newline: .asciz "\n"

.text
.global main
.align 2

// Función para imprimir número en binario
print_binary:
    stp x29, x30, [sp, -48]!
    mov x29, sp
    str x0, [sp, 16]                  // Guardar número
    str x1, [sp, 24]                  // Guardar cantidad de bits
    mov x19, x1                       // Contador de bits
    
print_bit_loop:
    cmp x19, #0
    b.le print_binary_end
    
    sub x19, x19, #1
    ldr x0, [sp, 16]
    mov x1, x19
    lsr x2, x0, x1
    and x2, x2, #1
    
    adrp x0, formato_bit
    add x0, x0, :lo12:formato_bit
    mov x1, x2
    bl printf
    
    b print_bit_loop
    
print_binary_end:
    adrp x0, newline
    add x0, x0, :lo12:newline
    bl printf
    
    ldp x29, x30, [sp], 48
    ret

main:
    // Prólogo
    stp x29, x30, [sp, -80]!
    mov x29, sp

    // Pedir número
    adrp x0, msg_num
    add x0, x0, :lo12:msg_num
    bl printf
    
    // Leer número
    adrp x0, formato_in
    add x0, x0, :lo12:formato_in
    add x1, x29, 16
    bl scanf
    
    // Pedir posición del bit
    adrp x0, msg_bit
    add x0, x0, :lo12:msg_bit
    bl printf
    
    // Leer posición del bit
    adrp x0, formato_in
    add x0, x0, :lo12:formato_in
    add x1, x29, 24
    bl scanf
    
    // Cargar valores en registros
    ldr x19, [x29, 16]                // Número original
    ldr x20, [x29, 24]                // Posición del bit
    
menu_loop:
    // Mostrar menú
    adrp x0, msg_menu
    add x0, x0, :lo12:msg_menu
    bl printf
    
    adrp x0, msg_menu1
    add x0, x0, :lo12:msg_menu1
    bl printf
    
    adrp x0, msg_menu2
    add x0, x0, :lo12:msg_menu2
    bl printf
    
    adrp x0, msg_menu3
    add x0, x0, :lo12:msg_menu3
    bl printf
    
    adrp x0, msg_menu4
    add x0, x0, :lo12:msg_menu4
    bl printf
    
    // Mostrar número actual
    adrp x0, msg_original
    add x0, x0, :lo12:msg_original
    mov x1, x19
    bl printf
    
    adrp x0, msg_binario
    add x0, x0, :lo12:msg_binario
    bl printf
    mov x0, x19
    mov x1, #8                        // Mostrar 8 bits
    bl print_binary
    
    // Pedir opción
    adrp x0, msg_opcion
    add x0, x0, :lo12:msg_opcion
    bl printf
    
    // Leer opción
    adrp x0, formato_in
    add x0, x0, :lo12:formato_in
    add x1, x29, 32
    bl scanf
    
    // Procesar opción
    ldr x21, [x29, 32]
    cmp x21, #4
    b.eq menu_exit
    
    cmp x21, #1
    b.eq do_set
    cmp x21, #2
    b.eq do_clear
    cmp x21, #3
    b.eq do_toggle
    b menu_loop

do_set:
    mov x22, #1                       // Preparar máscara
    lsl x22, x22, x20                 // Desplazar 1 a la posición del bit
    orr x23, x19, x22                 // Aplicar OR para establecer el bit
    
    adrp x0, msg_set
    add x0, x0, :lo12:msg_set
    mov x1, x20
    mov x2, x23
    bl printf
    
    adrp x0, msg_set_bin
    add x0, x0, :lo12:msg_set_bin
    bl printf
    mov x0, x23
    mov x1, #8
    bl print_binary
    
    mov x19, x23                      // Actualizar número
    b menu_loop

do_clear:
    mov x22, #1                       // Preparar máscara
    lsl x22, x22, x20                 // Desplazar 1 a la posición del bit
    mvn x22, x22                      // Invertir bits para crear máscara de borrado
    and x23, x19, x22                 // Aplicar AND para borrar el bit
    
    adrp x0, msg_clear
    add x0, x0, :lo12:msg_clear
    mov x1, x20
    mov x2, x23
    bl printf
    
    adrp x0, msg_clear_bin
    add x0, x0, :lo12:msg_clear_bin
    bl printf
    mov x0, x23
    mov x1, #8
    bl print_binary
    
    mov x19, x23                      // Actualizar número
    b menu_loop

do_toggle:
    mov x22, #1                       // Preparar máscara
    lsl x22, x22, x20                 // Desplazar 1 a la posición del bit
    eor x23, x19, x22                 // Aplicar XOR para alternar el bit
    
    adrp x0, msg_toggle
    add x0, x0, :lo12:msg_toggle
    mov x1, x20
    mov x2, x23
    bl printf
    
    adrp x0, msg_toggle_bin
    add x0, x0, :lo12:msg_toggle_bin
    bl printf
    mov x0, x23
    mov x1, #8
    bl print_binary
    
    mov x19, x23                      // Actualizar número
    b menu_loop

menu_exit:
    // Epílogo y retorno
    mov w0, #0
    ldp x29, x30, [sp], 80
    ret
