#!/bin/bash
set -euo pipefail

sourcePdf="$1"
buildDir="./build"

mkdir -p print $buildDir

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

echo "Creating signatures"
# The argument to --signature is the total number of pages (fronts and backs)
# per signature. It must be a multiple of 4, and the number of sheets used is
# signature/4. In this case, 8.
# pdfjam \
#     --signature 20 \
#     --landscape \
#     --paper letter \
#     --outfile "$signaturesPath" \
#     './Emissary v3 Digital Single-Page Layout.pdf'

# In this case, the PDF has 28 pages, so `--booklet true` is functionally the
# same as a signature of 28 pages
    # --booklet true \
pdfjam -q \
    --signature 28 \
    --landscape \
    --paper letter \
    --outfile "$signaturesPath" \
    "$sourcePdf"

echo "Fixing odd pages"
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

echo "Reversing even pages (for simplex printing)"
# If your printer doesn't support "duplex" printing (printing both sides on the
# same pass), you'll need to print off the odd sides, take the stack of paper,
# and print the even sides on the backs.
#
# In that case, you'll print `signatures_odd.pdf`; take the stack of paper and
# put it back into the paper supply; then print `signatures_even_reversed`.
pdftk build/signatures_even.pdf cat end-1 output build/signatures_even_reversed.pdf

echo "Recombining into true duplex document"
# This generates a document suitable for true duplex printing.
pdftk A=build/signatures_odd.pdf B=build/signatures_even.pdf shuffle A B output build/signatures_all_duplex.pdf

echo "Separating Color and B&W duplex sheets"
# Split out sheets that should be printed in color.
# In this case, just the first and last pages need to be printed in color.
# Because we're using booklet printing, that's just the front side of the first
# signature sheet, but we need to print its back too.
pdftk build/signatures_all_duplex.pdf cat 1-2 output build/signatures_all_duplex_color.pdf
pdftk build/signatures_all_duplex.pdf cat 3-end output build/signatures_all_duplex_bw.pdf

cp build/signatures_odd.pdf print/'Emissary - Simplex - Fronts.pdf'
cp build/signatures_even_reversed.pdf print/'Emissary - Simplex - Backs (Reversed).pdf'
cp build/signatures_all_duplex.pdf print/'Emissary - Duplex - All.pdf'
cp build/signatures_all_duplex_color.pdf print/'Emissary - Duplex - Color Pages Only.pdf'
cp build/signatures_all_duplex_bw.pdf print/'Emissary - Duplex - BW Pages Only.pdf'
echo Done.
