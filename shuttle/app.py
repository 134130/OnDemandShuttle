from flask import Flask, render_template, request
import json, pymysql, sys, mysqlpassword
app = Flask(__name__)

class Database():
    def __init__(self):
        self.db = pymysql.connect(host='localhost',
                                  user='root',
                                  password=mysqlpassword.MY_PASSWORD,
                                  db='shuttle',
                                  charset='utf8')
        self.cursor = self.db.cursor(pymysql.cursors.DictCursor)

    def execute(self, query, args={}):
        self.cursor.execute(query, args)

    def executeOne(self, query, args={}):
        self.cursor.execute(query, args)
        row = self.cursor.fetchone()
        return row

    def executeAll(self, query, args={}):
        self.cursor.execute(query, args)
        row = self.cursor.fetchall()
        return row

    def commit(self):
        self.db.commit()

@app.route('/')
def index():
    return "index!";

@app.route('/request')
def _request():
    try:
        departure = request.args.get('departure')
        arrival = request.args.get('arrival')
        date = request.args.get('date')
        hour = request.args.get('hour')
        minute = request.args.get('minute')

        if not (departure and arrival and date and hour and minute):
            return json.dumps({'success':False}), 400, {'ContentType':'application/json'}

    except Exception as e:
        return json.dumps({'success':False}), 400, {'ContentType':'application/json'}

    db = Database()
    db.execute('INSERT INTO request (departure, arrival, date, hour, minute) VALUES (%s, %s, %s, %s, %s)', (departure, arrival, date, hour, minute))
    db.commit()

    return json.dumps({'success': True}), 200, {'ContentType':'application/json'}

@app.route('/demand')
def _demand():
    try:
        departure = request.args.get('departure')
        arrival = request.args.get('arrival')
        date = request.args.get('date')

        if not (departure and arrival and date):
            return json.dumps({'success':False}), 400, {'ContentType':'application/json'}

    except:
        return json.dumps({'success':False}), 400, {'ContentType':'application/json'}

    db = Database()
    result = db.executeAll('SELECT hour, minute, COUNT(*) AS demand FROM request WHERE departure=%s AND arrival=%s AND date=%s GROUP BY hour, minute', (departure, arrival, date))

    return json.dumps(result), 200, {'ContentType':'application/json'}
        

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5780, debug=True)