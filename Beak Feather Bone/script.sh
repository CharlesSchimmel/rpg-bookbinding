#!/bin/bash
set -euo pipefail

buildDir="./build"

mkdir -p print $buildDir

cp './BFB Map - High Quality Print.pdf' print/

# --trim: left bottom right top
# ex: --trim '15mm 10mm 15mm 10mm'

# Generate spreads; useful for checking the final result.
# pdfjam \
#     --nup 2x1 \
#     --landscape \
#     --paper letter \
#     --clip true \
#     --outfile spreads.pdf \
#     './Beak Feather and Bone - Digital and Print.pdf'

signaturesPath="$buildDir/signatures_all_tumble.pdf"

# The argument to --signature is the total number of pages (fronts and backs)
# per signature. It must be a multiple of 4, and the number of sheets used is
# signature/4. In this case, 8.
pdfjam \
    --signature 32 \
    --landscape \
    --paper letter \
    --outfile "$signaturesPath" \
    './Beak Feather and Bone - Digital and Print.pdf'

# In this case, the PDF has 32 pages, so `--booklet true` is functionally the
# same as a signature of 32 pages
# pdfjam \
#     --booklet true \
#     --landscape \
#     --paper letter \
#     --outfile "build/booklet.pdf" \
#     './Beak Feather and Bone - Digital and Print.pdf'

# By default, the `--signature` and `--booklet` options generate a document
# formatted for "tumble" printing, where one side is printed and then flipped
# vertically before printing the other side. This is more common in large-scale
# printing; if you're printing on a home or office printer, you don't want
# that, so we have to flip it back upright.
#
# More recent versions of pdfjam give the `--no-otheredge` option which
# disables this. Otherwise, we need to divide, flip, and shuffle the pages to
# undo it. The `__south` option to `pdftk cat` flips the page 180'.
pdftk "$signaturesPath" cat oddsouth output build/signatures_odd.pdf
pdftk "$signaturesPath" cat even output build/signatures_even.pdf

# If your printer doesn't support "duplex" printing (printing both sides on the
# same pass), you'll need to print off the odd sides, take the stack of paper,
# and print the even sides on the backs.
#
# In that case, you'll print `signatures_odd.pdf`; take the stack of paper and
# put it back into the paper supply; then print `signatures_even_reversed`.
pdftk "build/signatures_even.pdf" cat end-1 output build/signatures_even_reversed.pdf

# This generates a document suitable for true duplex printing.
pdftk A=build/signatures_odd.pdf B=build/signatures_even.pdf shuffle A B output build/signatures_all_duplex.pdf

cp build/signatures_all_duplex.pdf print/'Beak Feather Bone - Duplex.pdf'
echo Done: ./print/Beak Feather Bone - Duplex.pdf
