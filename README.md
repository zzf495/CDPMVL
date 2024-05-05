# CDPMVL: Consensus and Diversity-fusion Partial-view-shared Multi-view Learning

## Introduction

CDPMVL is an algorithm that partitions data into three parts: (a) consensual part; (b) partial-view-shared part; and (c) specific part. It learns consensus and partial-view-shared knowledge for clustering. Some visualisation results on YALE are as follows (please refer to ```./visualization/``` for more).

| <img src= './visualization/Fig/Yale_1.tiff' width='400px'/> | ![Yale_2](./README/Figure/Yale_2-1714903166087-1.gif) | ![Yale_3](./README/Figure/Yale_3-1714903167897-3.gif) |
| ----------------------------------------------------------- | ----------------------------------------------------- | ----------------------------------------------------- |
| ![Yale_4](./README/Figure/Yale_4-1714903171254-5.gif)       | ![Yale_5](./README/Figure/Yale_5-1714903173252-7.gif) | ![Yale_6](./README/Figure/Yale_6-1714903174914-9.gif) |

## Example usage

- Use ```addpath('./utils/');``` and ```addpath(genpath('./utils/'))``` to add the required auxiliary functions, after which you can use ``` CDPMVL(fea, gt, options)```to call CDPMVL wherever you need to.

- You can launch the program by executing "demo_YALE.m" in the root directory (in windows) on ```Matlab```

```python
demo_YALE.m
```

- or use the following command to run it in Linux (The output will be stored in "fill.out"). The codes will be run directly without errors.

```Cpython
nohup matlab <demo_YALE.m> fill.out &
```

## Files

├─ **demo_YALE.m**: A demo that runs CDPMVL on YALE.  
├─ CDPMVL: A series of functions that implement CDPMVL  
├─ utils: A series of auxiliary functions.   
└─visualization: Some experimental results of visualization performed on CDPMVL.  