'''
Collects the most recent water discharge data and stores it in
HBase to be combined with Serve Layer data.

This script takes about a minute to run.
'''
import logging
import requests
import happybase
from credentials import zookeeperHost
from apscheduler.schedulers.blocking import BlockingScheduler

sched = BlockingScheduler()
logging.basicConfig(filename='speed.log',
                    filemode='w',
                    level='INFO',
                    format='%(asctime)s - %(message)s')

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
    return {'water:discharge': str(sum(map(parse_station, stations))),
            'water:n_discharge': str(len(stations))}

@sched.scheduled_job('interval', minutes=2)
def create_speed_table():
    '''Refreshes the speed table every hour.'''
    logging.info('Starting speed layer refresh.')

    with open('../01_batch/water/states.txt', 'r') as f:
        states = f.read().split('\n')[:-1]

    try:
        hbase = happybase.Connection(
            host=zookeeperHost,
            port=9090,
            table_prefix='ndtallant'
        )
        # Connect to HBase, disable, drop, and recreate table.
        try:
            hbase.delete_table('speed', disable=True)
            hbase.create_table('speed', families={'water': dict()})
            table = hbase.table('speed')
            logging.info('Speed table refreshed.')
            batch = table.batch()
            for state in states:
                batch.put(state, get_state(state))
                logging.info('Speed data created for {}'.format(state))
            batch.send()
            logging.info('All speed data loaded.')
        except Exception as e:
            logging.info('Error on speed insert', e)
        finally:
            hbase.close()
            logging.info('Closed Hbase Connection')
    except:
        logging.info('Cannot connect to HBase')

if __name__ == '__main__':
    sched.configure()
    logging.info('Started speed application.')
    create_speed_table()
    sched.start()
