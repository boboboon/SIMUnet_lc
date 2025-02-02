#!/bin/bash
#!
#! SLURM job script for Peta4-CascadeLake (Cascade Lake CPUs, HDR IB)
#! Configured for SIMUnet job submission with Miniconda environment
#!

#! sbatch directives begin here ###############################
#! Name of the job:
#SBATCH -J simunet_job
#! Which project should be charged:
#SBATCH -A MPHIL-DIS-SL2-CPU
#! Partition (Cascade Lake CPUs):
#SBATCH -p cclake
#! Number of nodes:
#SBATCH --nodes=1
#! Number of (MPI) tasks in total (<= nodes*56 for Cascade Lake):
#SBATCH --ntasks=56
#! Maximum wallclock time (adjust as needed):
#SBATCH --time=04:00:00
#! Email notifications (set to ALL, NONE, BEGIN, END, FAIL if needed):
#SBATCH --mail-type=NONE
#! Output and error log files:
#SBATCH --output=simunet_%j.out
#SBATCH --error=simunet_%j.err
#! Uncomment this to prevent requeueing in case of node failure/system downtime:
##SBATCH --no-requeue

#! sbatch directives end here ###############################

#! Number of nodes and tasks per node allocated by SLURM (do not change):
numnodes=$SLURM_JOB_NUM_NODES
numtasks=$SLURM_NTASKS
mpi_tasks_per_node=$(echo "$SLURM_TASKS_PER_NODE" | sed -e 's/^\([0-9][0-9]*\).*$/\1/')

#! Load required environment modules
. /etc/profile.d/modules.sh  # Enables module command
module purge                 # Clears all loaded modules
module load rhel8/default-ccl  # REQUIRED - loads the basic environment

#! Activate Miniconda and the SIMUnet environment
export PATH="/home/lc2010/miniconda3/bin:$PATH"
source activate simunet

#! Set working directory
workdir="/home/lc2010/rds/hpc-work/simunet_git/SIMUnet"
cd $workdir
echo -e "Changed directory to `pwd`.\n"

#! Set OpenMP threads (adjust if using OpenMP)
export OMP_NUM_THREADS=1

#! MPI pinning settings (from template)
export I_MPI_PIN_DOMAIN=omp:compact # Domains are $OMP_NUM_THREADS cores in size
export I_MPI_PIN_ORDER=scatter # Adjacent domains have minimal sharing of caches/sockets

#! Define commands for SIMUnet
CMD1="vp-setupfit runcard.yaml"
CMD2="vp-rebuild-data runcard_folder"
CMD3="n3fit runcard.yaml replica_number"
CMD4="evolven3fut runcard_folder replica_number"
CMD5="postfit final_replica_number runcard_folder"

#! Debugging output before execution
echo -e "JobID: $SLURM_JOB_ID\n======"
echo "Time: $(date)"
echo "Running on master node: $(hostname)"
echo "Current directory: $(pwd)"
echo -e "\nnumtasks=$numtasks, numnodes=$numnodes, mpi_tasks_per_node=$mpi_tasks_per_node (OMP_NUM_THREADS=$OMP_NUM_THREADS)"

if [ "$SLURM_JOB_NODELIST" ]; then
    export NODEFILE=$(generate_pbs_nodefile)
    cat $NODEFILE | uniq > machine.file.$SLURM_JOB_ID
    echo -e "\nNodes allocated:\n================"
    cat machine.file.$SLURM_JOB_ID | sed -e 's/\..*$//g'
fi

#! Execute the commands in sequence
echo -e "\nExecuting commands:\n=================="
echo "$CMD1"; eval $CMD1
echo "$CMD2"; eval $CMD2
echo "$CMD3"; eval $CMD3
echo "$CMD4"; eval $CMD4
echo "$CMD5"; eval $CMD5

echo "Job completed successfully!"
