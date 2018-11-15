;COM3F8.ASM
Include Pantalla.mac
Include Captura.mac
.model small
.stack 100h
.data
	x db 0
	x2 db 0
	y db 1
	y2 db 20
	cadena db 30 dup(0),36
	menu db '1: Chat',10,13,'2: Enviar archivo',10,13,'3: Recibir archivo',10,13,'4:Salir',10,10,13,'	Elija una opcion... $'
	NomArchivo db 257 dup(0)	;No lleva "$" porque asi debe ser el formato de la variable que contiene el nombre del archivo (ASCIIZ)
	NomArchivo2 db 257 dup(0)
	Manipulador dw 0
	Manipulador2 dw 0
	caracter db 0
	MsgErrorApertura db 1000 dup(0),'$'
	Texto db 1000 dup(0),'$'
	Mens db 'El Archivo Se Guardara En: $'
	Mens2 db 'Listo para recibir...$'
	Mens3 db '    Archivo recibido Exitosamente!$'
	Mens4 db 'Archivo a enviar: $'
	Contador1 dw 0
	Contador2 dw 0
	mensajeE db 'Enviando: $'
	mensajeR db 'Recibiendo: $'
	mensajeEsp db 'Esperando Una Respuesta Para Continuar....: $'
.code
	mov ax,@data
	mov ds,ax
	xor di,di
	xor cx,cx
	
	;Primera parte: Inicializar el puerto com1 para comunicaci¢n
	;con 2400 baudios, paridad impar, 8 bits de datos, 1 bit de parada
	;y habilitacion de señales de control
	;Velocidad 2400 baudios
	mov  dx,03fbh      ;Line Control Register
	mov  al,80h
	out  dx,al         ;Poner a 1 bit 7 para accesar registros Baud Rate
	mov  dx,03f8h      ;Baud Rate Register (LSB)
	mov  al,30h        ;LSB para 2400 baudios
	out  dx,al
	mov  dx,3f9h       ;Baud Rate Register (MSB)
	mov  al,0h         ;MSB para 2400 baudios
	out  dx,al

	;Paridad, bits de datos, bit de parada
	mov  dx,3fbh       ;Line Control Register
	mov  al,0bh        ;0bh = Paridad impar, 8 bits de datos, 1 bit de parada
	out  dx,al

	;Habilitacion de señales de control
	mov  dx,03fch      ;Modem Control Register
	mov  al,03h       ;Habilita señales RTS y DTR. Pone opcion "Loopback"
	out  dx,al

	;Deshabilitar las cuatro clases de interrupciones
	mov  dx,03f9h      ;Interrupt Enable Register
	mov  al,0h
	out  dx,al	
Men:
	Clear
	xor dh,dh
	xor dl,dl
	mov ah,2
	xor bh,bh
	int 10h
	mov ah,9
	mov dx,offset menu
	int 21h
	mov ah,10h
	int 16h
	mov ah,2
	mov dl,al
	int 21h
	cmp al,31h
	je Chat
	cmp al,32h
	je Enviar
	cmp al,33h
	je Recibo
	cmp al,34h
	jne Men
	Clear
	xor dh,dh
	xor dl,dl
	mov ah,2
	xor bh,bh
	int 10h
	mov  ah,04ch
	int  21h
Enviar:
	call Envia
	mov ah,10h
	int 16h
	jmp Men
Recibo:
	call Recibe
	mov ah,10h
	int 16h
	jmp Men
Chat:
	Clear
	xor dh,dh
	xor dl,dl
	mov ah,2
	xor bh,bh
	int 10h
	Escribe mensajeE
	mov dh,19
	mov dl,0
	int 10h
    Escribe mensajeR
    mov dh,1
	mov dl,0
	int 10h
	;Inicializacion completa
	;Segunda parte: Desplegar en la pantalla lo que se reciba y transmitir
	;lo que se introduzca por el teclado
	xor di,di
	
