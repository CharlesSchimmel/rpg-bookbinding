Scripts to format RPG PDFs for printing.

# About
I play a lot of indie RPGs. Many of them are out of print or are too small to 
support a print run, but still have a PDF version available to purchase.

Even on the best ereader, the experience of flipping through a digital RPG 
rulebook leaves much to be desired, particularly when you're flipping between 
different sections trying to explain the rules. 

I also love bookbinding, printing, and typesetting, so formatting, printing, and 
binding these books is a fun, tangential hobby.

I obviously can't redistribute PDFs that I've reformatted for printing, but I 
can share the formatting scripts.

# How to Use
- You will need source PDFs from itch.io or DriveThruRpg or wherever.
- Either:
    - Build the container image in <./docker>
    - Ensure that Ensure that `texlive-extra-utils` `texlive-latex-recommended` `pdftk` are installed.
- View the README in your desired RPG's subdirectory. Run the script in that subdirectory 
    with `./script.sh` or `podman run --rm -it -v './':/work -w /work pdftools 
    ./script.sh` if using the container image.

# Resources
- I found this blog helpful in understanding pdfjam: https://equa.space/notes/pdfjam/
