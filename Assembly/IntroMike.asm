cout  macro string
          lea dx,string
          int 21h
endm
getch macro
    mov ah,10h
    int 16h
endm
.model small
.stack 100h
.data                       
         F181 db '                               \     /                   ',10,'$'                                    
         F182 db '                                \ _/                      ',10,'$'                                    
         F183 db '                             ----/_\----                  ',10,'$'                                    
         F184 db '                 x--------------( . )--------------x      ',10,'$'                                    
         F185 db '                      x|x   | |_|\_/|_| |   x|x           ',10,'$'                                    
         F186 db '                       x    x           x    x            ',10,'$'                                                                               
         Nombre   db '           M i g u e l  A n g e l  G o m e z  M a r q u e z$'
         Espacio  db 10,13,'$'
         Parrafo    db 10,10,10,10,10,10,10,10,13,'$'
.code
    call Presentacion
    call Salir
Presentacion PROC
	mov ax,@data
	mov ds,ax
	mov ah,09
	cout  Parrafo
	cout  F181
	cout  F182
	cout  F183
	cout  F184
	cout  F185
	cout  F186
	cout  Espacio
	cout  Espacio
	cout  Nombre
	cout  Parrafo
	getch
	Ret
Presentacion EndP
Salir PROC
	mov ah,4Ch
	int 21h
	ret
Salir EndP
End