# -*- coding: utf-8 -*-
"""Module for integration of polynomials over 3D volumes and surfaces"""
from pyplasm import *
import sys; sys.path.insert(0, 'lib/py/')
from lar2psm import *

""" Surface and volume integrals """
def Surface(P):
    return II(P, 0, 0, 0)
def Volume(P):
    return III(P, 0, 0, 0)

""" Terms of the Euler tensor """
def FirstMoment(P):
    out = [None]*3
    out[0] = III(P, 1, 0, 0)
    out[1] = III(P, 0, 1, 0)
    out[2] = III(P, 0, 0, 1)
    return out

def SecondMoment(P):
    out = [None]*3
    out[0] = III(P, 2, 0, 0)
    out[1] = III(P, 0, 2, 0)
    out[2] = III(P, 0, 0, 2)
    return out

def InertiaProduct(P):
    out = [None]*3
    out[0] = III(P, 0, 1, 1)
    out[1] = III(P, 1, 0, 1)
    out[2] = III(P, 1, 1, 0)
    return out

""" Vectors and convectors of mechanical interest """
def Centroid(P):
    out = [None]*3
    firstMoment = FirstMoment(P)
    volume = Volume(P)
    out[0] = firstMoment[0]/volume
    out[1] = firstMoment[1]/volume
    out[2] = firstMoment[2]/volume
    return out

def InertiaMoment(P):
    out = [None]*3
    secondMoment = SecondMoment(P)
    out[0] = secondMoment[1] + secondMoment[2]
    out[1] = secondMoment[2] + secondMoment[0]
    out[2] = secondMoment[0] + secondMoment[1]
    return out

""" Basic integration functions """
def II(P, alpha, beta, gamma):
    w = 0
    V, FV = P
    for i in range(len(FV)):
        tau = [V[v] for v in FV[i]]
        w += T(tau, alpha, beta, gamma)
    return w

def III(P, alpha, beta, gamma):
    w = 0
    V, FV = P
    for i in range(len(FV)):
        tau = [V[v] for v in FV[i]]
        vo,va,vb = tau
        a = VECTDIFF([va,vo])
        b = VECTDIFF([vb,vo])
        c = VECTPROD([a,b])
        w += (c[0]/VECTNORM(c)) * T(tau, alpha+1, beta, gamma)
    return w/(alpha + 1)

def M(alpha, beta):
    a = 0
    for l in range(alpha + 2):
        a += CHOOSE([alpha+1,l]) * POWER([-1,l])/(l+beta+1)
    return a/(alpha + 1)

""" The main integration routine """
def T(tau, alpha, beta, gamma):
   vo,va,vb = tau
   a = VECTDIFF([va,vo])
   b = VECTDIFF([vb,vo])
   sl = 0;
   for h in range(alpha+1):
      for k in range(beta+1):
         for m in range(gamma+1):
            s2 = 0
            for i in range(h+1): 
               s3 = 0
               for j in range(k+1):
                  s4 = 0
                  for l in range(m+1):
                     s4 += CHOOSE([m, l]) * POWER([a[2], m-l]) \
                        * POWER([b[2], l]) * M( h+k+m-i-j-l, i+j+l )
                  s3 += CHOOSE([k, j]) * POWER([a[1], k-j]) \
                     * POWER([b[1], j]) * s4
               s2 += CHOOSE([h, i]) * POWER([a[0], h-i]) * POWER([b[0], i]) * s3;
            sl += CHOOSE ([alpha, h]) * CHOOSE ([beta, k]) * CHOOSE ([gamma, m]) \
               * POWER([vo[0], alpha-h]) * POWER([vo[1], beta-k]) \
               * POWER([vo[2], gamma-m]) * s2;
   c = VECTPROD([a, b]);
   return sl * VECTNORM(c);
