section .data
	
	; referente ao menu

	msgInicial db "Insira:", 0xA, "P para permutacao;", 0xA, "A para arranjo;", 0xA, "C para combinacao;", 0xA
	lenMsgInicial equ $ - msgInicial
	
	; referente a permutacao

	msgPermutacao db "Insira um valor (n) de, no maximo, 3 digitos:", 0xA
	lenMsgPermutacao equ $ - msgPermutacao	

	; referente ao arranjo

	msgArranjo1 db "Insira o numero de elementos (n) de, no maximo, 3 digitos:", 0xA
	lenMsgArranjo1 equ $ - msgArranjo1

	msgArranjo2 db "Insira o tamanho do grupo (k) de, no maximo, 3 digitos:", 0xA
	lenMsgArranjo2 equ $ - msgArranjo2		

	; referente a combinacao

	msgCombinacao1 db "Insira o numero de elementos (n) de, no maximo, 3 digitos:", 0xA
	lenMsgCombinacao1 equ $ - msgCombinacao1

	msgCombinacao2 db "Insira o tamanho do grupo (k) de, no maximo, 3 digitos:", 0xA
	lenMsgCombinacao2 equ $ - msgCombinacao2

	; outros

	msgErro db "Entrada(s) invalida(s)", 0xA
	lenMsgErro equ $ - msgErro

	saidaResult db "000000", 0xA ; 6 digitos. Tamanho 7 (caso resultado com valor pequeno) ou 6 (resultado gigante)

	; casos com resultados gigantes
	saidaResultBase db     " * 10^" ; tamanho 6
	saidaResultExpoente db "0000", 0xA ; 4 digitos. Tamanho 5  

section .bss
	opcao resb 2 ; referente as opcoes do menu. Opcao + '\n'
	
	; util para as labels permutacao, arranjo
	entradaNum1 resb 4 ; 3 digitos + '\n'
	entradaNum2 resb 4 ; 3 digitos + '\n'
	num1        resb 2 ; somente numero
	num2        resb 2 ; somente numero
	numResult   resb 4 ; somente numero

	; casos com resultados gigantes
	expoente1      resb 2 ; numero
	expoente2      resb 2 ; numero
	expoenteResult resb 2 ; numero	

section .text
	global _start

_start:
	; Mostro o menu
	mov rax, 1
	mov rdi, 1
	mov rsi, msgInicial
	mov rdx, lenMsgInicial
	syscall

	; Le a opcao escolhida
	mov rax, 0
	mov rdi, 0
	mov rsi, opcao
	mov rdx, 2
	syscall

	cmp byte [opcao], 'P'
	je permutacao

	cmp byte [opcao], 'A'
	je arranjo

	cmp byte [opcao], 'C'
	je combinacao

	cmp byte [opcao], 'p'
	je permutacao

	cmp byte [opcao], 'a'
	je arranjo

	cmp byte [opcao], 'c'
	je combinacao

	jmp erro

permutacao:
	; requisito o numero de entrada
	mov rax, 1
	mov rdi, 1
	mov rsi, msgPermutacao
	mov rdx, lenMsgPermutacao
	syscall

	; leio o valor de entrada
	mov rax, 0
	mov rdi, 0
	mov rsi, entradaNum1
	mov rdx, 4
	syscall

	; verifico a entrada
	lea rdi, [entradaNum1]
	mov rsi, 4
	call ehNumero

	cmp rax, 0
	je erro

	; converto de caracter para numero
	lea rdi, [entradaNum1]
	call caracterToNumber
	mov word [num1], ax

	; calculo a permutacao usando a formula: n!
	movzx rdi, word [num1]
	lea rsi, [expoente1]
	mov rdx, 1
	call fatorial

	mov dword [numResult], eax
	mov bx, word [expoente1]
	mov word [expoenteResult], bx

	jmp fim

