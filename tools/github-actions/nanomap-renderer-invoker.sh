#!/bin/bash
# Generate maps
map_files=(
    "./maps/USGIshimura/M.01 Ishimura (UT).dmm"
    "./maps/USGIshimura/M.02 Ishimura (T).dmm"
    "./maps/USGIshimura/M.03 Ishimura (L).dmm"
    "./maps/USGIshimura/M.04 Ishimura (M).dmm"
    "./maps/USGIshimura/M.05 Ishimura (U).dmm"
    "./maps/USGIshimura/M.06 Aegis VII.dmm"
    "./maps/TheColony/M.01_Mining_Colony_Underground.dmm"
    "./maps/TheColony/M.02_Mining_Colony.dmm"
    "./maps/TheColony/M.03_Mining_Colony_UpperLevels.dmm"
)

tools/github-actions/nanomap-renderer minimap -w 2240 -h 2240 "${map_files[@]}"

# Move and rename files so the game understands them
cd "data/nanomaps"

mv "M.01 Ishimura (UT)_nanomap_z1.png" "ishimura-1.png"
mv "M.02 Ishimura (T)_nanomap_z1.png" "ishimura-2.png"
mv "M.03 Ishimura (L)_nanomap_z1.png" "ishimura-3.png"
mv "M.04 Ishimura (M)_nanomap_z1.png" "ishimura-4.png"
mv "M.05 Ishimura (U)_nanomap_z1.png" "ishimura-5.png"
mv "M.06 Aegis VII_nanomap_z1.png" "ishimura-6.png"
mv "M.01_Mining_Colony_Underground_nanomap_z1.png" "colony-1.png"
mv "M.02_Mining_Colony_nanomap_z1.png" "colony-2.png"
mv "M.03_Mining_Colony_UpperLevels.dmm_nanomap_z1.png" "colony-3.png"

cd "../../"
cp data/nanomaps/ishimura-* "nano/images/ishimura"
cp data/nanomaps/colony-* "nano/images/colony"
