<p align="center">
  <img src="http://lenguajesfc.com/20191/images/ciencias.png" align="right" hspace="5">
  <h1>Fundamentos de Bases de Datos, 2019-1</h1>
</p>

Proyecto final: **Asociación de taxistas**
-----------------------------------

### Integrantes

* Monreal Gamboa Francisco Manuel | mmonrealgamboa@ciencias.unam.mx
* Páes Alcalá Alma Rosa | alma_rpa98@ciencias.unam.mx
* Vázquez Aguilar Lisandro | lisandro_xp@ciencias.unam.mx
* Vázquez Rizo Paola | paovats@ciencias.unam.mx

<hr>

## Instalación del proyecto
Para la instalación correcta se requiere tener el gestor de paquetes **pip** de python

1. Se tiene que instalar _Virtual Environment:_
```sh
pip install virtualenv
```

2. Se tiene que crear el virtualenv desde la carpeta **src**:
```sh
virtualenv taxis-env;            //se crea el ambiente virtual
source taxis-env/bin/activate;   //se activa el ambiente virtual
```

3. Se tienen que instalar los siguientes paquetes flask y psycopg2:
```sh
pip install flask psycopg2
```

4. En la carpeta **src** se crea el archivo **config.py** con el contenido:
```python
    db = {
        'host': 'localhost',
        'port': 5432,
        'user': 'TU_USUARIO',
        'password': 'TU_CONTRASEÑA',
        'name': 'asoc_taxis',
    }
```
**Nota:** es muy importante hacer todo desde la carpeta **src**

<hr>

## Ejecución del proyecto

desde la carpeta **src** levantamos el servidor:
```sh
source taxis-env/bin/activate   //se activa el ambiente virtual
python app.py                   //se levanta el servidor
```
