// ECE30 No Flyover Tower of Hanoi Final Project
// Created by Bassel Hatoum and Po Hsiang Huang on 3/15/19

        EOR     X1, X1, X1          // initialize the number of moves to 0

// stack pointers for stacks A, B, and C are X5, X6, and X7
// stacks A, B, and C grow upward

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
//      simulate no flyover tower of hanoi game
//
// assume that input n is in X0, src/dst/tmp in X2/X3/X4
// return number of moves in X1

nfhanoi:
        SUBI    SP, SP, #48     // allocate stack frame
        STUR    FP, [SP, #0]    // save old frame pointer
        ADDI    FP, SP, #40     // set new frame pointer
        STUR    LR, [FP, #0]    // save the return address
        STUR    X0, [FP, #-8]   // save the argument n
        STUR    X2, [FP, #-16]  // save the src pile
        STUR    X3, [FP, #-24]  // save the dst pile
        STUR    X4, [FP, #-32]  // save the tmp pile

N1:     SUBIS   XZR, X0, #1     // test for n = 1
        B.NE    ACB             // if n != 1, call ACB

M23:    ADDI    X20, XZR, #0    // if n = 1, call move(src, dst)
        ADDI    X30, XZR, #2
        B       move

ACB:    SUBI    X0, X0, #1      // set n = n - 1
        BL      nfhanoi         // call nfhanoi(n - 1)
        ADDI    X20, XZR, #0
        ADDI    X30, XZR, #1
        BL      move            // call move(src, tmp)

CAB:    ADDI    X2, XZR, #2
        ADDI    X3, XZR, #0
        BL      nfhanoi
        ADDI    X20, XZR, #1
        ADDI    X30, XZR, #2
        BL      move            // call move(tmp, dst)

ACB2:   ADDI    X2, XZR, #0
        ADDI    X3, XZR, #2
        BL      nfhanoi         // call nfhanoi(n - 1)

done:   LDUR    LR, [FP, #-24]
        LDUR    FP, [FP, #-32]
        ADDI    SP, SP, #40

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
        B       hanoi
con:
        SUBIS   XZR, X20, #0    // determine source pile and destination pile
        B.EQ    S2
        SUBIS   XZR, X20, #1
        B.EQ    S4

S3:     SUBIS    XZR, X30, #0
        B.EQ    S3D2

S3D4:                           // source is stack C and destination is stack B
        ADDI    X6, X6, #8      // set new stack B sp
        STUR    X6, [X7, #0]    // store memory of stack C sp in stack B sp
        STUR    X7, [XZR, #0]   // clear old stack C sp
        SUBI    X7, X7, #8      // set new stack C sp
        BR      LR

S3D2:                           // source is stack C and destination is stack A
        ADDI    X5, X5, #8
        STUR    X5, [X7, #0]
        STUR    X7, [XZR, #0]
        SUBI    X7, X7, #8
        BR LR

S2:     SUBIS    XZR, X30, #1
        B.EQ    S2D4

S2D3:                           // source is stack A and destination is stack C
        ADDI    X7, X7, #8
        STUR    X7, [X5, #0]
        STUR    X5, [XZR, #0]
        SUBI    X5, X5, #8
        BR      LR

S2D4:                           // source is stack A and destination is stack B
        ADDI    X6, X6, #8
        STUR    X6, [X5, #0]
        STUR    X5, [XZR, #0]
        SUBI    X5, X5, #8
        BR      LR

S4:     SUBIS    XZR, X30, #0
        B.EQ    S4D2

S4D3:                           // source is stack B and destination is stack C
        ADDI    X7, X7, #8
        STUR    X7, [X6, #0]
        STUR    X6, [XZR, #0]
        SUBI    X6, X6, #8
        BR      LR

S4D2:                           // source is stack B and destination is stack A
        ADDI    X5, X5, #8
        STUR    X5, [X6, #0]
        STUR    X6, [XZR, #0]
        SUBI    X6, X6, #8
        BR      LR

// move errors
//
// use these for debugging
// -1 is returned in case of size error
// -2 is returned in case of flyover error

//errorS: SUBI    X1, XZR, #1         // size error
//        STOP

//errorF: SUBI    X1, XZR, #2         // fly-over error
//        STOP

//count moves
//
//calculate how many moves required to take for n number of disks

hanoi:  ADDI    X1, X1, #1
        B       con


//SUBI    SP, SP, #32     // allocate stack frame
//        STUR    FP, [SP, #0]    // save old frame pointer
//        ADDI    FP, SP, #24     // set new frame pointer
//        STUR    LR, [FP, #-16]  // save the return address
//        STUR    X0, [FP, #0]    // save the argument n
//
//        SUBIS   XZR, X0, #1     // test for n = 1
//        B.EQ    R1              // if n = 1, go to L1
//        SUBI    X0, X0, #1      // if n > 1, call hanoi
//        BL      hanoi

//        LDUR    X0, [FP, #0]    // return from BL: restore argument n
//        ADDI    X8, XZR, #3     // return 3 * hanoi(n - 1) + 2
//        MUL     X1, X0, X8
//        ADDI    X1, X1, #2
//        B       count

//R1:     ADDI    X1, XZR, #1     // return 1

//count:  LDUR    LR, [FP, #-16]  // restore the return address
//        LDUR    FP, [FP, #-24]  // restore old frame pointer
//        ADDI    SP, SP, #32     // deallocate stack frame

//        BR      LR              // return to the caller
