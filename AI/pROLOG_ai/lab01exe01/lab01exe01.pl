/* STOXOS --> monopati([3,3,left,0,0],[0,0,right,3,3]). 
Anaparastasi katastasis --> [XL,YL,B,XR,YR]
Arxiki katastasi --> [3,3,left,0,0].
Teliki katastasi --> [0,0,right,3,3].
*/

check(XL,YL,XR,YR) :-
	YL>=0, XL>=0, YR>=0, XR>=0,
	(YL>=XL ; YL=0),   /* prepei o arithmos ton ierapostolon stin aristeri kai stin deksia*/
	(YR>=XR ; YR=0).   /* oxthi na einai megaliteros apo ton arithmo ton kanivalon i isos me 0 */


efarm_telesti([XL,YL,left,XR,YR],[XL,YL2,right,XR,YR2]):-
	/* T1: Dio ierapostoloi pernane stin deksia oxthi. */
	YR2 is YR+2,
	YL2 is YL-2,
	check(XL,YL2,XR,YR2).

efarm_telesti([XL,YL,left,XR,YR],[XL2,YL,right,XR2,YR]):-
	/* T2: Dio kanivaloi pernane stin deksia oxthi. */
	XR2 is XR+2,
	XL2 is XL-2,
	check(XL2,YL,XR2,YR).

efarm_telesti([XL,YL,left,XR,YR],[XL2,YL2,right,XR2,YR2]):-
	/* T3: Enas ierapostolos ki enas kanivalos pernane stin deksia oxthi. */
	XR2 is XR+1,
	XL2 is XL-1,
	YR2 is YR+1,
	YL2 is YL-1,
	check(XL2,YL2,XR2,YR2).

efarm_telesti([XL,YL,left,XR,YR],[XL,YL2,right,XR,YR2]):-
	/* T4: Enas ierapostolos pernaei stin deksia oxthi. */
	YR2 is YR+1,
	YL2 is YL-1,
	check(XL,YL2,XR,YR2).

efarm_telesti([XL,YL,left,XR,YR],[XL2,YL,right,XR2,YR]):-
	/* T5: Enas kanivalos pernaei stin deksia oxthi. */
	XR2 is XR+1,
	XL2 is XL-1,
	check(XL2,YL,XR2,YR).

efarm_telesti([XL,YL,right,XR,YR],[XL,YL2,left,XR,YR2]):-
	/* T6: Dio ierapostoloi pernane stin aristeri oxthi. */
	YR2 is YR-2,
	YL2 is YL+2,
	check(XL,YL2,XR,YR2).

efarm_telesti([XL,YL,right,XR,YR],[XL2,YL,left,XR2,YR]):-
	/* T7: Dio kanivaloi pernane stin aristeri oxthi. */
	XR2 is XR-2,
	XL2 is XL+2,
	check(XL2,YL,XR2,YR).

efarm_telesti([XL,YL,right,XR,YR],[XL2,YL2,left,XR2,YR2]):-
	/* T8: Enas ierapostolos ki enas kanivalos pernane stin aristeri oxthi. */
	XR2 is XR-1,
	XL2 is XL+1,
	YR2 is YR-1,
	YL2 is YL+1,
	check(XL2,YL2,XR2,YR2).

efarm_telesti([XL,YL,right,XR,YR],[XL,YL2,left,XR,YR2]):-
	/* T9: Enas ierapostolos pernaei stin aristeri oxthi. */
	YR2 is YR-1,
	YL2 is YL+1,
	check(XL,YL2,XR,YR2).

efarm_telesti([XL,YL,right,XR,YR],[XL2,YL,left,XR2,YR]):-
	/* T10: Enas kanivalos pernaei stin aristeri oxthi. */
	XR2 is XR-1,
	XL2 is XL+1,
	check(XL2,YL,XR2,YR).

monopati(X, Y) :- monopati(X, Y, [X], _).
	
monopati([XL,YL,B,XR,YR],[XL,YL,B,XR,YR],_,Teliko_monopati):- 
	output(Teliko_monopati).
	
monopati([XL1,YL1,B1,XR1,YR1],[XL2,YL2,B2,XR2,YR2],Monopati,Teliko_monopati) :- 
   efarm_telesti([XL1,YL1,B1,XR1,YR1],[XL3,YL3,B3,XR3,YR3]), 
   \+(member([XL3,YL3,B3,XR3,YR3],Monopati)),
   monopati([XL3,YL3,B3,XR3,YR3],[XL2,YL2,B2,XR2,YR2],[[XL3,YL3,B3,XR3,YR3]|Monopati],[ [[XL3,YL3,B3,XR3,YR3],[XL1,YL1,B1,XR1,YR1]] | Teliko_monopati ]).


output([]) :- nl. 
output([[A,B]|Teliko_monopati]) :- 
	output(Teliko_monopati), 
   	write(B), write(' -> '), write(A), nl.