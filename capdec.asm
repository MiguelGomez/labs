;Nombre: capcad.asm
;Descripci¢n: Captura con eco una cadena de m ximo 30 caracteres 
;y la da por capturada cuando el usuario pulsa la tecla ENTER.
;Toma en cuenta el funcionamiento del BACKSPACE.
;Autor: Iv n No‚ Alvarado Le¢n.
;Fecha: 22/Feb/07.

.model small
.stack 100h
.data
    cadena db 5 dup(30h),'$'
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


    ;longitud menor a 30?
    ;despliega tecla
    ;mov ah,02h
    ;mov dl,al
    ;int 21h

    
    ;¨es enter?
    cmp al,13
    je salir
    ;¨es backspace?
    cmp al,8
    je backspace
    ;¨5 caracteres capturados?
    cmp di,5
    je captura

    ;es menor a cero?
    cmp al,30h
    jl captura
    ;es mayor a nueve?
    cmp al,39h
    jg captura
    
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
    ;cadena vacia?
    cmp di,0
    je salta_relleno
    ;se lleno la cadena?
    cmp di,5
    je salta_relleno
    mov bx,4

ciclo:
    ;Copiar lado izquierdo al lado derecho.
    dec di
    mov al,cadena[di]
    mov cadena[bx],al
    dec bx
    cmp di,0
    jg ciclo

    inc bx
ciclo2:
        
    ;rellenar con el car cter cero
    dec bx
    mov cadena[bx],30h    
    cmp bx,0    
    jg ciclo2    

salta_relleno:
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
