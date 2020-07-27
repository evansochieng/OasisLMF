#!/usr/bin/env python

from .fm import manager, logger

import argparse
import logging

parser = argparse.ArgumentParser()
parser.add_argument('-a', '--allocation-rule', help='back-allocation rule', default=0, type=int)
parser.add_argument('-p', '--static-path', help='path to the folder containing the static files', default='input')
parser.add_argument('-i', '--files-in', help='names of the input file_path', nargs='+')
parser.add_argument('--queue-in-size', help='maximum size of the queue in', default=5, type=int)
parser.add_argument('-o', '--files-out', help='names of the output file_path', nargs='+')
parser.add_argument('--queue-out-size', help='maximum size of the queue in', default=5, type=int)
parser.add_argument('--run-mode', help='rum mode (synchronous :0, threaded: 1, ray: 2)', default=1, type=int)
parser.add_argument('--ray-address', help='Address of the ray server', default=None)
parser.add_argument('-v', '--logging-level', help='logging level (debug:10, info:20, warning:30, error:40, critical:50)',
                    default=30, type=int)


def main():
    kwargs = vars(parser.parse_args())

    # add handler to fm logger
    ch = logging.StreamHandler()
    formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    ch.setFormatter(formatter)
    logger.addHandler(ch)
    logging_level = kwargs.pop('logging_level')
    logger.setLevel(logging_level)

    manager.run(**kwargs)


if __name__ == '__main__':
    main()
