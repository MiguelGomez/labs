/*
===============================================================================
 NOMBRE:           Benavides Fernández Ricardo Abraham.
 No. CTRL:         01-401.
 MATERIA:          Fundamentos de Análisis Numérico.
 DESCRIPCION:      Este programa sirve para encontrar raices de ecuaciones
                   utilizando los siguientes métodos:
                    - Bisección.
                    - Falsa Posición.
                    - Newton-Rhapson.
                    - Secante.
 
                   Los métodos han sido proporcionados por la librería GSL
                   (GNU Scientific Library).
 FECHA DE ENTREGA: 11-May-05
 FECHA:            11-May-05
 
 CMDO. DE COMP:    
 g++ -O -Wall  -o raices raices.cpp -lgsl -lgslcblas -lncurses
                   
 de forma estatica:
 g++ -static -O -Wall  -o raices raices.cpp -lgsl -lgslcblas -lncurses -lgpm
===============================================================================
*/

/* =============================   ENCABEZADOS   ========================= */

#include <iostream>
#include <gpm.h>
#include <ncurses.h>
#include <gsl/gsl_roots.h>
#include <gsl/gsl_errno.h>
#include <gsl/gsl_poly.h>

using namespace std;

/* =============================   SINONIMOS  ============================ */

typedef unsigned short int USHORT;

/* ======================== CONSTANTES SIMBOLICAS ======================== */

const int ITERACION_MAX = 20;
const double ABS_TOL = 0.1;
const double REAL_TOL = 0.001;

/* ====================   TIPOS DEF. POR EL USUARIO   ==================== */

struct parametros_cuadratica {double a, b, c;};
struct parametros_cubica {double a, b, c, d;};
struct parametros_exp {double m, v, t;};

/* ============================= DECLARACIONES =========================== */
/*                                 (INTERFAZ)                              */

void tabla (struct parametros_cuadratica parametros, double & xl, double & xu);
//void tabla (struct parametros_cubica parametros);
void valores (struct parametros_cuadratica & parametros);
void valores (struct parametros_cubica  & parametros);
//void valores (parametros_cuadratica & parametros, int fn);
double cuadratica (double x, void * parametros);
double cubica     (double x, void * parametros);
double exp        (double x, void * parametros);
int resolver (double & rxl, double & rxu, gsl_root_fsolver* & rsolver);
int resolver (struct parametros_cuadratica & parametros);

/* ============================== PROGRAMA  ============================== */

int 
main ()
{
 int opcion1 = 0,
     opcion2 = 0;
 const gsl_root_fsolver_type *Tipo;
 gsl_root_fsolver *solver;
 gsl_function Funcion;
 double xl,
        xu;   
 struct parametros_cubica par_cubic;    
 struct parametros_cuadratica par_cua;// = 
 // {-0.4, 2.2, 4.7}; //Parametros para una fn cuadrática.

 initscr (); //Inicialización de ncurses
 nonl ();
 
 clear ();
 mvprintw (0, (COLS - 26) / 2, ":: RAICES DE ECUACIONES:: ");
 mvprintw (2, 0,  "Elija una ecuación:");
 //Elección de la ecuación a evaluar.
 mvprintw (3, 19, "[1] f(x) = ax^2+bx+c"); //Fn1
 mvprintw (4, 19, "[2] f(x) = ax^3+bx^2+cx+d"); //Fn2
 mvprintw (5, 19, "[3] f(c) = (gm/c)(1-exp(-(c/m)t)-v\t"
         "(Métodos Numéricos 3ed., Chapra, Pag. 127)"); //Fn3
 mvprintw (6, 19, "[4] Declarar\t\t\t\t"
           "(Sin implementación =("); //Fn4
 mvprintw (7, 0, "Opción [1-4]: ");
 refresh ();

 do {
 scanw ("%i", &opcion1);
 move (7, 14);
 refresh ();
 }while (opcion1 > 4 && opcion1 < 1);
 
 mvprintw (10, 0, "Elija un método:");
 //Elección del método a usar.
 mvprintw (11,  16, "[1] Fórmula General.");
 mvprintw (12, 16, "[2] Bisección");
 mvprintw (13, 16, "[3] Falsa Posición.");
 mvprintw (14, 16, "[4] Newton-Rhapson.");
 mvprintw (15, 16, "[5] Secante.");
 mvprintw (16, 0, "Opción [1-5]: ");
 refresh ();
 
 do {
 scanw ("%i", &opcion2);
 move (16, 14);
 refresh ();
 }while (opcion2 > 5 && opcion2 < 1);
 
 clear ();
  //mvprintw (20, 4, "%i, %i", opcion1, opcion2);
  //getch (); 
 switch (opcion1) { // Fn. a evaluar
 
  case 1: switch (opcion2) { //Fn1
           case 1: //Formula General
                      mvprintw (2, (COLS - 19) / 2, "::FORMULA GENERAL::");
                      valores (par_cua); //Inicializa los valores
                      clear ();
                      resolver (par_cua);
                      break; //Fórmula General
           case 2: mvprintw (2, (COLS - 13) / 2, "::BISECCION::");
                   valores (par_cua); //Inicializa los valores
                   clear ();
                   tabla (par_cua, xl, xu);
                   clear ();
                   //Inicialización del tipo.
                   Tipo = gsl_root_fsolver_bisection;                   
                   //Inicialización del solver con el tipo adecuado de fn.
                   solver = gsl_root_fsolver_alloc (Tipo); 
                   //Se le pasa al Data Type la fn. adecuda.
                   Funcion.function = &cuadratica;                   
                   //Se le pasa su conjunto de parámetros.                 
                   Funcion.params = &par_cua;                                  
                   //Pasado de parametros para el cálculo de la raiz al solver.
                   gsl_root_fsolver_set (solver, &Funcion, xl, xu); 
                   resolver (xl, xu, solver);
                   gsl_root_fsolver_free (solver); //Libera el espacio en mem.
                   break;//Fin Bisección
           case 3: break; //Falsa Posición
           case 4: break; //Newton-Rhapson
           case 5: break; //Secante
          }
          break;
  case 2: switch (opcion2) { //Fn2
           case 1: break; //Fórmula General
           case 2: break; //Bisección
           case 3: break; //Falsa Posición
           case 4: break; //Newton-Rhapson
           case 5: break; //Secante
          }
          break;
  case 3: switch (opcion2) { //Fn3
           case 1: break; //Fórmula General
           case 2: break; //Bisección
           case 3: break; //Falsa Posición
           case 4: break; //Newton-Rhapson
           case 5: break; //Secante
          }
          break;
  case 4: switch (opcion2) { //Fn4
           case 1: break; //Fórmula General
           case 2: break; //Bisección
           case 3: break; //Falsa Posición
           case 4: break; //Newton-Rhapson
           case 5: break; //Secante
          }
          break;
 }
 
 getch ();
    
 endwin (); //Terminación de ncurses
 return EXIT_SUCCESS;
}

