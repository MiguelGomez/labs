#include<stdio.h>         
#include<math.h>
float f_de_xi,derivada_xi;
FILE *object;
main()
{
  int i;
  float xi,xr,Es=100,Eu;
  object = fopen("newton.txt", "w+");
  printf("Es: ");
  scanf("%f",&Eu);
  printf("Xi: ");
  scanf("%f",&xi);
  while (Es>=Eu) {
      f_de_xi = exp(-xi)*7*sin(xi);
      derivada_xi = 7*exp(-1*xi)*cos(xi)-7*exp(-1*xi)*sin(xi);
      xr=xi-(f_de_xi/derivada_xi);  
      fprintf(object,"Xr = %f ",xr);
      fprintf(object,"F(x) = %f ",f_de_xi); 
      fprintf(object,"F'(x) = %f ",derivada_xi);
      fprintf(object,"Xi = %f ",xi);
      printf("F(x) = %f ",f_de_xi); 
      printf("F'(x) = %f ",derivada_xi);
      printf("Xi = %f ",xi);
      printf("Xr = %f ",xr);
      Es = ((xr-xi)/xr)*100;
      Es = fabs(Es);
      printf("Es = %f \n",Es);
      fprintf(object,"Es = %f \n",Es);
      xi=xr;     }
  printf("X r= %f.\n",xr);
    fclose(object);
}
