#!/bin/bash
#!
#! SLURM job script for SIMUnet
#!

#! Name of the job:
#SBATCH -J n3fit
#! Account name for project charging:
#SBATCH -A MPHIL-DIS-SL2-CPU
#! Use the Cascade Lake partition (you can change to icelake if needed)
#SBATCH -p cclake
#! Number of nodes required:
#SBATCH --nodes=1
#! Number of tasks (set to 1 since this is not an MPI job):
#SBATCH --ntasks=1
#! Number of CPUs per task (adjust as needed):
#SBATCH --cpus-per-task=1
#! Memory per CPU (defaults to ~3420 MB, adjust if needed):
#SBATCH --mem=6840MB
#! Maximum wallclock time for the job:
#SBATCH --time=20:00:00
#! Output and error files:
#SBATCH --output=log_files/n3fit_%A_%a.out
#SBATCH --error=log_files/n3fit_%A_%a.err
#! Job array (0 to 10)
#SBATCH --array=0-10

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

echo "Running fit for job $SLURM_ARRAY_TASK_ID"
# Run the command
n3fit quick.yaml $SLURM_ARRAY_TASK_ID
