""" Fast Polygon Triangulation based on Seidel's Algorithm """
# data generated by test10.py on file polygon.svg
from larlib import *

V,FV,EV = ([[0.222, 0.889],
  [0.722, 1.0],
  [0.519, 0.763],
  [1.0, 0.659],
  [0.859, 0.233],
  [0.382, 0.119],
  [0.519, 0.348],
  [0.296, 0.53],
  [0.0, 0.059]],
 [[0, 1, 2, 3, 4, 5, 6, 7, 8]],
 [[2, 3], [6, 7], [0, 8], [3, 4], [1, 2], [7, 8], [4, 5], [5, 6], [0, 1]])
 
VV = AA(LIST)(range(len(V)))
submodel = STRUCT(MKPOLS((V,EV)))
VIEW(larModelNumbering(1,1,1)(V,[VV,EV],submodel,0.5))

 
xord = TRANS(sorted(zip(V,range(len(V)))))[1]
trapezoids = zip(xord[:-1],xord[1:])
vert2forw_trap = dict()
vert2back_trap = dict()

for k,(a,b) in enumerate(trapezoids[1:-1]):
   print k,(a,b)
   vert2back_trap[a]=k
   vert2forw_trap[a]=k+1
   vert2back_trap[b]=k+1
   vert2forw_trap[b]=k+2
vert2forw_trap[trapezoids[0][0]] = 0
vert2back_trap[trapezoids[-1][1]] = len(trapezoids)-1
