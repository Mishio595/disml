# Helper script for running atdgen

for filename in ./lib/models/gen/*.atd; do
    [ -e "$filename" ] || continue
    atdgen -t $filename
    atdgen -j $filename
done