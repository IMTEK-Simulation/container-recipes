NEMO2
=====

*Important:*

* You need to specify `--userns` after Apptainers `run` or `exec` command!

An example job submission script looks like this:

```bash
#!/bin/bash
#SBATCH --job-name=mpiBench
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=64
#SBATCH --time=00:14:00
#SBATCH --mem-per-cpu=1gb

echo "ID/NAME:    $SLURM_JOB_ID / $SLURM_JOB_NAME"
echo "USER:       $SLURM_JOB_USER"
echo "PARTITION:  $SLURM_JOB_PARTITION"
echo "TASKS:      $SLURM_TASKS_PER_NODE tasks/node x $SLURM_JOB_NUM_NODES nodes = $SLURM_NTASKS tasks"
echo "NODES:      $SLURM_JOB_NODELIST"

srun apptainer exec --userns nemo2.sif /opt/mpiBench/mpiBench
```

Benchmarks
----------

* 1 node, 64 tasks per node:
```
Effective per-process bandwidth (in MB/sec) 
DATA 
Collected:  -  
Alltoall   ppn       64
 msgsize nodes        1
       0          0.000
       1          5.486
       2         12.539
       4         27.056
       8         51.225
      16         85.941
      32        150.201
      64        248.089
     128        346.754
     256        398.571
     512        502.859
      1K        604.620
      2K       1169.061
      4K        809.917
      8K       1071.680
     16K       1062.374
     32K        900.350
     64K        859.990
    128K        927.121
    256K       1062.248
```

* 2 nodes, 64 tasks per node:
```
Effective per-process bandwidth (in MB/sec) 
DATA 
Collected:  -  
Alltoall   ppn      64
 msgsize nodes       2
       0         0.000
       1         5.393
       2        11.803
       4        23.258
       8        44.590
      16        78.338
      32       127.617
      64       184.306
     128       238.379
     256       271.501
     512       288.261
      1K       204.370
      2K       431.263
      4K       487.593
      8K       596.123
     16K       640.955
     32K       605.501
     64K       552.296
    128K       564.348
    256K       608.883
```

* 4 nodes, 64 tasks per node:
```
Effective per-process bandwidth (in MB/sec) 
DATA 
Collected:  -  
Alltoall   ppn      64
 msgsize nodes       4
       0         0.000
       1         7.287
       2        15.182
       4        27.235
       8        49.965
      16        81.596
      32       105.688
      64       136.203
     128       157.444
     256       155.281
     512       160.935
      1K        41.508
      2K       177.508
      4K       224.284
      8K       383.660
     16K       138.656
     32K       413.281
     64K       417.714
    128K       308.305
    256K       239.758
```

* 8 nodes, 64 tasks per node:
```
Effective per-process bandwidth (in MB/sec) 
DATA 
Collected:  -  
Alltoall   ppn      64
 msgsize nodes       8
       0         0.000
       1        10.085
       2        20.782
       4        37.221
       8        59.387
      16        83.269
      32       108.797
      64       130.072
     128       143.424
     256       150.422
     512       152.448
      1K        22.439
      2K        66.487
      4K       107.149
      8K       318.339
     16K        85.719
     32K       158.326
     64K       119.946
    128K        72.740
    256K       236.320

