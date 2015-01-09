"""Module with functions needed to interface LAR with pyplasm"""
def importModule(moduleName):
    import sys; sys.path.insert(0, 'lib/py/')
    import moduleName
    

from lar2psm import *
def t(*args): 
    d = len(args)
    mat = scipy.identity(d+1)
    for k in range(d): 
        mat[k,d] = args[k]
    return mat.view(Mat)

def s(*args): 
    d = len(args)
    mat = scipy.identity(d+1)
    for k in range(d): 
        mat[k,k] = args[k]
    return mat.view(Mat)

def r(*args): 
    args = list(args)
    n = len(args)
    if n == 1: # rotation in 2D
        angle = args[0]; cos = COS(angle); sin = SIN(angle)
        mat = scipy.identity(3)
        mat[0,0] = cos;    mat[0,1] = -sin;
        mat[1,0] = sin;    mat[1,1] = cos;
    
    if n == 3: # rotation in 3D
        mat = scipy.identity(4)
        angle = VECTNORM(args); axis = UNITVECT(args)
        cos = COS(angle); sin = SIN(angle)
        if axis[1]==axis[2]==0.0:    # rotation about x
            mat[1,1] = cos;    mat[1,2] = -sin;
            mat[2,1] = sin;    mat[2,2] = cos;
        elif axis[0]==axis[2]==0.0:    # rotation about y
            mat[0,0] = cos;    mat[0,2] = sin;
            mat[2,0] = -sin;    mat[2,2] = cos;
        elif axis[0]==axis[1]==0.0:    # rotation about z
            mat[0,0] = cos;    mat[0,1] = -sin;
            mat[1,0] = sin;    mat[1,1] = cos;
        
        else:        # general 3D rotation (Rodrigues' rotation formula)    
            I = scipy.identity(3) ; u = axis
            Ux = scipy.array([
                [0,        -u[2],      u[1]],
                [u[2],        0,     -u[0]],
                [-u[1],     u[0],         0]])
            UU = scipy.array([
                [u[0]*u[0],    u[0]*u[1],    u[0]*u[2]],
                [u[1]*u[0],    u[1]*u[1],    u[1]*u[2]],
                [u[2]*u[0],    u[2]*u[1],    u[2]*u[2]]])
            mat[:3,:3] = cos*I + sin*Ux + (1.0-cos)*UU
        
    
    return mat.view(Mat)

def larEmbed(k):
    def larEmbed0(model):
        if len(model)==2: V,CV = model
        elif len(model)==3: V,CV,FV = model
        if k>0:
            V = [v+[0.]*k for v in V] 
        elif k<0:
            V = [v[:-k] for v in V] 
        if len(model)==2: return V,CV
        elif len(model)==3: return V,CV,FV
    return larEmbed0

def larApply(affineMatrix):
    def larApply0(model):
        if isinstance(model,Model):
            # V = scipy.dot([v.tolist()+[1.0] for v in model.verts], affineMatrix.T).tolist()
            V = scipy.dot(array([v+[1.0] for v in model.verts]), affineMatrix.T).tolist()
            V = [v[:-1] for v in V]
            CV = copy.copy(model.cells)
            return Model((V,CV))
        elif isinstance(model,tuple) or isinstance(model,list):
            if len(model)==2: V,CV = model
            elif len(model)==3: V,CV,FV = model
            V = scipy.dot([v+[1.0] for v in V], affineMatrix.T).tolist()
            if len(model)==2: return [v[:-1] for v in V],CV
            elif len(model)==3: return [v[:-1] for v in V],CV,FV
    return larApply0

from copy import deepcopy

def embedStruct(k):
    def embedStruct0(struct):
        struct,dim = embedding(k, struct) 
        if k==0: return struct,dim
        else: return struct
    return embedStruct0

def embedding(k, struct):
    out = deepcopy(struct)
    if isinstance(out,Struct):
        if k==0: 
            return out, len(out.box[0])
        out.box[0] = out.box[0]+k*[0.0]
        out.box[1] = out.box[1]+k*[0.0]
        for i,obj in enumerate(out.body):
            if isinstance(obj,Model): 
                out.body[i] = larEmbed(k)(obj)
                out.n = out.n + k
            elif (isinstance(obj,tuple) or isinstance(obj,list)) and len(obj)==2:
                out.body[i] = larEmbed(k)(obj)
            elif isinstance(obj,Mat): 
                out.body[i] = obj # TODO: embed matrix in identity
            elif isinstance(obj,Struct):
                out.body[i] = embedding(k, obj)
    elif not isinstance(struct,Struct):
        obj = struct[0]
        if isinstance(obj,Struct): 
            return struct,len(obj.box[0])
        elif isinstance(obj,Model): 
            return struct,obj.n
        elif (isinstance(obj,tuple) or isinstance(obj,list)):
            return struct,len(obj[0][0])
        elif isinstance(obj,Mat): 
            return struct,len(obj[0])-1
    return out,k
""" Flatten a list using Python generators """
def flatten(lst):
    for x in lst:
        if (isinstance(x,tuple) or isinstance(x,list)) and len(x)==2:
            yield x
        elif (isinstance(x,tuple) or isinstance(x,list)):
            for x in flatten(x):
                yield x
        elif isinstance(x, Struct):
            for x in flatten(x.body):
                yield x
        else:
            yield x
 
#  lst = [[1], 2, [[3,4], 5], [[[]]], [[[6]]], 7, 8, []]
#  print list(flatten(lst)) 
#  [1, 2, 3, 4, 5, 6, 7, 8]

#  import itertools
#  chain = itertools.chain.from_iterable([[1,2],[3],[5,89],[],[6]])
#  print(list(chain))
#  [1, 2, 3, 5, 89, 6]    ###  TODO: Bug coi dati sopra?

