import re
from collections import Counter

liberty = "timing_lib/sky130_fd_sc_hd__tt_025C_1v80.lib"
netlist = "synthesized_sky130_mac.v"

# Read Liberty and extract cell name -> area
with open(liberty, "r") as f:
    lib = f.read()

cell_area = {}

pattern = re.compile(
    r'cell\s*\(([^)]+)\)\s*\{.*?'
    r'area\s*:\s*([0-9.]+)\s*;',
    re.S
)

for name, area in pattern.findall(lib):
    name = name.strip('"')
    cell_area[name] = float(area)

# Count SKY130 cells instantiated in synthesized netlist
counts = Counter()

with open(netlist, "r") as f:
    for line in f:
        match = re.match(r'\s*(sky130_fd_sc_hd__\w+)\s+\w+\s*\(', line)
        if match:
            counts[match.group(1)] += 1

total_area = 0.0
missing = []

print("\nSKY130 MAC CELL AREA")
print("=" * 70)

for cell, count in sorted(counts.items()):
    if cell in cell_area:
        area = cell_area[cell]
        contribution = count * area
        total_area += contribution

        print(
            f"{cell:35s} "
            f"{count:6d} cells  "
            f"area={area:10.4f}  "
            f"total={contribution:12.4f}"
        )
    else:
        missing.append(cell)

print("=" * 70)
print(f"Total SKY130 cells : {sum(counts.values())}")
print(f"Total cell area    : {total_area:.4f}")
print(f"Area units         : Liberty library units")

if missing:
    print("\nWARNING: Missing Liberty cells:")
    for cell in sorted(missing):
        print(" ", cell)
