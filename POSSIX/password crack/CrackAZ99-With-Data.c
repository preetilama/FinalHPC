#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <crypt.h>
#include <time.h>
#include <pthread.h>

/***********************************************************************
*******
  Demonstrates how to crack an encrypted password using a simple
  "brute force" algorithm. Works on passwords that consist only of 2
uppercase
  letters and a 2 digit integer. Your personalised data set is included
in the
  code.

  Compile with:
    cc -o thread_possix thread_possix.c -lcrypt -pthread

  If you want to analyse the results then use the redirection operator
to send
  output to a file that you can view using an editor or the less
utility:

    ./thread_possix > Thread_results.txt

  Dr Kevan Buckley, University of Wolverhampton, 2018
************************************************************************
******/
int n_passwords = 4;

char *encrypted_passwords[] = {


"$6$KB$6SsUGf4Cq7/Oooym9WWQN3VKeo2lynKV9gXVyEG4HvYy1UFRx.XAye89TLp/OTcW7cGpf9UlU0F.cK/S9CfZn1",

"$6$KB$9su2.NRbU5.MLcI2AoIiaoweIjbw93hYcI3lT1s3YFyu.4oLGagTNFTLM9bl3C5MGLlVvnfYHEeArlvb.edBf1",

"$6$KB$ZXdNTMHL0bvIQIArdlYMICxLe0GpeH/ySCvlGWDTx8R1kojP0orMY/Ri/RRBwWk3WRps8oRf9v6H8neWXVpWm/",

"$6$KB$H5JrICe2/592qzS3JOjIhLZNmO8NwrtVwezWP78Dcu9Z6/JZ1ljNtWp.WyrduQCBQT80oLGGgPFIa4nDZ1Z61."
};
/**
 Required by lack of standard function in C.   
*/

void substr(char *dest, char *src, int start, int length){
  memcpy(dest, src + start, length);
  *(dest + length) = '\0';
}

/**
 This function can crack the kind of password explained above. All
combinations
 that are tried are displayed and when the password is found, #, is put
at the
 start of the line. Note that one of the most time consuming operations
that
 it performs is the output of intermediate results, so performance
experiments
 for this kind of program should not include this. i.e. comment out the
printfs.
*/

void thread()
{
  int i;
pthread_t t1, t2;

    void *kernel_function_1();
    void *kernel_function_2();
for(i=0;i<n_passwords;i<i++) {
   
    
    pthread_create(&t1, NULL,kernel_function_1, encrypted_passwords[i]);
    pthread_create(&t2, NULL,kernel_function_2, encrypted_passwords[i]);

    pthread_join(t1, NULL);
    pthread_join(t2, NULL);
 }
}

void *kernel_function_1(char *salt_and_encrypted){
  int w, x, y;     // Loop counters
  char salt[7];    // String used in hahttps://www.youtube.com/watch?v=L8yJjIGleMwshing the password. Need space
  char plain[7];   // The combination of letters currently being checked
  char *enc;       // Pointer to the encrypted password
  int count = 0;   // The number of combinations explored so far

  substr(salt, salt_and_encrypted, 0, 6);

  for(w='A'; w<='M'; w++){
    for(x='A'; x<='Z'; x++){
      for(y=0; y<=99; y++){
        sprintf(plain, "%c%c%02d", w,x,y);
        enc = (char *) crypt(plain, salt);
        count++;
        if(strcmp(salt_and_encrypted, enc) == 0){
          printf("#%-8d%s %s\n", count, plain, enc);
        } else {
          printf(" %-8d%s %s\n", count, plain, enc);
        }
      }
    }
  }
  printf("%d solutions explored\n", count);
}


void *kernel_function_2(char *salt_and_encrypted){
  int a, b, c;     // Loop counters
  char salt[7];    // String used in hahttps://www.youtube.com/watch?v=L8yJjIGleMwshing the password. Need space
  char plain[7];   // The combination of letters currently being checked
  char *enc;       // Pointer to the encrypted password
  int count = 0;   // The number of combinations explored so far

  substr(salt, salt_and_encrypted, 0, 6);

  for(a='N'; a<='Z'; a++){
    for(b='A'; b<='Z'; b++){
      for(c=0; c<=99; c++){
        sprintf(plain, "%c%c%02d", a,b,c);
        enc = (char *) crypt(plain, salt);
        count++;
        if(strcmp(salt_and_encrypted, enc) == 0){
          printf("#%-8d%s %s\n", count, plain, enc);
        }
      }
    }
  }
  printf("%d solutions explored\n", count);
}

//Calculating time

int time_difference(struct timespec *start, struct timespec *finish, long long int *difference)
 {
	  long long int ds =  finish->tv_sec - start->tv_sec; 
	  long long int dn =  finish->tv_nsec - start->tv_nsec; 

	  if(dn < 0 ) {
	    ds--;
	    dn += 1000000000; 
  } 
	  *difference = ds * 1000000000 + dn;
	  return !(*difference > 0);
}
int main(int argc, char *argv[])
{
  	
	struct timespec start, finish;   
  	long long int time_elapsed;

  	clock_gettime(CLOCK_MONOTONIC, &start);

  	
	
    		thread();
  	
	clock_gettime(CLOCK_MONOTONIC, &finish);
	  time_difference(&start, &finish, &time_elapsed);
	  printf("Time elapsed was %lldns or %0.9lfs\n", time_elapsed,
		                                 (time_elapsed/1.0e9)); 
  return 0;
}
