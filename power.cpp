#include<stdio.h>     
#include<math.h>          

int main()
{
  int i;
  float
  t,x,y;
  printf("n :");
  scanf("%f",&x);
  printf("max_limite :");
  scanf("%f",&y);
      for (i=x;i<y+1;i++){
      t=pow(x,y);
      printf("%f\n",t);
   }  
   return 0;
}
