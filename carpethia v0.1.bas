#include "string.bi"
#include "fbgfx.bi"
#include "vbcompat.bi"

#if __FB_LANG__ = "fb"
Using FB '' Scan code constants are stored in the FB namespace in lang FB
#endif

Const PI As Double = 3.1415926535897932
dim shared as integer xres,yres
dim shared as single rad, waves, rotd, prec
dim as byte p1,p2,p3,p4,p5
dim shared as uinteger ir1,ir2,cr1,cr2,ir,cr
dim shared as uinteger ig1,ig2,cg1,cg2,ig,cg
dim shared as uinteger ib1,ib2,cb1,cb2,ib,cb



sub plot (byval xpos as integer, ypos as integer, rad as integer, r as byte, g as byte, b as byte)
dim as integer x, y 
dim as single z,c1,c2,c3
dim as uinteger col

    for x = xpos-rad to xpos+rad
        for y = ypos-rad to ypos+rad
           
           z = sqr(rad^2-(x-xpos)^2-(y-ypos)^2)
           z = (255/rad)*z

            ir2 = ir+ir1
            cr2 = cr+cr1
            ig2 = ig+ig1
            cg2 = cg+cg1
            ib2 = ib+ib1
            cb2 = cb+cb1
            
            if r = 1 then c1 = (cr1*(ir2-z)+cr2*(z-ir1))/(ir2-ir1)
            if g = 1 then c2 = (cg1*(ig2-z)+cg2*(z-ig1))/(ig2-ig1)
            if b = 1 then c3 = (cb1*(ib2-z)+cb2*(z-ib1))/(ib2-ib1)
            
            if z < ir1 or z > ir2 then c1 = 0
            if z < ig1 or z > ig2 then c2 = 0
            if z < ib1 or z > ib2 then c3 = 0
            
           col = c1 shl 16 + c2 shl 8 + c3    
           col = col + point(x+400, 400-y)
           pset (x+400,400-y), col
        next y
    next x 

end sub

sub main ()
dim as single fact1
dim as single rotr 
dim as single x, y, s, t, z
    cls
        fact1 = (xres/waves)/(2*PI)
        rotr = PI*rotd/180
  
        for y = -400 to yres-400
            for x = -400 to xres-400
                s = x*cos(rotr)+y*sin(rotr)
                t = y*cos(rotr)-x*sin(rotr)
                z = ( sin(s/fact1+PI/2) + sin(t/fact1+PI/2) ) / 2
                if z < 0 then z = 0
                if z > = prec then plot (x, y, rad, 1,1,1)
                if multikey(SC_END) then goto ki
            next x
        next y 
ki:
        draw string (10,10), "Radius (Q): " + format(rad, "0")
        draw string (10,20), "Waves (UP/DOWN): " + format(waves, "0.000")
        draw string (10,30), "Precision (WERTZ): " + format(prec, "0.00000")
        draw string (10,40), "Rotate (LEFT/RIGHT): "+ format(rotd, "0.000")
        draw string (10,50), "Red int lo limit (Y): " + format(ir1,"0 ")
        draw string (10,60), "Red int range (A): " + format(ir,"0 ")
        draw string (10,70), "Red col lo limit (X): " + format(cr1,"0 ")
        draw string (10,80), "Red col range (S): " + format(cr,"0 ")
        draw string (10,90), "Green int lo limit (C): " + format(ig1,"0 ")
        draw string (10,100), "Green int range (D): " + format(ig,"0 ")
        draw string (10,110), "Green col lo limit (V): " + format(cg1,"0 ")
        draw string (10,120), "Green col range (F): " + format(cg,"0 ")
        draw string (10,130), "Blue int lo limit (B): " + format(ib1,"0 ")
        draw string (10,140), "Blue int range (G): " + format(ib,"0 ")
        draw string (10,150), "Blue col lo limit (N): " + format(cb1,"0 ")
        draw string (10,160), "Blue col range (H): " + format(cb,"0 ")

        'ScreenSync
        'screencopy        
        bsave format( now(), "yymmdd_hhnnss") + ".bmp",0 
