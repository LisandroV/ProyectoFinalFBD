#!/bin/bash
#crea o resetea (elimina y crea) la base de datos
psql -U "postgres" -f DDL.sql
