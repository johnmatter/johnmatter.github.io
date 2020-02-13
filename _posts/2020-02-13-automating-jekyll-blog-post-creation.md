---
title: automating jekyll blog post creation
---

I don't have any real experience in web design, HTML, or CSS.
As an internet literate millenial, I've picked up bits and pieces over the years but I never really sat down to learn how to build a website.
I don't remember where I heard about them, but I decided to use [jekyll](https://jekyllrb.com/) and [w3.css](https://www.w3schools.com/w3css/default.asp) to create my personal website.
Over the course of a few days I managed to stumble through the documentation and tutorials on those websites, build this website from scratch, and host it with [GitHub Pages](https://help.github.com/en/github/working-with-github-pages/about-github-pages).
I still have some cleanup to do, particularly with the Sass/CSS, but overall this was a pretty easy process.

Conventional jekyll organization seems to be to put all your images in `/assets/images/`.
This seems like it would get messy quickly if you post images regularly in a blog, so I decided to create an `/assets/images/posts/` directory which will contain one directory per day with the format `YYYY-MM-DD`.
To make things easy, I created an image.html include that fills in this extra information.
You just need to type `{{ "{% include image.html filename='myimage.jpg' " }}%}` and it will fill in the rest of the path for you.

Making new directories every time you want to post would be annoying, so I decided to write a bash script that does the following:
- Prompts you for a post title
- Creates an `assets/images/post/YYYY-MM-DD` directory if you tell it to
- Creates a minial `.md` file for your post and opens it in your text editor.

I used it to make this post, and it works well enough. We'll see if I can come up with any improvements.

Here's the script:

{% highlight bash linenos %}
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
{% endhighlight %}
