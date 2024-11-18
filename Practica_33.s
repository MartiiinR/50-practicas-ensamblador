// Autor: Ruiz Barcenas Martin Adolfo
// Fecha: 09-11-2024
// Descripción: Suma de todos los elementos de un arreglo
// Asciinema: 

.global _start       // Punto de entrada para el sistema operativo

_start:
    // Inicializamos el arreglo y el tamaño (solo para este ejemplo)
    ldr x0, =arreglo // Dirección base del arreglo en x0
    mov x1, #5       // Número de elementos en el arreglo (ejemplo: 5)

    // Inicializamos la suma a 0
    mov x2, #0       // x2 almacenará el resultado de la suma

sum_loop:
    cbz x1, end_sum  // Si el número de elementos es 0, terminamos el bucle

    // Cargamos el elemento actual y lo sumamos a x2
    ldr w3, [x0], #4 // Carga el elemento de 4 bytes (32 bits) y avanza el puntero
    add x2, x2, x3   // Suma el valor en x3 al acumulador en x2

    // Decrementamos el contador de elementos
    sub x1, x1, #1   // Reducimos el número de elementos en 1
    b sum_loop       // Repetimos el bucle

end_sum:
    // El resultado final (suma de elementos) está en x2
    mov w8, #93      // Código de salida del sistema para "exit" en Linux
    svc #0           // Llamada al sistema para finalizar el programa

// Datos del arreglo (ejemplo)
.section .data
arreglo:
    .word 1, 2, 3, 4, 5 // Ejemplo de arreglo con 5 elementos
