from flask import Flask, render_template, request, jsonify
import psycopg2
import config

con = psycopg2.connect(
    host=config.db['host'],
    port=config.db['port'],
    user=config.db['user'],
    password=config.db['password'],
    dbname=config.db['name']);
cur = con.cursor()
app = Flask(__name__)

@app.route("/", methods=['GET'])
def main():
#    cur.execute("SELECT * FROM test")
#    items = cur.fetchall()
#    print items;
    context = {
        'server': 'localhost:5000',
        'message': 'hola',
        'items': [
            {'name': 'Lisandro', 'age': 19},
            {'name': 'Pablo', 'age': 20}
        ]
    }
    #cur.execute("CREATE TABLE test(id serial PRIMARY KEY, name varchar, email varchar)");

    con.commit();
    return render_template('index.html', **context)


@app.route("/registro/auto", methods=['GET'])
def registra_auto_get():
    return render_template('regAuto.html')

@app.route("/registro/conductor", methods=['GET'])
def registra_conductor_get():
    return render_template('regConductor.html')

@app.route("/registro/usuario", methods=['GET'])
def registra_usuario_get():
    return render_template('regUsuario.html')

@app.route("/registro/usuario/alumno", methods=['GET'])
def registra_alumno_get():
    context = {
        'type_user':{
            'name': 'Alumno',
            'distinct': 'Facultad',
            'text': 'Nombre de la Facultad',
            'image': 'estudiante.png',
        },
    }
    return render_template('regAllUsers.html', **context)

@app.route("/registro/usuario/academico", methods=['GET'])
def registra_academico_get():
    context = {
        'type_user':{
            'name': 'Academico',
            'distinct': 'Instituto',
            'text': 'Nombre del Instituto',
            'image': 'aula.png',
        },
    }
    return render_template('regAllUsers.html', **context)

@app.route("/registro/usuario/trabajador", methods=['GET'])
def registra_trabajador_get():
    context = {
        'type_user':{
            'name': 'Trabajador',
            'distinct': 'Unidad',
            'text': 'Nombre de la Unidad',
            'image': 'redes.png',
        },
    }
    return render_template('regAllUsers.html', **context)


@app.route("/registro/auto", methods=['POST'])
def registra_auto_post():
    print request.form["marca"]
    message = {
        'status': 202,
        'message': 'Ha sido registrado',
    }
    resp = jsonify(message)
    resp.status_code = 202
    return resp

if __name__ == '__main__':
    app.run()
