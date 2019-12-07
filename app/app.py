'''Flask app.'''
import json
import calendar
import happybase
import datetime as dt
from collections import OrderedDict
from dateutil.relativedelta import relativedelta
from flask import Flask, render_template, request
from thriftpy2.transport import TTransportException
from credentials import zookeeperHost, zookeeperRoot, kafkaHost

app = Flask(__name__)

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
        print('Broken pipe!')
        return render_template('error.html')
    except TTransportException:
        print('Thrift server may be down!')
        return render_template('error.html')

def get_data(state, period):
    '''Looks up relevant data from HBase.'''
    table_name, labels = get_labels(period)
    hbase = happybase.Connection(
        host=zookeeperHost,
        port=9090,
        table_prefix='ndtallant_serve'
    )
    table = hbase.table(table_name)
    data = table.rows(['{}-{}'.format(state, label) for label in labels])
    hbase.close()
    p_data, w_data = parse_data(data)
    return labels, p_data, w_data

def parse_data(data):
    '''Given hbase data, returns averages.'''
    p_data, w_data = list(), list()
    for date, d in data:
        p_data.append(float(d[b'water:precip']) / float(d[b'water:n_precip']))
        w_data.append(float(d[b'water:discharge']) / float(d[b'water:n_discharge']))
    return p_data, w_data 

def get_labels(period):
    today = dt.date.today()

    if period == 'week': 
        return 'daily', [str(today - dt.timedelta(i)) for i in range(6, -1, -1)]

    if period == 'month': 
        this_week = today.isocalendar()[1]
        return 'weekly', ['{}-{}'.format(this_week - i, today.year) for i in range(5, -1, -1)]

    # Past year or three years
    m = 11 if period == 'year' else 35
    return 'monthly', [year_helper(today, i) for i in range(m, -1, -1)]

def year_helper(today, i):
    older_date = today - relativedelta(months=i)
    return '{}-{}'.format(calendar.month_abbr[older_date.month], older_date.year) 

@app.route('/about')
def about():
    '''Simply renders the about page.'''
    return render_template('about.html')

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=3042, debug=True)
