# THD Implementation

Source code for a THD implementation based on Matlab.
This code simulate a signal and samples it, applyies a window, zero-padding and estimates frequency components. After all, the THD calculation is done.

Ps: This code is part of an paper wich was submitted for review. As soon this article was accepted, the link and reference will be posted here.

## Usage

This scripts was written in Matlab 2016a. You must run the main script, **thd_proposed_method**. Other scripts are only support functions.

In thd_proposed_method, you will find a configuration field, wich is related to sampling frequency, period, selection of frequency of interest, window function and a possible center lob compensation (for amplitude estimation).

You can also change the simulated signal characteristics, if you want.

## Results

The results at high sampling periods (greatter than 2 seconds) was equivalent to *thd* function of Matlab. In lower sampling periods (0.8 ~ 1.4 seconds) the proposed method show better results when compared to exactly thd value (calculated before).

## Contribution

Any contribution is welcome. Please, if you doesn't understand something, or find some bug, feel free to contact me.
