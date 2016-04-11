---
title: Title Page
guide: title-page
add_header: no
---
{% assign author = site.data.author %}
{% assign publisher = site.data.publisher %}
{% assign publication = site.data.publication %}

# {{ publication.title }}

## {{ author.name }}

### {{ publisher.name }}

ISBN: {{ publication.isbn.ebook }}

{% assign claim = publication.rights | first %}
&copy; {{ claim.date }} {{ claim.owner }}

[Full Copyright Information](copyright.html)
