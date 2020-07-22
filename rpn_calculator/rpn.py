#!/usr/bin/env python3

import os
import sys

# Globals

OPERATORS = {'+', '-', '*', '/'}

# Functions

def usage(status=0):
    ''' Display usage message and exit with status. '''
    progname = os.path.basename(sys.argv[0])
    print(f'''Usage: {progname}

By default, {progname} will process expressions from standard input.''')

    sys.exit(status)

def error(message):
    ''' Display error message and exit with error. '''
    print(message, file=sys.stderr)
    sys.exit(1)

def evaluate_operation(operation, operand1, operand2):
    ''' Return the result of evaluating the operation with operand1 and
    operand2.

    >>> evaluate_operation('+', 4, 2)
    6

    >>> evaluate_operation('-', 4, 2)
    2

    >>> evaluate_operation('*', 4, 2)
    8

    >>> evaluate_operation('/', 4, 2)
    2.0
    '''
    pass

    if operation == '+':
        return(operand1 + operand2)
    elif operation == '-':
        return(operand1 - operand2)
    elif operation == '*':
        return(operand1 * operand2)
    elif operation == '/':
        return(operand1 / operand2)
    else:
        error('Invalid operand')

def evaluate_expression(expression):
    ''' Return the result of evaluating the RPN expression.

    >>> evaluate_expression('4 2 +')
    6.0

    >>> evaluate_expression('4 2 -')
    2.0

    >>> evaluate_expression('4 2 *')
    8.0

    >>> evaluate_expression('4 2 /')
    2.0

    >>> evaluate_expression('4 +')
    Traceback (most recent call last):
    ...
    SystemExit: 1

    >>> evaluate_expression('a b +')
    Traceback (most recent call last):
    ...
    SystemExit: 1
    '''
    pass

    # Creating the 'stack' where numbers will be stored and separating arguments in string
    stack = []
    expression = expression.split()

    # For item if number add to stack, if operator execute operation
    # Errors is not enough numbers to perform operation, not a vaid entry ex: alpha character

    for item in expression:
        if item in OPERATORS:
            if len(stack) > 1:
                stack[-2] = evaluate_operation(item, stack[-2], stack[-1])
                stack.pop(-1)
            else:
                error('Not enough numbers to perform operation')
        else:
            try:
                stack.append(float(item))
            except ValueError:
                error('Argument not a number or not an operator')
    
    # Checks if operations were performed in all numbers passed

    if len(stack) == 1:
        print(stack[0])
    else:
        error('Missing operators')
    
def main():
    ''' Parse command line arguments and process expressions from standard
    input. '''
    pass

    # If -h flag is dected display usage, else execute program

    for arg in sys.argv[1:]:
        if arg == '-h':
            usage(0)
    
    for line in sys.stdin:
        evaluate_expression(line)
    
# Main Execution

if __name__ == '__main__':
    main()

# vim: set sts=4 sw=4 ts=8 expandtab ft=python:
