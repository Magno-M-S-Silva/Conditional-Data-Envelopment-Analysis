# Conditional-Data-Envelopment-Analysis
Order-m CDEA based on 'Introducing Environmental Variables in Nonparametric Frontier Models: a Probabilistic Approach' from Daraio and Simar 2005

The main script is 'io_order_m_cdea.m', the rest are auxiliary functions that may be used for simpler versions of DEA.
Fill in lines 2,3,4 and lines 39 and 40 with your variables and the resampling parameters.

Input oriented case. At the moment it only works for a univariate conditional variable, the bandwidth selection method used was k-nearest neighbours.
Contrary to the original paper I capped efficiency at 1 and used a looser restriction both on resampling and the final DEA. For details just contact me.

magmenecopuc@hotmail.com
