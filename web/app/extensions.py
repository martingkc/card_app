
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import Column, Integer, DateTime

from flask_httpauth import HTTPBasicAuth, HTTPTokenAuth
import os
import hashlib


db = SQLAlchemy()
basic_auth = HTTPBasicAuth()
token_auth = HTTPTokenAuth(scheme='Bearer')
