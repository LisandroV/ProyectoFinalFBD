# -*- coding: utf-8 -*-
from flask import Flask, render_template, request, jsonify
import psycopg2, config
from datetime import datetime

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
    return render_template('index.html')


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
    r = request.form
    query = "INSERT INTO Vehiculo (rfc, id_aseguradora, numero_de_pasajeros, marca, modelo, año_vehiculo,llantas_refaccion,estandar_o_automatico,num_cilindros,capacidad_tanque,gasolina_o_hibrido,num_puertas,fecha_de_alta) "
    query += "VALUES ('{}','{}','{}','{}','{}','{}',{},'{}','{}','{}','{}','{}','{}');".format(r["rfc"],r["seguro"],r["num_pasajeros"],r["marca"],r["modelo"],r["anio"],r["refaccion"],r["transmision"],r["cilindros"],r["tanque"],r["hibrido"],r["num_puertas"], datetime.now().strftime('%Y/%m/%d %H:%M:%S'))
    try:
        cur.execute(query)
    except psycopg2.Error, e:
        return error_500(e)
    finally:
        con.commit()

    resp = jsonify({'message': '¡Vehículo registrado!'})
    resp.status_code = 202
    return resp


@app.route("/registro/conductor", methods=['POST'])
def registra_conductor_post():
    r = request.form
    query = "SELECT inserta_chofer('"
    query += r["num_licencia"]+"','"
    query += r["nombre"]+"','"
    query += r["paterno"]+"','"
    query += r["materno"]+"','"
    query += r["cel"]+"','"
    query += r["email"]+"','"
    query += datetime.now().strftime('%Y/%m/%d %H:%M:%S')+"','"
    query += "/static/img/users/chofer/"+r["num_licencia"]+".jpg','"
    query += r["rfc"]+"','"
    query += r["estado"]+"','"
    query += r["delegacion"]+"','"
    query += r["calle"]+"','"
    query += r["numero"]+"','"
    query += r["cp"]+"');"

    try:
        cur.execute(query)
    except psycopg2.Error, e:
        return error_500(e)
    finally:
        con.commit()
    resp = jsonify({'message': '¡Conductor registrado!'})
    resp.status_code = 202
    return resp

@app.route("/registro/users", methods=['POST'])
def registra_users_post():
    r = request.form
    query = "SELECT inserta_cliente('"
    query += r["nombre"]+"','"
    query += r["ap_paterno"]+"','"
    query += r["ap_materno"]+"','"
    query += r["tel_casa"]+"','"
    query += r["tel_cel"]+"','"
    query += r["correo"]+"','0','"
    query += r["entrada"]+"','"
    query += r["salida"]+"','/static/img/user/cliente/"
    query += r["correo"]+".jpg','"

    if r["type_user_name"]=='Alumno':
        query += r["type_user"]+"','','','"
    elif r["type_user_name"]=='Academico':
        query += "','"+r["type_user"]+"','','"
    else:
        query += "','','"+r["type_user"]+"','"

    query += r["estado"]+"','"
    query += r["delegacion"]+"','"
    query += r["calle"]+"','"
    query += r["numero"]+"','"
    query += r["cp"]+"');"

    try:
        cur.execute(query)
    except psycopg2.Error, e:
        return error_500(e)
    finally:
        con.commit()

    resp = jsonify({'message': "¡Cliente registrado!"})
    resp.status_code = 202
    return resp

def error_500(e):
    print e.pgerror
    resp = jsonify({'error': e.pgerror})
    resp.status_code = 500
    return resp

if __name__ == '__main__':
    app.run()
