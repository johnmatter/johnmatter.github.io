---
title: portfolio
---

<div class="w3-row">
    <div class="w3-col m3 l4">
        <p></p>
    </div>

    <div class="w3-col m6 l4">

        <h1>portfolio</h1>
        <h2>⚠︎under construction⚠︎</h2>

        {% for item in site.portfolio %}

            <div class="w3-padding-16">
                <div class="w3-card-4">
                    <a href="{{ item.url | prepend: site.baseurl }}">
                        <header class="w3-container" style="color:#FFFF;background-color:#679">
                            {{ item.title }}
                        </header>
                    </a>
                    <div class="w3-container">
                        {{ item.excerpt | strip_html | truncatewords: 20 | markdownify }}
                        <a href="{{ item.url | prepend: site.baseurl }}">
                            ...
                        </a>
                    </div>
                </div>
            </div>

        {% endfor %}

    </div>

    <div class="w3-col m3 l4">
        <p></p>
    </div>

</div>
