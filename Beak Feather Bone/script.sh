#!/bin/bash
set -euo pipefail

buildDir="./build"

mkdir -p print $buildDir

cp './BFB Map - High Quality Print.pdf' print/

# --trim: left bottom right top
# ex: --trim '15mm 10mm 15mm 10mm'

signaturesPath="$buildDir/signatures_all_tumble.pdf"
pdftk './Beak Feather and Bone - Digital and Print.pdf' cat 1-5 16-end output 'build/rulebook without roles.pdf'

echo Creating signatures
# The argument to --signature is the total number of pages (fronts and backs)
# per signature. It must be a multiple of 4, and the number of sheets used is
# signature/4. In this case, 8.
# pdfjam -q \
#     --signature 32 \
#     --shortedge true \
#     --landscape \
#     --paper letter \
#     --outfile "$signaturesPath" \
#     './Beak Feather and Bone - Digital and Print.pdf'

# In this case, the PDF has 32 pages, so `--booklet true` is functionally the
# same as a signature of 32 pages
pdfjam -q \
    --signature 32 \
    --shortedge true \
    --landscape \
    --paper letter \
    --outfile "$signaturesPath" \
    './Beak Feather and Bone - Digital and Print.pdf'

echo "Fixing odd pages"
# By default, the `--signature` and `--booklet` options generate a document
# formatted for "tumble" printing, where one side is printed and then flipped
# vertically before printing the other side. This is more common in large-scale
# printing; if you're printing on a home or office printer, you don't want
# that, so we have to flip it back upright.
#
# More recent versions of pdfjam give the `--no-otheredge` or `--shortedge` 
# option which disables this. Otherwise, we need to divide, flip, and shuffle 
# the pages to undo it. The `__south` option to `pdftk cat` flips the page 180'.
pdftk "$signaturesPath" cat odd output build/signatures_odd.pdf
pdftk "$signaturesPath" cat even output build/signatures_even.pdf

echo "Reversing even pages (for simplex printing)"
# If your printer doesn't support "duplex" printing (printing both sides on the
# same pass), you'll need to print off the odd sides, take the stack of paper,
# and print the even sides on the backs.
#
# In that case, you'll print `signatures_odd.pdf`; take the stack of paper and
# put it back into the paper supply; then print `signatures_even_reversed`.
pdftk "build/signatures_even.pdf" cat end-1 output build/signatures_even_reversed.pdf

echo "Recombining into true duplex document"
# This generates a document suitable for true duplex printing.
pdftk A=build/signatures_odd.pdf B=build/signatures_even.pdf shuffle A B output build/signatures_all_duplex.pdf

cp build/signatures_all_duplex.pdf print/'Beak Feather Bone - Duplex.pdf'
cp build/signatures_odd.pdf print/'Beak Feather Bone - Simplex - Fronts.pdf'
cp build/signatures_even_reversed.pdf print/'Beak Feather Bone - Simplex - Backs (Reversed).pdf'

echo Generating Role sheet
pdftk './Beak Feather and Bone - Digital and Print.pdf' cat 6-15 output 'build/roles.pdf'
pdfjam -q \
    --nup 4x2 \
    --landscape \
    --paper letter \
    --outfile 'print/Beak Feather Bone Roles - 4x2.pdf' \
    'build/roles.pdf'

pdfjam -q \
    --nup 2x2 \
    --paper letter \
    --outfile 'print/Beak Feather Bone Roles - 2x2.pdf' \
    'build/roles.pdf'

echo Done.
