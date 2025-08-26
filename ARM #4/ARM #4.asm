
   .cdecls C, LIST, "Compiler.h"
;------------------------------------------------
;      .data
;------------------------------------------------
GPIO_BASE         .equ   0x40000000
NVIC_BASE         .equ   0xe0000000
RCGCGPIO          .equ   0x608
RCGC2             .equ   0x108
RCGCUART          .equ   0x618
GPIOHBCTL         .equ   0x06C
GPIODIR           .equ   0x400
GPIOAFSEL         .equ   0x420
GPIOPUR           .equ   0x510
GPIODEN           .equ   0x51C
GPIODR8R          .equ   0x508
GPIOAMSEL         .equ   0x528
GPIOPCTL          .equ   0x52C
GPIOLOCK          .equ   0x520
GPIOCR            .equ   0x524

GPIODATA          .equ   0x000
EN3               .equ   0x10C
GPIOIM            .equ   0x410
GPIOICR           .equ   0x41C

UARTFR            .equ   0x18
UARTDR            .equ   0x00
UART0BAS          .equ   0xc000
UARTCTL           .equ   0x030
UART0BASE         .equ   0xc000

UARTIBRD          .equ   0x024
UART0BASE         .equ   0xc000
UARTFBRD          .equ   0x028
UARTLCRH          .equ   0x02C
UARTCTL           .equ   0x030

SW_ON             .equ   0xE
SW_OFF            .equ   0xD
SW_BLINK_S        .equ   0xB
SW_BLINK_F        .equ   0x7
;--------------------------------------------------
             .text                           ; Program Start
             .global RESET                   ; Define entry point
             .align   4
          .sect ".text"

             .global Switch_Init
             .global Switch_Input

             .global LED_Init
             .global LED_On
             .global LED_Off
             .global Blink_slow
             .global Blink_fast

             .global UART_Init
             .global PRINT_UART

          .global num_1
          .global num_2
          .global num_3
          .global num_4

;------------------------------------------------
;         switch initialization
;------------------------------------------------

Switch_Init:
      mov r0, #GPIO_BASE   ;RCGC : General-Purpose Input/Output Run Mode Clock Gating Control
      mov r1, #0xFE000
      add r1, r1, r0
      mov r0, #RCGCGPIO
      add r1, r1, r0

      ldr r0, [r1]
      orr r0, r0, #0x800
      str r0, [r1]
      nop
      nop

      mov r0, #GPIO_BASE   ;HBCTL : High-Performance Bus Control
      mov r1, #0xFE000
      add r1, r1, r0
      mov r0, #GPIOHBCTL
      add r1, r1, r0

      mov r0, #0x800
      str r0, [r1]
      nop
      nop

      mov r0, #GPIO_BASE   ;DIR
      mov r1, #0x63000
      add r1, r1, r0
      mov r0, #GPIODIR
      add r1, r1, r0

      ldr r0, [r1]
      bic r0, r0, #0xf   ;make pin we are going to use 0(input)
      str r0, [r1]

      mov r0, #GPIO_BASE   ;AFSEL : Alternate Function Select
      mov r1, #0x63000
      add r1, r1, r0
      mov r0, #GPIOAFSEL
      add r1, r1, r0

      ldr r0, [r1]
      bic r0, r0, #0xf
      str r0, [r1]

      mov r0, #GPIO_BASE   ;PUR
      mov r1, #0x63000
      add r1, r1, r0
      mov r0, #GPIOPUR
      add r1, r1, r0

      ldr r0, [r1]
      orr r0, r0, #0xf
      str r0, [r1]

      mov r0, #GPIO_BASE   ;DEN
      mov r1, #0x63000
      add r1, r1, r0
      mov r0, #GPIODEN
      add r1, r1, r0

      ldr r0, [r1]
      orr r0, r0, #0xf
      str r0, [r1]

      mov r0, #GPIO_BASE   ;AMSEL : Analog Mode Select
      mov r1, #0x63000
      add r1, r1, r0
      mov r0, #GPIOAMSEL
      add r1, r1, r0

      mov r0, #0
      str r0, [r1]

      mov r0, #GPIO_BASE   ;PCTL : Port Control
      mov r1, #0x63000
      add r1, r1, r0
      mov r0, #GPIOPCTL
      add r1, r1, r0

      ldr r0, [r1]
      orr r0, r0, #0xf
      str r0, [r1]

      mov r0, #GPIO_BASE   ;LOCK
      mov r1, #0x63000
      add r1, r1, r0
      mov r0, #GPIOLOCK
      add r1, r1, r0

      mov r0, #GPIO_BASE
      mov r2, #0xc400000
      add r2, r2, r0
      mov r0, #0xf4000
      add r2, r2, r0
      mov r0, #0x34b
      add r2, r2, r0

      ldr r0, [r1]
      orr r0, r0, r2
      str r0, [r1]

      mov r0, #GPIO_BASE   ;CR
      mov r1, #0x63000
      add r1, r1, r0
      mov r0, #GPIOCR
      add r1, r1, r0

      ldr r0, [r1]
      mov r2, #0x00000000
      bic r0, r0, r2
      str r0, [r1]

      ;finish
      bx lr

