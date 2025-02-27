#!/bin/bash
#!
#! SLURM job script for SIMUnet
#!

#! Name of the job:
#SBATCH -J evolven3fit
#! Account name for project charging:
#SBATCH -A MPHIL-DIS-SL2-CPU
#! Use the Cascade Lake partition (you can change to icelake if needed)
#SBATCH -p cclake
#! Number of nodes required:
#SBATCH --nodes=1
#! Number of tasks (set to 1 since this is not an MPI job):
#SBATCH --ntasks=1
#! Number of CPUs per task (adjust as needed):
#SBATCH --cpus-per-task=2
#! Memory per CPU (defaults to ~3420 MB, adjust if needed):
#SBATCH --mem=6840MB
#! Maximum wallclock time for the job:
#SBATCH --time=10:00:00
#! Output and error files:
#SBATCH --output=log_files/evolven3fit%j.out
#SBATCH --error=log_files/evolven3fit%j.err
#! Email notifications (uncomment and set your email if needed):
##SBATCH --mail-type=ALL
#SBATCH --mail-user=lc2010@cam.ac.uk

# Load system environment modules
. /etc/profile.d/modules.sh
module purge
module load rhel8/default-ccl

echo "Setting up conda env"
# Activate Conda environment
source /home/lc2010/miniconda3/etc/profile.d/conda.sh
conda activate simunet

echo "Switching to SIMUnet dir"
cd /home/lc2010/rds/hpc-work/simunet_git/SIMUnet

echo "Evolving fit"

# Run the command
#evolven3fit quick 1000

# Or if you are doing fixed-pdf fit
vp-fakeevolve quick 10