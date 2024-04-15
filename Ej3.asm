section .bss
cadena:
    resb 100          ; Reservar espacio para la cadena
subcadena_pares:
    resb 100          ; Reservar espacio para la subcadena de posiciones pares
subcadena_impares:
    resb 100          ; Reservar espacio para la subcadena de posiciones impares

section .data
fmtString:
    db "%s", 0
fmtLF:
    db 10, 0        ; Utilizamos 10 para el salto de línea en lugar de 0xA
mensajeEntrada:
    db "Ingresa una cadena: ", 0
mensajeSubcadenaPares:
    db "Subcadena de posiciones pares: %s", 0
mensajeSubcadenaImpares:
    db "Subcadena de posiciones impares: %s", 0

section .text
global main
global _start

extern printf
extern gets
extern exit
extern getchar

; Rutinas útiles
leerCadena:
    push cadena
    call gets
    add esp, 4
    ret

mostrarMensaje:
    push esi
    push fmtString
    call printf
    add esp, 8
    ret

mostrarSaltoDeLinea:
    push fmtLF
    call printf
    add esp, 4
    ret

main:
    ; Mostrar mensaje de entrada
    mov esi, mensajeEntrada
    call mostrarMensaje

    ; Leer la cadena
    call leerCadena

    ; Inicializar índices para recorrer la cadena
    mov edi, 0   ; Índice para posiciones pares (iniciando en 0)
    mov esi, 1   ; Índice para posiciones impares (iniciando en 1)

    ; Inicializar índices para subcadenas
    mov ebx, 0   ; Índice para subcadena de posiciones pares
    mov ecx, 0   ; Índice para subcadena de posiciones impares

    ; Recorrer la cadena y construir subcadenas de posiciones pares e impares
    mov eax, [cadena]   ; Cargar la dirección de la cadena

    recorrer_cadena:
        mov al, byte [eax + esi]   ; Cargar un byte de la cadena en posiciones impares
        test al, al   ; Comprobar si es el final de la cadena
        jz fin_recorrido
        mov byte [subcadena_pares + ebx], al   ; Guardar el byte en la subcadena de posiciones pares
        inc ebx   ; Incrementar el índice de la subcadena de posiciones pares

        mov al, byte [eax + edi]   ; Cargar un byte de la cadena en posiciones pares
        test al, al   ; Comprobar si es el final de la cadena
        jz fin_recorrido
        mov byte [subcadena_impares + ecx], al   ; Guardar el byte en la subcadena de posiciones impares
        inc ecx   ; Incrementar el índice de la subcadena de posiciones impares

        inc edi   ; Incrementar el índice para posiciones pares
        inc edi   ; Incrementar el índice para posiciones pares
        inc esi   ; Incrementar el índice para posiciones impares

        jmp recorrer_cadena

    fin_recorrido:
        ; Agregar terminadores nulos a las subcadenas
        mov byte [subcadena_pares + ebx], 0
        mov byte [subcadena_impares + ecx], 0

        ; Mostrar subcadenas de posiciones pares e impares
        mov esi, mensajeSubcadenaPares
        mov edi, subcadena_pares
        call mostrarMensaje

        mov esi, mensajeSubcadenaImpares
        mov edi, subcadena_impares
        call mostrarMensaje

        ; Agregar saltos de línea
        call mostrarSaltoDeLinea

        ; Pausa para mantener la ventana abierta (espera una tecla)
        call getchar

        ; Salir del programa
        push 0
        call exit

_start:
    call main
