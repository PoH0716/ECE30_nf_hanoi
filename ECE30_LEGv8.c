hanoi:
	STUR	 X29, [SP, -32]
	STUR	 X30, [SP, -40]
	// stp      X29, X30, [SP, -32]!
        ADD      X29, SP, XZR
        STUR     w0, [SP, #28]
        LDUR     w0, [SP, #28]
	SUBIS    XZR, w0, #1
        B.NE     L1
        ADDI     w0, XZR, #1
        B        L2
L1:
        LDUR     w0, [SP, #28]
        SUBI     w0, w0, #1
        BL       hanoi
	ADD      w1, w0, XZR
        ADD      w0, w1, XZR
        LSL      w0, w0, #1
        ADD      w0, w0, w1
        ADDI     w0, w0, #2
L2:
	LDUR	 X29, [SP], #32
	LDUR	 X30, [SP], #40
	// ldp      X29, X30, [SP], #32
	BL 	 LR


nf_hanoi:
        STUR	 X29, [SP, -48]
	STUR	 X30, [SP, -56]
	// stp      X29, X30, [SP, -48]!
        ADD      X29, SP, XZR
        STUR     w0, [SP, #44]
        STUR     X1, [SP, #32]
        STUR     X2, [SP, #24]
        STUR     X3, [SP, #16]
        LDUR     w0, [SP, #44]
	SUBIS    XZR, w0, #1
        B.NE     L3
        LDUR     X1, [SP, #24]
        LDUR     X0, [SP, #32]
        BL       move
        B        L4
L3:
        LDUR     w0, [SP, #44]
        SUBI     w0, w0, #1
        LDUR     X3, [SP, #16]
        LDUR     X2, [SP, #24]
        LDUR     X1, [SP, #32]
        BL       nf_hanoi
        LDUR     X1, [SP, #16]
        LDUR     X0, [SP, #32]
        BL       move
        LDUR     w0, [SP, #44]
        SUBI     w0, w0, #1
        LDUR     X3, [SP, #16]
        LDUR     X2, [SP, #32]
        LDUR     X1, [SP, #24]
        BL       nf_hanoi
        LDUR     X1, [SP, #24]
        LDUR     X0, [SP, #16]
        BL       move
        LDUR     w0, [SP, #44]
        SUBI     w0, w0, #1
        LDUR     X3, [SP, #16]
        LDUR     X2, [SP, #24]
        LDUR     X1, [SP, #32]
        BL       nf_hanoi
L4:
        LDUR	 X29, [SP], #48
	LDUR	 X30, [SP], #56
	BL 	 LR


move:
        SUBI     SP, SP, #32
        STUR     X0, [SP, #8]
        STUR     X1, [SP]
        STUR     XZR, [SP, #28]
L5:
        LDUR     w0, [SP, #28]
	SUBIS    XZR, w0, #127
        B.GT     L6
        LDUR     X0, [SP, #8]
        LDUR     w0, [X0]
	SUBIS    XZR, w0, #0
        B.NE     L6
        LDUR     X0, [SP, #8]
        ADD      X0, X0, #4
        STUR     X0, [SP, #8]
        LDUR     w0, [SP, #28]
        ADD      w0, w0, #1
        STUR     w0, [SP, #28]
        B        L5
L6:
        STUR     XZR, [SP, #24]
L7:
        LDUR     w0, [SP, #24]
	SUBIS    XZR, w0, #127
        B.GT     L8
        LDUR     X0, [SP]
        LDUR     w0, [X0]
	SUBIS    XZR, w0, #0
        B.NE     L8
        LDUR     X0, [SP]
        ADD      X0, X0, #4
        STUR     X0, [SP]
        LDUR     w0, [SP, #24]
        ADD      w0, w0, #1
        STUR     w0, [SP, #24]
        B        L7
L8:
        LDUR     X0, [SP]
        SUB      X0, X0, #4
        STUR     X0, [SP]
        LDUR     X0, [SP, #8]
        LDUR     w1, [X0]
        LDUR     X0, [SP]
        STUR     w1, [X0]
        LDUR     X0, [SP, #8]
        STUR     XZR, [X0]
        ADD      SP, SP, #32
        BL       LR
