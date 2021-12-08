# ASSA

Atom Surface Scattering Analysis

## Analyse spin echo data in the energy domain

### Generate the spectrum

All the measurements HeSE takes now is stored in a .mat file, so It will be most convenient to use MATLAB to analyse them. First of all, we give an example file (*examples/dy018713.mat*). In order to analyse it in the energy domain, or to extract the phonon spectrum, one can do the following:

In the ASSA folder, use the cammands:

```matlab
postprocess_dyfiles.postprocess_dyfile('initStr','examples/dy0','NumVec',[18713],'reProcessing',1,'fixFalsePositive',1);
res = fit_dyFiles.prepare_measured_set_for_fitting('initStr','examples/dy0','NumVec',[18713]);
```

To look at the phonon spectrum, we can do

```matlab
plot(res(1).Energ_meV,res(1).SKw)
axis([-5 15 0 1e9]); xlabel('\DeltaE/meV'); ylabel('Intensity/arbitrary units');
```

The spectrum should be generated as shown below.

<img src="https://github.com/Cambridge-Atom-Scattering-Centre/ASSA/blob/main/examples/dy018713.jpg" width="600">

#### An explanation of the commands

* `postprocess_dyfiles.postprocess_dyfiles` is a function used to process the raw data files that contains dynamics measurements. The original .mat file has only one structure called `meas`, which contains all the raw data. This function creates an additional structure called `processed_meas`, which is the processed data.
  * In the example, the file's name is `'examples/dy018713'`, which are split into `'examples/dy0'` and `[18713]`. `'examples/dy0'` is the `'initStr'` variable, and `[18713]` is the `'NumVec'` variable. You can put a vector containing multiple numbers, to process multiple files in a certain folder.
  * If `'reProcessing'` is set to `1`, the script will postprocess the files again even if it has been processed. If `'reProcessing'` is `0`, the function will not do anything to it.
  * Sometimes the system can have a glitch and the signal will have an outlier. In that case we will set `'fixFalsePositive'` to `0` in order to fix that. In the current example it is not needed, so `'fixFalsePositive'` is `1`.
* `fit_dyFiles.prepare_measured_set_for_fitting` further process the data in `processed_meas`, and saves the data into a structrue called `res`. The phonon spectrum as a function of energy transfer is stored in `res(1).Energ_meV` and `res(1).SKw`.

### Additional features of `postprocess_dyfiles.postprocess_dyfiles`

The raw data taken in a typical spin echo measurement, such as examples/dy018713.mat, can be extracted and plotted using
```matlab
figure; hold on
load('examples/dy018713.mat')
plot(meas.ibase,meas.mean.Preal,'color','r');
plot(meas.ibase,meas.mean.Pimag,'color','b');
xlabel('base current/A'); ylabel('Spin polarisation'); legend('real','imaginary');
```
The result should look like:

<img src="https://github.com/Cambridge-Atom-Scattering-Centre/ASSA/blob/main/examples/dy018713_pol.jpg" width="600">

This file actually shows the simplest case. There is no outlier in the data. If you look at the solenoid current you will find that it is equally spaced. However, that may not always be the case. There can be various features in the data that need dealing with, which are listed below.

#### Outliers in the data.
An example of such a case can be found in examples/dy018863.mat. Use the following commands again.

```matlab
figure; hold on
load('examples/dy018863.mat')
plot(meas.ibase,meas.mean.Preal,'color','r');
plot(meas.ibase,meas.mean.Pimag,'color','b');
xlabel('base current/A'); ylabel('Spin polarisation'); legend('real','imaginary');
```

we can find that the signal does have an outlier at around 0.83 A.

<img src="https://github.com/Cambridge-Atom-Scattering-Centre/ASSA/blob/main/examples/dy018863_pol.jpg" width="600">

In order to fix that, we can change `'fixFalsePositive'` from `1` to `0`, so the postprocessing will become

```matlab
postprocess_dyfiles.postprocess_dyfile('initStr','examples/dy0','NumVec',[18863],'reProcessing',1,'fixFalsePositive',0);
```
This will give you a panel where MATLAB automatically identifies the outliers and marks them in red, as shown below. Some points are wrongly identified as outliers. You can right-click to remove them. If the function did not recognise some outliers, you can also manually add them by left-clicking them. After marking all the outliers in red, simply press Enter to go to the next figure or to finish.

<img src="https://github.com/Cambridge-Atom-Scattering-Centre/ASSA/blob/main/examples/dy018863_removespikes.jpg" width="600">

After the outliers are removed, by default there will just be a "hole" in the data. However, sometimes that is undesirable, especially when we are measuring phonons, becuase we need to Fourier transform the data. We can add `,'keepIlength',1` to the arguments of the function. which will "fill the holes" by linearly interpolating the neighbouring data points.

#### The solenoid current not evenly spaced

examples/dy019253 is an example measurement in which the solenoid current is not evenly spaced. We can look at the measurement by typing the following commands in MATLAB.

```matlab
figure; hold on
load('examples/dy019253.mat')
plot(meas.ibase,meas.mean.Preal,'o','color','r');
plot(meas.ibase,meas.mean.Pimag,'o','color','b');
xlabel('Solenoid current/A'); ylabel('Spin polarisation'); legend('real','imaginary');
```

The result should look like:

<img src="https://github.com/Cambridge-Atom-Scattering-Centre/ASSA/blob/main/examples/dy019253_pol_o.jpg" width="600">

You will find that obviously the current is not evenly spaced, so in principle you cannot use Fast Fourier Transform (fft) to process that. In order to get around this, you can linearly interpolate it by adding `,'intpI',linspace(0,10,2001)` as an argument of the `postprocess_dyfiles.postprocess_dyfile` function.

```matlab
postprocess_dyfiles.postprocess_dyfile('initStr','examples/dy0','NumVec',[19253],'fixFalsePositive',1,'reProcessing',1,'intpI',0:0.001:8);
res = fit_dyFiles.prepare_measured_set_for_fitting('initStr','examples/dy0','NumVec',[19253]);
```

The polarisation will be interpolated now, use

```matlab
plot(res(1).Energ_meV,res(1).SKw)
axis([-5 15 0 1e9]); xlabel('\DeltaE/meV'); ylabel('Intensity/arbitrary units');
```

to see the spectrum:

<img src="https://github.com/Cambridge-Atom-Scattering-Centre/ASSA/blob/main/examples/dy019253_pho.jpg" width="600">

When interpolating the data, try to keep the range of the query points within the range of data points. For example, don't make `'intpI'` be `0:0.001:100` if `meas.ibase` is only from 0 A to 10 A. If not, there can be significant distortion in the generated spectrum.
