'''
Collects the most recent water discharge data and stores it in
HBase to be combined with Serve Layer data.
'''
import requests
state = 'al'
resp = requests.get(
    'https://waterservices.usgs.gov/nwis/dv/?format=json&stateCd={}&parameterCd=00060&siteStatus=active'.format(state)
)

