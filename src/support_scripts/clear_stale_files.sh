if [ -z "$1" ]; then
    echo "error line (  ${LINENO} ) : destination folder name missing"
    exit 1
fi

#switch to destination directory
DST_DIR=$1
mkdir -p $DST_DIR 2> /dev/null 1> /dev/null
cd $DST_DIR
[[ $? -ne 0 ]]; echo "error line (  ${LINENO} )"; exit 1



#remove wordpress backup files 
find . -name "*.wpress"|while read fname; do
  rm "$fname"
done

echo "( status ) wordpress backup files are removed"

#remove custom files ... 
