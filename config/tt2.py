from DTWs import *
import os
import math
from paths import *


# arr = os.listdir(resultspath)
# print(arr)


num_featuresList = []
divList = []
penaltyHereNUMList = []
WARP_SIZEList = []
for WARP_SIZE in range(32,0,-1):
    for div in range(1,45):
        num_features = div * WARP_SIZE - 1
        if (num_features + 1 - div) <= lenSeq <= num_features:
            penaltyHereNUM = div - (num_features + 1 - lenSeq)
            num_featuresList.append(num_features)
            divList.append(div)
            penaltyHereNUMList.append(penaltyHereNUM)
            WARP_SIZEList.append(WARP_SIZE)

print(num_featuresList[0])
print(divList[0])
print(penaltyHereNUMList[0])
print(WARP_SIZEList[0])

i = divList[0]

#######################
maxSeq = max(lenTrg,lenSeq) # ehtemalan tagher midam

batch_size = math.log2(num_entries)
batch_size = min(math.ceil(batch_size),19)

lengthLoad = lenSeq*num_entries
#######################
delete_line_lists = [f"penalty_here{delete_line}" for delete_line in range(i,350)]+[f"const value_t subject_value{delete_line}" for delete_line in range(i,350)]+[f"penalty_temp0 = penalty_here{i-1};"]+[f"penalty_temp1 = penalty_here{i-1};"]

with open(f"{dtwcudaname}", "rt") as fin:
    with open(f"{dtwcudapath}/{dtwcudaname}", "wt") as fout:
        for line in fin:
            if not any(del_line in line for del_line in delete_line_lists):
                fout.write(line.replace('_###', f'_{num_featuresList[0]}').replace('+!@#', f'+{divList[0]}').replace('!!!', f'{WARP_SIZEList[0]}').replace('&&&', f'{penaltyHereNUMList[0]}').replace('%^&', f'{lenTrg+WARP_SIZEList[0]}').replace('^@*$', f'{lenSeq}').replace('#%@&', f'{WARP_SIZEList[0]-1}').replace('&%&@&', f'{divList[0]-1}'))

lookupFirst = f'penalty_here{penaltyHereNUMList[0]} = (query_value-subject_value'
lookupSecond = f'	if(thid == {WARP_SIZEList[0]-1})  Dist[blid] = sqrt( (float) penalty_here{penaltyHereNUMList[0]});'

lineNUMF = []
lineNUMS = []
with open(f"{dtwcudapath}/{dtwcudaname}") as myFile:
    for num, line in enumerate(myFile, 1):
        if lookupFirst in line:
            lineNUMF.append(num)
        elif lookupSecond in line:
            lineNUMS.append(num)

print(lineNUMF[-1],lineNUMS[-1])
lines = []
with open(f"{dtwcudapath}/{dtwcudaname}", 'r') as fp:
    lines = fp.readlines()
with open(f"{dtwcudapath}/{dtwcudaname}", 'w') as fp:
    for number, line in enumerate(lines):
        if number not in range(lineNUMF[-1],lineNUMS[-1]-1):
            fp.write(line)
#######################
with open(f"{maincudaname}", 'r') as file:
    data = file.read()
    data = data.replace("&*^", f"{num_entries}").replace("$%^", f"{maxSeq}").replace("&*@#!", f"{batch_size}").replace("!&*%$", f"{lengthLoad}").replace("#1%*$", f"{lenTrg}").replace("^2*#$", f"{lenSeq}")
# print(data)
with open(f"{maincudapath}/{maincudaname}", 'w') as file:
    file.write(data)
######################### en ghasmat hazf shavad
# with open("/home/amir/Downloads/gpuDTW/testDTW.py", 'r') as file:
#     data = file.read()
#     data = data.replace("&*^", f"{lenSeq}").replace("$%^", f"{lenTrg}")
# # print(data)
# with open("/home/amir/pythonTest/testDTW2.py", 'w') as file:
#     file.write(data)
#
# with open("/home/amir/Downloads/gpuDTW/readBIN.py", 'r') as file:
#     data = file.read()
#     data = data.replace("&*^", f"{lenSeq}").replace("$%^", f"{lenTrg}")
# # print(data)
# with open("/home/amir/pythonTest/readBIN.py", 'w') as file:
#     file.write(data)