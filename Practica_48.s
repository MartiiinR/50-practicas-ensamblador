// Autor: Ruiz Barcenas Martin Adolfo
// Fecha: 09-11-2024
// Descripción: Medir el tiempo de ejecucion de una funcion
// Asciinema: 

.data
    .align 3  // Alineación a 8 bytes
    msg_start: .asciz "Iniciando medición de tiempo...\n"
    msg_end: .asciz "Tiempo de ejecución: %ld.%09ld segundos\n"
    timespec_start: .skip 16  // struct timespec para tiempo inicial
    timespec_end: .skip 16    // struct timespec para tiempo final
    clock_monotonic: .word 1
    sys_clock_gettime: .word 113
    .align 3  // Alineación a 8 bytes para los siguientes datos de 64 bits
    iterations: .quad 1000000  // 1 millón de iteraciones
    billion: .quad 1000000000  // Para ajuste de nanosegundos

.text
.global main
.align 2

main:
    stp x29, x30, [sp, -16]!
    mov x29, sp

    // Imprimir mensaje de inicio
    adrp x0, msg_start
    add x0, x0, :lo12:msg_start
    bl printf

    // Obtener tiempo inicial
    adrp x0, clock_monotonic
    ldr w0, [x0, :lo12:clock_monotonic]
    adrp x1, timespec_start
    add x1, x1, :lo12:timespec_start
    adrp x8, sys_clock_gettime
    ldr w8, [x8, :lo12:sys_clock_gettime]
    svc #0

    // Llamar a la función que queremos medir
    bl function_to_measure

    // Obtener tiempo final
    adrp x0, clock_monotonic
    ldr w0, [x0, :lo12:clock_monotonic]
    adrp x1, timespec_end
    add x1, x1, :lo12:timespec_end
    adrp x8, sys_clock_gettime
    ldr w8, [x8, :lo12:sys_clock_gettime]
    svc #0

    // Calcular la diferencia de tiempo
    adrp x0, timespec_end
    add x0, x0, :lo12:timespec_end
    adrp x1, timespec_start
    add x1, x1, :lo12:timespec_start
    bl calculate_time_diff

    // Imprimir el tiempo de ejecución
    adrp x0, msg_end
    add x0, x0, :lo12:msg_end
    bl printf

    // Salir del programa
    mov x0, #0
    ldp x29, x30, [sp], 16
    ret

// Función que queremos medir (ejemplo: un bucle simple)
function_to_measure:
    mov x0, #0
    adrp x1, iterations
    ldr x1, [x1, :lo12:iterations]
loop:
    add x0, x0, #1
    subs x1, x1, #1
    b.ne loop
    ret

// Función para calcular la diferencia de tiempo
// Parámetros: x0 = puntero a timespec_end, x1 = puntero a timespec_start
// Retorna: x0 = segundos, x1 = nanosegundos
calculate_time_diff:
    ldp x2, x3, [x0]    // Cargar timespec_end (segundos, nanosegundos)
    ldp x4, x5, [x1]    // Cargar timespec_start (segundos, nanosegundos)
    sub x0, x2, x4      // Diferencia en segundos
    sub x1, x3, x5      // Diferencia en nanosegundos
    cmp x1, #0
    b.ge end_calc
    sub x0, x0, #1      // Restar 1 segundo si nanosegundos son negativos
    adrp x2, billion
    ldr x2, [x2, :lo12:billion]
    add x1, x1, x2      // Ajustar nanosegundos
end_calc:
    ret
