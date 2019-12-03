'''Flask app.'''
from flask import Flask, render_template, url_for, session, redirect

app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def index():
    """Home page of the webapp."""
    return render_template('index.html')

@app.route('/about')
def about():
    """Simply renders the about page."""
    return render_template('about.html')

if __name__ == '__main__':
    app.run(host="0.0.0.0", debug=True)
