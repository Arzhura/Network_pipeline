#!/bin/bash
#Author: EMERY Clara 
#Date: 26th June 2019
#Release: git hub 

################################################################################################################
#									MENU CHOICE / HELP DISPLAY
################################################################################################################
function display() { #Display the main Menu 
    echo "Choose what you want to do :" >&2
    echo "
    1. Basic Analysis: BA
    2. Only Flexflux: F 
    3. Only Caspo: C 
    4. Only Post-validation module: P
    5. Display help : H 
    "
   	read -e -p "Choice:	" choice 
   	echo "Current location:"
	pwd
	echo "Give the following files: "

}

function display_help_menu() { #In case of the help is calling 
    echo "Usage: menu.sh " >&2
    echo
    echo "Option available : "
    echo "   BA, --basic_analysis	run Flexflux, then Caspots, and post-validation module finaly,the file entry is after, make choice first"
	echo "   F, --flexflux			run only FlexFlux, the file entry is after, make choice first"
    echo "   C, --caspots			run only Caspots, the file entry is after, make choice first"
    echo "   P, --post-validation	run only the post-validation module, the file entry is after, make choice first"
    echo "   D, --display			show this menu "
    exit 1
}
################################################################################################################
#									READING FILES  
################################################################################################################

function read_files_flexflux(){ 
	#Read the file for FlexFlux (normally automatic for postvalidation)
	# option -e permit to have the autocompletion and -p allow to user directly to give the file in input
	
	echo 
	echo "Files for the use of FlexFlux: "
	read -e -p "MetabolicNetwork (sbml):	" file_metabo 
	read -e -p "Constrainst (txt):		" file_constraints 
	read -e -p "RegulatoryNetwork(sbml):	" file_regu

}

function read_files_caspo(){
	#Read the file for Caspo with same option as Flexflux
	#option -e permit to have the autocompletion and -p allow to user directly to give the path to the file
	echo 
	echo "Files for the use of Caspots"
	read -e -p "Prior knowledge network (.sif):	" file_pkn
	read -e -p "Experimental setup (.json):	" file_setup
	read -e -p "Logical networks (dnf):		" file_dnf
	echo ""

}

################################################################################################################
#									FILES VERIFICATIONS 
################################################################################################################
function verifications_flexflux (){
	#Check if the extension is the right one, take only after the "." character
	# -eq stand for = ; -e for existing file (return true if it exists
	#Re-request to each false entry
	echo
	echo
	echo "	Run the verification for FlexFlux input... "
	echo "Note: "
	echo "If the files does not exist and/or does not have the right extension,"
	echo "you will have to re-enter it systematically until it is correct"
	echo "Please use the auto-complete in order to avoid any errors."
	while [[ $VERIF_META -eq 0 ]]; do
		if [ -e "$file_metabo" ] && [ "${file_metabo##*.}" == "xml" ] || [ "${file_metabo##*.}" == "sbml" ] ; then 
			VERIF_META=1
		else
			read -e -p "MetabolicNetwork (sbml):	" file_metabo  
			VERIF_META=0
		fi
	done

	while [[ $VERIF_CONS -eq 0 ]]; do
		if [ -e "$file_constraints" ] && [ "${file_constraints##*.}" == "txt" ] ; then 
				VERIF_CONS=1
		else
			read -e -p "Constrainst (txt):		" file_constraints
			VERIF_CONS=0
		fi
	done
	
	while [[ $VERIF_REGU -eq 0 ]]; do
		if [ -e "$file_regu" ] && [ "${file_regu##*.}" == "xml" ] || [ "${file_regu##*.}" == "sbml" ] ; then 
			VERIF_REGU=1
		else
			read -e -p "RegulatoryNetwork(sbml):	" file_regu
			VERIF_REGU=0	
		fi
	done
}



