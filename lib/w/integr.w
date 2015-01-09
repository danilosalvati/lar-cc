\documentclass[11pt,oneside]{article}	%use"amsart"insteadof"article"forAMSLaTeXformat
\usepackage{geometry}		%Seegeometry.pdftolearnthelayoutoptions.Therearelots.
\geometry{letterpaper}		%...ora4paperora5paperor...
%\geometry{landscape}		%Activateforforrotatedpagegeometry
%\usepackage[parfill]{parskip}		%Activatetobeginparagraphswithanemptylineratherthananindent
\usepackage{graphicx}				%Usepdf,png,jpg,orepsßwithpdflatex;useepsinDVImode
								%TeXwillautomaticallyconverteps-->pdfinpdflatex		
\usepackage{amssymb}
\usepackage[colorlinks]{hyperref}

%----macros begin---------------------------------------------------------------
\usepackage{color}
\usepackage{amsthm}

\def\conv{\mbox{\textrm{conv}\,}}
\def\aff{\mbox{\textrm{aff}\,}}
\def\E{\mathbb{E}}
\def\R{\mathbb{R}}
\def\Z{\mathbb{Z}}
\def\tex{\TeX}
\def\latex{\LaTeX}
\def\v#1{{\bf #1}}
\def\p#1{{\bf #1}}
\def\T#1{{\bf #1}}

\def\vet#1{{\left(\begin{array}{cccccccccccccccccccc}#1\end{array}\right)}}
\def\mat#1{{\left(\begin{array}{cccccccccccccccccccc}#1\end{array}\right)}}

\def\lin{\mbox{\rm lin}\,}
\def\aff{\mbox{\rm aff}\,}
\def\pos{\mbox{\rm pos}\,}
\def\cone{\mbox{\rm cone}\,}
\def\conv{\mbox{\rm conv}\,}
\newcommand{\homog}[0]{\mbox{\rm homog}\,}
\newcommand{\relint}[0]{\mbox{\rm relint}\,}

%----macros end-----------------------------------------------------------------

\title{Finite domain integration of polynomials
\footnote{This document is part of the \emph{Linear Algebraic Representation with CoChains} (LAR-CC) framework~\cite{cclar-proj:2013:00}. \today}
}
\author{Alberto Paoluzzi}
%\date{}							%Activatetodisplayagivendateornodate

\begin{document}
\maketitle
\nonstopmode

\begin{abstract}
In order to plan or control the static/dynamic behaviour of models in CAD applications, it is often necessary to evaluate integral properties ot solid models (i.e. volume, centroid, moments of inertia, etc.). This module deals with the exact evaluation of inertial properties of homogeneous polyhedral objects. 
\end{abstract}

\section{Introduction}

A finite integration method from\cite{CattaniP-BIL1990} is developed here the computation of various order monomial integrals over polyhedral solids and surfaces in 3D space. The integration method can be used for the exact evaluation of domain integrals of trivariate polynomial forms.


\section{Algoritms}


\section{Implementation}

\subsection{High-level interfaces}


\paragraph{Surface and volume integrals}
%-------------------------------------------------------------------------------
@D Surface and volume integrals
@{""" Surface and volume integrals """
def Surface(P):
    return II(P, 0, 0, 0)
def Volume(P):
    return III(P, 0, 0, 0)
@}
%-------------------------------------------------------------------------------


\paragraph{Terms of the Euler tensor}
%-------------------------------------------------------------------------------
@D Terms of the Euler tensor
@{""" Terms of the Euler tensor """
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
@}
%-------------------------------------------------------------------------------




\paragraph{Vectors and convectors of mechanical interest}
%-------------------------------------------------------------------------------
@D Vectors and convectors of mechanical interest
@{""" Vectors and convectors of mechanical interest """
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
@}
%-------------------------------------------------------------------------------




\paragraph{Basic integration functions}
%-------------------------------------------------------------------------------
@D Basic integration functions
@{""" Basic integration functions """
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
@}
%-------------------------------------------------------------------------------



\paragraph{The main integration routine}
%-------------------------------------------------------------------------------
@D The main integration routine
@{""" The main integration routine """
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
@}
%-------------------------------------------------------------------------------







\subsection{Exporting the \texttt{integr} module}

%-------------------------------------------------------------------------------
@o lib/py/integr.py 
@{# -*- coding: utf-8 -*-
"""Module for integration of polynomials over 3D volumes and surfaces"""
from pyplasm import *
import sys; sys.path.insert(0, 'lib/py/')
from lar2psm import *

@< Surface and volume integrals @>
@< Terms of the Euler tensor @>
@< Vectors and convectors of mechanical interest @>
@< Basic integration functions @>
@< The main integration routine @>
@}
%-------------------------------------------------------------------------------



\section{Test examples}

\paragraph{Integrals on the standard triangle}
%-------------------------------------------------------------------------------
@O test/py/integr/test01.py
@{""" Integrals on the standard triangle """
import sys; sys.path.insert(0, 'lib/py/')
from integr import *

V = [[0,0,0],[1,0,0],[0,1,0]]
FV = [[0,1,2]]
P = (V,FV)
print II(P, 0, 0, 0)
@}
%-------------------------------------------------------------------------------


\paragraph{Integrals on the standard tetrahedron}
%-------------------------------------------------------------------------------
@O test/py/integr/test02.py
@{""" Integrals on the standard triangle """
import sys; sys.path.insert(0, 'lib/py/')
from integr import *

V = [[0.0, 0.0, 0.0], [1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]]
FV = [[1,2,3],[0,3,2],[0,1,3],[0,1,2]]
P = (V,FV)
print Volume(P)
@}
%-------------------------------------------------------------------------------


\paragraph{Integrals on the standard 3D cube}
%-------------------------------------------------------------------------------
@O test/py/integr/test03.py
@{""" Integrals on the standard 3D cube """
import sys; sys.path.insert(0, 'lib/py/')
from integr import *

V = [[0, 0, 0],
    [1, 0, 0],
    [0, 1, 0],
    [1, 1, 0],
    [0, 0, 1],
    [1, 0, 1],
    [0, 1, 1],
    [1, 1, 1]]

FV = [[1, 0, 2],
      [0, 1, 4],
      [2, 0, 4],
      [1, 2, 3],
      [1, 3, 5],
      [4, 1, 5],
      [3, 2, 6],
      [2, 4, 6],
      [5, 3, 7],
      [3, 6, 7],
      [4, 5, 6],
      [6, 5, 7]]

P = (V,FV)
print Volume(P)
print Centroid(P)
@}
%-------------------------------------------------------------------------------


\appendix
\section{Utilities}



\bibliographystyle{amsalpha}
\bibliography{integr}



\end{document}