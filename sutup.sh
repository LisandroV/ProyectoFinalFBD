sudo pip install pipenv;
cd src;
pipenv install flask flask-sqlalchemy psycopg2 flask-migrate flask-script marshmallow flask-bcrypt pyjwt;
export FLASK_ENV=development;
export DATABASE_URL=postgres://postres:@localhost:port/asoc_taxis;
