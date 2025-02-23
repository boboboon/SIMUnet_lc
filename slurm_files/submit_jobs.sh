#!/bin/bash
# submit_jobs.sh

# Submit the first job
jobid_setup=$(sbatch setup_slurm.sh | awk '{print $4}')

# Submit the second job, dependent on the first finishing successfully
jobid_n3fit=$(sbatch --dependency=afterok:$jobid_setup n3fit_slurm.sh | awk '{print $4}')

# Submit the third job, dependent on the second finishing successfully
jobid_evolven3=$(sbatch --dependency=afterok:$jobid_n3fit evolven3fit_slurm.sh | awk '{print $4}')

# Submit the final job, dependent on the third finishing successfully
sbatch --dependency=afterok:$jobid_evolven3 finalisefit_slurm.sh
