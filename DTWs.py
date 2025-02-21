from config.crtDTWvrbs import *
from config.paths import *
import os

seqNameList = seqNameList(sequencesPath)
lenOfEachSeqList = lenOfEachSeqList(seqNameList)
numOfEachSeqInFileList = numOfEachSeqInFileList(
    seqNameList, lenOfEachSeqList, sequencesPath
)
trgNameList = trgNameList(targetpath)
######################################################################## parameter for create cuda files
lenTrg = [int(x.replace(".bin", "")) for x in trgNameList][0]

errLen = []
for seqIND in range(2):
    num_entries = numOfEachSeqInFileList[seqIND]
    lenSeq = lenOfEachSeqList[seqIND]
    createCudaFileBaseOfSeqANDTrg(
        num_entries,
        lenTrg,
        lenSeq,
        dtwcudaname,
        configpath,
        dtwcudapath,
        maincudaname,
        sequencesPath,
        targetpath,
        resultspath,
        maincudapath,
    )
    runMain = os.system(
        "nvcc -O3 -std=c++14 -arch=sm_89 -Xcompiler='-fopenmp -march=native' /home/amir/cupyDTW/cuDTW/main.cu -o main"
    )
    cmpMain = os.system("./main")
    if runMain == cmpMain == 0:
        # os.remove("main")
        pass
    else:
        errLen.append(lenSeq)


with open("errFile.txt", "w") as f:
    for line in errLen:
        f.write(f"{line}\n")
