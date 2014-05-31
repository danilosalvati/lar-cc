""" Extraction of boundary vertices of a cuboidal complex """
import sys; sys.path.insert(0, 'lib/py/')
from largrid import *
from random import random

shape = 20,20
V,cells = larCuboids(shape)
cellSpan = prod(shape)
fraction = 0.9
remove = [int(random()*cellSpan) for k in range(int(cellSpan*fraction)) ]
cells = [cells[k] for k in range(cellSpan) if not k in remove]
V,EV = larCuboidsFacets((V,cells))
VIEW(EXPLODE(1.2,1.2,1)(MKPOLS((V,EV))))
