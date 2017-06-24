                                                                 
 ____                          _                                 
|  _ \                       _| |_                     _     _   
| |_) ) ___   __  ___  _  __/     \ _   ___   ___  ___| |_ _| |_ 
|  _ ( / _ \ /  \/ / || |/ ( (| |) ) | | \ \ / / |/ (_   _|_   _)
| |_) ) |_) | ()  <| || / / \_   _/| |_| |\ v /|   <  |_|   |_|  
|____/|  __/ \__/\_\\_)__/    |_|   \___/  > < |_|\_\            
      | |                                 / ^ \                  
      |_|                                /_/ \_\              
          Standard Brainfuck + File IO + Socket IO

Instruction Set:

  Standard:
    +   ->  Increase current cell value by 1
    -   ->  Decrease current cell value by 1
    <   ->  Move back a cell
    >   ->  Move ahead a cell
    .   ->  Print ASCII of current cell
    ,   ->  Set cell value as ASCII code of input
    [   ->  Begin loop
    ]   ->  End loop

  Extended:
    #   ->  Open/close File
    %   ->  Write value of current cell to file
    !   ->  Read one character from file (at the current cursor position)
    @   ->  Open/close socket to localhost:1337
    &   ->  Read one char from socket and set it as val of current cell 
    *   ->  Write value of current cell to socket

USAGE: ruby bpp.rb <file.bf>
