---
title: blog
---

<div class="w3-row">
    <div class="w3-col m2 l2">
        <p></p>
    </div>

    <div class="w3-col m8 l8">

        <h1>posts by date</h1>

        <ul style="list-style-type:circle;">
            {% for post in site.posts %}
            <li>
                <p style="line-height:30px;margin:0px;"><a href="{{ post.url }}">{{ post.title }}</a></p>
                <p style="line-height:30px;margin:0px;">{{ post.date | date_to_long_string }}</p>
                <div class="w3-opacity">
                    {{ post.excerpt | strip_html | truncatewords: 40 | markdownify }}
                </div>
            </li>
            {% endfor %}
        </ul>
        
    </div>

    <div class="w3-col m2 l2">
        <p></p>
    </div>
</div>