Ciclo:
	mov  dx,3fdh       ;Line Status Register
	in   al,dx         ;Leer el byte de estado de la linea
	push ax
	and  al,01eh       ;Revisa si hay error en la recepcion
	cmp  al,0 
	jne  Error         ;Hubo error, hay que atenderlo
	pop  ax
	push ax
	and  al,01h        ;Revisa si se recibio algun byte
	cmp  al,01h
	je   recibir       ;Se recibio, hay que tomarlo del puerto
	pop  ax
	and  al,020h       ;Revisa si esta vacio el registro de transmision
	cmp  al,020h
	jne   Ciclo         ;No esta vacio, volver al ciclo
	;El registro de transmision esta vacio. Se puede transmitir un byte.

	;Hay que revisar si hay un caracter en el buffer del teclado
	mov  ah,01h        ;Funcion para verificar buffer del teclado
	int  16h           ;ZF = 1 si no hay caracter
	jz   Ciclo

	;Hay un caracter en el buffer del teclado, hay que tomarlo.
	mov  ah,00h        ;Funcion para leer caracter del buffer del teclado
	int  16h           ;En AL queda el caracter leido.

	cmp al,8
	je bks
	;Verificar si se pulso ESC
	cmp al,27
	je  Salir

	;No fue Esc, transmitir el caracter
	mov dh,y
	mov dl,x
	mov ah,2
	xor bh,bh
	int 10h
	mov ah,2
	mov dl,al
	int 21h
	inc x
	cmp al,0dh
	je trans
	cmp di,50
	je trans
	mov cadena[di],al
	inc di
	jmp Ciclo

	trans:
	mov cx,di
	xor di,di

bucle:

	mov  dx,3f8h       ;Transmitter Holding Register
	mov al,cadena[di]
	out  dx,al         ;Transmite el caracter por el puerto
	inc di
	loop bucle
	mov dx,3f8h
	mov al,13
	out dx,al
	mov  x,0
	inc  y
	xor di,di	;Si fue enter, desplegar caracter de avance de linea.
	jmp  Ciclo

Ciclo1:
	jmp Ciclo
bks:
	jmp bks1
Salir:
	jmp Salir1
	;El programa brinca a este punto se se ha recibido un byte por el pueto
Error:
	jmp Error1
Recibir:
	mov  dx,03f8h      ;Receiver Data Register
	in   al,dx         ;Toma el byte recibido

	push ax
	push dx
	cmp al,8  ;Desplegar el caracter
	je bks
    ;Funcion para desplegar caracter
    ;Posicionar el cursor
	mov dh,y2	;dh=columna
	mov dl,x2	;dl=linea
	mov ah,2	
	xor bh,bh	;Num de pagina
	int 10h

	mov ah,2
	mov dl,al
	int 21h
	inc x2
	
	pop dx
	pop  ax

	cmp  al,0dh        ;Verificar si es enter
	jne  Ciclo1
	mov  dh,y2
	mov  dl,x2
	mov  ah,2
	xor  bh,bh
	int  10h
	mov  x2,0
	inc  y2		;Si fue enter, desplegar caracter de avance de linea.
	jmp  Ciclo

	;El programa brinca a este punto si se ha detectado un error en
	;la recepcion. En tal caso despliega el caracter '?'
Error1:
	mov  dx,3f8h       ;Receiver Data Register
	in   al,dx         ;Leer el byte erroneo
	mov  ah,9h
	mov  al,'?'
	mov  bx,07h
	int  10h
	jmp  Ciclo
Salir1:
	jmp salir2
bks1:
	push dx
	push ax		
	
	mov dh,y
	mov dl,x
	mov ah,2
	xor bh,bh
	int 10h
	mov ah,02
	mov dl,8
	int 21h
	mov dl,' '
	int 21h
	mov dl,8
	int 21h
	dec x
        dec di
	pop ax
	pop dx
	jmp ciclo

Salir2:
	jmp Men
Envia PROC	
	;Borra pantalla y pone el cursor en la primera linea
	Clear
	mov dh,0
	mov dl,0
	mov ah,2
	xor bh,bh
	int 10h
	Escribe mensajeEsp	
	mov dh,1
	mov dl,0
	mov ah,2
	xor bh,bh
	int 10h

	;Espera a recibir el mensaje "Listo para recibir"
	
Ciclo11:
	mov dx,3fdh	;Line Status Register
	in al,dx	;Leer el byte de estado de la linea
	and al,1
	cmp al,1	;Revisa si se recibio algun byte
	jne Ciclo11	;Si no recibe regrsa al ciclo

	;Si recibe toma el byte del puerto

	mov dx,3f8h
	in al,dx

	;Revisa si recibio ENTER	
	cmp al,13
	je enterE
	mov ah,2
	mov dl,al
	int 21h
	jmp Ciclo11

	;Enviar archivo
	
enterE:

	;Despliega mensaje "Enviar archivo:"
	mov ah,9
	mov dx,offset Mens4	
	int 21h
	;Captura nombre del archivo a enviar
	CapCad NomArchivo,256
	;Abrir archivo
	mov ah,03Dh
	mov dx,offset NomArchivo
	mov al,0 ; Modo apertura: 0=lectura
	int 21h	; devuelve ax=Manipulador, cf=0 no errores ;cf 1 hubo error
	; ah=codigo del error
	jc ErrorApertura
	mov Manipulador,ax
	;leer el archivo y lo almacena en la variable Texto
	xor di,di
	
