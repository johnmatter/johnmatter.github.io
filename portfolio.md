---
title: portfolio
---

<div class="w3-row">
    <div class="w3-col m3 l4">
        <p></p>
    </div>

    <div class="w3-row">
        {% for item in site.portfolio %}

                <div class="w3-half">
                    <div class="w3-display-container w3-padding w3-center">

                            <a href="{{ item.url | prepend: site.baseurl }}">
                                <hr style="width:75%; margin:auto; height:1px; border-width:1px; background-color:#679">
                                <img src={{ site.baseurl }}"/assets/images/portfolio/{{ item.img }}" class="w3-hover-opacity" style="width:95%; padding-top:16px">
                                <h3>{{ item.title }}</h3>
                            </a>

                    </div>
                </div>

        {% endfor %}

    </div>

    <div class="w3-col m3 l4">
        <p></p>
    </div>

</div>
