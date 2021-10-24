#!/bin/bash
# Generate maps
map_files=(
    "./maps/DeadSpace/M.01 Ishimura (UT).dmm"
    "./maps/DeadSpace/M.02 Ishimura (T).dmm"
    "./maps/DeadSpace/M.03 Ishimura (L).dmm"
    "./maps/DeadSpace/M.04 Ishimura (M).dmm"
    "./maps/DeadSpace/M.05 Ishimura (U).dmm"
    "./maps/DeadSpace/M.06 Aegis VII.dmm"
)

tools/github-actions/nanomap-renderer minimap -w 2240 -h 2240 "${map_files[@]}"

# Move and rename files so the game understands them
cd "data/nanomaps"

mv "M.01 Ishimura (UT)_nanomap_z1.png" "Ishimura-1.png"
mv "M.02 Ishimura (T)_nanomap_z1.png" "Ishimura-2.png"
mv "M.03 Ishimura (L)_nanomap_z1.png" "Ishimura-3.png"
mv "M.04 Ishimura (M)_nanomap_z1.png" "Ishimura-4.png"
mv "M.05 Ishimura (U)_nanomap_z1.png" "Ishimura-5.png"
mv "M.06 Aegis VII_nanomap_z1.png" "Ishimura-6.png"

cd "../../"
cp data/nanomaps/* "nano/images/ishimura"