end sub


xres = 800
yres = 800


Screenres xres, yres, 32, 2
'ScreenSet 1, 0

Color RGB(255, 255, 255), RGB(50, 0, 50)
cls

rad = 50
waves = 25
rotd = 0

p1 = 9
p2 = 9
p3 = 9
p4 = 9
p5 = 9
prec = p1*0.1 + p2*0.01 + p3*0.001 + p4*0.0001 + p5*0.00001


ir1=230
ir=25
cr1=0
cr=255

ig1=0
ig=200
cg1=0
cg=255

ib1=200
ib=30
cb1=0
cb=255


main ()


do 

'WAVES
    if multikey(SC_UP) and waves < 100 then
        waves = waves + 1
        main ()
    end if
    if multikey(SC_DOWN) and waves > 1 then
        waves = waves - 1
        main ()
    end if

'ROTATION
    if multikey(SC_LEFT) then
        rotd = rotd - 0.001
        main ()
    end if
    if multikey(SC_RIGHT) then
        rotd = rotd + 0.001
        main ()
    end if

'RADIUS
    if MultiKey(SC_RSHIFT) and multikey(SC_Q) and rad > 1 then
        rad = rad - 1
        main ()
    end if
    if multikey(SC_Q) and rad < 200 then
        rad = rad + 1
        main ()
    end if

'PRECISION 1st DIGIT
    if MultiKey(SC_RSHIFT) and multikey(SC_W) and p1 > 0 then
        p1 = p1 - 1
        prec = p1*0.1 + p2*0.01 + p3*0.001 + p4*0.0001 + p5*0.00001
        main ()
    end if
    if multikey(SC_W) and p1 < 9 then
        p1 = p1 + 1
        prec = p1*0.1 + p2*0.01 + p3*0.001 + p4*0.0001 + p5*0.00001
        main ()
    end if

'PRECISION 2nd DIGIT
    if MultiKey(SC_RSHIFT) and multikey(SC_E) and p2 > 0 then
        p2 = p2 - 1
        prec = p1*0.1 + p2*0.01 + p3*0.001 + p4*0.0001 + p5*0.00001
        main ()
    end if
    if multikey(SC_E) and p2 < 9 then
        p2 = p2 + 1
        prec = p1*0.1 + p2*0.01 + p3*0.001 + p4*0.0001 + p5*0.00001
        main ()
    end if

'PRECISION 3rd DIGIT
    if MultiKey(SC_RSHIFT) and multikey(SC_R) and p3 > 0 then
        p3 = p3 - 1
        prec = p1*0.1 + p2*0.01 + p3*0.001 + p4*0.0001 + p5*0.00001
        main ()
    end if
    if multikey(SC_R) and p3 < 9 then
        p3 = p3 + 1
        prec = p1*0.1 + p2*0.01 + p3*0.001 + p4*0.0001 + p5*0.00001
        main ()
    end if

'PRECISION 4th DIGIT
    if MultiKey(SC_RSHIFT) and multikey(SC_T) and p4 > 0 then
        p4 = p4 - 1
        prec = p1*0.1 + p2*0.01 + p3*0.001 + p4*0.0001 + p5*0.00001
        main ()
    end if
    if multikey(SC_T) and p4 < 9 then
        p4 = p4 + 1
        prec = p1*0.1 + p2*0.01 + p3*0.001 + p4*0.0001 + p5*0.00001
        main ()
    end if

