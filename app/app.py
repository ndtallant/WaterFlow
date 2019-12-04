'''Flask app.'''
from flask import Flask, render_template, url_for, session, redirect, request
import datetime as dt

app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def index():
    '''Home page of the webapp.'''
    state = request.form.get('state') or 'al'
    print(state)
    labels, p_data, w_data = get_data(state, period='FIX ME')
    return render_template('index.html',
                           data_labels=labels,
                           p_data=p_data,
                           w_data=w_data)

def get_data(state, period):
    '''Looks up relevant data from HBase.'''
    today = dt.date.today()
    # Past Week
    labels = [str(dt.date.today() - dt.timedelta(i)) for i in range(7)]
    p_data = list(range(7))
    w_data = [i//2 for i in range(7)]
    return labels, p_data, w_data

@app.route('/about')
def about():
    '''Simply renders the about page.'''
    return render_template('about.html')

if __name__ == '__main__':
    app.run(host="0.0.0.0", debug=True)
