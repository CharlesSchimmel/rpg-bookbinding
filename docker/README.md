For convenience you can use a container image to build PDFs.

Build the image with `podman build -t pdftools`, then run individual scripts 
with `podman run --rm -it -v "./":/work -w /work pdftools ./work.sh`.
