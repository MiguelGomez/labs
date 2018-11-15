;Ejemplo1.asm
;Despliega una cadena.
;Autor: Iv n No‚ Alvarado Le¢n.
;Fecha: Febrero 14, 2007.

.model small
.stack 100h
.data
    mensaje db 'Primer programa de la materia de ensamblador.','$'
.code
    ;ds apunta a data.
    mov ax, @data
    mov ds, ax
    ;desplegar una cadena.
    mov ah, 09h
    mov dx, offset mensaje
    int 21h
    ;terminar.
    mov ah, 4ch
    int 21h
end
