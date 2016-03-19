""" Biconnected components from orthogonal LAR model """
from larlib import *

filename = "test/svg/inters/house.svg"
#filename = "test/svg/inters/plan.svg"
#filename = "test/py/inters/building.svg"
#filename = "test/py/inters/complex.svg"
lines = svg2lines(filename)
VIEW(STRUCT(AA(POLYLINE)(lines)))
    
V,FV,EV,polygons = larFromLines(lines)
VIEW(EXPLODE(1.2,1.2,1)(MKPOLS((V,EV)) + AA(MK)(V)))

VV = AA(LIST)(range(len(V)))
submodel = STRUCT(MKPOLS((V,EV)))
VIEW(larModelNumbering(1,1,1)(V,[VV,EV,FV],submodel,0.3))


verts,faces,edges = polyline2lar([[ V[v] for v in FV[-1] ]])
VIEW(STRUCT(MKPOLS((verts,edges))))
