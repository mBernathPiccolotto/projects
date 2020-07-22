#!/usr/bin/env python3

import concurrent.futures
import hashlib
import os
import string
import sys

# Constants

ALPHABET = string.ascii_lowercase + string.digits

# Functions

def usage(exit_code=0):
    progname = os.path.basename(sys.argv[0])
    print(f'''Usage: {progname} [-a ALPHABET -c CORES -l LENGTH -p PATH -s HASHES]
    -a ALPHABET Alphabet to use in permutations
    -c CORES    CPU Cores to use
    -l LENGTH   Length of permutations
    -p PREFIX   Prefix for all permutations
    -s HASHES   Path of hashes file''')
    sys.exit(exit_code)

def md5sum(s):
    ''' Compute md5 digest for given string. '''
    # Use the hashlib library to produce the md5 hex digest of the given
    # string.
    m = hashlib.md5(s.encode())
    return m.hexdigest()

def permutations(length, alphabet=ALPHABET):
    ''' Recursively yield all permutations of the given length using the
    provided alphabet. '''
    # Use yield to create a generator function that recursively produces
    # all the permutations of the given length using the provided alphabet.

    if length == 0:
        yield ''
    else:
        for letter in alphabet:
            for sequence in permutations(length - 1, alphabet):
                yield letter + sequence

def flatten(sequence):
    ''' Flatten sequence of iterators. '''
    # Iterate through sequence and yield from each iterator in sequence.

    for it in sequence:
        yield from it

def crack(hashes, length, alphabet=ALPHABET, prefix=''):
    ''' Return all password permutations of specified length that are in hashes
    by sequentially trying all permutations. '''
    # Return list comprehension that iterates over a sequence of
    # candidate permutations and checks if the md5sum of each candidate is in
    # hashes.

    return [prefix + result for result in permutations(length,alphabet) if md5sum(prefix + result) in hashes]

def cracker(arguments):
    ''' Call the crack function with the specified arguments '''
    return crack(*arguments)

def generate(hashes, length, alphabet=ALPHABET, prefix='', cores=1):
    ''' Return all password permutations of specified length that are in hashes
    by concurrently subsets of permutations concurrently.
    '''
    # Create generator expression with arguments to pass to cracker and
    # then use ProcessPoolExecutor to apply cracker to all items in expression.

    # Generator expression representing a sequence of arguments to pass
    # to `cracker` (hashes, length, alphabet remain constant, but prefix
    # should change for each argument tuple).
    arguments = ((hashes,length - 1,alphabet,prefix + letter) for letter in alphabet)

    # Create a ProcessPoolExecutor and then apply cracker to the
    # arguments

    with concurrent.futures.ProcessPoolExecutor(cores) as executor:
        results = executor.map(cracker,arguments)

    return flatten(results)

def main():
    arguments   = sys.argv[1:]
    alphabet    = ALPHABET
    cores       = 1
    hashes_path = 'hashes.txt'
    length      = 1
    prefix      = ''

    # Parse command line arguments

    if len(arguments) == 1 and arguments[0] == '-h':
        usage(0)

    while len(arguments) > 1 and arguments[0].startswith('-'):
        argument = arguments.pop(0)

        if(argument == '-a'):
            alphabet   = list(arguments.pop(0))
        elif(argument == '-c'):
            cores = int(arguments.pop(0))
        elif(argument == '-l'):
            length = int(arguments.pop(0))
        elif(argument == '-p'):
            prefix  = arguments.pop(0)
        elif(argument == '-s'):
            hashes_path  = arguments.pop(0)
        else:
            usage(1)

    if length < 1:
        usage(1)

    # Load hashes set

    hashes = set(open(hashes_path).read().split())

    # Execute crack or generate function

    if cores == 1:
        passwords = crack(hashes, length, alphabet, prefix)
    else:
        passwords = generate(hashes, length, alphabet, prefix, cores)

    # Print all found passwords

    for entry in passwords:
        print(entry)

# Main Execution

if __name__ == '__main__':
    main()

# vim: set sts=4 sw=4 ts=8 expandtab ft=python:
