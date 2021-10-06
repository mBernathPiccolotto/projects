#!/usr/bin/env python3

# Includes
import os
import PyPDF2 
import xlsxwriter
from os import system


class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

clear = lambda: system('clear')

totalSession = 0
totalProfessor = 0

publicationsDict = {"Journal of Finance" : 0,
"Journal of Financial Economics" : 0,
"Review of Financial Studies" : 0,
"American Economic Review" : 0,
"Econometrica" : 0,
"Journal of Political Economy" : 0,
"Quarterly Journal of Economics" : 0,
"Review of Economic Studies" : 0,
"American Economic Journal: Economic Policy" : 0,
"American Economic Journal: Macroeconomics" : 0,
"American Economic Journal: Applies" : 0,
"Journal of Monetary Economics" : 0,
"Review of Economics and Statistics" : 0,
"International Economic Review" : 0,
"Journal of Econometrics" : 0,
"Journal of International Economics" : 0,
"Journal of Public Economics" : 0,
"Journal of the European Economic Association" : 0,
"RAND Journal of Economics" : 0,
"Bell Journal of Economics and Management Science" : 0,
"Economic Journal" : 0,
"Journal of Economic Theory" : 0}

publicationsList = ["Journal of Finance",
"Journal of Financial Economics",
"Review of Financial Studies",
"American Economic Review",
"Econometrica",
"Journal of Political Economy",
"Quarterly Journal of Economics",
"Review of Economic Studies",
"American Economic Journal",
"Journal of Monetary Economics",
"Review of Economics and Statistics",
"International Economic Review",
"Journal of Econometrics",
"Journal of International Economics",
"Journal of Public Economics",
"Journal of the European Economic Association",
"RAND Journal of Economics",
"Bell Journal of Economics and Management Science",
"Economic Journal",
"Journal of Economic Theory",]

class professor:
  def __init__(self, university, name, publications, cv):
    self.university = university
    self.name = name
    self.publications = publications
    self.cv = cv


def searchPublications(theProfessor):

    global totalSession

    for journal in publicationsList:
        if "American Economic Journal" == journal:
            if journal in theProfessor.cv:
                fragments = theProfessor.cv.split("American Economic Journal")
                fragmentsSize = len(fragments) - 1
                for i, fragment in enumerate(fragments, start = 0):
                    if i == fragmentsSize:
                        continue
                    clear()
                    print(bcolors.OKBLUE + theProfessor.name + "    " + theProfessor.university + bcolors.FAIL)
                    print("Total matches in session:" + str(totalSession))
                    print("Total professors:" + str(totalProfessor) + bcolors.ENDC)


                    try:
                        print(fragment[-600:] + bcolors.WARNING + journal + bcolors.ENDC, end = "")
                    except IndexError:
                        print(fragment + bcolors.WARNING + journal+ bcolors.ENDC, end = "")

                    try:
                        print(fragments[i + 1][0:600])
                    except IndexError:
                        try:
                            print(fragments[i + 1])
                        except IndexError:
                            print("")

                    inputOK = False

                    while not inputOK:

                        publicationDoesCount = input()

                        if publicationDoesCount == "e":
                            theProfessor.publications["American Economic Journal: Economic Policy"] += 1
                            inputOK = True
                        elif publicationDoesCount == "m":
                            theProfessor.publications["American Economic Journal: Macroeconomics"] += 1
                            inputOK = True
                        elif publicationDoesCount == "a":
                            theProfessor.publications["American Economic Journal: Applies"] += 1
                            inputOK = True
                        elif publicationDoesCount == "\'":
                            inputOK = True

                    totalSession +=  1
        else:    
            if journal in theProfessor.cv:
                fragments = theProfessor.cv.split(journal)
                fragmentsSize = len(fragments) - 1
                for i, fragment in enumerate(fragments, start = 0):
                    if i == fragmentsSize:
                        continue
                    clear()
                    print(bcolors.OKBLUE + theProfessor.name + "    " + theProfessor.university + bcolors.FAIL)
                    print("Total matches in session:" + str(totalSession))
                    print("Total professors:" + str(totalProfessor) + bcolors.ENDC)

                    try:
                        print(fragment[-600:] + bcolors.WARNING + journal + bcolors.ENDC, end = "")
                    except IndexError:
                        print(fragment + bcolors.WARNING + journal + bcolors.ENDC, end = "")

                    try:
                        print(fragments[i + 1][0:600])
                    except IndexError:
                        try:
                            print(fragments[i + 1])
                        except IndexError:
                            print("")


                    inputOK = False

                    while not inputOK:

                        publicationDoesCount = input()

                        if publicationDoesCount == ";":
                            theProfessor.publications[journal] += 1
                            inputOK = True
                        elif publicationDoesCount == "\'":
                            inputOK = True
                    
                    totalSession += 1


def addToCsv(theProfessor):

    if os.path.isfile(theProfessor.university + ".csv"):
        f = open(theProfessor.university + ".csv", "a")
    else:
        f = open(theProfessor.university + ".csv", "w+")
        f.write("name" + ",")
        for journal in theProfessor.publications:
            if journal == "RAND Journal of Economics":
                f.write(journal + " OR The Bell Journal of Economics and Management Science" + ",")
            elif journal == "Bell Journal of Economics and Management Science":
                continue
            else:
                f.write(journal + ",")
        f.write("\n")

    f.write(theProfessor.name + ",")

    for journal in theProfessor.publications:
        if journal == "RAND Journal of Economics":
            f.write(str(theProfessor.publications[journal] + theProfessor.publications["Bell Journal of Economics and Management Science"]) + ",")
        elif journal == "Bell Journal of Economics and Management Science":
            continue
        else:
            f.write(str(theProfessor.publications[journal]) + ",")

    f.write("\n")

    f.close()


def main():

    mainDirectoryName = "unis"

    mainDirectory = os.fsencode(mainDirectoryName)

    for university in os.listdir(mainDirectory):

        universityName = os.fsdecode(university)
        if universityName == ".DS_Store":
            continue

        universityPath = os.fsencode(mainDirectoryName + "/" + universityName)

        for faculty in os.listdir(universityPath):
            fileName = os.fsdecode(faculty)
            if fileName == ".DS_Store":
                continue

            fileContents = ""

            # File is in pdf format
            if fileName.endswith(".pdf"):

                # creating a pdf file object 
                pdfFileObj = open(mainDirectoryName + "/" + universityName + "/"  + fileName, 'rb')
                # creating a pdf reader object 
                pdfReader = PyPDF2.PdfFileReader(pdfFileObj)
                # Finding number of pages
                nPages = pdfReader.numPages

                for pageNumber in range(nPages):
                    pageObj = pdfReader.getPage(pageNumber)
                    fileContents += pageObj.extractText()

            # File is in .txt format
            elif fileName.endswith(".txt"):
                f = open(mainDirectoryName + "/" + universityName + "/"  + fileName, "r", encoding="ISO-8859-1")
                fileContents += f.read()

            fileName = fileName[:-4]
            professorName = ""
            for name in fileName.split("_"):
                professorName = professorName + name + " "

            theProfessor = professor(universityName, str(professorName), publicationsDict.copy(), " ".join(fileContents.split()))

            searchPublications(theProfessor)
            addToCsv(theProfessor)

            global totalProfessor
            totalProfessor += 1
            
# Main execution

if __name__ == '__main__':
    main()
