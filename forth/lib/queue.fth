\ See license at end of file
purpose: Character queue

struct ( queue )
   /n field >qbase
   /n field >qsize
   /n field >qgetp
   /n field >qputp
constant /queue

: clearq  ( q -- )  dup >qbase @ swap  2dup >qgetp !  >qputp !  ;
: makeq  ( size -- q )
   /queue alloc-mem         ( size q )
   swap 1+ over  >qsize !  ( q )
   dup >qsize @ alloc-mem  over >qbase !  dup clearq
;
: decqp  ( q ptr -- q ptr' )
   over >qbase @  over =  if  over >qsize @ +  then 1-
;
: putq  ( char q -- )
   dup >qputp @  decqp                                 ( char q putptr )
   begin  over >qgetp @  over =  while  pause  repeat  ( char q putptr )
   rot over c!                                         ( q putptr )
   swap >qputp !                                       ( )
;
: getq  ( q -- char )
   dup >qgetp @                                        ( q getptr )
   begin  over >qputp @  over =  while  pause  repeat  ( q getptr )
   decqp                                               ( q getptr )
   dup c@ -rot                                         ( char q getptr )
   swap >qgetp !                                       ( char )
;
: qempty?  ( q -- flag )  dup >qgetp @  swap >qputp @ =  ;
: qfull?   ( q -- flag )  dup >qputp @  decqp  swap >qgetp @ =  ;
: qlen  ( q -- len )
   dup >qgetp @  over >qputp @ -        ( q len )
   dup 0<  if  over >qsize @  +  then    ( q len' )
   nip                                    ( len )
;
: q#open  ( q -- n )  dup >qsize @  1-  swap qlen  -  ;
\ 10 makeq constant q1
\ : .q  ( q -- )
\    dup >qbase @ . dup >qsize @ . dup >qgetp @ .  dup >qputp @ . cr
\    drop
\ ;

\ LICENSE_BEGIN
\ Copyright (c) 2010 FirmWorks
\ 
\ Permission is hereby granted, free of charge, to any person obtaining
\ a copy of this software and associated documentation files (the
\ "Software"), to deal in the Software without restriction, including
\ without limitation the rights to use, copy, modify, merge, publish,
\ distribute, sublicense, and/or sell copies of the Software, and to
\ permit persons to whom the Software is furnished to do so, subject to
\ the following conditions:
\ 
\ The above copyright notice and this permission notice shall be
\ included in all copies or substantial portions of the Software.
\ 
\ THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
\ EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
\ MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
\ NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
\ LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
\ OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
\ WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
\
\ LICENSE_END
