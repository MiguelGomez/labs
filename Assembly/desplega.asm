;desple.asm
;Descripci¢n: limpia pantalla, despliega datos y espera tecla.
;Autor: Iv n No‚ Alvarado Le¢n.
;Fecha: 27/Feb/07

.model small
.stack 100h
.data
    strdatos db 'Carrera: ISC',10,13
             db 'Materia: Lenguaje Ensamblador.',10,13
             db 'Alumno:  Iv n No‚ Alvarado Le¢n.',10,13
             db 'Fecha:   27/Feb/07.','$'
.code
    mov ax,@data
    mov ds,ax
    ;limpia pantalla
    mov ah,06h
    mov al,0
    mov bh,07h
    mov ch,0
    mov cl,0
    mov dh,24
    mov dl,80
    int 10h
    ;posiciona cursor
    mov ah,02h
    xor bh,bh
    xor dx,dx
    int 10h
    ;despliega datos
    mov ah,09h
    mov dx,offset strdatos
    int 21h
    ;espera tecla
    mov ah,0
    int 16h
    ;terminar
    mov ah,04ch
    int 21h
end
