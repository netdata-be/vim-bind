" This function is used to update the serial in the SOA from a bind file
function! UpdateDNSSerialZone()
  " Initialisation des variables
  let serialZone=0
  let serialZoneUpdated=0
  "Search for a line that start with a year and contains the word Serial
  let numberOfLine = search('\(19\|20\)\d\d\(0[1-9]\|1[012]\)\(0[1-9]\|[12][0-9]\|3[01]\)\d\d.*\(S\|s\)erial.*')
  if numberOfLine == 0
    echo "No bind serial found ! so not updating the file"
  else
    "Get the line contents 
    let line = getline(numberOfLine)
    "Extract the serial number
    let serialZone=strpart(line, match(line,'\(19\|20\)\d\d\(0[1-9]\|1[012]\)\(0[1-9]\|[12][0-9]\|3[01]\)'),match(line,";")-1-match(line,'\(19\|20\)\d\d\(0[1-9]\|1[012]\)\(0[1-9]\|[12][0-9]\|3[01]\)'))
    " Get the text which is before and after the serial number, this will
    " be used to update the serial.
    let pre = strpart(line, 0, match(line,'\(19\|20\)\d\d\(0[1-9]\|1[012]\)\(0[1-9]\|[12][0-9]\|3[01]\)') )
    let post = strpart(line, match(line,'\(19\|20\)\d\d\(0[1-9]\|1[012]\)\(0[1-9]\|[12][0-9]\|3[01]\)')+10, match(line, "$" ) )

    " Create a new server number for today
    let serialZoneUpdated=strftime("%Y%m%d")."01"
    " If the found serial date matches the one from today then we have to
    " increment
    if serialZone =~ "^.*".strftime("%Y%m%d").".*"
      let serialZoneUpdated=serialZone+1
    endif
    " Build a new line with the updated serial
    "let line = pre.serialZoneUpdated."\t; Serial HIHI"
    let line = pre.serialZoneUpdated.post
    " Write the line back to the file
    call setline(numberOfLine, line)
    echo "Old serial = \"".serialZone."\" updated serial to = \"".serialZoneUpdated."\""
  endif
endfunction

:map <F2> :call UpdateDNSSerialZone()<cr>
verbose au BufWritePre,FileWritePre * :call UpdateDNSSerialZone()


