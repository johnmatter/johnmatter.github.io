---
layout: portfolio-item
title: jake - a sequencer for norns/grid
img: jake.jpg
---

<div class="w3-display-container w3-padding w3-center">
    <p>
        <img src={{ site.baseurl }}"/assets/images/portfolio/jake.jpg" class="w3-image">
    </p>
</div>

jake is a sequencer for the monome [norns](https://monome.org/docs/norns/) and [grid](https://monome.org/docs/grid/) based on the game [snake](https://en.m.wikipedia.org/wiki/Snake_(video_game_genre)).

The snake travels across the grid at a rate of one pad per quarter note. The player can steer the snake by pressing any pad that lies in the direction desired. For each randomly placed apple eaten, the snake grows one segment in length. The game ends if the snake runs into itself.

Each segment of the snake corresponds to a note in a sequence. The snake is initialized with four segments, each of which has a random note assigned. Each additional segment grown by eating an apple adds a note to the sequence determined by the apple’s position.

jake can sequence internal norns synthesizer voices and external synthesizers via midi. It also outputs eurorack CV and sequences [Mannequins Just Friends](https://www.whimsicalraps.com/products/just-friends?variant=5586981781533) via  [crow](https://monome.org/docs/crow/)

A future version of jake will allow the user to adjust the rate of the snake’s travel and sequence playback speed as subdivisions of the clock tempo. It will also feature a more game-like display on the norns screen, displaying the current and high score and possibly a cute snake animation.

jake can be found on my [github](https://github.com/johnmatter/jake).
