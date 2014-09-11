#!/bin/bash

fin=$1	        			#input file template
fout=$1.out        			#output file template
fintmp=$fin.in				#pre-process file for quotes

rm $fout

echo "Processing $fin"
i=-1					#line number
last_n=-1 				#last unique patient number
gndr=-1					#gender info
dgns=-1					#diagnosis info

sed 's/[\"]//g' $fin > $fin.in 

while IFS=, read PATNO GENDER DIAGNOSIS CLINICAL_EVENT TYPE TESTNAME TESTVALUE UNITS RUNDATE PROJECTID PI_NAME PI_INSTITUTION UPDATE_STAMP;do      
   #read one line
   if [ $i -lt 0 ]; then
	(( i++ ))
	continue
   fi 
   curr_n=$PATNO
   if [ "$PATNO" != "$last_n" ]; then 	#looks for new patients
   	 last_n=$PATNO
	 echo $PATNO $GENDER $DIAGNOSIS
	 if [ "$GENDER" == "Female" ]; then
		gndr=1
	 elif [ "$GENDER" == "Male" ]; then
		gndr=2		
	 else 
		gndr=-1
	 fi
	 if [ $DIAGNOSIS = "Control" ]; then
		dgns=1
	 elif [ $DIAGNOSIS = "PD" ]; then
		dgns=2		
	 elif [ $DIAGNOSIS = "SWEDD" ]; then
		dgns=3
	 else 
		dgns=-1
	 fi

	output="$PATNO,$gndr,$dgns"
	echo $output >> $fout		#appends to new bash file
   fi
done < $fintmp 
echo "Done."

