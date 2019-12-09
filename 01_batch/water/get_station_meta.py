'''
This file collects usgs stations. The lat and lon
will be used to link to weather stations.
'''
import requests

def collect(state):
    # Doing this with "params" would not work :/, this does, but it is ugly.
    res = requests.get(
        ('https://waterdata.usgs.gov/nwis/dvstat?referred_module=qw&state_cd='+
         state+'&group_key=county_cd&format=sitefile_output&sitefile_output_format'+
         '=rdb&column_name=agency_cd&column_name=site_no&column_name=station_nm'+
         '&column_name=site_tp_cd&column_name=lat_va&column_name=long_va'+
         '&column_name=dec_lat_va&column_name=dec_long_va&'+
         'list_of_search_criteria=state_cd%2Crealtime_parameter_selection'))
    data = list(filter(lambda l: not l.startswith('#'), res.text.split('\n')))
    data.pop(1) # Remove foramt row.
    return '\n'.join(data)

if __name__ == '__main__':
    with open('states.txt', 'r') as f:
        states = f.readlines()
    for state in states: 
        state = state[:2]
        print(state)
        data = collect(state) 
        with open('station_meta/'+state+'.tsv', 'w') as f:
            f.write(data)
