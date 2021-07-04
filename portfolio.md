---
title: portfolio
---

<div class="w3-row">
    <div class="w3-col m3 l4">
        <p></p>
    </div>

    <div class="w3-row w3-margin-top">
        {% for item in site.portfolio %}

                <div class="w3-half">
                    <div class="w3-display-container w3-padding-16 w3-margin-left w3-margin-right">
                        <a href="{{ item.url | prepend: site.baseurl }}">
                            <img src={{ site.baseurl }}"/assets/images/portfolio/{{ item.img }}" class="w3-hover-opacity" style="width:100%">
                            <div class="w3-display-topmiddle w3-xxlarge">
                                <h1>{{ item.title }}</h1>
                            </div>
                        </a>
                    </div>
                </div>

        {% endfor %}

    </div>

    <div class="w3-col m3 l4">
        <p></p>
    </div>

</div>
