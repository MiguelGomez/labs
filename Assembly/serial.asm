;********************************************************************************
;*                                                                              *
;*                                      Miguel Angel Gomez Maquez                              *
;*                                                        02310258                                      *
;*                           Ingenieria en Sistemas Computacionales                      *
;*                                                                              *
;*********************************************************************************

include macros.mac
.model small
.stack 100h
.data  
         
                      
         F181 db '                               \     /                   ',10,'$'                                    
         F182 db '                                \ _/                      ',10,'$'                                    
         F183 db '                             ----/_\----                  ',10,'$'                                    
         F184 db '                 x--------------( . )--------------x      ',10,'$'                                    
         F185 db '                      x|x   | |_|\_/|_| |   x|x           ',10,'$'                                    
         F186 db '                       x    x           x    x            ',10,'$'                                                                               
         Demo1   db 'M  i  g  u  e  l    A  n  g  e  l    G  o  m  e  z  M  a  r  q  u  e  z$'
         Demo2   db '           M i g u e l  A n g e l  G o m e z  M a r q u e z$'
         Demo3   db '                     Miguel Angel Gomez Marquez$'
         Demo4   db 'Instituto Tecnologico de La Paz$'
         Demo5   db '                              $'
         Espacio  db 10,13,'$'
         Parrafo    db 10,10,10,10,10,10,10,10,13,'$'
         Escolar   db  '                     Miguel Angel Gomez Marquez ',10,'                              023120258      ',10,'$'
         
         Cad1 db  '                                     ',10,'$' 
	Cad2 db  '                                     ',10,'$'
	Cad3 db  '                                     ',10,'$'
	Cad4 db  '                                     ',10,'$'
	Cad5 db  '                                     ',10,'$'
         ;  ---------------------------------------------------------------------------------------------------------
         ;                                                     Variables numericas
         ;  ---------------------------------------------------------------------------------------------------------
	Var1 db 0
	Var2 db 0,'$'
	Var3 db 0
	Var4 db 0
         
         
.code
    call Presentacion
    call Numeral
    call Main
    call Salir

Numeral PROC
         Decimal
         Mov Var2,dl
         echoDecimal Var2
	Ret
Numeral EndP
Presentacion PROC
mov ax,@data
mov ds,ax
mov ah,09
fastecho Parrafo
fastecho F181
fastecho F182
fastecho F183
fastecho F184
fastecho F185
fastecho F186
fastecho Espacio
fastecho Espacio
fastecho Escolar
fastecho Parrafo
getch
	Ret
Presentacion EndP
Salir PROC
mov ah,4Ch
int 21h
	Ret
Salir EndP
Main PROC
         echo Demo4
         strcp Demo4,Demo5,31,15,20
         echo Espacio
         echo Demo5
         strcp Demo4,Demo5,31,3,24
         echo Espacio
         echo Demo5
         strcp Demo4,Demo5,31,4,7
         echo Espacio
         echo Demo5
         clean Demo5,30
         echo Demo5
         getch
	Ret
Main EndP

END
