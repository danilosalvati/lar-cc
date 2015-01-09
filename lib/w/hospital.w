\documentclass[11pt,oneside]{article}    %use"amsart"insteadof"article"forAMSLaTeXformat
\usepackage{geometry}        %Seegeometry.pdftolearnthelayoutoptions.Therearelots.
\geometry{letterpaper}        %...ora4paperora5paperor...
%\geometry{landscape}        %Activateforforrotatedpagegeometry
%\usepackage[parfill]{parskip}        %Activatetobeginparagraphswithanemptylineratherthananindent
\usepackage{graphicx}                %Usepdf,png,jpg,orepsßwithpdflatex;useepsinDVImode
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

\title{Concept and preliminary design of a hospital system
\footnote{This document is part of the \emph{Linear Algebraic Representation with CoChains} (LAR-CC) framework~\cite{cclar-proj:2013:00}. \today}
}
\author{Alberto Paoluzzi}
%\date{}                            %Activatetodisplayagivendateornodate

\begin{document}
\maketitle
\nonstopmode
\tableofcontents

\begin{abstract}
In this module we develop stepwise the concept and the preliminary building program of a hospital of medium size, using as source the document~\cite{who:2013} of the World Health Organisation.
\end{abstract}

\section{Introduction}


\section{Model planning}

\subsection{Data sources}

\subsection{Reference grid}

\paragraph{Reference grid}
%-------------------------------------------------------------------------------
@D Reference grid
@{""" Reference grid """
X = [0]+[7.5,9.5,7.5]+4*[8.4]+[7.5,9.5,7.5]+[0]
Y = [0]+14*[8.4]+[0]
xgrid = QUOTE(X[1:-1])
ygrid = QUOTE(Y[1:-1])
structuralGrid = PROD([xgrid,ygrid])
ymax = SUM(Y)
@}
%-------------------------------------------------------------------------------

\paragraph{From array indices to grid coordinates}
%-------------------------------------------------------------------------------
@D From array indices to grid coordinates
@{""" From array indices to grid coordinates """
def index2coords(theArray):
    return CONS(AA(T([1,2]))(CAT((theArray).tolist())))
@}
%-------------------------------------------------------------------------------


\subsection{Architecture of modeling process}



%===============================================================================
\section{Building units planning}
%===============================================================================

\subsection{Wire-frame input}

As already said, the data input for this project was made by hand. Of course, an
interactive user-interface in underway. I would like to notice that to enter apart the 
coordinates of the vertices of cells, as two (or three) adjacent arrays, is much 
faster and lesser in danger of getting errors than to enter an array of points.

The several building units contained in this storey are given in the below script,
each associated to a single ordered polyline, transposed on coordinates. Let us notice the used of 
a capitalised variable for storage, in order to distinguish from the corresponding \texttt{Struct}
object with the same name.

%-------------------------------------------------------------------------------
@D Storey input
@{""" Storey input """
@< Ground floor @>
@< Mezanine floor @>
@< First floor @>
@< Second floor @>
@< Third floor @>
@< Fourth floor @>
@< Fifth floor @>

""" Building unit structure """
@< Ground floor structure @>
@< Mezanine floor structure @>
@< First floor structure @>
@< Second floor structure @>
@< Third floor structure @>
@< Fourth floor structure @>
@< Fifth floor structure @>
@}
%-------------------------------------------------------------------------------


\subsubsection{Ground floor}
\paragraph{Ground floor input}

%-------------------------------------------------------------------------------
@D Ground floor 
@{""" Ground floor """
OpenCourt10 = metric(TRANS([[3,3,4,4,6,6,6.65,6.65],[4,8,8,7.8,7.8,8,8,4]]))
RadioDiagnosticImaging = metric(TRANS([[7,7,9,10,10,8.7],[4,8,8,8,4,4]]))
ServiceCore10 = metric(TRANS([[1.15, 1.15, 1.3,2.55, 2.55,2], [2.85, 3.7,3.7,3.7, 
    2.85,2.85]]))
ServiceCore20 = metric(TRANS([[7,7,8.7,8.8,8.8],[2.8,3.7,3.7,3.7,2.8]]))
EmergencyDepartment = metric(TRANS([[4.7,4.7,7,7,8.8,8.8,9.65,9.65],[0,3.7,3.7,
    2.8,2.8,3.7,3.7,0]]))
Endoscopy = metric(TRANS([[3,3,3,4.4,4.4],[0,2.5,3.7,3.7,0]]))
OutPatientDepartment10 = metric(TRANS([[4./7.5, 4./7.5,1.15,1.15,2,2,3,3],
    [0,3.7,3.7,2.85,2.85,2.5,2.5,0]]))
OutPatientDepartment20 = metric(TRANS([[0,0,2.65,2.65,1.3],[4,5.85,5.85,4,4]]))
RenalDialysis = metric(TRANS([[0,0,1,2.65,2.65],[5.85,8,8,8,5.85]]))
OpenCourt20 = metric(TRANS([[2,2,2,2,4,4,4,4],[10,11,11.35,12,12,11.35,11,10]]))
ChemiotherapyUnit = metric(TRANS([[0,0,4.5,4.5,4,4,2,2,1],
    [11.35,14,14,11.35,11.35,12,12,11.35,11.35,]]))
Service = metric(TRANS([[0,0,1,1,2,2,2,1],[8.35,10,10,9,9,8.5, 8.35,8.35]]))
PhysicalMedicineDept = metric(TRANS([[2,2,1,1,0,0, 1,2,2,4,4,4.5,4.5,4,4],
    [8.5,9,9,10,10,11,11,11,10,10,11,11,9,9,8.5]]))
MainEntrance = metric(TRANS([[4,4,4,4.5,4.75,4.75,6.65,6.65,6,6],
    [8.4,8.5,9,9,9,11,11, 9,9,8.4]]))
Unknown = metric(TRANS([[7.25,7.25, 6.65,6.65,6.65,10,10,9,8.2],
    [8.35,8.5,8.5,9,11,11,8.35,8.35,8.35]]))
#Mortuary = metric(TRANS([[],[]]))
Corridor0 = metric([[4.4,0],[4.4,3.7],[3,3.7],[3,2.5],[2,2.5],[2,2.85],[2.55,2.85],
    [2.55,3.7],[1.3,3.7],[1.3,4],[2.65,4],[2.65,5.85],[2.65,8],[1,8],[1,8.35],
    [2,8.35],[2,8.5],[4,8.5],[4,8.4],[6,8.4],[6,9],[6.65,9],[6.65,8.5],[7.25,8.5],
    [7.25,8.35],[8.2,8.35],[9,8.35],[9,8],[7,8],[7,4],[8.7,4],[8.7,3.7],
    [7,3.7],[4.7,3.7],[4.7,0]])
Corridor0a = metric(TRANS([[1, 1, 2, 2], [11, 11.35, 11.35, 11]]))
Corridor0b = metric(TRANS([[4.5, 4.5, 4, 4, 4.5, 4.5, 4.75,4.75, 4.75],
    [9, 11, 11, 11.35, 11.35, 14,14, 11, 9]]))
@}
%-------------------------------------------------------------------------------