arranjo:
	; requisito o numero de entrada n
	mov rax, 1
	mov rdi, 1
	mov rsi, msgArranjo1
	mov rdx, lenMsgArranjo1
	syscall

	; leio o valor de entrada n
	mov rax, 0
	mov rdi, 0
	mov rsi, entradaNum1
	mov rdx, 4
	syscall
	
	; verifico a entrada
	lea rdi, [entradaNum1]
	mov rsi, 4
	call ehNumero

	cmp rax, 0
	je erro

	; requisito o numero de entrada k
	mov rax, 1
	mov rdi, 1
	mov rsi, msgArranjo2
	mov rdx, lenMsgArranjo2
	syscall

	; leio o valor de entrada k
	mov rax, 0
	mov rdi, 0
	mov rsi, entradaNum2
	mov rdx, 4
	syscall

	; verifico a entrada
	lea rdi, [entradaNum2]
	mov rsi, 4
	call ehNumero

	cmp rax, 0
	je erro

	; converto de caracter para numero
	lea rdi, [entradaNum1]
	call caracterToNumber
	mov word [num1], ax

	; converto de caracter para numero
	lea rdi, [entradaNum2]
	call caracterToNumber
	mov word [num2], ax

	; verifico se num1 < num2
	mov ax, word [num1]
	cmp ax, word [num2]
	jl erro 

	; calculo o arranjo usando a seguinte formula: n! / (n - k)!
	
	; k = (n - k)
	mov ax, word [num1]
	sub ax, word [num2]
	mov word [num2], ax

	; n! / k! equivalente a n! / (n - k)!
	movzx rdi, word [num1]
	lea rsi, [expoente1]
	movzx rdx, word [num2]
	call fatorial

	mov dword [numResult], eax
	mov bx, word [expoente1]
	mov word [expoenteResult], bx

	jmp fim

combinacao:
	
	; requisito o numero de entrada n
	mov rax, 1
	mov rdi, 1
	mov rsi, msgArranjo1
	mov rdx, lenMsgArranjo1
	syscall

	; leio o valor de entrada n
	mov rax, 0
	mov rdi, 0
	mov rsi, entradaNum1
	mov rdx, 4
	syscall
	
	; verifico a entrada
	lea rdi, [entradaNum1]
	mov rsi, 4
	call ehNumero

	cmp rax, 0
	je erro

	; requisito o numero de entrada k
	mov rax, 1
	mov rdi, 1
	mov rsi, msgArranjo2
	mov rdx, lenMsgArranjo2
	syscall

	; leio o valor de entrada k
	mov rax, 0
	mov rdi, 0
	mov rsi, entradaNum2
	mov rdx, 4
	syscall

	; verifico a entrada
	lea rdi, [entradaNum2]
	mov rsi, 4
	call ehNumero

	cmp rax, 0
	je erro

	; converto de caracter para numero
	lea rdi, [entradaNum1]
	call caracterToNumber
	mov word [num1], ax

	; converto de caracter para numero
	lea rdi, [entradaNum2]
	call caracterToNumber
	mov word [num2], ax

	; verifico se num1 <= num2
	mov ax, word [num1]
	cmp ax, word [num2]
	jl erro

	; calculo a combinacao usando a seguinte formula: (n! / (n - k)!) / k!
	
	; bx = n - k
	mov bx, word [num1]
	sub bx, word [num2]

	; rbx (base) = n! / bx! equivalente a n! / (n - k)!
	movzx rdi, word [num1]
	lea rsi, [expoente1]
	mov rdx, rbx
	call fatorial
	mov rbx, rax

	; rcx (base) = k!
	movzx rdi, word [num2]
	lea rsi, [expoente2]
	mov rdx, 1
	call fatorial
	mov rcx, rax

	; (n! / (n - k)!) / k!

	cmp word [expoente1], 0
	je semVirgulaComb

	comVirgulaComb:

		; divido as bases (rax e rcx) e subtraio os expoentes
		; antes de dividir, multiplico o numerador pelo numero de casas decimais que mostro na tela ^ 10
		; a fim de "simular" uma divisao real.
		; se nao multiplicasse, o div iria calcular apenas o quociente da parte inteira (sem virgula) 
	
		; divido as bases
		mov rax, rbx
		imul rax, rax, 100000 ; sem risco de overflow
		xor rdx, rdx
		div rcx

		; subtraio os expoentes
		mov bx, word [expoente1]
		sub bx, word [expoente2]
	
		; finalizo a label
		mov dword [numResult], eax ; sem risco de overflow
		mov word [expoenteResult], bx
	
		jmp fim
	
	semVirgulaComb:
	
		; divido as bases
		mov rax, rbx
		xor rdx, rdx
		div rcx
		
		; finalizo a label

		mov dword [numResult], eax ; sem risco de overflow
		; como a saida do fatorial nao esta em notacao cientifica, o expoente deve ser 0
		mov word [expoenteResult], 0

		jmp fim		

erro:
	; informo para o usuario que a entrada foi invalida
	mov rax, 1
	mov rdi, 1
	mov rsi, msgErro
	mov rdx, lenMsgErro
	syscall

	; encerro o programa
	mov rax, 60
	xor rdi, rdi
	syscall

