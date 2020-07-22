#!/usr/bin/env python3

import os
import sys

# Functions

def usage(status=0):
    ''' Display usage message and exit with status. '''
    progname = os.path.basename(sys.argv[0])
    print(f'''Usage: {progname} [flags]

    -c      Prefix lines by the number of occurences
    -d      Only print duplicate lines
    -i      Ignore differences in case when comparing, prints out full line in lowercase
    -u      Only print unique lines

By default, {progname} prints one of each type of line.''')
    sys.exit(status)

def count_frequencies(stream=sys.stdin, ignore_case=False):
    ''' Count the line frequencies from the data in the specified stream while
    ignoring case if specified. '''
    pass

    # Dictionary where lines in input will be stored as keys and frequency of occurence as value

    counts = {}

    # For each line, check if it is already in dictionary, if it is increase frequency it occurs, if not add to dictionary with frequency value of 1

    for line in stream:
        line = line.rstrip()
        if ignore_case:
            line = line.lower()
        if line in counts:
            counts[line] += 1
        else:
            counts[line] = 1

    return counts


def print_lines(frequencies, occurrences=False, duplicates=False, unique_only=False):
    ''' Display line information based on specified parameters:

    - occurrences:  if True, then prefix lines with number of occurrences
    - duplicates:   if True, then only print duplicate lines
    - unique_only:  if True, then only print unique lines
    '''
    pass

    # For all the keys output it depending on coniditons specified by user

    for key in frequencies:
        frequency = frequencies[key]
        if occurrences and duplicates:
            if frequency > 1:
                print(f'{frequency:>7} {key}')
        elif occurrences and unique_only:
            if frequency == 1:
                print(f'{frequency:>7} {key}')
        elif occurrences:
            print(f'{frequency:>7} {key}')
        elif duplicates and frequency > 1:
            print(f'{key}')
        elif unique_only and frequency == 1:
            print(f'{key}')
        elif not(occurrences or duplicates or unique_only):
            print(f'{key}')

        


def main():
    ''' Process command line arguments, count frequencies from standard input,
    and then print lines. '''
    pass

    # Defaults values to options set by user

    occurrences = False 
    duplicates = False 
    unique_only = False
    ignore_case = False

    # Getting arguments from user and setting their values as true if aplicable

    arguments = sys.argv[1:]

    while arguments and arguments[0].startswith('-'):
        argument = arguments.pop(0)

        if(argument == '-h'):
            usage(0)
        elif(argument == '-u'):
            unique_only = True
        elif(argument == '-d'):
            duplicates = True
        elif(argument == '-c'):
            occurrences = True
        elif(argument == '-i'):
            ignore_case = True

    # Find frequency of each line in stdin then print lines acording to user parameters

    frequencies = count_frequencies(sys.stdin,ignore_case)

    print_lines(frequencies, occurrences, duplicates, unique_only)


# Main Execution

if __name__ == '__main__':
    main()

# vim: set sts=4 sw=4 ts=8 expandtab ft=python: