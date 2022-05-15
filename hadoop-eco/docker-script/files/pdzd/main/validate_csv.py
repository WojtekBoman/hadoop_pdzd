import csv
import sys

def check_data_validity(file):
    with open(file, newline = "") as csvfile:
        try:
            dialect = csv.Sniffer().sniff(csvfile.read(1024), delimiters = ",")
            print(0)
        except:
            print(1)

check_data_validity(sys.argv[1])
