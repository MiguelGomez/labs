;Nombre: capcad.asm
;Descripci¢n: Captura con eco una cadena de m ximo 30 caracteres 
;y la da por capturada cuando el usuario pulsa la tecla ENTER.
;Toma en cuenta el funcionamiento del BACKSPACE.
;Autor: Iv n No‚ Alvarado Le¢n.
;Fecha: 22/Feb/07.

.model small
.stack 100h
.data
    cadena db 30 dup(0),'$'
.code
    ;ds apunta a data
    mov ax,@data
    mov ds,ax
    ;inicializar registros si y cx
    xor di,di    
captura:
    ;captura tecla    
    mov ah,10h
    int 16h     
    ;¨es enter?
    cmp al,13
    je salir
    ;¨es backspace?
    cmp al,8
    je backspace
    ;¨30 caracteres capturados?
    cmp di,30
    je captura
    ;mover a memoria el caracter
    mov cadena[di],al
    inc di
    ;despliega tecla
    mov ah,02h
    mov dl,al
    int 21h
    jmp captura

backspace:
    ;¨es el primer car cter?
    cmp di,0
    je captura
    ;limpiar £ltimo byte de cadena
    dec di
    mov cadena[di],0
    ;leer posici¢n de cursor
    mov ah,03h
    xor bx,bx
    int 10h
    ;regresar cursor una columna
    dec dl
    mov ah,02h
    xor bx,bx
    int 10h
    ;desplegar espacio en blanco sin mover cursor
    mov ah,09h
    mov al,32
    xor bh,bh
    mov bl,07h
    mov cx,1
    int 10h
    jmp captura

salir:
    ;nueva linea
    mov ah,2
    mov dl,10
    int 21h
    mov ah,2
    mov dl,13
    int 21h
    ;desplegar la cadena
    mov ah,09h
    mov dx,offset cadena
    int 21h
    ;terminar
    mov ah,4ch
    int 21h
end