def checkStruct(lst):
    """ Return the common dimension of structure elements.

        TODO: aggiungere test sulla dimensione minima delle celle (legata a quella di immersione)
    """
    lst,dim = embedStruct(0)(lst)
    return dim

""" Traversal of a scene multigraph """
def traversal(CTM, stack, obj, scene=[]):
    for i in range(len(obj)):
        if isinstance(obj[i],Model): 
            scene += [larApply(CTM)(obj[i])]
        elif (isinstance(obj[i],tuple) or isinstance(obj[i],list)) and (
                len(obj[i])==2 or len(obj[i])==3):
            scene += [larApply(CTM)(obj[i])]
        elif isinstance(obj[i],Mat): 
            CTM = scipy.dot(CTM, obj[i])
        elif isinstance(obj[i],Struct):
            stack.append(CTM) 
            traversal(CTM, stack, obj[i], scene)
            CTM = stack.pop()
    return scene

def evalStruct(struct):
    dim = checkStruct(struct.body)
    CTM, stack = scipy.identity(dim+1), []
    scene = traversal(CTM, stack, struct, []) 
    return scene

""" class definitions for LAR """
import scipy
class Mat(scipy.ndarray): pass
class Verts(scipy.ndarray): pass

class Model:
    """ A pair (geometry, topology) of the LAR package """
    def __init__(self,(verts,cells)):
        self.n = len(verts[0])
        # self.verts = scipy.array(verts).view(Verts)
        self.verts = verts
        self.cells = cells
    def __getitem__(self,i):
        return list((self.verts,self.cells))[i]

from myfont import *
class Struct:
    """ The assembly type of the LAR package """
    def __init__(self,data,name=None):
        self.body = data
        if name != None: 
            self.name = str(name)
        else:
            self.name = str(id(self))
        self.box = box(self) 
    def __name__(self):
        return self.name
    def __iter__(self):
        return iter(self.body)
    def __len__(self):
        return len(list(self.body))
    def __getitem__(self,i):
        return list(self.body)[i]
    def __print__(self): 
        return "<Struct name: %s>" % self.__name__()
    def __repr__(self):
        return "<Struct name: %s>" % self.__name__()
        #return "'Struct(%s,%s)'" % (str(self.body),str(str(self.__name__())))
    def draw(self,color=WHITE,scaling=1):
        vmin,vmax = self.box
        delta = VECTDIFF([vmax,vmin])
        point = CCOMB(self.box)
        scalingFactor = scaling*delta[0]/20.
        text = TEXTWITHATTRIBUTES (TEXTALIGNMENT='centre', TEXTANGLE=0,
                    TEXTWIDTH=0.1*scalingFactor, 
                    TEXTHEIGHT=0.2*scalingFactor,
                    TEXTSPACING=0.025*scalingFactor)
        return T([1,2,3])(point)(COLOR(color)(text(self.name)))

""" Structure to pair (Vertices,Cells) conversion """

def struct2lar(structure):
    listOfModels = evalStruct(structure)
    vertDict = dict()
    index,defaultValue,CW,W,FW = -1,-1,[],[],[]
        
    for model in listOfModels:
        if isinstance(model,Model):
            V,FV = model.verts,model.cells
        elif (isinstance(model,tuple) or isinstance(model,list)):
            if len(model)==2: V,FV = model
            elif len(model)==3: V,FV,EV = model
        for k,incell in enumerate(FV):
            outcell = []
            for v in incell:
                key = vcode(V[v])
                if vertDict.get(key,defaultValue) == defaultValue:
                    index += 1
                    vertDict[key] = index
                    outcell += [index]
                    W += [eval(key)]
                else: 
                    outcell += [vertDict[key]]
            CW += [outcell]
        if len(model)==3:
            for k,incell in enumerate(EV):
                outcell = []
                for v in incell:
                    key = vcode(V[v])
                    if vertDict.get(key,defaultValue) == defaultValue:
                        index += 1
                        vertDict[key] = index
                        outcell += [index]
                        W += [eval(key)]
                    else: 
                        outcell += [vertDict[key]]
                FW += [outcell]
            
    if len(model)==2: return W,CW
    if len(model)==3: return W,CW,FW

def larEmbed(k):
    def larEmbed0(model):
        if len(model)==2: V,CV = model
        elif len(model)==3: V,CV,FV = model
        if k>0:
            V = [v+[0.]*k for v in V] 
        elif k<0:
            V = [v[:-k] for v in V] 
        if len(model)==2: return V,CV
        elif len(model)==3: return V,CV,FV
    return larEmbed0

""" Computation of the containment box of a Lar Struct or Model """
import copy
def box(model):
    if isinstance(model,Mat): return []
    elif isinstance(model,Struct):
        dummyModel = copy.deepcopy(model)
        dummyModel.body = [term if (not isinstance(term,Struct)) else [term.box,[[0,1]]]  for term in model.body]
        listOfModels = evalStruct( dummyModel )
        dim = checkStruct(listOfModels)
        theMin,theMax = box(listOfModels[0]) 
        for theModel in listOfModels[1:]:
            modelMin, modelMax = box(theModel)
            theMin = [val if val<theMin[k] else theMin[k] for k,val in enumerate(modelMin)]
            theMax = [val if val>theMax[k] else theMax[k] for k,val in enumerate(modelMax)]
        return [theMin,theMax]
    elif isinstance(model,Model):
        V = model.verts
    elif (isinstance(model,tuple) or isinstance(model,list)) and (len(model)==2 or len(model)==3):
        V = model[0]
    coords = TRANS(V)
    theMin = [min(coord) for coord in coords]
    theMax = [max(coord) for coord in coords]
    return [theMin,theMax]
