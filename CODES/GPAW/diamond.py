"""
Simple GPAW example: Energy of a 2x2x2 cubic diamond supercell
"""
from ase.build import bulk
from ase.parallel import parprint
from gpaw import GPAW, FD

# Create diamond primitive cell and make 2x2x2 supercell
diamond = bulk('C', 'diamond', a=3.567)
supercell = diamond.repeat((2, 2, 2))

parprint(f"Number of atoms: {len(supercell)}")
parprint(f"Cell volume: {supercell.get_volume():.2f} Å³")

# Set up GPAW calculator with plane-wave mode
calc = GPAW(
    mode=FD(),         # Finite differences
    h=0.2,             # Real-space grid spacing 0.2 A
    xc='LDA',          # PBE exchange-correlation functional
    txt='gpaw.txt'     # Output file
)

supercell.calc = calc

# Compute energy
energy = supercell.get_potential_energy()

parprint(f"Total energy: {energy:.6f} eV")
parprint(f"Energy per atom: {energy/len(supercell):.6f} eV")
