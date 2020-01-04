#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <crypt.h>
#include <time.h>
#include <cuda.h>
#include <cuda_runtime.h>
#include <cuda_runtime_api.h>


/******************************************************************************
  Demonstrates how to crack an encrypted password using a simple
  "brute force" algorithm. Works on passwords that consist only of 2 uppercase
  letters and a 2 digit integer. Your personalised data set is included in the
  code. 

  Compile with:
    nvcc -o cuda_password cuda_password.cu -lcrypt

  If you want to analyse the results then use the redirection operator to send
  output to a file that you can view using an editor or the less utility:

    ./CrackAZ99-With-Data > results.txt

  Dr Kevan Buckley, University of Wolverhampton, 2018
******************************************************************************/


__device__ int is_a_match(char *attempt){
	
char p_password1[] ="CV7812";
char p_password2[] ="ES8122";
char p_password3[] ="GT3433";
char p_password4[] ="RD4844";

	char *a = attempt;
	char *b = attempt;
	char *c = attempt;
	char *d = attempt;

	char *p1 = p_password1;
	char *p2 = p_password2;
	char *p3 = p_password3;
	char *p4 = p_password4;


while (*a == *p1){
	if(*a == '\0'){
		//printf("Password: %s\n", p_password1);
		break;
	}
	a++;
	p1++;
}

while (*b == *p2){
	if(*b == '\0'){
		//printf("Password: %s\n", p_password2);
		break;
	}
	b++;
	p2++;
}

while (*c == *p3){
	if(*c == '\0'){
		//printf("Password: %s\n", p_password3);
		break;
	}
	c++;
	p3++;
}

while (* d== *p4){
	if(*d == '\0'){
		printf("Password: %s\n", p_password4);
		break;
	}
	d++;
	p4++;
}
return 0;

}

__global__ void kernel(){
	char k1,k2,k3,k4;
	
	char password[7];
	password[6] = '\0';

	int i = blockIdx.x+65;
	int j = threadIdx.x+65;

	char matchone = i;
	char matchtwo = j;
	password[0] = matchone;
	password[1] = matchtwo;
	
	for(k1='0';k1<='9';k1++){
		for(k2='0';k2<='9';k2++){
			for(k3='0';k3<='9';k3++){
				for(k4='0';k4<='9';k4++){
					password[2] = k1;
					password[3] = k2;
					password[4] = k3;
					password[5] = k4;
					if(is_a_match(password)){
											
					}else{
						
					}
					
	}
	}
	}
	}

}



int time_difference(struct timespec *start, struct timespec *finish,
                    long long int *difference) {
  long long int ds =  finish->tv_sec - start->tv_sec; 
  long long int dn =  finish->tv_nsec - start->tv_nsec; 

  if(dn < 0 ) {
    ds--;
    dn += 1000000000; 
  } 
  *difference = ds * 1000000000 + dn;
  return !(*difference > 0);
}



int main(int argc, char *argv[]){
  struct timespec start, finish;   
  long long int time_elapsed;

  clock_gettime(CLOCK_MONOTONIC, &start);

 	kernel <<<26,26>>>();
	cudaThreadSynchronize();

  clock_gettime(CLOCK_MONOTONIC, &finish);
  time_difference(&start, &finish, &time_elapsed);
  printf("Time elapsed was %lldns or %0.9lfs\n", time_elapsed,
         (time_elapsed/1.0e9)); 

  return 0;
}