function verification_caspo(){
	#Check if the extension is the right one, take only after the "." character
	# -eq stand for = ; -e for existing file (return true if it exists)
	#Re-request to each false entry
	echo
	echo
	echo "	Run the verification for Caspots input... "
	echo "Note: "
	echo "If the files does not exist and/or does not have the right extension,"
	echo "you will have to re-enter it systematically until it is correct"
	echo "Please use the auto-complete in order to avoid any errors."

	while [[ $VERIF_PKN -eq 0 ]]; do
		if [ -e "$file_pkn" ] && [ "${file_pkn##*.}" == "sif" ]; then 
			VERIF_PKN=1
		else
			read -e -p "Prior knowledge network (.sif):	" file_pkn
			VERIF_PKN=0
		fi
	done

	while [[ $VERIF_SET -eq 0 ]]; do
		if [ -e "$file_setup" ] && [ "${file_setup##*.}" == "json" ] ; then
			VERIF_SET=1
		else
			read -e -p "Experimental setup (.json):	" file_setup
			VERIF_SET=0	
		fi
	done

	while [[ $VERIF_DNF -eq 0 ]]; do
		if [ -e "$file_dnf" ] ; then
				VERIF_DNF=1
		else
			read -e -p "Logical networks (dnf):		" file_dnf
			VERIF_DNF=0
		fi
	done
	echo
	echo
}

function verification_global(){
	verifications_flexflux 
	verification_caspo
}

