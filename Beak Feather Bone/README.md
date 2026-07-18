> Beak, Feather, & Bone is a collaborative worldbuilding tool as well as a 
> competitive map-labeling RPG. Starting with an unlabeled city map, players are 
> assigned community roles before taking turns claiming and describing 
> locations. Players draw from a standard 52-card deck to determine a building's 
> purpose and then describe its beak (reputation), feather (appearance), and 
> bone (interior). As buildings are claimed, a narrative for the town and its 
> inhabitants emerges, including major NPCs and shifting power-dynamics. 
https://possible-worlds-games.itch.io/bfb

Beak Feather Bone is formatted for half-letter booklet printing so no additional 
trimming is required. The booklet can be simply staple bound.

# Script Instructions
- Copy `./Beak Feather and Bone - Digital and Print.pdf` to this directory
- Run `./script.sh` (or `podman run --rm -it -v './':/work -w /work pdftools 
    ./script.sh` if using podman/docker)

# Duplex
For printing on a duplex printer (ie printing both sides of a sheet in the same 
pass). Ex: a fancy printer like at Kinkos, Office Max, Staples, etc.

BFB is entirely black and white, so just print it off.

# Simplex
Assuming your printer outputs pages face down, top towards you: First print 
`./print/Beak Feather Bone - Simplex Fronts.pdf`. Take the stack of paper and 
put it back into your printer's paper feed, then print `./print/Beak Feather 
Bone - Simplex - Backs (Reversed).pdf`. You should try a couple test pages first 
to ensure your print outputs like you expect.
