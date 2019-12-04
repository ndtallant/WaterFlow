'''Flask app.'''
import json
import datetime as dt
from flask import Flask, render_template, request
from credentials import zookeeperHosts, zookeeperRoot, kafkaHost

import math #For fun 

app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def index():
    '''Home page of the webapp.'''

    # Form information
    state = request.form.get('state') or 'al'
    period = request.form.get('periodGroup') or 'week'
    with open("static/states.json", "r") as f:
        states = json.loads(f.read())
    
    # Actual data
    labels, p_data, w_data = get_data(state, period)
    return render_template('index.html',
                           user_state=state,
                           period=period,
                           data_labels=labels,
                           p_data=p_data,
                           w_data=w_data,
                           states=states)

def get_data(state, period):
    '''Looks up relevant data from HBase.'''
    dates = get_dates(period)
    p_data = list(range(len(dates)))
    w_data = [math.sqrt(i) for i in range(len(dates))]
    return dates, p_data, w_data

def get_dates(period):
    today = dt.date.today()
    dates = {'week': 6, 'month': 27, 'year': 364}
    return [str(today - dt.timedelta(i)) for i in range(dates[period], -1, -1)]


@app.route('/about')
def about():
    '''Simply renders the about page.'''
    return render_template('about.html')

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=3042, debug=True)
