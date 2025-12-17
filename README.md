# Lyapunov Characteristic Exponents In Rock-Paper-Scissors Game

Compute Lyapunov Characteristic Exponents (LCEs) for the pestilent Rock–Paper–Scissors (RPS) mean-field ODE model.  
It uses a Benettin-style algorithm with Gram–Schmidt reorthonormalization and a 4th-order Runge–Kutta (RK4) integrator, and supports parameter sweeps in the pest strength `q`.

- **Core language**: C  
- **Automation**: Bash (`run.sh`)  
- **Plots**: gnuplot + LaTeX (`pdflatex`/`lualatex`)  

---

## Repository structure

```text
├── run.sh                 # main driver: sweeps q and runs (LCE/BIF/PLT) keys
├── makefile               # builds cp.out, lz.out, sn.out, sd.out
├── lce.h                  # model + numerical presets (ntr, nit, ipb, pa, pb=q, pc, x0,y0,z0)
├── src/
│   ├── lz.c               # main LCE computation + trajectory output
│   ├── cp.c               # critical points extractor (for bifurcation diagrams)
│   ├── sn.c               # sorts LCE output by q
│   ├── sd.c               # mean/std helper (GSL)
│   └── *.plt              # plotting scripts (gnuplot)
├── dat/                   # generated data files (.dat)
│   └── ps/                # per-q trajectories
└── plt/                   # generated figures (.pdf / .png)
    └── ps/                # per-q plots
```


## Quick Start

### Inputs and presets

All default parameters are defined in `lce.h`, including:

  * `ntr` : transient iterations discarded in the LCE accumulation
  * `nit` : iterations used for averaging
  * `ipb` : inner RK steps between reorthonormalizations
  * `pa`, `pb`, `pc` : model parameters (pb = q)
  * `x0`, `y0`, `z0` : initial conditions

### Running

1) Give execution permission to the main script:

  > chmod +x run.sh

2) Choose a range for the pest strength `q`:

  > ./run.sh 0.82 0.99 0.001

> [!IMPORTANT]
at the top of `run.sh` there are three keys: `LCE`, `BIF`, `PLT`.
  * `LCE=1`: Computes trajectories and appends LCEs into `dat/lce.dat` for each `q`.
  * `BIF=1`: Extracts critical points from trajectories and generates bifurcation datasets.
  * `PLT=1`: Produces phase-space, bifurcation diagram and LCE plots using gnuplot + LaTeX.
