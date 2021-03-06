\ XXX get these from video/common/defer.fth
\ false instance value 6-bit-primaries?	\ Indicate if DAC only supports 6bpp
\ defer ext-textmode  ' noop to ext-textmode
\ These are just to make vga.fth happy.  They are ba
\ defer rs@   defer rs!
\ defer idac@ defer idac!
\ defer xvideo-on
\ From graphics.fth

\ defer plt@
\ defer plt!
\ defer rindex!
\ defer windex!

: ext-textmode
   use-vga-dac
   h# ff h# e crt!  h# ff h# f crt!  \ Move the hardware cursor off-screen
   h# 01 h# 33 crt!   \ Hsync adjustment
   h# 10 h# 35 crt!   \ Clear extended bits that can't be on for this mode's size
   h# 00 h# 15 seq!   \ Not using graphics modes
   h# 0c h# 16 seq!   \ FIFO
   h# 1f h# 17 seq!   \ FIFO
   h# 4e h# 18 seq!   \ FIFO
\  h# 21 h# 1a seq!   \ Extended mode memory access disable, palette registers access secondary display
\  h# 01 h# 1a seq!   \ Extended mode memory access disable, palette registers access secondary display
   h# 00 h# 1a seq!   \ Palette registers access primary display
   h# 54 h# 1c seq!   \ Hdisp fetch count low
   h# 00 h# 1d seq!   \ Hdisp fetch count high
   h# 14 h# 22 seq!   \ FIFO
   h# 40 h# 41 seq!   \ arbiter
   h# 30 h# 42 seq!   \ arbiter
   h# 00 h# 51 seq!   \ FIFO
   h# 06 h# 58 seq!   \ FIFO
   h# 00 h# 71 seq!   \ FIFO
   h# 00 h# 73 seq!   \ FIFO
;
\ defer rmr@  defer rmr!

: (set-colors)  ( adr index #indices -- )
   swap windex!
   3 *  bounds  ?do  i c@  plt!  loop
   h# ff rmr!
;

\ fload ${BP}/dev/video/controlr/vga.fth
fload ${BP}/dev/video/common/textmode.fth

0 value pc-font-adr
: (pc-font)  ( -- fontparams )
   pc-font-adr 0=  if
      " pcfont" " find-drop-in" evaluate  if  ( adr len )
         drop to pc-font-adr
      else
         default-font exit
      then
   then

   " /packages/terminal-emulator" find-package  if  ( phandle )
      " decode-font" rot find-method  if   ( xt )
         pc-font-adr swap execute          ( font-params )
         exit
      then
   then

   \ Fallback
   default-font
;
' (pc-font) to pc-font

warning @ warning off
: text-mode3  ( -- )
   olpc-crt-on  \ Restore power to IGA1, as we need it for VGA modes
   text-mode3   \ The base VGA version; sets up the font and stuff
   d# 640 d# 400 8 set-resolution
   set-primary-mode
   expanded
   3 note-mode
;
: graphics-mode12  ( -- )
   olpc-crt-on  \ Restore power to IGA1, as we need it for VGA modes
   graphics-mode12   \ The base VGA version; sets up the font and stuff
   d# 640 d# 480 4 set-resolution
   set-primary-mode
   expanded
   h# 12 note-mode
;
warning !

: 640x480x32   ( -- )  olpc-lcd-mode  d# 640 d# 480 d# 32 change-resolution  h# 112 note-mode  ;  \ VESA mode 112
: 800x600x32   ( -- )  olpc-lcd-mode  d# 800 d# 600 d# 32 change-resolution  h# 115 note-mode  ;  \ VESA mode 115
: 1024x768x32  ( -- )  olpc-lcd-mode d# 1024 d# 768 d# 32 change-resolution  h# 118 note-mode  ;  \ VESA mode 118
: 1200x900x16  ( -- )  olpc-lcd-mode d# 1024 d# 768 d# 16 change-resolution  native-mode# 1- note-mode  ;
: 1200x900x24  ( -- )  olpc-lcd-mode d# 1024 d# 768 d# 32 change-resolution  note-native-mode  ;
: 1200x900x32  ( -- )  olpc-lcd-mode d# 1024 d# 768 d# 32 change-resolution  note-native-mode  ;
