.data
prompt: .asciiz "Digite um número inteiro n para calcular o termo F(n) da sequência de Fibonacci: "
newline: .asciiz "\n"

.text
.globl main

# Função para calcular o n-ésimo termo da sequência de Fibonacci (Fibonacci(n))
# Recebe o valor de n em $a0 e retorna o termo em $v0
fibonacci:
    # Procedimento para F(0) e F(1)
    li $t0, 0       # F(0)
    li $t1, 1       # F(1)
    beq $a0, $zero, fib_end   # Se n == 0, retorna F(0)
    beq $a0, 1, fib_end       # Se n == 1, retorna F(1)

    # Caso n >= 2, calcular Fibonacci iterativamente
    move $t2, $t0   # F(0)
    move $t3, $t1   # F(1)

    # Iteração para F(n)
    li $t4, 2       # Começa de F(2)
    loop_fib:
        add $t5, $t2, $t3   # F(n) = F(n-1) + F(n-2)
        bne $t4, $a0, next_fib   # Se ainda não chegou em n, continue
        move $v0, $t5       # Se chegou em n, armazena F(n) em $v0
        j fib_end
        next_fib:
        move $t2, $t3       # Prepara para o próximo ciclo
        move $t3, $t5
        addi $t4, $t4, 1    # Incrementa o contador
        j loop_fib
    
    fib_end:
        jr $ra      # Retorna ao endereço de retorno

# Função principal
main:
    # Calcular e armazenar o 30º termo da sequência de Fibonacci (F(30)) em $s1
    li $a0, 30
    jal fibonacci
    move $s1, $v0

    # Calcular e armazenar o 41º termo da sequência de Fibonacci (F(41)) em $s2
    li $a0, 41
    jal fibonacci
    move $s2, $v0

    # Calcular e armazenar o 40º termo da sequência de Fibonacci (F(40)) em $s3
    li $a0, 40
    jal fibonacci
    move $s3, $v0

    # Calcular a razão áurea ? usando F(41) e F(40)
    div $s2, $s3   # ? = F(41) / F(40)
    mtc1 $s2, $f0  # Coloca o resultado em $f0 (ponto flutuante)

    # Imprimir os resultados
    li $v0, 1       # System call para imprimir inteiro
    move $a0, $s1   # Argumento é F(30)
    syscall

    li $v0, 4       # System call para imprimir string
    la $a0, newline
    syscall

    li $v0, 1       # System call para imprimir inteiro
    move $a0, $s2   # Argumento é F(41)
    syscall

    li $v0, 4       # System call para imprimir string
    la $a0, newline
    syscall

    li $v0, 1       # System call para imprimir inteiro
    move $a0, $s3   # Argumento é F(40)
    syscall

    li $v0, 4       # System call para imprimir string
    la $a0, newline
    syscall

    li $v0, 2       # System call para imprimir float
    syscall

    # Finalizar programa
    li $v0, 10      # Exit
    syscall
