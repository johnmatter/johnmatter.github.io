#!/bin/bash

textEditor=vim

# Where is your repository cloned?
topDir=$HOME/johnmatter.github.io
postDir=$topDir/_posts

# Date format should be YYYY-MM-DD for jekyll
today=$(date +%F)

# Ask user for title
read -p "title: " title

# Remove spaces for filename
titleNoSpaces=$(echo $title | sed "s/ /-/g")

# Construct post filename
post=$postDir/$today-$titleNoSpaces.md

# Check if file exists
if [ -f "$post" ]; then
    echo "$post already exists. Please delete it before moving forward."
    exit 1
fi

# Create image directory if we have images
echo "Do you want to create an images directory for this post?"
select yn in "Yes" "No"; do
    case $yn in
        Yes)
            imageDir=$topDir/assets/images/posts/$today
            echo Creating $imageDir
            echo You should put your images here.

            # Check if directory already exists
            if [ -d "$imageDir" ]; then
                echo "$imageDir already exists. Please delete it before moving forward."
                exit 2
            fi

            # Create the directory
            mkdir $imageDir

            # macOS syntax: open the directory in Finder so we can move the images into it
            open $imageDir

            break;;
        No)
            break;;
    esac
done

# Create file with minimal header
touch $post
echo --- >> $post
echo title: $title >> $post
echo --- >> $post

# Open file for editing
$textEditor $post
