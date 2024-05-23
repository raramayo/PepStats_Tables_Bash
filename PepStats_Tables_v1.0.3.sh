#!/usr/bin/env bash

func_copyright ()
{
    cat <<COPYRIGHT

This program is free software: you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option)
any later version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
more details.

You should have received a copy of the GNU General Public License along
with this program. If not, see <https://www.gnu.org/licenses/>.

COPYRIGHT
};

func_authors ()
{
    cat <<AUTHORS
Author:                            Rodolfo Aramayo
WORK_EMAIL:                        raramayo@tamu.edu
PERSONAL_EMAIL:                    rodolfo@aramayo.org
AUTHORS
};

func_usage()
{
    cat <<EOF
###########################################################################
ARAMAYO_LAB
$(func_copyright)

SCRIPT_NAME:                    $(basename ${0})
SCRIPT_VERSION:                 ${version}

USAGE: $(basename ${0})
 -p Proteins_Fasta_File.fa      # REQUIRED (Proteins File)
 -r PepStats_Tables             # OPTIONAL (Run Name)
 -z TMPDIR Location             # OPTIONAL (default='0'='TMPDIR Run')

TYPICAL COMMANDS:
 $(basename ${0}) -p Proteins_Fasta_File.fa

INPUT01:          -p FLAG       REQUIRED - Proteins File
INPUT01_FORMAT:                 Fasta Format
INPUT01_DEFAULT:                No default

INPUT02:          -r FLAG       OPTIONAL - Run Name
INPUT02_FORMAT:                 Text
INPUT02_DEFAULT:                PepStats_Tables

INPUT03:          -z FLAG       OPTIONAL input
INPUT03_FORMAT:                 Numeric: '0' == TMPDIR Run | '1' == Local Run
INPUT03_DEFAULT:                '0' == TMPDIR Run
INPUT03_NOTES:
 '0' Processes the data in the \$TMPDIR directory of the computer used or of
the node assigned by the SuperComputer scheduler.

 Processing the data in the \$TMPDIR directory of the node assigned by the
SuperComputer scheduler reduces the possibility of file error generation
due to network traffic.

 '1' Processes the data in the same directory where the script is being run.

DEPENDENCIES:
 EMBOSS: Required (http://emboss.open-bio.org/html/adm/ch01s01.html)

$(func_authors)
###########################################################################
EOF
};

## Defining_Script_Current_Version
version="1.0.3";

## Defining_Script_Initial_Version_Data (date '+DATE:%Y/%m/%d')
version_date_initial="DATE:2021/07/17";

## Defining_Script_Current_Version_Data (date '+DATE:%Y/%m/%d')
version_date_current="DATE:2024/05/23";

## Testing_Script_Input
## Is the number of arguments null?
if [[ ${#} -eq 0 ]];then
    echo -e "\nPlease enter required arguments";
    func_usage;
    exit 1;
fi

while true;do
    case ${1} in
        -h|--h|-help|--help|-\?|--\?)
            func_usage;
            exit 0;
            ;;
        -v|--v|-version|--version)
            printf "Version: ${version} %s\n" >&2;
            exit 0;
            ;;
        -p|--p|-proteome|--proteome)
            proteinsfile=${2};
            shift;
            ;;
        -r|--r|-run_name|--run_name)
            run_name=${2};
            shift;
            ;;
	-z|--z|-tmp-dir|--tmp-dir)
            tmp_dir=${2};
            shift;
            ;;
        -?*)
            printf '\nWARNNING: Unknown Option (ignored): %s\n\n' ${1} >&2;
            func_usage;
            exit 0;
            ;;
        :)
            printf '\nWARNING: Invalid Option (ignored): %s\n\n' ${1} >&2;
            func_usage;
            exit 0;
            ;;
        \?)
            printf '\nWARNING: Invalid Option (ignored): %s\n\n' ${1} >&2;
            func_usage;
            exit 0;
            ;;
        *)  # Should not get here
            break;
            exit 1;
            ;;
    esac
    shift;
done

## Processing: -p Flag
if [[ -z ${proteinsfile} ]];then
    echo "Please define a proteins fasta file";
    func_usage;
    exit 1;
fi
if [[ ! -f ${proteinsfile} ]];then
    echo "Please provide a proteins fasta file";
    func_usage;
    exit 1;
fi

## Processing: -r Flag
run_name=${run_name:=PepStats_Tables};

## Processing '-z' Flag
## Determining Where The TMPDIR Will Be Generated
if [[ -z ${tmp_dir} ]];then
    tmp_dir=${tmp_dir:=0};
fi

var_regex="^[0-1]+$"
if ! [[ ${tmp_dir} =~ $var_regex ]];then
    echo "Please provide a valid number (e.g., 0 or 1), for this variable";
    func_usage;
    exit 1;
