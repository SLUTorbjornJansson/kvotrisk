PARAMETERS
    MC      Marginalkostnad (kronor per kg) /50/
    Pin     Pris inom kvot (kronor per kg) /100/
    Pout    Pris utom kvot (kronor per kg) /10/
    sdev    Standardavvikelse av f�ngst (ton) /5/
    s       Parameter i f�rdelningsfunktionen
    C       Integrationskonstant i f�rdelningsfunktionen
    kvot    Fiskekvot (ton) /100/
    ;

VARIABLES
    v_catch Planerad f�ngst
    v_rev   Int�kter
    v_cost  Kostnader
    v_qcost F�rv�ntad kostnad f�r kvot�verskridande
    v_profit    F�rv�ntad vinst

*   Extra variabler f�r analys av resultaten
    v_mc    Marginalkostnad vid planerad f�ngst
    v_mr    F�rv�ntad marginalint�kt vid planerad f�ngst
    ;

EQUATIONS
    e_rev   Int�kter till marknadspris
    e_cost  R�rliga kostnader
    e_qcost F�rv�ntad kostnad f�r kvot�verskridande
    e_profit    F�rv�ntad vinst

*   Extra ekvationer f�r analys av resultaten
    e_mc    Marginalkostnad vid planerad f�ngst
    e_mr    Marginalint�kt vid planerad f�ngst
    ;

e_profit ..
    v_profit =E= v_rev - v_cost - v_qcost;

e_rev ..
    v_rev =E= Pin*v_catch;

e_cost ..
    v_cost =E= MC*v_catch;

e_qcost ..
    v_qcost =E= (Pin-Pout)*(s*LOG[EXP(kvot/s)+EXP(v_catch/s)] + C);

*   Block av ekvationer f�r analys av resultaten

e_mc ..
    v_mc =E= MC;

e_mr ..
    v_mr =E= Pin
           - (Pin-Pout)*1/[1+EXP(-(v_catch-kvot)/s)];


MODEL m_kvotrisk /ALL/;

*   Ber�kna den logistiska f�rdelningens parametrar utifr�n givna data
s = SQRT(3)*sdev/PI;
C = -s*LOG(EXP(kvot/s)+1);
DISPLAY s,C;

SOLVE m_kvotrisk USING NLP MAXIMIZING v_profit;