fim:
	; converto de numero para caracter
	mov r8, 0
	inicioLoop:
		
		cmp dword [numResult], 0
		je fimLoop
		
		mov eax, dword [numResult]
		xor edx, edx
		mov ecx, 10
		div ecx
		mov dword [numResult], eax

		add dl, '0'
		mov r9, 5
		sub r9, r8
		mov byte [saidaResult + r9], dl

		inc r8

		jmp inicioLoop

	fimLoop:

	; verifico se o resultado esta na notacao cientifica
	cmp word [expoenteResult], 0
	jg notaCient

	jmp naoCient

	notaCient:

		add word [expoenteResult], 5
		
		; converto o expoente de numero para caracter
		mov r8, 0
		inicioLoop2:
		
			cmp word [expoenteResult], 0
			je fimLoop2
		
			mov ax, word [expoenteResult]
			xor dx, dx
			mov cx, 10
			div cx
			mov word [expoenteResult], ax

			add dl, '0'
			mov r9, 3
			sub r9, r8
			mov byte [saidaResultExpoente + r9], dl

			inc r8

			jmp inicioLoop2

		fimLoop2:

		; reescrevo o saidaResult com o formato de virgula
		mov rdi, 5
		mov rsi, 4
		xor r8, r8 ; variavel de loop
		inicioVirgula:

			cmp r8, 4
			je fimVirgula

			; copio os valores da casa a esquerda
			mov al, byte [saidaResult + rsi]
			mov byte [saidaResult + rdi], al
			
			dec rsi
			dec rdi

			inc r8

			jmp inicioVirgula
			
		fimVirgula: 

		; insiro a virgula no saidaResult
		mov byte [saidaResult + 1], ','

		; mostro o resultado na tela
		mov rax, 1
		mov rdi, 1
		mov rsi, saidaResult
		mov rdx, 6
		syscall

		mov rax, 1
		mov rdi, 1
		mov rsi, saidaResultBase
		mov rdx, 6
		syscall

		mov rax, 1
		mov rdi, 1
		mov rsi, saidaResultExpoente
		mov rdx, 5
		syscall

		; encerro o programa
		mov rax, 60
		xor rdi, rdi
		syscall

	naoCient: 

	; mostro o resultado na tela
	mov rax, 1
	mov rdi, 1
	mov rsi, saidaResult
	mov rdx, 7
	syscall	

	; encerro o programa
	mov rax, 60
	xor rdi, rdi
	syscall

; calcula o fatorial de um numero n. Sem recursao
; rdi recebe o valor de entrada (copia)
; rsi recebe o expoente por referencia
; rdx recebe o caso base para parar (1 eh o caso base padrao)
; rax eh o valor de saida (base)
fatorial:
 
	mov word [rsi], 0
	mov rax, 1
	mov rcx, rdx
	comecoFatorial:
		cmp rdi, rcx
		jle saidaFatorial
		
		mul rdi
		dec rdi

		mov r10, 10 ; refente ao expoente
		cmp rax, 999999
		jg cientif

		jmp normal		
	
		cientif:
		
		; incremento o expoente enquanto a base for maior que 999999
			
		inc word [rsi]

		; altero a base
		xor rdx, rdx
		div r10

		cmp rax, 999999
		jg cientif

		normal:

		jmp comecoFatorial
	
	saidaFatorial:		

	ret


; Funcao que converte uma sequencia de caracter ASCII em numero
; rdi recebe o parametro de entrada por referencia
; rax sera o valor de saida, no caso, o numero convertido 
caracterToNumber:
	
	xor rax, rax
	xor rcx, rcx ; indice do loop

	.loop: 
	
		movzx rdx, byte [rdi + rcx] ; le o caracter atual
		
		cmp dl, '0'
		jl .done
		
		cmp dl, '9'
		jg .done
		
		imul rax, rax, 10 ; rax = rax * 10
		sub dl, '0'
		add rax, rdx

		inc rcx
		
		jmp .loop
		
	.done:	

	ret

; funcao que le um buffer e verifica se eh um numero
; percorre o buffer ate o tamanho maximo dele ou ate encontrar o '\n'
; rdi eh o buffer passado por referencia
; rsi eh o tamanho maximo do buffer
; rax eh o valor de retorno, sendo 1 para buffer valido e 0 para invalido
ehNumero:

	mov rax, 1
	mov r9, 1

	cmp byte [rdi], 0xA ; '\n'
	je naoEhNumero

	cmp byte [rdi], '0'
	jl naoEhNumero

	cmp byte [rdi], '9'
	jg naoEhNumero

	inicioLoopEhNumero:
	
		cmp r9, rsi
		jge fimLoopEhNumero

		cmp byte [rdi + r9], 0xA ; '\n'
		je fimLoopEhNumero

		cmp byte [rdi + r9], '0'
		jl naoEhNumero

		cmp byte [rdi + r9], '9'
		jg naoEhNumero

		inc r9
		jmp inicioLoopEhNumero

	fimLoopEhNumero:	
	ret

	naoEhNumero:
		xor rax, rax
		ret
