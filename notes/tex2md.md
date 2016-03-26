# The Tex to Markdown (tex2md) Command

    tex2md [options] source mddir

## Options

- `-c, --collection`: \\chapter{The Chapter Title} writes <div class='chapter'>The Chapter Title</div>
- `-s, --standalone`: \\chapter{The Chapter Title} writes ---<nl>style: chapter<nl>title: The Chapter Title<nl>---


Or:

- `-s, --styles`: Each listed style writes the yaml style and title tags
