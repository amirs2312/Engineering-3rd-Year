
#include "pico/stdlib.h"

///function to repeatedly cause the raspberry pi to blink
void repeat_blink(int sleep_delay, int pinnumber);

int main() {

/// Declare the Pin number and sleep delay
    const uint LED_PIN   =  25;
    const uint LED_DELAY = 500;


///Setup the LED pin as an output
    gpio_init(LED_PIN);
    gpio_set_dir(LED_PIN, GPIO_OUT);


/// Call the repeat blink function 
    repeat_blink(LED_DELAY,LED_PIN);

///return 0 when main is finished, if sucessful this point should never be reached.
    return 0;
}

void repeat_blink(int sleep_delay, int pinnumber){

       while (true) {
        gpio_put(pinnumber, 1);
        sleep_ms(sleep_delay);
    ///Toggle the LED on and then sleep for delay period
        
        gpio_put(pinnumber, 0);
        sleep_ms(sleep_delay);
    /// Toggle the LED off and then sleep for delay period
    }

}