LED_Init:   ;Advanced Peripheral Bus (APB) is clear in the state of reset of Port G. So we don't need to clear it.
      mov r0, #GPIO_BASE   ;RCGC2 :  Run Mode Clock Gating Control Register 2
      mov r1, #0xFE000
      add r1, r1, r0
      mov r0, #RCGC2
      add r1, r1, r0

      mov r0, #0x40
      str r0, [r1]
      nop
      nop

      mov r0, #GPIO_BASE   ;DIR
      mov r1, #0x26000
      add r1, r1, r0
      mov r0, #GPIODIR
      add r1, r1, r0

      ldr r0, [r1]
      orr r0, r0, #0x4   ;we use PG2(second pin of G port) as output
      str r0, [r1]

      mov r0, #GPIO_BASE   ;AFSEL : Alternate Function Select
      mov r1, #0x26000
      add r1, r1, r0
      mov r0, #GPIOAFSEL
      add r1, r1, r0

      ldr r0, [r1]
      bic r0, r0, #0x4   ;we use PG2(second pin of G port) // �����ϱ�
      str r0, [r1]

      mov r0, #GPIO_BASE   ;DEN
      mov r1, #0x26000
      add r1, r1, r0
      mov r0, #GPIODEN
      add r1, r1, r0

      mov r0, #0x4   ;we make digital functions for PG2(second pin of G port) enabled
      str r0, [r1]

      mov r0, #GPIO_BASE   ;DR8R
      mov r1, #0x26000
      add r1, r1, r0
      mov r0, #GPIODR8R
      add r1, r1, r0

      ldr r0, [r1]
      orr r0, r0, #0x4   ;PG2(second pin of G port) has 8-mA drive
      str r0, [r1]

      ;LED_Output_is_OFF_on_Initial_State
      mov r5, #GPIO_BASE
      mov r1, #0x26000
      add r1, r1, r5
      mov r5, #0x10
      add r1, r1, r5

      mov r0, #0x0
      str r0, [r1]

      ;finish
      bx lr

