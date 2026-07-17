## Thermodynamic Modeling Framework



Institute of Thermal-, Environmental- and Resources’ Process Engineering,

Technische Universität Bergakademie Freiberg, Leipziger Str. 28, 09599 Freiberg, Germany



#### Overview



This repository contains parts of the MATLAB source code and experimental vapor–liquid equilibrium (VLE) database accompanying the publication:



*Tom Goldberg, Volker Herdegen, Andreas S. Braeuer*

*"Isobaric vapor-liquid equilibria of binary and multicomponent organic carbonate mixtures (DMC, EMC, DEC, EC, and PC) from 101.3 kPa to 5.0 kPa"*

*Journal of Chemical \& Engineering Data 2026*



The framework provides tools for managing experimental binary and ternary VLE data, fitting Gibbs excess models (see "Supported Models" below), performing VLE and residue curve map calculations, and generating corresponding diagrams.



**Redistribution or use of this software and/or the accompanying database, in whole or in part, requires appropriate citation of the associated publication.**



This repository is provided for reproducibility purposes; **the original publication/database should be considered the primary source for data usage**.



All third-party data associated with the publication have been removed. For clarity and simplicity, the uncertainty/error calculation has also been completely removed.



The code was developed using MATLAB 2023b. Compatibility with other MATLAB versions is not guaranteed, and differences in software versions may affect the execution, functionality, or results.



#### Repository Structure



root/
 - database/

&#x20;- helper\_functions/
 - thermodynamic\_modeling\_functions/

&#x20;- scripts/
 - main.m
 - README.md



*main.m* … is the main execution script for running the framework.



scripts/… contains the main workflow components that are executed by running the main.m file. The scripts are organized into: A) model fitting, B) model application to binary systems, and C) model application to ternary systems.



database/… contains *VLE\_DATA\_binary.json* and *VLE\_DATA\_ternary.json* files providing the experimental VLE data of the associated publication. The MATLAB data file *model\_parameters.mat* contains the parameters of all supported models, which can be updated by refitting the models to the experimental data. The MATLAB data file *modelConfig.mat* contains initial values and boundary conditions for model fitting.



helper\_functions/… contains auxiliary MATLAB functions for data handling.



thermodynamic\_modeling\_functions/… contains all MATLAB functions related to thermodynamic modeling, including the implementation of Gibbs excess models, VLE calculations, and parameter fitting to experimental data.



#### Running the Software

Run:



*main.m*



To run the software, the user only has to open *main.m* and execute the file. The program then guides the user through all available options by prompting for the corresponding inputs in the MATLAB Command Window.



#### Supported Models



Vapor pressure correlations:

* Antoine



Gibbs excess models:

* UNIQUAC-gl
* UNIQUAC-sep
* NRTL



Detailed information on the models is provided in the associated publication.



#### Citation

If this software, the accompanying database, or parts thereof are used in scientific work, the associated publication **must be cited**.



*Tom Goldberg, Volker Herdegen, Andreas S. Braeuer*

*"Isobaric vapor-liquid equilibria of binary and multicomponent organic carbonate mixtures (DMC, EMC, DEC, EC, and PC) from 101.3 kPa to 5.0 kPa"*

*Journal of Chemical \& Engineering Data 2026*



#### Disclaimer

This software and the accompanying experimental database are provided solely for scientific and research purposes.

Although every effort has been made to ensure the correctness of the implementation and the included data, the authors make **no representations or warranties**, express or implied, regarding the accuracy, completeness, reliability, or suitability of the software or data for any particular purpose.

The software and data are provided **"as is"**, without warranty of any kind. The authors shall not be held liable for any errors, omissions, or consequences arising from the use of this software or the accompanying data.

Users are solely responsible for verifying all calculations and results obtained using this repository.



#### Contact

For questions regarding the software or database, please contact the corresponding author of the associated publication.

