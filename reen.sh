#/bin/bash
DEST=""
SOURCE_FILE=""
IGNORE_FILE=""

function header {
  echo -e "###################
# 🔧 Reen script  #
###################
"
}

function help {
  header;
  echo -e "-h - Show help
-d - Direcotry path for destiny of the backup
-s - File with directories to backup
-i - File with directories to be ignored in the backup
"
}

function validate_dir {
  # Validates dir exists or creates it
  if [ -z $1 ];
  then
    echo -e "Missing required parameter for directory";
    help;
    exit;  
  fi
}

function validate_file {
  # Validates if global var is not empty
  if [ -z $1 ];
  then
    echo -e "Missing required parameter for file";
    help;
    exit;
  fi

  # Validates if file is empty
  if ! [[ -s $1 ]];
  then
    echo -e "Not found or empty file ${1}";
    exit;
  fi
}

function main {

  # Validations
  validate_file $SOURCE_FILE;
  
  if ! [[ -z "${IGNORE_FILE}" ]];
  then
    validate_file $IGNORE_FILE;
  fi

  validate_dir $DEST;
  
  # Print input parameters
  header;
  
  if ! [[ -z "${IGNORE_FILE}" ]];
  then
    echo -e "[Ignoring] => ${IGNORE_FILE}";  
  fi  
  echo -e "[Source] => $SOURCE_FILE"; 
  echo -e "[Destiny] => $DEST";
  echo -e " "; 

  if [ ! -d $DEST ];
  then
    mkdir -p $DEST;
    echo -e "... Destiny directory created";
  fi
  
  for i in $(cat $SOURCE_FILE ); do
    rsync -a --exclude-from={"${IGNORE_FILE}",} "${i}"  "${DEST}"
    echo -e "... ${i} complete";
  done
  tree "${DEST}";
}

while getopts ":hd:s:i:" option; do
  case $option in
    h) # Display help  
      help
      exit;;
    d) # Set destiny global var
      DEST="${OPTARG}";
      ;;
    s) # Set source global var
      SOURCE_FILE="${OPTARG}";
      ;;
    i) # Set ignore global var
      IGNORE_FILE="${OPTARG}";
      ;;
    \?) # Invalid option
      echo "ERROR: Invalid option";
      help;
      exit;;
  esac
done 

main;
