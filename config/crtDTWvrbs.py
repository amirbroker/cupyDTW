import os
import math
import numpy as np


def readBIN(path, name):  # Read BIN file
    with open(f"{path}/{name}", "rb") as f:
        arrayList = np.fromfile(f, dtype=np.float32)
        return arrayList


def seqNameList(path):  # list of all sequences Files in path
    seqNameList = os.listdir(path)
    return seqNameList


def trgNameList(path):  # list of all target File in path
    trgNameList = os.listdir(path)
    return trgNameList


def lenOfEachSeqList(seqNameList):  # list of Length of each sequence
    return [int(x.replace(".bin", "")) for x in seqNameList]


def numOfEachSeqInFileList(
    seqNameList, lenOfEachSeqList, sequencesPath
):  # Create list of Number each sequence in each Files
    numOfEachSeqInFileList = []
    for seqName, lenSeq in zip(seqNameList, lenOfEachSeqList):
        seqArr = readBIN(sequencesPath, seqName)
        lenOfFile = len(seqArr)
        numOfEachSeqInFile = int(lenOfFile / lenSeq)
        numOfEachSeqInFileList.append(numOfEachSeqInFile)
    return numOfEachSeqInFileList


def createCudaFileBaseOfSeqANDTrg(
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
):  # This fun create cuda file bases of sequence and target
    num_featuresList = []
    divList = []
    penaltyHereNUMList = []
    WARP_SIZEList = []
    for WARP_SIZE in range(32, 0, -1):  # maximum WARP_SIZE is 32
        for div in range(
            1, 45
        ):  # The amount of registers per thread is limited to 256 on modern CUDA-enabled GPUs then maximum div is 256/4 = 64 but in my GPU is 44
            num_features = div * WARP_SIZE - 1
            if (num_features + 1 - div) <= lenSeq <= num_features:
                penaltyHereNUM = div - (num_features + 1 - lenSeq)
                num_featuresList.append(num_features)
                divList.append(div)
                penaltyHereNUMList.append(penaltyHereNUM)
                WARP_SIZEList.append(WARP_SIZE)

    firstOfnum_featuresList = num_featuresList[0]
    firstDiv = divList[0]
    firstOfpenaltyHereNUMList = penaltyHereNUMList[0]
    firstOfWARP_SIZEList = WARP_SIZEList[0]
    #######################
    maxSeq = max(lenTrg, lenSeq)
    batch_size = math.log2(num_entries)
    batch_size = min(
        math.ceil(batch_size), 19
    )  # maximum of batch size in my GPU is 2^19

    lengthLoad = lenSeq * num_entries
    #######################
    delete_line_lists = (
        [f"penalty_here{delete_line}" for delete_line in range(firstDiv, 350)]
        + [
            f"const value_t subject_value{delete_line}"
            for delete_line in range(firstDiv, 350)
        ]
        + [f"penalty_temp0 = penalty_here{firstDiv-1};"]
        + [f"penalty_temp1 = penalty_here{firstDiv-1};"]
    )

    with open(f"{configpath}/{dtwcudaname}", "rt") as fin:
        with open(f"{dtwcudapath}/{dtwcudaname}", "wt") as fout:
            for line in fin:
                if not any(del_line in line for del_line in delete_line_lists):
                    fout.write(
                        line.replace("_###", f"_{firstOfnum_featuresList}")
                        .replace("+!@#", f"+{firstDiv}")
                        .replace("!!!", f"{firstOfWARP_SIZEList}")
                        .replace("&&&", f"{firstOfpenaltyHereNUMList}")
                        .replace("%^&", f"{lenTrg+firstOfWARP_SIZEList}")
                        .replace("^@*$", f"{lenSeq}")
                        .replace("#%@&", f"{firstOfWARP_SIZEList-1}")
                        .replace("&%&@&", f"{firstDiv-1}")
                    )

    lookupFirst = (
        f"penalty_here{firstOfpenaltyHereNUMList} = (query_value-subject_value"
    )
    lookupSecond = f"	if(thid == {firstOfWARP_SIZEList-1})  Dist[blid] = sqrt( (float) penalty_here{firstOfpenaltyHereNUMList});"

    lineNUMF = []
    lineNUMS = []
    with open(f"{dtwcudapath}/{dtwcudaname}") as myFile:
        for num, line in enumerate(myFile, 1):
            if lookupFirst in line:
                lineNUMF.append(num)
            elif lookupSecond in line:
                lineNUMS.append(num)

    lines = []
    with open(f"{dtwcudapath}/{dtwcudaname}", "r") as fp:
        lines = fp.readlines()
    with open(f"{dtwcudapath}/{dtwcudaname}", "w") as fp:
        for number, line in enumerate(lines):
            if number not in range(lineNUMF[-1], lineNUMS[-1] - 1):
                fp.write(line)
    #######################
    with open(f"{configpath}/{maincudaname}", "r") as file:
        data = file.read()
        data = (
            data.replace("&*^", f"{num_entries}")
            .replace("$%^", f"{maxSeq}")
            .replace("&*@#!", f"{batch_size}")
            .replace("!&*%$", f"{lengthLoad}")
            .replace("#1%*$", f"{lenTrg}")
            .replace("^2*#$", f"{lenSeq}")
            .replace("9#@7*", f"{sequencesPath}")
            .replace("0*6%$(", f"{targetpath}")
            .replace("4$%#8&", f"{resultspath}")
        )
    with open(f"{maincudapath}/{maincudaname}", "w") as file:
        file.write(data)
