 #!/bin/sh
 
 # A script whose purpose
 # is to check for changes
 # that have been made to the
 # folder responsible for generating
 # proto buffer files.
 
 TAGS="$(git tag | tail -2)"
 IFS=$'\n', read -d '\n' -a tagsArray <<< "$TAGS"
 TEST_VERSION="v1.2.0-dev.112" # Delete if it is to be used for purposes other than demonstration.
 echo "The last two tags are: ${tagsArray[0]} and $TEST_VERSION" # Delete if it is to be used for purposes other than demonstration.
 # Uncomment if it is to be used for purposes other than demonstration.
 # echo "The last two tags are: ${tagsArray[0]} and ${tagsArray[1]}"
 echo "Comparising the two tags..."
 
 if [ "${tagsArray[0]}" == "${tagsArray[1]}" ]; then
     echo "ERROR: The two tags are the same. They have to be different."
 else
     echo "The two tags are different. They can be merged."
     OUT="$(git --no-pager diff ${tagsArray[0]} $TEST_VERSION -- ./pb/service_externalsystem.proto | grep '+\|-')"# Delete if it is to be used for purposes other than demonstration.
     # Uncomment if it is to be used for purposes other than demonstration.
     # OUT="$(git --no-pager diff ${tagsArray[0]} ${tagsArray[1]} -- ./pb/service_externalsystem.proto)"
     if [ "${OUT}" == "" ]; then
         echo "INFO: There's no changes in protobuffers"
     else
         echo "The patch is: "
         echo "${OUT}"
         echo "Do you want to apply the patch? (y/n)"
         read -r answer
         if [ "${answer}" == "y" ]; then
             echo "Applying the patch..."
             # We can implement something like this:
             # git apply "${tagsArray[0]}.patch"
             echo "The patch has been applied."
             echo "${OUT}" > "${tagsArray[0]}.patch"
         else
             echo "The patch has not been applied."
         fi
     fi
 fi
