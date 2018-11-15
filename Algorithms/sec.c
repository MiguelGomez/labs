#include<stdio.h>         
#include<math.h>
float f_de_xi,f_de_xi1;
FILE *object;
main()
{
  int i;
  float xi1,xi,xr,Es=100,Eu;
  object = fopen("secante.txt", "w+");
  printf("Es: ");
  scanf("%f",&Eu);
  printf("Xi: ");
  scanf("%f",&xi);
  printf("Xi-1: ");
  scanf("%f",&xi1);
  while (Es>=Eu) {
      f_de_xi = exp(-xi)*7*sin(xi);
      f_de_xi1 = exp(-xi1)*7*sin(xi1);
      xr=xi-(f_de_xi)*(xi1-xi)/(f_de_xi1-f_de_xi);
            fprintf(object,"Xr = %f ",xr);
      fprintf(object,"F(xi) = %f ",f_de_xi); 
      fprintf(object,"F(xi-1) = %f ",f_de_xi1);

      printf("F(xi) = %f ",f_de_xi); 
      printf("F(xi-1) = %f ",f_de_xi1);
      printf("Xr = %f ",xr);
      Es = ((xr-xi)/xr)*100;
      Es = fabs(Es);
      printf("Es = %f \n",Es);
      fprintf(object,"Es = %f \n",Es);
      xi1=xi;
      xi=xr;     }
  printf("X r= %f.\n",xr);
  fclose(object);
}