fi

## Generating Directories
var_script_out_data_dir=""$(pwd)"/"${proteinsfile}"_"${run_name}".dir";
export var_script_out_data_dir=""$(pwd)"/"${proteinsfile}"_"${run_name}".dir";

if [[ ! -d ${var_script_out_data_dir} ]];then
    mkdir ${var_script_out_data_dir};
else
    rm ${var_script_out_data_dir}/* &>/dev/null;
fi

if [[ -d ${proteinsfile}_${run_name}.tmp ]];then
    rm -fr ${proteinsfile}_${run_name}.tmp &>/dev/null;
fi

## Generating/Cleaning TMP Data Directory
if [[ ${tmp_dir} -eq 0 ]];then
    ## Defining Script TMP Data Directory
    var_script_tmp_data_dir=""$(pwd)"/"${proteinsfile}"_"${run_name}".tmp";
    export var_script_tmp_data_dir=""$(pwd)"/"${proteinsfile}"_"${run_name}".tmp";

    if [[ -d ${var_script_tmp_data_dir} ]];then
        rm -fr ${var_script_tmp_data_dir};
    fi

    if [[ -z ${TMPDIR} ]];then
        ## echo "TMPDIR not defined";
        TMP=$(mktemp -d -p ${TMP}); ## &> /dev/null);
        var_script_tmp_data_dir=${TMP};
        export  var_script_tmp_data_dir=${TMP};
    fi

    if [[ ! -z ${TMPDIR} ]];then
        ## echo "TMPDIR defined";
        TMP=$(mktemp -d -p ${TMPDIR}); ## &> /dev/null);
        var_script_tmp_data_dir=${TMP};
        export  var_script_tmp_data_dir=${TMP};

    fi
fi

if [[ ${tmp_dir} -eq 1 ]];then
    ## Defining Script TMP Data Directory
    var_script_tmp_data_dir=""$(pwd)"/"${proteinsfile}"_"${run_name}".tmp";
    export var_script_tmp_data_dir=""$(pwd)"/"${proteinsfile}"_"${run_name}".tmp";

    if [[ ! -d ${var_script_tmp_data_dir} ]];then
        mkdir ${var_script_tmp_data_dir};
    else
        rm -fr ${var_script_tmp_data_dir};
        mkdir ${var_script_tmp_data_dir};
    fi
fi

## Initializing_Log_File
time_execution_start=$(date +%s)
echo -e "Starting Processing Genome: "$proteome" on: "$(date)"" \
     > ${var_script_out_data_dir}/${proteinsfile}_${run_name}.log;

## Verifying_Software_Dependency_Existence
echo -e "Verifying Software Dependency Existence on: "$(date)"" \
     >> ${var_script_out_data_dir}/${proteinsfile}_${run_name}.log;
## Determining_Current_Computer_Platform
osname=$(uname -s);
cputype=$(uname -m);
case "${osname}"-"${cputype}" in
    Linux-x86_64 )           plt=Linux ;;
    Darwin-x86_64 )          plt=Darwin ;;
    Darwin-*arm* )           plt=Silicon ;;
    CYGWIN_NT-* | MINGW*-* ) plt=CYGWIN_NT ;;
    Linux-*arm* )            plt=ARM ;;
esac
## Determining_GNU_Bash_Version
if [[ ${BASH_VERSINFO:-0} -ge 4 ]];then
    echo "GNU_BASH version "${BASH_VERSINFO}" is Installed" >> ${var_script_out_data_dir}/${proteinsfile}_${run_name}.log;
else
    echo "GNU_BASH version 4 or higher is Not Installed";
    echo "Please Install GNU_BASH version 4 or higher";
    rm -fr ${var_script_out_data_dir};
    rm -fr ${var_script_tmp_data_dir};
    func_usage;
    exit 1;
fi
## pepstats
type pepstats &> /dev/null;
var_sde=$(echo ${?});
if [[ ${var_sde} -eq 0 ]];then
    echo "pepstats is Installed" >> ${var_script_out_data_dir}/${proteinsfile}_${run_name}.log;
else
    echo "EMBOSS pepstats is Not Installed";
    echo "Please Install EMBOSS pepstats";
    rm -fr ${var_script_out_data_dir};
    rm -fr ${var_script_tmp_data_dir};
    func_usage;
    exit 1;
fi

echo -e "Software Dependencies Verified on: "$(date)"\n" >> ${var_script_out_data_dir}/${proteinsfile}_${run_name}.log;
echo -e "Script Running on: "${osname}", "${cputype}"\n" >> ${var_script_out_data_dir}/${proteinsfile}_${run_name}.log;

## set LC_ALL to "C"
export LC_ALL="C";

echo -e "Command Issued Was:" >> ${var_script_out_data_dir}/${proteinsfile}_${run_name}.log;
echo -e "\tScript Name:\t\t$(basename ${0})" >> ${var_script_out_data_dir}/${proteinsfile}_${run_name}.log;
echo -e "\tGenome Analyzed:\t${proteinsfile}" >> ${var_script_out_data_dir}/${proteinsfile}_${run_name}.log;
echo -e "\tFile Type:\t\tProteome" >> ${var_script_out_data_dir}/${proteinsfile}_${run_name}.log;

if [[ ${tmp_dir} -eq 0 ]];then
    echo -e "\tTMPDIR Requested:\t\$TMPDIR Directory" >> ${var_script_out_data_dir}/${proteinsfile}_${run_name}.log;
else
    echo -e "\tTMPDIR Requested:\tLocal Directory" >> ${var_script_out_data_dir}/${proteinsfile}_${run_name}.log;
fi

## Starting_Script
if [[ ! -s ${var_script_tmp_data_dir}/001_${proteinsfile}.out ]];then
    pepstats -sequence "${proteinsfile}" -outfile ${var_script_tmp_data_dir}/001_${proteinsfile}.out 2> /dev/null;
fi

echo '#!/usr/bin/awk -f
/PEPSTATS/ {
        if (nl) {printf "\n"} else nl = 1
        printf "%s", $3
        next
}

/Molecular weight/ {
        printf " %s", $4
}

/Residues =/ {
        printf " %s", $NF
}

/Average/ {
	  printf " %s", $5
}

/Isoelectric/ {
	  printf " %s", $NF
}

/Tiny/ {
      printf " %s", $NF
}

/Small/ {
      printf " %s", $NF
}

/Aliphatic/ {
      printf " %s", $NF
}

/Aromatic/ {
      printf " %s", $NF
}

/Non-polar/ {
      printf " %s", $NF
}

/Polar/ {
      printf " %s", $NF
}

/Charged/ {
      printf " %s", $NF
}

/Basic/ {
      printf " %s", $NF
}

/Acidic/ {
      printf " %s", $NF
}

END {
        printf "\n"
}' \
     > ${var_script_tmp_data_dir}/002_${proteinsfile}.out;

chmod 755 \
      ${var_script_tmp_data_dir}/002_${proteinsfile}.out;

${var_script_tmp_data_dir}/002_${proteinsfile}.out \
  ${var_script_tmp_data_dir}/001_${proteinsfile}.out | \
    awk '{$1=$1}1' OFS="\t" \
	> ${var_script_tmp_data_dir}/003_${proteinsfile}.out

echo -e "Protein_ID\tMolecular_weight\tNo_Residues\tAverage_Residue_Weight\tIsoelectric_Point\t\
     Mole%_Tiny\tMole%_Small\tMole%_Aliphatic\tMole%_Aromatic\tMole%_Non-polar\tMole%_Polar\tMole%_Charged\tMole%_Basic\tMole%_Acidic" \
     > ${var_script_tmp_data_dir}/004_${proteinsfile}.out;

cat ${var_script_tmp_data_dir}/004_${proteinsfile}.out \
    ${var_script_tmp_data_dir}/003_${proteinsfile}.out \
    > ${var_script_tmp_data_dir}/005_${proteinsfile}.out


cp ${var_script_tmp_data_dir}/001_${proteinsfile}.out \
   ${var_script_out_data_dir}/${proteinsfile}_${run_name}_Analysis.out

cp ${var_script_tmp_data_dir}/005_${proteinsfile}.out \
   ${var_script_out_data_dir}/${proteinsfile}_${run_name}_Table.out

rm -fr ${var_script_tmp_data_dir};

# Closing_Log_File
time_execution_stop=$(date +%s)
echo -e "\nFinishing Processing proteome: "${proteinsfile}" on: "$(date)"" \
     >> ${var_script_out_data_dir}/${proteinsfile}_${run_name}.log;
echo -e "Script Runtime: $(echo "${time_execution_stop}"-"${time_execution_start}"|bc -l) seconds" \
     >> ${var_script_out_data_dir}/${proteinsfile}_${run_name}.log;
echo -e "Script Runtime: $(echo "scale=2;(${time_execution_stop}"-"${time_execution_start})/60"|bc -l) minutes" \
     >> ${var_script_out_data_dir}/${proteinsfile}_${run_name}.log;
echo -e "Script Runtime: $(echo "scale=2;((${time_execution_stop}"-"${time_execution_start})/60)/60"|bc -l) hours" \
     >> ${var_script_out_data_dir}/${proteinsfile}_${run_name}.log;

exit 0