/* ==============================  FUNCIONES  ============================ */
/*                               (DEFINICION)                              */

void 
tabla (struct parametros_cuadratica parametros, double & xl, double & xu)
{
 double x_inf, 
        x_sup;
 float fDato = 0.0;
 char res = 'N';
 
 xl = 5.0;
 xu = 10.0;
 
 /*parametros.a = -0.4;
 parametros.b = 2.2;
 parametros.c = 4.7;*/
 
 do {
  clear ();

  x_inf = 0.0;
  x_sup = 15.0;
  
  move (5, 0);
  printw ("--Tabulando función--\n\n\n");
  printw ("Introduzca el rango de valores x para tabular [x_inf , x_sup]\n\n");
  
  printw ("Introduzca min. valor para x_inf [0.0]: ");    
  if (scanw ("%f%*c", &fDato) != ERR)
   x_inf = fDato;
  
  
  printw ("Introduzca valor para x_supe [15.0]: ");
  if (scanw ("%f%*c", &fDato) != ERR)
   x_sup = fDato;
 
  putchar ('\n');
  
  printw ("%8c %10s\n", 'x', "f(x)");
  printw ("  --------------------\n");
  
  for (;x_inf <= x_sup; x_inf++)
   printw ("%''9.4f | %''9.4f\n", x_inf, (parametros.a * x_inf + parametros.b) * \
     x_inf + parametros.c);
   
  printw ("\nDesea volver a generar la tabla? (N/S):[N] ");
  if (scanw ("%c%*c", &res) != ERR)
   if (res == 's' || res == 'S')
    continue;
    
  printw ("\n\nIngrese valores para xl y xu con respecto a la tabla\n");
  printw ("xl [5.0]: "); 
  if (scanw ("%f%*c", &fDato) != ERR)
   xl = fDato;
  printw ("xu [10.0]: ");
  if (scanw ("%f%*c", &fDato) != ERR)
   xu = fDato;
 }while (res == 'S' || res == 's'); 
 //
 refresh ();
}

/*void
tabla (struct parametros_cubica parametros)
{
 int xmin = 0,
        xmax = 0;
        
 do {
  move (7,0);
  printw ("--Tabulando valores de la ecuaion--\n");
  printw ("Ingrese los valores para el rango de tabulación [x, x]\n \
            Los valores deben esta en un rango no mayor a 10\n \
            (x máximo - xminimo) <= 10\n\n");
            
  printw ("x minimo :"); 
  scanw ("%d%*c", &xmin);
  printw ("x máximo :"); 
  scanw ("%d%*c", &xmax);
  refresh ();
  
  printw ("%d\n", xmin);
  printw ("%d\n", xmax);
  refresh ();
 }while (xmax - xmin > 10);
 
 printw ("%c %s", 'x', "f(x)\n");
 
 for (;xmin < xmax; xmin++)
  printw ("%d %d\n", xmin, (parametros.a * xmin + parametros.b) \
    * xmin + parametros.c);
}*/

