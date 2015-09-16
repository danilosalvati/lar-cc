""" Example of oriented edge drawing """

""" Example of oriented edge drawing """
from larlib import *

V = [[9,0],[13,2],[15,4],[17,8],[14,9],[13,10],[11,11],[9,10],[7,9],[5,9],[3,
8],[0,6],[2,3],[2,1],[5,0],[7,1],[4,2],[12,10],[6,3],[8,3],[3,5],[5,5],[7,6],
[8,5],[10,5],[11,4],[10,2],[13,4],[14,6],[13,7],[11,9],[9,7],[7,7],[4,7],[2,
6],[12,7],[12,5]]

FV = [[0,1,26],[5,6,17],[6,7,17,30],[7,30,31],[7,8,31,32],[24,30,31,35],[3,4,
28],[4,5,17,29,30,35],[4,28,29],[28,29,35,36],[8,9,32,33],[9,10,33],[11,10,
33,34],[11,20,34],[20,33,34],[20,21,32,33],[18,21,22],[21,22,32],[22,23,31,
32],[23,24,31],[11,12,20],[12,16,18,20,21],[18,22,23],[18,19,23],[19,23,24],
[15,19,24,26],[0,15,26],[24,25,26],[24,25,35,36],[2,3,28],[1,2,27,28],[12,13,
16],[13,14,16],[14,15,16,18,19],[1,25,26,27],[25,27,36],[36,27,28]]

VIEW(EXPLODE(1.2,1.2,1)(MKPOLS((V,FV))))
VV = AA(LIST)(range(len(V)))
_,EV = larFacets((V,FV+[range(16)]),dim=2,emptyCellNumber=1)

submodel = mkSignedEdges((V,EV))
VIEW(submodel)
VIEW(larModelNumbering(scalx=1,scaly=1,scalz=1)(V,[VV,EV,FV],submodel,2))

orientedBoundary = signedCellularBoundaryCells(V,[VV,EV,FV])
cells = [EV[e] if sign==1 else REVERSE(EV[e]) for (sign,e) in zip(*orientedBoundary)]
submodel = mkSignedEdges((V,cells))
VIEW(submodel)


C2 = csr_matrix((len(FV),1))
for i in [1,2, 12,13,14,15, 22,23, 29,30,31]: C2[i,0] = 1
BD = boundary(FV,EV)
C1 = BD * C2
C_1 = [i for i in range(len(EV)) if ABS(C1[i,0]) == 1 ]
C_2 = [i for i in range(len(FV)) if C2[i,0] == 1 ]

VIEW(EXPLODE(1.2,1.2,1)(MKPOLS((V,[EV[k] for k in C_1] + [FV[k] for k in C_2]))))
