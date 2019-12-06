'''Flask app.'''
import json
import calendar
import happybase
import datetime as dt
from collections import OrderedDict
from flask import Flask, render_template, request
from credentials import zookeeperHost, zookeeperRoot, kafkaHost
from thriftpy2.transport import TTransportException

app = Flask(__name__)
hbase = happybase.Connection(
    host=zookeeperHost,
    port=9090,
    table_prefix='ndtallant_serve'
)

@app.route('/', methods=['GET', 'POST'])
def index():
    '''Home page of the webapp.'''

    try:
        # Form information
        state = request.form.get('state') or 'al'
        period = request.form.get('periodGroup') or 'week'
        with open("static/states.json", "r") as f:
            states = json.loads(f.read(), object_pairs_hook=OrderedDict)
        
        # Actual data
        labels, p_data, w_data = get_data(state, period)
        return render_template('index.html',
                               user_state=state,
                               period=period,
                               data_labels=labels,
                               p_data=p_data,
                               w_data=w_data,
                               states=states)
    except BrokenPipeError:
        return render_template('error.html')
    except TTransportException:
        return render_template('error.html')

def get_data(state, period):
    '''Looks up relevant data from HBase.'''
    table_name, dates = get_dates(period)
    table = hbase.table(table_name)
    data = table.rows(['{}-{}'.format(state, date) for date in dates])
    p_data, w_data = parse_data(data)
    return dates, p_data, w_data

def parse_data(data):
    '''Given hbase data, returns averages.'''
    p_data, w_data = list(), list()
    for date, d in data:
        p_data.append(float(d[b'water:precip']) / float(d[b'water:n_precip']))
        w_data.append(float(d[b'water:discharge']) / float(d[b'water:n_discharge']))
    return p_data, w_data 

def get_dates(period):
    today = dt.date.today()

    # Past week
    if period == 'week': 
        return 'daily', [str(today - dt.timedelta(i)) for i in range(6, -1, -1)]

    if period == 'month': 
        this_week = today.isocalendar()[1]
        return 'weekly', ['{}-{}'.format(this_week - i, today.year) for i in range(5, -1, -1)]

    # Past year
    if period == 'year':
        return 'monthly', [date_helper(today.month, today.year, i)\
                           for i in range(11, -1, -1)] 

def date_helper(this_month, this_year, i):
    rv = this_month - i
    if rv < 1:
        return str(rv + 12) + str(this_year - 1)
    return '{}-{}'.format(calendar.month_abbr[rv], this_year)

@app.route('/about')
def about():
    '''Simply renders the about page.'''
    return render_template('about.html')

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=3042, debug=True)
