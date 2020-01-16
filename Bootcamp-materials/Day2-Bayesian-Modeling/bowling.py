import math
import numpy

def F(x):
  """This function returns the x-th Fibonacci number"""
  sqrt_5 = math.sqrt(5)
  golden_ratio = (1.0 + sqrt_5) / 2
  return round(golden_ratio**(x + 1) / sqrt_5)
  
def Pr(x, n = 10):
  p = F(x) / (-1 + F(n + 2)) if x <= n else 0
  return p
  
Omega = {0,1,2,3,4,5,6,7,8,9,10}

joint_Pr = numpy.zeros((11,11))
for x1 in range(0, 11):
  Pr_x1 = Pr(x1, n = 10)
  for x2 in range(0, 10 - x1 + 1):
    joint_Pr[x1, x2] = Pr_x1 * Pr(x2, n = 10 - x1)
    
    
