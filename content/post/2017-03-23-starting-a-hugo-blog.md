+++
date = "2017-03-23T18:11:12-07:00"
title = "How to Start a Hugo Blog"
categories = ["Code"]
tags = ["Hugo", "Web", "Static"]
+++


{{% nt %}}I have a lofty goal: {{% /nt %}} Learn something new every day and
write it down.

It's not that I'm not learning anymore. It's more that I want to get better
at _expressing_ the things that I know.

Why not make the inaugural post about the process of setting this very blog up?

## Arriving at Hugo's Door

I've [used static site generators before](http://pedaldrivenprogramming.com).
After playing around with a few different generators I finally decided to go with
[Hugo](https://gohugo.io/). It's fast, modern and pretty nice to use (single
binary distribution anyone?).

Setup is pretty simple:

```shell
wget https://github.com/spf13/hugo/releases/download/v0.19/hugo_0.19_Linux-64bit.tar.gz
tar -xzf hugo_0.19_Linux-64bit.tar.gz
cp /hugo_0.19_linux_amd64/hugo_0.19_linux_amd64 hugo
./hugo new site mynewblog
```

Is all you need to start a new site.

The first thing you need is a theme:

`git clone https://github.com/Fingel/nofancy.git mynewblog/themes/nofancy/`

Now you can create content:

`hugo new posts/myfirstpost.md`

And that'll get you pretty close to what you see right here.

## Publishing with Git

Hugo places static output into `public/`. suitable for hosting basically anywhere. However I'm a big
fan of git and since I'll be tracking this repo with git anyway, why not have hugo build the site
and deploy for me on push?

With `public/` added to `.gitignore` we can now use a `post-receive` git hook on the remote repo to
build the site:

```
git clone --recursive /path/or/url/to/repo.git /tmp/mysite/
cd /tmp/mysite/
hugo
cp -R public/* /var/www/mysite/
rm -rf /tmp/mysite
exit
```

Now whenever a push is made, the repo will be cloned, the site built, and the output copied.
No scp/ftp/whatever necessary.

## Working with Images

Hugo has built in support for static files, including images. But we don't really
want to be placing a bunch of images in source control.

My solution:

1. Create a top level directory `images/` where you will place images for the posts you write.
2. Create an s3 bucket (or equivalent) and install s3cmd. Add the root url to `config.toml`:

    ```
    [params]
        imageurl = "https://s3-us-west-2.amazonaws.com/mybucket/images"
    ```

3. Write a handly Makefile:

    ```
    s3sync:
        s3cmd sync images/ s3://mybucket/images/ -P
    ```

4. Create the following file in `layouts/shortcodes/imageurl.html`:

    ```
    {{ .Site.Params.imageurl }}
    ```

5. Now after you run `make s3sync` you can add images to post using the shortcode:

    ```
    ![hugo]({ {% imageurl %} }/hugo.png)
    ```

The result:

![hugo]({{% imageurl %}}/hugo-logo.png)

Images will be stored in s3, not locally. If you write posts from other computers
you won't need to download all (or any) of the images from previous posts. Bath
in the glory of your lightweight text only blog.


This is a code block:

## Hugo is Good

I'm happy to have learned how to use the new hot static site generator in
the neighborhood. I hope it keeps kicking ass well into the future.
