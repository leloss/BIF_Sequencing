#!/bin/bash

fin=$1	        			#input bioanalysis file
fin2=$2					#input sequencing file
fout=$2.out        			#output file template

rm $fout

echo "Processing $fin"
dgns=-1					#diagnosis info

i=0 
while IFS=, read PATNO GENDER DIAGNOSIS;do      
   #read one line
   patlist[$i]=$PATNO
   #genlist[$i]=$GENDER
   diaglist[$i]=$DIAGNOSIS 
   (( i++ )) 
done < $fin

#echo ${patlist[*]}
#echo ${diaglist[*]}
echo "Processing $fin2"
while IFS=" " read FAMID SAMID PATID MATID SEX AFFECT;do
   #read one line
   j=0 
   while [ $j -le $i ]; do 
	#echo $j $i $SAMID ${patlist[$j]} ${diaglist[$j]}
	if [ "$SAMID" == "${patlist[$j]}" ]; then
		dgns=${diaglist[$j]}
		echo $j $i $SAMID ${patlist[$j]} ${diaglist[$j]}
		break 
	fi	
        (( j++ ))		
   done  
   output="$FAMID $SAMID $PATID $MATID $SEX $dgns"
   echo $output >> $fout           	#appends to new bash file
   dgns=-1
done < $fin2

echo "Done."

