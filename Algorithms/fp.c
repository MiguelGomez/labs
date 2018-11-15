#include<stdio.h>               
#include<math.h>



main()
{
  FILE *object;
  object = fopen("posicion.txt", "w+");
  float f_de_xi,f_de_xr,f_de_xu;
  float xu,xi,xr=10000,xr1,Es=100,Eu;
  printf("Es: ");
  scanf("%f",&Eu);
  printf("Xi: ");
  scanf("%f",&xi);
  printf("Xu: ");
  scanf("%f",&xu);
  while (Eu<Es) {
    xr1=xr;
    f_de_xi= -2+7*xi-5*xi*xi+6*xi*xi*xi;
    f_de_xu= -2+7*xu-5*xu*xu+6*xu*xu*xu;
    f_de_xr= -2+7*xr-5*xr*xr+6*xr*xr*xr;
    xr=xu-(f_de_xu)*(xi-xu)/(f_de_xi-f_de_xu);
    Es = ((xr-xr1)/xr)*100;
    Es = fabs(Es);
    printf("Xr= %f ",xr);
    fprintf(object,"F(xi) = %f ",f_de_xi); 
    fprintf(object,"F(xr) = %f ",f_de_xr);
    printf("F(xi) = %f ",f_de_xi); 
    printf("F(xr) = %f ",f_de_xr);
    fprintf(object,"Es = %f\n",Es); 
    printf("Es = %f\n",Es);
    if (f_de_xi*f_de_xr < 0) xu=xr;
    if (f_de_xi*f_de_xr > 0) xi=xr;
    if (f_de_xi*f_de_xr == 0) break;
  }  
  printf("Xr = %f\n",xr);
  fprintf(object,"Xr = %f\n",xr);
  fclose(object);
}
