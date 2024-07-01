outputFileName = str
waitTime = 0

def addHitBox(fileName):
    NoteList=[]
    hitBoxes = open(fileName,"r",encoding="UTF-8")
    for theHitBox in hitBoxes:
        theHitBox = list(map(int,theHitBox.split(" ")))
        NoteList.append([theHitBox,0,0])
    hitBoxes.close()
    return NoteList

def setRhythm(fileName,NoteList):
    rhythm = open(fileName,"r",encoding="UTF-8")
    i = 0
    time = 0
    time += waitTime
    for rhythmTime in rhythm:
        rhythmTime = list(map(int,rhythmTime.split(" ")))
        theHitBox :list = NoteList[i]
        if len(rhythmTime)==1:
            theHitBox[1] = time
            theHitBox[2] = 0
        else:
            theHitBox[1] = time
            theHitBox[2] = NoteTime(rhythmTime[1])
        time += NoteTime(rhythmTime[0])
        i += 1
    rhythm.close()
    outputFile = open(outputFileName,"w+",encoding="UTF-8")
    outputFile.write(str(NoteList))
    outputFile.close()
    return

def NoteTime(num):
    if num==4:
        return n4
    if num==2:
        return n2
    if num==1:
        return n1
    if num==8:
        return n8
    if num==16:
        return n16
    else:
        return 0
    
def main():
    global outputFileName
    global n4,n2,n1,n8,n16
    global waitTime
    hitBoxFileName = input("hitBoxFileName:")
    rhythmFileName = input("rhythmFileName:")
    outputFileName = input("outputFileName:")
    bpm = int(input("bpm:"))
    n4 = 60/bpm
    n2 = n4*2
    n1 = n4*4
    n8 = n4*0.5
    n16 = n4*0.25
    waitTime = float(input("waitTime:"))
    NoteList = addHitBox(hitBoxFileName)
    setRhythm(rhythmFileName,NoteList)
    # print(f"hitBoxSpeed is {640/(n4*4)}")
    print("NoteList created")

if __name__ == "__main__":
    main()