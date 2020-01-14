import pystan

sm = pystan.StanModel(file='hello.stan')
hello = sm.sampling(data={'n': 7, 'y': 5, 'a': 4, 'b':2}, n_jobs=-1)
print hello