################################################################################################################
#									CREATION OF DIRECTORIES FOR RESULTS 
################################################################################################################
#In order to keep a trace, the results are organized according to the name given to the variable "run_number", 
# which gives its name to the folder in which different folders are created for each tool used.
function creationDirectory(){
	#Enter the run number :
	read -e -p "Chose a run string or number which would be attribuate to the current run: " run_number
	if [ -d "result" ]; then 								#if the directory result already exist previously we enter and do not remove it each time 
		echo "" 
		echo "Directory result/ already created previously"
		echo ""
		cd result/
		if [ -d "$run_number" ] ; then
			cd "$run_number"/
			if [ -d "R" ] ; then 
				echo
			else 
				mkdir R/
			fi

			if [ -d "FlexFlux" ] ; then
				echo
				
			else
				mkdir FlexFlux/
			fi

			if  [ -d "Caspo" ]; then
				echo
			else 
				mkdir Caspo
			fi
			if  [ -d "Post-validation/" ]; then
				cd Post-validation/
				if [ -d "regulatory/" ]; then 
					echo
				else 
					mkdir regulatory/
				fi
				if [ -d "FlexFlux/" ]; then 
					echo
				else 
					mkdir FlexFlux/
				fi
				cd ../
			else 
				mkdir -p Post-validation/regulatory/ &&	mkdir -p Post-validation/FlexFlux/
			fi
		else 
			mkdir -p "$run_number"/FlexFlux/				#The option -p allows to create recurssively the repertories
			mkdir -p "$run_number"/R/ 
			mkdir -p "$run_number"/Caspo/
			mkdir -p "$run_number"/Post-validation/regulatory/ &&	mkdir -p "$run_number"/Post-validation/FlexFlux/
		fi

	else
		echo "Creation of repository result/" 
		mkdir -p result/"$run_number"/FlexFlux/
		mkdir -p result/"$run_number"/R/
		mkdir -p result/"$run_number"/Caspo/
		mkdir -p result/"$run_number"/Post-validation/regulatory/ &&	mkdir -p result/"$run_number"/Post-validation/FlexFlux/
			
	fi
	cd $dir

}
################################################################################################################
#									FLEXFLUX
################################################################################################################
function flexflux(){
	echo "----------------------------------------------------"
	echo "			FLEXFLUX"
	echo "----------------------------------------------------"
	echo "	Analyse option:"  >&2
	echo
	echo "			1.TDRFBA (time dependant FBA analyse)"
	echo "			2.RSA (regulatory steady state FBA analyse)"
	echo
	read -e -p "Choice of analyse: " analyse
	if [ "$analyse" == 1 ] || [ "$analyse" ==" TDRFBA" ] || [ "$analyse" == "tdrfba" ]; then
		echo
		echo "You choose time dependant FBA analyse"
		echo
		read -e -p "Name of the biomass reaction: " bio
		read -e -p "Add other options: " suppl
		echo
		bash $run/FlexFlux/Flexflux.sh TDRFBA -s $file_metabo -cons $file_constraints -reg $file_regu -bio $bio $suppl -x 0.01 -out out_times_"$run_number".csv -sol CPLEX 
		python3 $run/graph_flexflux.py out_times_"$run_number".csv 
		mv out_times_$run_number.csv $dir/result/$run_number/FlexFlux/
		mv output_graph_FlexFlux.png out_graph_$run_number.png 
		mv out_graph_$run_number.png $dir/result/$run_number/FlexFlux/
		flexflux_dir="$dir/result/$run_number/FlexFlux/"
		echo ""
		echo ""
		echo "File created:" ; ls $flexflux_dir
		echo ""
		flex_result="$dir/result/$run_number/FlexFlux/out_times_"$run_number".csv"
		scripts_R
	else 
		echo
		echo "	You choose regulatory steady state FBA analyse"
		echo	
		bash $run/FlexFlux/Flexflux.sh RSA -reg $file_regu -out out_RSA_"$run_number".csv 
		bash $run/FlexFlux/Flexflux.sh RSA -reg $file_regu -cons $file_constraints -out out_RSA_with_constrainst_"$run_number".csv 
		mv out_RSA_$run_number.csv $dir/result/$run_number/FlexFlux/
		mv out_RSA_with_constrainst_$run_number.csv $dir/result/$run_number/FlexFlux/
		flexflux_dir="$dir/result/$run_number/FlexFlux/"
		echo ""
		echo ""
		echo "	File created:" ; ls $flexflux_dir
		echo ""
	fi

}
################################################################################################################
#									SCRIPT R 
################################################################################################################	
#We do a transformation of the out_times.csv from Flexflux into a MIDAS file which is specific format,
#in prupose to have a behaviour in Caspots about the metabolic flux
#for more informations about how work the Rscripts and what they do, there is a README in the src/scripts_R/
function scripts_R(){
	cd $run/scripts_R
	Rscript CreateMidas.R $flex_result
	Rscript FilterTimeSeries.R Midas.csv
	Rscript Discretize.R Filtered.csv 0.1
	Rscript CurveProfile.R Filtered.csv
	mv Midas.csv $dir/result/$run_number/R/
	mv Filtered.csv $dir/result/$run_number/R/
	mv Discretize.csv $dir/result/$run_number/R/
	mv CurveProfile.csv $dir/result/$run_number/R/
	cd $dir
	echo ""
	echo "File created: " ; ls result/$run_number/R/
	echo ""
	cd $dir
	cd result/$run_number/R
	R_results=$(pwd)
	cd $dir
}
################################################################################################################
#									CASPOTS
################################################################################################################	
function caspo(){
	echo "----------------------------------------------------"
	echo "			CASPOTS"
	echo "----------------------------------------------------"
	cd $run/caspo/
	#Creation of directory use by the docker:
	#Be Aware as we use a docker it is better to create and check the files in this function, dont move this code please
	#The directory created will be move to the correct place at the end.
	if [ -d "caspo-wd" ]; then
		#If the directory was already created before we just copy the files needed
		cd caspo-wd  && cp $dir/$file_pkn ./pkn.sif && cp $dir/$file_setup ./setup.json && cp $dir/$file_dnf ./dnf.txt
		while [[ $VERIF_MIDAS -eq 0 ]]; do
		if [ -e "$dir/result/$run_number/R/Midas.csv" ] ; then 
			cp $dir/result/$run_number/R/Midas.csv	./midas_r.csv
			VERIF_MIDAS=1

		else
			cd $dir
			read -e -p "Midas file (.csv):			" file_midas
			VERIF_MIDAS=0
			cd $run/caspo/caspo-wd/
			cp $dir/$file_midas ./midas_r.csv
		fi
		done

		while [[ $VERIF_DISCR -eq 0 ]]; do
		if [ -e "$dir/result/$run_number/R/Discretize.csv" ] ; then 
			cp $dir/result/$run_number/R/Discretize.csv	./discret.csv
			VERIF_DISCR=1
		else 
			cd $dir 
			read -e -p "Discretize file (.csv):		" file_discret
			VERIF_DISCR=0
			cd $run/caspo/caspo-wd/
			cp $dir/$file_discret ./discret.csv

		fi
		done
	else
		mkdir caspo-wd && cd caspo-wd 
		cp $dir/$file_pkn ./pkn.sif && cp $dir/$file_setup ./setup.json && cp $dir/$file_dnf ./dnf.txt
	    while [[ $VERIF_MIDAS -eq 0 ]]; do
		if [ -e "$dir/result/$run_number/R/Midas.csv" ] ; then 
			cp $dir/result/$run_number/R/Midas.csv	./midas_r.csv
			VERIF_MIDAS=1

		else
			cd $dir
			read -e -p "Midas file (.csv):			" file_midas
			VERIF_MIDAS=0
			cd $run/caspo/caspo-wd/
			cp $dir/$file_midas ./midas_r.csv
		fi
		done

		while [[ $VERIF_DISCR -eq 0 ]]; do
		if [ -e "$dir/result/$run_number/R/Discretize.csv" ] ; then 
			cp $dir/result/$run_number/R/Discretize.csv	./discret.csv
			VERIF_DISCR=1
		else 
			cd $dir 
			read -e -p "Discretize file (.csv):		" file_discret
			VERIF_DISCR=0
			cd $run/caspo/caspo-wd/
			cp $dir/$file_discret ./discret.csv

		fi
		done
	fi
		#Once this step done we could start the true analysis with Caspots
	echo "	Here we use the options identify and validate of Caspots,
	and add the visualization from Caspo with vizualise option
	In prupose to avoid false entry Caspots will run alone and
	you have the choice between the possibilities below to add
	at identify Caspots
	Options available:
	1. Simple without any option in particular 
	2. With control-nodes 
	3. With control-nodes and partial-bn
	4. With partial-bn
	5. With partial-bn and family mincard
	6. With partial-bn and family subset
	7. With partial-bn and family mincard,  mincard-tolerance, weight-tolerance
	8. With partial-bn and family subset, mincard-tolerance weight-tolerance
	"
	read -e -p "Choice of option: " option
	while [[ $OPTION -eq 0 ]]; do
		if [ "$option" == 1 ] || [ "$option" == 2 ] || [ "$option" == 3 ] || [ "$option" == 4 ] || [ "$option" == 5 ] || [ "$option" == 6 ] || [ "$option" == 7 ] || [ "$option" == 8 ]; then 
			echo "You choose $option "
			OPTION=1
		else 
			echo "You don't choose an valide option"
			read -e -p "Choice of option: " option
			OPTION=0
		fi 
	done
	echo "----------------------------------------------------"
	echo "			Identify"
	echo "----------------------------------------------------"
	if [ "$option" == 1 ] ; then
		docker run --rm --volume "$PWD":/wd --workdir /wd pauleve/caspots identify pkn.sif discret.csv network.csv 
	elif [ "$option" == 2 ] ; then
		echo "Give the control-nodes that you want to study separate by ,  (i.e. Carbon1,Carbon2) :"
		read control_nodes
		docker run --rm --volume "$PWD":/wd --workdir /wd pauleve/caspots identify pkn.sif discret.csv network.csv --control-nodes "$control_nodes"
	elif [ "$option" == 3 ] ; then
		echo "Give the control-nodes that you want to study separate by ,  (i.e. Carbon1,Carbon2) :"
		read control_nodes
		docker run --rm --volume "$PWD":/wd --workdir /wd pauleve/caspots identify pkn.sif discret.csv network.csv --partial-bn dnf.txt --control-nodes "$control_nodes"
    elif [ "$option" == 4 ] ; then
        docker run --rm --volume "$PWD":/wd --workdir /wd pauleve/caspots identify pkn.sif discret.csv network.csv --partial-bn dnf.txt 
	elif [ "$option" == 5 ] ; then
		docker run --rm --volume "$PWD":/wd --workdir /wd pauleve/caspots identify pkn.sif discret.csv network.csv --partial-bn dnf.txt --family mincard
	elif [ "$option" == 6 ] ; then
        docker run --rm --volume "$PWD":/wd --workdir /wd pauleve/caspots identify pkn.sif discret.csv network.csv --partial-bn dnf.txt --family subset  
    elif [ "$option" == 7 ] ; then
    	docker run --rm --volume "$PWD":/wd --workdir /wd pauleve/caspots identify pkn.sif discret.csv network.csv --partial-bn dnf.txt --family mincard --mincard-tolerance 0 --weight-tolerance 0 
    else
        docker run --rm --volume "$PWD":/wd --workdir /wd pauleve/caspots identify pkn.sif discret.csv network.csv --partial-bn dnf.txt --family subset --mincard-tolerance 0 --weight-tolerance 0 
    fi
    echo "----------------------------------------------------"
	echo "			Validate"
	echo "----------------------------------------------------"
	docker run --rm --volume "$PWD":/wd --workdir /wd pauleve/caspots validate pkn.sif  discret.csv network.csv --output network_validate.csv 
	if [ "$option" == 1 ] ; then
		docker run --rm --volume "$PWD":/wd --workdir /wd pauleve/caspots mse pkn.sif  discret.csv 
	elif [ "$option" == 2 ] ; then
		docker run --rm --volume "$PWD":/wd --workdir /wd pauleve/caspots mse pkn.sif  discret.csv --control-nodes "$control_nodes"
	elif [ "$option" == 3 ] ; then
		docker run --rm --volume "$PWD":/wd --workdir /wd pauleve/caspots mse pkn.sif  discret.csv --partial-bn dnf.txt --control-nodes "$control_nodes"
	elif [ "$option" == 4 ] ; then
		docker run --rm --volume "$PWD":/wd --workdir /wd pauleve/caspots mse pkn.sif  discret.csv --partial-bn dnf.txt 
	elif [ "$option" == 5 ] ; then
		docker run --rm --volume "$PWD":/wd --workdir /wd pauleve/caspots mse pkn.sif  discret.csv  --partial-bn dnf.txt --family mincard
	elif [ "$option" == 6 ] ; then
		docker run --rm --volume "$PWD":/wd --workdir /wd pauleve/caspots mse pkn.sif  discret.csv --partial-bn dnf.txt --family subset  
	elif [ "$option" == 7 ] ; then
		docker run --rm --volume "$PWD":/wd --workdir /wd pauleve/caspots mse pkn.sif  discret.csv --partial-bn dnf.txt --family mincard --mincard-tolerance 0 --weight-tolerance 0 
	else
		docker run --rm --volume "$PWD":/wd --workdir /wd pauleve/caspots mse pkn.sif  discret.csv  --partial-bn dnf.txt --family subset --mincard-tolerance 0 --weight-tolerance 0 
	fi


	nblines=$(wc -l network.csv | sed 's/ network.csv//') 
	#Number of lines in the file must to be converted in integer:
	nbnet=$(($nblines-1))
	echo "----------------------------------------------------"
	echo "			Visualize"
	echo "----------------------------------------------------"
	docker run --rm -v $PWD:/caspo-wd -w /caspo-wd bioasp/caspo visualize --pkn pkn.sif --setup setup.json --networks network.csv --sample $nbnet
	cd out/
	#We just take -1 to the for loop because the number of --sample start at 0 
	nbnets=$(($nbnet-1))
	#Transform all the dot into PNG files:	
	for (( i=0; i<=$nbnets; i++ )) ; do
    	dot -Tpng network-"$i".dot -o network-"$i".png 
	done
	dot -Tpng pkn.dot -o pkn.png
	dot -Tpng networks-union.dot -o networks-union.png
	cd ../
	echo "----------------------------------------------------"
	echo "			END"
	echo "----------------------------------------------------"
	mkdir files
	mv pkn.sif files/ && mv dnf.txt files/ && mv setup.json files/ && mv discret.csv files/ && mv midas_r.csv files/ && mv files/ ../
	cd ../
	ls $dir/result/

	#I choose to remove the existing files if they are already has the same run_number
	if [ -d "$dir/result/$run_number/Caspo/caspo-wd" ] && [ -d "$dir/result/$run_number/Caspo/files/" ] ; then
		rm -rf $dir/result/$run_number/Caspo/*
		mv caspo-wd/ $dir/result/$run_number/Caspo/
		mv files/ $dir/result/$run_number/Caspo/
	else 
		mv caspo-wd/ $dir/result/$run_number/Caspo/
		mv files/ $dir/result/$run_number/Caspo/
	fi
	cd $dir 


}

function post_validation(){
	echo "----------------------------------------------------"
	echo "			POST-VALIDATION"
	echo "----------------------------------------------------"
	cd $dir
	network="$dir/result/$run_number/Caspo/caspo-wd/network.csv"
	caspometa= which capsometabolism
	capsometa
	capsometa $file_regu $network
	echo $nb 
	echo $nbnets
	for ((nb=0; nb<=$nbnets; nb++)) ; do 
		ls
		bash $run/FlexFlux/Flexflux.sh TDRFBA -s $file_metabo -cons $file_constraints -reg network_regulatory_"$nb".xml -bio $bio $suppl -x 0.01 -out out_times_network_"$nb".csv -sol CPLEX 
		python3 $run/graph_flexflux.py out_times_network_"$nb".csv 
		mv out_times_network_"$nb".csv  $dir/result/$run_number/Post-validation/FlexFlux/
		mv output_graph_FlexFlux.png out_graph_"$nb".png 
		mv out_graph_"$nb".png $dir/result/$run_number/Post-validation/FlexFlux/
	done

	mv network_regulatory_* $dir/result/$run_number/Post-validation/regulatory/
	post_validation_regu="$dir/result/$run_number/Post-validation/regulatory"
	ls post_validation_regu
	cd $dir
	echo "----------------------------------------------------"
}

################################################################################################################
#									RUNNING THE DIFFERENTS MODULES 
################################################################################################################
function flexflux_analysis(){
	read_files_flexflux
	verifications_flexflux	
	creationDirectory 
	flexflux 
}


function caspo_analysis() {
	read_files_caspo	
	verification_caspo 
	creationDirectory 
	caspo

}
function postvalidation_analysis() {
	echo "To be continued ! "
	post_validation

}

function basic_analysis () {
	read_files_flexflux
	read_files_caspo
	verification_global  
	creationDirectory 
	flexflux 
	caspo 
	post_validation

}
################################################################################################################
#									DISPLAY MENU
################################################################################################################
function main (){
	#Initialization of the verification variables (allows to check the loop)
	VERIF_META=0
	VERIF_CONS=0
	VERIF_REGU=0
	VERIF_PKN=0
	VERIF_SET=0	
	VERIF_DNF=0
	#Definitions of the differents path useful there
	dir=$(pwd)
	cd src/ 
	run=$(pwd)
	cd $dir
	display
	case $choice in 
		BA | ba | --basic_analysis | 1 ) 
		basic_analysis
		exit 1
		;;
		F | f  | --flexflux | 2 )
		flexflux_analysis
		exit 1
		;;
		C | c | --caspo  | 3 )
		caspo_analysis 
		exit 1
		;;
		P | p | --post-validation  | 4 )
		postvalidation_analysis
		exit 1
		;;
		H | h | help | 5 )
		display_help 
		break
		;;
    esac
	
}
#sed -i -e "s/<cn type=\"integer\"/<ci/g" file.sbml
#sed -i -e "s/<\/cn>/<\/ci>/g" file.sbml
main