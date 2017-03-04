#include<stdio.h>     
#include<math.h>          

main()
{
  int i;
  float
  t,x,y;
 
  printf("n :");
  scanf("%f",&x);
  printf("max_limite :");
  scanf("%f",&y);
      for (i=0;i<y+1;i++){
      t=pow(x,y);
      printf("%f\n",t);
  getchar();
   }  
}
