from flask import Flask, render_template
import psycopg2

con = psycopg2.connect(host='127.0.0.1', port=5432, user='postgres',
                          password='funkfunk91', dbname='asoc_taxis')
cur = con.cursor()
app = Flask(__name__)

@app.route("/")
def main():
    cur.execute("SELECT * FROM test")
    items = cur.fetchall()
    print items;
    context = {
        'message': 'hola',
        'items': [
            {'name': 'Lisandro', 'age': 19},
            {'name': 'Pablo', 'age': 20}
        ]
    }
    #cur.execute("CREATE TABLE test(id serial PRIMARY KEY, name varchar, email varchar)");

    con.commit();
    return render_template('index.html', **context)

if __name__ == '__main__':
    app.run()
