from flask import Blueprint

contacts_bp = Blueprint('contacts', __name__)

from .routes import *