void 
valores (struct parametros_cuadratica & parametros)
{
 float fParam;
 
 parametros.a = -0.4;
 parametros.b = 2.2;
 parametros.c = 4.7;
 
 clear ();
 refresh ();
 move (5, 0);
 printw ("Introduzca los parámetros para la ecuación:\n");
 
 printw ("\ta [-0.4]: ");
 if (scanw ("%f%*c", &fParam) != ERR)
  parametros.a = fParam;
 refresh (); 
 
 printw ("\tb [2.2]: ");
 if (scanw ("%f%*c", &fParam) != ERR)
  parametros.a = fParam;
 refresh ();
 printw ("\tc [4.7]: ");
 if (scanw ("%f%*c", &fParam) != ERR)
  parametros.c = fParam;
   
 putchar ('\n');
 refresh ();
}

void
valores (struct parametros_cubica & parametros)
{
}

double
cuadratica (double x, void * parametros)
{
 struct parametros_cuadratica *p = (struct parametros_cuadratica *)
parametros;
 
 double a = p -> a;
 double b = p -> b;
 double c = p -> c;
  
 return (a*x+b)*x+c; //Factorizando una x.
}

double
cubica (double x, void * parametros)
{
 struct parametros_cubica *p = (struct parametros_cubica *) parametros;
 
 double a = p -> a;
 double b = p -> b;
 double c = p -> c;
 double d = p -> d;
  
 return ((a*x+b)*x+c)*x+d;
}

double
exp (double x, void * parametros)
{
 struct parametros_exp *p = (struct parametros_exp *) parametros;
 const double g = 9.8; //gravedad
 
 double m = p -> m;
 double v = p -> v;
 double t = p -> t;

 return ((g*m)/x)*(1-exp(-1*(x/m)*t))-v;
}

int 
resolver (double & rxl, double & rxu, gsl_root_fsolver* & rsolver)
{
 int status,
     iteracion = 0;
 double raiz = 0.0,
        tmp;
 
 //Titulo 
 mvprintw (1, (COLS - 34) / 2, "Usando el método: -- %s --\n",
          gsl_root_fsolver_name (rsolver));
 
 move (5, 0);

 printw ("Valores de paro:\n");
 printw ("Tolerancia absoluta:\t\t%.4f\n", ABS_TOL);
 printw ("Tolerancia real:\t\t%.4f\n\n", REAL_TOL);

 printw ("Corrida...\n");
 printw ("%s [%8s, %8s] %8s %8s %8s\n", "iteración", "xl", "xu", "raiz",
         "error", "err(est)");
 raiz = gsl_root_fsolver_root (rsolver);
 rxl = gsl_root_fsolver_x_lower (rsolver);
 rxu = gsl_root_fsolver_x_upper (rsolver);
 tmp = (rxu - rxl) / (rxu + rxl);
 tmp = fabsl (tmp);
 printw ("%9d [%''8.4f, %''8.4f] %''8.4f %''8.4f %''8.4f\n",
          iteracion, rxl, rxu, raiz, tmp, rxl-rxu );
         refresh ();

 do{
  iteracion++;
  status = gsl_root_fsolver_iterate (rsolver);
  raiz = gsl_root_fsolver_root (rsolver);
  rxl = gsl_root_fsolver_x_lower (rsolver);
  rxu = gsl_root_fsolver_x_upper (rsolver);
  tmp = (rxu - rxl) / (rxu + rxl);
  tmp = fabsl (tmp);
  status = gsl_root_test_interval (rxl, rxu, ABS_TOL, REAL_TOL);
  if (status == GSL_SUCCESS)
   printw ("Convergió:\n");
  printw ("%9d [%''8.4f, %''8.4f] %''8.4f %''8.4f %''8.4f\n",
           iteracion, rxl, rxu, raiz, tmp, rxl-rxu );
  refresh ();
 }while (status == GSL_CONTINUE && iteracion < ITERACION_MAX);
 
 return status;
}

int resolver (struct parametros_cuadratica & parametros)
{
 double *raiz0 = 0,
           *raiz1 = 0,
           a = -3.0,
           b = 2.9,
           c=1.9;
           
 mvprintw (1, (COLS - 37) / 2, "Usando el método: -- %s --\n", "Formula Gral.");
 move (5, 0);
 
 gsl_poly_solve_quadratic (a, b, c, raiz0, raiz1);
 
 printw ("ok");
 refresh (); 
 
 if (*raiz1 != 0) {
  printw ("El valor para la primera raiz es: %f\n", *raiz0);
  printw ("El valor para la segunda raiz es: %f\n", *raiz1);
 }
 printw ("El valor para la primera raiz es:%f", *raiz0);
 
//printw ("esta es una cadena: %s", "hola mundo");
 
 refresh ();
 //exit (-21);
 return 1;
}
//EOF
