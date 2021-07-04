---
layout: portfolio-item
title: ising - a sequencer for norns/grid
img: ising.jpg
---

ising is a sequencer for the monome [norns](https://monome.org/docs/norns/) and [grid](https://monome.org/docs/grid/) based on a simple [2D Ising model](https://en.m.wikipedia.org/wiki/Ising_model) of ferromagnetism. ising is based on [zellen](https://llllllll.co/t/zellen/21107).

In the Ising model, the energy of a lattice of spins is determined by the orientation of each spin with respect to its neighbors’ spins. Depending on the sign of the coupling coefficients, large scale ferromagnetic (aligned) or antiferromagnetic (anti-aligned) order emerges. Nonzero temperatures introduce fluctuations that can create local disruptions or overwhelm the order with entropy.
Each pad on the grid represents a lattice node. Each pad’s spin orientation (either up or down) is indicated by its LED brightness. Spin down LEDs are off, and spin up LEDs are on. Transitions between spin states are determined by a [Metropolis algorithm](https://en.m.wikipedia.org/wiki/Metropolis–Hastings_algorithm): if it is energetically favorable to flip or if there is “enough” thermal energy, a pad’s spin will flip in the next generation.
Like zellen’s reborn/born/ghost options for sequencing, ising allows you to sequence on spin up pads, spin down pads, or spin flips. I’ve found the most useful settings to be large negative or positive coupling, sequencing on spin flips, and slowly turning temperature up from zero until you see a few spin flips per generation.

ising can be found on my [github](https://github.com/johnmatter/ising).
