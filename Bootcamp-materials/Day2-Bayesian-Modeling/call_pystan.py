import pystan
from numpy import genfromtxt

US_Open2010 = genfromtxt('US_Open2010.csv', delimiter=',', skip_header=1)
dat = {'N' : len(US_Open2010), 'roll_1' : US_Open2010[:,2].astype(int),
       'roll_2' : US_Open2010[:,3].astype(int), 'a' : 0.0} # fix a
sm = pystan.StanModel(file='simplest.stan', extra_compile_args=['-O3', '-g0'])
post = sm.sampling(data=dat, refresh=0)
print(pystan.misc._print_stanfit(post))
