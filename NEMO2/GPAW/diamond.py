"""
Diamond DFT calculation with GPAW

This example performs a DFT calculation on a 2x2x2 supercell of diamond
using the finite-difference (FD) mode. It demonstrates parallel scaling
across multiple MPI ranks.

Usage:
    srun apptainer run gpaw.sif diamond.py
"""

from ase.build import bulk
from gpaw import GPAW, PW, FermiDirac

# Create 2x2x2 diamond supercell (16 atoms)
atoms = bulk('C', 'diamond', a=3.567) * (2, 2, 2)

# Set up GPAW calculator
# Using plane-wave mode for better parallel scaling
calc = GPAW(
    mode=PW(400),                    # Plane-wave cutoff 400 eV
    xc='PBE',                        # PBE exchange-correlation
    kpts=(4, 4, 4),                  # 4x4x4 k-point grid
    occupations=FermiDirac(0.1),     # Fermi smearing 0.1 eV
    txt='diamond.txt',               # Output file
    parallel={'domain': 1,           # Domain decomposition
              'band': 1},            # Band parallelization
)

atoms.calc = calc

# Run the calculation
energy = atoms.get_potential_energy()

print(f'\nDiamond 2x2x2 supercell (16 atoms)')
print(f'Total energy: {energy:.6f} eV')
print(f'Energy per atom: {energy/len(atoms):.6f} eV')
