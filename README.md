# paper boston 2019
this repository contains the code of my small paper that i wrote during to summer of 2019 with the lisp research group at boston university \
the paper was about predicting a specific modulation of an intercepted signal (iq samples). we studied different architectures that can be used to classifiy the signal. the results where pretty good however we used matlab to implement our models

## paper pdf
[pdf](paper_boston2019.pdf)

## outlook
this project is supposed to provide the basis for some hot stuff we came up with recently. first of all we need a python implementation of our existing models. furthermore we want to improve the models and the complete pipeline that was used before. so maybe we can increase our performance \
moreover we want to compare two completly different approaches that are used when it comes to modulation classification:
-   classification based on iq samples
    -   this is the approach we already chose for this implementation
-   classification based on spectrograms
    -   for this approach we evaluate the spectrograms of the signals to be classified. actually we dont fancy this way since a turns our time series of iq samples to an image increasing the dimension of the input massively. therefore we transfer a problem of communication system to a computer vision problem since cv is a nice ml use case that offers a lot of algorithms that can be applied easily. well, we kinda hope that we can show that the classification using iq samples outperforms spectrograms so thats the main reason for this project
