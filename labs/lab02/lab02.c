#include <stdio.h>
#include <stdlib.h>
#include <math.h>
//#include "pico/stdlib.h"

/// Required for using single-precision variables.
/// Required for using double-precision variables.
#include "pico/float.h"    
#include "pico/double.h"   

/// Calculates the the value of the Wallis product.
/// The Wallis product is an infinte product approximation of pi/2.
/// This function approximates it using the double variable, continuing the product 'MAX_IT' times.
double Wallis(int MAX_IT);


/// Calculates the the value of the Wallis product.
/// The Wallis product is an infinte product approximation of pi/2.
/// This function approximates it using the float variable, continuing the product 'MAX_IT' times.
float Wallis_f(int MAX_IT);

int main(){
    
    /// The double approximatin for pi/2.
    double approximation_d;

    /// pi accurate to 11 decimal places 
    double REFERENCE_PI = 3.14159265359; 

    /// The float approximatin for pi/2.
    float approximation_f; 

    /// Calculate the value of the double approximation of pi/2 using 100000 iterations.
    approximation_d = Wallis(10000);

    /// Calculate the value of the float approximation of pi/2 using 100000 iterations.
    approximation_f = Wallis_f(10000);


    /// Calculate and assign the percentage error between the double approximation
    /// of pi and the reference value of pi.
    double error = 100*(2*approximation_d-REFERENCE_PI)/REFERENCE_PI;

    /// Calculate and assign the percentage error between the float approximation
    /// of pi and the reference value of pi.
    float errorf = 100*(2*approximation_f-REFERENCE_PI)/REFERENCE_PI;

    ///Print out the relevent metrics.
    printf("The double approximation of half of pi is equal to %lf\n",approximation_d);
    printf("Error of %lf percent\n\n",error);
    printf("The float approximation of half of pi is equal to %f\n",approximation_f);
    printf("Error of %f percent\n",errorf);

    /// Return 0 to indicate the program ran successfully.
    return 0;
}





double Wallis(int MAX_IT){

    /// The value of the infinte product as a double, initialised at 1.
    double half_calculated_pi = 1;
    
    /// Calculate the value of the infinte product.
    for(int i = 1;i<=MAX_IT;i++){
        half_calculated_pi = half_calculated_pi*(4*i*i)/((4*i*i)-1);
    }

    
    /// Return the value of the infinte product.
    return half_calculated_pi;
    
}

float Wallis_f(int MAX_IT){

    /// The value of the infinte product as a double, initialised at 1.
    float half_calculated_pi = 1;
    
    /// Calculate the value of the infinte product.
    for(int i = 1;i<=MAX_IT;i++){
        half_calculated_pi = half_calculated_pi*(4*i*i)/((4*i*i)-1);
    }

  
     /// Return the value of the infinte product.
    return half_calculated_pi;
    
}


