import sys
import numpy as np


# n = sys.argv[1]  : number of servers (server ids are from 0 to n-1)
NUMBER_OF_SERVERS = 4
if len(sys.argv) > 1:
    NUMBER_OF_SERVERS =int(sys.argv[1])

if len(sys.argv) > 2:
    THRESHOLD = int(sys.argv[2])

def calculateNthPercentile(n):
    percentileDataArray = []

    for i in range(0,NUMBER_OF_SERVERS):
        dataArray = np.loadtxt('serverLog/server'+str(i)+'_cpu_idle.log')
        percentileValue = np.percentile(dataArray, 100-n);
        percentileDataArray.append(100-percentileValue)

    return percentileDataArray


def calculateStandardDeviation(percentileDataArray):
    stdeviation = np.std(percentileDataArray)
    return stdeviation


def checkUsageAndCalculateParameters():
    percentileDataArray = calculateNthPercentile(90)
    if len(percentileDataArray)>0:
        result = calculateStandardDeviation(percentileDataArray)
        print result


if __name__== "__main__":
    checkUsageAndCalculateParameters()
    #calculateParameters()






####### second way ###########
# n=[]
# for i in a:
#     n.append(100-i)
#
# #print n, len(n)
# p = np.percentile(n, 90)
# print p


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




