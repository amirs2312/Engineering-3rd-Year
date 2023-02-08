#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "pico/stdlib.h"
#include "pico/float.h"     // Required for using single-precision variables.
#include "pico/double.h"    // Required for using double-precision variables.


double Wallis(int MAX_IT);
float Wallis_f(int MAX_IT);

int main(){
    double approximation;
    double REFERENCE_PI = 3.14159265359;
    float approximation_f;

    approximation = Wallis(10000);
    approximation_f = Wallis_f(10000);

    double error = 100*(2*approximation-REFERENCE_PI)/REFERENCE_PI;
    float errorf = 100*(2*approximation_f-REFERENCE_PI)/REFERENCE_PI;

    printf("Half of pi is equal to %lf\n",approximation);
    printf("Error of %lf percent\n\n",error);
    printf("The float approximation of half of pi is equal to %f\n",approximation_f);
     printf("Error of %f percent\n",errorf);


    return 0;
}





double Wallis(int MAX_IT){
    double half_calculated_pi = 1;
    

    for(int i = 1;i<=MAX_IT;i++){
        half_calculated_pi = half_calculated_pi*(4*i*i)/((4*i*i)-1);
    }

    

    return half_calculated_pi;
    
}

float Wallis_f(int MAX_IT){
    float half_calculated_pi = 1;
    

    for(int i = 1;i<=MAX_IT;i++){
        half_calculated_pi = half_calculated_pi*(4*i*i)/((4*i*i)-1);
    }

  

    return half_calculated_pi;
    
}
