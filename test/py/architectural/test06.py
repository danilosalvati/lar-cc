""" Construction and visualization of a business tower building """

""" import modules from larlib """
from larlib import *

""" Input of floorplan wire-frame """
filename = "test/svg/inters/plan.svg"
larModel = svg2lar(filename)

""" Generation of 2-cellular complexes """

""" Floor layout generation as LAR cellular complex """
scaleFactor = 83.333
larModel = larApply(s(scaleFactor,scaleFactor))(larModel)
V,FV,EV = larModel

""" Visualization of cell numbering of floorplan 2-complex """
VV = AA(LIST)(range(len(V)))
submodel = STRUCT(MKPOLS((V,EV)))
VIEW(larModelNumbering(1,1,1)(V,[VV,EV,FV[:-1]],submodel,2.5))

""" Selection of specialized 1-chains """

""" Classification of edges (boundary, interior, passage 1-chains) """
FE = crossRelation(FV,EV)
boundaryEdges = boundaryCells(FV[:-1], EV)
corridorEdges = list(set(CAT([FE[k] for k in [1,16,9,19,10]])).difference(boundaryEdges))
internalEdges = set(range(len(EV))).difference(boundaryEdges+corridorEdges)

boundaryWalls = AA(COLOR(CYAN))(MKPOLS((V,[EV[k] for k in boundaryEdges])))
internalWalls = AA(COLOR(MAGENTA))(MKPOLS((V,[EV[k] for k in internalEdges])))
corridorWalls = AA(COLOR(YELLOW))(MKPOLS((V,[EV[k] for k in corridorEdges])))

""" Visualization of coloured chains """
submodel = STRUCT(boundaryWalls+internalWalls+corridorWalls)
VIEW(larModelNumbering(1,1,1)(V,[VV,EV,FV[:-1]],submodel,2.5))

""" Guides: 1-chains embedded in 3D """

def plan2Building(V,EV):
    def plan2Building0(subsystem):
        subsystemEV = [EV[k] for k in subsystem]
        subsystemModel = Struct([([v+[0.] for v in V],subsystemEV)])
        subsystemModels = Struct(4*[subsystemModel,t(0,0,3)])
        Vs,EVs = struct2lar(subsystemModels)
        return Vs,EVs
    return plan2Building0

Vc,EVc = plan2Building(V,EV)(corridorEdges)
Vi,EVi = plan2Building(V,EV)(internalEdges)
Vb,EVb = plan2Building(V,EV)(boundaryEdges)

""" 3D visualization of different 1-chains embedded in 3D """
VIEW(EXPLODE(1.2,1.2,1.2)(
    AA(COLOR(CYAN))(MKPOLS((Vc,EVc))) + AA(COLOR(MAGENTA))(MKPOLS((Vi,EVi))) +
    AA(COLOR(YELLOW))(MKPOLS((Vb,EVb))) ))

""" 2.5D chains of the whole building """

plan_2D = V,FV[:2]+FV[3:-1],EV
plan_25D = embedStruct(1)(Struct([plan_2D],"floor"))
building = Struct(4*[plan_25D,t(0,0,3.0)])

""" Construction of 3D floor slabs (pyplasm) """
"""
emptyFaces = [36,63,93,80,64,91,44,22,104,97]
faceChain = [k for k in range(len(FV[:-1])) if k not in emptyFaces+[2]]
FW = [FV[k] for k in faceChain]
VIEW(STRUCT(CAT([[MK(V[v]) for v in FV[f]] for f in faceChain])))
edges = set(CAT([[e for e in FE[f]]  for f in faceChain ]))
EW = [EV[e] for e in edges]
VIEW(EXPLODE(1.2,1.2,1)(MKTRIANGLES(([v+[0] for v in V],FW,EW)+AA(COLOR(RED))(MKPOLS((V,EW))))))
"""
piano_2D = V,FV[:2]+FV[3:-1],EV
piano_25D = embedStruct(1)(Struct([piano_2D],"floor"))

pol = PolygonTessellator()
polVerts =  REVERSE(boundaryPolylines(piano_25D)[0])
vertices = [ vertex.Vertex( (x,y,0) ) for x,y,z in polVerts  ]
verts = pol.tessellate(vertices)
ps = [list(v.point) for v in verts]
trias = [[ps[k],ps[k+1],ps[k+2],ps[k]] for k in range(0,len(ps),3)]
VIEW(STRUCT(AA(POLYLINE)(trias)))

triangles = DISTR([AA(orientTriangle)(trias),[[0,1,2]]])
floor = STRUCT(CAT(AA(MKPOLS)(triangles)))
theFloor = PROJECT(1)(floor)
floor3D = PROD([theFloor,Q(.3)])
VIEW(theFloor)

""" Assembly of 3D model """

""" reference lines """
CVlines = [[Vb[h],Vb[k]] for h,k in EVb]
PIlines = [[Vi[h],Vi[k]] for h,k in EVi]
PClines = [[Vc[h],Vc[k]] for h,k in EVc]

""" Orizontal Partitions """
floors = STRUCT(4*[floor3D,T(3)(3)])
VIEW(floors)

""" Vertical Envelope """
cv = INSR(PROD)([Q(0.3),Q(1),QUOTE([1.2,-1,0.8])])
CV0 = STRUCT(AA(place(cv)())(CVlines))
CV = STRUCT( [ CV0, T(3)(3.) ] )
VIEW(CV)

""" Blind internal partitions """
pint = T(1)(-0.06)(STRUCT([CUBOID([0.12,1,3])]))
PI0 = STRUCT(AA(place(pint)())(PIlines))
PIa = STRUCT( [ PI0, T(3)(3) ] )
VIEW(PIa)

""" Horizontal communication system """
door = T(2)(0.1)(CUBOID([0.8,0.8,2.2]))
PI1 = STRUCT(AA(place(pint)(door))(PClines))
PIb = STRUCT( [ PI1, T(3)(3) ] )
VIEW(PIb)

""" Visualization of whole tower building """
VIEW( STRUCT([ PIa,PIb,CV,T(3)(-.3)(floors) ]) )