UART_Init:
		mov r0, #GPIO_BASE ;RCGCUART
		mov r1, #0xFE000
		add r1, r1, r0
		mov r0, #RCGCUART
		add r1, r1, r0

		ldr r0, [r1]
		orr r0, r0, #0x1
		str r0, [r1]
		nop
		nop

		mov r0, #GPIO_BASE ;RCGCGPIO
		mov r1, #0xFE000
		add r1, r1, r0
		mov r0, #RCGCGPIO
		add r1, r1, r0

		ldr r0, [r1]
		orr r0, r0, #0x1
		str r0, [r1]
		nop
		nop

		mov r0, #GPIO_BASE ;UARTCTL
		mov r1, #UART0BASE
		add r1, r1, r0
		mov r0, #UARTCTL
		add r1, r1, r0

		ldr r0, [r1]
		bic r0, r0, #0x1
		str r0, [r1]

		mov r0, #GPIO_BASE ;UARTIBRD
		mov r1, #UART0BASE
		add r1, r1, r0
		mov r0, #UARTIBRD
		add r1, r1, r0

		ldr r0, [r1]
		mov r2, #0xFFFF
		bic r0, r0, r2
		orr r0, r0, #0x08
		str r0, [r1]

		mov r0, #GPIO_BASE ;UARTFBRD
		mov r1, #UART0BASE
		add r1, r1, r0
		mov r0, #UARTFBRD
		add r1, r1, r0

		ldr r0, [r1]
		bic r0, r0, #0x3F
		orr r0, r0, #0x2C
		str r0, [r1]

		mov r0, #GPIO_BASE ;UARTLCRH
		mov r1, #UART0BASE
		add r1, r1, r0
		mov r0, #UARTLCRH;
		add r1, r1, r0

		mov r0, #0x60
		str r0, [r1]

		mov r0, #GPIO_BASE ;UARTCTL
		mov r1, #UART0BASE
		add r1, r1, r0
		mov r0, #UARTCTL
		add r1, r1, r0

		ldr r0, [r1]
		orr r0, r0, #0x1
		str r0, [r1]


		mov r0, #GPIO_BASE ;GPIOAFSEL
		mov r1, #0x4000
		add r1, r1, r0
		mov r0, #GPIOAFSEL
		add r1, r1, r0

		ldr r0, [r1]
		orr r0, r0, #0x03
		str r0, [r1]

		mov r0, #GPIO_BASE ;GPIOPCTL
		mov r1, #0x4000
		add r1, r1, r0
		mov r0, #GPIOPCTL
		add r1, r1, r0

		ldr r0, [r1]
		orr r0, r0, #0x11
		str r0, [r1]

		mov r0, #GPIO_BASE ;GPIODEN
		mov r1, #0x4000
		add r1, r1, r0
		mov r0, #GPIODEN
		add r1, r1, r0

		ldr r0, [r1]
		orr r0, r0, #0x3
		str r0, [r1]

		mov r0, #GPIO_BASE ;GPIOAMSEL
		mov r1, #0x4000
		add r1, r1, r0
		mov r0, #GPIOAMSEL
		add r1, r1, r0

		ldr r0, [r1]
		bic r0, r0, #0x3
		str r0, [r1]

		mov r1, #GPIO_BASE
		mov r2, #UART0BASE
		add r2, r2, r1
		mov r1, #UARTFR
		add r2, r1
PRINT_CHAR_loop1:
		ldr r1, [r2]
		and r1, r1, #0x20
		cmp r1, #0x20
		BEQ PRINT_CHAR_loop1

		mov r1, #GPIO_BASE
		mov r2, #UART0BASE
		add r2, r2, r1
		mov r1, #UARTDR
		add r2, r1

		mov r0, #'L'
		str r0, [r2]
		mov r0, #'E'
		str r0, [r2]
		mov r0, #'D'
		str r0, [r2]
		mov r0, #' '
		str r0, [r2]
		mov r0, #'M'
		str r0, [r2]
		mov r0, #'O'
		str r0, [r2]
		mov r0, #'D'
		str r0, [r2]
		mov r0, #'E'
		str r0, [r2]
		mov r0, #0x0D
		str r0, [r2]
		mov r0, #0x0A
		str r0, [r2]

      ;finish
      bx lr

Switch_Input:
      mov r5, #GPIO_BASE
      mov r1, #0x63000
      add r1, r1, r5
      mov r5, #0x3c
      add r1, r1, r5

      ldr r5, [r1]

DELAY:   MOVW r3,#0xffff

_DELAY_LOOP:
      CBZ r3,_DELAY_EXIT      ;Compare and Branch on Zero
      sub r3,r3,#1
      B _DELAY_LOOP
_DELAY_EXIT:

      cmp r5, #SW_ON
      BEQ _on

      cmp r5, #SW_OFF
      BEQ _off

      cmp r5, #SW_BLINK_S
      BEQ _BLINK_S

      cmp r5, #SW_BLINK_F
      BEQ _BLINK_F

      mov r1, #'A'
      b _EXIT

_on:
      mov r1, #'B'
      b _EXIT

_off:
      mov r1, #'C'
      b _EXIT

_BLINK_S:
      mov r1, #'D'
      b _EXIT

_BLINK_F:
      mov r1, #'E'
      b _EXIT

_EXIT:
      bx lr

num_1:
      mov r0, r1
      bx lr

num_3:
      mov r0, #'D'
      bx lr

