#!/bin/bash
dirArray=()
start(){
    CurrentDirectory
}

Title(){
    figlet -w 999 -f starwars Directory Detect
}

CurrentDirectory() {
Title 
Pwd
}

ChangeDirectory() {
    cd $1
    echo "CHANGE"
}

ListDirectory() {
    dirArray=() # Reset the array to ensure it's empty before starting.
    while IFS= read -r -d '' directory; do
        dirArray+=("${directory#./}") # Remove './' prefix from directory names
    done < <(find . -mindepth 1 -maxdepth 1 -type d -print0)
}
DirectoryExistsInArray() {
    local searchDir="$1"
    for dir in "${dirArray[@]}"; do
        if [[ "$dir" == "$searchDir" ]]; then
            echo "Directory '$searchDir' exists in the array."
            return 0
        fi
    done
    echo "Directory '$searchDir' does not exist in the array."
    return 1
}
Line(){
    > tempFile.txt
    period=""   
    for ((i= 1; i <=$1 ; i++)) do
    period+="."
    done
    figlet -w 999 $period > tempfile.txt
     echo "$(<tempfile.txt)"

}

Pwd(){
    > tempfile2.txt
     figlet -w 999 "PWD : ""$PWD" > tempfile2.txt
     lineLength=$(wc -L <<< "$(<tempfile2.txt)")
     lineLength=$(($lineLength / 2 ))

    Line $lineLength
    figlet -w 999 "PWD : ""$PWD"
    Line $lineLength

   
}
getw(){
  
    local length=$(Pwd)
    wc -L <<< $length
    }
start


Bfs() {
    local searchDir="$1"
    local queue=("$PWD") # Initialize queue with the current directory
    local currentDir

    while [ ${#queue[@]} -gt 0 ]; do
        currentDir="${queue[0]}" # Dequeue the first directory
        queue=("${queue[@]:1}") # Remove the first element from the queue
        cd "$currentDir" || continue # Change to the current directory or skip if it fails

        ListDirectory # Populate dirArray with subdirectories of the current directory

        # Check if the target directory is in the current set of directories
        for dir in "${dirArray[@]}"; do
            if [[ "${dir##*/}" == "$searchDir" ]]; then
                echo "Directory found in $currentDir/$dir."
                return 0
            fi
        done

        # If not found, add subdirectories to the queue for later processing
        for dir in "${dirArray[@]}"; do
            queue+=("$currentDir/$dir")
        done
    done

    echo "Directory not found."
    echo "...Creating!"
    mkdir $1
    return 1
}

while IFS=' ' read -r -p "Enter command and argument (or 'q' to quit): " cmd arg; do
  if [[ $cmd == q ]]; then
    echo "Quitting..."
    break
  fi

  case $cmd in
    Move)
      if cd "$arg"; then
          echo "Moved to $arg"
          CurrentDirectory
      else
          echo "Failed to move to $arg"
      fi
      ;;
    Contents)
      ListDirectory
      echo "Contents: ${dirArray[@]}"
      ;;
    Find)
      ListDirectory # Ensure dirArray is populated with the current directory's contents
      DirectoryExistsInArray "$arg"
      result=$?
      if [ $result -eq 0 ]; then
          CurrentDirectory
            echo "Directory found."
            mkdir $arg
      else
          echo "Directory not found in current directory. Starting BFS..."
          Bfs "$arg"
      fi
      ;;
    *)
      echo "Unknown command: $cmd"
      ;;
  esac
done