leercaracter:
	mov ah,03Fh
	mov bx,Manipulador
	mov cx,1 		; cuantos bytes se desea leer
	mov dx,offset Caracter
	int 21h
	jc ErrorLectura
	cmp ax,0		;Si llega al fin del archivo  "je Desplegar" te manda a enviar la variable
	je Desplegar
	;Mete el caracter leido a la variable
	mov al,Caracter
	mov Texto[di],al
	inc di
	jmp leercaracter

ErrorLectura:
	;Despliega el codigo o num del error
	mov ah,2
	mov dl,ah
	int 21h
	jmp final

ErrorApertura:

	;Despliega el codigo o num del error
	mov ah,2
	mov dl,ah
	int 21h
	jmp final

Desplegar:
	mov cx,di
	xor di,di

etiqueta:
  	Ciclo5:
  		mov  dx,3fdh       ;Line Status Register
  		in   al,dx         ;Leer el byte de estado de la linea
		and  al,020h       ;Revisa si esta vacio el registro de transmision
		cmp  al,020h
		jne   Ciclo5       ;No esta vacio, volver al ciclo

	mov  dx,3f8h       ;Transmitter Holding Register
	mov al,Texto[di]
	out  dx,al         ;Transmite el caracter por el puerto
	inc di
	loop etiqueta
	Ciclo7:
		mov  dx,3fdh       ;Line Status Register
		in   al,dx         ;Leer el byte de estado de la linea
		and  al,020h
		cmp  al,020h		;Revisa si esta vacio el registro de transmision
		jne   Ciclo7         ;No esta vacio, volver al ciclo
	;Envia ESC para indicar fin de transmision
	mov dx,3f8h
	mov ax,di
	out dx,al
	;Cerrar el archivo
	mov ah,03Eh
	mov bx,Manipulador
	int 21h
final:
	ret
Envia ENDP

Recibe PROC
	Clear
	;Pone el cursor en la primera linea
	xor dh,dh
	xor dl,dl
	mov ah,2
	xor bh,bh
	int 10h
	;Mandar mensaje para guardar
        mov ah,9
        mov dx,offset Mens
        int 21h
        ;mov ah,9
        ;mov dx,offset NomArchivo2
        ;int 21h
    mov dh,0
	mov dl,29
	mov ah,2
	xor bh,bh
	int 10h
	;Captura el nombre del archivo
        CapCad NomArchivo2,256
	xor di,di
	;Enviar mensaje para recibir
Ciclo10:
	mov dx,03fdh		;Line Status Register
	in al,dx		;Leer el byte de estado de la linea
	and al,20h		;Revisa si esta vacio el registro de transmision
	cmp al,20h
	jne Ciclo10		;No esta vacio, regresa al ciclo
				;Esta vacio, envia
	mov dx,3f8h		;Transmitter Holding Register
	mov al,Mens2[di]
	out dx,al		;Transmite el caracter por el puerto
	inc di
	cmp Mens2[di],36		;Revisa si llego al final de cadena
	jne Ciclo10
Cicl:
    
	mov dx,03fdh
	in al,dx
	and al,20h
	cmp al,20h
	jne Cicl
	;Envia ENTER para indicar fin de transmision
	mov dx,3f8h
	mov al,13
	out dx,al
	;Crear el archivo
	mov ah,3CH
	xor ch,ch
	mov dx,offset NomArchivo2
	int 21h
	;Abrir el archivo
	mov ah,03Dh
	mov dx,offset NomArchivo2
	mov al,1 ; Modo apertura: 1=Escritura
	int 21h
	mov Manipulador2,ax	
	
lee:    
	Ciclo6:
	mov  dx,3fdh       	;Line Status Register
	in   al,dx         	;Leer el byte de estado de la linea
	and  al,1   		;Revisa si se recibio algun byte
	cmp  al,1
	jne   Ciclo6       	;Se recibio, hay que tomarlo del puerto
	mov  dx,3f8h  		;Receiver Data Register
	in   al,dx          ;Toma el byte recibido
	mov bx,di
	cmp al,bl		     ;Si recibe ESC termina de recibir		
	je fin	
	mov ah,40h		;Funcion para escribir en archivo
	mov bx,Manipulador2	;Manipulador del archivo
	mov cx,1		;Numero de caracteres a escribir
	mov Caracter,al		;Se manda a la variable caracter el byte recibido
	mov dx,offset Caracter	;Le dice a la funcion lo que va a escribir
	int 21h			;escribe
	jmp lee
fin:
	;Manda a pantalla en mensaje "Archivo recibido"
	mov ah,9
	mov dx, offset Mens3
	int 21h
	;Cierra archivo
	mov ah,03Eh
	mov bx,Manipulador2
	int 21h
	ret
Recibe ENDP
end
;Fin de COM3F8.ASM