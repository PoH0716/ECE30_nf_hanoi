// ECE30 No Flyover Tower of Hanoi Final Project
// Created by Bassel Hatoum and Po Hsiang Huang on 3/15/19

        EOR     X1, X1, X1          // initialize the number of moves to 0

// stack pointers for stacks A, B, and C are X5, X6, and X7
// stacks A, B, and C groX upXard

        ADDI    X5, XZR, #0         // X5 = 0X0000
        ADDI    X6, XZR, #128       // X6 = 0X0080
        ADDI    X7, XZR, #256       // X7 = 0X0100

// place a super large disk (of size 255) at the bottom of each pile

        ADDI    X9, XZR, #0X00ff
        STUR    X9, [X5, #0]
        STUR    X9, [X6, #0]
        STUR    X9, [X7, #0]

// store n disks on src pile in the decreasing size order

        ADDI    X0, XZR, #7         // n = 7
        ADD     X10, XZR, X0
loop:   ADDI    X5, X5, #8
        STUR    X10, [X5, #0]
        SUBI    X10, X10, #1
        CBNZ    X10, loop

// pile A = 0
// pile B = 1
// pile C = 2

        ADDI    X2, XZR, #0         // src = A
        ADDI    X3, XZR, #2         // dst = C
        ADDI    X4, XZR, #1         // tmp = B
        BL      nfhanoi
        STOP

// nfhanoi(n, src, dst, tmp)
//      simulate no flyover toXer of hanoi game
//
// assume that input n is in X0, src/dst/tmp in X2/X3/X4
// return number of moves in X1

nfhanoi:

        BR      LR


// move(src, dst)
//      move a disk from src pile to dst pile
//
// src/dst in X2/X3
//      pile A = 0
//      pile B = 1
//      pile C = 2
// return running count of moves in X1

move:

        BR      LR

// move errors
//
// use these for debugging
// -1 is returned in case of size error
// -2 is returned in case of flyover error

errorS: SUBI    X1, XZR, #1         // size error
        STOP

errorF: SUBI    X1, XZR, #2         // fly-over error
        STOP

// count moves
//
// calculate how many moves are required to solve the problem for n disks
hanoi:
	STUR	 X29, [SP, -32]
	STUR	 X30, [SP, -40]
        ADD      X29, SP, XZR
        STUR     w0, [SP, #28]
        
        // when n = 1, return 1
        LDUR     X0, [SP, #28]
	SUBIS    XZR, X0, #1		// 100%
        B.NE     L1			// 100%
        ADDI     X1, X1, #1		// 100%
        B        L2			// 100%
        
        // when n != 1, return 3*hanoi(n-1)+2
L1:
        LDUR     X0, [SP, #28]
        SUBI     X0, X0, #1
        BL       hanoi
	ADD      w1, w0, XZR
        ADD      w0, w1, XZR
        LSL      w0, w0, #1
        ADD      w0, w0, w1
        ADDI     w0, w0, #2
L2:
	LDUR	 X29, [SP], #32
	LDUR	 X30, [SP], #40
	BL 	 LR			// 100%