'PRECISION 5th DIGIT
    if MultiKey(SC_RSHIFT) and multikey(SC_Y) and p5 > 0 then
        p5 = p5 - 1
        prec = p1*0.1 + p2*0.01 + p3*0.001 + p4*0.0001 + p5*0.00001
        main ()
    end if
    if multikey(SC_Y) and p5 < 9 then
        p5 = p5 + 1
        prec = p1*0.1 + p2*0.01 + p3*0.001 + p4*0.0001 + p5*0.00001
        main ()
    end if

'RED LOW INTENSITY
    if MultiKey(SC_RSHIFT) and multikey(SC_Z) and ir1 > 0 then
        ir1 = ir1 - 1
        main ()
    end if
    if multikey(SC_Z) and ir1 < 255 then
        ir1 = ir1 + 1
        main ()
    end if

'RED HIGH INTENSITY
    if MultiKey(SC_RSHIFT) and multikey(SC_A) and ir > 0 then
        ir = ir - 1
        main ()
    end if
    if multikey(SC_A) and ir < 255 then
        ir = ir + 1
        main ()
    end if

'RED LOW COLOR LIMIT
    if MultiKey(SC_RSHIFT) and multikey(SC_X) and cr1 > 0 then
        cr1 = cr1 - 1
        main ()
    end if
    if multikey(SC_X) and cr1 < 255 then
        cr1 = cr1 + 1
        main ()
    end if

'RED HIGH COLOR LIMIT
    if MultiKey(SC_RSHIFT) and multikey(SC_S) and cr > 0 then
        cr = cr - 1
        main ()
    end if
    if multikey(SC_S) and cr < 255 then
        cr = cr + 1
        main ()
    end if

'GREEN LOW INTENSITY
    if MultiKey(SC_RSHIFT) and multikey(SC_C) and ig1 > 0 then
        ig1 = ig1 - 1
        main ()
    end if
    if multikey(SC_C) and ig1 < 255 then
        ig1 = ig1 + 1
        main ()
    end if

'GREEN HIGH INTENSITY
    if MultiKey(SC_RSHIFT) and multikey(SC_D) and ig > 0 then
        ig = ig - 1
        main ()
    end if
    if multikey(SC_D) and ig < 255 then
        ig = ig + 1
        main ()
    end if

'GREEN LOW COLOR LIMIT
    if MultiKey(SC_RSHIFT) and multikey(SC_V) and cg1 > 0 then
        cg1 = cg1 - 1
        main ()
    end if
    if multikey(SC_V) and cg1 < 255 then
        cg1 = cg1 + 1
        main ()
    end if

'GREEN HIGH COLOR LIMIT
    if MultiKey(SC_RSHIFT) and multikey(SC_F) and cg > 0 then
        cg = cg - 1
        main ()
    end if
    if multikey(SC_F) and cg < 255 then
        cg = cg + 1
        main ()
    end if

'BLUE LOW INTENSITY
    if MultiKey(SC_RSHIFT) and multikey(SC_B) and ib1 > 0 then
        ib1 = ib1 - 1
        main ()
    end if
    if multikey(SC_B) and ib1 < 255 then
        ib1 = ib1 + 1
        main ()
    end if

'BLUE HIGH INTENSITY
    if MultiKey(SC_RSHIFT) and multikey(SC_G) and ib > 0 then
        ib = ib - 1
        main ()
    end if
    if multikey(SC_G) and ib < 255 then
        ib = ib + 1
        main ()
    end if

'BLUE LOW COLOR LIMIT
    if MultiKey(SC_RSHIFT) and multikey(SC_N) and cb1 > 0 then
        cb1 = cb1 - 1
        main ()
    end if
    if multikey(SC_N) and cb1 < 255 then
        cb1 = cb1 + 1
        main ()
    end if

'BLUE HIGH COLOR LIMIT
    if MultiKey(SC_RSHIFT) and multikey(SC_H) and cb > 0 then
        cb = cb - 1
        main ()
    end if
    if multikey(SC_H) and cb < 255 then
        cb = cb + 1
        main ()
    end if


loop Until MultiKey(SC_ESCAPE)