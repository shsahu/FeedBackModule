import pylab as plb
import scipy as sy
from scipy.optimize import curve_fit

def pow1(x, a, b):
  return a*x**b

def pow2(x, a, b,c):
  return a*x**b+c

# xdata =[]
# cpu_metric_data = []
# query_count_data = []
# datafile = open('data.csv', 'r')
# myreader = csv.reader(datafile)
# for row in myreader:
#     # print row[0]
#     # print row
#     xdata.append(row[0])
#     cpu_metric_data.append(row[2])
#     query_count_data.append(row[3])

#kernel trick linear reg


data = plb.loadtxt('data.csv')
x = data[:,0]
cpu_metric_data= data[:,2]
query_count_data=data[:,3]

p0 = sy.array([1,1])
coeffs, matcov = curve_fit(pow1, x, cpu_metric_data,p0)
print(coeffs)
p0 = sy.array([1,1,1])
coeffs, matcov = curve_fit(pow2, x, query_count_data,p0)
print(coeffs)
