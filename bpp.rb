#!/usr/bin/env ruby

# TODO: Add network programming support

# A list of allowed charachters.
ALLOWED = [
           '.', # Standard out
           ',', # Standard in
           '[', # Loop start
           ']', # Loop end
           '<', # Move back a cell
           '>', # Move ahead a cell
           '+', # Add 1 to the current cell
           '-', # Sub 1 from the current cell
           '#', # Open/close file
           '%', # Write val of current cell to file
           '!', # Read a char from file and set it as the current cell
           '@', # Open/close socket to localhost (on port 1337)
           '&', # Read 1 char from the socket and set as current cell
           '*'  # Write val of current cell to socket
          ]

def execute(filename)
	begin    
		f = File.read(filename)
	rescue
		puts "No such file."
		exit
	end
	
    evaluate(f)
end

def evaluate(code)
    # cleanup the code (Remove anything not in ALLOWED) and then build a bracemap.
    code = cleanup(code.chars)
    bracemap = buildbracemap(code)
    handler = nil
    cursor = 0
    sock = nil

    cells, codeptr, cellptr = [0], 0, 0

    while codeptr < code.length
        command = code[codeptr]

        # Iterate through all the commands in the code and evaluate
        case command
        when '>' then cellptr += 1
                      cells.push(0) if cellptr == cells.length
        when '<' then cellptr = cellptr <= 0 ? 0 : cellptr - 1
        when '+' then cells[cellptr] = cells[cellptr] < 255 ? cells[cellptr] + 1 : 0
        when '-' then cells[cellptr] = cells[cellptr] > 0 ? cells[cellptr] - 1 : 255
        when '[' then if cells[cellptr] == 0 then codeptr = bracemap[codeptr] end
        when ']' then if cells[cellptr] != 0 then codeptr = bracemap[codeptr] end
        when '.' then $stdout.write cells[cellptr].chr
        when ',' then cells[cellptr] = $stdin.getc.ord
        when '#' then 
          if handler.nil?
             handler = File.open(cells[cellptr].chr, "w")
             cursor = 0
          else
            handler.close
            handler = nil
          end
        when "%"  
          if ! handler.nil?
            handler.syswrite(cells[cellptr].chr)
          else
            $stderr.write "At #{codeptr}: ERROR - NO FILE IS OPEN\n"
            exit
          end
        when '!'
          if ! handler.nil?
            cells[cellptr] = handler.sysread()[cursor]
            cursor += 1;
          else
            $stderr.write "At #{codeptr}: ERROR - NO FILE IS OPEN\n"
            exit
          end
        when '@' 
            if sock.nil?
                sock = TCPSocket.new("127.0.0.1", 1337)
            else
                sock.close
                sock = nil
            end
        when '*'
            if ! sock.nil?
                sock.write(cells[cellptr].chr)
            else
                $stderr.write "At #{codeptr}: ERROR - NO SOCK IS OPEN\n"
            end
        when '&'
            if ! sock.nil?
                cells[cellptr] = sock.getc.ord
            else
                $stderr.write "At #{codeptr}: ERROR - NO SOCK IS OPEN\n"
            end
        end

        codeptr += 1
    end
end

def cleanup(code)
    cleaned = []
    code.each do |c|
        if ALLOWED.include? c then cleaned.push(c) end
    end
    return cleaned
end
    
def buildbracemap(code)
    temp_bracestack, bracemap = [], {}

    code.each_with_index do |command, position|
        if command == "[" then temp_bracestack.push(position) end
        if command == "]"
            start = temp_bracestack.pop
            bracemap[start] = position
            bracemap[position] = start
        end

    end
    return bracemap
end

def main()
    if ARGV.length == 1 then execute(ARGV[0])
    else print "Usage: #{File.basename($0)} filename" end
end

main
exit
