'''
Collects the most recent water discharge data and stores it in
HBase to be combined with Serve Layer data.

This script takes about a minute to run.
'''
import requests

def parse_station(station):
    try:
        return max(float(station['values'][0]['value'][0]['value']), 0)
    except:
        return 0 

def get_state(state='al'):
    resp = requests.get(
        'https://waterservices.usgs.gov/nwis/dv/?format=json&'+\
        'stateCd={}&parameterCd=00060&siteStatus=active'.format(state)
    )
    stations = resp.json()['value']['timeSeries']
    return sum(map(parse_station, stations)), len(stations)


if __name__ == '__main__':
    with open('../01_batch/water/states.txt', 'r') as f:
        states = f.read().split('\n')[:-1]

    for state in states:
        print(state, get_state(state))

    # HBase Table where key is simply state, it can then be combined
    # with any of the serve tables, as these are just counts!

    #TODO:
    # Connect to HBase table
    # Remove existing HBase data.
    # Add new data to table.
