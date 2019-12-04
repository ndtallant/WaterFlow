'''Flask app.'''
from flask import Flask, render_template, url_for, session, redirect, request

app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def index():
    """Home page of the webapp."""
    state = request.form.get('state') or 'al'
    print(state)
    table = True if request.form.get('table') == 'on' else False
    print(table)
    return render_template('index.html', table=table)

@app.route('/about')
def about():
    """Simply renders the about page."""
    return render_template('about.html')

if __name__ == '__main__':
    app.run(host="0.0.0.0", debug=True)
