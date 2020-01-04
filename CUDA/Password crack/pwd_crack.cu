#include <stdio.h>
#include <cuda_runtime_api.h>
#include <time.h>
/****************************************************************************
  This program gives an example of a poor way to implement a password cracker
  in CUDA C. It is poor because it acheives this with just one thread, which
  is obviously not good given the scale of parallelism available to CUDA
  programs.
 
  The intentions of this program are:
    1) Demonstrate the use of __device__ and __global__ functions
    2) Enable a simulation of password cracking in the absence of library
       with equivalent functionality to libcrypt. The password to be found
       is hardcoded into a function called is_a_match.   

  Compile and run with:
  nvcc -o pwd_crack pwd_crack.cu


     To Run:
     ./pwd_crack > results.txt

  Dr Kevan Buckley, University of Wolverhampton, 2018
*****************************************************************************/

/****************************************************************************
  This function returns 1 if the attempt at cracking the password is
  identical to the plain text password string stored in the program.
  Otherwise,it returns 0.
*****************************************************************************/
__device__ int is_a_match(char *attempt) {
  char password1[] = "CV78";
  char password2[] = "ES81";
  char password3[] = "GT34";
  char password4[] = "RD48";

  char *a = attempt;
  char *b = attempt;
  char *c = attempt;
  char *d = attempt;
  char *pswd1 = password1;
  char *pswd2 = password2;
  char *pswd3 = password3;
  char *pswd4 = password4;

  while(*a == *pswd1) {
   if(*a== '\0')
    {
    printf("Found password: %s\n",password1);
      break;
    }

    a++;
    pswd1++;
  }
    
  while(*b == *pswd2) {
   if(*b == '\0')
    {
    printf("Found password: %s\n",password2);
      break;
}

    b++;
    pswd2++;
  }

  while(*c == *pswd3) {
   if(*c == '\0')
    {
    printf("Found password: %s\n",password3);
      break;
    }

    c++;
    pswd3++;
  }

  while(*d == *pswd4) {
   if(*d == '\0')
    {
    printf("Found password: %s\n",password4);
      return 1;
    }

    d++;
    pswd4++;
  }
  return 0;

}
/****************************************************************************
  The kernel function assume that there will be only one thread and uses
  nested loops to generate all possible passwords and test whether they match
  the hidden password.
*****************************************************************************/

__global__ void  kernel() {
char p,s;
 
  char password[5];
  password[4] = '\0';

int i = blockIdx.x+65;
int j = threadIdx.x+65;
char firstValue = i;
char secondValue = j;
    
password[0] = firstValue;
password[1] = secondValue;
    for(p='0'; p<='9'; p++){
      for(s='0'; s<='9'; s++){
            password[2] = p;
            password[3] = s;
          if(is_a_match(password)) {
        //printf("Success");
          }
             else {
         //printf("tried: %s\n", password);          
            }
          }
        } 
      
}
int time_difference(struct timespec *start,
                    struct timespec *finish,
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


int main() {

  struct  timespec start, finish;
  long long int time_elapsed;
  clock_gettime(CLOCK_MONOTONIC, &start);

kernel <<<26,26>>>();
  cudaThreadSynchronize();

  clock_gettime(CLOCK_MONOTONIC, &finish);
  time_difference(&start, &finish, &time_elapsed);
  printf("Time elapsed was %lldns or %0.9lfs\n", time_elapsed, (time_elapsed/1.0e9));
  return 0;
}




