#include "hardware/regs/addressmap.h"
#include "hardware/regs/m0plus.h"

.syntax unified                 @ Specify unified assembly syntax
.cpu    cortex-m0plus           @ Specify CPU type is Cortex M0+
.thumb                          @ Specify thumb assembly for RP2040
.global main_asm                @ Provide program starting address to the linker
.align 4                        @ Specify code alignment

.equ    SLEEP_TIME, 500         @ Specify the sleep time (in ms)
.equ    LED_GPIO_PIN, 25        @ Specify the pin that the LED is connected to
.equ    LED_GPIO_OUT, 1         @ Specify the direction of the GPIO pin
.equ    LED_VALUE_ON, 1         @ Specify the value that turns the LED "on"
.equ    LED_VALUE_OFF, 0        @ Specify the value that turns the LED "off"
.equ    SVC_ISR_OFFSET, 0x2C    @ The SVC is entry 11 in the vector table
.equ    SVC_MAX_INSTRS, 0x01    @ Maximum allowed SVC subroutines

@ Entry point to the ASM portion of the program
main_asm:
    bl      init_gpio_led       @ Initialise the GPIO LED pin
    bl      install_svc_isr     @ Install the SVC interrupt service routine
loop:
    svc     #0                  @ Call the SVC ISR with value 0 (turns on LED)
    nop                         @ Add a no-op instruction for alignment after SVC
    bl      do_sleep            @ Short pause before proceeding
    svc     #1                  @ Call the SVC ISR with value 1 (turns off LED)
    nop                         @ Add a no-op instruction for alignment after SVC
    bl      do_sleep            @ Add a short pause before proceeding
    b       loop                @ Always jump back to the start of the loop

@ Subroutine used to introduce a short delay in the application
do_sleep:
    push {lr}           @ Save the address for us to return to afterwards
    ldr r0,=SLEEP_TIME  @ Move the value of SLEEP_TIME into r0
    bl sleep_ms         @ Call the sleep_ms function to sleep for SLEEP_TIME
    pop {pc}            @ Return to the previously saved address

@ Subroutine used to initialise the PI Pico built-in LED
init_gpio_led:
    push {lr}                           @ Push link register onto stack 
    movs    r0, #LED_GPIO_PIN           @ This value is the GPIO LED pin on the PI PICO board
    bl      asm_gpio_init               @ Call the subroutine to initialise the GPIO pin specified by r0
    movs    r0, #LED_GPIO_PIN           @ This value is the GPIO LED pin on the PI PICO board
    movs    r1, #LED_GPIO_OUT           @ We want this GPIO pin to be setup as an output pin
    bl      asm_gpio_set_dir            @ Call the subroutine to set the GPIO pin specified by r0 to state specified by r1
    pop {pc}                            @ Pop the value in lr onto pc to return out of this subroutine

@ Subroutine used to install the SVC interrupt service handler
install_svc_isr:
    ldr     r2, =(PPB_BASE + M0PLUS_VTOR_OFFSET)    @ Load the address of the vector table base into r2
    ldr     r1, [r2]                                @ Load the value in the address of r2 (vector table base) into r1
    movs    r2, #SVC_ISR_OFFSET                     @ Move SVC_ISR_OFFSET (entry 11 in vector table) into r2
    add     r2, r1                                  @ Add r2 (the offset) to r1 (table base address) to get the handler address. Store this back in r2
    ldr     r0, =svc_isr                            @ Load address of svc_isr (Supervisor call interrupt service routine) into r0
    str     r0, [r2]                                @ Store the address of svc_isr at the address of the handler
    bx      lr                                      @ Return back from this subroutine

@ SVC interrupt service handler routine
.thumb_func                     @ Required for all interrupt service routines
svc_isr:
    push    {lr}                @ Push link register onto stack
    ldr     r0, [sp, #0x1C]     @ Load into r0 the value stored in the address 28 in front of the stack pointer
    subs    r0, #0x2            @ Subtract 2 from the value in r0 and store the result in r0. This is the address of the SVC instruction that caused interrupt.
    ldr     r0, [r0]            @ Load into r0 the value stored in the address at r0
    ldr     r1, =#0xFF          @ Load the value 255 into r1
    ands    r0, r1              @ Bitwise AND r0 and r1, updating flags and store the result in r0. Leaves only value of SVC number.
    cmp     r0, #SVC_MAX_INSTRS @ Compare this to the maximum value of SVC subroutines
    bgt     svc_done            @ Branch to svc_done if r0 > SVC_MAX_INSTRS
    adr     r1, svc_jmptbl      @ Load address of jump table into r1
    lsls    r0, #2              @ Logical Shift left by 2, ie multiply by 4. Every entry in the jump table is 4 bytes long.
    ldr     r1, [r1, r0]        @ Load the address of subroutine corresponding to the SVC number into r1
    mov     pc, r1              @ Move the address of the subroutine into pc, ie move to the subroutine.
svc_done:
    pop     {pc}                @ Pop the value in lr onto pc to return out of this subroutine

@ First function of SVC subroutine - turn on the LED
svc_num0:
    movs    r1, #LED_VALUE_ON
    movs    r0, #LED_GPIO_PIN           @ Set the LED GPIO pin number to r0 for use by asm_gpio_put
    bl      asm_gpio_put                @ Update the the value of the LED GPIO pin (based on value in r1)
    b       svc_done                    @ Branch back to the main ISR when done

@ Second function of SVC subroutine - turn off the LED
svc_num1:
    movs    r1, #LED_VALUE_OFF
    movs    r0, #LED_GPIO_PIN           @ Set the LED GPIO pin number to r0 for use by asm_gpio_put
    bl      asm_gpio_put                @ Update the the value of the LED GPIO pin (based on value in r1)
    b       svc_done                    @ Branch back to the main ISR when done

@ SVC function entry jump table.
.align 2
svc_jmptbl:
    .word svc_num0              @ Entry zero goes to SVC function #0.
    .word svc_num1              @ Entry one goes to SVC function #1.
    .word 0                     @ Null termination of the jump table.

@ Set data alignment
.data
    .align 4