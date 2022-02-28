import numpy as np
from sys import argv

def main():

    if not len(argv) == 6:
        exit("Usage: python3 read_record file_name NLAT NLON NREC IREC")
    fname = argv[1]
    nlat = int(argv[2])
    nlon = int(argv[3])
    nrec = int(argv[4])
    irec = int(argv[5])
    data = np.fromfile(fname).reshape((nrec, nlon, nlat)).transpose((0,2,1))
    print(data[irec,:,:])

if __name__ == '__main__':
    exit(main())