LED_On:
      mov r0, #GPIO_BASE
      mov r1, #0x26000
      add r0, r0, r1
      mov r1, #0x10
      add r0, r0, r1

      mov r1, #0x4   ;when masking, it starts from third bit. However when modifying, we need to be careful about it starts from first bit.
      str r1, [r0]
      bx lr

LED_Off:
      mov r0, #GPIO_BASE
      mov r1, #0x26000
      add r0, r0, r1
      mov r1, #0x10
      add r0, r0, r1

      mov r1, #0x0   ;when masking, it starts from third bit. However when modifying, we need to be careful about it starts from first bit.
      str r1, [r0]
      bx lr

Blink_slow:

      mov r2, #0x4   ;5 times loop
_5t_slow_LOOP:

      mov r0, #GPIO_BASE   ;turn on
      mov r1, #0x26000
      add r0, r0, r1
      mov r1, #0x10
      add r0, r0, r1

      mov r1, #0x4
      str r1, [r0]

DELAY_slow_on:   MOVW r3,#0xffff   ;delay
      LSL r3, r3, #0x6

_DELAY_LOOP_slow_on:
      CBZ r3,_DELAY_EXIT_slow_on
      sub r3,r3,#1
      B _DELAY_LOOP_slow_on
_DELAY_EXIT_slow_on:

      mov r1, #0x0   ;turn off
      str r1, [r0]

DELAY_slow:   MOVW r3,#0xffff   ;delay
      LSL r3, r3, #0x6

_DELAY_LOOP_slow_off:
      CBZ r3,_DELAY_EXIT_slow_off
      sub r3,r3,#1
      B _DELAY_LOOP_slow_off
_DELAY_EXIT_slow_off:

      CBZ r2, _5t_slow_EXIT   ;5 times loop
      sub r2,r2,#1
      B _5t_slow_LOOP
_5t_slow_EXIT:
      bx lr

Blink_fast:

      mov r2, #0x4   ;5 times loop
_5t_fast_LOOP:

      mov r0, #GPIO_BASE   ;turn on
      mov r1, #0x26000
      add r0, r0, r1
      mov r1, #0x10
      add r0, r0, r1

      mov r1, #0x4
      str r1, [r0]

DELAY_fast_on:   MOVW r3,#0xffff   ;delay
      LSL r3, r3, #0x4

_DELAY_LOOP_fast_on:
      CBZ r3,_DELAY_EXIT_fast_on
      sub r3,r3,#1
      B _DELAY_LOOP_fast_on
_DELAY_EXIT_fast_on:

      mov r1, #0x0   ;turn off
      str r1, [r0]

DELAY_fast_off:   MOVW r3,#0xffff   ;delay
      LSL r3, r3, #0x4

_DELAY_LOOP_fast_off:
      CBZ r3,_DELAY_EXIT_fast_off
      sub r3,r3,#1
      B _DELAY_LOOP_fast_off
_DELAY_EXIT_fast_off:

      CBZ r2, _5t_fast_EXIT   ;5 times loop
      sub r2,r2,#1
      B _5t_fast_LOOP
_5t_fast_EXIT:
      bx lr

PRINT_UART:
		mov r3,lr ;spilling
		mov r4, #'-'
		bl PRINT_CHAR
		mov r4, #'S'
		bl PRINT_CHAR
		mov r4, #'W'
		bl PRINT_CHAR
		mov r4, #' '
		bl PRINT_CHAR
		mov r4, r0
		bl PRINT_CHAR

		mov r4, #0x0D
		bl PRINT_CHAR
		mov r4, #0x0A
		bl PRINT_CHAR
		mov lr, r3
		bx lr

PRINT_CHAR:
		mov r1, #GPIO_BASE
		mov r2, #UART0BASE
		add r2, r2, r1
		mov r1, #UARTFR
		add r2, r1
PRINT_CHAR_loop2:
		ldr r1, [r2]
		and r1, r1, #0x20
		cmp r1, #0x20
		BEQ PRINT_CHAR_loop2

		mov r1, #GPIO_BASE
		mov r2, #UART0BASE
		add r2, r2, r1
		mov r1, #UARTDR
		add r2, r1

		str r4, [r2]
		bx lr

         .retain
         .retainrefs
