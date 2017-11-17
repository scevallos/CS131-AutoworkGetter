#!/bin/zsh
#
# Script used for automating retrieval of hw or lab files through SVN for
# CS131
#
# Usage:
#     ./get.sh (hw | lab) <number> <person_1> <optionally_person_2>
# 
# Example:
#     ./get.sh lab 42 moneill cstone
#     ./get.sh hw 47 scevallos
#
# author: scevallos
# date: 11.16.17

# function for catching bad inputs
bad(){
    tput setaf 3; echo "Usage:\n    ./get.sh (hw | lab) <number> <person_1> <optionally_person_2>" 
    exit 1
}

# str.lower() to catch "HW" and "hw", "Lab" and "lab", etc.
file_type=$(echo "$1" | tr '[:upper:]' '[:lower:]')

# Base url for svn directories that will be used (could change this
# and would be usable in future semesters)
base_dir="https://svn.cs.hmc.edu/cs131/fall17/given/"

# check that it is actually either 'hw' or 'lab'
case "$file_type" in
    "hw")
        file_type="hw"
        ;;
    "lab")
        file_type="lab"
        ;;
    *)
        echo "First arg must be ('hw' | 'lab')"
        bad
esac

# check that 2nd input is actually a number
if echo $2 | egrep -q '^[0-9]+$'; then
    file_num=$2
else
    echo "Second arg must be a number"
    bad
fi

# get name(s) and alphabetize; make local_dir name
if [[ -z "$3" ]] then
    echo "Must have non-empty third arg"
    bad
else
    if [[ ! -z "$4" ]] then
        # there is a second name --> alphabetize and make local dir name
        temp=$(printf $3"\n"$4 | sort | tr '\n' -)

        # remove last \n char, which comes from the sort command
        local_dir=${temp: : -1}
    else
        # no second person so dir_name is just u
        local_dir=$3
    fi
fi

# cd into the dir if it exists already, otherwise make it and cd into it
cd ~"/courses/cs131/$local_dir" 2>/dev/null || (mkdir ~"/courses/cs131/$local_dir" && cd ~"/courses/cs131/$local_dir")

# Do the svn stuff
svn copy $base_dir$file_type$file_num $file_type$file_num
svn commit -m "Copied over $file_type$file_num files"


