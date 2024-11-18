// Autor: Ruiz Barcenas Martin Adolfo
// Fecha: 09-11-2024
// Descripción: Calcular el Maximo Comun Divisor de dos numeros usando el algoritmo de Euclides
// Asciinema: 

.global _start      // Punto de entrada para el sistema operativo

_start:
    // Cargamos los valores en los registros
    mov x0, #56     // Primer número (por ejemplo, 56)
    mov x1, #98     // Segundo número (por ejemplo, 98)

mcd_loop:
    cmp x1, #0         // Comparamos x1 con 0
    beq end_mcd        // Si x1 es 0, terminamos el bucle (MCD en x0)
    
    // Calculamos x0 = x0 % x1 usando una instrucción de división entera
    udiv x2, x0, x1    // x2 = x0 / x1 (división entera)
    msub x2, x2, x1, x0 // x2 = x0 - (x2 * x1), lo que da el resto
    
    mov x0, x1         // Intercambiamos x0 con x1
    mov x1, x2         // y x1 con el resto (nuevo valor para la siguiente iteración)
    b mcd_loop         // Repetimos el proceso

end_mcd:
    // Resultado en x0 (el MCD de los dos números originales)
    mov w8, #93        // Código de salida del sistema para "exit" en Linux
    svc #0             // Llamada al sistema para finalizar el programa