\paragraph{Ground floor's building units}
%-------------------------------------------------------------------------------
@D Ground floor's building units 
@{""" Ground floor's building units """
openCourt10 = buildingUnit(OpenCourt10,"OpenCourt10")
radioDiagnosticImaging = buildingUnit(RadioDiagnosticImaging,"RadioDiagnosticImaging")
serviceCore10 = buildingUnit(ServiceCore10,"ServiceCore10")
serviceCore20 = buildingUnit(ServiceCore20,"ServiceCore20")
emergencyDepartment = buildingUnit(EmergencyDepartment,"EmergencyDepartment")
endoscopy = buildingUnit(Endoscopy,"Endoscopy")
outPatientDepartment10 = buildingUnit(OutPatientDepartment10,"OutPatientDepartment10")
outPatientDepartment20 = buildingUnit(OutPatientDepartment20,"OutPatientDepartment20")
renalDialysis = buildingUnit(RenalDialysis,"RenalDialysis")
openCourt20 = buildingUnit(OpenCourt20,"OpenCourt20")
chemiotherapyUnit = buildingUnit(ChemiotherapyUnit,"ChemiotherapyUnit")
service = buildingUnit(Service,"Service")
physicalMedicineDept = buildingUnit(PhysicalMedicineDept,"PhysicalMedicineDept")
mainEntrance = buildingUnit(MainEntrance,"MainEntrance")
unknown = buildingUnit(Unknown,"Unknown")
#mortuary = buildingUnit(Mortuary,"Mortuary")
corridor0 = buildingUnit(Corridor0,"Corridor0")
corridor0a = buildingUnit(Corridor0a,"Corridor0a")
corridor0b = buildingUnit(Corridor0b,"Corridor0b")
@}
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
@D Ground floor structure
@{""" Ground floor structure """

@< Ground floor's building units @>

buildingUnits0 = [openCourt10,radioDiagnosticImaging,serviceCore10,serviceCore20,
    emergencyDepartment,endoscopy,outPatientDepartment10,outPatientDepartment20,
    renalDialysis,openCourt20,chemiotherapyUnit,service,physicalMedicineDept,
    mainEntrance,unknown,corridor0,corridor0a,corridor0b]
    
groundFloor = Struct(buildingUnits0, "groundFloor")
@}
%-------------------------------------------------------------------------------

\subsubsection{Mezanine floor}
\paragraph{Mezanine floor input}

%-------------------------------------------------------------------------------
@D Mezanine floor
@{""" Mezanine floor """
MedicalWaste = metric(TRANS([[4./7.5,4./7.5,.8,1.25,1.25],[0,1.5,1.5,1.5,0]]))
CentralStores = metric(TRANS([[1.25,1.25,.8,.8,3.7,3.7,2.55,2.55,2.2,2.2],[0,1.5,1.5,
    2.65,2.65,.35,.35,.65,.65,0]]))
StaffDining = metric(TRANS([[3.95,3.95,6.7,6.7,6.95,6.95],[0,3.7,3.7,2,2,0]]))
CSSD = metric(TRANS([[6.95,6.95,6.95,8.8,8.8,9.65,9.65],[0,2,2.65,2.65,2,2,0]]))
HouseKeeping = metric(TRANS([[8.8,8.8,8.8,8.8,9.65,9.65],[2,2.65,2.8,3.7,3.7,2]]))
CentralStaffChanging11 = metric(TRANS([[4./7.5,4./7.5,1.15,1.15],[2.85,3.7,3.7,2.85]]))
CentralStaffChanging21 = metric(TRANS([[2.55,2.55,3.7,3.7],[2.85,3.7,3.7,2.85]]))
OpenCourt11 = metric(TRANS([[3,3,7,7,7],[4,8,8,6,4]]))
Pharmacy = metric(TRANS([[0,0,2.65,2.65,1.3],[4,6.45,6.45,4,4]]))
CentralWorkshop = metric(TRANS([[0,0,1,2.65,2.65],[6.45,8,8,8,6.45]]))
Laundry = metric(TRANS([[7,7,10,10,8.7],[4,6,6,4,4]]))
AdministrationSuite11 = metric(TRANS([[7,7,9,10,10],[6,8,8,8,6]]))
MainLaboratories = metric(TRANS([[1,1,0,0,2,2,5,5,4,4,4],[8.3,8.4,8.4,11,11,10,10,9,
    9,8.4,8.3]]))
MedicalLibrary = metric(TRANS([[6.7,6.7,8,8,7.75],[9.7,11,11,9.7,9.7]]))
MedicalRecords = metric(TRANS([[8,8,8,8.85,8.85,8.85],[8.3,9.7,11,11,9.75,8.3]]))
AdministrationSuite21 = metric(TRANS([[8.85,8.85,10,10,9,9],[8.3,9.75,9.75,8.4,8.4,8.3]]))
MeetingRooms = metric(TRANS([[6,6,6,6.7,6.7,7.75,7.75,7.45,7,7],[8.3,8.4,9,9,9.7,9.7,
    8.7,8.7,8.7,8.3]]))
DataCenter = metric(TRANS([[7,7,7.45,7.45],[8.3,8.7,8.7,8.3]]))
ServerRoom = metric(TRANS([[7.45,7.45,7.75,7.75],[8.3,8.7,8.7,8.3]]))
PublicCore = metric(TRANS([[4,4,5,6,6],[8.4,9,9,9,8.4]]))
ServiceCore11 = metric(TRANS([[1.15,1.15,1.3,2.55,2.55],[2.85,3.7,3.7,3.7,2.85]]))
ServiceCore21 = metric(TRANS([[7,7,8.7,8.8,8.8],[2.8,3.7,3.7,3.7,2.8]]))
Corridor1 = metric([[2.2,0],[2.2,0.65],[2.55,0.65],[2.55,0.35],[3.7,0.35],[3.7,2.65],
    [0.8,2.65],[0.8,1.5],[0.5333,1.5],[0.5333,2.85],[1.15,2.85],[2.55,2.85],[3.7,
    2.85],[3.7,3.7],[2.55,3.7],[1.3,3.7],[1.3,4],[2.65,4],[2.65,6.45],[2.65,
    8],[1,8],[1,8.3],[4,8.3],[4,8.4],[6,8.4],[6,8.3],[7,8.3],[7.45,8.3],
    [7.75,8.3],[7.75,8.7],[7.75,9.7],[8,9.7],[8,8.3],[8.85,8.3],[9,8.3],[9,8],
    [7,8],[3,8],[3,4],[7,4],[8.7,4],[8.7,3.7],[7,3.7],[7,2.8],[8.8,2.8],
    [8.8,2.65],[6.95,2.65],[6.95,2],[6.7,2],[6.7,3.7],[3.95,3.7],[3.95,0]])
GroundRoof = metric(TRANS([[4,4,2,2,1,1,0,0,4.75,4.75],[10,12,12,11,11,11.35,11.35,14,
    14,10]]))
@}
%-------------------------------------------------------------------------------

\paragraph{Mezanine floor's building units}
%-------------------------------------------------------------------------------
@D Mezanine floor's building units 
@{""" Mezanine floor's building units """
medicalWaste = buildingUnit(MedicalWaste,"MedicalWaste")
centralStores = buildingUnit(CentralStores,"CentralStores")
staffDining = buildingUnit(StaffDining,"StaffDining")
cSSD = buildingUnit(CSSD,"CSSD")
houseKeeping = buildingUnit(HouseKeeping,"HouseKeeping")
centralStaffChanging11 = buildingUnit(CentralStaffChanging11,"CentralStaffChanging1")
centralStaffChanging21 = buildingUnit(CentralStaffChanging21,"CentralStaffChanging2")
pharmacy = buildingUnit(Pharmacy,"Pharmacy")
centralWorkshop = buildingUnit(CentralWorkshop,"CentralWorkshop")
laundry = buildingUnit(Laundry,"Laundry")
administrationSuite11 = buildingUnit(AdministrationSuite11,"AdministrationSuite11")
mainLaboratories = buildingUnit(MainLaboratories,"MainLaboratories")
medicalLibrary = buildingUnit(MedicalLibrary,"MedicalLibrary")
medicalRecords = buildingUnit(MedicalRecords,"MedicalRecords")
administrationSuite21 = buildingUnit(AdministrationSuite21,"AdministrationSuite21")
meetingRooms = buildingUnit(MeetingRooms,"MeetingRooms")
dataCenter = buildingUnit(DataCenter,"DataCenter")
serverRoom = buildingUnit(ServerRoom,"ServerRoom")
publicCore = buildingUnit(PublicCore,"PublicCore")
serviceCore11 = buildingUnit(ServiceCore11,"ServiceCore11")
serviceCore21 = buildingUnit(ServiceCore21,"ServiceCore21")
corridor1 = buildingUnit(Corridor1,"Corridor1")
groundRoof = buildingUnit(GroundRoof,"GroundRoof")
@}
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
@D Mezanine floor structure
@{""" Mezanine floor structure """

@< Mezanine floor's building units @>

buildingUnits1 = [medicalWaste, centralStores, staffDining, cSSD, houseKeeping, 
    centralStaffChanging11, centralStaffChanging21, pharmacy, centralWorkshop, laundry, 
    administrationSuite11, mainLaboratories, medicalLibrary, medicalRecords, 
    administrationSuite21, meetingRooms, dataCenter, serverRoom, publicCore, 
    serviceCore11, serviceCore21, corridor1, groundRoof]
    
mezanineFloor = Struct(buildingUnits1, "mezanineFloor")
@}
%-------------------------------------------------------------------------------


\subsubsection{First floor}
\paragraph{First floor}
%-------------------------------------------------------------------------------
@D First floor
@{""" First floor """
OpenCourt3 = metric(TRANS([[3.,3.,7.,7.],[4.,8.,8.,4.]]))
Surgery = metric(TRANS([[4.15,4.15,7.,7.,8.8,8.8,9.65,9.65],[0,3.7,3.7, 2.8,2.8, 3.7,3.7,0]]))
CatheterizationLab = metric(TRANS([[3,3,4.15,4.15],[0,3.7,3.7,0]]))
ServiceCore32 = metric(TRANS([[7.,7.,8.7,8.8,8.8],[2.8,3.7,3.7,3.7,2.8]]))
CoronaryCareUnit = metric(TRANS([[7.,7.,8.3,9.,10.,10.,8.7],[4.,8.,8.,8.,8.,4.,4.]]))
DeliveryAndNicu = metric(TRANS([[0,0, 1.7,2.65,2.65,1.3],[4.,8.,8.,8.,4.,4.]]))
ServiceCore31 = metric(TRANS([[1.15, 1.15, 1.3,2.65, 2.65], [2.85, 3.7,3.7, 3.7, 2.85]]))
IntensiveCareUnit = metric(TRANS([[4./7.5, 4./7.5,1.15,1.15,2.65, 2.65,1.95,1.95],
    [0.,3.7,3.7,2.85,2.85,.6,.6,0.]]))
ServiceCore33 = metric(TRANS([[1.95,1.95,2.65, 2.65],[0,.6,.6,0]]))
PublicCore3 = metric(TRANS([[1.7,1.7,4.,4.,6.,6.,8.3,8.3,7,3,2.65],
    [8,8.4,8.4,9,9,8.4,8.4,8,8,8,8]]))
Corridor3 = metric(TRANS([[2.65,2.65,2.65,2.65,1.3,1.3,2.65,2.65,3.0,3.0,7.0,8.7,8.7,
    7.0,4.15,3.0,3.0],[0.0,0.6,2.85,3.7,3.7,4.0,4.0,8.0,8.0,4.0,4.0,4.0,3.7,
    3.7,3.7,3.7,0.0]]))
MezanineRoof = metric(TRANS([[1,1,0,0,2,2,4.75,4.75,10,10,9,9,8.3,8.3, 6,6,4,4 ,1.7,1.7],
    [8,8.4,8.4,11,11,10,10,11,11,8.4,8.4,8,8,8.4,8.4,9,9,8.4,8.4,8]]))
@}
%-------------------------------------------------------------------------------

\paragraph{First floor's building units}
%-------------------------------------------------------------------------------
@D First floor's building units 
@{""" First floor's building units """
openCourt3 = buildingUnit(OpenCourt3,"OpenCourt3")
surgery = buildingUnit(Surgery,"Surgery")
catheterizationLab = buildingUnit(CatheterizationLab,"CatheterizationLab")
serviceCore32 = buildingUnit(ServiceCore32,"ServiceCore32")
coronaryCareUnit = buildingUnit(CoronaryCareUnit,"CoronaryCareUnit")
deliveryAndNicu = buildingUnit(DeliveryAndNicu,"DeliveryAndNicu")
serviceCore31 = buildingUnit(ServiceCore31,"ServiceCore31")
intensiveCareUnit = buildingUnit(IntensiveCareUnit,"IntensiveCareUnit")
serviceCore33 = buildingUnit(ServiceCore33,"ServiceCore33")
publicCore3 = buildingUnit(PublicCore3,"PublicCore3")
corridor3 = buildingUnit(Corridor3,"Corridor3")
mezanineRoof = buildingUnit(MezanineRoof,"MezanineRoof")
@}
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
@D First floor structure
@{""" First floor structure """

@< First floor's building units @>

buildingUnits2 = [surgery,catheterizationLab,serviceCore32,coronaryCareUnit,
    deliveryAndNicu,serviceCore31,intensiveCareUnit,serviceCore33,publicCore3,
    corridor3,mezanineRoof]
    
firstFloor = Struct(buildingUnits2, "firstFloor")
@}
%-------------------------------------------------------------------------------


\subsubsection{Ward sections}
\paragraph{Ward sections}
Here input by polylines and structure modeling are freely mixed. Just notice that
the affine maps included in structures are given in grid coordinates. This fact 
does not permit an immediate transformation in Cartesian coordinates using the \texttt{metric}
function.
%-------------------------------------------------------------------------------
@D Ward sections
@{""" Ward sections """
room = TRANS([[0,0,1,1,2./3,2./3],[0,0.5,0.5,0.25,0.25,0]])
restRoom = TRANS([[2./3,2./3,1,1],[0,0.25,0.25,0]])
nursing1 = TRANS([[0,0,.2,.2],[0,.4,.4,.0]])
nursing2 = TRANS([[.2,.2,.4,.4],[0,.4,.4,.0]])
nursing3 = TRANS([[0,0,.4,.4],[.4,.8,.8,.4]])
nursing4 = TRANS([[0,0,.4,.4],[.8,1.1,1.1,.8]])
nursing5 = TRANS([[0,0,.4,.4],[1.1,1.4,1.4,1.1]])

service2 = Struct([polyline2lar([nursing1,nursing2,nursing3,nursing4,nursing5])])
service1 = Struct([t(0,1.4),s(1,-1),service2])
wardServices = Struct([t(1.3,.3),service1,t(0,2),service2])
HospitalRoom = Struct([polyline2lar([room,restRoom])],"Room")
DounbleRoom =  Struct([HospitalRoom,t(0,1),s(1,-1),HospitalRoom])
HalfWard = Struct(4*[DounbleRoom,t(0,1)])
Ward = Struct([HalfWard, wardServices, t(3,0),s(-1,1), HalfWard])
V,FV,EV = struct2lar(Ward)
theWard = lar2lines((V,FV))
@}
%-------------------------------------------------------------------------------


\subsubsection{Second floor}
\paragraph{Second floor}
%-------------------------------------------------------------------------------
@D Second floor
@{
@< Ward sections @>

""" Second floor """
PublicCore4 = metric(TRANS([[1.7,1.7,4,4,6,6,8.3,8.3, 8,7+2./3, 7, 3, 2+1./3,2],
    [8,8.4,8.4,9,9,8.4,8.4,8,8,8,8,8,8,8]]))
ObstetricGinecologicWard = AA(metric)((AA(larTranslate([0,4]))(theWard)))
SurgicalWard1 = AA(metric)((AA(larTranslate([7,4]))(theWard)))
Filter1 = metric(TRANS([[1,1,1.35,1.35,1.15],[3.7,4,4,3.7,3.7]]))
Filter2 = metric(TRANS([[8.65,8.65,9,9,8.8],[3.7,4,4,3.7,3.7]]))
ServiceCore14 = metric(TRANS([[1.15, 1.15, 1.35,2.55, 2.55], [2.8, 3.7,3.7, 3.7, 2.8]]))
ServiceCore24 = metric(TRANS([[7,7,8.65,8.8,8.8],[2.8,3.7,3.7,3.7,2.8]]))
FirstRoof = metric(TRANS([[4./7.5, 4./7.5,1.15,1.15,2.55,2.55,7,7,8.8,8.8,9.65,9.65],
    [0,3.7,3.7,2.8,2.8,3.7,3.7,2.8,2.8,3.7,3.7,0]]))
Corridor4a = metric([[1.35,3.7],[1.35,4],[2,4],[2.3333,4],[3,4],[7,4],[7.6667,4],[8,4],
    [8.65,4],[8.65,3.7],[7,3.7],[2.55,3.7]])
Corridor4b = metric([[1,4.0],[1,4.25],[1,4.5],[1,4.75],[1,5.0],[1,5.25],[1,5.5],
    [1,5.75],[1,6.0],[1,6.25],[1,6.5],[1,6.75],[1,7.0],[1,7.25],[1,7.5],
    [1,7.75],[1,8.0],[2,8.0],[2,7.75],[2,7.5],[2,7.25],[2,7.0],[2,6.75],
    [2,6.5],[2,6.25],[2,6.0],[2,5.75],[2,5.5],[2,5.25],[2,5.0],[2,4.75],
    [2,4.5],[2,4.25],[2,4.0],[1.35,4.0]])
Corridor4b1 = metric([[1.3,4.3],[1.3,4.6],[1.3,4.9],[1.3,5.3],[1.3,5.7],[1.5,5.7],[1.7,5.7],
    [1.7,5.3],[1.7,4.9],[1.7,4.6],[1.7,4.3]])
Corridor4b2 = metric([[1.3,6.3],[1.3,6.7],[1.3,7.1],[1.3,7.4],[1.3,7.7],[1.7,7.7],[1.7,7.4],
    [1.7,7.1],[1.7,6.7],[1.7,6.3],[1.5,6.3]])
Corridor4c = metric([[8,4.0],[8,4.25],[8,4.5],[8,4.75],[8,5.0],[8,5.25],[8,5.5],
    [8,5.75],[8,6.0],[8,6.25],[8,6.5],[8,6.75],[8,7.0],[8,7.25],[8,7.5],
    [8,7.75],[8,8.0],[8.3,8.0],[9,8.0],[9,7.75],[9,7.5],[9,7.25],[9,7.0],
    [9,6.75],[9,6.5],[9,6.25],[9,6.0],[9,5.75],[9,5.5],[9,5.25],[9,5.0],
    [9,4.75],[9,4.5],[9,4.25],[9,4.0],[8.65,4.0]])
Corridor4c1 = metric([[8.3,4.3],[8.3,4.6],[8.3,4.9],[8.3,5.3],[8.3,5.7],[8.5,5.7],[8.7,5.7],
    [8.7,5.3],[8.7,4.9],[8.7,4.6],[8.7,4.3]])
Corridor4c2 = metric([[8.3,6.3],[8.3,6.7],[8.3,7.1],[8.3,7.4],[8.3,7.7],[8.7,7.7],[8.7,7.4],
    [8.7,7.1],[8.7,6.7],[8.7,6.3],[8.5,6.3]])
@}
%-------------------------------------------------------------------------------

\paragraph{Second floor's building units}
%-------------------------------------------------------------------------------
@D Second floor's building units 
@{""" Second floor's building units """
publicCore4 = buildingUnit(PublicCore4,'PublicCore4')
obstetricGinecologicWard = buildingUnit(ObstetricGinecologicWard,'ObstetricGinecologicWard')
surgicalWard1 = buildingUnit(SurgicalWard1,'SurgicalWard1')
filter1 = buildingUnit(Filter1,'Filter1')
filter2 = buildingUnit(Filter2,'Filter2')
serviceCore14 = buildingUnit(ServiceCore14,'ServiceCore14')
serviceCore24 = buildingUnit(ServiceCore24,'ServiceCore24')
firstRoof = buildingUnit(FirstRoof,'FirstRoof')
serviceCore11 = buildingUnit(ServiceCore11,'ServiceCore11')
serviceCore21 = buildingUnit(ServiceCore21,'ServiceCore21')
corridor4a = buildingUnit(Corridor4a,'Corridor4a')
corridor4b = buildingUnit(Corridor4b,'Corridor4b')
corridor4b1 = buildingUnit(Corridor4b1,'Corridor4b1')
corridor4b2 = buildingUnit(Corridor4b2,'Corridor4b2')
corridor4c = buildingUnit(Corridor4c,'Corridor4c')
corridor4c1 = buildingUnit(Corridor4c1,'Corridor4c1')
corridor4c2 = buildingUnit(Corridor4c2,'Corridor4c2')
@}
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
@D Second floor structure
@{""" Second floor structure """

@< Second floor's building units @>

buildingUnits3 = [publicCore4,obstetricGinecologicWard,surgicalWard1,filter1,filter2,
serviceCore14,serviceCore24,firstRoof,corridor4a,
corridor4b,corridor4b1,corridor4b2,corridor4c,corridor4c1,corridor4c2]
    
secondFloor = Struct(buildingUnits3, "secondFloor")
@}
%-------------------------------------------------------------------------------



\subsubsection{Third floor}
\paragraph{Third floor}
%-------------------------------------------------------------------------------
@D Third floor
@{""" Third floor floor """
GeneralWard1 = AA(metric)(AA(larTranslate([0,4]))(theWard))
SurgicalWard2 = AA(metric)(AA(larTranslate([7,4]))(theWard))
@}
%-------------------------------------------------------------------------------


\paragraph{Third floor's building units}
%-------------------------------------------------------------------------------
@D Third floor's building units 
@{""" Third floor's building units """
generalWard1 = buildingUnit(GeneralWard1,'GeneralWard1')
surgicalWard2 = buildingUnit(SurgicalWard2,'SurgicalWard2')
@}
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
@D Third floor structure
@{""" Third floor structure """

@< Third floor's building units @>

buildingUnits4 = [generalWard1,surgicalWard2,publicCore4,serviceCore14,serviceCore24,
                filter1,filter2,corridor4a,corridor4b,corridor4b1,corridor4b2,corridor4c,
                corridor4c1,corridor4c2]

thirdFloor = Struct(buildingUnits4, "thirdFloor")
@}
%-------------------------------------------------------------------------------


\subsubsection{Fourth floor}
\paragraph{Fourth floor}
%-------------------------------------------------------------------------------
@D Fourth floor
@{""" Fourth floor floor """
PediatricWard1 = AA(metric)(AA(larTranslate([0,4]))(theWard))
PediatricWard2 = AA(metric)(AA(larTranslate([7,4]))(theWard))
@}
%-------------------------------------------------------------------------------

\paragraph{Fourth floor's building units}
%-------------------------------------------------------------------------------
@D Fourth floor's building units 
@{""" Fourth floor's building units """
pediatricWard1 = buildingUnit(PediatricWard1,'PediatricWard1')
pediatricWard2 = buildingUnit(PediatricWard2,'PediatricWard2')
@}
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
@D Fourth floor structure
@{""" Fourth floor structure """

@< Fourth floor's building units @>

buildingUnits5 = [pediatricWard1,pediatricWard2,publicCore4,serviceCore14,serviceCore24,
                filter1,filter2,corridor4a,corridor4b,corridor4b1,corridor4b2,corridor4c,
                corridor4c1,corridor4c2]

fourthFloor = Struct(buildingUnits5, "fourthFloor")
@}
%-------------------------------------------------------------------------------


\subsubsection{Fifth floor}
\paragraph{Fifth floor}
%-------------------------------------------------------------------------------
@D Fifth floor
@{""" Fifth floor floor """
GeneralWard2 = AA(metric)(AA(larTranslate([0,4]))(theWard))
GeneralWard3 = AA(metric)(AA(larTranslate([7,4]))(theWard))
@}
%-------------------------------------------------------------------------------


\paragraph{Fifth floor's building units}
%-------------------------------------------------------------------------------
@D Fifth floor's building units 
@{""" Fifth floor's building units """
generalWard2 = buildingUnit(GeneralWard2,'GeneralWard2')
generalWard3 = buildingUnit(GeneralWard3,'GeneralWard3')
@}
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
@D Fifth floor structure
@{""" Fifth floor structure """

@< Fifth floor's building units @>

buildingUnits6 = [generalWard2,generalWard3,publicCore4,serviceCore14,serviceCore24,
                filter1,filter2,corridor4a,corridor4b,corridor4b1,corridor4b2,corridor4c,
                corridor4c1,corridor4c2]

fifthFloor = Struct(buildingUnits6, "fifthFloor")
@}
%-------------------------------------------------------------------------------



\subsection{Preliminary 2.5D mock-up}

\subsubsection{Building structure}

\paragraph{Column locations on grid}
%-------------------------------------------------------------------------------
@D Column locations on grid 
@{""" Column locations on grid """
SecondPillars = [((4,5),(1,10)),((3,4),(1,4)),((3,4),(7,10)),((4,8),(0,4)),((4,8),(7,11)),((8,9),(0,11)),((9,10),(4,7))]
FirstPillars = [((0,5),(1,10)),((4,8),(0,4)),((4,8),(7,11)),((8,9),(0,11)),((9,10),(4,7))]
FrontPillars = [((8,10),(0,11)),((10,11),(0,6)),((10,11),(7,11)),((11,12),(0,3)),((11,12),(4,11))]
MezaninePillars = FirstPillars + FrontPillars
BottomPillars = [((12,15),(0,5))]
@}
%-------------------------------------------------------------------------------

\paragraph{Generation of beams and structural chains}
%-------------------------------------------------------------------------------
@D Generation of beams and structural chains 
@{""" Generation of beams and structural chains """
def ManhattanTest(nodes,nDict,i,j):
	hi,ki = nodes[i]
	hj,kj = nodes[j]
	return nDict.setdefault((hi,kj),-1)!=-1 and nDict.setdefault((hj,ki),-1)!=-1

def structureGrid(loci):
    nodes = AA(tuple)(CAT([CART([range(*I), range(*J)]) for (I,J) in loci]))
    nDict = dict([(node,k) for k,node in enumerate(nodes)])
    arcs = CAT([[(nDict[(i,j)], nDict.setdefault((i,j+1),-1)),
             (nDict[(i,j)], nDict.setdefault((i,j-1),-1)),
             (nDict[(i,j)], nDict.setdefault((i+1,j),-1)),
             (nDict[(i,j)], nDict.setdefault((i-1,j),-1))] for (i,j) in nodes])
    arcs1 = list(set(AA(tuple)([sorted(arc) for arc in arcs if arc[1]!=-1])))
    arcs = CAT([[(nDict[(i,j)], nDict.setdefault((i+1,j+1),-1)),
             (nDict[(i,j)], nDict.setdefault((i+1,j-1),-1)),
             (nDict[(i,j)], nDict.setdefault((i-1,j-1),-1)),
             (nDict[(i,j)], nDict.setdefault((i-1,j+1),-1))] for (i,j) in nodes])
    arcs2 = list(set(AA(tuple)([sorted(arc) for arc in arcs if arc[1]!=-1])))
    arcs2 = [[i,j] for i,j in arcs2 if ManhattanTest(nodes,nDict,i,j)]
    nodes = metric([[j,i] for i,j in nodes])
    return nodes, arcs1,arcs2
@}
%-------------------------------------------------------------------------------
    
\paragraph{Instancing of 3D structure frame}
%-------------------------------------------------------------------------------
@D Instancing of 3D structure frame 
@{""" Instancing of 3D structure frame """
nodes0, arcs10,arcs20 = structureGrid(MezaninePillars+BottomPillars)
nodes1, arcs11,arcs21 = structureGrid(MezaninePillars)
nodes2, arcs12,arcs22 = structureGrid(FirstPillars)
nodes3, arcs13,arcs23 = structureGrid(SecondPillars)
nodes4, arcs14,arcs24 = structureGrid(SecondPillars)
nodes5, arcs15,arcs25 = structureGrid(SecondPillars)
nodes6, arcs16,arcs26 = structureGrid(SecondPillars)
VIEW(STRUCT(MKPOLS((nodes0, arcs10+arcs20)) ))
@}
%-------------------------------------------------------------------------------


\paragraph{Assembling 3D structure frame}
%-------------------------------------------------------------------------------
@D Assembling 3D structure frame 
@{""" Assembling 3D structure frame """
Nodes0 = AA(lambda v: list(v)+[4-.3])(nodes0)
Nodes1 = AA(lambda v: list(v)+[8-.3])(nodes1)
Nodes2 = AA(lambda v: list(v)+[12-.3])(nodes2)
Nodes3 = AA(lambda v: list(v)+[16-.3])(nodes3)
Nodes4 = AA(lambda v: list(v)+[20-.3])(nodes4)
Nodes5 = AA(lambda v: list(v)+[24-.3])(nodes5)
Nodes6 = AA(lambda v: list(v)+[28-.3])(nodes6)

Frame0 = STRUCT(MKPOLS((Nodes0, arcs10))+MKPOLS((Nodes1, arcs11))+
	MKPOLS((Nodes2, arcs12))+MKPOLS((Nodes3, arcs13))+
	MKPOLS((Nodes4, arcs14))+MKPOLS((Nodes5, arcs15))+
	MKPOLS((Nodes6, arcs16)) + \
	CONS(AA(T([1,2,3]))(Nodes0+Nodes1+Nodes2+Nodes3+Nodes4+Nodes5+Nodes6))(
	POLYLINE([[0,0,0],[0,0,-4]])  ))

Frame1 = STRUCT(MKPOLS((Nodes0, arcs20))+MKPOLS((Nodes1, arcs21))+
	MKPOLS((Nodes2, arcs22))+MKPOLS((Nodes3, arcs23))+
	MKPOLS((Nodes4, arcs24))+MKPOLS((Nodes5, arcs25))+
	MKPOLS((Nodes6, arcs26)) )
SteelFrame = OFFSET([.2,.2,.3])(STRUCT([Frame0,Frame1]))
"""
ConcreteFrame = OFFSET([.4,.4,.8])(Frame0)
"""
VIEW(Frame0)
VIEW(STRUCT([Frame0,Frame1]))
@}
%-------------------------------------------------------------------------------


\paragraph{2.5D building assembly}
%-------------------------------------------------------------------------------
@D 2.5D building assembly
@{""" 2.5D building assembly """
def embedBuildingUnitsIn3D(floors):
    for floor in floors:
        for buildingUnit in floor.body:
            buildingUnit = larEmbed(1)(buildingUnit)
    return floors
        
floors = [groundFloor,mezanineFloor,firstFloor,
                secondFloor,thirdFloor,fourthFloor,fifthFloor]
floors3D = AA(COMP([Struct,AA(larEmbed(1)),evalStruct]))(floors)
building = evalStruct(Struct(CAT(DISTR([floors3D,t(0,0,4)]))))
storeys = STRUCT(CAT(DISTR([[ground,mezanine,first,second,third,fourth,fifth],T(3)(4)])))

VIEW(STRUCT([storeys,SteelFrame] + CAT(AA(MKPOLS)(AA(CONS([S1,S3]))(building))) ))
@}
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
@D test
@{""" 2.5D building assembly """
floors = Struct([groundFloor,mezanineFloor,firstFloor,
                secondFloor,thirdFloor,fourthFloor,fifthFloor,fifthFloor],"building")

floors3D = embedStruct(1)(floors)
building = Struct(CAT(DISTR([floors3D.body,t(0,0,4)])))
models = AA(CONS([S1,S3]))(building)
VIEW(STRUCT(CAT(AA(MKPOLS)(models))))
@}
%-------------------------------------------------------------------------------



\subsubsection{Storey viewing}

\paragraph{Storey viewing}
%-------------------------------------------------------------------------------
@D Storey generation
@{""" Storey generation """
def structDraw(color,scaling):
    def structDraw0(obj): return obj.draw(color,scaling)
    return structDraw0

ground,W,EV = floor(X,Y)(groundFloor)
ground2D = STRUCT([ground, COLOR(RED)(STRUCT(MKPOLS((W,EV))))] + \
            AA(structDraw(RED,10))(buildingUnits0))
mezanine,W,EV = floor(X,Y)(mezanineFloor)
mezanine2D = STRUCT([mezanine, COLOR(RED)(STRUCT(MKPOLS((W,EV))))] + \
            AA(structDraw(RED,10))(buildingUnits1))
first,W,EV = floor(X,Y)(firstFloor)
first2D = STRUCT([first, COLOR(RED)(STRUCT(MKPOLS((W,EV))))] + \
            AA(structDraw(RED,10))(buildingUnits2))
second,W,EV = floor(X,Y)(secondFloor)
second2D = STRUCT([second, COLOR(RED)(STRUCT(MKPOLS((W,EV))))] + \
            AA(structDraw(RED,10))(buildingUnits3))
third,W,EV = floor(X,Y)(thirdFloor)
third2D = STRUCT([third, COLOR(RED)(STRUCT(MKPOLS((W,EV))))] + \
            AA(structDraw(RED,10))(buildingUnits4))
fourth,W,EV = floor(X,Y)(fourthFloor)
fourth2D = STRUCT([fourth, COLOR(RED)(STRUCT(MKPOLS((W,EV))))] + \
            AA(structDraw(RED,10))(buildingUnits5))
fifth,W,EV = floor(X,Y)(fifthFloor)
fifth2D = STRUCT([fifth, COLOR(RED)(STRUCT(MKPOLS((W,EV))))] + \
            AA(structDraw(RED,10))(buildingUnits6))
@}
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
@D Storey viewing
@{""" Storey viewing """
VIEW(ground2D)
VIEW(mezanine2D)
VIEW(first2D)
VIEW(second2D)
VIEW(third2D)
VIEW(fourth2D)
VIEW(fifth2D)
@}
%-------------------------------------------------------------------------------


\paragraph{aaaa}
%-------------------------------------------------------------------------------
@D aaaa
@{""" aaaa """

@}
%-------------------------------------------------------------------------------

\subsection{Structural frame}

Complex of columns, and beams, girders, spandrels, and trusses connected to one another and to the columns anchored in a foundation, as well as other components or members necessary for the stability of a structure. Floors and roof panels, not connected to the columns (and called secondary members) are not considered part of the structural frame.

\paragraph{aaaa}
%-------------------------------------------------------------------------------
@D aaaa
@{""" aaaa """

@}
%-------------------------------------------------------------------------------

\subsection{Vertical communications}


\paragraph{aaaa}
%-------------------------------------------------------------------------------
@D aaaa
@{""" aaaa """

@}
%-------------------------------------------------------------------------------

\subsection{Design review}


%===============================================================================
\section{System semantics}
%===============================================================================

\subsection{Topological requirements}

\subsection{Geometrical requirements}


%===============================================================================
\section{Code exporting}
%===============================================================================

\paragraph{The \texttt{Hospital.py} module}
%-------------------------------------------------------------------------------
@O lib/py/hospital.py
@{""" The 'Hospital' module """

from pyplasm import *

""" import modules from larcc/lib """
sys.path.insert(0, 'lib/py/')
from architectural import *
from iot3d import *
DEBUG = True

@< Reference grid @>
@< Coding utilities @>
@< From array indices to grid coordinates @>
@< Storey input @>
@< Storey generation @>
@< Storey viewing @>
@< Column locations on grid @>
@< Generation of beams and structural chains @>
@< Instancing of 3D structure frame @>
@< Assembling 3D structure frame @>
@< 2.5D building assembly @>
@}
%-------------------------------------------------------------------------------


%===============================================================================
\appendix
\section{Code utilities}
%===============================================================================

\paragraph{Coding utilities}
%-------------------------------------------------------------------------------
@D Coding utilities
@{""" Coding utilities """
@< From grid to metric coordinates @>
@< Mapping a grid frame to a Cartesian one @>
@< Solidify the boundary of polyline-like building units @>
@< Make a struct object from a 2D polyline @>
@}
%-------------------------------------------------------------------------------

\paragraph{From grid to metric coordinates}
%-------------------------------------------------------------------------------
@D From grid to metric coordinates
@{""" From grid to metric coordinates """
def grid2coords(X,Y):
    xMeasures = list(cumsum(X))
    yMeasures = list(cumsum(Y))
    def grid2coords0(point):
        x,y = point[0:2]
        xint,yint = int(x), int(y)
        xdec,ydec = float(x-xint), float(y-yint)
        xcoord = xMeasures[xint] + xdec*X[xint+1]
        ycoord = yMeasures[yint] + ydec*Y[yint+1]
        if len(point)==2: return [xcoord, ycoord]
        else: return [xcoord, ycoord, point[2]]
    return grid2coords0

def coordMaps(ymax):
    def coordMaps0(polyline):
        polyline = AA(grid2coords(X,Y))(polyline)
        polyline = vmap(ymax)(polyline)
        return [eval(vcode(point)) for point in polyline]
    return coordMaps0

metric = coordMaps(ymax)
@}
%-------------------------------------------------------------------------------
\paragraph{Mapping the grid frame to a Cartesian right-hand frame}
%-------------------------------------------------------------------------------
@D Mapping a grid frame to a Cartesian one
@{""" Mapping the grid frame to a Cartesian right-hand frame """
def vmap(ymax):
    def vmap0(V):
        if len(V[0])==3: W = [[x,ymax-y,z] for x,y,z in V]
        else: W = [[x,ymax-y] for x,y in V]
        return W
    return vmap0
                
def embed(z):
    def embed0(p): 
        return p+[z]
    return embed0
@}
%-------------------------------------------------------------------------------

\paragraph{Solidify the boundary of polyline-like building units}
%-------------------------------------------------------------------------------
@D Solidify the boundary of polyline-like building units
@{""" Solidify the boundary of polyline-like building units """
def floor(X,Y):
    def floor0(structure2D):
        V,FV,EV = struct2lar(structure2D)
        BE = [EV[e] for e in boundaryCells(FV,EV)]
        theFloor = SOLIDIFY(STRUCT([POLYLINE([V[v],V[w]]) for v,w in BE]))
        return theFloor,V,EV
    return floor0
@}
%-------------------------------------------------------------------------------

\paragraph{Make a struct object from a 2D polyline}
%-------------------------------------------------------------------------------
@D Make a struct object from a 2D polyline
@{""" Make a struct object from a 2D polyline """
isPolyline = ISSEQOF(ISSEQOF(ISNUM))
isPolylineSet = ISSEQOF(ISSEQOF(ISSEQOF(ISNUM)))

def buildingUnit(polyline,string):
    if ISSEQOF(ISSEQOF(ISNUM))(polyline): model = polyline2lar([polyline])
    else: model = polyline2lar(polyline)
    return Struct([model],str(string))
@}
%-------------------------------------------------------------------------------

\paragraph{Extract 1-cells from the lar of a polylineSet}
%-------------------------------------------------------------------------------
@D Make a struct object from a 2D polyline
@{""" Make a struct object from a 2D polyline """
def lineSet(polylineSet):
    EV = []
    for polyline in polylineSet:
        EV += [(v,w) if v<w else (w,v) for v,w in zip(polyline,polyline[1:]+[polyline[0]])]
    return AA(list)(EV)
@}
%-------------------------------------------------------------------------------
    

\paragraph{The 2.5D mock-up}
%-------------------------------------------------------------------------------
@O test/py/hospital/mock-up.py
@{""" The 2.5D mock-up of an hospital building """

@}
%-------------------------------------------------------------------------------


\bibliographystyle{amsalpha}
\bibliography{hospital}

\end{document}