.model small
.stack 100h
.data
    bytes db 65,66
    words dw 45h
.code
    mov ax, @data
    mov ds, ax

    mov bp, offset words
    mov ax, 82h
    mov si,0    

    sub word ptr [ds:bp],2
    mov ax, [ds:bp]

    
    
    ;despliega cx veces lo que esta contenido en AL
    mov AH,0ah
    xor bx,bx
    mov cx,1
    int 10h
fin:    
    mov ah,4ch
    int 21h
end
