// Autor: Ruiz Barcenas Martin Adolfo
// Fecha: 09-11-2024
// Descripción: 
// Asciinema: 

.data
    filename: .asciz "mensaje.txt"
    message: .asciz "Hola, este es un mensaje escrito desde ensamblador ARM64!\n"
    error_create: .asciz "Error al crear el archivo.\n"
    error_write: .asciz "Error al escribir en el archivo.\n"
    success: .asciz "Mensaje escrito exitosamente en el archivo.\n"

.text
.global main
.align 2

main:
    stp x29, x30, [sp, -16]!
    mov x29, sp

    // Crear el archivo
    mov x0, -100                // AT_FDCWD (directorio de trabajo actual)
    adrp x1, filename
    add x1, x1, :lo12:filename
    mov x2, 0x41                // O_WRONLY | O_CREAT
    mov x3, 0644                // Permisos del archivo
    mov x8, 56                  // syscall openat
    svc 0

    // Verificar si la creación fue exitosa
    cmp x0, 0
    b.lt create_error

    // Guardar el descriptor de archivo
    mov x19, x0

    // Escribir en el archivo
    mov x0, x19                 // Descriptor de archivo
    adrp x1, message
    add x1, x1, :lo12:message
    mov x2, 56                  // Longitud del mensaje
    mov x8, 64                  // syscall write
    svc 0

    // Verificar si la escritura fue exitosa
    cmp x0, 56
    b.ne write_error

    // Cerrar el archivo
    mov x0, x19
    mov x8, 57                  // syscall close
    svc 0

    // Imprimir mensaje de éxito
    adrp x0, success
    add x0, x0, :lo12:success
    bl printf

    b end_program

create_error:
    // Imprimir mensaje de error de creación
    adrp x0, error_create
    add x0, x0, :lo12:error_create
    bl printf
    b end_program

write_error:
    // Imprimir mensaje de error de escritura
    adrp x0, error_write
    add x0, x0, :lo12:error_write
    bl printf
    // Cerrar el archivo en caso de error
    mov x0, x19
    mov x8, 57                  // syscall close
    svc 0

end_program:
    // Salir del programa
    mov x0, 0
    ldp x29, x30, [sp], 16
    ret
