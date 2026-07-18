# Trying a Makefile to use the built-in change detection. We don't need to
# recompile signatures every time, etc.
#
# It sort of works, but since it _is_ the source file that's being changed, it
# doesn't really make sense.

buildDir := ./build
printDir := ./print
signaturesPath := $(buildDir)/signatures_all_tumble.pdf
duplexPath=$(printDir)/Beak Feather Bone - Duplex.pdf

all: $(duplexPath)

$(duplexPath): $(buildDir)/signatures_odd.pdf $(buildDir)/signatures_even.pdf
	pdftk A=build/signatures_odd.pdf B=build/signatures_even.pdf shuffle A B output build/signatures_all_duplex.pdf
	cp './build/signatures_all_duplex.pdf' '$(duplexPath)'

reversed: $(signaturesPath)
	pdftk "$(signaturesPath)" cat even-1 output build/signatures_even_reversed.pdf

$(buildDir)/signatures_odd.pdf: $(signaturesPath)
	pdftk "$(signaturesPath)" cat oddsouth output build/signatures_odd.pdf

$(buildDir)/signatures_even.pdf: $(signaturesPath)
	pdftk "$(signaturesPath)" cat even output build/signatures_even.pdf

$(signaturesPath): 
	pdfjam \
		--signature 32 \
		--landscape \
		--paper letter \
		--outfile "$(signaturesPath)" \
		'./Beak Feather and Bone - Digital and Print.pdf'

clean:
	rm './build/*'

